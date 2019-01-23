package com.sinosafe.xszc.survey.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.survey.vo.MarketResInforChannel;
import com.sinosafe.xszc.survey.vo.MarketResInforMain;
import com.sinosafe.xszc.util.PageDto;

public interface MarketResInforChannelService {
	
	/*void saveMarketResInforChannel(MarketResInforChannel marketResInforChannel);*/
	 
	public List<MarketResInforChannel> queryAllMarketResInforChannel(PageDto pageDto);
	 
	List<Map<String,Object>> queryMarketResInforChannelByVo(String pkId);

	void saveMarketResInforChannel(MarketResInforChannel marketResInforChannel);
}
