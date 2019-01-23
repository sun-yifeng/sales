package com.sinosafe.xszc.planNew.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.DateUtil;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.planNew.service.PlanMainService;
import com.sinosafe.xszc.planNew.service.SalePlanDetailService;
import com.sinosafe.xszc.planNew.vo.PlanDetailNew;
import com.sinosafe.xszc.planNew.vo.PlanMainNew;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

/**
 * 类名:com.sinosafe.xszc.planNew.controller.SalePlanController <pre>
 * 描述:销售计划
 * 基本思路:用于处所有关于销售计划的请求
 * 特别说明:目前有专属保费计划和销售保费计划两大块
 * 编写者:卢水发
 * 创建时间:2015年6月2日 上午11:39:12
 * 修改说明:无修改说明
 * </pre>
 */
@Controller
@RequestMapping("/salePlan")
public class SalePlanController {

	private static final Log log = LogFactory.getLog(SalePlanController.class);

	@Autowired
	@Qualifier("SalePlanDetailService")
	private SalePlanDetailService salePlanDetailService;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;
	
	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;
	
	@Autowired
	@Qualifier("PlanMainNewService")
	private PlanMainService planMainService;
	
	/**
	 * 编辑[PickAppInfo]信息
	 * @param PickAppInfo
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("/checkSalePlan")
	public void checkSalePlan(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String approveFlag = request.getParameter("approveFlag");
		String planMainId = request.getParameter("planMainId");
		IUserDetails curUserInfo = CurrentUser.getUser();
		String userCode = curUserInfo.getUserCode();
		PlanMainNew planMain = new PlanMainNew();

		planMain.setApproveCode(userCode);
		planMain.setApproveFlag(approveFlag);
		planMain.setPlanMainId(planMainId);
		boolean actionFlag = planMainService.saveOrUpdate(planMain);
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("actionFlag", actionFlag);
		response.getWriter().write(jsonObject.toJSONString());
		return;
	}
	
	/**
	 * 导入数据
	 * @param PickAppInfo
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("/impPlanDetailInXls")
	public void impPlanDetailInXls(@RequestParam MultipartFile impFile,HttpServletRequest request,HttpServletResponse response) throws IOException{
		String planYear = request.getParameter("planYear");
		String planType = request.getParameter("planType");
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath+"ExportExcel/";
		String fileDiskPath = "";
		try {
			if(!impFile.isEmpty()){
				String fileName = "impPlanDetailInXls.xls";
				fileDiskPath = savePath+fileName;
				impFile.transferTo(new File(fileDiskPath));
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		boolean impFlag = this.salePlanDetailService.batchSaveDataInXls(fileDiskPath,planType,planYear);
		response.setContentType("text/html; charset=UTF-8");
		if(impFlag){
			String result = "<script type='text/javascript'>";
			       result += "alert('导入成功');";
			       result += "window.history.go(-1);";
			       result += "</script>";
			response.getWriter().print(result);;
		}else{
			String result = "<script type='text/javascript'>";
		       result += "alert('导入失败,请再次尝试或者调整excel中的数据试试！');";
		       result += "window.history.go(-1);";
		       result += "</script>";
		    response.getWriter().print(result);
		}
		return;
	}
	
	
	/**
	 * 详细说明:生成导入模板 <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月5日 上午10:24:39 </pre>
	 * @throws IOException 
	 */
	@RequestMapping("/getSalePlanDetailXls")
	public void getSalePlanDetailXls(HttpServletRequest request,HttpServletResponse response,String planType) throws IOException{
		//组织机构代码,用户编码
		IUserDetails curUserInfo = CurrentUser.getUser();
		String userCode = "";
		String deptCode = "";
		if (curUserInfo != null) {
			userCode = curUserInfo.getUserCode();
			deptCode = departmentService.getDefaultDeptCodeByUser(userCode);
		}
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath+"ExportExcel/";
		boolean actionFlag = false;
		JSONObject jsonObject = new JSONObject();;
		if(planType.equals("1")){
			savePath+="salePlanDeptDetailModel.xls";
			actionFlag = this.salePlanDetailService.genDeptPlanDetailXls(savePath,deptCode);
		    if(actionFlag){
		    	jsonObject.put("actionFlag",true);
		    	jsonObject.put("actionMsg","导出成功!");
		    	jsonObject.put("fileUrl", "ExportExcel/salePlanDeptDetailModel.xls");
		    }
		}else{
			jsonObject.put("actionFlag",false);
			jsonObject.put("actionMsg","销售专属保费模块需求确认中......！");
			jsonObject.put("fileUrl", "");
		}
		response.getWriter().write(jsonObject.toString());
	}

