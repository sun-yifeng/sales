package com.sinosafe.xszc.common.service;

import java.util.List;
import java.util.Map;

public interface CommonServerice {

	List<Map<String, Object>> queryProvince();

	List<Map<String, Object>> queryCity(String province);

	List<Map<String, Object>> queryBank();

	List<Map<String, Object>> queryCategory();

	List<Map<String, Object>> queryChannelFeature();

	List<Map<String, Object>> queryProfession();

	List<Map<String, Object>> queryBusinessLine();
	
	List<Map<String, Object>> queryBusinessLineNew();
	
	List<Map<String, Object>> queryChannelLevel();

	List<Map<String, Object>> queryCountry();

	List<Map<String, Object>> queryProperty(String parentCode);
	
	List<Map<String, Object>> queryPropertyMV(String parentCode);

	List<Map<String, Object>> queryConferType();

	List<Map<String, Object>> queryChannelPartnerType();

	List<Map<String, Object>> queryCertifyType();

	List<Map<String, Object>> queryEducatioin();

	List<Map<String, Object>> queryTitle();

	List<Map<String, Object>> queryTPrdKind();

	List<Map<String, Object>> queryNational();

	List<Map<String, Object>> querySaleRank(String managerFlag);
	
	List<Map<String, Object>> queryGroupRank();

	List<Map<String, Object>> querySalesmanStatus();

	List<Map<String, Object>> querySalesmanType();

	List<Map<String, Object>> queryPrdCode(String prdType);

	List<Map<String, Object>> queryBankNode(Map<String, Object> map);

	List<Map<String, Object>> queryFinancePolicyFlag();

	String getUserDept();
	
	String getCalcMonth();
}
