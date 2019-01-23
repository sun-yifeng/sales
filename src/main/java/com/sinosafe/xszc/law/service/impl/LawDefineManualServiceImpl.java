package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_LAW_DEFINE_MANUAL;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.law.service.LawDefineManualService;
import com.sinosafe.xszc.util.PageDto;

public class LawDefineManualServiceImpl implements LawDefineManualService {
	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Override
	public PageDto queryManualTaskList(Map<String, Object> whereMap) {
		PageDto pageDto = new PageDto();
		List<Map<String, Object>> rows = dao.selectList(T_LAW_DEFINE_MANUAL + ".queryManualTaskList", whereMap);
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Map<String, Object> execManualCal(Map<String, Object> paraMap) {
		String taskCode = (String) paraMap.get("taskCode");
		String procName = getCalcStep(taskCode);
		try {
			//更新操作人
			dao.update(T_LAW_DEFINE_MANUAL + ".updateOperaterUser", paraMap);
			
			//调用任务存过
			dao.selectOne(T_LAW_DEFINE_MANUAL+ procName, paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			paraMap.put("resultMsg", "手动执行算法第"+taskCode+"失败");
		}
		return paraMap;
	}
	
	private String getCalcStep(String taskCode){
		if("1".equals(taskCode)){
			return ".execManualCal1";
		}else if("2".equals(taskCode)){
			return ".execManualCal2";
		}else if("3".equals(taskCode)){
			return ".execManualCal3";
		}else if("4".equals(taskCode)){
			return ".execManualCal4";
		}else if("5".equals(taskCode)){
			return ".execManualCal5";
		}else if("6".equals(taskCode)){
			return ".execManualCal6";
		}else if("7".equals(taskCode)){
			return ".execManualCal7";
		}else{
			return "";
		}
	}

	@Override
	public boolean findTaskStatus(Map<String, Object> paraMap) {
		long total = dao.selectOne(T_LAW_DEFINE_MANUAL+".findTaskStatus", paraMap);
		return total > 0;
	}

	@Override
	public String findLastTaskStatus(Map<String, Object> paraMap) {
		String result = dao.selectOne(T_LAW_DEFINE_MANUAL + ".queryLastTaskStatus", paraMap);
		return result;
	}

	@Override
	public boolean lawRuleConfigOrNot(Map<String, Object> paraMap) {
		long total = dao.selectOne(T_LAW_DEFINE_MANUAL + ".queryRuleConfigByVersionId", paraMap);
		return total > 0;
	}

	@Override
	public void updateTaskStatus(Map<String, Object> paraMap) {
		String taskCode = (String) paraMap.get("taskCode");
		int taskCodeInt = Integer.valueOf(taskCode);
		for (int i = taskCodeInt; i <=7; i++) {
			paraMap.put("taskCode", i+"");
			dao.update(T_LAW_DEFINE_MANUAL + ".updateTaskStatus", paraMap);
		}
		
	}

	@Override
	public PageDto queryCalcLogs(PageDto pageDto) {
		Long total = dao.selectOne(T_LAW_DEFINE_MANUAL + ".queryCalcLogsCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(T_LAW_DEFINE_MANUAL + ".queryCalcLogs", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public String queryCalcMonth(Map<String, Object> paraMap) {
		String result = dao.selectOne(T_LAW_DEFINE_MANUAL + ".queryCalcMonth", paraMap);
		return result;
	}
}
