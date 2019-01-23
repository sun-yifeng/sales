package com.sinosafe.xszc.law.controller;

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
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.law.service.LawCostRateService;
import com.sinosafe.xszc.law.vo.TLawCostRate;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/lawCostRate")
public class LawCostRateController {

	private static final Log log = LogFactory.getLog(LawCostRateController.class);

	@Autowired
	@Qualifier("LawCostRateService")
	private LawCostRateService lawCostRateService;

	@RequestMapping("/queryLawCostRate")
	public void queryLawCostRate(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = lawCostRateService.findLawCostRateByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/saveLawCostRate")
	public void saveLawCostRate(HttpServletRequest request, HttpServletResponse response, TLawCostRate lawCostRate) throws GeneralException {
		try {
			lawCostRateService.saveLawCostRate(lawCostRate);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(lawCostRate), e);
		}
		SendUtil.sendJSON(response, "success");
	}

	@RequestMapping("/queryLawCostRateToUpdate")
	public void queryLawCostRateToUpdate(HttpServletRequest request, HttpServletResponse response, String costRateId) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = lawCostRateService.queryLawCostRateToUpdate(costRateId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + costRateId, e);
		}
		SendUtil.sendJSON(response, rows);
	}
	
	@RequestMapping("/deleteLawCostRate")
	public void deleteLawCostRate(HttpServletRequest request, HttpServletResponse response, String costRateId) throws GeneralException {
		try {
			lawCostRateService.deleteLawCostRate(costRateId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + costRateId, e);
		}
		SendUtil.sendJSON(response, "success");
	}
}
