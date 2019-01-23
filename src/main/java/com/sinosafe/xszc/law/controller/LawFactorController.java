package com.sinosafe.xszc.law.controller;

import java.io.IOException;
import java.io.PrintWriter;
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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.law.service.LawFactorService;
import com.sinosafe.xszc.law.vo.LawFactor;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/lawFactor")
public class LawFactorController {

	private static final Log log = LogFactory.getLog(LawFactorController.class);

	@Autowired
	@Qualifier("LawFactorService")
	private LawFactorService lawFactorService;
	
	/**
	 *  分页查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryLawFactor")
	public void queryLawFactor(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = lawFactorService.findLawFactorByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 		新增因素
	 * @param request
	 * @param response
	 * @param lawFactor
	 * @throws GeneralException
	 */
	@RequestMapping("/saveLawFactor")
	public void saveLawFactor(HttpServletRequest request, HttpServletResponse response, LawFactor lawFactor) throws GeneralException {
		lawFactor.setLastOpt(CurrentUser.getUser().getUserCode());
		lawFactor.setChannelId("1");
		lawFactor.setValidInd("1");
		if( "".equals(lawFactor.getSerno()) ||  lawFactor.getSerno() == null){
			//获取最大流水号加 1
			String number = lawFactorService.getSerialNumber().toString();
			lawFactor.setSerno(number);
		}
		try {
			lawFactorService.saveLawFactor(lawFactor);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(lawFactor), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 		修改因素
	 * @param request
	 * @param response
	 * @param serno
	 * @throws GeneralException
	 */
	@RequestMapping("/queryLawFactorToUpdate")
	public void queryLawFactorToUpdate(HttpServletRequest request, HttpServletResponse response, String serno) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = lawFactorService.queryLawFactorToUpdate(serno);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + serno, e);
		}
		SendUtil.sendJSON(response, rows);
	}

	/**
	 * 删除
	 * @param request
	 * @param response
	 * @param serno
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteLawFactor")
	public void deleteLawFactor(HttpServletRequest request, HttpServletResponse response,String  serno) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		LawFactor lawFactor = new LawFactor();
		lawFactor.setSerno(serno);
		try {
			lawFactorService.deleteLawFactor(lawFactor);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(lawFactor), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 校验重复
	 * @param request
	 * @param response
	 * @param serno
	 * @throws GeneralException
	 */
	@RequestMapping("/queryItemCode")
	public void queryItemCode(HttpServletRequest request, HttpServletResponse response, String itemCode) throws GeneralException {
		try {
			Boolean bool = lawFactorService.queryItemCode(itemCode);
			request.setCharacterEncoding("utf-8");
	    	response.reset();
	        response.setCharacterEncoding("utf-8");
	        response.setContentType("text/html; charset=UTF-8");
	        PrintWriter writer = response.getWriter();
			writer.write(Boolean.toString(!bool));
	        writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + itemCode, e);
		}
	}
	
	/**
	 * 查询因素COD和名称 用于指标因素关系指定
	 * @param pageDto
	 * @return
	 */
	@RequestMapping("/queryCodeAndName")
	public void queryCodeAndName(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		Map<String,Object> factorMap = new HashMap<String,Object>();
		
		List<Map<String, Object>> resList = (List<Map<String, Object>>) lawFactorService.queryCodeAndName(factorMap);
		JSONArray result=new JSONArray();
		try {
			if(resList.size()>0){
				for(int i=0;i<resList.size();i++){
					result.add( buildUser(resList.get(i).get("itemCode").toString(),resList.get(i).get("itemName").toString()) );
				}
			}else {
				result.add( buildUser("","暂无因素数据！") );
			}
			response.reset();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer;
			writer = response.getWriter();
			writer.write(result.toString());
			writer.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 拼装json字符串
	 * @param id
	 * @param name
	 * @return JSONObject
	 */
	private JSONObject buildUser(String id,String name){
	    JSONObject result=new JSONObject();
	    result.put("value", id);
	    result.put("text", name);
	    return result;
	}
	
}
