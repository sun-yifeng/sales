package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL_WARNING;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.mail.MailService;
import com.sinosafe.xszc.channel.service.ChannelWarningService;
import com.sinosafe.xszc.channel.vo.ChannelWarning;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.util.PageDto;

public class ChannelWarningServiceImpl implements ChannelWarningService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "DepartmentService")
	private DepartmentService departmentService;

	@Autowired
	@Qualifier(value = "mailService")
	private MailService mailService;

	/**
	 * 分页查询代理人合同预警
	 */
	@Override
	public PageDto findChannelWarningByWhere(PageDto pageDto) {
		Long total = dao.selectOne(CHANNEL_WARNING + ".queryAgentCounts", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(CHANNEL_WARNING + ".queryListPages", pageDto.getWhereMap());

		pageDto.setRows(rows);
		return pageDto;
	}

	/**
	 * 分页查询中介合同预警
	 */
	@Override
	public PageDto findChannelWarningMediumByWhere(PageDto pageDto) {
		Long total = dao.selectOne(CHANNEL_WARNING + ".queryCounts", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(CHANNEL_WARNING + ".queryListPageM", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	/**
	 * 单条数据详细
	 */
	@Override
	public PageDto findChannelWarningsByWhere(PageDto pageDto) {
		Long total = dao.selectOne(CHANNEL_WARNING + ".queryCounts", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(CHANNEL_WARNING + ".queryAgentWarningDetail", pageDto.getWhereMap());

		pageDto.setRows(rows);
		return pageDto;
	}

	/**
	 * 中介单条数据详细
	 */
	@Override
	public PageDto findChannelWarningsMediumByWhere(PageDto pageDto) {
		Long total = dao.selectOne(CHANNEL_WARNING + ".queryCounts", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(CHANNEL_WARNING + ".queryAgentWarningMedium", pageDto.getWhereMap());

		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void saveChannelWarning(ChannelWarning channelWarning) {
		dao.insert(CHANNEL_WARNING + INSERT_VO, channelWarning);
	}

	/**
	 * 新增中介机构预警
	 */
	@Override
	public void saveChannelWarningAgent(ChannelWarning channelWarning) {
		dao.insert(CHANNEL_WARNING + INSERT_VO, channelWarning);
	}

	/**
	 * 修改中介机构预警
	 */
	@Override
	public void updateChannelWarning(ChannelWarning channelWarning) {
		dao.update(CHANNEL_WARNING + UPDATE_VO, channelWarning);
	}

	@Override
	public List<Map<String, Object>> queryDeptAgent(Map<String, Object> userMap) {
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(CHANNEL + ".queryDeptAgent", userMap);
		return resultList;
	}

	@Override
	public void deleteChannelWarning(ChannelWarning channelWarning) {
		dao.update(CHANNEL_WARNING + DELETE_BY_ID, channelWarning);
	}

	@Override
	public List<Map<String, Object>> queryDeptMedium(Map<String, Object> mediumMap) {
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(CHANNEL + ".queryDeptMedium", mediumMap);
		return resultList;
	}

}
