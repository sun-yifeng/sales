package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.TIndexFactor;
import com.sinosafe.xszc.util.PageDto;

public interface TIndexFactorService {
	//分页查询
	PageDto findTIndexFactorByWhere(PageDto pageDto);
	//新增
	void savetIndexFactor(TIndexFactor... tIndexFactor);
	//获取流水号
	Long getSerialNumber(TIndexFactor... tIndexFactor);
	//查询单条数据
	List<Map<String, Object>> queryTIndexFactorToUpdate(String serno);
	//删除
	void deleteTIndexFactor(TIndexFactor tIndexFactor);
	
}
