package com.sinosafe.xszc.review.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.group.controller.GroupMainController;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.review.service.ReviewSalaryService;
import com.sinosafe.xszc.review.vo.ReviewSalary;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/reviewSalary")
public class ReviewSalaryController {

	private static final Log log = LogFactory.getLog(GroupMainController.class);

	@Autowired
	@Qualifier("ReviewSalaryService")
	private ReviewSalaryService reviewSalaryService;

	/**
	 * 查询所有薪酬信息
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@VisitDesc(label="查询薪酬信息",actionType=4)
	@RequestMapping("/queryReviewSalary")
	public void queryReviewSalary(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		String curDeptCode = (String)request.getSession().getAttribute("curDeptCode");
		if(curDeptCode.equals("00")){
			curDeptCode = "";
		}
		pageDto.getWhereMap().put("curDeptCode", curDeptCode);
		try {
			pageDto = reviewSalaryService.findReviewSalaryByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 
	 * 指定模板文件路径,生成Excel <br>
	 * 
	 * <pre>
	 * 方法queryDataToExcel的详细说明 <br>
	 * @param @param request
	 * @param response
	 * @param dto
	 * @throws 无
	 */
	@RequestMapping("/queryDataToExcel")
	@VisitDesc(label="导出薪酬信息",actionType=4)
	public void queryDataToExcel(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
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
			pageDto = reviewSalaryService.queryDataToExcel(pageDto);

			// 定义从数据库取出数据顺序数组
			String[] colum_name = { "calcMonth", "deptCodeTwo", "deptNameTwo", "deptCodeThree", "deptNameThree", "deptCodeFour",
					"deptNameFour", "groupName", "bizLineName", "salesmanCode", "salesmanName", "rankName", "companyDate",
					"positionDate", "salaryFixed", "salaryPerform", "salaryBase", "salaryBenefit", "salaryTotal" };
			// 模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			// String strFilePath = "/home/xssurport/app/ExportExcel/";
			String strFileName = "reviewSalaryModel.xls";

			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename=" + strFileName);
			response.setContentType("application/x-download; charset=utf-8");

			// 生成所需的Excel文件
			ExportExcel.dataToExcel(pageDto.getRows(), strFilePath + strFileName, colum_name, response.getOutputStream());
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}

	/**
	 * 薪酬确认数据查询
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/querySalaryConfirm")
	@VisitDesc(label="薪酬确认数据查询")
	public void querySalaryConfirm(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reviewSalaryService.querySalaryConfirm(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 详细说明:批量薪酬确认 <br>
	 * 编写者:卢水发
	 * @throws Exception
	 */
	@RequestMapping("/batchConfirmReviewSalary")
	@VisitDesc(label="批量薪酬确认",actionType=3)
	public void batchConfirmReviewSalary(HttpServletRequest request,HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		boolean actionFlag = true;
		try{
			String rangeRows = request.getParameter("rows");
			JSONArray reviewSalaryList = JSONArray.parseArray(rangeRows);
			if(actionFlag){
				actionFlag = this.reviewSalaryService.batchConfirmSalary(reviewSalaryList);
			    jsonObject.put("actionMsg", "薪酬确认成功！");
			    jsonObject.put("actionFlag", actionFlag);
			}
		}catch(Exception e){
			e.printStackTrace();
			jsonObject.put("actionFlag", false);
			jsonObject.put("actionMsg", "确认失败！");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}
	
	/**
	 * 薪酬修改
	 */
	@RequestMapping("/updateReviewSalary")
	@VisitDesc(label="修改薪酬信息",actionType=3)
	public void updateReviewSalary(HttpServletRequest request, HttpServletResponse response, String salaryId) throws GeneralException,
	JsonParseException, JsonMappingException, IOException {
		ReviewSalary reviewSalary = new ReviewSalary();
		reviewSalary.setUpdatedUser(CurrentUser.getUser().getUserCode());
		reviewSalary.setSalaryId(salaryId);
		try {
			reviewSalaryService.updateReviewSalary(reviewSalary);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(reviewSalary), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

}
