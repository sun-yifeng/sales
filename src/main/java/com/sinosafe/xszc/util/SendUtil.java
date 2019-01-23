package com.sinosafe.xszc.util;

import java.io.IOException;
import java.util.Collection;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

public abstract class SendUtil {

	private static final Log log = LogFactory.getLog(SendUtil.class);

	@SuppressWarnings("rawtypes")
	public static void sendJSONList(HttpServletResponse response, Collection list) {
		if (list != null) {
			try {
				response.getWriter().print(JSONArray.toJSONString(list));
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			throw new RuntimeException("SendUtil.sendJSONList方法给定的参数list为null");
		}
	}

	public static void sendJSON(HttpServletResponse response,Object obj) {
		if (obj != null) {
			try {
				response.getWriter().print(JSONObject.toJSONString(obj));
				log.debug("返回到页面的json数据:" + JSONObject.toJSONString(obj));
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			throw new RuntimeException("SendUtil.sendJSON方法给定的参数list为null");
		}
	}

	public static void sendString(HttpServletResponse response, String str) {
		if (str != null) {
			try {
				response.getWriter().print(str);
				log.debug("返回到页面的json数据:" + str);
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			throw new RuntimeException("SendUtil.sendString方法给定的参数str为null");
		}
	}
}
