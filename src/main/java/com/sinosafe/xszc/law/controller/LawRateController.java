package com.sinosafe.xszc.law.controller;

import java.io.File;
import java.io.IOException;
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

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.law.service.LawRateService;
import com.sinosafe.xszc.law.vo.TLawRate;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/lawRate")
@VisitDesc(label="基本法系数管理")
public class LawRateController {

	private static final Log log = LogFactory.getLog(LawRateController.class);

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@Autowired
	@Qualifier("LawRateService")
	private LawRateService lawRateService;

	// =============================导入==导出===编辑新功能===开始============================================
	/**
	 * 生成导入模板，并返回下载地址
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws IOException
	 */
	@RequestMapping("/getLawRateValueXls")
	@VisitDesc(label="导入基本法系数",actionType=4)
	public void getLawRateValueXls(String rateType, HttpServletRequest request, HttpServletResponse response) throws GeneralException, IOException {
		// 组织机构代码,用户编码
		JSONObject jsonObject = new JSONObject();
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath + "ExportExcel/";
		String versionId = request.getParameter("versionId");
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("versionId", versionId);
		boolean actionFlag = false;
		// 险种
		if (rateType.equals("1")) {
			savePath += "rateSafeTypeModel.xls";
			paramMap.put("savePath", savePath);
			actionFlag = this.lawRateService.genRateSafeTypeModelXls(paramMap);
			if (actionFlag) {
				jsonObject.put("actionFlag", true);
				jsonObject.put("actionMsg", "导出成功!");
				jsonObject.put("fileUrl", "ExportExcel/rateSafeTypeModel.xls");
			}
			// 业务线
		} else if (rateType.equals("2")) {

			// 车型
		} else if (rateType.equals("3")) {

			// 渠道
		} else if (rateType.equals("4")) {
			savePath += "rateChnnelModel.xls";
			paramMap.put("savePath", savePath);
			actionFlag = this.lawRateService.genRateChannelModelXls(paramMap);
			if (actionFlag) {
				jsonObject.put("actionFlag", true);
				jsonObject.put("actionMsg", "导出成功!");
				jsonObject.put("fileUrl", "ExportExcel/rateChnnelModel.xls");
			}
		}
		response.getWriter().write(jsonObject.toString());
		response.getWriter().close();
		return;
	}

