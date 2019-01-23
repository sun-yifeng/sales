package com.sinosafe.xszc.partner.service;

import java.util.Map;

import com.sinosafe.xszc.util.PageDto;

public interface EnterpriseService {
	
	public PageDto findEnterpriseByWhere(PageDto pageDto);
	
	public Map<String, Object> findEnterpriseByPk(String channelCode);

	public void saveEnterprise(Map<String, Object> paramMap);
	
	public void updateEnterprise(Map<String, Object> paramMap);

}
