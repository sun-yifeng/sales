package com.sinosafe.xszc.law.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.common.service.CommonServerice;
import com.sinosafe.xszc.constant.Constant;
import com.sinosafe.xszc.law.service.LawDefineManualService;
import com.sinosafe.xszc.law.service.LawDefineService;
import com.sinosafe.xszc.law.service.LawRateService;
import com.sinosafe.xszc.law.service.LawSpecifyService;
import com.sinosafe.xszc.law.vo.LawDefine;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/lawDefine")
public class LawDefineController {

	private static final Log log = LogFactory.getLog(LawDefineController.class);

	@Autowired
	@Qualifier("LawSpecifyService")
	private LawSpecifyService lawSpecifyService;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@Autowired
	@Qualifier("LawDefineService")
	private LawDefineService lawDefineService;

	@Autowired
	@Qualifier("LawRateService")
	private LawRateService lawRateService;

	@Autowired
	@Qualifier("CommonServerice")
	private CommonServerice commonServerice;

	@Autowired
	@Qualifier(value = "noticeService")
	private NoticeService noticeService;
	
	@Autowired
	@Qualifier("LawDefineManualService")
	private LawDefineManualService lawDefineManualService;

	@RequestMapping("/getCurDeptTwo")
	@VisitDesc(label = "查询分公司", actionType = 4, hidden = true)
	public void getCurDeptTwo(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String deptCode = request.getSession().getAttribute("curDeptCode").toString();
		JSONArray jsonArray = Constant.getData("deptTwo");
		if (deptCode.equals("") || deptCode.equals("00")) {
			response.getWriter().write(jsonArray.toJSONString());
			return;
		} else {
			JSONArray jsonArray2 = new JSONArray();
			for (Object object : jsonArray) {
				JSONObject joObject = (JSONObject) object;
				if (joObject.getString("value").startsWith(deptCode)) {
					jsonArray2.add(joObject);
				}
			}
			log.debug(jsonArray2.toJSONString());
			response.getWriter().write(jsonArray2.toJSONString());
			return;
		}
	}

	@RequestMapping("/getCurLineCode")
	@VisitDesc(label = "得到业务线", actionType = 4, hidden = true)
	public void getCurLineCode(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String deptCode = request.getSession().getAttribute("curDeptCode").toString();
		// 登录者业务线
		List<String> lineCodeFix = noticeService.filterSubBusinessLines();
		String curCodeFix = JSONArray.toJSONString(lineCodeFix);
		JSONArray jsonArray = Constant.getData("bizLine");
		if (deptCode.equals("") || deptCode.equals("00")) {
			response.getWriter().write(jsonArray.toJSONString());
			return;
		} else {
			JSONArray jsonArray2 = new JSONArray();
			for (Object object : jsonArray) {
				JSONObject joObject = (JSONObject) object;
				if (curCodeFix.contains(joObject.getString("value"))) {
					jsonArray2.add(joObject);
				}
			}
			System.out.println(jsonArray2.toJSONString());
			response.getWriter().write(jsonArray2.toJSONString());
			return;
		}
	}

	/**
	 * 简要说明: 查询基本法<br>
	 * 
	 * <pre>
	 * 方法queryLawDefine的详细说明: <br>
	 * 创建时间:2015年7月31日 下午3:34:04
	 * </pre>
	 */
	@RequestMapping("/queryLawDefine")
	@VisitDesc(label = "查询基本法", actionType = 4)
	public void queryLawDefine(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		PageDto pageDto = new PageDto();
		Map<String, Object> paramMap = dto.getFormMap();
		pageDto.setStart(request.getParameter("start"));
		pageDto.setLimit(request.getParameter("limit"));
		pageDto.setWhereMap(paramMap);
		String curDeptCode = request.getSession().getAttribute("curDeptCode").toString();
		if (curDeptCode.equals("00")) {
			curDeptCode = "";
		}
		pageDto.getWhereMap().put("curDeptCode", curDeptCode);
		try {
			pageDto = lawDefineService.findLawDefineByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}

		// //=============初始化业务线车险系统数据到数据库=====================
		// Thread iniRateThread = new Thread(){
		// public void run() {
		// lawDefineService.initRateData();
		// };
		// };
		// iniRateThread.start();

		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * <pre>
	 * 新增/修改
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/saveLawDefine")
	@VisitDesc(label = "新增基本法", actionType = 1)
	public void saveLawDefine(HttpServletRequest request, HttpServletResponse response, FormDto dto) {
		Map<String, Object> paraMap = dto.getFormMap();
		paraMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawDefineService.saveOrUpdateLawDefine(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(paraMap), e);
		}
	}

