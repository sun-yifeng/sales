package com.sinosafe.xszc.partner.service;

import java.util.Map;

import com.sinosafe.xszc.util.PageDto;

public interface IndividualService {

	public PageDto findIndividualByWhere(PageDto pageDto);

	public Map<String, Object> findIndividualByPk(String channelCode);

	public void saveIndividual(Map<String, Object> paramMap);

	public void updateIndividual(Map<String, Object> paramMap);
	
}
