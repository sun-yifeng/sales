package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL_MAINTAIN;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ID_LIST;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.channel.service.ChannelMaintainService;
import com.sinosafe.xszc.channel.vo.ChannelMediumMaintain;
import com.sinosafe.xszc.util.PageDto;

public class ChannelMaintainServiceImpl implements ChannelMaintainService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public void saveChannelMaintain(ChannelMediumMaintain channelMaintain) {
		// TODO Auto-generated method stub
		dao.insert(CHANNEL_MAINTAIN + INSERT_VO, channelMaintain);
	}

	@Override
	public PageDto findChannelMaintainByWhere(PageDto pageDto) {
		Long total = dao.selectOne(CHANNEL_MAINTAIN + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(CHANNEL_MAINTAIN + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void updateChannelMaintain(ChannelMediumMaintain channelMaintain) {
		// TODO Auto-generated method stub
		dao.update(CHANNEL_MAINTAIN + UPDATE_PK_VO, channelMaintain);
	}

	@Override
	public List<ChannelMediumMaintain> queryIdList(String nodeCode) {
		// TODO Auto-generated method stub
		List<ChannelMediumMaintain> list = dao.selectList(CHANNEL_MAINTAIN + QUERY_ID_LIST, nodeCode);
		return list;
	}

	@Override
	public void deleteChannelMediumMaintain(Map<String, Object> map) {
		// TODO Auto-generated method stub
		dao.update(CHANNEL_MAINTAIN + DELETE_BY_ID, map);
	}
}
