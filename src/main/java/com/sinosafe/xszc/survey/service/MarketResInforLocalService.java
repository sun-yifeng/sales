package com.sinosafe.xszc.survey.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.survey.vo.MarketResInforLocal;
import com.sinosafe.xszc.util.PageDto;

public interface MarketResInforLocalService {
	
	void saveMarketResInforLocal(MarketResInforLocal marketLocal);
	//void saveMarketResInforChannel(MarketResInforMain marketInforMain,MarketResInforChannel marketResInforChannel);
	public List<MarketResInforLocal> queryAllMarketResInforLocal(PageDto pageDto);

	List<Map<String,Object>> queryMarketResInforLocalByVo(String pkId);
}
