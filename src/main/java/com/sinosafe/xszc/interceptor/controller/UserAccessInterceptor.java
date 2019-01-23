/**
 * Project Name:fastPlat
 * File Name:SysLogInterceptor.java
 * Package Name:com.fast.intercept
 * Date:2015年3月5日下午10:51:24
 * Copyright (c) 2015, lsflu@126.com All Rights Reserved.
 *
 */

package com.sinosafe.xszc.interceptor.controller;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.sinosafe.xszc.common.controller.BaseWebUtil;
import com.sinosafe.xszc.common.service.CommonServerice;
import com.sinosafe.xszc.main.service.UserAccessRecordService;

/**
 * ClassName:SysLogInterceptor <br/>
 * 用途:用户访问记录 <br/>
 * 开发人员：lushuifa http://lushuifa.iteye.com/ 邮箱:lsflu@126.com
 * 
 * @version
 * @since JDK 1.6
 * @see Date: 2015年3月5日 下午10:51:24 <br/>
 */
public class UserAccessInterceptor implements HandlerInterceptor {

	protected final static Log log = LogFactory.getLog(UserAccessInterceptor.class);

	@Autowired
	@Qualifier(value = "UserAccessRecordService")
	private UserAccessRecordService userAccessRecordService;

	@Autowired
	@Qualifier("CommonServerice")
	private CommonServerice commonServerice;

	HttpServletRequest request = null;

	// 当前用户
	IUserDetails curUserInfo = null;

	// 访问地址
	String url = "";

	// 访问处理器
	HandlerMethod handlerMethod = null;

	String curDeptCode = "";

	/**
	 * 第一执行 在业务处理器处理请求之前被调用 如果返回false 从当前的拦截器往回执行所有拦截器的afterCompletion(),再退出拦截器链 如果返回true 执行下一个拦截器,直到所有的拦截器都执行完毕 再执行被拦截的Controller 然后进入拦截器链,
	 * 从最后一个拦截器往回执行所有的postHandle() 接着再从最后一个拦截器往回执行所有的afterCompletion()
	 */

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		Object object = request.getSession().getAttribute("curDeptCode");
		// 检验部门session值
		curDeptCode = commonServerice.getUserDept();
		if (object == null) {
			BaseWebUtil.reDeptCodeInSession(request, curDeptCode);
		}

		if (curDeptCode != null) {
			if (curDeptCode.equals("")) {
				curDeptCode = "00";
			}
		} else if (curDeptCode == null) {
			curDeptCode = "";
		}
		return true;
	}

	/**
	 * 第二执行 在业务处理器处理请求执行完成后,生成视图之前执行的动作 TODO 简单描述该方法的实现功能（可选）.
	 * 
	 * @see org.springframework.web.servlet.HandlerInterceptor#postHandle(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse,
	 *      java.lang.Object, org.springframework.web.servlet.ModelAndView)
	 */
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		this.request = request;
		url = request.getRequestURI().toString();
		try {
			if (validateUrl(url)) {
				curUserInfo = CurrentUser.getUser();
				handlerMethod = (HandlerMethod) handler;
				Method actionMethod = handlerMethod.getMethod();
				String controllerJavaName = actionMethod.getDeclaringClass().getName();
				String parentValue = controllerJavaName.split("\\.")[3];
				if (!parentValue.equals("common") && !parentValue.equals("main") && !parentValue.equals("department") && !parentValue.equals("upload")
						&& !parentValue.equals("interceptor")) {
					Map<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("ip", BaseWebUtil.getIpAddr(request));
					paramMap.put("url", url);
					paramMap.put("deptCode", curDeptCode);
					// 得到当前用户信息
					AccessThread accessThread = new AccessThread(actionMethod, userAccessRecordService, paramMap);
					accessThread.start();
				}
			}
		} catch (Exception e) {
			log.info(url + e);
		}
	}

	/**
	 * 第三执行 在DispatcherServlet完全处理完请求后被调用 当有拦截器抛出异常时,会从当前拦截器往回执行所有的拦截器的afterCompletion()
	 */
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object object, Exception e) throws Exception {

	}

	// 验证访问路路径是否可用
	private boolean validateUrl(String url) {
		String[] pathArray = { "/core", "/css", "/ExportExcel", "/images/", "/index", "/styles", "/styles", "/WEB-INF" };
		for (int i = 0; i < pathArray.length; i++) {
			if (url.contains(pathArray[i])) {
				return false;
			}
		}
		return true;
	}
}
