package com.sinosafe.xszc.report.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.report.service.ReportCommonService;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.GetRequestMap;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/reportCommon")
public class ReportCommonController {

	private static Logger logger = Logger.getLogger(ReportCommonController.class);
	
	@Autowired
	@Qualifier("ReportCommonExportService")
	private ReportCommonService reportCommonService;


	@RequestMapping("/excelExport")
	public void excelExport(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> requestMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		requestMap = new GetRequestMap().getRequstMap(request);
		try {
			resultList = reportCommonService.findInfo(requestMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(requestMap), e);
		}
		try {
			String fileName = (String) requestMap.get("queryName");
			fileName += ".xls";
			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				fileName = URLEncoder.encode(fileName, "UTF-8");// IE浏览器
			} else {
				fileName = new String(fileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename=" + fileName);
			response.setContentType("application/x-download; charset=utf-8");
			ExportExcel.dataToExcel(resultList, response.getOutputStream());
		} catch (IOException e) {
			logger.error(e);
			throw new ServiceException("查询结果导成excel出错：" + JSONObject.toJSONString(requestMap), e);
		}
	}

	@RequestMapping("/getOptions")
	public void getOptions(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> requestMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		requestMap = new GetRequestMap().getRequstMap(request);
		try {
			resultList = reportCommonService.getOptions(requestMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(requestMap), e);
		}
		SendUtil.sendJSON(response, resultList);
	}

	/**
	 * 功能：报表查询,通用方法
	 * 
	 * @param request
	 * @param response
	 * @param formDto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryReportList")
	public void queryReportList(HttpServletRequest request, HttpServletResponse response, FormDto formDto) throws GeneralException {
		Map<String, Object> paramMap = formDto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(formDto.getFormMap());
		try {
			pageDto = reportCommonService.queryReportList(pageDto);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("报表查询异常，传入参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		String operType = (String) formDto.getFormMap().get("operType");
		String excelName = (String) formDto.getFormMap().get("excelName");
		if ("1".equals(operType)) {
			pageDto.getWhereMap().clear();
			SendUtil.sendJSON(response, pageDto);
		} else if ("2".equals(operType)) {
			exportExcle(request, response, pageDto, excelName);
		}
	}
	
	/**
	 * 简要说明:团队日报业绩跟踪 <br><pre>
	 */
	@RequestMapping("/queryDayGroupReportList")
	public void queryDayGroupReportList(HttpServletRequest request, HttpServletResponse response, FormDto formDto) throws GeneralException {
		Map<String, Object> paramMap = formDto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(formDto.getFormMap());
		String curDeptCode = request.getSession().getAttribute("curDeptCode").toString();
		pageDto.getWhereMap().put("curDeptCode", curDeptCode);
		try {
			pageDto = reportCommonService.queryDayGroupReportList(pageDto);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("报表查询异常，传入参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		String operType = (String) formDto.getFormMap().get("operType");
		String excelName = (String) formDto.getFormMap().get("excelName");
		if ("1".equals(operType)) {
			pageDto.getWhereMap().clear();
			SendUtil.sendJSON(response, pageDto);
		} else if ("2".equals(operType)) {
			exportExcle(request, response, pageDto, excelName);
		}
	}
	
	/**
	 * 简要说明:团队月报业绩跟踪 <br><pre>
	 */
	@RequestMapping("/queryMonthGroupReportList")
	public void queryMonthGroupReportList(HttpServletRequest request, HttpServletResponse response, FormDto formDto) throws GeneralException {
		Map<String, Object> paramMap = formDto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(formDto.getFormMap());
		try {
			pageDto = reportCommonService.queryMonthGroupReportList(pageDto);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("报表查询异常,传入参数为:" + JSONObject.toJSONString(paramMap), e);
		}
		String operType  = (String) formDto.getFormMap().get("operType");
		String excelName = (String) formDto.getFormMap().get("excelName");
		if ("1".equals(operType)) {
			pageDto.getWhereMap().clear();
			SendUtil.sendJSON(response, pageDto);
		} else if ("2".equals(operType)) {
			exportExcle(request, response, pageDto, excelName);
		}
	}

	/**
	 * 简要:团队排行榜查询 <br><pre>
	 */
	@RequestMapping("/queryMonthGroupPaihangList")
	public void queryMonthGroupPaihangList(HttpServletRequest request, HttpServletResponse response, FormDto formDto) throws GeneralException {
		Map<String, Object> paramMap = formDto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(formDto.getFormMap());
		String curDeptCode = request.getSession().getAttribute("curDeptCode").toString();
		if(curDeptCode.equals("00")){
			curDeptCode = "";
		}
		pageDto.getWhereMap().put("curDeptCode", curDeptCode);
		try {
			pageDto = reportCommonService.queryMonthGroupPaihangList(pageDto);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("报表查询异常,传入参数为:" + JSONObject.toJSONString(paramMap), e);
		}
		String operType  = (String) formDto.getFormMap().get("operType");
		String excelName = (String) formDto.getFormMap().get("excelName");
		if ("1".equals(operType)) {
			pageDto.getWhereMap().clear();
			SendUtil.sendJSON(response, pageDto);
		} else if ("2".equals(operType)) {
			exportExcle(request, response, pageDto, excelName);
		}
	}
	
	/**
	 * 简要:得到当前登录用户的部门,团队信息 <br><pre>
	 * @throws IOException 
	 */
	@RequestMapping("/getCurUserGroupMsg")
	public void getCurUserGroupMsg(HttpServletResponse response) throws IOException {
		Map<String,Object> groupDeptMap = this.reportCommonService.getCurUserGroupMsg();
		if(groupDeptMap!=null){
			response.getWriter().write(JSONObject.toJSON(groupDeptMap).toString());
		}else{
			response.getWriter().write("");
		}
		response.getWriter().close();
	}
	
	/**
	 * 功能：报表导出,通用方法
	 * 
	 * @param request
	 * @param response
	 * @param pageDto
	 * @param excelName
	 * @throws ServiceException
	 */
	public void exportExcle(HttpServletRequest request, HttpServletResponse response, PageDto pageDto, String excelName) throws ServiceException {
		try {
			// 列名
			String[] columName = (String[]) pageDto.getWhereMap().get("columName");
			// 模板
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			String strFileName = excelName + ".xls";
			logger.debug("报表模板的部署路径:" + strFilePath);
			logger.debug("报表模板的文件名称:" + strFileName);
			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename=" + strFileName);
			response.setContentType("application/x-download; charset=utf-8");
			ExportExcel.dataToExcel(pageDto.getRows(), strFilePath + strFileName, columName, response.getOutputStream());
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + pageDto.getWhereMap(), e);
		}
	}

}