	/**
	 * <pre>
	 * 查询VO
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/queryLawDefineInfo")
	@VisitDesc(label = "查询基本法", actionType = 4)
	public void queryLawDefineInfo(HttpServletRequest request, HttpServletResponse response, String versionCode) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = lawDefineService.queryLawDefineInfo(versionCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询基本法版本信息时出现异常，传入参数为：" + versionCode, e);
		}
		SendUtil.sendJSON(response, rows);
	}

	/**
	 * <pre>
	 * 是否存在已生效的基本法
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/existValidVersion")
	@VisitDesc(label = "是否存在已生效的基本法", actionType = 4, hidden = true)
	public void existValidVersion(HttpServletRequest request, HttpServletResponse response, String versionCode) throws GeneralException {
		boolean falg;
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("versionCode", versionCode);
		paraMap.put("versionStatus", "1");
		try {
			falg = lawDefineService.existValidVersion(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("是否存在已生效的基本法，传入参数为：" + versionCode, e);
		}
		SendUtil.sendJSON(response, falg);
	}

	/**
	 * <pre>
	 * 启用/停用
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/updateLawDefine")
	@VisitDesc(label = "修改基本法", actionType = 3, hidden = false)
	public void updateLawDefine(HttpServletRequest request, HttpServletResponse response, String versionCode, String versionStatus) throws GeneralException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("versionCode", versionCode);
		paraMap.put("versionStatus", versionStatus);
		paraMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawDefineService.updateLawDefine(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("启用/停用基本法版本信息时出现异常，传入参数为：" + versionCode + "," + versionStatus, e);
		}
		SendUtil.sendJSON(response, versionCode);
	}

	/**
	 * 删除基本法
	 * 
	 * @param request
	 * @param response
	 * @param versionCode
	 * @throws GeneralException
	 *             </pre>
	 */
	@RequestMapping("/deleteLawDefine")
	@VisitDesc(label = "删除基本法", actionType = 2, hidden = true)
	public void deleteLawDefine(HttpServletRequest request, HttpServletResponse response, String versionCode) throws GeneralException {
		try {
			lawDefineService.deleteLawDefine(versionCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + versionCode, e);
		}
		SendUtil.sendJSON(response, "success");
	}

	@RequestMapping("/queryLawDefineOmcombo")
	@VisitDesc(label = "", actionType = 3, hidden = false)
	public void queryLawDefineOmcombo(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = lawDefineService.queryLawDefineOmcombo(pageDto);
			JSONArray result = new JSONArray();
			if (pageDto.getRows() != null && pageDto.getRows().size() != 0) {
				result.add(buildDept("", "请选择"));
				for (int i = 0; i < pageDto.getRows().size(); i++) {
					result.add(buildDept(pageDto.getRows().get(i).get("versionCode").toString(), pageDto.getRows().get(i).get("versionCname").toString()));
				}
			}
			response.reset();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer;
			writer = response.getWriter();
			writer.write(result.toString());
			writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
	}

