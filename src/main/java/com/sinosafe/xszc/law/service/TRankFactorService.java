package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.TRankFactor;
import com.sinosafe.xszc.util.PageDto;

public interface TRankFactorService {
	//分页查询
	PageDto findTRankFactorByWhere(PageDto pageDto);
	//新增
	void savetTRankFactor(TRankFactor... tRankFactor);
	//获取流水号
	Long getSerialNumber(TRankFactor... tRankFactor);
	//查询单条数据
	List<Map<String, Object>> queryTRankFactorToUpdate(String serno);
	//删除
	void deleteTRankFactor(TRankFactor tRankFactor);
}
