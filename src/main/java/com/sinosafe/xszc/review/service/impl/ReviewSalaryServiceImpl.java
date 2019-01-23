package com.sinosafe.xszc.review.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REVIEW_SALARY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_MISSION;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.DateUtil;
import com.sinosafe.xszc.common.service.CommonServerice;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.review.service.ReviewSalaryService;
import com.sinosafe.xszc.review.vo.ReviewSalary;
import com.sinosafe.xszc.util.PageDto;

public class ReviewSalaryServiceImpl implements ReviewSalaryService {
	
	private static final Log log = LogFactory.getLog(ReviewSalaryServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Autowired
	@Qualifier(value = "noticeService")
	private NoticeService noticeService;

	/**
	 * 编写者:卢水发
	 * 创建时间:2015年7月23日 下午5:08:29 </pre>
	 * @see com.sinosafe.xszc.review.service.ReviewSalaryService#batchConfirmSalary(java.util.List)
	 */
	public boolean batchConfirmSalary(JSONArray reviewSalaryList){
		try{
			IUserDetails curUserInfo = CurrentUser.getUser();
			String userCode = curUserInfo.getUsername();
			for (Object o : reviewSalaryList) {
				JSONObject reviewSalary = (JSONObject)o;
				Map<String,Object> salesMap = new HashMap<String, Object>();
				salesMap.put("confirmStatus","1");
				salesMap.put("confirmDate",DateUtil.getSystemDateStr("yyyy-MM-dd HH:mm:ss") );
				salesMap.put("confirmUser",userCode);
				salesMap.put("salaryId",reviewSalary.get("salaryId"));
				dao.update(REVIEW_SALARY + ".confirmSalaryByPrimaryKey", salesMap);
			}
			return true;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
	
	/**
	 *  分页查询薪酬
	 */
	@Override
	public PageDto findReviewSalaryByWhere(PageDto pageDto) {
		// ===========================加入业务线=部门判断=开始=============================
		// 登录者业务线
		List<String> lineCodeFix = noticeService.filterSubBusinessLines();
		pageDto.getWhereMap().put("lineCodeFix", lineCodeFix);
		// ===========================加入业务线=部门判断=结束=============================
		log.debug("薪酬分页查询开始.....");
		Long total = dao.selectOne(REVIEW_SALARY + ".queryListPageCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REVIEW_SALARY + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		log.debug("薪酬分页查询结束.....");
		return pageDto;
	}
	
	/**
	 * 薪酬导出
	 */
	@Override
	public PageDto queryDataToExcel(PageDto pageDto) {
		Long total = dao.selectOne(REVIEW_SALARY + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", total);
		List<Map<String, Object>> rows = dao.selectList(REVIEW_SALARY + ".queryListPage", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	//修改确认的薪酬信息
	@Override
	public void updateReviewSalary(ReviewSalary... reviewSalary) {
		dao.update(REVIEW_SALARY + UPDATE_VO, reviewSalary[0]); 
	}

	@Override
	public PageDto querySalaryConfirm(PageDto pageDto) {
		Long total = dao.selectOne(T_MISSION + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(T_MISSION + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void confirmReviewSalary(String deptCodeThree,String statMonth) {
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("deptCodeThree", deptCodeThree);
			map.put("statMonth", statMonth);
			map.put("updatedUser", CurrentUser.getUser().getUserCode());
			map.put("missionType", '3');
			dao.update(T_MISSION + ".confirmTask", map);
			dao.update(T_MISSION + ".confirmSalary", map);
	}
}
