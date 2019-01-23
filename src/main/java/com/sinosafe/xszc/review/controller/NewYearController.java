package com.sinosafe.xszc.review.controller;

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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.review.service.NewYearRewardService;
import com.sinosafe.xszc.review.vo.NewYearReward;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/newYearReward")
@VisitDesc(label="新年奖数据导入")
public class NewYearController {

	private static final Log log = LogFactory.getLog(NewYearController.class);

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@Autowired
	@Qualifier("NewYearRewardService")
	private NewYearRewardService newYearRewardService;


	/**
	 * 导入数据
	 * 
	 * @param PickAppInfo
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/impNewYearRewardValueInXls")
	@VisitDesc(label="导入系数数据",actionType=1)
	public void impNewYearRewardValueInXls(@RequestParam MultipartFile impFile, HttpServletRequest request, HttpServletResponse response) throws IOException {
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath + "ExportExcel/";
		String fileDiskPath = "";
		try {
			if (!impFile.isEmpty()) {
				String fileName = "new_year_reward.xls";
				fileDiskPath = savePath + fileName;
				impFile.transferTo(new File(fileDiskPath));
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("fileDiskPath", fileDiskPath);
		boolean impFlag = this.newYearRewardService.saveNewYearRewardInXls(whereMap);
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
	 * 查询导入数值
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryNewYearReward")
	public void queryNewYearReward(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
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
			pageDto = newYearRewardService.queryNewYearRewardToPage(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/queryAllEmployAndSalary")
	public void queryAllEmployAndSalary(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		Map<String, Object> map = null;
		try {
			map = newYearRewardService.queryAllEmployAndSalary(paramMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, map);
	}
	
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
	public void getLawRateValueXls( HttpServletRequest request, HttpServletResponse response) throws GeneralException, IOException {
		// 组织机构代码,用户编码
		JSONObject jsonObject = new JSONObject();
		String strDirPath = request.getSession().getServletContext().getRealPath("/");
		String savePath = strDirPath + "ExportExcel/";
		Map<String, Object> paramMap = new HashMap<String, Object>();
		boolean actionFlag = false;
			savePath += "newYearRewardModel.xls";
			paramMap.put("savePath", savePath);
			actionFlag = this.newYearRewardService.genRateSafeTypeModelXls(paramMap);
			if (actionFlag) {
				jsonObject.put("actionFlag", true);
				jsonObject.put("actionMsg", "导出成功!");
				jsonObject.put("fileUrl", "ExportExcel/newYearRewardModel.xls");
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
			List<NewYearReward> changeList = JSONArray.parseArray(changeRows, NewYearReward.class);
		    boolean actionFlag = this.newYearRewardService.updateChange(changeList);
		    jsonObject.put("actionMsg", "编辑成功！");
		    jsonObject.put("actionFlag", actionFlag);
		}catch(Exception e){
			jsonObject.put("actionFlag", false);
			jsonObject.put("actionMsg", "操作失败！");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}
	
}
