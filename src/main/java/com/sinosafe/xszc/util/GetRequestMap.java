package com.sinosafe.xszc.util;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * <pre>
 * 封装request参数，存入hashMap
 * 类名:com.sinosafe.xszc.util.GetRequestMap :
 * 编写者:李晓亮
 * 创建时间:2014年6月24日 上午10:16:18
 * 修改说明: 类的修改说明
 * </pre>
 */
public class GetRequestMap {

	private static final Log log = LogFactory.getLog(GetRequestMap.class);

	private Map<String, Object> searchIfoMap = new HashMap<String, Object>();

	/**
	 * <pre>
	 * 遍历获取request参数，并以map形式返回
	 * 方法getRequstMap的简要说明 <br>
	 * 方法getRequstMap的详细说明 <br>
	 * 编写者：李晓亮
	 * 创建时间：2014年6月24日 上午10:15:20
	 * </pre>
	 * 
	 * @param request
	 * @return
	 * @return Map<String,Object>说明
	 * @throws 异常类型说明
	 */
	public Map<String, Object> getRequstMap(HttpServletRequest request) {
		@SuppressWarnings("rawtypes")
		Enumeration paramNames = request.getParameterNames();
		while (paramNames.hasMoreElements()) {
			String paramName = (String) paramNames.nextElement();
			String paramValue = request.getParameter(paramName);
			if (paramValue.length() != 0) {
				log.debug("从HttpServletRequest中获取的参数:" + paramName + " = " + paramValue);
				searchIfoMap.put(paramName, paramValue);
			}
		}
		return searchIfoMap;
	}

	public void setSearchIfoMap(Map<String, Object> searchIfoMap) {
		this.searchIfoMap = searchIfoMap;
	}

	public Map<String, Object> getSearchIfoMap() {
		return searchIfoMap;
	}
}
