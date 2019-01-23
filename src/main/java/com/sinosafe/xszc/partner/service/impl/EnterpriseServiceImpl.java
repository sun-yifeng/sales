package com.sinosafe.xszc.partner.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.ENTERPISE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.partner.service.EnterpriseService;
import com.sinosafe.xszc.util.PageDto;

public class EnterpriseServiceImpl implements EnterpriseService {

	// private static final Log log = LogFactory.getLog(EnterpriseServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findEnterpriseByWhere(PageDto pageDto) {
		Long total = dao.selectOne(ENTERPISE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(ENTERPISE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Map<String, Object> findEnterpriseByPk(String channelCode) {
		Map<String, Object> resultMap = dao.selectOne(ENTERPISE + QUERY_ONE, channelCode);
		return resultMap;
	}

	@Override
	public void saveEnterprise(Map<String, Object> paramMap) {
		paramMap.put("channelCode", getChannelCode(paramMap));
		dao.insert(ENTERPISE + ".insertChannelMain", paramMap);
		dao.insert(ENTERPISE + ".insertChannelMedium", paramMap);
	}

	@Override
	public void updateEnterprise(Map<String, Object> paramMap) {
		dao.update(ENTERPISE + ".updateChannelMain", paramMap);
		dao.update(ENTERPISE + ".updateChannelMedium", paramMap);
	}

	public String getChannelCode(Map<String, Object> paramMap) {
		dao.insert(ENTERPISE + ".getChannelCode", paramMap); // 生成渠道代码
		return (String) paramMap.get("channelCode");
	}

}
