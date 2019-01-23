package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.TLawOriginRate;
import com.sinosafe.xszc.util.PageDto;

public interface TLawOriginRateService {
	//分页
	public PageDto findTLawOriginRateByWhere(PageDto pageDto);
	//新增
	void saveTLawOriginRate(TLawOriginRate... tLawOriginRate);
	//查询单条数据
	List<Map<String, Object>> queryTLawOriginRateToUpdate(String originRateId);
	//删除
	void deleteTLawOriginRate(TLawOriginRate tLawOriginRate);
}
