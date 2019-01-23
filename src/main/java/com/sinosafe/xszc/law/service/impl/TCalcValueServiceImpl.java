package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_CALC_VALUE;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.law.service.TCalcValueService;
import com.sinosafe.xszc.util.PageDto;

public class TCalcValueServiceImpl implements TCalcValueService {
	
	private static final Log log = LogFactory.getLog(TCalcValueServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Override
	public PageDto findTCalcValueByWhere(PageDto pageDto) {
		log.debug("TCalcValueServiceImpl  findTCalcValueByWhere start.....");
		Long total = dao.selectOne(T_CALC_VALUE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(T_CALC_VALUE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		log.debug("TCalcValueServiceImpl  findTCalcValueByWhere end.....");
		return pageDto;
	}

}
