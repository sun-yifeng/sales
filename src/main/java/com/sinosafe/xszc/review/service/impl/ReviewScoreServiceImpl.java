package com.sinosafe.xszc.review.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.FACTOR_GOT_PRM;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REVIEW_SCORE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_MISSION;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.DateUtil;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.review.service.ReviewScoreService;
import com.sinosafe.xszc.util.PageDto;

public class ReviewScoreServiceImpl implements ReviewScoreService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;

	@Autowired
	@Qualifier(value = "noticeService")
	private NoticeService noticeService;

	//考核得分
	@Override
	public PageDto findReviewScoreByWhere(PageDto pageDto) {
		Long total = (Long) dao.selectOne(REVIEW_SCORE + ".queryListPageScoreCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REVIEW_SCORE + ".queryListPageScore", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void confirmReviewScore(String deptCodeThree, String statMonth) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptCodeThree", deptCodeThree);
		map.put("statMonth", statMonth);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		map.put("missionType", '2');
		dao.update(T_MISSION + ".confirmTask", map);
		dao.update(T_MISSION + ".confirmScore", map);
	}

	@Override
	public PageDto findScoreCoutApplyByWhere(PageDto pageDto) {
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
	public PageDto queryStandToExcel(PageDto pageDto) {
		Map<String, Object> whereMap = pageDto.getWhereMap();
		pageDto.setWhereMap(whereMap);
		List<Map<String, Object>> rows = dao.selectList(FACTOR_GOT_PRM + ".exportStandFee", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto queryScoreConfirm(PageDto pageDto) {
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

	//查询保费清单
	@Override
	public PageDto queryPlyPrmListByWhere(PageDto pageDto) {
		Long total = (Long) dao.selectOne(REVIEW_SCORE + ".queryStandardPremiumCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REVIEW_SCORE + ".queryStandardPremium", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	
	@Override
	public PageDto queryClmRateListByWhere(PageDto pageDto) {
		Long total = (Long) dao.selectOne(REVIEW_SCORE + ".queryClmRateListCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REVIEW_SCORE + ".queryClmRateList", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}


	@Override
	public List<Map<String, Object>> queryTotalPremium(Map<String, Object> paramap) {
		List<Map<String, Object>> total_map = dao.selectList(REVIEW_SCORE + ".queryTotalPremium", paramap);
		return total_map;
	}
	
	public boolean batchConfirmScore(JSONArray reviewScoreList) {
		try {
			IUserDetails curUserInfo = CurrentUser.getUser();
			String userCode = curUserInfo.getUsername();
			for (Object o : reviewScoreList) {
				JSONObject reviewSalary = (JSONObject) o;
				Map<String, Object> salesMap = new HashMap<String, Object>();
				salesMap.put("confirmStatus", "1");
				salesMap.put("confirmDate", DateUtil.getSystemDateStr("yyyy-MM-dd HH:mm:ss"));
				salesMap.put("confirmUser", userCode);
				salesMap.put("scoreId", reviewSalary.get("scoreId"));
				dao.update(REVIEW_SCORE + ".confirmScoreByPrimaryKey", salesMap);
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
