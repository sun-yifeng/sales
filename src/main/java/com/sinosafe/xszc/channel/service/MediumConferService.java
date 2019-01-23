package com.sinosafe.xszc.channel.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.channel.vo.ChannelConfer;
import com.sinosafe.xszc.util.PageDto;


public interface MediumConferService {

	void saveMediumConfer(ChannelConfer confer,String uploadId);

	void updateMediumConfer(ChannelConfer confer,String uploadId,String updateFlag);

	PageDto findMediumConferByWhere(PageDto pageDto);

	PageDto findMediumConfersByWhere(PageDto pageDto);

	void deleteMediumConfer(String conferCode);

	PageDto findAgentConferByWhere(PageDto pageDto);

	PageDto findAgentConfersByWhere(PageDto pageDto);

	Boolean queryConferCode(String conferCode);

	PageDto findMediumConferHistorysByWhere(PageDto pageDto);

	List<Map<String, Object>> findMediumConferHistoryByWhere(PageDto pageDto);

	PageDto findAgentConferHistorysByWhere(PageDto pageDto);

	List<Map<String, Object>> findAgentConferHistoryByWhere(PageDto pageDto);

	Map<String, String> processConfers(String conferCodes, String channelCode);
	
	

}