	@RequestMapping("/querySalePlanDetail")
	public void querySalePlanDetail(HttpServletRequest request,HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = salePlanDetailService.findPlanDetailToPage(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/queryAllSalePlanDetail")
	public void queryAllSalePlanDetail(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		// 如果是总公司
		String dept = (String) pageDto.getWhereMap().get("deptCode");
		if (StringUtils.isBlank(dept)) {
			List<Map<String, Object>> list = umService.findDeptListByUserCode(CurrentUser.getUser().getUserCode());
			if (list != null && list.size() == 1) {
				pageDto.getWhereMap().put("deptCode", list.get(0).get("deptCode").toString());
			}
		}
		try {
			pageDto = salePlanDetailService.queryPlanWidthDetailToPage(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	
	
	/**
	 * 方法querySalePlanDetailByVo的详细说明:得到计划信息<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月8日 上午10:41:13 </pre>
	 */
	@RequestMapping("/querySalePlanByVo")
	public void querySalePlanByVo(HttpServletResponse response, String planMainId) throws GeneralException {
		PlanMainNew planMain = salePlanDetailService.querySalePlanByVo(planMainId);
		response.setContentType("text/html;charset=UTF-8");
		SendUtil.sendJSON(response, planMain);
		return;
	}

	/**
	 * 方法querySalePlanDetailByVo的详细说明:查出计划明细 <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月8日 上午10:41:13 </pre>
	 * @param 参数名 说明
	 * @return void 说明
	 * @throws 异常类型 说明
	 */
	@RequestMapping("/querySalePlanDetailByVo")
	public void querySalePlanDetailByVo(HttpServletResponse response, String planMainId) throws GeneralException {
		PlanMainNew planMain = new PlanMainNew();
		planMain.setPlanMainId(planMainId);
		planMain = salePlanDetailService.queryPlanDetailToVo(planMain);
		response.setContentType("text/html;charset=UTF-8");
		SendUtil.sendJSON(response, planMain);
		return;
	}
	
	/**
	 * 详细说明: 通过销售计划ID来查出明细列表<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月8日 上午10:41:13 </pre>
	 * @param planMainId 计划id
	 * @throws IOException 
	 */
	@RequestMapping("/querySalePlanDetailListByPlanId")
	public void querySalePlanDetailListByPlanId(HttpServletResponse response, String planMainId) throws GeneralException, IOException {
		Set<PlanDetailNew> detailSet = salePlanDetailService.querySalePlanDetailListByPlanId(planMainId);
		response.setContentType("text/html;charset=UTF-8");
		JSONObject jo = new JSONObject();
		jo.put("rows", detailSet);
		jo.put("total", detailSet.size());
		response.getWriter().print(jo.toJSONString());
		return;
	}

	/**
	 * 详细说明: 保存一条计划 <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月8日 下午3:56:57 </pre>
	 * @throws Exception 
	 */
	@RequestMapping("/saveSalePlan")
	public void saveSalePlan(HttpServletRequest request,HttpServletResponse response,PlanMainNew planMain) throws Exception {
		JSONObject jsonObject = new JSONObject();
		try{
			Timestamp curTime =  Timestamp.valueOf(DateUtil.getSystemDateStr("yyyy-MM-dd hh:mm:ss"));
			String writeDate = request.getParameter("writeDate");
			IUserDetails curUserInfo = CurrentUser.getUser();
			System.out.println(planMain.getPlanMainId());
			planMain.setUpdatedDate(curTime);
			planMain.setUpdatedUser(curUserInfo.getUsername());
			planMain.setPlanWriteDate(Timestamp.valueOf(writeDate+" 00:00:00"));
			String planDetailGrid = request.getParameter("planDetailGrid");
			List<PlanDetailNew> detailList = JSONArray.parseArray(planDetailGrid, PlanDetailNew.class);
		    this.salePlanDetailService.savePlanWithDetail(planMain,detailList);
		    jsonObject.put("actionMsg", "编辑计划成功！");
		    jsonObject.put("actionFlag", true);
		}catch(Exception e){
			jsonObject.put("actionFlag", false);
			jsonObject.put("actionMsg", "操作失败！");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}

	@RequestMapping("/deleteSalePlanDetail")
	public void deleteSalePlanDetail(HttpServletRequest request, HttpServletResponse response, String planMainId) throws IOException {
		salePlanDetailService.delPlanDetail(planMainId);
	}

	@RequestMapping("/updateStuts")
	public void updateStuts(HttpServletRequest request, HttpServletResponse response, FormDto dto) {
		String resoult = salePlanDetailService.updateStatus(dto.getFormMap());
		SendUtil.sendJSON(response, resoult);
	}
	
	@RequestMapping("/checkExistPlan")
	public void checkExistPlan(HttpServletRequest request, HttpServletResponse response, String deptCode, String year)  throws GeneralException {	
		long count = 1;
		try {
			count = salePlanDetailService.querySalePlanOneByDept(deptCode, Integer.parseInt(year));
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("核对销售计划是否存在，传入参数为：" + deptCode + "," + year, e);
		}
		SendUtil.sendJSON(response, count <= 0);
	}
}
