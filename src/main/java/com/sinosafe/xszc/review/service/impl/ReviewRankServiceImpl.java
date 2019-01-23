package com.sinosafe.xszc.review.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REVIEW_RANK;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REVIEW_RANK_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.StringUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.review.service.ReviewRankHistoryService;
import com.sinosafe.xszc.review.service.ReviewRankService;
import com.sinosafe.xszc.review.vo.ReviewRank;
import com.sinosafe.xszc.review.vo.ReviewRankHistory;
import com.sinosafe.xszc.util.PageDto;

public class ReviewRankServiceImpl implements ReviewRankService {

	private static final Log log = LogFactory.getLog(ReviewRankServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Autowired
	@Qualifier(value = "ReviewRankHistoryService")
	private ReviewRankHistoryService reviewRankHistoryService;
	
	@Autowired
	@Qualifier(value = "noticeService")
	private NoticeService noticeService;
	
	/**
	 * 批量确认职级
	 * @throws Exception 
	 */
	public boolean batchConfirmRank(String rankIds){
		try{
			Date date = new Date();
			String time = "";
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			time = sdf.format(date);
			Timestamp ts = Timestamp.valueOf(time);
			IUserDetails curUserInfo = CurrentUser.getUser();
			String userCode = curUserInfo.getUsername();
			String[] rankId = rankIds.split(",");
			for (int i = 0; i < rankId.length; i++) {
				ReviewRank reviewRank = new ReviewRank();
				reviewRank = dao.selectOne(REVIEW_RANK + ".queryDataByRankId", rankId[i]);
				
				reviewRank.setConfirmDate(ts);
				reviewRank.setConfirmStatus("9");
				reviewRank.setConfirmUser(userCode);
				if(!reviewRank.getReviewResult().equals("T")){
					reviewRank.setConfirmRank(reviewRank.getRecommendRank());
				}
				if(!reviewRank.getCusReviewResult().equals("T")){
					reviewRank.setCusConfirmRank(reviewRank.getCusRecommendRank());
				}
				ReviewRankHistory rrh = new ReviewRankHistory();
				//添加变更记录
				rrh.setPkid(UUIDGenerator.getUUID());
				rrh.setRankId(reviewRank.getRankId());
				rrh.setBeforeRank(reviewRank.getRankCode());
				if(!reviewRank.getReviewResult().equals("T")){
					rrh.setAfterRank(reviewRank.getConfirmRank());
				}
				rrh.setChangeuser(userCode);
				rrh.setChangedate(ts);
				this.reviewRankHistoryService.saveOrUpdate(rrh);
				//更改确认职级状态
				dao.update(REVIEW_RANK + ".confirmRankByPrimaryKeyElse", reviewRank);
				Map<String,Object> salesMap = new HashMap<String, Object>();
				salesMap.put("salesmanCode", reviewRank.getSalesmanCode());
				if(!reviewRank.getReviewResult().equals("T")){
					salesMap.put("rankCode", reviewRank.getRecommendRank());
				}
				if(!reviewRank.getCusReviewResult().equals("T")){
					salesMap.put("cusConfirmRank", reviewRank.getCusRecommendRank());
				}
				//同步修改销售人员职级
				if(!reviewRank.getReviewResult().equals("T") || !reviewRank.getCusReviewResult().equals("T")){
					dao.update(REVIEW_RANK + ".updateSalesmanRankCode", salesMap);
				}
			}
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
	
	/**
	 * 职级调整
	 * 编写者:卢水发
	 * 创建时间:2015年7月27日 下午3:01:31 </pre>
	 * @see com.sinosafe.xszc.review.service.ReviewRankService#changeReviewRank(java.util.Map)
	 */
	@Override
	public void changeReviewRank(Map<String, Object> whereMap) {
		try{
			Timestamp curTime =  Timestamp.valueOf(DateUtil.getSystemDateStr("yyyy-MM-dd hh24:mm:ss"));
			IUserDetails curUserInfo = CurrentUser.getUser();
			String userCode = curUserInfo.getUsername();
			Map<String,Object> salesMap = new HashMap<String, Object>();
			salesMap.put("salesmanCode", whereMap.get("salesmanCode"));
			if(StringUtil.isNotEmpty(whereMap.get("cusConfirmRank").toString())){
				salesMap.put("cusConfirmRank", whereMap.get("cusConfirmRank"));
			}
			salesMap.put("rankCode", whereMap.get("confirmRank"));
			//添加历史记录
			ReviewRank reviewRank = this.findReviewRankDetailByPK(whereMap.get("rankId").toString());
			ReviewRankHistory rrh = new ReviewRankHistory();
			rrh.setPkid(UUIDGenerator.getUUID());
			rrh.setRankId(whereMap.get("rankId").toString());
			rrh.setBeforeRank(reviewRank.getRankCode());
			rrh.setAfterRank(whereMap.get("confirmRank").toString());
			rrh.setChangeuser(userCode);
			rrh.setChangedate(curTime);
			this.reviewRankHistoryService.saveOrUpdate(rrh);
			//添加历史记录--结束
			//职级调整
			dao.update(REVIEW_RANK + ".updateConfirmRankByPK", whereMap);
			//同步修改销售人员职级
			dao.update(REVIEW_RANK + ".updateSalesmanRankCode", salesMap);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	/**
	 * 分页查询
	 */
	@Override
	public PageDto findReviewRankByWhere(PageDto pageDto) {
		// ===========================加入业务线=部门判断=开始=============================
		// 登录者业务线
		List<String> lineCodeFix = noticeService.filterSubBusinessLines();
		pageDto.getWhereMap().put("lineCodeFix", lineCodeFix);
		// ===========================加入业务线=部门判断=结束=============================
		log.debug("职级考核分页查询.....");
		Long total = dao.selectOne(REVIEW_RANK + ".queryListPageCount",pageDto.getWhereMap());
		pageDto.setTotal(total);
		
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REVIEW_RANK + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	
	/**
	 * 分页查询
	 */
	@Override
	public PageDto queryReviewRankHistory(PageDto pageDto) {
		Long total = dao.selectOne(REVIEW_RANK_HISTORY+ ".queryHistoryListPageCount",pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REVIEW_RANK_HISTORY + ".queryHistoryListPage", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}


	/**
	 * 导出
	 */
	@Override
	public PageDto queryDataToExcel(PageDto pageDto) {
		Long total = dao.selectOne(REVIEW_RANK + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", total);
		List<Map<String, Object>> rows = dao.selectList(REVIEW_RANK + ".queryListPage", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	/**
	 * 确认职级
	 */
	@Override
	public void updateReviewRank(ReviewRank... reviewRank) {
		// TODO Auto-generated method stub
		dao.update(REVIEW_RANK + UPDATE_VO, reviewRank[0]);
	}

	/**
	 * 职级调整
	 */
	@Override
	public void updateRankAdjust(ReviewRank... reviewRank) {
		dao.update(REVIEW_RANK + ".updateByPrimaryKeysVo", reviewRank[0]);
	}

	/**
	 * 修改人员的职级
	 */
	@Override
	public void updateSalesRank(ReviewRank... reviewRank) {
		dao.update(REVIEW_RANK + ".updateBySaleRank", reviewRank[0]);
	}

	@Override
	public ReviewRank findReviewRankDetailByPK(String rankId) {
		ReviewRank reviewRank = dao.selectOne(REVIEW_RANK + ".selectByPrimaryKeyVo", rankId);
		return reviewRank;
	}
	
	@Override
	public Map<Object,String> queryComAndCusRank(String rankId) {
		Map<Object,String> map  = new HashMap<Object,String>();
		map = dao.selectOne(REVIEW_RANK + ".queryComAndCusRank", rankId);
		return map;
	}

	@Override
	public void saveReviewRank(ReviewRank... reviewRank) {
		if (reviewRank != null && reviewRank.length > 0) {
			for (int i = 0; i < reviewRank.length; i++) {
				dao.insert(REVIEW_RANK + INSERT_VO, reviewRank[i]);
			}
		} else {
			throw new RuntimeException("没有要添加的版本定义，参数为null或长度为0");
		}
	}

	
	@Override
	public boolean findRankAuditFlag(String rankCode) {
		int auditFlag = (Integer) dao.selectOne(REVIEW_RANK + ".findRankAuditFlag", rankCode);
		return auditFlag > 0;
	}

	@Override
	public long queryReviewRank(String salesmanCode) {
		long num = dao.selectOne(REVIEW_RANK + ".queryReviewRank", salesmanCode);
		return num;
	}

	@Override
	public boolean queryMonthSalary(Map<String,Object> parmMap) {
		long confirmSalary = dao.selectOne(REVIEW_RANK + ".queryMonthSalaryByCode", parmMap);
		long recommendSalary = dao.selectOne(REVIEW_RANK + ".queryMonthSalaryByName", parmMap);
		System.out.println("调整职级："+confirmSalary);
		System.out.println("推荐职级："+recommendSalary);
		if(confirmSalary>recommendSalary){
			return false;
		}else{
			return true;
		}
	}

	@Override
	public String queryRankName(String rankCode) {
		String rankName = dao.selectOne(REVIEW_RANK + ".queryRankName", rankCode);
		return rankName;
	}

	@Override
	public boolean batchRecoverRank(String salesmanCodes,String calcMonth) {
		try {
			String[] salesmanCodesArr = salesmanCodes.split(",");
			Map<String,Object> paraMap = new HashMap<String, Object>();
			for (int i = 0; i < salesmanCodesArr.length; i++) {
				String salesmanCode = salesmanCodesArr[i];
				paraMap.put("calcMonth", calcMonth);
				paraMap.put("salesmanCode", salesmanCode);
				dao.update(REVIEW_RANK + ".recoverRank", paraMap);
				dao.update(REVIEW_RANK + ".updateRankStatus", paraMap);
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
		
	}

}
