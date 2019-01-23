package com.sinosafe.xszc.law.service;

import java.util.Map;

import com.sinosafe.xszc.util.PageDto;

public interface LawDefineManualService {
	
	public PageDto queryManualTaskList(Map<String, Object> whereMap);
	
	Map<String, Object> execManualCal(Map<String,Object> paraMap);
	
	boolean findTaskStatus(Map<String, Object> paraMap);
	
	String findLastTaskStatus(Map<String, Object> paraMap);
	
	boolean lawRuleConfigOrNot(Map<String, Object> paraMap);
	
	void updateTaskStatus(Map<String, Object> paraMap);
	
	public PageDto queryCalcLogs(PageDto pageDto);
	
	String queryCalcMonth(Map<String, Object> paraMap);
	
}
