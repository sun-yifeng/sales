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
import com.sinosafe.xszc.law.service.LawTargetService;
import com.sinosafe.xszc.law.vo.LawTarget;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/lawTarget")
public class LawTargetController {

	private static final Log log = LogFactory.getLog(LawTargetController.class);

	@Autowired
	@Qualifier("LawTargetService")
	private LawTargetService lawTargetService;
	
	/**
	 * 分页查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryLawTarget")
	public void queryLawTarget(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = lawTargetService.findLawTargetByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 		新增指标
	 * @param request
	 * @param response
	 * @param lawTarget
	 * @throws GeneralException
	 */
	@RequestMapping("/saveLawTarget")
	public void saveLawTarget(HttpServletRequest request, HttpServletResponse response, LawTarget lawTarget) throws GeneralException {
		lawTarget.setLastOpt(CurrentUser.getUser().getUserCode());
		lawTarget.setChannelId("1");
		lawTarget.setValidInd("1");
		if( "".equals(lawTarget.getSerno()) ||  lawTarget.getSerno() == null){
			//获取最大流水号加 1
			String number = lawTargetService.getSerialNumber().toString();
			lawTarget.setSerno(number);
		}
		try {
			lawTargetService.saveLawTarget(lawTarget);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(lawTarget), e);
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
	@RequestMapping("/queryLawTargetToUpdate")
	public void queryLawTargetToUpdate(HttpServletRequest request, HttpServletResponse response, String serno) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = lawTargetService.queryLawTargetToUpdate(serno);
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
	@RequestMapping("/deleteLawTarget")
	public void deleteLawTarget(HttpServletRequest request, HttpServletResponse response,String  serno) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		LawTarget lawTarget = new LawTarget();
		lawTarget.setSerno(serno);
		try {
			lawTargetService.deleteLawTarget(lawTarget);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(lawTarget), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 校验重复
	 * @param request
	 * @param response
	 * @param indexCode
	 * @throws GeneralException
	 */
	@RequestMapping("/queryIndexCode")
	public void queryIndexCode(HttpServletRequest request, HttpServletResponse response, String indexCode) throws GeneralException {
		try {
			Boolean bool = lawTargetService.queryIndexCode(indexCode);
			request.setCharacterEncoding("utf-8");
	    	response.reset();
	        response.setCharacterEncoding("utf-8");
	        response.setContentType("text/html; charset=UTF-8");
	        PrintWriter writer = response.getWriter();
			writer.write(Boolean.toString(!bool));
	        writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + indexCode, e);
		}
	}

	/**
	 * 查询因素COD和名称 用于指标因素关系指定
	 * @param pageDto
	 * @return
	 */
	@RequestMapping("/queryCodeAndName")
	public void queryCodeAndName(HttpServletRequest request, HttpServletResponse response ,String indexCode) throws GeneralException {
		Map<String,Object> indexMap = new HashMap<String,Object>();
		indexMap.put("indexCode", indexCode);
		List<Map<String, Object>> resList = (List<Map<String, Object>>) lawTargetService.queryCodeAndName(indexMap);
		JSONArray result=new JSONArray();
		try {
			if(resList.size()>0){
				for(int i=0;i<resList.size();i++){
					result.add( buildUser(resList.get(i).get("indexCode").toString(),resList.get(i).get("indecName").toString()) );
				}
			}else {
				result.add( buildUser("","暂无指标数据！") );
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
