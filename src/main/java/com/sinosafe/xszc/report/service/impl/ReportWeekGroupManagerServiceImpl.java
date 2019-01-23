package com.sinosafe.xszc.report.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_DEPT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_PARENT_DEPT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REPORT_WEEK_GROUP_MANAGER;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.report.service.ReportWeekGroupManagerService;
import com.sinosafe.xszc.util.PageDto;

public class ReportWeekGroupManagerServiceImpl implements ReportWeekGroupManagerService{

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findReportWeekGroupManagerByWhere(PageDto pageDto) {
		Long total = dao.selectOne(REPORT_WEEK_GROUP_MANAGER + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REPORT_WEEK_GROUP_MANAGER + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	@Override
	public PageDto queryParentDept(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(REPORT_WEEK_GROUP_MANAGER + QUERY_PARENT_DEPT, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto queryDeptName(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(REPORT_WEEK_GROUP_MANAGER + QUERY_DEPT, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}


	@Override
	public PageDto queryDataToExcel(PageDto pageDto) {
		// TODO Auto-generated method stub
		Long total = dao.selectOne(REPORT_WEEK_GROUP_MANAGER + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", total);
		List<Map<String, Object>> rows = dao.selectList(REPORT_WEEK_GROUP_MANAGER + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
}
