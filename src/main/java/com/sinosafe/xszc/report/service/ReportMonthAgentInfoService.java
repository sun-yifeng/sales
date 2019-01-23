package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportMonthAgentInfoService {
	
	public PageDto findReportMonthAgentInfoByWhere(PageDto pageDto);
	  
	public PageDto queryDataToExcel(PageDto pageDto);

	public String findChannelNameByAgentCode(String agentCode);

}
