package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.LawTarget;
import com.sinosafe.xszc.util.PageDto;

public interface LawTargetService {

	public PageDto findLawTargetByWhere(PageDto pageDto);
	//新增
	void saveLawTarget(LawTarget... lawTarget);
	//生成流水号
	Long getSerialNumber(LawTarget... lawTarget);
	//查询单条数据
	List<Map<String, Object>> queryLawTargetToUpdate(String serno);
	//删除
	void deleteLawTarget(LawTarget lawTarget);
	//校验重复
	Boolean queryIndexCode(String indexCode);
	
	public LawTarget queryLawTargetByVo(LawTarget lawTarget);
	
	LawTarget selectByPrimaryKey(LawTarget lawTarget);
	//查询指标CODE和名称 用于指标关系指定
	List<Map<String, Object>> queryCodeAndName(Map<String, Object> indexMap);

}
