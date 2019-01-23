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
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.law.service.LawSpecifyService;
import com.sinosafe.xszc.law.vo.LawDefineDept;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/lawSpecify")
public class LawSpecifyController {

	private static final Log log = LogFactory.getLog(LawSpecifyController.class);

	@Autowired 
	@Qualifier(value = "umService") 
	private UmService umService;
	
	@Autowired
	@Qualifier("LawSpecifyService")
	private LawSpecifyService lawSpecifyService;

	@RequestMapping("/queryLawSpecify")
	public void queryLawSpecify(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		if(paramMap.get("deptCode")==null || "".equals(paramMap.get("deptCode"))){
			List<Map<String, Object>> list = umService.findDeptListByUserCode(CurrentUser.getUser().getUserCode());
			if(list != null && list.size() == 1){
				paramMap.put("deptCode", list.get(0).get("deptCode"));
			}
		}
		pageDto.setWhereMap(paramMap);
		try {
			pageDto = lawSpecifyService.findLawSpecifyByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/saveLawSpecify")
	public void saveLawSpecify(HttpServletRequest request, HttpServletResponse response, LawDefineDept lawDefineDept) throws GeneralException {
		try {
			lawSpecifyService.saveLawSpecify(lawDefineDept);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(lawDefineDept), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	@RequestMapping("/queryLawSpecifyToUpdate")
	public void queryLawSpecifyToUpdate(HttpServletRequest request, HttpServletResponse response, String pkUuid) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = lawSpecifyService.queryLawSpecifyToUpdate(pkUuid);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + pkUuid, e);
		}
		SendUtil.sendJSON(response, rows);
	}
	
	@RequestMapping("/updateLawSpecify")
	public void updateLawSpecify(HttpServletRequest request, HttpServletResponse response, LawDefineDept lawDefineDept)throws GeneralException{
		String pkUuid = lawDefineDept.getPkUuid();
		String deptCode = lawDefineDept.getDeptCode();
		String isValid = lawDefineDept.getIsValid();
		try {
			if("1".equals(isValid)){
				//SendUtil.sendString(response, "donothing");
			}else{
				lawSpecifyService.updateLawSpecifyNotValid(deptCode);
				lawSpecifyService.updateLawSpecifyIsValid(pkUuid);
			}
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + pkUuid, e);
		}
		//SendUtil.sendString(response, "OK");
	}
	@RequestMapping("/deleteLawSpecify")
	public void deleteLawSpecify(HttpServletRequest request, HttpServletResponse response, String pkUuid) throws GeneralException {
		try {
			lawSpecifyService.deleteLawSpecify(pkUuid);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + pkUuid, e);
		}
		SendUtil.sendJSON(response, "success");
	}
}
