package com.sinosafe.xszc.law.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.sinosafe.xszc.law.vo.TLawRate;
import com.sinosafe.xszc.util.PageDto;

public interface LawRateService {

	public PageDto queryRateList(Map<String, Object> whereMap);
	
	public PageDto queryAreaRateList(Map<String, Object> whereMap);
	
	public List<Map<String, Object>> queryRateType();
	
	public List<Map<String, Object>> queryRateCol(String rateType);
	
	public void updateLawRate(String pkId, String rate);

	public boolean genRateSafeTypeModelXls(Map<String, Object> paramMap);

	public boolean genRateChannelModelXls(Map<String, Object> paramMap);

	public boolean batchSaveLawRateDataInXls(Map<String, Object> whereMap);

	boolean saveOrUpdateByWhere(TLawRate lawRate);

	public boolean updateChange(List<TLawRate> LawRateList,String rateType,String versionId);

	void saveList(List<Map<String, Object>> rows);

	List<Map<String, Object>> getDefaultCarTypeInputModel(Map<String, Object> whereMap);

	List<Map<String, Object>> getDefaultInputModel(Map<String, Object> whereMap);

	public void initRateData(List<Map<String, Object>> rows);
	
	public void saveLawRuleConfig(Map<String, Object> paramMap) throws JsonParseException, JsonMappingException, IOException;
	
	public Map<String, Object> findLawRateConfigByVersionId(String versionId);

	void saveAreaRateConfig(Map<String, Object> formMap) throws JsonParseException, JsonMappingException, IOException;

	public void saveLawRulePermission(Map<String, Object> formMap);

	public Map<String, Object> queryButtonStatus(String versionId);

	public boolean queryFactorImp(Map<String, Object> paraMap);
	
}
