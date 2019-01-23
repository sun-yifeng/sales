package com.sinosafe.xszc.channel.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.channel.service.MediumSalesmanService;
import com.sinosafe.xszc.channel.vo.MediumSalesman;
import com.sinosafe.xszc.group.vo.SalesmanVirtual;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.review.vo.NewYearReward;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.ReflectMatch;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/mediumSalesman")
@VisitDesc(label="中介机构销售人员数据导入")
public class MediumSalesmanController {

	private static final Log log = LogFactory.getLog(MediumSalesmanController.class);

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@Autowired
	@Qualifier("MediumSalesmanService")
	private MediumSalesmanService mediumSalesmanService;


	/**
	 * 导入数据
	 * 
	 * @param PickAppInfo
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/impSalesmanValueInXls")
	@VisitDesc(label="导入系数数据",actionType=1)
	public void impSalesmanValueInXls(@RequestParam MultipartFile impFile, HttpServletRequest request, HttpServletResponse response) throws IOException {
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath + "ExportExcel/";
		String fileDiskPath = "";
		String channelCode=request.getParameter("channelCode");
		try {
			if (!impFile.isEmpty()) {
				String fileName = "mediumSalesman.xls";
				fileDiskPath = savePath + fileName;
				impFile.transferTo(new File(fileDiskPath));
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("fileDiskPath", fileDiskPath);
		whereMap.put("channelCode", channelCode);
		Map<String,Object> resultMap = this.mediumSalesmanService.saveMediumSalesmanInXls(whereMap);
		response.setContentType("text/html; charset=UTF-8");
		String flag = resultMap.get("result").toString();
		List<String> resultList = (List<String>) resultMap.get("existsIdCard");
		String existId = "";
		String newExistId = "";
		if(resultList.size()>0){
			for (String str : resultList) {
				existId += str+",";
			}
			newExistId = existId.substring(0,existId.length() - 1);
		}
		if (flag.equals("success")) {
			if(resultList.size()>0){
				String result = "<script type='text/javascript'>";
				result += "alert('导入成功,但有"+resultList.size()+"个身份证号已存在，未能导入！\\n号码是："+newExistId+"');";
				result += "parent.history.go(0)";
				result += "</script>";
				response.getWriter().print(result);
			}else{
				String result = "<script type='text/javascript'>";
				result += "alert('导入成功');";
				result += "parent.history.go(0)";
				result += "</script>";
				response.getWriter().print(result);
			}
		} else {
			String result = "<script type='text/javascript'>";
			result += "alert('导入失败,请再次尝试或者调整excel中的数据试试！');";
			result += "parent.closeWait();";
			result += "</script>";
			response.getWriter().print(result);
		}
		return;
	}

	/**
	 * 查询导入数值
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediumSalesman")
	public void queryMediumSalesman(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String curDeptCode = request.getSession().getAttribute("curDeptCode").toString();
		dto.getFormMap().put("curDeptCode", curDeptCode);
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumSalesmanService.queryMediumSalesmanToPage(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 生成导入模板，并返回下载地址
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws IOException
	 */
	@RequestMapping("/downloadSalesmanModel")
	@VisitDesc(label="导入基本法系数",actionType=4)
	public void downloadSalesmanModel( HttpServletRequest request, HttpServletResponse response) throws GeneralException, IOException {
		// 组织机构代码,用户编码
		JSONObject jsonObject = new JSONObject();
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath + "ExportExcel/";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		boolean actionFlag = false;
			savePath += "channelMediumSalesman.xls";
			paramMap.put("savePath", savePath);
			actionFlag = this.mediumSalesmanService.downloadSalesmanModel(paramMap);
			if (actionFlag) {
				jsonObject.put("actionFlag", true);
				jsonObject.put("actionMsg", "导出成功!");
				jsonObject.put("fileUrl", "ExportExcel/channelMediumSalesman.xls");
			}
		response.getWriter().write(jsonObject.toString());
		response.getWriter().close();
		return;
	}
	
	@RequestMapping("/saveRowsChange")
	public void saveRowsChange(HttpServletRequest request,HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		try{
			String changeRows = request.getParameter("changeRows");
			List<MediumSalesman> changeList = JSONArray.parseArray(changeRows, MediumSalesman.class);
		    boolean actionFlag = this.mediumSalesmanService.updateChange(changeList);
		    jsonObject.put("actionMsg", "编辑成功！");
		    jsonObject.put("actionFlag", actionFlag);
		}catch(Exception e){
			jsonObject.put("actionFlag", false);
			jsonObject.put("actionMsg", "操作失败！");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}
	
	@RequestMapping("/saveSalesmanAdd")
	public void saveSalesmanAdd(HttpServletRequest request,HttpServletResponse response,FormDto dto) throws Exception {
		JSONObject jsonObject = new JSONObject();
		try {
			Map<String, Object> paramMap = dto.getFormMap();
			String idCard = paramMap.get("addIdCard").toString();
			boolean idFlag = this.mediumSalesmanService.querySalesmanId(idCard);
			if(idFlag){
				String sex = paramMap.get("addSex").toString();
				if(sex.equals("男")){
					paramMap.put("addSex", 1);
				}else if(sex.equals("女")){
					paramMap.put("addSex", 2);
				}else{
					paramMap.put("addSex", 9);
				}
				String currentUser = CurrentUser.getUser().getUserCode();
				String curTime = DateUtil.dateToStr(new Date());
				paramMap.put("pkId", UUIDGenerator.getUUID());
				paramMap.put("validInd", 1);
				paramMap.put("createdUser", currentUser);
				paramMap.put("createdDate", curTime);
				paramMap.put("updatedUser", currentUser);
				paramMap.put("updatedDate", curTime);
				this.mediumSalesmanService.saveSalesmanAdd(paramMap);
			}else{
				jsonObject.put("idFlag", "idError");
			}
		} catch (Exception e) {
			jsonObject.put("idFlag", "error");
		}
		response.getWriter().write(jsonObject.toJSONString());
	}
	
	@RequestMapping("/saveRowsApprove")
	public void saveRowsApprove(HttpServletRequest request,HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		try{
			String selectedRows = request.getParameter("selectedRows");
			List<MediumSalesman> selectedList = JSONArray.parseArray(selectedRows, MediumSalesman.class);
			List<String> listPkId = new ArrayList<String>();
			for (MediumSalesman mediumSalesman : selectedList) {
				listPkId.add(mediumSalesman.getPkId());
			}
			int approveFileCount = this.mediumSalesmanService.saveRowsApprove(listPkId);
			if(approveFileCount==0){
				jsonObject.put("actionMsg", "ok");
			}else{
				jsonObject.put("actionCount", approveFileCount);
			}
		}catch(Exception e){
			jsonObject.put("actionMsg", "error");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}
}
