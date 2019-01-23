package com.sinosafe.xszc.survey.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.survey.vo.MarketResInforMain;
import com.sinosafe.xszc.util.PageDto;

public interface MarketResInforMainService {

	public List<MarketResInforMain> queryAllMarketResInforMain(PageDto pageDto);

	boolean saveMarketResInforMain(MarketResInforMain marketResInforMain);
	
	public PageDto findMarketResInforMainByWhere(PageDto pageDto);

	public MarketResInforMain selectByPrimaryKey(MarketResInforMain marketResInforMain);

	MarketResInforMain queryMarketResInforMainByVo( MarketResInforMain marketResInforMain);

	public boolean deleteMarketResInforMain(String pkId);
}
