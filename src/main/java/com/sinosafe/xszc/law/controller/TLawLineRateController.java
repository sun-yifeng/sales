package com.sinosafe.xszc.law.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.law.service.TLawLineRateService;
import com.sinosafe.xszc.law.vo.TLawLineRate;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/tlawLineRate")
public class TLawLineRateController {

	private static final Log log = LogFactory.getLog(TLawLineRateController.class);
	
	@Autowired
	@Qualifier("TLawLineRateService")
	private TLawLineRateService tLawLineRateService;
	
	@RequestMapping("/queryTLawLineRate")
	public void queryTLawLineRate(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = tLawLineRateService.findTLawLineRateByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/saveTLawLineRate")
	public void saveTLawLineRate(HttpServletRequest request, HttpServletResponse response, TLawLineRate tLawLineRate) throws GeneralException {
		try {
			tLawLineRateService.saveTLawLineRate(tLawLineRate);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tLawLineRate), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	@RequestMapping("/queryTLawLineRateToUpdate")
	public void queryTLawLineRateToUpdate(HttpServletRequest request, HttpServletResponse response, String lineRateId) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = tLawLineRateService.queryTLawLineRateToUpdate(lineRateId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + lineRateId, e);
		}
		SendUtil.sendJSON(response, rows);
	}
	
	@RequestMapping("/deleteTLawLineRate")
	public void deleteTLawLineRate(HttpServletRequest request, HttpServletResponse response, String lineRateId) throws GeneralException {
		try {
			tLawLineRateService.deleteTLawLineRate(lineRateId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + lineRateId, e);
		}
		SendUtil.sendJSON(response, "success");
	}
}


