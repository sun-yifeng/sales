package com.sinosafe.xszc.interceptor.service.impl;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.interceptor.service.SessionTimeoutProcessService;

public class SessionTimeoutProcessServiceImpl implements SessionTimeoutProcessService {
	
	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;
	
	@Override
    public boolean fillSession(HttpServletRequest request, HttpServletResponse response) {  
        	Map<String, Object> deptMap = umService.findDefaultDeptCodeByUserCode(CurrentUser.getUser().getUserCode());
    		String defaultDeptString = "###";
    		if (deptMap != null) {
    			defaultDeptString = (String) deptMap.get("deptCode");
    		}
        	request.getSession().setAttribute("imgUrl", umService.findSystemExtsPropertiesBySysCode("xszc").getProperty("imgUrl"));
        	request.getSession().setAttribute("defaultDept", defaultDeptString);
        	return true;
    }
}
