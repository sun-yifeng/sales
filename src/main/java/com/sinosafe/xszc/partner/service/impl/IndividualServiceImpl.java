package com.sinosafe.xszc.partner.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INDIVIDUAL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.partner.service.IndividualService;
import com.sinosafe.xszc.util.PageDto;

public class IndividualServiceImpl implements IndividualService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findIndividualByWhere(PageDto pageDto) {
		Long total = dao.selectOne(INDIVIDUAL + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(INDIVIDUAL + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Map<String, Object> findIndividualByPk(String channelCode) {
		Map<String, Object> resultMap = dao.selectOne(INDIVIDUAL + QUERY_ONE, channelCode);
		return resultMap;
	}

	@Override
	public void saveIndividual(Map<String, Object> paramMap) {
		paramMap.put("channelCode", getChannelCode(paramMap));
		dao.insert(INDIVIDUAL + ".insertChannelMain", paramMap);
		dao.insert(INDIVIDUAL + ".insertChannelAgent", paramMap);
	}

	@Override
	public void updateIndividual(Map<String, Object> paramMap) {
		dao.update(INDIVIDUAL + ".updateChannelMain", paramMap);
		dao.update(INDIVIDUAL + ".updateChannelAgent", paramMap);
	}

	public String getChannelCode(Map<String, Object> paramMap) {
		dao.insert(INDIVIDUAL + ".getChannelCode", paramMap); // 生成渠道代码
		return (String) paramMap.get("channelCode");
	}

}
