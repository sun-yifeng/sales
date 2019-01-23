package com.sinosafe.xszc.report.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REPORT_DAY_GROUP_SALE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REPORT_WEEK_GROUP_SALE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REPORT_MONTH_GROUP_SALE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.report.service.ReportGroupSaleService;
import com.sinosafe.xszc.util.PageDto;

public class ReportGroupSaleServiceImpl implements ReportGroupSaleService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findReportDayGroupSaleByWhere(PageDto pageDto) {
		Long total = dao.selectOne(REPORT_DAY_GROUP_SALE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REPORT_DAY_GROUP_SALE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto findReportWeekGroupSaleByWhere(PageDto pageDto) {
		Long total = dao.selectOne(REPORT_WEEK_GROUP_SALE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REPORT_WEEK_GROUP_SALE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto findReportMonthGroupSaleByWhere(PageDto pageDto) {
		Long total = dao.selectOne(REPORT_MONTH_GROUP_SALE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REPORT_MONTH_GROUP_SALE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto queryReportDayToExcel(PageDto pageDto) {
		Long total = dao.selectOne(REPORT_DAY_GROUP_SALE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", total);
		List<Map<String, Object>> rows = dao.selectList(REPORT_DAY_GROUP_SALE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	
	@Override
	public PageDto queryReportWeekToExcel(PageDto pageDto) {
		Long total = dao.selectOne(REPORT_WEEK_GROUP_SALE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", total);
		List<Map<String, Object>> rows = dao.selectList(REPORT_WEEK_GROUP_SALE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	
	@Override
	public PageDto queryReportMonthToExcel(PageDto pageDto) {
		Long total = dao.selectOne(REPORT_MONTH_GROUP_SALE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", total);
		List<Map<String, Object>> rows = dao.selectList(REPORT_MONTH_GROUP_SALE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
}
