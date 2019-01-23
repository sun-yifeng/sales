package com.sinosafe.xszc.law.controller;

import java.io.File;
import java.io.IOException;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.sinosafe.xszc.common.service.CommonServerice;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.law.service.TLawFactorImpValueService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/lawImpValue")
@VisitDesc(label="个人经理/团队经理数据导入导出管理")
public class TLawFactorImpValueController {
	
	private static final Log log = LogFactory.getLog(TLawFactorImpValueController.class);
	
	@Autowired
	@Qualifier("TLawFactorImpValueService")
	private TLawFactorImpValueService tLawFactorImpValueService;
	
	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;
	
	@Autowired
  @Qualifier("CommonServerice")
  private CommonServerice commonServerice;
	
	/**
	 * 详细说明: 保存更新的数值数据 <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月8日 下午3:56:57 </pre>
	 * @throws Exception 
	 */
	@RequestMapping("/saveRowsChange")
	public void saveRowsChange(HttpServletRequest request,HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		try{
			String impType = request.getParameter("impType");
			String versionId = request.getParameter("versionId");
			String changeRows = request.getParameter("changeRows");
			JSONArray changeList = JSONArray.parseArray(changeRows);
			String itemType = "";
			if(impType.equals("1")){
				itemType = "0";
			}else if(impType.equals("2")){
				itemType = "1";
			}
		    boolean actionFlag = this.tLawFactorImpValueService.updateChange(changeList,itemType,versionId);
		    jsonObject.put("actionMsg", "编辑成功！");
		    jsonObject.put("actionFlag", actionFlag);
		}catch(Exception e){
			jsonObject.put("actionFlag", false);
			jsonObject.put("actionMsg", "操作失败！");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}
	
	/**
	 * 生成导入模板，并返回下载地址
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws IOException 
	 */
	@RequestMapping("/getLawImpValueXls")
	public void getLawImpValueXls(String impType,HttpServletRequest request, HttpServletResponse response) throws GeneralException, IOException {
		// 组织机构代码,用户编码
		JSONObject jsonObject = new JSONObject();
		String versionId = request.getParameter("versionId");
		String calcMonth = request.getParameter("calcMonth");
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath + "ExportExcel/";
		Map<String,Object> paramMap = new HashMap<String, Object>();
		paramMap.put("versionId", versionId);
		paramMap.put("calcMonth", calcMonth);
		boolean actionFlag = false;
		if (impType.equals("1")) {
			savePath += "salesmanData.xls";
			paramMap.put("savePath", savePath);
			actionFlag = this.tLawFactorImpValueService.genTLawFactorImpValueXls(paramMap);
			if (actionFlag) {
				jsonObject.put("actionFlag", true);
				jsonObject.put("actionMsg", "导出成功!");
				jsonObject.put("fileUrl","ExportExcel/salesmanData.xls");
			}
		} else if (impType.equals("2")){
			savePath += "groupData.xls";
			paramMap.put("savePath", savePath);
			actionFlag = this.tLawFactorImpValueService.genGroupImpXls(paramMap);
			if (actionFlag) {
				jsonObject.put("actionFlag", true);
				jsonObject.put("actionMsg", "导出成功!");
				jsonObject.put("fileUrl","ExportExcel/groupData.xls");
			}
		}
		response.getWriter().write(jsonObject.toString());
		response.getWriter().close();
		return;
	}
	
	/**
	 * 导入数据
	 * @param PickAppInfo
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("/impLawImpValueInXls")
	public void impLawImpValueInXls(@RequestParam MultipartFile impFile,HttpServletRequest request,HttpServletResponse response) throws IOException{
		String impType = request.getParameter("impType");
		String calcMonth = commonServerice.getCalcMonth();
		String versionId = request.getParameter("versionId");
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath+"ExportExcel/";
		String fileDiskPath = "";
		try {
			if(!impFile.isEmpty()){
				String fileName = "salesmanDataImp.xls";
				fileDiskPath = savePath+fileName;
				impFile.transferTo(new File(fileDiskPath));
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		Map<String,Object> whereMap = new HashMap<String, Object>();
		whereMap.put("fileDiskPath", fileDiskPath);
		whereMap.put("impType", impType);
		whereMap.put("calcMonth", calcMonth);
		whereMap.put("versionId", versionId);
		boolean impFlag = this.tLawFactorImpValueService.batchSaveDataInXls(whereMap);
		response.setContentType("text/html; charset=UTF-8");
		if(impFlag){
			String result = "<script type='text/javascript'>";
			       result += "alert('导入成功');";
			       result += "parent.history.go(0)";
			       result += "</script>";
			response.getWriter().print(result);;
		}else{
			String result = "<script type='text/javascript'>";
		       result += "alert('导入失败,请再次尝试或者调整excel中的数据试试！');";
		       result += "parent.closeWait();";
		       //result += "parent.history.go(0)";
		       result += "</script>";
		    response.getWriter().print(result);
		}
		return;
	}
	
	/**
	 * 导入团队数据
	 * @param PickAppInfo
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("/impGroupValueInXls")
	public void impGroupValueInXls(@RequestParam MultipartFile impFile,HttpServletRequest request,HttpServletResponse response) throws IOException{
		//导入类型
		String impType = request.getParameter("impType");
		//导入月份
		String calcMonth = commonServerice.getCalcMonth();
		//导入的管理办法
		String versionId = request.getParameter("versionId");
		
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath+"ExportExcel/";
		String fileDiskPath = "";
		try {
			if(!impFile.isEmpty()){
				String fileName = "groupDataImp.xls";
				fileDiskPath = savePath+fileName;
				impFile.transferTo(new File(fileDiskPath));
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		Map<String,Object> whereMap = new HashMap<String,Object>();
		whereMap.put("fileDiskPath", fileDiskPath);
		whereMap.put("impType", impType);
		whereMap.put("calcMonth", calcMonth);
		whereMap.put("versionId", versionId);
		boolean impFlag = this.tLawFactorImpValueService.batchSaveGroupDataInXls(whereMap);
		response.setContentType("text/html; charset=UTF-8");
		if(impFlag){
			String result = "<script type='text/javascript'>";
			       result += "alert('导入成功');";
			       result += "parent.history.go(0);";
			       result += "</script>";
			response.getWriter().print(result);;
		}else{
			String result = "<script type='text/javascript'>";
		       result += "alert('导入失败,请再次尝试或者调整excel中的数据试试！');";
		       result += "parent.closeWait();";
		       //result += "parent.history.go(0);";
		       result += "</script>";
		    response.getWriter().print(result);
		}
		return;
	}
	
	/**
	 * 电销保单上传
	 * @param impFile
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/lawElectricPolicyUpload")
	public void lawElectricPolicyUpload(@RequestParam MultipartFile impFile,
		HttpServletRequest request,HttpServletResponse response){
		response.setContentType("text/html; charset=UTF-8");
		
		try{
			
			//导入类型
			String impType = request.getParameter("impType");
			//导入的管理办法
			String versionId = request.getParameter("versionId");
			
			String strDirPath = request.getSession().getServletContext().getRealPath("/");
			log.info("strDirPath:"+strDirPath);
			String savePath = strDirPath+"ExportExcel/";
			log.info("savePath:"+savePath);
			String fileDiskPath = "";
			if(!impFile.isEmpty()){
				fileDiskPath = savePath + "lawElectricPolicyUpload"+ Calendar.getInstance().getTimeInMillis() +".xls";
				impFile.transferTo(new File(fileDiskPath));
			}
			log.info("fileDiskPath:"+fileDiskPath);
			Map<String,Object> whereMap = new HashMap<String,Object>();
			whereMap.put("fileDiskPath", fileDiskPath);
			whereMap.put("impType", impType);
			whereMap.put("versionId", versionId);
			boolean impFlag = this.tLawFactorImpValueService.batchSaveLawElectricPolicy(whereMap);
			
			if(impFlag){
				String result = "<script type='text/javascript'>";
				result += "alert('导入成功');";
				result += "parent.history.go(0);";
				result += "</script>";
				response.getWriter().print(result);;
			}else{
				String result = "<script type='text/javascript'>";
			    result += "alert('导入失败');";
			    result += "parent.closeWait();";
			    result += "</script>";
			    response.getWriter().print(result);
			}
			
		}catch(Exception e){
			String result = "<script type='text/javascript'>";
		    result += "alert('导入失败');";
		    result += "parent.closeWait();";
		    result += "</script>";
		    try {
				response.getWriter().print(result);
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
		
	}
	
	/**
	 * 电销保单查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryLawElectricPolicy")
	public void queryLawElectricPolicy(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		dto.getFormMap().put("dataMonth",dto.getFormMap().get("year")+""+dto.getFormMap().get("month"));
		pageDto.setWhereMap(dto.getFormMap());
		pageDto = tLawFactorImpValueService.queryLawElectricPolicy(pageDto);
		pageDto.setTotal(pageDto.getTotal());
		pageDto.setLimit(String.valueOf(pageDto.getLimit()));
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 查询导入数值
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryLawImpValue")
	public void queryLawImpValue(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		dto.getFormMap().put("calcMonth",dto.getFormMap().get("year")+""+dto.getFormMap().get("month"));
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = tLawFactorImpValueService.findTLawFactorImpValueToPage(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 查询客户经理导入类型
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/getLawDefineList")
	public void getLawDefineList(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		String itemType = request.getParameter("itemType");
		String versionId = request.getParameter("versionId");
		List<Map<String,Object>> lawDefineList = this.tLawFactorImpValueService.getLawDefineImpList(itemType,versionId);
		SendUtil.sendJSONList(response,lawDefineList);
		return;
	}
	
	/**
	 * 管理办法
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/getBFLawDefineList")
	public void getBFLawDefineList(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		//组织机构代码,用户编码
		IUserDetails curUserInfo = CurrentUser.getUser();
		String userCode = "";
		String deptCode = "";
		if (curUserInfo != null) {
			userCode = curUserInfo.getUserCode();
			deptCode = departmentService.getDefaultDeptCodeByUser(userCode);
			if(deptCode.length()>2){
				deptCode = deptCode.substring(0, 2);
			}
		}
		if(deptCode.equals("00")){
			deptCode = null;
		}
		List<Map<String,Object>> lawDefineList = this.tLawFactorImpValueService.getBFLawDefineList(deptCode);
		SendUtil.sendJSONList(response,lawDefineList);
		return;
	 }
}
