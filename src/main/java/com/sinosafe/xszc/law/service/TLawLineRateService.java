package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.TLawLineRate;
import com.sinosafe.xszc.util.PageDto;

public interface TLawLineRateService {

	PageDto findTLawLineRateByWhere(PageDto pageDto);

	void saveTLawLineRate(TLawLineRate... tLawLineRate);

	List<Map<String, Object>> queryTLawLineRateToUpdate(String lineRateId);

	void deleteTLawLineRate(String lineRateId);

}
