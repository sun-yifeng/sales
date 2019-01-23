package com.sinosafe.xszc.renewal.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.core.context.PlatformContext;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.constant.Constant;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.renewal.service.RenewalLevelService;
import com.sinosafe.xszc.renewal.service.RenewalService;
import com.sinosafe.xszc.renewal.vo.Renewal;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.GetRequestMap;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;
import com.sinosafe.xszc.util.StringUtil;

@Controller
@RequestMapping("/renewal")
public class RenewalController {
	private static Logger logger = Logger.getLogger(RenewalController.class);

	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;

	/*
	 * 设置级别
	 */
	@Autowired
	@Qualifier("RenewalLevelService")
	private RenewalLevelService renewalLevelService;
	
	/*
	 * 续保
	 */
	@Autowired
	@Qualifier("RenewalService")
	private RenewalService renewalService;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;
	
	/**
	 * 分页查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryRenewal")
	public void queryRenewal(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);

		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> list = umService.findRolesInSystemByUserCode(this.getUserCode(), systemCode);

		if (list.size() > 0) {
			pageDto.setWhereMap(StringUtil.moveSpaceForMap(dto.getFormMap()));
			try {
				pageDto = renewalService.findRenewalByWhere(pageDto);
			} catch (Exception e) {
				logger.error(e);
				throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(dto.getFormMap()), e);
			}
		}
		SendUtil.sendJSON(response, pageDto);
	}


	@RequestMapping("/RenewalRedirect")
	public ModelAndView RenewalRedirect(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);

		paraMap.put("userCName", this.getUserName());

		String actionName = (String) paraMap.get("actionName");
		if ("renewalLevelAdd".equals(actionName)) {
			ModelMap modelMap = new ModelMap();
			modelMap.addAttribute("RenewalDetail", "{}");
			modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
			return new ModelAndView("redirect:/view/renewal/renewalLevelAdd.jsp", modelMap);
		} else if ("RenewalOnceAdd".equals(actionName)) {
			ModelMap modelMap = new ModelMap();
			modelMap.addAttribute("RenewalDetail", "{}");
			modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
			return new ModelAndView("redirect:/view/Renewal/RenewalOnceAdd.jsp", modelMap);
		} else {
			ModelMap modelMap = new ModelMap();
			modelMap.addAttribute("RenewalDetail", "{}");
			modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
			return new ModelAndView("redirect:/view/Renewal/RenewalPeriodAdd.jsp", modelMap);
		}
	}

	@RequestMapping("/renewalLevelSave")
	public void RenewalSubmit(HttpServletRequest request, HttpServletResponse response) throws GeneralException, IOException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		boolean flag = renewalLevelService.RenewalLevelValidate(paraMap.get("deptCode").toString());
		if (flag) {
			try {
				renewalLevelService.saveRenewalLevel(paraMap);
			} catch (Exception e) {
				logger.error(e);
				throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
			}
			SendUtil.sendJSON(response, "1");
		} else {
			SendUtil.sendJSON(response, "0");
		}
	}

	@RequestMapping("/queryRenewalLevel")
	public void queryRenewalLevel(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String deptCode = (String) paramMap.get("deptCode");
		if(deptCode == null || "".equals(deptCode)){
			String userCode = CurrentUser.getUser().getUserCode();
			//查询出登录用户的所属机构编码
			List<Map<String, Object>> roleCodeList = umService.findDeptListByUserCode(userCode);
			deptCode = (String) roleCodeList.get(0).get("deptCode");
			if(!"00".equals(deptCode)){//如果不属于总公司
				paramMap.put("deptCode", deptCode);
			}
		}
		
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");

		String action = request.getParameter("action");

		if (dto.getFormMap().get("validInd") != null && dto.getFormMap().get("validInd").toString().equalsIgnoreCase("2")) {
			dto.getFormMap().remove("validInd");
		}
		PageDto pd = new PageDto();
		pd.setStart(startStr);
		pd.setLimit(limitStr);

		pd.setWhereMap(StringUtil.moveSpaceForMap(dto.getFormMap()));
		try {
			pd = renewalLevelService.findRenewalLevelByWhere(pd, action);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(dto.getFormMap()), e);
		}
		SendUtil.sendJSON(response, pd);
	}

	@RequestMapping("/RenewalLevelValidate")
	public void RenewalLevelValidate(HttpServletRequest request, HttpServletResponse response, String deptCode) throws GeneralException, IOException {
		boolean flag = renewalLevelService.RenewalLevelValidate(deptCode);
		response.getWriter().print(Boolean.toString(flag));
	}

	/**
	 * 
	 * TODO 方法RenewalDetail的简要说明 <br>
	 * 
	 * <pre>
	 * 编写者：康立新
	 * @param request
	 * @param response
	 * @throws GeneralException
	 * @throws IOException
	 * @throws 异常类型 说明
	 */
	@RequestMapping("/RenewalLevelDelete")
	public void RenewalLevelDelete(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		String noticIds = (String) paraMap.get("index");
		String[] noticIdArray = noticIds.split(",");
		try {
			renewalLevelService.deleteRenewalLevelByIds(noticIdArray);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("公告删除出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, "success");
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @return
	 * @throws GeneralException
	 * @return String 说明
	 * @throws UnsupportedEncodingException
	 * @throws 异常类型 说明
	 */
	@RequestMapping("/RenewalLevelDetail")
	public ModelAndView RenewalLevelDetail(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		try {
			resultMap = renewalService.findRenewalDetailByWhere(paraMap);

			String publishDeptCode = (String) resultMap.get("publishDeptCode");
			String publishDeptName = departmentService.findDepartmentVo(publishDeptCode).getDeptCname();
			resultMap.put("deptCname", publishDeptName);

		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		ModelMap modelMap = new ModelMap();
		String resultJson = JSONObject.toJSONString(resultMap);
		modelMap.addAttribute("RenewalDetail", resultJson);
		modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
		String actionName = (String) paraMap.get("actionName");
		String sourcePage = (String) paraMap.get("soursePage");
		if ("RenewalOnceQuery".equals(sourcePage)) {
			if ("RenewalModify".equals(actionName)) {
				return new ModelAndView("redirect:/view/Renewal/RenewalOnceEdit.jsp", modelMap);
			} else {
				return new ModelAndView("redirect:/view/Renewal/RenewalOnceDetail.jsp", modelMap);
			}
		} else {
			if ("RenewalModify".equals(actionName)) {
				return new ModelAndView("redirect:/view/Renewal/RenewalPeriodEdit.jsp", modelMap);
			} else if ("RenewalDelete".equals(actionName)) {
				return new ModelAndView("redirect:/view/Renewal/RenewalPeriodQuery.jsp", null);
			} else {
				return new ModelAndView("redirect:/view/Renewal/RenewalPeriodDetail.jsp", modelMap);
			}

		}
	}

	@RequestMapping("queryAssignLevelByRole")
	public void queryAssignLevelByRole(HttpServletRequest request, HttpServletResponse response) {
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> list = umService.findRolesInSystemByUserCode(this.getUserCode(), systemCode);
		JSONArray result = new JSONArray();
		if (list.size() > 0) {
			String roles = list.get(0).get("roleEname").toString();
			String[][] renewalLevel = Constant.renewalLevel;
			if (roles.equals("subDeptManager")) {
				for (String level[] : renewalLevel) {
					result.add(Constant.setValue(level));
				}
				//result.add(Constant.setValue(new String[]{"","不能选择下发"}));
			} else if (roles.equals("thirdDeptBusiMana")) {
				for (String level[] : renewalLevel) {
					if (!level[0].equals("1"))
						result.add(Constant.setValue(level));
				}
			} else if (roles.equals("groupCaptain")) {
				for (String level[] : renewalLevel) {
					if (!(level[0].equals("1") || level[0].equals("2")))
						result.add(Constant.setValue(level));
				}
			} else if (roles.equals("groupManager")) {
				for (String level[] : renewalLevel) {
					if (!(level[0].equals("1") || level[0].equals("2") || level[0].equals("3")))
						result.add(Constant.setValue(level));
				}
			} else {
				for (String level[] : renewalLevel) {
					result.add(Constant.setValue(level));
				}
			}
			SendUtil.sendJSON(response, result);
		} else {
			SendUtil.sendJSON(response, "获取下发级别失败");
		}
	}

	@RequestMapping("updateRenewalById")
	public void updateRenewalById(HttpServletRequest request, HttpServletResponse response, Renewal renewal) {
		renewalService.updateRenewalById(renewal);
	}

	@RequestMapping("queryRenewalById")
	public void queryRenewalById(HttpServletRequest request, HttpServletResponse response, String renewalId) {
		Renewal renewal = renewalService.queryRenewalById(renewalId);
		response.setContentType("text/html;charset=UTF-8");
		SendUtil.sendJSON(response, renewal);
	}

	@RequestMapping("/RenewalDelete")
	public ModelAndView RenewalDelete(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//boolean result = false;
		paraMap = new GetRequestMap().getRequstMap(request);
		//String actionName = (String) paraMap.get("actionName");
		String sourcePage = (String) paraMap.get("soursePage");
		String noticIds = (String) paraMap.get("noticIds");
		String[] noticIdArray = noticIds.split(",");
		try {
			renewalService.deleteRenewalByIds(noticIdArray);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("公告删除出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		ModelMap modelMap = new ModelMap();
		String resultJson = JSONObject.toJSONString(resultMap);
		modelMap.addAttribute("RenewalDetail", resultJson);
		modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));

		if ("RenewalOnceQuery".equals(sourcePage)) {
			return new ModelAndView("redirect:/view/Renewal/RenewalOnceQuery.jsp", null);
		} else {
			return new ModelAndView("redirect:/view/Renewal/RenewalPeriodQuery.jsp", null);
		}
	}

	@RequestMapping("/RenewalDetail")
	public ModelAndView RenewalDetail(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		try {
			resultMap = renewalService.findRenewalDetailByWhere(paraMap);

			String publishDeptCode = (String) resultMap.get("publishDeptCode");
			String publishDeptName = departmentService.findDepartmentVo(publishDeptCode).getDeptCname();
			resultMap.put("deptCname", publishDeptName);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		ModelMap modelMap = new ModelMap();
		String resultJson = JSONObject.toJSONString(resultMap);
		modelMap.addAttribute("RenewalDetail", resultJson);
		modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
		String actionName = (String) paraMap.get("actionName");
		String sourcePage = (String) paraMap.get("soursePage");
		if ("RenewalOnceQuery".equals(sourcePage)) {
			if ("RenewalModify".equals(actionName)) {
				return new ModelAndView("redirect:/view/Renewal/RenewalOnceEdit.jsp", modelMap);
			} else {
				return new ModelAndView("redirect:/view/Renewal/RenewalOnceDetail.jsp", modelMap);
			}
		} else {
			if ("RenewalModify".equals(actionName)) {
				return new ModelAndView("redirect:/view/Renewal/RenewalPeriodEdit.jsp", modelMap);
			} else if ("RenewalDelete".equals(actionName)) {
				return new ModelAndView("redirect:/view/Renewal/RenewalPeriodQuery.jsp", null);
			} else {
				return new ModelAndView("redirect:/view/Renewal/RenewalPeriodDetail.jsp", modelMap);
			}
		}
	}

	@RequestMapping("/renewalSave")
	public void RenewalSave(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		Boolean result = false;
		try {
			result = renewalService.saveRenewal(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("公告保存出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/queryDataToExcel")
	public void queryDataToExcel(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> list = umService.findRolesInSystemByUserCode(this.getUserCode(), systemCode); //取用户的角色

		if (list.size() > 0) {
			try {
				//不分页查询所有数据
				pageDto = renewalService.queryDataToExcel(pageDto);

				//定义从数据库取出数据顺序数组
				String[] colum_name = {"RN", "policyNo", "deptNameTwo", "deptNameThree", "deptNameFour","salesmanNo","insuraName",
						"safeBeginDate","safeEndDate", "custType", "renewalPolicyNo","renewalSalesmanCode",
						"claimCount","recognizeeName", "policyHolderName", "renewalBusiDept","vehicleCode",
						"brnd","engineNumber", "vin", "fristRegetDate"};
				//模板路径
				String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
				String strFileName ="renewalModel.xls";
				
				if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
					strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
				} else {
					strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
				}
				response.setHeader("Content-disposition","attachment;filename=" + strFileName);
				response.setContentType("application/x-download; charset=utf-8");
				
				//生成所需的Excel文件
				ExportExcel.dataToExcel(pageDto.getRows(), strFilePath+strFileName,colum_name,response.getOutputStream());
			} catch (Exception e) {
				logger.error(e);
				throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
			}
		}
	}

	private String getUserCode() {
		return CurrentUser.getUser().getUserCode();
	}

	private String getUserName() {
		String result = CurrentUser.getUser().getUserCName();
		if (result == null) {
			return "user";
		}
		return result;
	}

	public Map<String, Object> getDeptByUserId(String userCode) {
		List<Map<String, Object>> list = umService.findDeptListByUserCode(userCode);
		if (list == null || list.size() != 1) {
			return null;
		}
		return list.get(0);
	}

}
