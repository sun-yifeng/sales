package com.sinosafe.xszc.channel.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.channel.vo.ChannelMediumContact;
import com.sinosafe.xszc.util.PageDto;


public interface MediumContectService {

	void saveMediumContect(ChannelMediumContact mediumContect);

	PageDto findMediumContectByWhere(PageDto pageDto);

	void updateMediumContect(ChannelMediumContact mediumContect);

	void deleteMediumContect(Map<String,Object> map);

	List<ChannelMediumContact> queryIdList(String channelCode);

}
