package com.sinosafe.xszc.common.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.core.context.PlatformContext;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.common.service.CommonServerice;
import com.sinosafe.xszc.constant.Constant;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/common")
public class CommonController {

	private static final Log log = LogFactory.getLog(CommonController.class);

	@Autowired
	@Qualifier("CommonServerice")
	private CommonServerice commonServerice;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;
	
	@Autowired
	@Qualifier("NoticeService")
	private NoticeService noticeService;

	/**
	 * 省地区编码
	 * @param response
	 */
	@RequestMapping("/queryProvince")
	public void queryProvince(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryProvince();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("province").toString(), resList.get(i).get("cname").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 市级编码
	 * 
	 * @param response
	 * @param province 省编码
	 */
	@RequestMapping("/queryCity")
	public void queryCity(HttpServletResponse response, String province) {
		List<Map<String, Object>> resList = commonServerice.queryCity(province);
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("cityCode").toString(), resList.get(i).get("cname").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 银行编码
	 * 
	 * @param response
	 */
	@RequestMapping("/queryBank")
	public void queryBank(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryBank();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("bankCode").toString(), resList.get(i).get("bankCname").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 渠道大类
	 * 
	 * @param response
	 */
	@RequestMapping("/queryCategory")
	public void queryCategory(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryCategory();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("categoryCode").toString(), resList.get(i).get("categoryName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}
	
	/**
	 * 渠道类型、渠道性质
	 * 
	 * @param response
	 */
	@RequestMapping("/queryProperty")
	public void queryProperty(HttpServletResponse response, String parentCode) {
		List<Map<String, Object>> resList = commonServerice.queryProperty(parentCode);
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("categoryCode").toString(), resList.get(i).get("categoryName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}
	
	/**
	 * 渠道性质
	 * 
	 * @param response
	 */
	@RequestMapping("/queryPropertyMV")
	public void queryPropertyMV(HttpServletResponse response, String parentCode) {
		List<Map<String, Object>> resList = commonServerice.queryPropertyMV(parentCode);
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("categoryCode").toString(), resList.get(i).get("categoryName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 渠道特征
	 * 
	 * @param response
	 */
	@RequestMapping("/queryChannelFeature")
	public void queryChannelFeature(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryChannelFeature();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("channelCode").toString(), resList.get(i).get("channelName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 所属行业
	 * 
	 * @param response
	 */
	@RequestMapping("/queryProfession")
	public void queryProfession(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryProfession();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("professionCode").toString(), resList.get(i).get("professionName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 业务线
	 * 
	 * @param response
	 */
	@RequestMapping("/queryBusinessLine")
	public void queryBusinessLine(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryBusinessLine();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("lineCode").toString(), resList.get(i).get("lineName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}
	
	/**
	 * 新的业务线获取
	 * @param response
	 */
	@RequestMapping("/queryBusinessLineNew")
	public void queryBusinessLineNew(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryBusinessLineNew();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("lineCode").toString(), resList.get(i).get("lineName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}
	
	/**
	 * 获取HR人员处理的业务线
	 */
	@RequestMapping("/queryEmployeeProcessBusinessLine")
	public void queryEmployeeProcessBusinessLine(HttpServletResponse response){
		List<String> subBusinessLines = noticeService.filterSubBusinessLines();	
		SendUtil.sendJSON(response,noticeService.queryBusinessline(subBusinessLines));
	}
	
     /**
	 * 新业务线
	 * @param response
	 */
	@RequestMapping("/loadBline")
	public void loadBline(HttpServletResponse response) {
		JSONArray result = new JSONArray();
		result=Constant.getCombo("bizLine");
		SendUtil.sendJSON(response, result);
	}

	/**
	 * 渠道层级
	 * 
	 * @param response
	 */
	@RequestMapping("/queryChannelLevel")
	public void queryChannelLevel(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryChannelLevel();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("levelCode").toString(), resList.get(i).get("levelName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 国家地区
	 * 
	 * @param response
	 */
	@RequestMapping("/queryCountry")
	public void queryCountry(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryCountry();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("countryCode").toString(), resList.get(i).get("countryName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 协议类型
	 * 
	 * @param response
	 */
	@RequestMapping("/queryConferType")
	public void queryConferType(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryConferType();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("conferCode").toString(), resList.get(i).get("conferName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 合作渠道类型
	 * 
	 * @param response
	 */
	@RequestMapping("/queryChannelPartnerType")
	public void queryChannelPartnerType(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryChannelPartnerType();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("channelPartnerCode").toString(), resList.get(i).get("channelPartnerName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 证件类型
	 * 
	 * @param response
	 */
	@RequestMapping("/queryCertifyType")
	public void queryCertifyType(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryCertifyType();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("certifyTypeCode").toString(), resList.get(i).get("certifyTypeName").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 学历
	 * 
	 * @param response
	 */
	@RequestMapping("/queryEducatioin")
	public void queryEducatioin(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryEducatioin();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 职称
	 * 
	 * @param response
	 */
	@RequestMapping("/queryTitle")
	public void queryTitle(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryTitle();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 产品大类
	 * 
	 * @param response
	 */
	@RequestMapping("/queryTPrdKind")
	public void queryTPrdKind(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryTPrdKind();
		JSONArray result = new JSONArray();
		try {
			// result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("code").toString()+ " "+resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询产品分类错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 产品编码
	 * 
	 * @param response
	 * @param prdType
	 */
	@RequestMapping("/queryPrdCode")
	public void queryPrdCode(HttpServletResponse response, String prdType) {
		List<Map<String, Object>> resList = commonServerice.queryPrdCode(prdType);
		JSONArray result = new JSONArray();
		try {
			// result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("code").toString() + " " +resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 民族
	 * 
	 * @param response
	 */
	@RequestMapping("/queryNational")
	public void queryNational(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryNational();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询市级地区错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 对应总司职级
	 * 
	 * @param response
	 */
	@RequestMapping("/querySaleRank")
	public void querySaleRank(HttpServletRequest request, HttpServletResponse response, String managerFlag) {
		List<Map<String, Object>> resList = commonServerice.querySaleRank(managerFlag);
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询销售职级错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 员工状态
	 * 
	 * @param response
	 */
	@RequestMapping("/querySalesmanStatus")
	public void querySalesmanStatus(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.querySalesmanStatus();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询市级地区错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 员工类型
	 * 
	 * @param response
	 */
	@RequestMapping("/querySalesmanType")
	public void querySalesmanType(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.querySalesmanType();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询市级地区错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 银行网点
	 * 
	 * @param response
	 */
	@RequestMapping("/queryBankNode")
	public void queryBankNode(HttpServletResponse response, String bank, String city) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bank", bank);
		map.put("city", city);

		List<Map<String, Object>> resList = commonServerice.queryBankNode(map);
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询银行网点错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 团队长职级
	 * 
	 * @param response
	 */
	@RequestMapping("/queryGroupRank")
	public void queryGroupRank(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryGroupRank();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询团队长职级错误！！");
			e.printStackTrace();
		}
	}

	/**
	 * 查询出用户角色权限，用于页面数据显示的操作
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/findRolesInSystemByUserCode")
	public void findRolesInSystemByUserCode(HttpServletRequest request, HttpServletResponse response) {
		String roleName = null;
		// 获取当前登录用户
		String userCode = CurrentUser.getUser().getUserCode();
		// 获取系统标识
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		// 查询出登录用户的角色
		List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);
		// 获取当前登录用户的第一个角色权限
		roleName = (String) roleCodeList.get(0).get("roleEname");
		try {
			response.getWriter().print(roleName);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * <pre>
	 * 查询出用户是否拥护某个角色
	 * @param request
	 * @param response
	 * @param roleName 可传入多个角色，用英文逗号分开，如"subDeptMarketM,thirdDeptMiddle"；可传入单个角色，如 "subDeptMarketM"
	 * </pre>
	 */
	@RequestMapping("/existRolesInSystemByUserCode")
	public void existRolesInSystemByUserCode(HttpServletRequest request, HttpServletResponse response, String roleName) {
		boolean flag = false;
		String userCode = CurrentUser.getUser().getUserCode();
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);

		String[] roleArray = roleName.split(",");

		for (int i = 0; i < roleArray.length; i++) {
			for (int j = 0; j < roleCodeList.size(); j++) {
				if (roleArray[i].equals((String) roleCodeList.get(j).get("roleEname"))) {
					flag = true;
					break;
				}
			}
			if (flag) {
				break;
			}
		}

		try {
			log.debug("权限控制,用户:" + userCode);
			log.debug("从页面传入的角色:" + roleName);
			log.debug("从后台返回的角色:" + JSON.toJSONString(roleCodeList));
			log.debug("是否有权限" + roleName + ":" + flag);
			response.getWriter().print(flag);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 查询出用户角色权限，用于页面数据显示的操作
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/findRoleJSONByUserCode")
	public void findRoleJSONByUserCode(HttpServletRequest request, HttpServletResponse response) {
		String userCode = CurrentUser.getUser().getUserCode();
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);
		SendUtil.sendJSON(response, roleCodeList);
	}

	/**
	 * <pre>
	 * 查询出用户所在机构，用于页面数据显示的操作 如果某个用户有多个机构，则默认取第一个
	 * @param request
	 * @param response
	 * </pre>
	 */
	@RequestMapping("/findDeptByUserCode")
	public void findDeptByUserCode(HttpServletRequest request, HttpServletResponse response) {
		String userDept = null;
		// 获取当前登录用户
		String userCode = CurrentUser.getUser().getUserCode();
		// 查询出登录用户的角色
		List<Map<String, Object>> roleCodeList = umService.findDeptListByUserCode(userCode);
		// 获取当前登录用户机构
		userDept = (String) roleCodeList.get(0).get("deptCode");
		try {
			response.getWriter().print(userDept);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 理财险渠道标识
	 * 
	 * @param response
	 */
	@RequestMapping("/queryFinancePolicyFlag")
	public void queryFinancePolicyFlag(HttpServletResponse response) {
		List<Map<String, Object>> resList = commonServerice.queryFinancePolicyFlag();
		JSONArray result = new JSONArray();
		try {
			result.add(buildDept("", "请选择"));
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("code").toString(), resList.get(i).get("name").toString()));
			}
			outPut(response, result);
		} catch (IOException e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}
	
	/**
	 * 
	 */
	@RequestMapping("/queryCurrUserRoleEname")
	public void queryCurrUserRoleEname(HttpServletRequest request, HttpServletResponse response){
		// 获取当前登录用户
		String userCode = CurrentUser.getUser().getUserCode();
		// 获取系统标识
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		// 查询出登录用户的角色
		List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);
		String roleEnameStrs = "";
		for (int i = 0; i < roleCodeList.size(); i++) {
			Map<String, Object> map = roleCodeList.get(i);
			String roleEname = (String)map.get("roleEname");
			if(i < roleCodeList.size()-1){
				roleEnameStrs += roleEname + ",";
			}else{
				roleEnameStrs += roleEname;
			}
		}
		
		try {
			response.getWriter().print(roleEnameStrs);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	/**
	 * 拼装json字符串
	 * 
	 * @param id
	 * @param name
	 * @return JSONObject
	 */
	private JSONObject buildDept(String id, String name) {
		JSONObject result = new JSONObject();
		result.put("value", id);
		result.put("text", name);
		return result;
	}

	private void outPut(HttpServletResponse response, JSONArray result) throws IOException {
		response.reset();
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter writer;
		writer = response.getWriter();
		writer.write(result.toString());
		writer.flush();
	}
	
}
