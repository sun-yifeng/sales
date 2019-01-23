package com.sinosafe.xszc.channel.controller;

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
import com.sinosafe.xszc.channel.service.MediumHistoryService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/mediumHistory")
public class MediumHistoryController {

	private static final Log log = LogFactory.getLog(MediumHistoryController.class);
	
	@Autowired
	@Qualifier("MediumHistoryService")
	private MediumHistoryService mediumHistoryService;
	
	/**
	 * 中介机构历史轨迹列表及自定义查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediumHistory")
	@VisitDesc(label="中介机构历史轨迹列表及自定义查询",actionType=4)
	public void queryMediumHistory(HttpServletRequest request, HttpServletResponse response,FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumHistoryService.findMediumByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 中介机构历史轨迹详情
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediumHistorys")
	@VisitDesc(label="中介机构历史轨迹详情",actionType=4)
	public void queryMediumHistorys(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumHistoryService.findMediumsByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}
}
