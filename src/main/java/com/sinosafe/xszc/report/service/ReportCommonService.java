package com.sinosafe.xszc.report.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.util.PageDto;

public interface ReportCommonService {

	public List<Map<String, Object>> findInfo(Map<String, Object> requestMap);

	public List<Map<String, Object>> getOptions(Map<String, Object> requestMap);

	public PageDto queryReportList(PageDto pageDto);

	public Map<String, Object> getReportSql(PageDto pageDto);

	public PageDto queryDayGroupReportList(PageDto pageDto);

	public PageDto queryMonthGroupReportList(PageDto pageDto);

	public PageDto queryMonthGroupPaihangList(PageDto pageDto);

	Map<String, Object> getCurUserGroupMsg();

}
