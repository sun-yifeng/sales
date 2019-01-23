package com.sinosafe.xszc.group.controller;

import java.io.IOException;
import java.io.PrintWriter;
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
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.group.service.SalesmanVirtualService;
import com.sinosafe.xszc.group.vo.SalesmanVirtual;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.ReflectMatch;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/salesmanVirtual")
public class SalesmanVirtualController {

	private static final Log log = LogFactory.getLog(SalesmanVirtualController.class);

	@Autowired
	@Qualifier("SalesmanVirtualService")
	private SalesmanVirtualService salesmanVirtualService;
	
	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;
	

	/**
	 * 非HR人员分页查询
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/querySalesmanVirtual")
	public void querySalesmanVirtual(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = salesmanVirtualService.findSalesmanVirtualByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	/**
	 * 非HR人员历史修改记录分页查询
	 */
	@RequestMapping("/SalesmanVirtualHistory")
	public void querySalesmanVirtualHistory(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(paramMap);
		try {
			pageDto = salesmanVirtualService.findSalesmanHistoryByWhere(pageDto);
			
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 非HR人员新增
	 * 
	 * @param request
	 * @param response
	 * @param SalesmanVirtual
	 * @throws GeneralException
	 */
	@RequestMapping("/saveSalesmanVirtual")
	public void saveSalesmanVirtual(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String currentUser = CurrentUser.getUser().getUserCode();
		// 把前台传过来的Map集合保存到对象
		ReflectMatch rm = new ReflectMatch();
		SalesmanVirtual salesmanVirtual = new SalesmanVirtual();
		rm.setValue(salesmanVirtual, paramMap);
		salesmanVirtual.setVirtualId(UUIDGenerator.getUUID());
		salesmanVirtual.setCreatedUser(currentUser);
		salesmanVirtual.setUpdatedUser(currentUser);
		salesmanVirtual.setValidInd("1");
		try {
			salesmanVirtualService.saveSalesmanVirtual(salesmanVirtual);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(salesmanVirtual), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 非HR人员修改
	 * 
	 * @param request
	 * @param response
	 * @param SalesmanVirtual
	 * @throws GeneralException
	 */
	@RequestMapping("/updateSalesmanVirtual")
	public void updateSalesmanVirtual(HttpServletRequest request, HttpServletResponse response, SalesmanVirtual salesmanVirtual)
			throws GeneralException {
		String currentUser = CurrentUser.getUser().getUserCode();
		String historyId=UUIDGenerator.getUUID();
		salesmanVirtual.setUpdatedUser(currentUser);
		salesmanVirtual.setValidInd("1");
		salesmanVirtual.setHistoryId(historyId);
		try {
			salesmanVirtualService.updateSalesmanVirtual(salesmanVirtual);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(salesmanVirtual), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 修改，查看 ， 单条数据详情
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/querySalesmanVirtualDetial")
	public void querySalesmanVirtualDetial(HttpServletRequest request, HttpServletResponse response, String virtualId) throws GeneralException {
		Map<String, Object> salesmanVirtual;
		try {
			salesmanVirtual = salesmanVirtualService.querySalesmanVirtualDetial(virtualId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + virtualId, e);
		}
		SendUtil.sendJSON(response, salesmanVirtual);
	}
	
	
	///
	@RequestMapping("/querySalesmanVirtualDetial2")
	public void querySalesmanVirtualDetial2(HttpServletRequest request, HttpServletResponse response, String historyId) throws GeneralException {
		Map<String, Object> salesmanVirtual;
		try {
			salesmanVirtual = salesmanVirtualService.querySalesmanVirtualDetial2(historyId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + historyId, e);
		}
		SendUtil.sendJSON(response, salesmanVirtual);
	}

	/**
	 * 校验身份证号码是否存在
	 * 
	 * @param request
	 * @param response
	 * @param certiryNo
	 * @throws GeneralException
	 */
	@RequestMapping("/queryCertiryNoByCount")
	public void queryCertiryNoByCount(HttpServletRequest request, HttpServletResponse response, String certiryNo) throws GeneralException {
		SalesmanVirtual salesmanVirtual = new SalesmanVirtual();
		salesmanVirtual.setCertiryNo(certiryNo);
		Long maxNum = null;
		try {
			PrintWriter writer = response.getWriter();
			maxNum = salesmanVirtualService.findCertiryNoByCount(salesmanVirtual);
			// 转为返回页面的true或 false
			writer.write(Boolean.toString(maxNum < 1));
			writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询团队名称，返回的参数：" + salesmanVirtual, e);
		}
	}

	/**
	 * 判断时间段是否交叉或包含
	 * 
	 * @param request
	 * @param response
	 * @param salesmanVirtual
	 * @throws GeneralException
	 */
	@RequestMapping("/queryDateTime")
	public void queryDateTime(HttpServletRequest request, HttpServletResponse response, SalesmanVirtual salesmanVirtual)
			throws GeneralException {
		Long count = null;
		try {
			PrintWriter writer = response.getWriter();
			count = salesmanVirtualService.findDateTime(salesmanVirtual);
			// 转为返回页面的true或 false
			writer.write(Boolean.toString(count <1));
			writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询团队名称，返回的参数：" + salesmanVirtual, e);
		}
	}

	
	/**
	 * 1.判断历史记录的时间段是否交叉或包含
	 * 2.判断当前的时间段与修过后的时间段是否有交叉或者包含
	 * @param request
	 * @param response
	 * @param salesmanVirtual
	 * @throws GeneralException
	 */
	@RequestMapping("/queryDateTimeAndHistory")
	public void queryDateTimeAndHistory(HttpServletRequest request, HttpServletResponse response, SalesmanVirtual salesmanVirtual)
			throws GeneralException {
		Long count = null;
		Long count2=null; 
		try {
			PrintWriter writer = response.getWriter();
			//1.判断历史记录的时间段是否交叉或包含
			count2=salesmanVirtualService.findDateTimeHistory(salesmanVirtual);
			//2.判断当前的时间段与修过后的时间段是否有交叉或者包含
			count = salesmanVirtualService.findDateTime(salesmanVirtual);
			// 转为返回页面的true或 false
			if (count2<1 && count<1){
				writer.write("true");
			}
			else{
				writer.write("false");
			}
			writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询团队名称，返回的参数：" + salesmanVirtual, e);
		}
	}
	
	
	/**
	 * 1.判断历史记录的时间段是否交叉或包含
      * @param request
	 * @param response
	 * @param salesmanVirtual
	 * @throws GeneralException
	 */
	@RequestMapping("/queryHistoryTime")
	public void queryHistoryTime(HttpServletRequest request, HttpServletResponse response, SalesmanVirtual salesmanVirtual)
			throws GeneralException {
		
		Long count2=null; 
		try {
			PrintWriter writer = response.getWriter();
			//1.判断历史记录的时间段是否交叉或包含
			count2=salesmanVirtualService.findDateTimeHistory(salesmanVirtual);
		
			if (count2<1){
				writer.write("true");
			}
			else{
				writer.write("false");
			}
			
			writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询团队名称，返回的参数：" + salesmanVirtual, e);
		}
	}

	/**
	 * 校验工号是否存在
	 * 
	 * @param request
	 * @param response
	 * @param employCode
	 * @throws GeneralException
	 */
	@RequestMapping("/queryEmployCode")
	public void queryEmployCode(HttpServletRequest request, HttpServletResponse response, String employCode) throws GeneralException {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		SalesmanVirtual salesmanVirtual = new SalesmanVirtual();
		salesmanVirtual.setEmployCode(employCode);
		Long count = null;
		String salesmanType = "";
		try {
//			PrintWriter writer = response.getWriter();
			count = salesmanVirtualService.findEmployCode(salesmanVirtual);
			resultMap.put("RESULT", Boolean.toString(count < 1));
			if(count >= 1){
			salesmanType = salesmanVirtualService.querySalesmanType(employCode); 
			resultMap.put("TYPE", salesmanType);
			}
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询团队名称，返回的参数：" + salesmanVirtual, e);
		}
		SendUtil.sendJSON(response, resultMap);
	}
	
	@RequestMapping("/queryEmployCodeHR")
	public void queryEmployCodeHR(HttpServletRequest request, HttpServletResponse response, String employCode) throws GeneralException {
		SalesmanVirtual salesmanVirtual = new SalesmanVirtual();
		salesmanVirtual.setEmployCode(employCode);
		Long count = null;
		try {
			PrintWriter writer = response.getWriter();
			count = salesmanVirtualService.queryEmployCodeHR(salesmanVirtual);
			// 转为返回页面的true或 false
			writer.write(Boolean.toString(count < 1));
			writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询团队名称，返回的参数：" + salesmanVirtual, e);
		}
	}

	/**
	 * 删除非HR人员信息
	 * 
	 * @param request
	 * @param response
	 * @param virtualId
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteSalesmanVirtual")
	public void deleteSalesmanVirtual(HttpServletRequest request, HttpServletResponse response, String virtualId,String employCode) throws GeneralException,
			JsonParseException, JsonMappingException, IOException {
		SalesmanVirtual salesmanVirtual = new SalesmanVirtual();
		salesmanVirtual.setUpdatedUser(CurrentUser.getUser().getUserCode());
		salesmanVirtual.setVirtualId(virtualId);
		salesmanVirtual.setEmployCode(employCode);
		try {
			salesmanVirtualService.deleteSalesmanVirtual(salesmanVirtual);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(salesmanVirtual), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 销售助理异动记录
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/querySalesmanVirtualRecord")
	public void querySalesmanVirtualRecord(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		String employCode = request.getParameter("employCode");
		paramMap.put("employCode", employCode);
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(paramMap);
		try {
			pageDto = salesmanVirtualService.findSalesmanVirtualRecordByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * <pre>
	 * 记录销售人员异动记录
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/updateSalesmanVirtualRecord")
	public void updateSalesmanVirtualRecord(HttpServletRequest request, HttpServletResponse response, FormDto dto) {
		Map<String, Object> paraMap = dto.getFormMap();
		paraMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			salesmanVirtualService.updateSalesmanVirtualRecord(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(paraMap), e);
		}
	}
	
	@RequestMapping("/validateDate")
	@VisitDesc(label="获取所有手动执行任务的状态",actionType=4)
	public void validateDate(HttpServletRequest request, HttpServletResponse response,FormDto dto) throws GeneralException {
		String result  = "";
		Map<String, Object> paraMap = dto.getFormMap();
		String employCode = request.getParameter("employCode");
		paraMap.put("employCode", employCode);
		paraMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			result = salesmanVirtualService.validateDate(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		
		SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/querySalesmanName")
	public void querySalesmanName(HttpServletRequest request, HttpServletResponse response,String salesCode) throws GeneralException {
		String result  = "";
		try {
			result = salesmanVirtualService.querySalesmanName(salesCode);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(salesCode), e);
		}
		SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/queryVirtualName")
	public void queryVirtualName(HttpServletRequest request, HttpServletResponse response,String employCode) throws GeneralException {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String employName = "";
		try {
			employName = salesmanVirtualService.queryVirtualName(employCode);
			resultMap.put("employName", employName);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(employCode), e);
		}
		SendUtil.sendJSON(response, resultMap);
	}

}
