package com.sinosafe.xszc.channel.controller;

import java.util.ArrayList;
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

import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.channel.service.ConferProductService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.GetRequestMap;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/conferProduct")
public class ConferProductController {

	private static final Log log = LogFactory.getLog(ConferProductController.class);

	@Autowired
	@Qualifier("ConferProductService")
	private ConferProductService conferProductService;

	/**
	 * 协议产品列表展示（修改页面）
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryConferProduct")
	@VisitDesc(label="协议产品列表展示（修改页面）",actionType=4)
	public void queryConferProduct(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = conferProductService.findConferProductByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 查询复制对象产品手续费比例 方法queryConferProdCopy的简要说明 <br>
	 * 
	 * <pre>
	 * 方法queryConferProdCopy的详细说明 <br>
	 * 编写者：李晓亮
	 * 创建时间：2015年1月28日 上午9:26:59
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @return void 说明
	 * @throws 异常类型
	 *             说明
	 */
	@RequestMapping("/queryConferProdCopy")
	@VisitDesc(label="查询复制对象产品手续费比例",actionType=4)
	public void queryConferProdCopy(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		whereMap = new GetRequestMap().getRequstMap(request);
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		try {
			resultList = conferProductService.findConferProdCopyByWhere(whereMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + whereMap, e);
		}
		pageDto.setRows(resultList);
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 协议产品列表展示（详情页面）
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryConferProducts")
	@VisitDesc(label="协议产品列表展示（详情页面）",actionType=4)
	public void queryConferProducts(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = conferProductService.findConferProductsByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 协议产品列表展示（历史轨迹详情页面）
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryConferProductsHistory")
	@VisitDesc(label="协议产品列表展示（历史轨迹详情页面）",actionType=4)
	public void queryConferProductsHistory(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = conferProductService.findConferProductsHistoryByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 中介机构、代理人协议产品删除
	 * 
	 * @param request
	 * @param response
	 * @param conferProductId
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteMediumConferProduct")
	@VisitDesc(label="中介机构、代理人协议产品删除",actionType=2)
	public void deleteMediumConferProduct(HttpServletRequest request, HttpServletResponse response, String conferProductId)
			throws GeneralException {
		try {
			conferProductService.deleteMediumConferProduct(conferProductId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + conferProductId, e);
		}
		SendUtil.sendJSON(response, "success");
	}

	/**
	 * 中介机构、代理人协议产品校验（是否在同一协议下重复添加）
	 * 
	 * @param request
	 * @param response
	 * @param conferProductId
	 * @param productCode
	 * @param conferCode
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediumConferProductCode")
	@VisitDesc(label="中介机构、代理人协议产品校验",actionType=4)
	public void queryMediumConferProductCode(HttpServletRequest request, HttpServletResponse response, String conferProductId,
			String productCode, String conferCode) throws GeneralException {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("conferProductId", conferProductId);
		map.put("productCode", productCode);
		map.put("conferCode", conferCode);
		String result = "";
		try {
			Long total = conferProductService.queryMediumConferProductCode(map);
			if (total > 0) {
				result = "fail";
			} else {
				result = "success";
			}
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + map, e);
		}
		SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/queryRateByProduct")
	public void queryRateByProduct(HttpServletRequest request, HttpServletResponse response, String productCode) throws GeneralException {
		Map<String,Object> paraMap = new HashMap<String,Object>();
		try {
			paraMap = conferProductService.queryRateByProduct(productCode);
			
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + productCode, e);
		}
		if(paraMap==null){
			SendUtil.sendJSON(response, "noData");
		}else{
			SendUtil.sendJSON(response, paraMap);
		}
	}
	
	@RequestMapping("/queryProductName")
	public void queryProductName(HttpServletRequest request, HttpServletResponse response, String productCode) throws GeneralException {
		Map<String,Object> paraMap = new HashMap<String,Object>();
		try {
			paraMap = conferProductService.queryProductName(productCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + productCode, e);
		}
			SendUtil.sendJSON(response, paraMap);
	}
	
	@RequestMapping("/queryProductByConferId")
	public void queryProductByConferId(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		Map<String,Object> paraMap = new HashMap<String,Object>();
		String productCode = request.getParameter("productCode");
		String conferId = request.getParameter("conferId");
		paraMap.put("productCode", productCode);
		paraMap.put("conferId", conferId);
		String commissionRate = "";
		try {
			commissionRate = conferProductService.queryProductByConferId(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + productCode, e);
		}
		SendUtil.sendJSON(response, commissionRate);
	}
}
