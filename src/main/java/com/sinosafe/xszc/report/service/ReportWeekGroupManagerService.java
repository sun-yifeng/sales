package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportWeekGroupManagerService {
	
	PageDto findReportWeekGroupManagerByWhere(PageDto pageDto);
	
	public PageDto queryParentDept(PageDto pageDto);

	public PageDto queryDeptName(PageDto pageDto);

	public PageDto queryDataToExcel(PageDto pageDto);
	
	

}
