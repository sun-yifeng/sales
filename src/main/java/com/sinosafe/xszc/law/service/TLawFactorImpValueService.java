package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONArray;
import com.sinosafe.xszc.law.vo.TLawFactorImpValue;
import com.sinosafe.xszc.util.PageDto;

/**
 * 类名:com.sinosafe.xszc.law.service.TLawFactorImpValueService <pre>
 * 描述:经理团队导入因子数值业务
 * 编写者:卢水发
 * 创建时间:2015年6月30日 上午11:13:23
 * 修改说明:无修改说明
 */
public interface TLawFactorImpValueService {
	
	boolean genTLawFactorImpValueXls(Map<String, Object> paramMap);
	
	boolean genGroupImpXls(Map<String, Object> paramMap);

	boolean batchSaveDataInXls(Map<String, Object> paramMap);
	
	boolean batchSaveGroupDataInXls(Map<String, Object> paramMap);
	
	boolean batchSaveLawElectricPolicy(Map<String, Object> paramMap)throws Exception;
	
	PageDto findTLawFactorImpValueToPage(PageDto pageDto);
	
	PageDto queryLawElectricPolicy(PageDto pageDto);
	
	boolean isExist(String detailId);

	boolean saveOrUpdateByWhere(TLawFactorImpValue lfiv);

	boolean updateChange(JSONArray changeList, String itemType,String versionId);

	List<Map<String, Object>> getLawDefineImpList(String itemType, String versionId);

	List<Map<String, Object>> getBFLawDefineList(String deptCode);
}
