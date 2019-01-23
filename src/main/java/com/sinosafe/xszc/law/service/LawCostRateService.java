package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.TLawCostRate;
import com.sinosafe.xszc.util.PageDto;


public interface LawCostRateService {

	PageDto findLawCostRateByWhere(PageDto pageDto);

	void saveLawCostRate(TLawCostRate... lawCostRate);

	List<Map<String, Object>> queryLawCostRateToUpdate(String costRateId);

	void deleteLawCostRate(String costRateId);
}
