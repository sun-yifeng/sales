package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportTotalGroupMenberService {
	
	public PageDto findReportTotalGroupMenberByWhere(PageDto pageDto);

	public PageDto queryDataToExcel(PageDto pageDto);
}