	@RequestMapping("/queryVersionCode")
	public void queryVersionCode(HttpServletRequest request, HttpServletResponse response, String versionCode) throws GeneralException {
		long count = 1;
		try {
			count = lawDefineService.queryVersionCode(versionCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询销售人员管理办法版本代码是否存在时出现异常，传入参数为：" + versionCode, e);
		}
		SendUtil.sendJSON(response, count <= 0);
	}

	/**
	 * 查询版本CODE和名称，用于指标因素关系指定
	 * 
	 * @param pageDto
	 * @return
	 */
	@RequestMapping("/queryDefineCode")
	public void queryDefineCode(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		Map<String, Object> defineMap = new HashMap<String, Object>();

		List<Map<String, Object>> resList = (List<Map<String, Object>>) lawDefineService.queryDefineCode(defineMap);
		JSONArray result = new JSONArray();
		try {
			if (resList.size() > 0) {
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildDept(resList.get(i).get("versionCode").toString(), resList.get(i).get("versionCname").toString()));
				}
			} else {
				result.add(buildDept("", "暂无版本数据！"));
			}
			response.reset();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer;
			writer = response.getWriter();
			writer.write(result.toString());
			writer.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@RequestMapping("/generateVersionCode")
	public void generateVersionCode(HttpServletRequest request, HttpServletResponse response, LawDefine lawDefine) throws GeneralException {
		Map<String, Object> param;
		try {
			param = lawDefineService.generateVersionCode(lawDefine);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("生成基本法代码时出错，传入参数为：" + lawDefine, e);
		}
		SendUtil.sendJSON(response, param);
	}

	private JSONObject buildDept(String id, String name) {
		JSONObject result = new JSONObject();
		result.put("value", id);
		result.put("text", name);
		return result;
	}

	/**
	 * <pre>
	 * 功能：取因素，不分页
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionId
	 * &#64;throws ServiceException
	 * </pre>
	 */
	@RequestMapping("/queryPageFactor")
	public void queryPageFactor(HttpServletRequest request, HttpServletResponse response, String versionId, String itemType) throws ServiceException {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", versionId);
		whereMap.put("itemType", itemType);
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(whereMap);
		try {
			pageDto = lawDefineService.queryPageFactor(pageDto);
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + JSON.toJSONString(whereMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * <pre>
	 * 功能：取导入因素，不分页
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionId
	 * &#64;throws ServiceException
	 * </pre>
	 */
	@RequestMapping("/queryPageImport")
	public void queryPageImport(HttpServletRequest request, HttpServletResponse response, String versionId, String itemType) throws ServiceException {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", versionId);
		whereMap.put("itemType", itemType);
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(whereMap);
		try {
			pageDto = lawDefineService.queryPageImport(pageDto);
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + JSON.toJSONString(whereMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * <pre>
	 * 功能：取考核因素，不分页
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionId
	 * &#64;throws ServiceException
	 * </pre>
	 */
	@RequestMapping("/queryPageExamine")
	public void queryPageExamine(HttpServletRequest request, HttpServletResponse response, String versionId, String itemType) throws ServiceException {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", versionId);
		whereMap.put("itemType", itemType);
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(whereMap);
		try {
			pageDto = lawDefineService.queryPageExamine(pageDto);
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + JSON.toJSONString(whereMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * <pre>
	 * 功能：取指标，不分页
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionId
	 * &#64;throws ServiceException
	 * </pre>
	 */
	@RequestMapping("/queryPageIndex")
	public void queryPageIndex(HttpServletRequest request, HttpServletResponse response, String versionId, String itemType) throws ServiceException {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", versionId);
		whereMap.put("itemType", itemType);
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(whereMap);
		try {
			pageDto = lawDefineService.queryPageIndex(pageDto);
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + JSON.toJSONString(whereMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * <pre>
	 * 功能：取职级，不分页
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionId
	 * &#64;throws ServiceException
	 * </pre>
	 */
	@RequestMapping("/queryPageRank")
	public void queryPageRank(HttpServletRequest request, HttpServletResponse response, String versionId, String itemType) throws ServiceException {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", versionId);
		whereMap.put("itemType", itemType);
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(whereMap);
		try {
			pageDto = lawDefineService.queryPageRank(pageDto);
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + JSON.toJSONString(whereMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * <pre>
	 * 功能：取考核公式，不分页
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionId
	 * &#64;throws ServiceException
	 * </pre>
	 */
	@RequestMapping("/queryPageReview")
	public void queryPageReview(HttpServletRequest request, HttpServletResponse response, String versionId, String itemType) throws ServiceException {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", versionId);
		whereMap.put("itemType", itemType);
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(whereMap);
		try {
			pageDto = lawDefineService.queryPageReview(pageDto);
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + JSON.toJSONString(whereMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * <pre>
	 * 修改系统因子
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/updateFactorSystem")
	public void updateFactorSystem(HttpServletRequest request, HttpServletResponse response, FormDto dto) {
		Map<String, Object> paraMap = dto.getFormMap();
		paraMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawDefineService.updateFactorSystem(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(paraMap), e);
		}
	}

	/**
	 * <pre>
	 * 修改导入因素
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/updateFactorImport")
	public void updateFactorImport(HttpServletRequest request, HttpServletResponse response, FormDto dto) {
		Map<String, Object> paraMap = dto.getFormMap();
		paraMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawDefineService.updateFactorImport(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(paraMap), e);
		}
	}

	/**
	 * <pre>
	 * 修改导入因素
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/updateFactorExamine")
	public void updateFactorExamine(HttpServletRequest request, HttpServletResponse response, FormDto dto) {
		Map<String, Object> paraMap = dto.getFormMap();
		paraMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawDefineService.updateFactorExamine(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(paraMap), e);
		}
	}

	/**
	 * <pre>
	 * 修改计算公式
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/updateLawIndex")
	public void updateLawIndex(HttpServletRequest request, HttpServletResponse response, FormDto dto) {
		Map<String, Object> paraMap = dto.getFormMap();
		paraMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawDefineService.updateLawIndex(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(paraMap), e);
		}
	}

	/**
	 * <pre>
	 * 修改考核公式
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/updateLawReview")
	public void updateLawReview(HttpServletRequest request, HttpServletResponse response, FormDto dto) {
		Map<String, Object> paraMap = dto.getFormMap();
		paraMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawDefineService.updateLawReview(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(paraMap), e);
		}
	}

	/**
	 * <pre>
	 * 修改销售职级
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/updateRankSales")
	public void updateRankSales(HttpServletRequest request, HttpServletResponse response, FormDto dto) {
		Map<String, Object> paraMap = dto.getFormMap();
		paraMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawDefineService.updateLawRank(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常，传入参数为：" + JSONObject.toJSONString(paraMap), e);
		}
	}

	/**
	 * <pre>
	 * 查询分公司,已经新增基本法的公司不出现在下拉框
	 * &#64;param request
	 * &#64;param response
	 * &#64;param versionCode
	 * &#64;throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/queryDeptCodeList")
	public void queryDeptCodeList(HttpServletResponse response) throws GeneralException {
		List<Map<String, Object>> resultList = null;
		try {
			resultList = lawDefineService.queryDeptCodeList();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("无参数传入", e);
		}
		SendUtil.sendJSON(response, resultList);
	}

	/**
	 * 手动执行计算
	 */
	@RequestMapping("/manualCalc")
	public void manualCalc(HttpServletResponse response, String versionId, String deptCode, String lineCode) {
		try {
			lawDefineService.manualCalculation(versionId, deptCode, lineCode);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常", e);
		}
		SendUtil.sendJSON(response, true);
	}

	/**
	 * 是否显示“手动执行计算”按钮
	 * 
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/isShowManualCalculation")
	public void isShowManualCalculation(HttpServletResponse response) throws IOException {
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(CurrentUser.getUser().getUserCode(), systemCode);
		JSONObject obj = new JSONObject();

		for (int index = 0; index < roleCodeList.size(); index++) {
			String roleEname = (String) roleCodeList.get(index).get("roleEname");
			if ("xszcAdmin".equals(roleEname) || "headDeptSalesmanManageNew".equals(roleEname)) {
				obj.put("status", true);
				SendUtil.sendJSON(response, obj);
				return;
			}
		}
		obj.put("status", false);
		SendUtil.sendJSON(response, obj);
		return;
	}

	/**
	 * <pre>
	 * 查询基本法中团队长是否按客户经理考核
	 * @param request
	 * @param response
	 * @param versionCode
	 * @throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/queryBasicLaw")
	public void queryBasicLaw(HttpServletRequest request, HttpServletResponse response, String deptCode) {
		Long basicLaw=null;
		try {
			basicLaw = lawDefineService.queryBasicLaw(deptCode);
			if(basicLaw==null){
				basicLaw = (long) 0;
			}
		} catch (Exception e) {
			log.error(e);
		}
		SendUtil.sendJSON(response, basicLaw);
	}
	/**
	 * <pre>
	 * 查询基本法是否配置地域标识
	 * @param request
	 * @param response
	 * @param versionCode
	 * @throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/queryBasicLawArea")
	public void queryBasicLawArea(HttpServletRequest request, HttpServletResponse response, String deptCode) {
		Long basicLawArea=null;
		try {
			basicLawArea = lawDefineService.queryBasicLawArea(deptCode);
			if(basicLawArea==null){
				basicLawArea = (long) 0;
			}
		} catch (Exception e) {
			log.error(e);
		}
		SendUtil.sendJSON(response, basicLawArea);
	}
	
	@RequestMapping("/validateTaskStatus")
	@VisitDesc(label="获取所有手动执行任务的状态",actionType=4)
	public void validateTaskStatus(HttpServletRequest request, HttpServletResponse response,FormDto dto) throws GeneralException {
		boolean result = false;
		Map<String,Object> paraMap = dto.getFormMap();
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, -1);
		paraMap.put("calcMonth", new SimpleDateFormat("yyyyMM").format(calendar.getTime()));
		try {
			result = lawDefineManualService.findTaskStatus(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("操作异常", e);
		}
		SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/queryRules")
	public void queryRules(HttpServletRequest request,HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		String itemType = request.getParameter("itemType");
		map.put("itemType", itemType);
		List<Map<String, Object>> resList = lawDefineService.queryRules(map);
		JSONArray result = new JSONArray();
		try {
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("itemCode").toString(), resList.get(i).get("itemCode").toString()+" "+resList.get(i).get("itemName").toString()));
			}
			SendUtil.sendJSON(response, result);
		} catch (Exception e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}
	
	@RequestMapping("/queryRulesE")
	public void queryRulesE(HttpServletRequest request,HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		String itemType = request.getParameter("itemType");
		map.put("itemType", itemType);
		List<Map<String, Object>> resList = lawDefineService.queryRules(map);
		JSONArray result = new JSONArray();
		try {
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildDept(resList.get(i).get("itemCode").toString(),resList.get(i).get("itemName").toString()));
			}
			SendUtil.sendJSON(response, result);
		} catch (Exception e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
	}
	
	@RequestMapping("/validateFormula")
	public void validateFormula(HttpServletRequest request,HttpServletResponse response) {
		String versionId = request.getParameter("versionId");
		String resultMsg = lawDefineService.validateFormula(versionId);
		SendUtil.sendJSON(response, convertResult(resultMsg));
	}
	
	private String convertResult(String result){
		String[] strArr = result.split(",");
		List<String> strList = new ArrayList<String>();
		for(String str : strArr){
			if(!strList.contains(str)){
				strList.add(str);
			}
		}
		return strList.toString();
	}
	
}
