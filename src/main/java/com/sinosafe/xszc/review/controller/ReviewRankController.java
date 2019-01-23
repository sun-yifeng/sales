package com.sinosafe.xszc.review.controller;

import java.io.IOException;
import java.net.URLEncoder;
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

import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.hf.framework.core.context.PlatformContext;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.StringUtil;
import com.sinosafe.xszc.group.controller.GroupMainController;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.review.service.ReviewRankService;
import com.sinosafe.xszc.review.vo.ReviewRank;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/reviewRank")
public class ReviewRankController {

	private static final Log log = LogFactory.getLog(GroupMainController.class);

	@Autowired
	@Qualifier("ReviewRankService")
	private ReviewRankService reviewRankService;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;
	
	/**
	 * 详细说明:批量职级确认 <br>
	 * 编写者:卢水发
	 * @throws Exception
	 */
	@RequestMapping("/confirmRank")
	@VisitDesc(label="批量职级确认",actionType=3)
	public void confirmRank(HttpServletRequest request,HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		boolean actionFlag = true;
		try{
			String rankIds = request.getParameter("rankIds");
				actionFlag = this.reviewRankService.batchConfirmRank(rankIds);
				if(actionFlag == false){
					jsonObject.put("actionFlag", false);
					jsonObject.put("actionMsg", "确认失败！");
				}else{
					jsonObject.put("actionMsg", "职级确认成功！");
					jsonObject.put("actionFlag", actionFlag);
				}
		}catch(Exception e){
			jsonObject.put("actionFlag", false);
			jsonObject.put("actionMsg", "确认失败！");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}
	
	

	/**
	 * 查询所有考核职级信息
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryReviewRank")
	@VisitDesc(label="查询用户职级",actionType=4)
	public void queryReviewRank(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		String curDeptCode = request.getSession().getAttribute("curDeptCode").toString();
		if(curDeptCode.equals("00")){
			curDeptCode = "";
		}
		pageDto.getWhereMap().put("curDeptCode", curDeptCode);
		try {
			pageDto = reviewRankService.findReviewRankByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 查询职级历史记录
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryReviewRankHistory")
	@VisitDesc(label="查询历史记录",actionType=4)
	public void queryReviewRankHistory(HttpServletRequest request,HttpServletResponse response,FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reviewRankService.queryReviewRankHistory(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	

	/**
	 * 考核职级导出
	 * 
	 * @param @param request
	 * @param response
	 * @param dto
	 * @throws 无
	 */
	@RequestMapping("/queryDataToExcel")
	@VisitDesc(label="考核职级导出",actionType=3)
	public void queryDataToExcel(HttpServletRequest request, HttpServletResponse response, FormDto dto, int identify)
			throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");

		// 查询所有符合条件数据不分页，用来导出Excel
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());

		try {
			// 不分页查询所有数据
			pageDto = reviewRankService.queryDataToExcel(pageDto);

			// 根据传来的参数判断是"职级数据导出"还是"历史职级导出"
			if (identify == 0 || "0".equals(identify)) {
				// 定义从数据库取出数据顺序数组
				String[] colum_name = { "calcMonth", "deptCodeTwo", "deptNameTwo", "deptCodeThree", "deptNameThree", "deptCodeFour",
						"deptNameFour", "groupName", "salesmanCode", "salesmanName", "confirmStatus", "rankName", "rankScore", "premRate",
						"reviewResults", "recommendRank" };
				// 模板路径
				String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
				String strFileName = "reviewRankModel.xls";
				//
				if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
					strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
				} else {
					strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
				}
				response.setHeader("Content-disposition", "attachment;filename=" + strFileName);
				response.setContentType("application/x-download; charset=utf-8");

				// 生成所需的Excel文件
				ExportExcel.dataToExcel(pageDto.getRows(), strFilePath + strFileName, colum_name, response.getOutputStream());
			} else {
				// 定义从数据库取出数据顺序数组
				String[] colum_name = { "calcMonth", "deptCodeTwo", "deptNameTwo", "deptCodeThree", "deptNameThree", 
						"deptNameFour", "groupName", "salesman", "name","rankName", "rankScore", "premRate",
						"reviewResult", "recommendRankName", "cusReviewResult", "cusRecommendRankName","confirmStatus","confirmRankName",
						"cusConfirmRankName","confirmDate","confirmName","signNo"};
				// 模板路径
				String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
				// String strFilePath = "/home/xssurport/app/ExportExcel/";
				String strFileName = "historyReviewRankModel.xls";

				if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
					strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
				} else {
					strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
				}
				response.setHeader("Content-disposition", "attachment;filename=" + strFileName);
				response.setContentType("application/x-download; charset=utf-8");

