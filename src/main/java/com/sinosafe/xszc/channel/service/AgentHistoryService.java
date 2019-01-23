package com.sinosafe.xszc.channel.service;


import com.sinosafe.xszc.util.PageDto;

public interface AgentHistoryService {

	public PageDto findAgentByWhere(PageDto pageDto);

	public PageDto findAgentsByWhere(PageDto pageDto);
}
