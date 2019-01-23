package com.sinosafe.xszc.survey.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.survey.vo.MarketResInforMain;
import com.sinosafe.xszc.survey.vo.MarketResInforPremium;
import com.sinosafe.xszc.util.PageDto;

public interface MarketResInforPremiumService {

	/*void saveMarketResInforPremium(MarketResInforMain marketResInforMain , MarketResInforPremium marketResInforPremium);
	 */
	public List<MarketResInforPremium> queryAllMarketResInforPremium(PageDto pageDto);

	MarketResInforMain queryMarketResInforPremiumByVo(MarketResInforMain marketResInforMain);

	List<Map<String,Object>> queryMarketResInforPremiumByVo(String pkId);

	void saveMarketResInforPremium(MarketResInforPremium marketPremium);
	
}
