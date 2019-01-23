package com.sinosafe.xszc.channel.service;

import java.util.Map;

import com.sinosafe.xszc.channel.vo.ChannelMain;
import com.sinosafe.xszc.util.PageDto;

public interface ChannelMainService {

	public void saveChannelMain(ChannelMain channelMain);

	public PageDto findChannelMainsByWhere(PageDto pageDto);

	public void updateChannelMain(ChannelMain channelMain);

	public Map<String, String> processMediums(String channelCodes);
	
	public Map<String, String> channelSync(String[] channelCodes);
	
	public PageDto queryAgentALL(PageDto pageDto);
	
	public PageDto queryDataToExcel(PageDto pageDto);

}
