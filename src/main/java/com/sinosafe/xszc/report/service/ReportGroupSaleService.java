package com.sinosafe.xszc.report.service;

import com.sinosafe.xszc.util.PageDto;

public interface ReportGroupSaleService {

	public PageDto findReportDayGroupSaleByWhere(PageDto pageDto);

	public PageDto findReportWeekGroupSaleByWhere(PageDto pageDto);

	public PageDto findReportMonthGroupSaleByWhere(PageDto pageDto);

	public PageDto queryReportDayToExcel(PageDto pageDto);

	public PageDto queryReportWeekToExcel(PageDto pageDto);

	public PageDto queryReportMonthToExcel(PageDto pageDto);
	
}
