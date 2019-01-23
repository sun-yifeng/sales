package com.sinosafe.xszc.util;

import javax.servlet.http.HttpServletRequest;

public class IPAddressUtil {
	
	/**
	 * 获取远程登录用户的电脑ip地址
	 * @param request
	 * @return
	 */
	public static String getRemortIP(HttpServletRequest request) {
        if (request.getHeader("x-forwarded-for") == null) {
         return request.getRemoteAddr();
        }
        return request.getHeader("x-forwarded-for");
     }
}
