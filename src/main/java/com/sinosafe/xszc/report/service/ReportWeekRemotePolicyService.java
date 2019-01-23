package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportWeekRemotePolicyService {

	PageDto queryDataToExcel(PageDto pageDto);

	PageDto findReportWeekRemotePolicyByWhere(PageDto pageDto);

}