	/**
	 * 导入数据
	 * 
	 * @param PickAppInfo
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/impLawImpValueInXls")
	@VisitDesc(label="导入系数数据",actionType=1)
	public void impLawRateCommonInXls(@RequestParam MultipartFile impFile, HttpServletRequest request, HttpServletResponse response) throws IOException {
		String rateType = request.getParameter("rateType");
		String versionId = request.getParameter("versionId");
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath + "ExportExcel/";
		String fileDiskPath = "";
		try {
			if (!impFile.isEmpty()) {
				String fileName = "law_rate_common.xls";
				fileDiskPath = savePath + fileName;
				impFile.transferTo(new File(fileDiskPath));
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("fileDiskPath", fileDiskPath);
		whereMap.put("rateType", rateType);
		whereMap.put("versionId", versionId);
		boolean impFlag = this.lawRateService.batchSaveLawRateDataInXls(whereMap);
		response.setContentType("text/html; charset=UTF-8");
		if (impFlag) {
			String result = "<script type='text/javascript'>";
			result += "alert('导入成功');";
			result += "parent.history.go(0)";
			result += "</script>";
			response.getWriter().print(result);
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
	 * 功能:不分页查询标准保费调整系数
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/queryLawRate")
	@VisitDesc(label="取基本法车型系数",actionType=4)
	public void queryLawRate(HttpServletRequest request, HttpServletResponse response,FormDto dto) throws GeneralException {
		PageDto pageDto = null;
		Map<String, Object> paraMap = new HashMap<String, Object>();
		try {
			Map<String,Object> whereMap = dto.getFormMap();
			pageDto = lawRateService.queryRateList(whereMap);
			int rowLength = pageDto.getRows().size();
			if(rowLength==0){
				if(whereMap.get("rateType").equals("2")){
				   //设置业务线系数默认输入模板 
				   pageDto.setRows(this.lawRateService.getDefaultInputModel(whereMap));
				}
				if(whereMap.get("rateType").equals("3")){
				   //设置车型 
				   pageDto.setRows(this.lawRateService.getDefaultCarTypeInputModel(whereMap));
				}
			}
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + JSON.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 功能:不分页查询标准保费调整系数
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * </pre>
	 */
	@RequestMapping("/queryAreaRate")
	@VisitDesc(label="取基本法区域系数",actionType=4)
	public void queryAreaRate(HttpServletRequest request, HttpServletResponse response,String versionId) throws GeneralException {
		PageDto pageDto = null;
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("versionId", versionId);
		try {
			pageDto = lawRateService.queryAreaRateList(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + JSON.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	
	//得到业务线系数类型
	@RequestMapping("/queryRateType")
	@VisitDesc(label="查询系数类型",actionType=4)
	public void queryRateType(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		List<Map<String, Object>> list;
		try {
			list = lawRateService.queryRateType();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询调整系数是异常", e);
		}
		SendUtil.sendJSON(response, list);
	}
	
	/**
	 * 详细说明: 保存系数数值类型 <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月8日 下午3:56:57 </pre>
	 * @throws Exception 
	 */
	@RequestMapping("/saveRowsChange")
	@VisitDesc(label="保存系数数值类型",actionType=1)
	public void saveRowsChange(HttpServletRequest request,HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		try{
			String rateType = request.getParameter("rateType");
			String versionId = request.getParameter("versionId");
			String changeRows = request.getParameter("changeRows");
			List<TLawRate> changeList = JSONArray.parseArray(changeRows, TLawRate.class);
		    boolean actionFlag = this.lawRateService.updateChange(changeList,rateType,versionId);
		    jsonObject.put("actionMsg", "编辑成功！");
		    jsonObject.put("actionFlag", actionFlag);
		}catch(Exception e){
			jsonObject.put("actionFlag", false);
			jsonObject.put("actionMsg", "操作失败！");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}
	// =============================导入==导出===编辑新功能===结束============================================

	/**
	 * 功能：根据系数类型查询列名
	 * @param request
	 * @param response
	 * @param rateType
	 * @throws GeneralException
	 */
	@RequestMapping("/queryRateCol")
	public void queryRateCol(HttpServletRequest request, HttpServletResponse response, String rateType) throws GeneralException {
		List<Map<String, Object>> list;
		try {
			list = lawRateService.queryRateCol(rateType);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询调整系数异常", e);
		}
		SendUtil.sendJSON(response, list);
	}

	@RequestMapping("/updateLawRate")
	public void updateLawRate(HttpServletRequest request, HttpServletResponse response, String pkId, String rate) throws GeneralException {
		try {
			lawRateService.updateLawRate(pkId, rate);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("修改调整系数异常", e);
		}
	}
	
	@RequestMapping("/saveLawRuleConfig")
	@VisitDesc(label = "其他配置项信息保存", actionType = 2)
	public void saveLawRuleConfig(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> formMap = dto.getFormMap();
		formMap.put("createdUser", CurrentUser.getUser().getUserCode());
		formMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawRateService.saveLawRuleConfig(formMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("保存操作异常，传入参数为：" + JSONObject.toJSONString(formMap), e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	@RequestMapping("/saveLawRulePermission")
	@VisitDesc(label = "其他配置项信息保存", actionType = 2)
	public void saveLawRulePermission(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> formMap = dto.getFormMap();
		formMap.put("createdUser", CurrentUser.getUser().getUserCode());
		formMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawRateService.saveLawRulePermission(formMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("保存操作异常，传入参数为：" + JSONObject.toJSONString(formMap), e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	@RequestMapping("/queryButtonStatus")
	@VisitDesc(label = "其他配置项信息保存", actionType = 2)
	public void queryButtonStatus(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> formMap = dto.getFormMap();
		String versionId = request.getParameter("versionId");
		try {
			formMap = lawRateService.queryButtonStatus(versionId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("保存操作异常，传入参数为：" + JSONObject.toJSONString(formMap), e);
		}
		SendUtil.sendJSON(response, formMap);
	}
	
	@RequestMapping("/queryLawRateConfigByVersionId")
	@VisitDesc(label = "其他配置项信息查询", actionType = 2)
	public void queryLawRateConfigByVersionId(HttpServletRequest request, HttpServletResponse response, String versionId) throws GeneralException {
		Map<String, Object> resultMap = null;
		try {
			resultMap = lawRateService.findLawRateConfigByVersionId(versionId);
		} catch (Exception e) {

			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + versionId, e);
		}
		SendUtil.sendJSON(response, resultMap);
	}
	
	@RequestMapping("/saveLawAreaRate")
	@VisitDesc(label = "其他区域系数", actionType = 2)
	public void saveLawAreaRate(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> formMap = dto.getFormMap();
		formMap.put("createdUser", CurrentUser.getUser().getUserCode());
		formMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			lawRateService.saveAreaRateConfig(formMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("保存操作异常，传入参数为：" + JSONObject.toJSONString(formMap), e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	@RequestMapping("/queryFactorImp")
	@VisitDesc(label = "其他配置项信息查询", actionType = 2)
	public void queryFactorImp(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		boolean result = false;
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String versionId = request.getParameter("versionId");
		String itemType = request.getParameter("itemType");
		resultMap.put("versionId", versionId);
		resultMap.put("itemType", itemType);
		try {
			result = lawRateService.queryFactorImp(resultMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + versionId, e);
		}
		SendUtil.sendJSON(response, result);
	}

}
