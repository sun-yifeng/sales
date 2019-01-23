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
import com.sinosafe.xszc.law.service.TIndexFactorService;
import com.sinosafe.xszc.law.vo.TIndexFactor;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/tIndexFactor")
public class TIndexFactorController {
	
	private static final Log log = LogFactory.getLog(TIndexFactorController.class);

	@Autowired
	@Qualifier("TIndexFactorService")
	private TIndexFactorService tIndexFactorService;
	
	/**
	 * 		分页查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryTIndexFactor")
	public void queryTIndexFactor(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = tIndexFactorService.findTIndexFactorByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 		新增指标因素关系
	 * @param request
	 * @param response
	 * @param TIndexFactor
	 * @throws GeneralException
	 */
	@RequestMapping("/saveTIndexFactor")
	public void saveTIndexFactor(HttpServletRequest request, HttpServletResponse response, TIndexFactor tIndexFactor) throws GeneralException {
		tIndexFactor.setLastOpt(CurrentUser.getUser().getUserCode());
		tIndexFactor.setChannelId("1");
		tIndexFactor.setValidInd("1");
		if( "".equals(tIndexFactor.getSerno()) ||  tIndexFactor.getSerno() == null){
			//获取最大流水号加 1
			String number = tIndexFactorService.getSerialNumber().toString();
			tIndexFactor.setSerno(number);
		}
		try {
			tIndexFactorService.savetIndexFactor(tIndexFactor);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tIndexFactor), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 		修改因素
	 * @param request
	 * @param response
	 * @param serno
	 * @throws GeneralException
	 */
	@RequestMapping("/queryTIndexFactorToUpdate")
	public void queryTIndexFactorToUpdate(HttpServletRequest request, HttpServletResponse response, String serno) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = tIndexFactorService.queryTIndexFactorToUpdate(serno);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + serno, e);
		}
		SendUtil.sendJSON(response, rows);
	}
	
	/**
	 * 删除
	 * @param request
	 * @param response
	 * @param serno
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteTIndexFactor")
	public void deleteTIndexFactor(HttpServletRequest request, HttpServletResponse response,String  serno) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		TIndexFactor tIndexFactor = new TIndexFactor();
		tIndexFactor.setSerno(serno);
		try {
			tIndexFactorService.deleteTIndexFactor(tIndexFactor);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tIndexFactor), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
}
