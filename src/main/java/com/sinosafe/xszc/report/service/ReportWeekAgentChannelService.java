package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportWeekAgentChannelService {

	public PageDto findReportWeekAgentChannelByWhere(PageDto pageDto);

	public PageDto queryDataToExcel(PageDto pageDto);
	
}
