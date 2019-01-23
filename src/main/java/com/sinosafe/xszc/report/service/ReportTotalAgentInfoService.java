package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportTotalAgentInfoService {

	PageDto findReportDayAgentChannelByWhere(PageDto pageDto);

	PageDto queryDataToExcel(PageDto pageDto);

}
