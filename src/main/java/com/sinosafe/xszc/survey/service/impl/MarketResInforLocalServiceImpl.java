package com.sinosafe.xszc.survey.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MARKET_RESINFOR_LOCAL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.survey.service.MarketResInforLocalService;
import com.sinosafe.xszc.survey.service.MarketResInforMainService;
import com.sinosafe.xszc.survey.vo.MarketResInforLocal;
import com.sinosafe.xszc.util.PageDto;

public class MarketResInforLocalServiceImpl  implements  MarketResInforLocalService{

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Autowired
	@Qualifier("MarketResInforMainService")
	private MarketResInforMainService marketResInforMainService;
	
	public void saveMarketResInforLocal(MarketResInforLocal marketLocal) {
		dao.insert(MARKET_RESINFOR_LOCAL + INSERT_VO, marketLocal);
	}

	@Override
	public List<MarketResInforLocal> queryAllMarketResInforLocal(PageDto pageDto) {
		Long total = dao.selectOne(MARKET_RESINFOR_LOCAL + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<MarketResInforLocal> list = dao.selectList(MARKET_RESINFOR_LOCAL + QUERY_LIST_PAGE,pageDto.getWhereMap());
		return list;
	}

	@Override
	public List<Map<String,Object>> queryMarketResInforLocalByVo(String pkId) {
		List<Map<String,Object>> list = dao.selectList(MARKET_RESINFOR_LOCAL +QUERY_ONE_VO, pkId);
		return list;
	}

}
