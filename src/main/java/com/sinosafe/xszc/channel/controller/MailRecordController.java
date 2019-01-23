package com.sinosafe.xszc.channel.controller;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.channel.service.ChannelMailRecordService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/mailRecord")
public class MailRecordController {
private static final Log log = LogFactory.getLog(MediumConferController.class);
	
	@Autowired
	@Qualifier("ChannelMailRecordService")
	private ChannelMailRecordService channelMailRecordService;
	
	/**
	 * 预警记录查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/queryMailRecords")
	@VisitDesc(label="邮件预警记录查询",actionType=4)
	public void queryMailRecords(HttpServletRequest request,HttpServletResponse response, FormDto dto) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = channelMailRecordService.queryByPage(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
}
