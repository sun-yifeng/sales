package com.sinosafe.xszc.common.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_BANK;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_BANK_NODE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_BUSINESS_LINE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_CATEGORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_CERTIFY_TYPE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_CHANNEL_FEATURE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_CHANNEL_LEVEL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_CHANNEL_PARTNER_TYPE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_CITY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_CONFER_TYPE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_COUNTRY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_EDUCATIOIN;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_FINANCE_POLICY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_GROUP_RANK;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_NATIONAL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_PROFESSION;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_PROVINCE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_SALESMAN_RANK;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_SALESMAN_STATUS;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_SALESMAN_TYPE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_TITLE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_T_PRD_KIND;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_T_PRD_PROD;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LISTS_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.COMMON_PROPERTY;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.common.service.CommonServerice;

public class CommonServericeImpl implements CommonServerice {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Autowired
	@Qualifier("umService")
	private UmService umService;
	
	/**
	 * <pre>
	 * 取登录用户在UM的角色部门
	 * @return
	 * </pre>
	 */
	@Override
	synchronized public String getUserDept() {
		try{
			String currentUser = CurrentUser.getUser().getUserCode();
			// 用户所在机构
			List<Map<String, Object>> detplist = umService.findDeptListByUserCode(currentUser);
			if (detplist == null || detplist.size() == 0) {
				throw new RuntimeException("登录用户" + currentUser + "在UM系统没有分配结构!");
			}
			String deptCode = (String) detplist.get(0).get("deptCode");
			// 如果是总公司用户
			if (deptCode != null && "00".equals(deptCode.substring(0, 2))) {
				deptCode = "";
			}
			return deptCode;
		}catch(Exception e){
			return null;
		}
	}

	@Override
	public List<Map<String, Object>> queryProvince() {

		List<Map<String, Object>> list = dao.selectList(COMMON_PROVINCE + QUERY_LIST_PAGE, "");

		return list;
	}

	@Override
	public List<Map<String, Object>> queryCity(String province) {

		List<Map<String, Object>> list = dao.selectList(COMMON_CITY + QUERY_LIST_PAGE, province);

		return list;
	}

	@Override
	public List<Map<String, Object>> queryBank() {
		List<Map<String, Object>> list = dao.selectList(COMMON_BANK + QUERY_LIST_PAGE, "");
		return list;
	}
    
	@Override
	public List<Map<String, Object>> queryCategory() {
		// 渠道大类  Category_sqlMapper.xml
		List<Map<String, Object>> list = dao.selectList(COMMON_CATEGORY + QUERY_LIST_PAGE, "");
		return list;
	}
	
	@Override
	public List<Map<String, Object>> queryProperty(String parentCode) {
		// 渠道类型 Category_sqlMapper.xml
		List<Map<String, Object>> list = dao.selectList(COMMON_CATEGORY + QUERY_LISTS_PAGE, parentCode);
		return list;
	}
	
	@Override
	public List<Map<String, Object>> queryPropertyMV(String parentCode) {
		// 渠道性质/渠道属类 取物化视图的数据，不用同步
		List<Map<String, Object>> list = dao.selectList(COMMON_CATEGORY + ".queryListMV", parentCode);
		return list;
	}

	@Override
	public List<Map<String, Object>> queryChannelFeature() {
		List<Map<String, Object>> list = dao.selectList(COMMON_CHANNEL_FEATURE + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryProfession() {
		List<Map<String, Object>> list = dao.selectList(COMMON_PROFESSION + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryBusinessLine() {
		List<Map<String, Object>> list = dao.selectList(COMMON_BUSINESS_LINE + QUERY_LIST_PAGE, "");
		return list;
	}
	
	@Override
	public List<Map<String, Object>> queryBusinessLineNew() {
		List<Map<String, Object>> list = dao.selectList(COMMON_BUSINESS_LINE + ".queryListPageNew", "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryChannelLevel() {
		List<Map<String, Object>> list = dao.selectList(COMMON_CHANNEL_LEVEL + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryCountry() {
		List<Map<String, Object>> list = dao.selectList(COMMON_COUNTRY + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryConferType() {
		List<Map<String, Object>> list = dao.selectList(COMMON_CONFER_TYPE + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryChannelPartnerType() {
		List<Map<String, Object>> list = dao.selectList(COMMON_CHANNEL_PARTNER_TYPE + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryCertifyType() {
		List<Map<String, Object>> list = dao.selectList(COMMON_CERTIFY_TYPE + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryEducatioin() {
		List<Map<String, Object>> list = dao.selectList(COMMON_EDUCATIOIN + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryTitle() {
		List<Map<String, Object>> list = dao.selectList(COMMON_TITLE + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryTPrdKind() {
		List<Map<String, Object>> list = dao.selectList(COMMON_T_PRD_KIND + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryNational() {
		List<Map<String, Object>> list = dao.selectList(COMMON_NATIONAL + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> querySaleRank(String managerFlag) {
		HashMap<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("managerFlag", managerFlag);
		List<Map<String, Object>> list = dao.selectList(COMMON_SALESMAN_RANK + ".queryListPage", whereMap);
		return list;
	}

	@Override
	public List<Map<String, Object>> querySalesmanStatus() {
		List<Map<String, Object>> list = dao.selectList(COMMON_SALESMAN_STATUS + QUERY_LIST_PAGE, "");
		return list;
	}
	
	@Override
	public List<Map<String, Object>> querySalesmanType() {
		List<Map<String, Object>> list = dao.selectList(COMMON_SALESMAN_TYPE + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryPrdCode(String prdType) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("prdType", prdType);
		List<Map<String, Object>> list = dao.selectList(COMMON_T_PRD_PROD + QUERY_LIST_PAGE, map);
		return list;
	}

	@Override
	public List<Map<String, Object>> queryBankNode(Map<String, Object> map) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> list = dao.selectList(COMMON_BANK_NODE + QUERY_LIST_PAGE, map);
		return list;
	}

	@Override
	public List<Map<String, Object>> queryGroupRank() {
		// TODO Auto-generated method stub
		List<Map<String, Object>> list = dao.selectList(COMMON_GROUP_RANK + QUERY_LIST_PAGE, "");
		return list;
	}

	@Override
	public List<Map<String, Object>> queryFinancePolicyFlag() {
		// TODO Auto-generated method stub
		List<Map<String, Object>> list = dao.selectList(COMMON_FINANCE_POLICY + QUERY_LIST_PAGE, "");

		return list;
	}

  @Override
  public String getCalcMonth() {
    return dao.selectOne(COMMON_PROPERTY + ".queryCalcMonth", "");
  }
	
	/**
	 * <pre>
	 * 取登录用户在UM的角色
	 * @return
	 * </pre>
	 *//*
	@Override
	public  String getUserDept() {
		String currentUser = CurrentUser.getUser().getUserCode();
		// 用户所在机构
		List<Map<String, Object>> detplist = umService.findDeptListByUserCode(currentUser);
		if (detplist == null || detplist.size() == 0) {
			throw new RuntimeException("登录用户" + currentUser + "在UM系统没有分配结构!");
		}
		String deptCode = (String) detplist.get(0).get("deptCode");
		// 如果是总公司用户
		if (deptCode != null && "00".equals(deptCode.substring(0, 2))) {
			deptCode = "";
		}
		return deptCode;
	}*/
}
