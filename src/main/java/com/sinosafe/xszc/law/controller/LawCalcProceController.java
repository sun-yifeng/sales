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
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.law.service.LawCalcProceService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/lawCalcProce")
public class LawCalcProceController {

	private static final Log log = LogFactory.getLog(LawCalcProceController.class);

	@Autowired
	@Qualifier("LawCalcProceService")
	private LawCalcProceService lawCalcProceService;

	/**
	 * <pre>
	 * 功能：取表格的记录数
	 * @param request
	 * @param response
	 * @param calcType
	 * @param calcMonth
	 * @param deptCode
	 * @param salesCode
	 * @throws ServiceException
	 * </pre>
	 */
	@RequestMapping("/queryRowCount")
	@VisitDesc(label="取表格的记录数",actionType=4)
	public void queryRowCount(HttpServletRequest request, HttpServletResponse response, int calcType, String calcMonth, String deptCode, String salesCode)
			throws ServiceException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		Long count = -1l;
		paraMap.put("calcType", calcType);
		paraMap.put("calcMonth", calcMonth);
		paraMap.put("deptCode", deptCode);
		paraMap.put("salesCode", salesCode);
		try {
			count = lawCalcProceService.queryRowCount(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + JSON.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, count);
	}

	/**
	 * <pre>
	 * 功能：得分计算过程，不分页
	 * @param request
	 * @param response
	 * @param dto
	 * @param calcType
	 * @param calcMonth
	 * @param deptCode
	 * @param salesCode
	 * @throws ServiceException
	 * </pre>
	 */
	@RequestMapping("/queryCalcScore")
	@VisitDesc(label="得分计算过程",actionType=4)
	public void queryCalcScore(HttpServletRequest request, HttpServletResponse response, FormDto dto, int calcType, String calcMonth, String deptCode,
			String salesCode) throws ServiceException {
		PageDto pageDto = new PageDto();
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("calcType", calcType);
		paraMap.put("calcMonth", calcMonth);
		paraMap.put("deptCode", deptCode);
		paraMap.put("salesCode", salesCode);
		try {
			pageDto.setRows(lawCalcProceService.queryLawCalcByWhere(paraMap));
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + JSON.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * <pre>
	 * 功能：取表格数据，不分页
	 * @param request
	 * @param response
	 * @param dto
	 * @param calcType
	 * @param calcMonth
	 * @param deptCode
	 * @param salesCode
	 * @throws ServiceException
	 * </pre>
	 */
	@RequestMapping("/queryCalcRank")
	@VisitDesc(label="查出职级计算过程",actionType=4)
	public void queryLawRankByWhere(HttpServletRequest request, HttpServletResponse response, FormDto dto, int calcType, String calcMonth, String deptCode,
			String salesCode) throws ServiceException {
		PageDto pageDto = new PageDto();
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("calcMonth", calcMonth);
		paraMap.put("deptCode", deptCode);
		paraMap.put("salesCode", salesCode);
		try {
			pageDto.setRows(lawCalcProceService.queryLawRankByWhere(paraMap));
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + JSON.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

}
