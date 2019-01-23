package com.sinosafe.xszc.channel.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.channel.vo.ChannelWarning;
import com.sinosafe.xszc.util.PageDto;

public interface ChannelWarningService {
	
	PageDto findChannelWarningByWhere(PageDto pageDto);
	
	PageDto findChannelWarningsByWhere(PageDto pageDto);
	
	void saveChannelWarning(ChannelWarning channelWarning);
	
	void updateChannelWarning(ChannelWarning channelWarning);
	
	void deleteChannelWarning(ChannelWarning channelWarning);
	
	//查询渠道机构部门下的所有代理人信息
	List<Map<String, Object>> queryDeptAgent(Map<String, Object> userMap);
	//查询渠道机构部门下的所有中介信息
	List<Map<String, Object>> queryDeptMedium(Map<String, Object>mediumMap);

	PageDto findChannelWarningMediumByWhere(PageDto pageDto);

	PageDto findChannelWarningsMediumByWhere(PageDto pageDto);

	void saveChannelWarningAgent(ChannelWarning channelWarning);
}
