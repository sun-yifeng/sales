package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.TRankDef;
import com.sinosafe.xszc.util.PageDto;

public interface TRankDefService {

	public PageDto findLawRankByWhere(PageDto pageDto);
	
	public void saveLawRank(TRankDef... tRankDef);
	
	//获取流水号
	Long getSerialNumber(TRankDef... tRankDef);
	
	//查询单条数据
	public List<Map<String, Object>> queryLawRankToUpdate(String serno);
	
	//删除
	void deleteLawRank(TRankDef tRankDef);
	
	//校验重复
	Boolean queryRankCode(String rankCode);
	
	List<Map<String, Object>> queryRankByLineCode(Map<String, Object> rankMap);
	
	String queryRankNameByRankCode(String rankCode);
	
	List<Map<String, Object>> queryManagerRankByLineCode(Map<String, Object> rankMap);
	
	List<Map<String, Object>> queryConfirmRank(Map<String, Object> rankMap);
	
	List<Map<String, Object>> queryCusAdjustRank(Map<String, Object> rankMap);
	
	Map<String, Object> generateRankCode(TRankDef rankDef);
}
