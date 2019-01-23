package com.sinosafe.xszc.auth.controller;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.auth.service.AuthService;
import com.sinosafe.xszc.channel.controller.AgentController;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/auth")
public class AuthController {

	private static final Log log = LogFactory.getLog(AuthController.class);
	
	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;
	
	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;
	
	@Autowired
	@Qualifier("AuthService")
	private AuthService authService;

	@RequestMapping("/findCfgDept")
	public void findBtnCfg(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException {
		// 为true则关闭按钮
		boolean flag = false;
		String deptCode = (String) request.getSession().getAttribute("defaultDept");
		//String deptCode = list2.get(0).get("deptCode").toString();
		if(StringUtils.isNotEmpty(deptCode)){
			log.info("deptCode : " + deptCode);
			flag = authService.findBtnCfg(deptCode);
		}
		SendUtil.sendJSON(response, flag);
	}

	@RequestMapping("/findCfgHtml")
	public void findBtnHtml(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException {
		List<Map<String, Object>> list = authService.findBtnHtml();		
		SendUtil.sendJSON(response, list);
	}
	
}
