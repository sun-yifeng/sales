package com.sinosafe.xszc.report.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REPORT_MONTH_AGENT_INFO;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.report.service.ReportMonthAgentInfoService;
import com.sinosafe.xszc.util.PageDto;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.AGENT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM;

public class ReportMonthAgentInfoServiceImpl implements ReportMonthAgentInfoService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findReportMonthAgentInfoByWhere(PageDto pageDto) {
		Long total = dao.selectOne(REPORT_MONTH_AGENT_INFO + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(REPORT_MONTH_AGENT_INFO + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}


	@Override
	public PageDto queryDataToExcel(PageDto pageDto) {
		Long total = dao.selectOne(REPORT_MONTH_AGENT_INFO + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", total);
		List<Map<String, Object>> rows = dao.selectList(REPORT_MONTH_AGENT_INFO + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}


	@Override
	public String findChannelNameByAgentCode(String agentCode) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("channelCode", agentCode);
		List<Map<String, Object>> rows1 = dao.selectList(AGENT + ".findChannelNameByCode1", map);
		String channelName = "";
		if(rows1 != null && rows1.size() == 1){
			channelName = (String) rows1.get(0).get("channelName");
		}else if(rows1 == null || rows1.size()==0){
			List<Map<String,Object>> rows2 = dao.selectList(MEDIUM+".findChannelNameByCode2", map);
			if(rows2 !=null && rows2.size() == 1){
				channelName = (String) rows2.get(0).get("mediumCname");
			}
		}
		return channelName;
	}

}
