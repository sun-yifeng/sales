package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportDaySaleTraceService {

	public PageDto findReportDaySaleTraceByWhere(PageDto pageDto);

	public PageDto queryDataToExcel(PageDto pageDto);
	
}
