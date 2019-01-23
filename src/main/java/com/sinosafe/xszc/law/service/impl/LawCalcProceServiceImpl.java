package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_LAW_CALC_PROCE;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.law.service.LawCalcProceService;

public class LawCalcProceServiceImpl implements LawCalcProceService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public Long queryRowCount(Map<String, Object> whereMap) {
		return (Long) dao.selectOne(T_LAW_CALC_PROCE + QUERY_COUNT, whereMap);
	}

	@Override
	public List<Map<String, Object>> queryLawCalcByWhere(Map<String, Object> whereMap) {
		return dao.selectList(T_LAW_CALC_PROCE + ".queryListProc", whereMap);
	}

	@Override
	public List<Map<String, Object>> queryCalcRank(Map<String, Object> whereMap) {
		return dao.selectList(T_LAW_CALC_PROCE + ".queryCalcProce", whereMap);
	}

	@Override
	public List<Map<String, Object>> queryLawRankByWhere(Map<String, Object> whereMap) {
		return dao.selectList(T_LAW_CALC_PROCE + ".queryListRankPage", whereMap);
	}

}