				// 生成所需的Excel文件
				ExportExcel.dataToExcel(pageDto.getRows(), strFilePath + strFileName, colum_name, response.getOutputStream());
			}
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}

	/**
	 * 考核职级明细表表状态更新,已经废除
	 * @deprecated
	 * @param request
	 * @param response
	 * @param rankId
	 * @throws GeneralException
	 */
	@RequestMapping("/updateReviewRank")
	public void updateReviewRank(HttpServletRequest request, HttpServletResponse response, String rankId, String confirmRank,
			String auditFlag) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		log.debug("职级确认开始.....");
		// 获取用户角色权限
		String userCode = CurrentUser.getUser().getUserCode();
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);
		// 获取参数的值
		ReviewRank reviewRank = new ReviewRank();
		reviewRank.setUpdatedUser(userCode);
		reviewRank.setRankId(rankId);
		reviewRank.setConfirmRank(confirmRank);

		try {
			// 获取集合中第一个角色
			String roleName = (String) roleCodeList.get(0).get("roleEname");
			// subDeptSalesman -人员管理岗 subDeptAdmin -渠道管理岗 haedDeptSalesman
			// -总司管理岗
			if (roleName.equals("subDeptSalesman") || roleName == "subDeptSalesman") {
				reviewRank.setConfirmStatus("2");
			} else if (roleName.equals("subDeptAdmin") || roleName == "subDeptAdmin") {
				// 职级小于或等于 6 ，表示职级高于或等于 高级 ， 则需要提交到总司审批
				if (auditFlag == "1" || "1".equals(auditFlag)) {
					reviewRank.setConfirmStatus("3");
				} else {
					reviewRank.setConfirmStatus("9");
					// 确认完成，改变人员表的人员职级
					reviewRankService.updateSalesRank(reviewRank);
				}
			} else if (roleName.equals("haedDeptSalesman") || roleName == "haedDeptSalesman") {
				reviewRank.setConfirmStatus("9");
				// 确认完成，改变人员表的人员职级
				reviewRankService.updateSalesRank(reviewRank);
			}

			// 确认完成，改变人员表的人员职级
			reviewRankService.updateSalesRank(reviewRank);
			// 职级确认
			reviewRankService.updateReviewRank(reviewRank);

		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("确认职级操作异常，传入参数为：" + JSONObject.toJSONString(reviewRank), e);
		}
		log.debug("职级确认结束.....");
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 人员表中的职级调整
	 * 
	 * @param request
	 * @param response
	 * @param rankId
	 * @throws GeneralException
	 */
	@RequestMapping("/updateRankAdjust")
	@VisitDesc(label="人员职级调整",actionType=3)
	public void updateRankAdjust(HttpServletRequest request, HttpServletResponse response, String rankId, String confirmRank)
			throws GeneralException, JsonParseException, JsonMappingException, IOException {
		log.debug("ReviewRankController updateRankAdjust  start.....");
		ReviewRank reviewRank = new ReviewRank();
		reviewRank.setUpdatedUser(CurrentUser.getUser().getUserCode());
		reviewRank.setRankId(rankId);
		reviewRank.setConfirmRank(confirmRank);
		try {

			// 人员职级调整
			reviewRankService.updateSalesRank(reviewRank);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("职级调整操作异常，传入参数为：" + JSONObject.toJSONString(reviewRank), e);
		}
		log.debug("ReviewRankController updateRankAdjust  end.....");
		SendUtil.sendJSON(response, "OK");
	}

	@RequestMapping("/findReviewRankDetail")
	@VisitDesc(label="查询职级明细信息",actionType=4)
	public void findReviewRankDetailByPK(HttpServletRequest request, HttpServletResponse response, String rankId) throws GeneralException {
		ReviewRank reviewRank = reviewRankService.findReviewRankDetailByPK(rankId);
		SendUtil.sendJSON(response, reviewRank);
	}
	
	@RequestMapping("/queryComAndCusRank")
	public void queryComAndCusRank(HttpServletRequest request, HttpServletResponse response, String rankId) throws GeneralException {
		Map<Object,String> map  = new HashMap<Object,String>();
		map = reviewRankService.queryComAndCusRank(rankId);
		SendUtil.sendJSON(response, map);
	}

	/**
	 * 简要说明:调整职级 <br><pre>
	 * 方法confirmReviewRank的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月27日 下午2:50:58 </pre>
	 */
	@RequestMapping("/chnageReviewRank")
	@VisitDesc(label="调整职级",actionType=3)
	public void chnageReviewRank(HttpServletRequest request, HttpServletResponse response, ReviewRank reviewRank) throws GeneralException,
			JsonParseException, JsonMappingException, IOException {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		
		whereMap.put("confirmUser", CurrentUser.getUser().getUserCode());
		whereMap.put("rankId", reviewRank.getRankId());
		whereMap.put("confirmRank", reviewRank.getConfirmRank());
		if(StringUtil.isNotEmpty(reviewRank.getCusConfirmRank())){
			whereMap.put("cusConfirmRank", reviewRank.getCusConfirmRank());
		}else{
			whereMap.put("cusConfirmRank", "");
		}
		whereMap.put("salesmanCode", reviewRank.getSalesmanCode());
		whereMap.put("signNo", reviewRank.getSignNo());
		log.debug("param:" + whereMap);
		try {
			reviewRankService.changeReviewRank(whereMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("确认职级操作异常，传入参数为：" + whereMap, e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	@RequestMapping("/findRankLevel")
	@VisitDesc(label="查询职级是否需要审批",actionType=4)
	public void findRankLevel(HttpServletRequest request, HttpServletResponse response, String rankCode) {
		boolean auditFlag = reviewRankService.findRankAuditFlag(rankCode);
		log.debug("确认的职级" + rankCode + "是否需要上报审批:" + auditFlag);
		String userCode = CurrentUser.getUser().getUserCode();
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);
		String roleName = (String) roleCodeList.get(0).get("roleEname");
		// 如果不是总公司室主任, 不是总公司人员管理岗，并且职级的调整需要上报审批
		if (((!"headDeptDirector".equals(roleName)) || (!"haedDeptSalesman".equals(roleName))|| (!"xszcAdmin".equals(roleName))) && auditFlag) {
			SendUtil.sendString(response, "true");
		}
	}

	/**
	 * 查询出用户角色权限，用于页面数据显示的操作
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
	
	@RequestMapping("/queryUserAuthority")
	public void queryUserAuthority(HttpServletRequest request, HttpServletResponse response) {
		// 获取当前登录用户
		String userCode = CurrentUser.getUser().getUserCode();
		Map<String,Object> map = umService.findDefaultDeptCodeByUserCode(userCode);
	    String deptCode = map.get("deptCode").toString();
		if(deptCode.equals("00")){
			SendUtil.sendString(response, "true");
		}else{
			SendUtil.sendString(response, "false");
		}
	}
	@RequestMapping("/queryRankSize")
	public void queryRankSize(HttpServletRequest request, HttpServletResponse response) {
		Map<String,Object> parmMap = new HashMap<String,Object>();
		String confirmRankCode = request.getParameter("rankCode");  //调整职级
		String recommendCode = request.getParameter("recommendCode");    //推荐职级
		String deptCode = request.getParameter("deptCode");    //二级机构代码
		Pattern p = Pattern.compile("[0-9]");
	   Matcher m = p.matcher(deptCode);
	   String dept = "";
	   while (m.find()) {
		   dept+=m.group();
		  }
		parmMap.put("confirmCode", confirmRankCode);
		parmMap.put("recommendName", recommendCode);
		parmMap.put("deptCode", dept);
		//分别查询出2个职级的月度固定工资
		boolean flag = reviewRankService.queryMonthSalary(parmMap);
		SendUtil.sendString(response, String.valueOf(flag));
	}
	
	@RequestMapping("/queryRankSize2")
	public void queryRankSize2(HttpServletRequest request, HttpServletResponse response) {
		Map<String,Object> parmMap = new HashMap<String,Object>();
		String cusConfirmRank = request.getParameter("cusConfirmRank");  //调整职级
		String cusRecommendRank = request.getParameter("cusRecommendRank");    //推荐职级
		String deptCode = request.getParameter("deptCode");    //二级机构代码
		Pattern p = Pattern.compile("[0-9]");
	   Matcher m = p.matcher(deptCode);
	   String dept = "";
	   while (m.find()) {
		   dept+=m.group();
		  }
		parmMap.put("confirmCode", cusConfirmRank);
		parmMap.put("recommendName", cusRecommendRank);
		parmMap.put("deptCode", dept);
		//分别查询出2个职级的月度固定工资
		boolean flag = reviewRankService.queryMonthSalary(parmMap);
		SendUtil.sendString(response, String.valueOf(flag));
	}
	
	@RequestMapping("/queryRankName")
	public void queryRankName(HttpServletRequest request, HttpServletResponse response) {
		String rankCode = request.getParameter("randCode");
		String rankName="";
		if(rankCode.equals("T")){
			rankName = "淘汰";
		}else{
			rankName = reviewRankService.queryRankName(rankCode);
		}
		SendUtil.sendString(response, rankName);
	}
	
	/**
	 * 详细说明:批量职级恢复 <br>
	 * @throws Exception
	 */
	@RequestMapping("/recoverRank")
	@VisitDesc(label="批量职级恢复",actionType=3)
	public void recoverRank(HttpServletRequest request,HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		boolean actionFlag = true;
		try{
			String salesmanCodes = request.getParameter("salesmanCodes");
			String calcMonth = request.getParameter("calcMonth");
				actionFlag = this.reviewRankService.batchRecoverRank(salesmanCodes,calcMonth);
				if(actionFlag == false){
					jsonObject.put("actionFlag", false);
					jsonObject.put("actionMsg", "恢复失败！");
				}else{
					jsonObject.put("actionMsg", "职级恢复成功！");
					jsonObject.put("actionFlag", actionFlag);
				}
		}catch(Exception e){
			jsonObject.put("actionFlag", false);
			jsonObject.put("actionMsg", "恢复失败！");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}
}
