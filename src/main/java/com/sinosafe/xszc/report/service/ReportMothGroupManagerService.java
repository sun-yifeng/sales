package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportMothGroupManagerService {

	PageDto findReportMonthAgentInfoByWhere(PageDto pageDto);
	
	public PageDto queryDataToExcel(PageDto pageDto);
}
