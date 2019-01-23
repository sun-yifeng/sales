package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportDayRemotePolicyService {

	PageDto queryDataToExcel(PageDto pageDto);

	PageDto findReportDayRemotePolicyByWhere(PageDto pageDto);

}
