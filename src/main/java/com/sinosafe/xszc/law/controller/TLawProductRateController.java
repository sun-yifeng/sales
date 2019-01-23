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
import com.sinosafe.xszc.law.service.TLawProductRateService;
import com.sinosafe.xszc.law.vo.TLawProductRate;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/tLawProductRate")
public class TLawProductRateController {

	private static final Log log = LogFactory.getLog(TLawProductRateController.class);
	
	@Autowired
	@Qualifier("TLawProductRateService")
	private TLawProductRateService tLawProductRateService;
	
	@RequestMapping("/queryTLawProductRate")
	public void queryTLawProductRate(HttpServletRequest request,HttpServletResponse response,FormDto dto) throws ServiceException{
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try{
			pageDto = tLawProductRateService.findTLawProductRateByWhere(pageDto);
		}catch(Exception e){
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/saveTLawProductRate")
	public void saveTLawLineRate(HttpServletRequest request, HttpServletResponse response, TLawProductRate tLawProductRate) throws GeneralException {
		try {
			tLawProductRateService.saveTLawProductRate(tLawProductRate);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tLawProductRate), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	@RequestMapping("/queryTLawProductRateToUpdate")
	public void queryTLawProductRateToUpdate (HttpServletRequest request, HttpServletResponse response, String productRateId) throws ServiceException{
		List<Map<String,Object>>rows;
		try{
			rows = tLawProductRateService.queryTLawProductRateToUpdate(productRateId); 
		}catch(Exception e){
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + productRateId, e);
		}
		SendUtil.sendJSON(response, rows);
	}
	
	@RequestMapping("/deleteTLawProductRate")
	public void deleteTLawProductRate(HttpServletRequest request, HttpServletResponse response, String productRateId) throws ServiceException{
		try {
			tLawProductRateService.deleteTLawLineRate(productRateId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + productRateId, e);
		}
		SendUtil.sendJSON(response, "success");
	}
}
