package com.sinosafe.xszc.upload.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.activity.controller.ActivityController;
import com.sinosafe.xszc.upload.service.UploadService;
import com.sinosafe.xszc.util.GetRequestMap;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/upload")
public class UploadController {
	private static Logger logger = Logger.getLogger(ActivityController.class);
	@Autowired
	@Qualifier("UploadService")
	private UploadService uploadService;

	@Autowired
	@Qualifier("umService")
	private UmService umService;

	@RequestMapping("/queryUpload")
	public void queryUpload(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		Map<String, Object> paramMap = new GetRequestMap().getRequstMap(request);
		List<Object> resultList = new ArrayList<Object>();
		paramMap.remove("deptCode");
		try {
			resultList = uploadService.findUploadInfo(paramMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		SendUtil.sendJSON(response, resultList);
	}

	@RequestMapping("/queryUploadWithDpt")
	public void queryUploadWithDpt(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		Map<String, Object> paramMap = new GetRequestMap().getRequstMap(request);
		List<Object> resultList = new ArrayList<Object>();
		if (paramMap.get("deptCode") == null) {
			Map<String, Object> deptMap = umService.findDefaultDeptCodeByUserCode(CurrentUser.getUser().getUserCode());
			String deptCode = "";
			if (deptMap != null) {
				deptCode = (String) deptMap.get("deptCode");
			}
			paramMap.put("deptCode", deptCode.length() <= 0 ? "000000" : deptCode);
		}
		try {
			resultList = uploadService.findUploadInfo(paramMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		SendUtil.sendJSON(response, resultList);
	}

	@RequestMapping("/queryUploadByMainId")
	public void queryUploadByMainId(HttpServletRequest request, HttpServletResponse response,String mainId,String module) throws GeneralException {
		Map<String, Object> paramMap = new HashMap<String,Object>();
		paramMap.put("mainId", mainId);
		paramMap.put("module", module);
		List<Map<String, Object>> resultList;
		try {
			resultList = uploadService.queryUploadByMainId(paramMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		SendUtil.sendJSON(response, resultList);
	}
}
