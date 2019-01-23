package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.TRankCalc;
import com.sinosafe.xszc.util.PageDto;

public interface TRankCalcService {

	public PageDto findTRankCalcByWhere(PageDto pageDto);
	
	void saveTRankCalc(TRankCalc... tRankCalc);

	public Object getSerialNumber(TRankCalc... tRankCalc);
	
	public List<Map<String, Object>> queryTRankCalcToUpdate(String serno);

	void deleteTRankCalc(TRankCalc tRankCalc);
}
