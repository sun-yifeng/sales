package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.LawFactor;
import com.sinosafe.xszc.util.PageDto;

public interface LawFactorService {
	//分页查询
	PageDto findLawFactorByWhere(PageDto pageDto);
	//新增
	void saveLawFactor(LawFactor... lawFactor);
	//生成流水号
	Long getSerialNumber(LawFactor... lawFactor);
	//查询单条数据
	List<Map<String, Object>> queryLawFactorToUpdate(String serno);
	//删除
	void deleteLawFactor(LawFactor lawFactor);
	//校验重复
	Boolean queryItemCode(String itemCode);
	//查询因素COD和名称 用于指标因素关系指定
	List<Map<String, Object>> queryCodeAndName(Map<String, Object> factorMap);
}
