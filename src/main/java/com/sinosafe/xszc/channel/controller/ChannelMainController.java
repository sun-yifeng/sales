package com.sinosafe.xszc.channel.controller;

import java.net.URLEncoder;
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

import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.channel.service.ChannelMainService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/channelMain")
public class ChannelMainController {

	private static final Log log = LogFactory.getLog(ChannelMainController.class);
	
	@Autowired
	@Qualifier("ChannelMainService")
	private ChannelMainService channelMainService;
	
	
	@RequestMapping("/queryChannelMains")
	@VisitDesc(label="渠道列表查询",actionType=4)
	public void queryChannelMains(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = channelMainService.findChannelMainsByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	/**
	 * 渠道审核
	 * @param request
	 * @param response
	 * @param channelCodes
	 * @throws GeneralException
	 */
	@RequestMapping("/processMediums")
	@VisitDesc(label="渠道审核",actionType=3)
	public void processMediums(HttpServletRequest request, HttpServletResponse response, String channelCodes) throws GeneralException {
		Map<String, String> resultMap = new HashMap<String, String>();
		try {
			resultMap = channelMainService.processMediums(channelCodes);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + channelCodes, e);
		}
		SendUtil.sendJSON(response, resultMap);
	}
	
	/**
	 * 全民营销代理人增员情况查询
	 * 
	 * @param request
	 * @param response
	 * @param formDto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryAgentALL")
	public void queryAgentALL(HttpServletRequest request, HttpServletResponse response, FormDto formDto) throws GeneralException {
		Map<String, Object> paramMap = formDto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(formDto.getFormMap());
		try {
			pageDto = channelMainService.queryAgentALL(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("报表查询异常，传入参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	//全民营销增员情况导出
	@RequestMapping("/queryDataToExcel")
	public void queryDataToExcel(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		//查询所有符合条件数据不分页，用来导出Excel
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			//不分页查询所有数据
			pageDto = channelMainService.queryDataToExcel(pageDto);
			//定义从数据库取出数据顺序数组
			String[] colum_name = {"deptCode", "deptNameTwo", "deptNameThree", "deptNameFour", "groupName", "channelCode", "channelName","tel",
					"mobile","sex","birthday","education","recommenderName","salesStatus","salesCategory","signDate","validDate","expireDate","reportMoth"};
			//模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			String strFileName ="reportAgentAdd.xls";
			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename=" + strFileName);
			response.setContentType("application/x-download; charset=utf-8");
			
			//生成所需的Excel文件
			ExportExcel.dataToExcel(pageDto.getRows(), strFilePath+strFileName,colum_name,response.getOutputStream());
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
		
	}
}
