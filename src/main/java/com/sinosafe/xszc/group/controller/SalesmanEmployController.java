package com.sinosafe.xszc.group.controller;

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
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.group.service.SalesmanEmployService;
import com.sinosafe.xszc.group.vo.SalesmanEmploy;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/salesmanEmploy")
public class SalesmanEmployController {

	private static final Log log = LogFactory.getLog(SalesmanEmployController.class);
	
	@Autowired
	@Qualifier("SalesmanEmployService")
	private SalesmanEmployService salesmanEmployService;
	
	
	/**
	 * 关联工号查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/querySalesmanEmploy")
	public void querySalesmanEmploy(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = salesmanEmployService.findSalesmanEmployByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	
	/**
	 * 查询销售人员维护改动前的关联工号
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/querySalesmanEmployHistory")
	public void querySalesmanEmployHistory(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = salesmanEmployService.findSalesmanEmployHistory(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 人员新增
	 * @param request
	 * @param response
	 * @param saleUser
	 * @throws GeneralException
	 */
	@RequestMapping("/saveSalesmanEmploy")
	public void saveSalesmanEmploy(HttpServletRequest request, HttpServletResponse response, SalesmanEmploy salesmanEmploy) throws GeneralException {
		salesmanEmploy.setPkId(UUIDGenerator.getUUID());
		salesmanEmploy.setCreatedUser(CurrentUser.getUser().getUserCode());
		salesmanEmploy.setUpdatedUser(CurrentUser.getUser().getUserCode());
		salesmanEmploy.setValidInd("1");
		try {
			salesmanEmployService.saveSalesmanEmploy(salesmanEmploy);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(salesmanEmploy), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	
	
}
