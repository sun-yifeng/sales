package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_CONTECT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ID_LIST;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.channel.service.MediumContectService;
import com.sinosafe.xszc.channel.vo.ChannelMediumContact;
import com.sinosafe.xszc.util.PageDto;

public class MediumContectServiceImpl implements MediumContectService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public void saveMediumContect(ChannelMediumContact mediumContect) {
		// TODO Auto-generated method stub
		dao.insert(MEDIUM_CONTECT + INSERT_VO, mediumContect);
	}

	@Override
	public PageDto findMediumContectByWhere(PageDto pageDto) {
		Long total = dao.selectOne(MEDIUM_CONTECT + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_CONTECT + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void updateMediumContect(ChannelMediumContact mediumContect) {
		dao.update(MEDIUM_CONTECT + UPDATE_VO, mediumContect);
	}

	@Override
	public void deleteMediumContect(Map<String,Object> map) {
		// TODO Auto-generated method stub
		dao.update(MEDIUM_CONTECT + DELETE_BY_ID, map);
	}

	@Override
	public List<ChannelMediumContact> queryIdList(String channelCode) {
		// TODO Auto-generated method stub
		List<ChannelMediumContact> list = dao.selectList(MEDIUM_CONTECT + QUERY_ID_LIST, channelCode);
		return list;
	}
}
