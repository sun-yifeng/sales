package com.sinosafe.xszc.interceptor.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface SessionTimeoutProcessService {
	public boolean fillSession(HttpServletRequest request, HttpServletResponse response);
}
