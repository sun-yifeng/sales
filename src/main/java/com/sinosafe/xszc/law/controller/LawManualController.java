package com.sinosafe.xszc.law.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.law.service.LawDefineManualService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.IPAddressUtil;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/lawManual")
public class LawManualController {
	
	private static final Log log = LogFactory.getLog(LawRateController.class);
	
	@Autowired
	@Qualifier("LawDefineManualService")
	private LawDefineManualService lawDefineManualService;
	
	/**
	 * 功能:不分页查询手动执行任务
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/queryManualTask")
	@VisitDesc(label="取手动计算任务表数据",actionType=4)
	public void queryManualTask(HttpServletRequest request, HttpServletResponse response,String versionId,FormDto dto) throws GeneralException {
		PageDto pageDto = null;
		Map<String,Object> paraMap = dto.getFormMap();
		String year = (String) paraMap.get("year");
		String month = (String) paraMap.get("month");
		paraMap.put("versionId", versionId);
		paraMap.put("calcMonth", year+month);
		try {
			pageDto = lawDefineManualService.queryManualTaskList(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + JSON.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
    
	
	@RequestMapping("/execManualCal")
	@VisitDesc(label="取手动计算任务表数据",actionType=4)
	public void execManualCal(HttpServletRequest request, HttpServletResponse response,FormDto dto) throws GeneralException {
		Map<String,Object> paraMap = dto.getFormMap();
		String year = (String) paraMap.get("year");
		String month = (String) paraMap.get("month");
		String versionId = request.getParameter("versionId");
		String taskCode = request.getParameter("taskCode");
		String deptCode = request.getParameter("deptCode");
		paraMap.put("versionId", versionId);
		paraMap.put("calcMonth", year+month);
		paraMap.put("taskCode", taskCode);
		paraMap.put("deptCode", deptCode);
		paraMap.put("lineCode", "925007");
		paraMap.put("userCode", CurrentUser.getUser().getUserCode().split("@")[0]);
		
		//获取当前操作人的本机ip地址
		String operatorId = IPAddressUtil.getRemortIP(request);
		paraMap.put("operatorId", operatorId);
		
		
		Map<String,Object> resultMap = new HashMap<String, Object>();
		try {
			resultMap = lawDefineManualService.execManualCal(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常", e);
		}
		SendUtil.sendJSON(response, resultMap);
	}
	
	@RequestMapping("/validateTaskStatus")
	@VisitDesc(label="获取所有手动执行任务的状态",actionType=4)
	public void validateTaskStatus(HttpServletRequest request, HttpServletResponse response,FormDto dto) throws GeneralException {
		boolean result = false;
		Map<String,Object> paraMap = dto.getFormMap();
		String year = (String) paraMap.get("year");
		String month = (String) paraMap.get("month");
		paraMap.put("calcMonth", year+month);
		try {
			result = lawDefineManualService.findTaskStatus(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常", e);
		}
		SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/queryLastTaskStatus")
	@VisitDesc(label="查询上一条任务的执行状态",actionType=4)
	public void queryLastTaskStatus(HttpServletRequest request, HttpServletResponse response,FormDto dto) throws GeneralException {
		String result = "";
		Map<String,Object> paraMap = dto.getFormMap();
		String taskCode = request.getParameter("taskCode");
		if("2".equals(taskCode)){
			paraMap.put("taskCode", taskCode);
		}else{
			String lastTaskCode = (Integer.valueOf(taskCode)-1) + "";
			paraMap.put("taskCode", lastTaskCode);
		}
		String lastTaskCode = (Integer.valueOf(taskCode)-1) + "";
		String year = (String) paraMap.get("year");
		String month = (String) paraMap.get("month");
		String versionId = request.getParameter("versionId");
		paraMap.put("calcMonth", year+month);
		paraMap.put("taskCode", lastTaskCode);
		paraMap.put("versionId", versionId);
		try {
			result = lawDefineManualService.findLastTaskStatus(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常", e);
		}
		SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/validateRuleConfig")
	@VisitDesc(label="获取所有手动执行任务的状态",actionType=4)
	public void validateRuleConfig(HttpServletRequest request, HttpServletResponse response,FormDto dto) throws GeneralException {
		boolean result = false;
		Map<String,Object> paraMap = dto.getFormMap();
		String versionId = request.getParameter("versionId");
		paraMap.put("versionId", versionId);
		try {
			result = lawDefineManualService.lawRuleConfigOrNot(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常", e);
		}
		SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/updateTaskStatus")
	@VisitDesc(label="获取所有手动执行任务的状态",actionType=4)
	public void updateTaskStatus(HttpServletRequest request, HttpServletResponse response,FormDto dto) throws GeneralException {
		Map<String,Object> paraMap = dto.getFormMap();
		String versionId = request.getParameter("versionId");
		String taskCode = request.getParameter("taskCode");
		paraMap.put("versionId", versionId);
		paraMap.put("taskCode", taskCode);
		try {
			lawDefineManualService.updateTaskStatus(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常", e);
		}
		SendUtil.sendJSON(response, true);
	}
	
	@RequestMapping("/queryCalcLogs")
	@VisitDesc(label="查询计算过程的详细日志",actionType=4)
	public void queryMedium(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		String taskId = request.getParameter("taskId");
		String logLevel = request.getParameter("logLevel");
		dto.getFormMap().put("taskId", taskId);
		dto.getFormMap().put("logLevel", logLevel);
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());

		try {
			pageDto = lawDefineManualService.queryCalcLogs(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/queryCalcMonth")
	@VisitDesc(label="查询计算过程的详细日志",actionType=4)
	public void queryCalcMonth(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("cfgCode", "CFG001");
		String result = lawDefineManualService.queryCalcMonth(paraMap);
		SendUtil.sendJSON(response, result);
	}	
}
