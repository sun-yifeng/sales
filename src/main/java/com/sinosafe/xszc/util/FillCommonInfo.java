package com.sinosafe.xszc.util;

import java.util.Map;

import com.hf.framework.service.security.CurrentUser;

/**
 * 自动装填 创建人、创建时间等通用表字段相关信息
 *
 * 类名:com.sinosafe.xszc.util.FillCommonInfo <pre>
 * 描述:
 * 基本思路:
 * 特别说明:
 * 编写者:李晓亮
 * 创建时间:2014年6月30日 上午11:37:11
 * 修改说明: 类的修改说明
 * </pre>
 */
public class FillCommonInfo {
	/**
	 * Map 通用字段填装
	 *
	 * TODO 方法fillParamMap的简要说明 <br><pre>
	 * 方法fillParamMap的详细说明 <br>
	 * 编写者：李晓亮
	 * 创建时间：2014年6月30日 上午11:42:38 </pre>
	 * @param paraMap 待保存信息
	 * @param a 装填类型(update,insert)
	 * @return void 说明
	 * @throws 异常类型 说明
	 */

	public static void fillParamMap(Map<String, Object> paraMap, String a) {
		String userCode = CurrentUser.getUser().getUserCode();
		if (a.equals("insert")) {
			paraMap.put("createdUser", userCode);
			paraMap.put("updatedUser", userCode);
		} else if (a.equals("update")) {
			paraMap.put("updatedUser", userCode);
		} else if (a.equals("delete")){
			paraMap.put("updatedUser", userCode);
			paraMap.put("validInd", '0');
		}
	}

}
