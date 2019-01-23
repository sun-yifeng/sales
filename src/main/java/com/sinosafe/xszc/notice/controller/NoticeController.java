package com.sinosafe.xszc.notice.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.hf.framework.core.context.PlatformContext;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.department.vo.Department;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.upload.service.UploadService;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.GetRequestMap;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;
import com.sinosafe.xszc.util.StringUtil;

/**
 * 公告管理
 * @author maguang
 *
 */

/**
 * 
 * 类名: com.sinosafe.xszc.notice.controller.NoticeController
 * 
 * <pre>
 * 描述:
 * 基本思路:
 * 特别说明:
 * 编写者:mg
 * 创建时间:2014年7月15日 下午2:15:29
 * 修改说明: 类的修改说明
 * </pre>
 */
@Controller
@RequestMapping("/notice")
public class NoticeController {
	private static Logger logger = Logger.getLogger(NoticeController.class);

	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;

	@Autowired
	@Qualifier("NoticeService")
	private NoticeService noticeService;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;
	
	@Autowired
	@Qualifier("UploadService")
	private UploadService uploadService;

	@RequestMapping("/queryNotice")
	public void queryNotice(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");

		String action = request.getParameter("action");

		if (dto.getFormMap().get("validInd") != null && dto.getFormMap().get("validInd").toString().equalsIgnoreCase("2")) {
			dto.getFormMap().remove("validInd");
		}
		if (dto.getFormMap().get("authType") != null && dto.getFormMap().get("authType").toString().equalsIgnoreCase("0")) {
			dto.getFormMap().remove("authType");
		}
		PageDto pd = new PageDto();
		pd.setStart(startStr);
		pd.setLimit(limitStr);
		//这里是查询的部门
		if(this.getDeptByUserId(this.getUserCode()).get("deptCode").equals(dto.getFormMap().get("parentDept")) || 
			this.getDeptByUserId(this.getUserCode()).get("deptCode").equals(dto.getFormMap().get("deptName"))){
			if(dto.getFormMap().get("parentDept") != "" && !"".equals(dto.getFormMap().get("parentDept"))){
				dto.getFormMap().put("deptCode", dto.getFormMap().get("parentDept"));
			}else{
				dto.getFormMap().put("deptCode", dto.getFormMap().get("deptName"));
			}
		}else{
			dto.getFormMap().put("deptCode", this.getDeptByUserId(this.getUserCode()).get("deptCode"));
		}
		// 加入登陆用户的usercode 跟所在部门 的控制.
		//dto.getFormMap().put("publisher", this.getUserCode());
		dto.getFormMap().put("dept_code", this.getDeptByUserId(this.getUserCode()).get("deptCode"));
		//如果是管理员，可以查看所有部门的数据
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(CurrentUser.getUser().getUserCode(), systemCode);
		for(int index=0;index<roleCodeList.size();index++){
			String roleEname = (String)roleCodeList.get(index).get("roleEname");
			if("xszcAdmin".equals(roleEname)){
				dto.getFormMap().remove("deptCode");
				break;
			}
		}

		pd.setWhereMap(StringUtil.moveSpaceForMap(dto.getFormMap()));
		
		//业务线
//		List<String> subBusinessLines = noticeService.filterSubBusinessLines();
//		pd.getWhereMap().put("nrl",subBusinessLines);
		
		try {
			pd = noticeService.findNoticeByWhere(pd, action);
			//加部门名称
			addDeptName(pd);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(dto.getFormMap()), e);
		}
		SendUtil.sendJSON(response, pd);
	}

	private void addDeptName(PageDto pd) {
		List<Map<String, Object>> rows = pd.getRows();
		if (rows == null || rows.size() == 0)
			return;
		for (Map<String, Object> rowData : rows) {
			addPulichDeptName(rowData);
		}
	}

	private void addPulichDeptName(Map<String, Object> rowData) {
		//String publishDeptCode = (String) resultMap.get("publishDeptCode");
		String deptCode = (String) rowData.get("publishDeptCode");
		//String deptCName ="";
		if (deptCode != null) {
			String publishDeptCode = deptCode;
			Department deptVo = departmentService.findDepartmentVo(publishDeptCode);
			String publishDeptName = "";
			if (deptVo != null) {
				publishDeptName = deptVo.getDeptSimpleName();
			}
			rowData.put("deptCname", publishDeptName);
		}
	}

	/**
	 * 
	 * 公告详情查看 TODO 方法noticeDetail的简要说明 <br>
	 * 
	 * <pre>
	 * 方法noticeDetail的详细说明 <br>
	 * 编写者：mg
	 * 创建时间:2014年7月15日 下午2:15:29
	 * @param request
	 * @param response
	 * @param dto
	 * @return
	 * @throws GeneralException
	 * @return String 说明
	 * @throws UnsupportedEncodingException
	 * @throws 异常类型 说明
	 */
	@RequestMapping("/noticeDelete")
	public ModelAndView noticeDelete(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		boolean result = false;
		paraMap = new GetRequestMap().getRequstMap(request);
		String actionName = (String) paraMap.get("actionName");
		String sourcePage = (String) paraMap.get("soursePage");
		String noticIds = (String) paraMap.get("noticIds");
		String[] noticIdArray = noticIds.split(",");
		try {
			result = noticeService.deleteNoticeByIds(noticIdArray);

//			String publishDeptCode = (String)resultMap.get("publishDeptCode");
//			String publishDeptName = departmentService.findDepartmentVo(publishDeptCode).getDeptCname();
//			resultMap.put("deptCname", publishDeptName);

		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("公告删除出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		ModelMap modelMap = new ModelMap();
		String resultJson = JSONObject.toJSONString(resultMap);
		modelMap.addAttribute("noticeDetail", resultJson);
		modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
//		String actionName = (String)paraMap.get("actionName");
//		String sourcePage = (String)paraMap.get("soursePage");

		if ("noticeOnceQuery".equals(sourcePage)) {
			return new ModelAndView("redirect:/view/notice/noticeOnceQuery.jsp", null);
		} else {
			return new ModelAndView("redirect:/view/notice/noticePeriodQuery.jsp", null);
		}
	}
	
	@RequestMapping("/noticeValid")
	public ModelAndView noticeValid(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		boolean result = false;
		paraMap = new GetRequestMap().getRequstMap(request);
		String actionName = (String) paraMap.get("actionName");
		String sourcePage = (String) paraMap.get("soursePage");
		String noticIds = (String) paraMap.get("noticIds");
		String[] noticIdArray = noticIds.split(",");
		try {
			result = noticeService.validNoticeByIds(noticIdArray);
			
//			String publishDeptCode = (String)resultMap.get("publishDeptCode");
//			String publishDeptName = departmentService.findDepartmentVo(publishDeptCode).getDeptCname();
//			resultMap.put("deptCname", publishDeptName);
			
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("公告删除出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		ModelMap modelMap = new ModelMap();
		String resultJson = JSONObject.toJSONString(resultMap);
		modelMap.addAttribute("noticeDetail", resultJson);
		modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
//		String actionName = (String)paraMap.get("actionName");
//		String sourcePage = (String)paraMap.get("soursePage");
		
		if ("noticeOnceQuery".equals(sourcePage)) {
			return new ModelAndView("redirect:/view/notice/noticeOnceQuery.jsp", null);
		} else {
			return new ModelAndView("redirect:/view/notice/noticePeriodQuery.jsp", null);
		}
	}

	/**
	 * 
	 * 公告详情查看 TODO 方法noticeDetail的简要说明 <br>
	 * 
	 * <pre>
	 * 方法noticeDetail的详细说明 <br>
	 * 编写者：mg
	 * 创建时间:2014年7月15日 下午2:15:29
	 * @param request
	 * @param response
	 * @param dto
	 * @return
	 * @throws GeneralException
	 * @return String 说明
	 * @throws UnsupportedEncodingException
	 * @throws 异常类型 说明
	 */
	@RequestMapping("/noticeDetail")
	public String noticeDetail(Model model,HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		try {
			resultMap = noticeService.findNoticeDetailByWhere(paraMap);
			addPulichDeptName(resultMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		
		String resultJson = JSONObject.toJSONString(resultMap);
		model.addAttribute("noticeDetail", resultJson);
		model.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
		String actionName = (String) paraMap.get("actionName");
		String sourcePage = (String) paraMap.get("soursePage");
		if ("noticeOnceQuery".equals(sourcePage)) {
			if ("noticeModify".equals(actionName)) {
				return "notice/noticeOnceEdit";
			} else {
				return "notice/noticeOnceDetail";
			}
		} else {
			if ("noticeModify".equals(actionName)) {
				return "notice/noticePeriodEdit";
			} else if ("noticeDelete".equals(actionName)) {
				return "notice/noticePeriodQuery";
			} else {
				return "notice/noticePeriodDetail";
			}
		}
	}

	@RequestMapping("/noticeRedirect")
	public String noticeRedirect(Model model,HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
		
		Map<String, Object> paraMap = new GetRequestMap().getRequstMap(request);

		paraMap.put("userCName", this.getUserName());

		String actionName = (String) paraMap.get("actionName");

		Map<String, String> resultMap = new HashMap<String, String>();
		resultMap.put("batchNumber", UUIDGenerator.getUUID());
		String resultJson = JSONObject.toJSONString(resultMap);
		
		//常规渠道，渠道重客，金融保险（可复选）
		model.addAttribute("businessLinePermission",noticeService.filterSubBusinessLines());

		if ("noticePeriodAdd".equals(actionName)) {
			model.addAttribute("noticeDetail", resultJson);
			model.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
			return "notice/noticePeriodAdd";
		} else if ("noticeOnceAdd".equals(actionName)) {
			model.addAttribute("noticeDetail", resultJson);
			model.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
			return "notice/noticeOnceAdd";
		} else {
			model.addAttribute("noticeDetail", "{}");
			model.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
			return "notice/noticePeriodAdd";
		}
	}

	/**
	 * 
	 * 查询待反馈的notice 列表<br>
	 * 编写者：maguang 创建时间：2014-7-24 </pre> 方法findNoticeFeedback的详细说明
	 * 
	 * @param 参数类型 filterPara 过滤条件参数
	 * @return String 说明
	 * @throws 异常类型
	 * @param request
	 * @param response
	 * @throws GeneralException
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping("/findNoticeFeedback")
	public void findNoticeFeedback(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pd = new PageDto();
		pd.setStart(startStr);
		pd.setLimit(limitStr);
		//dto.getFormMap().put("deptCode", dto.getFormMap().get("deptName"));
		//查询出登录用户的所属机构编码
		if(dto.getFormMap().get("deptName")!=""&&!"".equals(dto.getFormMap().get("deptName"))){
			dto.getFormMap().put("deptCode",dto.getFormMap().get("deptName"));
		}else if(dto.getFormMap().get("parentDept")!=""&&!"".equals(dto.getFormMap().get("parentDept"))){
			dto.getFormMap().put("deptCode",dto.getFormMap().get("parentDept"));
		}else{
			List<Map<String, Object>> roleCodeList = umService.findDeptListByUserCode(this.getUserCode());
			dto.getFormMap().put("deptCode",(String) roleCodeList.get(0).get("deptCode"));
		}
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(CurrentUser.getUser().getUserCode(), systemCode);
		List<String> roleEname = new ArrayList<String>();
		for (Map<String, Object> map : roleCodeList) {
			roleEname.add( map.get("roleEname").toString());
		}
		pd.setWhereMap(StringUtil.moveSpaceForMap(dto.getFormMap()));
		pd.getWhereMap().put("roleEname",roleEname);
		try {
			pd = noticeService.findNoticeFeedbackByWhere(pd);
			addDeptName(pd);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, pd);
	}

	/**
	 * 
	 * 查询待处理的公告 列表<br>
	 * 编写者：maguang 创建时间：2014-7-24 </pre> 方法findNoticeDeal的详细说明
	 * 
	 * @param 参数类型 filterPara 过滤条件参数
	 * @return String 说明
	 * @throws 异常类型
	 * @param request
	 * @param response
	 * @throws GeneralException
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping("/findNoticeDeal")
	public void findNoticeDeal(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pd = new PageDto();
		pd.setStart(startStr);
		pd.setLimit(limitStr);
		String deptCode = "";
		//dto.getFormMap().put("deptCode", dto.getFormMap().get("deptName"));
		if(dto.getFormMap().get("deptName")!=""&&!"".equals(dto.getFormMap().get("deptName"))){
			deptCode = (String) dto.getFormMap().get("deptName");
		}else if(dto.getFormMap().get("parentDept")!=""&&!"".equals(dto.getFormMap().get("parentDept"))){
			deptCode = (String) dto.getFormMap().get("parentDept");
		}
		List<Map<String, Object>> roleCodeList = umService.findDeptListByUserCode(this.getUserCode());
		String currentDeptCode = (String) roleCodeList.get(0).get("deptCode");
		if(currentDeptCode.equals(deptCode) || "".equals(deptCode)){
			dto.getFormMap().put("publishDeptCode", currentDeptCode);
		}else{
			dto.getFormMap().put("deptCode", deptCode);
		}
		pd.setWhereMap(StringUtil.moveSpaceForMap(dto.getFormMap()));

		//业务线
//		List<String> subBusinessLines = noticeService.filterSubBusinessLines();
//		pd.getWhereMap().put("nrl",subBusinessLines);
		
		try {
			//pd = noticeService.findNoticeForDealByWhere(pd);
			pd = noticeService.findNoticeDealByWhere(pd);
			addDeptName(pd);
			//dealwithDealDate(pd);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, pd);
	}

	/**
	 * 
	 * 将查询到的日期换成字符串格式 <br>
	 * 编写者：maguang 创建时间：2014-8-7 </pre> 方法dealwithDealDate的详细说明
	 * 
	 * @param 参数类型 filterPara 过滤条件参数
	 * @return String 说明
	 * @throws 异常类型
	 * @param pd
	 */
	private void dealwithDealDate(PageDto pd) {
		List<Map<String, Object>> rowList = pd.getRows();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		for (Map<String, Object> rowData : rowList) {
			Date dealDate = (Date) rowData.get("NKCREATE_DATE");
			String newDateS = df.format(dealDate);
			rowData.put("NKCREATE_DATE", newDateS);
		}
	}

	/**
	 * 获取指定公告未完成反馈的.
	 * 
	 * TODO 方法noticeSummary的简要说明 <br>
	 * 
	 * <pre>
	 * 方法noticeSummary的详细说明 <br>
	 * 编写者：mg
	 * 创建时间:2014年7月15日 下午2:15:29
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @throws GeneralException
	 * @throws UnsupportedEncodingException
	 * @return void 说明
	 * @throws 异常类型 说明
	 */
	@RequestMapping("/noticeFeedback")
	public String noticeFeedback(Model model,HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new GetRequestMap().getRequstMap(request);
		Map<String, Object> noticeMap = null;
		try {
			//String noticId = (String) paraMap.get("noticId");
			noticeMap = noticeService.findNoticeFeeBackDetailByWhere(paraMap);
			addPulichDeptName(noticeMap);
			//resultMap = noticeService.findNoticeFeedbackForFeedback(noticId);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}

		model.addAttribute("noticeDetail", JSONObject.toJSONString(noticeMap));
		//modelMap.addAttribute("paraMap", JSONObject.toJSONString(resultMap));
		return "notice/noticeFeedbackDetail";
	}

	//	private void addDeptCname(Map<String, Object> noticeMap)
	//	{
	//		String publishDeptCode = (String) noticeMap.get("publishDeptCode");
	//
	//		Department dd = departmentService.findDepartmentVo(publishDeptCode);
	//		String publishDeptName = "";
	//		if (dd!=null)
	//		{
	//			publishDeptName = dd.getDeptCname();
	//			
	//		}
	//		noticeMap.put("deptCname", publishDeptName);
	//	}

	/**
	 * 获取指定公告反馈信息用于处理
	 * 
	 * TODO 方法noticeSummary的简要说明 <br>
	 * 
	 * <pre>
	 * 方法noticeSummary的详细说明 <br>
	 * 编写者：mg
	 * 创建时间:2014年7月15日 下午2:15:29
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @throws GeneralException
	 * @throws UnsupportedEncodingException
	 * @return void 说明
	 * @throws 异常类型 说明
	 */
	@RequestMapping("/noticeDeal")
	public String noticeDeal(Model model,HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		Map<String, Object> resultMap = null;
		Map<String, Object> noticeMap = null;
		try {
			String feedbackId = (String) paraMap.get("feedbackId");
			String noticId = (String) paraMap.get("noticId");
			/*
			 * 找到要处理的那个反馈的notice
			 */
			noticeMap = noticeService.findNoticeDetailByWhere(paraMap);

			addPulichDeptName(noticeMap);
			noticeMap.put("feedbackId", feedbackId);
			/*
			 * 找到要处理的那条反馈
			 */
			resultMap = noticeService.findNoticeFeedbackForDeal(feedbackId);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}

		model.addAttribute("noticeDetail", JSONObject.toJSONString(noticeMap));
		model.addAttribute("paraMap", JSONObject.toJSONString(resultMap));

		return "notice/noticeDealDetail";
	}

	@RequestMapping("/noticeSave")
	public void noticeSave(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		
		Boolean result = false;
		Map<String, Object> paraMap = new GetRequestMap().getRequstMap(request);
		
		try {
			paraMap.put("deptCode", this.getDeptByUserId(this.getUserCode()).get("deptCode"));
			//获取登录人的角色权限
			String userCode = CurrentUser.getUser().getUserCode();
			String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
			List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);
			String roleList = "";
			for (Map<String, Object> map : roleCodeList) {
				roleList +=map.get("roleEname").toString()+",";
			}
			int indx = roleList.lastIndexOf(",");
			if(indx!=-1){
				roleList = roleList.substring(0,indx)+roleList.substring(indx+1,roleList.length());
			}
			paraMap.put("createdUserRole", roleList);
			// 部门 就没了???
			result = noticeService.saveNotice(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("公告保存出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		
		SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/noticeUpdate")
	public void noticeUpdate(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new GetRequestMap().getRequstMap(request);
		
		Boolean result = false;
		try {
			result = noticeService.updateNotice(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("公告保存出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, result);
	}

	@RequestMapping("/noticeSubmit")
	public void noticeSubmit(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		try {
			noticeService.saveSubmitNotice(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, true);
	}

	@RequestMapping("/queryAllReceiveDept")
	public void queryAllReceiveDept(HttpServletRequest request, HttpServletResponse response,String deptCode) throws GeneralException, UnsupportedEncodingException {

		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		if("".equals(deptCode) || deptCode == null || "null".equals(deptCode)){
			deptCode = (String) this.getDeptByUserId(CurrentUser.getUser().getUserCode()).get("deptCode");
		}
		paraMap.put("parentCode", deptCode);

		List<Map<String, Object>> deptList = noticeService.queryAllReceiveDept(paraMap);

		SendUtil.sendJSON(response, deptList);
	}
	
	@RequestMapping("/queryAllReceiveRole")
	public void queryAllReceiveRole(HttpServletRequest request, HttpServletResponse response,String relationType,String createdUserRole) throws GeneralException, UnsupportedEncodingException {
		
		Map<String, Object> paraMap = new HashMap<String, Object>();
		List<String> list = new ArrayList<String>();
		paraMap = new GetRequestMap().getRequstMap(request);
		
		if("".equals(createdUserRole) || createdUserRole == null || "null".equals(createdUserRole)){
			if(com.hf.framework.util.StringUtil.isNotEmpty(relationType)){
				paraMap.put("relationType", relationType);
				String userCode = CurrentUser.getUser().getUserCode();
				String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
				List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);
				for (Map<String, Object> map : roleCodeList) {
					list.add(map.get("roleEname").toString());
				}
				paraMap.put("sendUserRole", list);
				List<Map<String, Object>> deptList = noticeService.queryAllReceiveRole(paraMap);
				SendUtil.sendJSON(response, deptList);
		}
		}else{
			paraMap.put("relationType", relationType);
			String[] userRole = createdUserRole.split(",");
			for (int i = 0; i < userRole.length; i++) {
				list.add(userRole[i]);
			}
			paraMap.put("sendUserRole", list);
			List<Map<String, Object>> deptList = noticeService.queryAllReceiveRole(paraMap);
			SendUtil.sendJSON(response, deptList);
		}
	}

	@RequestMapping("/feedbackSave")
	public void feedbackSave(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new GetRequestMap().getRequstMap(request);

		Boolean result = false;
		try {
			result = noticeService.saveNoticeFeedback(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("公告保存出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, result);
	}

	@RequestMapping("/dealSave")
	public void dealSave(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new GetRequestMap().getRequstMap(request);
		Boolean result = false;
		try {
			result = noticeService.saveNoticeDeal(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("公告保存出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/dealArgue")
	public void dealArgue(HttpServletRequest request, HttpServletResponse response) throws GeneralException, UnsupportedEncodingException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		Boolean result = false;
		try {
			result = noticeService.argueNoticeDeal(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("公告驳回出现异常，数据参数为：" + JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, result);
	}

//	@RequestMapping("/noticeSummaryUpdate")
//	public void noticeSummaryUpdate(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
//		Map<String, Object> paraMap = new HashMap<String, Object>();
//		paraMap = new GetRequestMap().getRequstMap(request);
//		try {
//			noticeService.updateSummarynotice(paraMap);
//		} catch (Exception e) {
//			logger.error(e);
//			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
//		}
//		SendUtil.sendJSON(response, true);
//	}

	/**
	 * 取用户CODE
	 */
	private String getUserCode() {
		return CurrentUser.getUser().getUserCode();
	}

	/**
	 * 
	 * 取登陆用户的用户名 <br>
	 * 
	 * @return
	 */
	private String getUserName() {
		String result = CurrentUser.getUser().getUserCName();
		if (result == null) {
			return "user";
		}
		return result;
	}

	/**
	 * 
	 * 取部门 <br>
	 * </pre> 方法getDeptByUserId的详细说明
	 * 
	 * @param 参数类型 filterPara 过滤条件参数
	 * @return String 说明
	 * @throws 异常类型
	 * @param userCode
	 * @return
	 */
	public Map<String, Object> getDeptByUserId(String userCode) {
		List<Map<String, Object>> list = umService.findDeptListByUserCode(userCode);
		if (list == null || list.size() != 1) {
			Map<String, Object> deptMap = new HashMap<String, Object>();
			deptMap.put("deptCode", "1");
			return deptMap;
		}
		return list.get(0);
	}

	@RequestMapping("/findNoticeFeedbackByNoticId")
	public void findNoticeFeedbackByNoticId(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
	    Map<String, Object> paraMap = new HashMap<String, Object>();
	    paraMap = new GetRequestMap().getRequstMap(request);
		String startStr = request.getParameter("start");
	    String limitStr = request.getParameter("limit");
	    String statusNum = request.getParameter("statusNum");
	    if(com.hf.framework.util.StringUtil.isBlank(statusNum)){
	    	paraMap.put("statusNum", "");
	    }else{
	    	paraMap.put("statusNum", statusNum);
	    }
	    PageDto pd = new PageDto();
	    pd.setStart(startStr);
	    pd.setLimit(limitStr);
	    pd.setWhereMap(StringUtil.moveSpaceForMap(paraMap));
	    try {
	    	pd = noticeService.findNoticeFeedbackByNoticId(pd);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
	    SendUtil.sendJSON(response, pd);
	}
	
	/**
	 * 查询公告附件
	 * @param request
	 * @param response
	 */
	@RequestMapping("/queryTimingUploadMajor")
	public void queryTimingUploadMajor(HttpServletRequest request,HttpServletResponse response){
		
	    String mainId = request.getParameter("mainId");
	    String module = request.getParameter("module");
	    
	    Map<String, Object> paraMap = new HashMap<String, Object>();
	    paraMap.put("mainId", mainId);
	    paraMap.put("module", module);
	    List<Map<String, Object>> result = noticeService.queryTimingUploadMajor(paraMap);
	    
		SendUtil.sendJSON(response, result);
	}
	
	/**
	 * 查询反馈附件
	 * @param request
	 * @param response
	 */
	@RequestMapping("/queryTimingUploadFeedback")
	public void queryTimingUploadFeedback(HttpServletRequest request,HttpServletResponse response){
		
	    String mainId = request.getParameter("mainId");
	    String module = request.getParameter("module");
	    String feedbackId = request.getParameter("feedbackId");
	    
	    Map<String, Object> paraMap = new HashMap<String, Object>();
	    paraMap.put("mainId", mainId);
	    paraMap.put("module", module);
	    paraMap.put("feedbackId", feedbackId);
	    List<Map<String, Object>> result = noticeService.queryTimingUploadFeedback(paraMap);
	    
		SendUtil.sendJSON(response, result);
	}
	
	/**
	 * 查询当前登陆用户的机构信息
	 * @param request
	 * @param response
	 */
	@RequestMapping("/queryCurrentUserDepartment")
	public void queryCurrentUserDepartment(HttpServletRequest request,HttpServletResponse response){
		
		JSONObject result = new JSONObject();
		Map<String,String> parameter = new HashMap<String,String>();
		parameter.put("deptCode", (String)this.getDeptByUserId(this.getUserCode()).get("deptCode"));
		
		Map<String,Object> resultMap = departmentService.queryDeptLevelInfo(parameter).get(0);
		result.put("deptCode",resultMap.get("DEPTCODE").toString());
		result.put("deptName",resultMap.get("DEPTSIMPLENAME").toString());
		SendUtil.sendJSON(response, result);
	}
	
	/**
	 * 验证是否超过有效反馈期
	 * @param feedbackId
	 * @param response
	 */
	@RequestMapping("/feedbackIsEffective")
	public void feedbackIsEffective(String feedbackId,HttpServletResponse response){
		boolean isEffective = noticeService.feedbackIsEffective(feedbackId);
		JSONObject result = new JSONObject();
		if(isEffective){
			result.put("status","YES");
			result.put("message","反馈期有效");
		}else{
			result.put("status","NO");
			result.put("message","反馈期失效");
		}
		SendUtil.sendJSON(response, result);
	}
	
	/**
	 * 获取业务线信息
	 * @param request
	 * @param response
	 */
	@RequestMapping("/getBusinessLineInfo")
	private void getBusinessLineInfo(HttpServletRequest request, HttpServletResponse response){
		List<Map<String, String>> businessLineInfo = null;
		businessLineInfo = noticeService.getBusinessLineInfo(noticeService.filterSubBusinessLines());
		SendUtil.sendJSON(response, businessLineInfo);
	}
	
	@RequestMapping("/queryUploadWithDpt")
	public void queryUploadWithDpt(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		Map<String, Object> paramMap = new GetRequestMap().getRequstMap(request);
		List<Object> resultList = new ArrayList<Object>();
		if (paramMap.get("deptCode") == null) {
			Map<String, Object> deptMap = umService.findDefaultDeptCodeByUserCode(CurrentUser.getUser().getUserCode());
			String deptCode = "";
			if (deptMap != null) {
				deptCode = (String) deptMap.get("deptCode");
			}
			paramMap.put("deptCode", deptCode.length() <= 0 ? "000000" : deptCode);
		}
		try {
			resultList = uploadService.findUploadInfo(paramMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		SendUtil.sendJSON(response, resultList);
	}
	
	/**
	 * 获取发送层级
	 * @param request
	 * @param response
	 */
	@RequestMapping("/getRelationType")
	private void getRelationType(HttpServletRequest request, HttpServletResponse response){
		String userCode =  CurrentUser.getUser().getUserCode();
		Map<String,Object> map = umService.findDefaultDeptCodeByUserCode(userCode);
	    Object deptCode = map.get("deptCode");
	    try {
			response.getWriter().print(deptCode);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
