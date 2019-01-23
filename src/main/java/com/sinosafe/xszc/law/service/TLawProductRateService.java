package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.TLawProductRate;
import com.sinosafe.xszc.util.PageDto;

public interface TLawProductRateService {

	PageDto findTLawProductRateByWhere(PageDto pageDto);

	void saveTLawProductRate(TLawProductRate... tLawProductRate);

	void deleteTLawLineRate(String productRateId);

	List<Map<String, Object>> queryTLawProductRateToUpdate(String productRateId);

}
