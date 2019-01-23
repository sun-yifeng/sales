package com.sinosafe.xszc.common.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hf.framework.core.context.PlatformContext;
import com.hf.framework.service.security.CurrentUser;

/**
 * 类名:com.sinosafe.xszc.common.controller.BaseWebUtil <pre>
 * 描述:基础web工具类
 * 基本思路:
 * 特别说明:无
 * 编写者:卢水发
 * 创建时间:2015年8月6日 上午11:36:08
 * 修改说明:无修改说明
 * </pre>
 */
public class BaseWebUtil {
	
	/**
	 * 获取ip地址
	 * @return
	 */
	public static String getIpAddr(HttpServletRequest request) {
		try {
			String ip = request.getHeader("x-forwarded-for");
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getHeader("Proxy-Client-IP");
			}
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getHeader("WL-Proxy-Client-IP");
			}
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getRemoteAddr();
			}
			if (ip != null) {
				if(ip.equals("0:0:0:0:0:0:0:1")){
					ip = "127.0.0.1";
				}
			}
			return ip;
		} catch (Exception e) {
			return "获取失败";
		}
	}
	
	/**
	 * 重新设置部门session
	 * @return deptCode
	 */
	public static String reDeptCodeInSession(HttpServletRequest request,String curDeptCode) {
		Object object = request.getSession().getAttribute("curDeptCode");
		if(object!=null){
			return String.valueOf(object);
		}
		if(curDeptCode!=null){
			if(curDeptCode.equals("")){
				curDeptCode = "00";
			}
			request.getSession().setAttribute("curDeptCode",curDeptCode);
		}
		return curDeptCode;
	}
}
