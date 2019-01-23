package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LISTS_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSON;
import com.hf.framework.core.context.PlatformContext;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.mail.MailService;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.channel.service.ChannelMainService;
import com.sinosafe.xszc.channel.vo.ChannelMain;
import com.sinosafe.xszc.group.service.SalesmanService;
import com.sinosafe.xszc.util.PageDto;

public class ChannelMainServiceImpl implements ChannelMainService {

	private static final Log log = LogFactory.getLog(ChannelMainServiceImpl.class);

	public static final String MAIL_FROM = (String) PlatformContext.getGoalbalContext("mail.username");

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "mailService")
	private MailService mailService;

	@Autowired
	@Qualifier(value = "SalesmanService")
	private SalesmanService salesmanService;

	@Override
	public void saveChannelMain(ChannelMain channelMain) {
		// 保存中介机构/代理人主表信息
		dao.insert(CHANNEL + INSERT_VO, channelMain);
	}

	@Override
	public PageDto findChannelMainsByWhere(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(CHANNEL + QUERY_LISTS_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void updateChannelMain(ChannelMain channelMain) {
		// 修改中介机构/代理人主表信息
		dao.update(CHANNEL + UPDATE_VO, channelMain);
	}

	@Override
	public Map<String, String> processMediums(String channelCodes) {
		String userCode = CurrentUser.getUser().getUserCode();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("approveFlag", '1');
		map.put("approveCode", userCode);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		map.put("channelCodes", channelCodes.split(","));
		dao.update(CHANNEL + ".approveChannel", map);
		return channelSync(channelCodes.split(","));
	}

	/**
	 * 功能说明：审核渠道时，同步数据到核心系统 <br>
	 * 1、页面做了控制，一次只能审核一条数据。<br>
	 * 1、如果有多条记录，只审核一条记录。<br>
	 */
	@Override
	public Map<String, String> channelSync(String[] channelCodes) {
		String resultMsg = "";
		Map<String, String> resultmap = new HashMap<String, String>();
		log.debug("审核渠道，页面传入参数:" + JSON.toJSONString(channelCodes));
		resultmap.put("channelCode", channelCodes[0]);
		log.debug("审核渠道，调用存过参数:" + JSON.toJSONString(resultmap));
		dao.selectOne(CHANNEL + ".callChaSync", resultmap); // 同步数据到核心系统
		if (resultmap.get("flag").equals("-1")) {
			resultMsg += "审核失败的原因：" + (String) resultmap.get("msg");
		}
		resultmap.put("msg", resultMsg);
		log.debug("渠道审核结果:" + resultMsg);
		return resultmap;
	}

	@Override
	public PageDto queryAgentALL(PageDto pageDto) {
		   Long count = dao.selectOne(CHANNEL + ".queryAgentALLCount", pageDto.getWhereMap());
		   pageDto.setTotal((long)count);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> rows = dao.selectList(CHANNEL + ".queryAgentALL", pageDto.getWhereMap());
			pageDto.setRows(rows);
			return pageDto;
		}

	@Override
	public PageDto queryDataToExcel(PageDto pageDto) {
		  Long count = dao.selectOne(CHANNEL + ".queryAgentALLCount", pageDto.getWhereMap());
		   pageDto.setTotal((long)count);
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> rows = dao.selectList(CHANNEL + ".queryAgentALLExcel", pageDto.getWhereMap());
			pageDto.setRows(rows);
			return pageDto;
			}
	
}
