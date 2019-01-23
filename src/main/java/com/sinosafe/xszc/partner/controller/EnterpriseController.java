package com.sinosafe.xszc.partner.controller;

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
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.partner.service.EnterpriseService;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/enterprise")
public class EnterpriseController {

	private static final Log log = LogFactory.getLog(EnterpriseController.class);

	@Autowired
	@Qualifier("EnterpriseService")
	private EnterpriseService enterpriseService;

	@RequestMapping("/queryEnterpriseByWhere")
	@VisitDesc(label = "电商渠道分页查询查询", actionType = 4)
	public void queryEnterpriseByWhere(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		PageDto pageDto = new PageDto();
		Map<String, Object> paramMap = dto.getFormMap();
		pageDto.setStart(request.getParameter("start"));
		pageDto.setLimit(request.getParameter("limit"));
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = enterpriseService.findEnterpriseByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/queryEnterpriseByPk")
	@VisitDesc(label = "电商渠道详细信息查询", actionType = 4)
	public void queryEnterpriseByPk(HttpServletRequest request, HttpServletResponse response, String channelCode) throws GeneralException {
		Map<String, Object> resultMap = null;
		try {
			resultMap = enterpriseService.findEnterpriseByPk(channelCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + channelCode, e);
		}
		SendUtil.sendJSON(response, resultMap);
	}

	@RequestMapping("/saveEnterprise")
	@VisitDesc(label = "电商企业渠道保存", actionType = 1)
	public void saveEnterprise(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> formMap = dto.getFormMap();
		formMap.put("createdUser", CurrentUser.getUser().getUserCode());
		formMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			enterpriseService.saveEnterprise(formMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("保存操作异常，传入参数为：" + JSONObject.toJSONString(formMap), e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	@RequestMapping("/updateEnterprise")
	@VisitDesc(label = "电商企业渠道修改", actionType = 2)
	public void updateEnterprise(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> formMap = dto.getFormMap();
		formMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			enterpriseService.updateEnterprise(formMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("保存操作异常，传入参数为：" + JSONObject.toJSONString(formMap), e);
		}
		SendUtil.sendJSON(response, "success");
	}

}
