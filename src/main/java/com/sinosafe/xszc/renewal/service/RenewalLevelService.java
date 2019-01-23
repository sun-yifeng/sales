package com.sinosafe.xszc.renewal.service;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.util.PageDto;

public interface RenewalLevelService
{

	public PageDto findRenewalLevelByWhere(PageDto pd,String action);

	public Map<String, Object> findRenewalLevelDetailByWhere(Map<String, Object> whereMap);
	
	public Boolean saveRenewalLevel(Map<String, Object> paraMap);
	
	public Boolean deleteRenewalLevelByIds(String[] noticIdArray) throws ParseException;

	public boolean RenewalLevelValidate(String deptCode);

	public int findRenewalLevelRoleByUser(Map<String,Object> map);
	
}
