package com.sinosafe.xszc.survey.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MARKET_RESINFOR_CHANNEL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MARKET_RESINFOR_LOCAL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MARKET_RESINFOR_MAIN;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MARKET_RESINFOR_PREMIUM;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.hf.framework.util.UUIDGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.survey.service.MarketResInforChannelService;
import com.sinosafe.xszc.survey.service.MarketResInforLocalService;
import com.sinosafe.xszc.survey.service.MarketResInforMainService;
import com.sinosafe.xszc.survey.service.MarketResInforPremiumService;
import com.sinosafe.xszc.survey.vo.MarketResInforChannel;
import com.sinosafe.xszc.survey.vo.MarketResInforLocal;
import com.sinosafe.xszc.survey.vo.MarketResInforMain;
import com.sinosafe.xszc.survey.vo.MarketResInforPremium;
import com.sinosafe.xszc.util.PageDto;

public class MarketResInforMainServiceImpl implements MarketResInforMainService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Autowired
	@Qualifier("MarketResInforChannelService")
	private MarketResInforChannelService marketResInforChannelService;
	
	@Autowired
	@Qualifier("MarketResInforLocalService")
	private MarketResInforLocalService marketResInforLocalService;
	
	@Autowired
	@Qualifier("MarketResInforPremiumService")
	private MarketResInforPremiumService marketResInforPremiumService;
	
	@Override
	public boolean saveMarketResInforMain(MarketResInforMain marketResInforMain) {
		boolean flag = false;
		marketResInforMain.setValidInd("1");
		marketResInforMain.setPkId(UUIDGenerator.getUUID());
		String username = CurrentUser.getUser().getUserCode();
		if(marketResInforMain.getCreateUser() == null){
			marketResInforMain.setCreateUser(username);
			marketResInforMain.setUpdateUser(username);
			marketResInforMain.setValidInd("1");
			dao.insert(MARKET_RESINFOR_MAIN + INSERT_VO, marketResInforMain);
		}
		for(MarketResInforChannel marketChannel : marketResInforMain.getMarketResInforChannel()){
			marketChannel.setChannelPremiumId(UUIDGenerator.getUUID());
			marketChannel.setDeptCode(marketResInforMain.getDeptCode());
			marketChannel.setMainId(marketResInforMain.getPkId());
			marketChannel.setInsertMonth(marketResInforMain.getInsertMonth());
			marketChannel.setValidInd("1");
			marketChannel.setCreateUser(username);
			marketChannel.setUpdateUser(username);
			marketResInforChannelService.saveMarketResInforChannel(marketChannel);
		}
		for(MarketResInforLocal marketLocal : marketResInforMain.getMarketResInforLocal()){
			marketLocal.setLocalMarketId(UUIDGenerator.getUUID());
			marketLocal.setMainId(marketResInforMain.getPkId());
			marketLocal.setInsertMonth(marketResInforMain.getInsertMonth());
			marketLocal.setDeptCode(marketResInforMain.getDeptCode());
			marketLocal.setValidInd("1");
			marketLocal.setCreateUser(username);
			marketLocal.setUpdateUser(username);
			marketResInforLocalService.saveMarketResInforLocal(marketLocal);
		}
		for(MarketResInforPremium marketPremium : marketResInforMain.getMarketResInforPremium()){
			marketPremium.setSameIndusPremiumId(UUIDGenerator.getUUID());
			marketPremium.setMainId(marketResInforMain.getPkId());
			marketPremium.setInsertMonth(marketResInforMain.getInsertMonth());
			marketPremium.setDeptCode(marketResInforMain.getDeptCode());
			marketPremium.setValidInd("1");
			marketPremium.setCreateUser(username);
			marketPremium.setUpdateUser(username);
			marketResInforPremiumService.saveMarketResInforPremium(marketPremium);
		}
		
		return flag;
	}

	@Override
	public List<MarketResInforMain> queryAllMarketResInforMain(PageDto pageDto) {
		Long total = dao.selectOne(MARKET_RESINFOR_MAIN + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<MarketResInforMain> list = dao.selectList(MARKET_RESINFOR_MAIN + QUERY_LIST_PAGE,pageDto.getWhereMap());
		return list;
	}

	@Override
	public PageDto findMarketResInforMainByWhere(PageDto pageDto) {
		Long total = dao.selectOne(MARKET_RESINFOR_MAIN + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MARKET_RESINFOR_MAIN + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public MarketResInforMain selectByPrimaryKey(MarketResInforMain marketResInforMain) {
		MarketResInforMain mrfm = (MarketResInforMain)dao.selectOne(MARKET_RESINFOR_MAIN + QUERY_ONE_VO, marketResInforMain.getPkId());
		return mrfm;
	}
	
	@Override
	public MarketResInforMain queryMarketResInforMainByVo(MarketResInforMain marketResInforMain) {
			List<MarketResInforChannel> marketResInforChannel = new ArrayList<MarketResInforChannel>();
			List<MarketResInforLocal> marketResInforLocal = new ArrayList<MarketResInforLocal>();
			List<MarketResInforPremium> marketResInforPremium = new ArrayList<MarketResInforPremium>();
			MarketResInforMain marketResInforMains = this.selectByPrimaryKey(marketResInforMain);
			List<MarketResInforChannel> marketResInforChannelList = dao.selectList(MARKET_RESINFOR_CHANNEL +QUERY_ONE, marketResInforMains.getPkId());
			List<MarketResInforLocal> marketResInforLocalList = dao.selectList(MARKET_RESINFOR_LOCAL +QUERY_ONE, marketResInforMains.getPkId());
			List<MarketResInforPremium> marketResInforPremiumList = dao.selectList(MARKET_RESINFOR_PREMIUM +QUERY_ONE, marketResInforMains.getPkId());
			for(MarketResInforChannel mric : marketResInforChannelList){
				marketResInforChannel.add(mric);
			}
			for(MarketResInforLocal mril : marketResInforLocalList){
				marketResInforLocal.add(mril);
			}
			for(MarketResInforPremium mrip : marketResInforPremiumList){
				marketResInforPremium.add(mrip);
			}
			return marketResInforMains;
		}
	
	
	@Override
	public boolean deleteMarketResInforMain(String pkId) {
		boolean flag = false ;
		dao.update(MARKET_RESINFOR_MAIN + ".deleteByPkId", pkId);
		dao.update(MARKET_RESINFOR_CHANNEL + ".deleteByPkId", pkId);
		dao.update(MARKET_RESINFOR_LOCAL + ".deleteByPkId", pkId);
		dao.update(MARKET_RESINFOR_PREMIUM + ".deleteByPkId", pkId);
		flag = true ;
		return flag;
	}
}
