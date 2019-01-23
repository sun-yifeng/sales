package com.sinosafe.xszc.partner.service;

import java.util.Map;

import com.sinosafe.xszc.partner.vo.Confer;
import com.sinosafe.xszc.util.PageDto;

public interface ConferService {

	public PageDto findConferByWhere(PageDto pageDto);

	public Map<String, Object> findEnterpriseConferByPk(String channelCode);
	
	public Map<String, Object> findIndividualConferByPk(String channelCode);

	public void saveConfer(Confer confer);

	public void updateConfer(Confer confer, String updateFlag);

}
