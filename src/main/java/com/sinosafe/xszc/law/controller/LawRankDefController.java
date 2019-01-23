package com.sinosafe.xszc.law.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
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
import com.sinosafe.xszc.law.service.TRankDefService;
import com.sinosafe.xszc.law.vo.TRankDef;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/lawRank")
public class LawRankDefController {

	private static final Log log = LogFactory.getLog(LawRankDefController.class);

	@Autowired
	@Qualifier("TRankDefService")
	private TRankDefService tRankDefService;

	@RequestMapping("/queryLawRank")
	public void queryLawRank(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = tRankDefService.findLawRankByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/saveLawRank")
	public void saveLawRank(HttpServletRequest request, HttpServletResponse response, TRankDef tRankDef) throws GeneralException {
		tRankDef.setLastOpt(CurrentUser.getUser().getUserCode());
		tRankDef.setChannelId("1");
		tRankDef.setValidInd("1");
		if( "".equals(tRankDef.getPkId()) ||  tRankDef.getPkId() == null){
			//获取最大流水号加 1
			String number = tRankDefService.getSerialNumber().toString();
			tRankDef.setPkId(number);
		}
		try {
			tRankDefService.saveLawRank(tRankDef);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tRankDef), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	@RequestMapping("/queryLawRankToUpdate")
	public void queryLawRankToUpdate(HttpServletRequest request, HttpServletResponse response, String pkId) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = tRankDefService.queryLawRankToUpdate(pkId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + pkId, e);
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
	@RequestMapping("/deleteLawRank")
	public void deleteLawRank(HttpServletRequest request, HttpServletResponse response,String  serno) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		TRankDef tRankDef = new TRankDef();
		tRankDef.setPkId(serno);
		try {
			tRankDefService.deleteLawRank(tRankDef);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tRankDef), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 校验重复
	 * @param request
	 * @param response
	 * @param rankCode
	 * @throws GeneralException
	 */
	@RequestMapping("/queryRankCode")
	public void queryRankCode(HttpServletRequest request, HttpServletResponse response, String rankCode) throws GeneralException {
		try {
			Boolean bool = tRankDefService.queryRankCode(rankCode);
			request.setCharacterEncoding("utf-8");
	    	response.reset();
	        response.setCharacterEncoding("utf-8");
	        response.setContentType("text/html; charset=UTF-8");
	        PrintWriter writer = response.getWriter();
			writer.write(Boolean.toString(!bool));
	        writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + rankCode, e);
		}
	}
	
	@RequestMapping("/queryRankByLineCode")
	public void queryRankByLineCode(HttpServletRequest request, HttpServletResponse response, String deptCode, String lineCode, String managerFlag) throws GeneralException {
		Map<String, Object> rankMap = new HashMap<String, Object>();
		rankMap.put("deptCode", deptCode);
		rankMap.put("managerFlag", managerFlag);
		rankMap.put("lineCode", lineCode);
		List<Map<String, Object>> resList = tRankDefService.queryRankByLineCode(rankMap);
		SendUtil.sendJSON(response, resList);
	}
	
	@RequestMapping("/queryRankName")
	public void queryRankName(HttpServletRequest request, HttpServletResponse response, String rankCode) throws GeneralException {
		String resList = tRankDefService.queryRankNameByRankCode(rankCode);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("jsonStr", resList);
		SendUtil.sendJSON(response, map);
	}
	
	@RequestMapping("/queryManagerRankByLineCode")
	public void queryManagerRankByLineCode(HttpServletRequest request, HttpServletResponse response, String deptCode, String lineCode, String managerFlag) throws GeneralException {
		Map<String, Object> rankMap = new HashMap<String, Object>();
		rankMap.put("deptCode", deptCode);
		rankMap.put("managerFlag", managerFlag);
		rankMap.put("lineCode", lineCode);
		List<Map<String, Object>> resList = tRankDefService.queryManagerRankByLineCode(rankMap);
		SendUtil.sendJSON(response, resList);
	}
	
	@RequestMapping("/queryConfirmRank")
	public void queryConfirmRank(HttpServletRequest request, HttpServletResponse response, String deptCodeTwo, String rankCode,String rankId) throws GeneralException {
		Map<String, Object> rankMap = new HashMap<String, Object>();
		String curDeptCode = request.getSession().getAttribute("curDeptCode").toString();
		rankMap.put("curDeptCode", curDeptCode);
		rankMap.put("deptCodeTwo", deptCodeTwo);
		rankMap.put("rankCode", rankCode);
		rankMap.put("rankId", rankId);
		List<Map<String, Object>> resList = tRankDefService.queryConfirmRank(rankMap);
		SendUtil.sendJSON(response, resList);
	}
	
	@RequestMapping("/queryCusAdjustRank")
	public void queryCusAdjustRank(HttpServletRequest request, HttpServletResponse response, String rankId,String deptCodeTwo) throws GeneralException {
		Map<String, Object> rankMap = new HashMap<String, Object>();
		String curDeptCode = request.getSession().getAttribute("curDeptCode").toString();
		rankMap.put("deptCodeTwo", deptCodeTwo);
		rankMap.put("curDeptCode", curDeptCode);
		rankMap.put("rankId", rankId);
		List<Map<String, Object>> resList = tRankDefService.queryCusAdjustRank(rankMap);
		SendUtil.sendJSON(response, resList);
	}
	
	@RequestMapping("/queryTwoDept")
	public void queryTwoDept(HttpServletRequest request, HttpServletResponse response, String rankId,String deptCodeTwo) throws GeneralException {
		String curDeptCode = request.getSession().getAttribute("curDeptCode").toString();
		SendUtil.sendJSON(response, curDeptCode);
	}
	
	@RequestMapping("/generateRankCode")
	public void generateRankCode(HttpServletRequest request, HttpServletResponse response, TRankDef rankDef) throws GeneralException {
		Map<String, Object> param;
		try {
			param = tRankDefService.generateRankCode(rankDef);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("生成职级代码时出错，传入参数为：" + rankDef, e);
		}
		SendUtil.sendJSON(response, param);
	}

}
