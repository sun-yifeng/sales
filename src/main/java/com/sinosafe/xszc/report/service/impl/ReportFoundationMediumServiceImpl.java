package com.sinosafe.xszc.report.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT_New;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REPORT_FOUNDATION_MEDIUM;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.report.service.ReportFoundationMediumService;
import com.sinosafe.xszc.util.PageDto;

public class ReportFoundationMediumServiceImpl implements ReportFoundationMediumService {

	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	
	@Override
	public PageDto findReportDayAgentChannelByWhere(PageDto pageDto) {
		// TODO Auto-generated method stub
		Long total = dao.selectOne(REPORT_FOUNDATION_MEDIUM + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal((long)0);
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", total);
		List<Map<String, Object>> rows = dao.selectList(REPORT_FOUNDATION_MEDIUM + ".queryRP", pageDto.getWhereMap());
		
		
		pageDto.setRows(rows);
		return pageDto;
	}
	
	@Override
	public PageDto findReportDayAgentChannelByWhereNew(PageDto pageDto) {
		// TODO Auto-generated method stub
		Long total = dao.selectOne(REPORT_FOUNDATION_MEDIUM + QUERY_COUNT_New, pageDto.getWhereMap());
		pageDto.setTotal((long)0);
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", total);
		List<Map<String, Object>> rows = dao.selectList(REPORT_FOUNDATION_MEDIUM + ".querybizorigin", pageDto.getWhereMap());
		
		
		pageDto.setRows(rows);
		return pageDto;
	}
	

}
