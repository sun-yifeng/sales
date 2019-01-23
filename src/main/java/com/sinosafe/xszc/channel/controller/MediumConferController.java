package com.sinosafe.xszc.channel.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.channel.service.MediumConferService;
import com.sinosafe.xszc.channel.vo.ChannelConfer;
import com.sinosafe.xszc.channel.vo.ChannelConferProduct;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/mediumConfer")
public class MediumConferController {

	private static final Log log = LogFactory.getLog(MediumConferController.class);
	
	@Autowired
	@Qualifier("MediumConferService")
	private MediumConferService mediumConferService;

	/**
	 * 中介机构协议列表展示及自定义查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediumConfer")
	@VisitDesc(label="中介机构协议列表展示及自定义查询",actionType=4)
	public void queryMediumConfer(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumConferService.findMediumConferByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 个人代理人协议列表展示及自定义查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryAgentConfer")
	@VisitDesc(label="个人代理人协议列表展示及自定义查询",actionType=4)
	public void queryAgentConfer(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumConferService.findAgentConferByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 中介机构协议详情
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediumConfers")
	public void queryMediumConfers(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumConferService.findMediumConfersByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}
	
	/**
	 * 个人代理人协议详情
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryAgentConfers")
	@VisitDesc(label="个人代理人协议详情",actionType=4)
	public void queryAgentConfers(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumConferService.findAgentConfersByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	/**
	 * 中介机构、代理人协议保存
	 * @param request
	 * @param response
	 * @param confer
	 * @throws GeneralException
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@RequestMapping("/saveMediumConfer")
	@VisitDesc(label="中介机构、代理人协议保存",actionType=4)
	public void saveMediumConfer(HttpServletRequest request, HttpServletResponse response, ChannelConfer confer)
			throws GeneralException, JsonParseException, JsonMappingException, IOException {
		//接收产品列表信息
		String jsonData = request.getParameter("conferJsonStr");
		int beginIndex = jsonData.lastIndexOf("[");
		int endIndex = jsonData.lastIndexOf("]");
		//获取json中的rows中的有效数据
		jsonData = jsonData.substring(beginIndex, endIndex+1);
		ObjectMapper objectMapper = new ObjectMapper();
		ChannelConferProduct[] conferProduct = objectMapper.readValue(jsonData, ChannelConferProduct[].class);
		Set<ChannelConferProduct> conferProducts = new HashSet<ChannelConferProduct>();
		for(int i = 0 ; i < conferProduct.length ; i++){
			conferProducts.add(conferProduct[i]);
		}
		confer.setChannelConferProduct(conferProducts);

		//附件ID
		String uploadId = request.getParameter("uploadId");
		
		confer.setCreatedUser(CurrentUser.getUser().getUserCode());
		confer.setUpdatedUser(CurrentUser.getUser().getUserCode());
		confer.setValidInd("1");
		try {
			mediumConferService.saveMediumConfer(confer,uploadId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(confer), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 中介机构、代理人协议修改，保存
	 * @param request
	 * @param response
	 * @param confer
	 * @throws GeneralException
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@RequestMapping("/updateMediumConfer")
	@VisitDesc(label="中介机构、代理人协议修改，保存",actionType=3)
	public void updateMediumConfer(HttpServletRequest request, HttpServletResponse response, ChannelConfer confer) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		//接收产品列表信息
		String jsonData = request.getParameter("conferJsonStr");
		//接收明细修改变动标记
		String updateFlag = request.getParameter("updateFlag");
		int beginIndex = jsonData.lastIndexOf("[");
		int endIndex = jsonData.lastIndexOf("]");
		//获取json中的rows中的有效数据
		jsonData = jsonData.substring(beginIndex, endIndex+1);
		ObjectMapper objectMapper = new ObjectMapper();
		ChannelConferProduct[] conferProduct = objectMapper.readValue(jsonData, ChannelConferProduct[].class);
		Set<ChannelConferProduct> conferProducts = new HashSet<ChannelConferProduct>();
		for(int i = 0 ; i < conferProduct.length ; i++){
			conferProducts.add(conferProduct[i]);
		}
		confer.setChannelConferProduct(conferProducts);

		//附件ID
		String uploadId = request.getParameter("uploadId");
		
		confer.setUpdatedUser(CurrentUser.getUser().getUserCode());
		try {
			mediumConferService.updateMediumConfer(confer,uploadId,updateFlag);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(confer), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 中介机构、代理人协议删除
	 * @param request
	 * @param response
	 * @param conferCode
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteMediumConfer")
	@VisitDesc(label="中介机构、代理人协议删除",actionType=2)
	public void deleteMediumConfer(HttpServletRequest request, HttpServletResponse response, String conferCode) throws GeneralException {
		try {
			mediumConferService.deleteMediumConfer(conferCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + conferCode, e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	/**
	 * 协议编码校验
	 * @param request
	 * @param response
	 * @param conferCode
	 * @throws GeneralException
	 */
	@RequestMapping("/queryConferCode")
	@VisitDesc(label="协议编码校验",actionType=4)
	public void queryConferCode(HttpServletRequest request, HttpServletResponse response, String conferCode) throws GeneralException {
		try {
			Boolean bool = mediumConferService.queryConferCode(conferCode);
			request.setCharacterEncoding("utf-8");
	    	response.reset();
	        response.setCharacterEncoding("utf-8");
	        response.setContentType("text/html; charset=UTF-8");
	        PrintWriter writer = response.getWriter();
			writer.write(Boolean.toString(!bool));
	        writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + conferCode, e);
		}
	}
	
	/**
	 * 中介机构协议历史轨迹列表展示
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediumConferHistorys")
	@VisitDesc(label="中介机构协议历史轨迹列表展示",actionType=4)
	public void queryMediumConferHistorys(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumConferService.findMediumConferHistorysByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 中介机构历史记录详情
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediumConferHistory")
	@VisitDesc(label="中介机构历史记录详情",actionType=4)
	public void queryMediumConferHistory(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		List<Map<String, Object>> rows;
		try {
			rows = mediumConferService.findMediumConferHistoryByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, rows);
	}

	/**
	 * 代理人协议历史轨迹列表展示
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryAgentConferHistorys")
	@VisitDesc(label="代理人协议历史轨迹列表展示",actionType=4)
	public void queryAgentConferHistorys(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumConferService.findAgentConferHistorysByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 代理人历史记录详情
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryAgentConferHistory")
	@VisitDesc(label="代理人历史记录详情",actionType=4)
	public void queryAgentConferHistory(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		List<Map<String, Object>> rows;
		try {
			rows = mediumConferService.findAgentConferHistoryByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, rows);
	}
	
	/**
	 * 协议审核
	 * @param request
	 * @param response
	 * @param conferCodes
	 * @throws GeneralException
	 */
	@RequestMapping("/processConfers")
	@VisitDesc(label="协议审核",actionType=3)
	public void processConfers(HttpServletRequest request, HttpServletResponse response, String conferCodes, String channelCode) throws GeneralException {
		Map<String, String> resultMap = new HashMap<String, String>();
		try {
			resultMap = mediumConferService.processConfers(conferCodes,channelCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + conferCodes, e);
		}
		SendUtil.sendJSON(response, resultMap);
	}
}
