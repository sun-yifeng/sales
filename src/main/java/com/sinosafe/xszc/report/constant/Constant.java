package com.sinosafe.xszc.report.constant;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

public class Constant {

	public final static JSONArray JSON(String type) {
		JSONArray jsonArr = new JSONArray();
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("value", "");
		jsonObj.put("text", "请选择");
		jsonArr.add(jsonObj);
		if ("insureType".equals(type)) {
			for (String[] str : insureType) {
				jsonArr.add(setValue(str));
			}
		} else if ("bizLine".equals(type)) {
			for (String[] str : bizLine) {
				jsonArr.add(setValue(str));
			}
		}
		return jsonArr;
	}

	public static JSONObject setValue(String[] str) {
		JSONObject oo = new JSONObject();
		oo.put("value", str[0]);
		oo.put("text", str[1]);
		return oo;
	}

	// 险种
	public static String[][] insureType = { { "车险", "车险" }, { "财产险", "财产险" }, { "人身险", "人身险" }, { "理财险", "理财险" }, { "学贷险", "学贷险" } };
	
	// 业务线
	public static String[][] bizLine = {{ "925004电话直销", "925004电话直销" }, { "925005网销业务", "925005网销业务" }, { "925006渠道重客", "925006渠道重客" }, 
			                             { "925007其他业务", "925007其他业务" }, { "925008信用保证险", "925008信用保证险" }, { "925009创新", "925009创新" } };

}
