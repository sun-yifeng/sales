package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

public interface LawCalcProceService {
	
	Long queryRowCount(Map<String, Object> whereMap);

	List<Map<String, Object>> queryLawCalcByWhere(Map<String, Object> whereMap);
	
	List<Map<String, Object>> queryLawRankByWhere(Map<String, Object> whereMap);

	List<Map<String, Object>> queryCalcRank(Map<String, Object> whereMap);

}
