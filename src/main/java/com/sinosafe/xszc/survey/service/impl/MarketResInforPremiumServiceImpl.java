package com.sinosafe.xszc.survey.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MARKET_RESINFOR_PREMIUM;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.survey.service.MarketResInforMainService;
import com.sinosafe.xszc.survey.service.MarketResInforPremiumService;
import com.sinosafe.xszc.survey.vo.MarketResInforMain;
import com.sinosafe.xszc.survey.vo.MarketResInforPremium;
import com.sinosafe.xszc.util.PageDto;

public class MarketResInforPremiumServiceImpl implements MarketResInforPremiumService{

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Autowired
	@Qualifier("MarketResInforMainService")
	private MarketResInforMainService marketResInforMainService;
	
	@Override
	public void saveMarketResInforPremium(MarketResInforPremium marketPremium) {
		dao.insert(MARKET_RESINFOR_PREMIUM + INSERT_VO, marketPremium);
	}

	@Override
	public List<MarketResInforPremium> queryAllMarketResInforPremium(PageDto pageDto) {
		Long total = dao.selectOne(MARKET_RESINFOR_PREMIUM + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<MarketResInforPremium> list = dao.selectList(MARKET_RESINFOR_PREMIUM + QUERY_LIST_PAGE,pageDto.getWhereMap());
		return list;
	}

	@Override
	public MarketResInforMain queryMarketResInforPremiumByVo(MarketResInforMain marketResInforMain) {
		List<MarketResInforPremium> marketResInforMainList = new ArrayList<MarketResInforPremium>();
		MarketResInforMain marketResInforMains = marketResInforMainService.selectByPrimaryKey(marketResInforMain);
		Map<String,String> map = new HashMap<String, String>();
		map.put("pkId", marketResInforMains.getPkId());
		List<MarketResInforPremium> list = dao.selectList(MARKET_RESINFOR_PREMIUM +QUERY_ONE_VO, map);
		for (MarketResInforPremium marketResInforPremium : list) {
			marketResInforMainList.add(marketResInforPremium);
		}
		marketResInforMains.setMarketResInforPremium(marketResInforMainList);
		return marketResInforMains;
	}
	
	@Override
	public List<Map<String,Object>> queryMarketResInforPremiumByVo(String pkId) {
		List<Map<String,Object>> list = dao.selectList(MARKET_RESINFOR_PREMIUM +QUERY_ONE_VO, pkId);
		return list;
	}
}
