package com.sinosafe.xszc.channel.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.channel.vo.ChannelMediumMaintain;
import com.sinosafe.xszc.util.PageDto;


public interface ChannelMaintainService {

	void saveChannelMaintain(ChannelMediumMaintain channelMaintain);

	PageDto findChannelMaintainByWhere(PageDto pageDto);

	void updateChannelMaintain(ChannelMediumMaintain channelMaintain);

	List<ChannelMediumMaintain> queryIdList(String nodeCode);

	void deleteChannelMediumMaintain(Map<String, Object> map);

}
