package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportMonthRemotePolicyService {

	PageDto findReportMonthRemotePolicyByWhere(PageDto pageDto);

	PageDto queryDataToExcel(PageDto pageDto);


}
