package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportDayGroupManagerService {

	PageDto findReportDayGroupManagerByWhere(PageDto pageDto);

	PageDto queryDataToExcel(PageDto pageDto);
		
}
