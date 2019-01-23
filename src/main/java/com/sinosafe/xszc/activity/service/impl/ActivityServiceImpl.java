package com.sinosafe.xszc.activity.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.ACTIVITY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.ACTIVITY_EXPAND;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.ACTIVITY_FEEDBACK;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.ACTIVITY_RECEIVE_DEPT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPLOAD;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.activity.service.ActivityService;
import com.sinosafe.xszc.util.FillCommonInfo;
import com.sinosafe.xszc.util.PageDto;

/**
 *
 * 类名:com.sinosafe.xszc.activity.service.impl.ActivityServiceImpl <pre>
 * 描述:活动管理业务实现
 * 基本思路:
 * 特别说明:
 * 编写者:李晓亮
 * 创建时间:2014年6月19日 上午11:03:48
 * 修改说明: 类的修改说明
 * </pre>
 */
public class ActivityServiceImpl implements ActivityService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@Override
	public PageDto findActivityByWhere(PageDto pageDto) {
		Long total = dao.selectOne(ACTIVITY + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(ACTIVITY + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Map<String, Object> findActivityDetailByWhere(Map<String, Object> whereMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = dao.selectList(ACTIVITY+QUERY, whereMap);
		if (resultList!=null&&resultList.size()>0) {
			resultMap = resultList.get(0);
		}
		return resultMap;
	}

	@Override
	public PageDto findActivityFeedbackByWhere(PageDto pageDto) {
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(ACTIVITY_FEEDBACK + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Map<String, Object> findActivityForSummary(Map<String, Object> paraMap) {
		Long total;
		paraMap.put("status", "3");//反馈已完成状态
		Map<String, Object> resultMap = new HashMap<String, Object>();
		total = dao.selectOne(ACTIVITY_EXPAND + ".queryNoFeedbackCount", paraMap);
		resultMap.put("total", total);
		return resultMap;
	}

	@Override
	public Boolean saveActivity(Map<String, Object> paraMap) {
		paraMap.put("status", "0");//指定状态为暂存
		commonActivitySave(paraMap);
		return true;
	}
	
	private String commonActivitySave(Map<String, Object> paraMap) {
		paraMap.put("validInd", '1');//状态设置为有效
		String defaultDept = getDefaultDept();
		if (paraMap.get("activityId").equals("undefined")) {
			FillCommonInfo.fillParamMap(paraMap,"insert");
			paraMap.put("activityId", UUIDGenerator.getUUID());
			paraMap.put("deptCode", defaultDept);
			dao.insert(ACTIVITY+INSERT, paraMap);
			paraMap.put("uploadId", paraMap.get("programUploadId"));
			paraMap.put("mainId", paraMap.get("activityId"));
			paraMap.put("module", "05");
			paraMap.put("name", "活动方案");
			dao.insert(UPLOAD + INSERT, paraMap);
		} else {
			if (paraMap.get("status").equals("0")) {
				paraMap.remove("status");
			}
			FillCommonInfo.fillParamMap(paraMap,"update");
			dao.update(ACTIVITY+UPDATE_PK, paraMap);
		}
		return (String) paraMap.get("activityId");
	}

	private String getDefaultDept() {
		// TODO Auto-generated method stub
		
		Map<String, Object> deptMap =  umService.findDefaultDeptCodeByUserCode(CurrentUser.getUser().getUserCode());
		String defaultDept = null;
		if(deptMap!=null){
			defaultDept = (String) deptMap.get("deptCode");
		}
		return defaultDept;
	}

	@Override
	public void saveSubmitActivity(Map<String, Object> paraMap) {
		paraMap.put("status", "1");//指定状态为活动进行中
		commonActivitySave(paraMap);
		saveActivityExpand(paraMap);
	}

	private void saveActivityExpand(Map<String, Object> paraMap) {
		List<Map<String, Object>> receiveDeptMaps = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> feedbackMaps = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> uploadMaps = new ArrayList<Map<String, Object>>();
		String issuedDepts[] = (String[]) paraMap.get("issuedDepts");
		for (int i = 0; i < issuedDepts.length; i++) {
			Map<String, Object> tempMap = new HashMap<String, Object>();
			tempMap.put("deptCode", issuedDepts[i]);
			tempMap.put("activityId", paraMap.get("activityId"));
			FillCommonInfo.fillParamMap(tempMap, "insert");
			receiveDeptMaps.add(tempMap);
			tempMap.put("status", "1");
			feedbackMaps.add(tempMap);
			tempMap.put("module", "06");
			tempMap.put("name", "活动反馈");
			tempMap.put("mainId", paraMap.get("activityId"));
			uploadMaps.add(tempMap);
		}
		Map<String, Object> tempMap = new HashMap<String, Object>();
		tempMap.put("deptCode", paraMap.get("deptCode"));
		FillCommonInfo.fillParamMap(tempMap, "insert");
		tempMap.put("module", "07");
		tempMap.put("name", "活动总结");
		tempMap.put("mainId", paraMap.get("activityId"));
		uploadMaps.add(tempMap);
		insertByMaps(ACTIVITY_RECEIVE_DEPT, "receiverId", receiveDeptMaps);
		insertByMaps(ACTIVITY_FEEDBACK, "feedbackId", feedbackMaps);
		insertByMaps(UPLOAD, "uploadId", uploadMaps);
	}

	private void insertByMaps(String tableNameSpace, String tableId, List<Map<String, Object>> feedbackMaps) {
		for (int i = 0; i < feedbackMaps.size(); i++) {
			String sqlId = tableNameSpace + INSERT;
			feedbackMaps.get(i).put(tableId, UUIDGenerator.getUUID());
			feedbackMaps.get(i).put("validInd", "1");
			dao.insert(sqlId, feedbackMaps.get(i));
		}
	}

	/**
	 * 
	 * TODO 活动总结 <br>
	 * 
	 * <pre>
	 * 覆盖方法updateSummaryActivity详细说明 <br>
	 * 编写者：李晓亮
	 * 创建时间：2014年8月5日 下午3:21:34
	 * </pre>
	 * 
	 * @param 参数名 说明
	 * @return 返回值类型 说明
	 * @throws 异常类型 说明
	 * @see com.sinosafe.xszc.activity.service.ActivityService#updateSummaryActivity(java.util.Map)
	 */
	@Override
	public void updateSummaryActivity(Map<String, Object> paraMap) {
		paraMap.put("status", "2");//指定状态为已结束
		FillCommonInfo.fillParamMap(paraMap,"update");
		dao.update(ACTIVITY+UPDATE_PK, paraMap);
	}

	@Override
	public void saveActivityFeedback(Map<String, Object> paraMap) {
		paraMap.put("status", "2");//指定状态为草稿
		FillCommonInfo.fillParamMap(paraMap,"update");
		dao.update(ACTIVITY_FEEDBACK+UPDATE_PK, paraMap);
//		FillCommonInfo.fillParamMap(paraMap,"insert");
//		paraMap.put("feedbackId", UUIDGenerator.getUUID());
//		paraMap.put("validInd", '1');//状态设置为有效
//		dao.insert(ACTIVITY_FEEDBACK+INSERT, paraMap);
	}

	/**
	 * 
	 * TODO 覆盖方法findActivityDetailForFeedback简单说明 <br>
	 * 活动反馈界面数据加载
	 * 
	 * <pre>
	 * 覆盖方法findActivityDetailForFeedback详细说明 <br>
	 * 编写者：李晓亮
	 * 创建时间：2014年8月5日 下午3:50:40
	 * </pre>
	 * 
	 * @param 参数名 说明
	 * @return 返回值类型 说明
	 * @throws 异常类型 说明
	 * @see com.sinosafe.xszc.activity.service.ActivityService#findActivityDetailForFeedback(java.util.Map)
	 */
	@Override
	public Map<String, Object> findActivityDetailForFeedback(Map<String, Object> paraMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> activityMap = new HashMap<String, Object>();
		Map<String, Object> feedbackMap = new HashMap<String, Object>();
		List<Map<String, Object>> activityList = dao.selectList(ACTIVITY+QUERY, paraMap);
		paraMap.put("deptCode", getDefaultDept());
		List<Map<String, Object>> feedbackList = dao.selectList(ACTIVITY_FEEDBACK+QUERY, paraMap);
		if (feedbackList!=null&&feedbackList.size()>0) {
			feedbackMap = feedbackList.get(0);
		}
		if (activityList!=null&&activityList.size()>0) {
			activityMap = activityList.get(0);
		}
		resultMap.putAll(activityMap);
		resultMap.putAll(feedbackMap);
		resultMap.put("defaultDept", getDefaultDept());
		return resultMap;
	}

	@Override
	public void updateFeedbackSubmit(Map<String, Object> paraMap) {
		paraMap.put("status", "3");//指定状态为提交
		FillCommonInfo.fillParamMap(paraMap,"update");
		dao.update(ACTIVITY_FEEDBACK+UPDATE_PK, paraMap);
	}

	@Override
	public PageDto findFeedback(PageDto pageDto) {
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		String deptCode = getDefaultDept();
		if(deptCode == null){
			deptCode = "XXXX";
			pageDto.getWhereMap().put("errorMsg", "请先行设置登录用户默认业务机构，再行查询！");
		}
		pageDto.getWhereMap().put("deptCode", deptCode);
		Long total = dao.selectOne(ACTIVITY_EXPAND + ".queryFeedbackCount", pageDto.getWhereMap());
		List<Map<String, Object>> rows = dao.selectList(ACTIVITY_EXPAND + ".queryFeedbackListPage", pageDto.getWhereMap());
		pageDto.setTotal(total);
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Map<String, List<Map<String, Object>>> findDept(Map<String, Object> paramMap) {
		paramMap.put("deptCode",getDefaultDept()==null?"XXXX":getDefaultDept());
		Map<String, List<Map<String, Object>>> resultMap = new HashMap<String, List<Map<String, Object>>>();
		if (paramMap.get("activityId").equals("undefined")) {
			paramMap.put("activityId", "XXXXXX");
		}
		List<Map<String, Object>> leftResultList = dao.selectList(ACTIVITY_EXPAND + ".queryDept", paramMap);
		List<Map<String, Object>> rightResultList = dao.selectList(ACTIVITY_EXPAND + ".queryIssuedDept", paramMap);
		resultMap.put("left", leftResultList);
		resultMap.put("right", rightResultList);
		return resultMap;
	}

	@Override
	public void deleteActivity(Map<String, Object> paraMap) {
		String[] activityIds = paraMap.get("activityId").toString().split("&");
		for (int i = 0; i < activityIds.length; i++) {
			Map<String, Object> Map = new HashMap<String, Object>();
			Map.put("activityId", activityIds[i]);
			FillCommonInfo.fillParamMap(Map,"delete");
			dao.update(ACTIVITY+UPDATE_PK, Map);
			dao.update(ACTIVITY_FEEDBACK+".updateByActivityId", Map);
			dao.update(ACTIVITY_RECEIVE_DEPT+".updateByActivityId", Map);
			dao.update(ACTIVITY_RECEIVE_DEPT+".updateByActivityId", Map);
			dao.update(UPLOAD+".updateByMainId", Map);
		}
	}

}
