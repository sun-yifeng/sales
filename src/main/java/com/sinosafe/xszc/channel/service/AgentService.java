package com.sinosafe.xszc.channel.service;


import java.util.Map;

import com.sinosafe.xszc.channel.vo.ChannelAgentDetail;
import com.sinosafe.xszc.channel.vo.ChannelMain;
import com.sinosafe.xszc.util.PageDto;

public interface AgentService {

	public PageDto findAgentByWhere(PageDto pageDto);

	public void saveAgent(ChannelMain channelMain,ChannelAgentDetail channelAgentDetail,String uploadId);

	public PageDto findAgentsByWhere(PageDto pageDto);

	public void updateAgent(Map<String, Object> whereMap,ChannelMain channelMain,ChannelAgentDetail channelAgentDetail,String uploadId);

	public Boolean queryChannelCode(String channelCodeformMap);

	public void deleteChannelAgents(String channelCode);
	
	public boolean queryChannelLicenseValid(String deptCode);

}
