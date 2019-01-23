package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.LawDefine;
import com.sinosafe.xszc.util.PageDto;

public interface LawDefineService {

	public PageDto findLawDefineByWhere(PageDto pageDto);
	
	public boolean saveDefine(LawDefine... lawDefine);
	
	public void saveOrUpdateLawDefine(Map<String, Object> paraMap);
	
	public void updateLawDefine(Map<String, Object> whereMap);

	public List<Map<String, Object>> queryLawDefineInfo(String versionCode);
	
	public boolean existValidVersion(Map<String, Object> whereMap);

	public void deleteLawDefine(String versionCode);

	public PageDto queryLawDefineOmcombo(PageDto pageDto);
	
	public List<Map<String, Object>> queryDeptCodeList();

	public long queryVersionCode(String versionCode);
	
	List<Map<String, Object>> queryDefineCode(Map<String, Object> whereMap);
	
	Map<String, Object> generateVersionCode(LawDefine lawDefine);
	
	public PageDto queryPageFactor(PageDto pageDto);
	
	public PageDto queryPageImport(PageDto pageDto);
	
	public PageDto queryPageExamine(PageDto pageDto);
	
	public PageDto queryPageIndex(PageDto pageDto);
	
	public PageDto queryPageRank(PageDto pageDto);
	
	public PageDto queryPageReview(PageDto pageDto);
	
	public void updateFactorSystem(Map<String, Object> paraMap);
	
	public void updateFactorImport(Map<String, Object> paraMap);
	
	public void updateFactorExamine(Map<String, Object> paraMap);
	
	public void updateLawIndex(Map<String, Object> paraMap);
	
	public void updateLawReview(Map<String, Object> paraMap);
	
	public void updateLawRank(Map<String, Object> paraMap);
	
	public List<Map<String, Object>> queryImportList(Map<String, Object> whereMap);

	public Map<String, Object> getLawDefineByDeptCode(String deptCode,String lineCode);

	public List<Map<String, Object>> queryLawDefineForSelect(String deptCode);
	
	public LawDefine getLawDefineByPkId(String pkId);
	
	public void manualCalculation(String versionId,String deptCode,String lineCode);

	public void initRateData();
	
	public Long queryBasicLaw(String deptCode);
	
	public Long queryBasicLawArea(String deptCode);
	
	List<Map<String, Object>> queryRules(Map<String, Object> map); 
	
	String validateFormula(String versionId);
	
}
