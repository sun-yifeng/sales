package com.sinosafe.xszc.channel.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.channel.vo.ChannelMain;
import com.sinosafe.xszc.channel.vo.ChannelMediumDetail;
import com.sinosafe.xszc.util.PageDto;

public interface MediumService {

	public PageDto findMediumByWhere(PageDto pageDto);

	public void saveMedium(ChannelMain channelMain,ChannelMediumDetail channelMediumDetail,String uploadId);

	public PageDto findMediumsByWhere(PageDto pageDto);

	public void updateMedium(Map<String, Object> whereMap,ChannelMain channelMain,ChannelMediumDetail channelMediumDetail,String uploadId);

	public List<Map<String, Object>> queryParentMedium(String deptCode);

	public Boolean queryChannelCode(String channelCodeformMap);

	public void deleteMediums(String channelCode);

	public PageDto queryParentChannel(PageDto pageDto);
	
	public PageDto queryMediumInfoByDeptCode(PageDto pageDto);
	
	public PageDto queryChooseMedium(PageDto pageDto);
	
}
