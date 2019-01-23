package com.sinosafe.xszc.law.controller;

import java.io.IOException;
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
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.law.service.TLawOriginRateService;
import com.sinosafe.xszc.law.vo.TLawOriginRate;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/tLawOriginRate")
public class TLawOriginRateController {

	private static final Log log = LogFactory.getLog(TLawOriginRateController.class);
	
	@Autowired
	@Qualifier("TLawOriginRateService")
	private TLawOriginRateService tLawOriginRateService;
	
	/**
	 * 		分页查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/findTLawOriginRateByWhere")
	public void findTLawOriginRateByWhere(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = tLawOriginRateService.findTLawOriginRateByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 		新增
	 * @param request
	 * @param response
	 * @param TLawOriginRate
	 * @throws GeneralException
	 */
	@RequestMapping("/saveTLawOriginRate")
	public void saveTLawOriginRate(HttpServletRequest request, HttpServletResponse response, TLawOriginRate tLawOriginRate) throws GeneralException {
		try {
			tLawOriginRateService.saveTLawOriginRate(tLawOriginRate);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tLawOriginRate), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 		修改
	 * @param request
	 * @param response
	 * @param originRateId
	 * @throws GeneralException
	 */
	@RequestMapping("/queryTLawOriginRateToUpdate")
	public void queryTLawOriginRateToUpdate(HttpServletRequest request, HttpServletResponse response, String originRateId) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = tLawOriginRateService.queryTLawOriginRateToUpdate(originRateId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + originRateId, e);
		}
		SendUtil.sendJSON(response, rows);
	}
	
	/**
	 * 删除
	 * @param request
	 * @param response
	 * @param originRateId
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteTLawOriginRate")
	public void deleteTLawOriginRate(HttpServletRequest request, HttpServletResponse response,String  originRateId) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		TLawOriginRate tLawOriginRate = new TLawOriginRate();
		tLawOriginRate.setOriginRateId(originRateId);
		tLawOriginRate.setUpdatedUser(CurrentUser.getUser().getUserCode());
		try {
			tLawOriginRateService.deleteTLawOriginRate(tLawOriginRate);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tLawOriginRate), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
}
