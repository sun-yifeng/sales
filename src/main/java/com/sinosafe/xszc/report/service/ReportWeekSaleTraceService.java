package com.sinosafe.xszc.report.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.util.PageDto;

public interface ReportWeekSaleTraceService {

	public PageDto findReportWeekSaleTraceByWhere(PageDto pageDto);

	public PageDto queryDataToExcel(PageDto pageDto);

	public List<Map<String,String>> queryBusiLine(String busiLineDict);
	
}
