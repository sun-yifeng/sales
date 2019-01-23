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
import com.sinosafe.xszc.law.service.TRankCalcService;
import com.sinosafe.xszc.law.vo.TRankCalc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/tRankCalc")
public class TRankCalcController {

	private static final Log log = LogFactory.getLog(TRankCalcController.class);

	@Autowired
	@Qualifier("TRankCalcService")
	private TRankCalcService tRankCalcService;
	
	@RequestMapping("/queryTRankCalc")
	public void queryTRankCalc(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = tRankCalcService.findTRankCalcByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	/**
	 * 		新增职级计算公式
	 * @param request
	 * @param response
	 * @param lawBank
	 * @throws GeneralException
	 */
	@RequestMapping("/saveTRankCalc")
	public void saveTRankCalc(HttpServletRequest request, HttpServletResponse response, TRankCalc tRankCalc) throws GeneralException {
		tRankCalc.setLastOpt(CurrentUser.getUser().getUserCode());
		tRankCalc.setChannelId("1");
		tRankCalc.setValidInd("1");
		//tRankCalc.setVersionId("1");
		//tRankCalc.setCondType("1");
		//tRankCalc.setChangeType("1");
	if( "".equals(tRankCalc.getSerno()) ||  tRankCalc.getSerno() == null){
			//获取最大流水号加 1
			String number = tRankCalcService.getSerialNumber().toString();
			tRankCalc.setSerno(number);
		}
		try {//在sql  insertVo语句中关联T_INDEX_DEF表  
			tRankCalcService.saveTRankCalc(tRankCalc);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tRankCalc), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	/**
	 * 		修改计算
	 * @param request
	 * @param response
	 * @param serno
	 * @throws GeneralException
	 */
	@RequestMapping("/queryTRankCalcToUpdate")
	public void queryTRankCalcToUpdate(HttpServletRequest request, HttpServletResponse response, String serno) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = tRankCalcService.queryTRankCalcToUpdate(serno);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + serno, e);
		}
		SendUtil.sendJSON(response, rows);
	}
	
	@RequestMapping("/deleteTRankCalc")
	public void deleteTIndexCalc(HttpServletRequest request, HttpServletResponse response,String  serno) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		TRankCalc tRankCalc = new TRankCalc();
		tRankCalc.setSerno(serno);
		try {
			tRankCalcService.deleteTRankCalc(tRankCalc);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tRankCalc), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
}
