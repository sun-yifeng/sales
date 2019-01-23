package com.sinosafe.xszc.partner.controller;

import java.io.IOException;
import java.util.HashSet;
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
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.partner.service.ConferService;
import com.sinosafe.xszc.partner.vo.Confer;
import com.sinosafe.xszc.partner.vo.ConferProduct;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/confer")
public class ConferController {

	private static final Log log = LogFactory.getLog(ConferController.class);

	@Autowired
	@Qualifier("ConferService")
	private ConferService conferService;

	@RequestMapping("/queryConferByWhere")
	@VisitDesc(label = "电商协议分页查询查询", actionType = 4)
	public void queryConferByWhere(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		PageDto pageDto = new PageDto();
		Map<String, Object> paramMap = dto.getFormMap();
		pageDto.setStart(request.getParameter("start"));
		pageDto.setLimit(request.getParameter("limit"));
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = conferService.findConferByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/queryEnterpriseConferByPk")
	@VisitDesc(label = "电商协议详细信息查询", actionType = 4)
	public void queryEnterpriseConferByPk(HttpServletRequest request, HttpServletResponse response, String conferCode) throws GeneralException {
		Map<String, Object> resultMap = null;
		try {
			resultMap = conferService.findEnterpriseConferByPk(conferCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + conferCode, e);
		}
		SendUtil.sendJSON(response, resultMap);
	}
	
	@RequestMapping("/queryIndividualConferByPk")
	@VisitDesc(label = "电商协议详细信息查询", actionType = 4)
	public void queryIndividualConferByPk(HttpServletRequest request, HttpServletResponse response, String conferCode) throws GeneralException {
		Map<String, Object> resultMap = null;
		try {
			resultMap = conferService.findIndividualConferByPk(conferCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + conferCode, e);
		}
		SendUtil.sendJSON(response, resultMap);
	}

	@RequestMapping("/saveConfer")
	@VisitDesc(label = "电商协议保存", actionType = 1)
	public void saveConfer(HttpServletRequest request, HttpServletResponse response, Confer confer)
			throws GeneralException, JsonParseException, JsonMappingException, IOException {
		// 接收产品列表信息
		String jsonData = request.getParameter("conferJsonStr");
		int beginIndex = jsonData.lastIndexOf("[");
		int endIndex = jsonData.lastIndexOf("]");

		// 获取json中的rows中的有效数据
		jsonData = jsonData.substring(beginIndex, endIndex + 1);
		ObjectMapper objectMapper = new ObjectMapper();
		ConferProduct[] conferProduct = objectMapper.readValue(jsonData, ConferProduct[].class);
		Set<ConferProduct> conferProducts = new HashSet<ConferProduct>();
		for (int i = 0; i < conferProduct.length; i++) {
			conferProducts.add(conferProduct[i]);
		}
		confer.setConferProduct(conferProducts);
		confer.setCreatedUser(CurrentUser.getUser().getUserCode());
		confer.setUpdatedUser(CurrentUser.getUser().getUserCode());
		confer.setValidInd("1");

		// 保存协议
		try {
			conferService.saveConfer(confer);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(confer), e);
		}
		SendUtil.sendJSON(response, "success");
	}

	@RequestMapping("/updateConfer")
	@VisitDesc(label = "电商协议修改", actionType = 2)
	public void updateConfer(HttpServletRequest request, HttpServletResponse response, Confer confer)
			throws GeneralException, JsonParseException, JsonMappingException, IOException {
		// 接收产品列表信息
		String jsonData = request.getParameter("conferJsonStr");
		// 接收明细修改变动标记
		String updateFlag = request.getParameter("updateFlag");
		int beginIndex = jsonData.lastIndexOf("[");
		int endIndex = jsonData.lastIndexOf("]");

		// 获取json中的rows中的有效数据
		jsonData = jsonData.substring(beginIndex, endIndex + 1);
		ObjectMapper objectMapper = new ObjectMapper();
		ConferProduct[] conferProduct = objectMapper.readValue(jsonData, ConferProduct[].class);
		Set<ConferProduct> conferProducts = new HashSet<ConferProduct>();
		for (int i = 0; i < conferProduct.length; i++) {
			conferProducts.add(conferProduct[i]);
		}
		confer.setConferProduct(conferProducts);

		confer.setUpdatedUser(CurrentUser.getUser().getUserCode());
		try {
			conferService.updateConfer(confer, updateFlag);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(confer), e);
		}
		SendUtil.sendJSON(response, "success");
	}

}
