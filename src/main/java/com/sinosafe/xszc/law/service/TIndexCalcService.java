package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.TIndexCalc;
import com.sinosafe.xszc.util.PageDto;

public interface TIndexCalcService {
	
	public PageDto findTIndexCalcByWhere(PageDto pageDto);

	void saveTIndexCalc(TIndexCalc... tIndexCalc);

	//生成流水号
	Long getSerialNumber(TIndexCalc... tIndexCalc);

	public List<Map<String, Object>> queryTIndexFactorToUpdate(String serno);

	void deleteTIndexCalc(TIndexCalc tIndexCalc);
	
}
