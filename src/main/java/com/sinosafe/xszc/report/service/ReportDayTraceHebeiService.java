package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportDayTraceHebeiService {

	public PageDto findReportDayTraceHebeiByWhere(PageDto pageDto);
  
	public PageDto queryDataToExcel(PageDto pageDto);
	
}
