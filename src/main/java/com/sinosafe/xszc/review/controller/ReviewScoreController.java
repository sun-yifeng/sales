package com.sinosafe.xszc.review.controller;

import java.net.URLEncoder;
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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.review.service.ReviewScoreService;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/reviewScore")
public class ReviewScoreController {

	private static final Log log = LogFactory.getLog(ReviewScoreController.class);

	@Autowired
	@Qualifier("ReviewScoreService")
	private ReviewScoreService reviewScoreService;
	
	@Autowired
	@Qualifier("NoticeService")
	private NoticeService noticeService;

	//得分查询
	@RequestMapping("/queryReviewScore")
	@VisitDesc(label="查询考核评分",actionType=4)
	public void queryReviewScore(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
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
			pageDto = reviewScoreService.findReviewScoreByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	//得分导出
	@RequestMapping("/excelPlyList")
	@VisitDesc(label="导出考核评分",actionType=4)
	public void excelPlyList(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		// 查询所有符合条件数据不分页，用来导出Excel
		PageDto pageDto = new PageDto();
		pageDto.setStart("0");
		pageDto.setLimit("100000");
		pageDto.setWhereMap(dto.getFormMap());
		try {
			// 不分页查询所有数据
			pageDto = reviewScoreService.findReviewScoreByWhere(pageDto);
			// 定义从数据库取出数据顺序数组
			String[] colum_name = { 
				"calcMonth", "deptNameTwo", "deptNameThree", "deptNameFour", "managerFlag", "employNo", "salesName", "salesCode",
				"tryOut", "contractDate", "entryDate", "rankName", "frontDate", "groupFoundDate", "groupEntryDate", "groupLeaveDate",
				"reviewResult","rankNameRec", "groupName", "frontMonth", "normPremium", "baseSalary","caclSalary","groupPrmGot",
				"groupPrmSta", "yearGot", "yearSta", "scheduleStan","scheduleRate","thisYearClm", "thisYearPro", "twelevMonthClm", 
				"twelevMonthPro", "twelevMonthRate", "score", "salaryFixed", "salaryPerform", "salaryBase", "salaryTotal"
				};
			// 模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			String strFileName = "salesmanSalaryList.xls";

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

	@RequestMapping("/confirmReviewScore")
	@VisitDesc(label="确认考核评分",actionType=4,hidden=true)
	public void confirmReviewScore(HttpServletRequest request, HttpServletResponse response, String deptCodeThree, String statMonth)
			throws GeneralException {
		try {
			reviewScoreService.confirmReviewScore(deptCodeThree, statMonth);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("执行操作异常，传入参数为：" + deptCodeThree, e);
		}
		SendUtil.sendJSON(response, "success");
	}

	@RequestMapping("/queryScoreCoutApply")
	@VisitDesc(label="计划任务查询",actionType=4)
	public void queryScoreCoutApply(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		
		List<String> subBusinessLine = noticeService.filterSubBusinessLines();
		pageDto.getWhereMap().put("nrl", subBusinessLine);
		
		try {
			pageDto = reviewScoreService.findScoreCoutApplyByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/queryScoreConfirm")
	@VisitDesc(label="确认考核评分",actionType=4)
	public void queryScoreConfirm(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reviewScoreService.queryScoreConfirm(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/batchConfirmScore")
	@VisitDesc(label="批量[客户经理/团队经理]评分确认",actionType=3)
	public void batchConfirmScore(HttpServletRequest request,HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		boolean actionFlag = true;
		try{
			String rangeRows = request.getParameter("rows");
			JSONArray reviewScoreList = JSONArray.parseArray(rangeRows);
			if(actionFlag){
				actionFlag = this.reviewScoreService.batchConfirmScore(reviewScoreList);
			    jsonObject.put("actionMsg", "评分确认成功！");
			    jsonObject.put("actionFlag", actionFlag);
			}
		}catch(Exception e){
			e.printStackTrace();
			jsonObject.put("actionFlag", false);
			jsonObject.put("actionMsg", "确认失败！");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}

	//查询保费清单
	@RequestMapping("/queryPlyPrmList")
	@VisitDesc(label="查询标准保费",actionType=4)
	public void queryPlyPrmList(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reviewScoreService.queryPlyPrmListByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/exportPlyPrmList")
	@VisitDesc(label="导出保费清单",actionType=4)
	public void exportPlyPrmList(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		//查询所有符合条件数据不分页，用来导出Excel
		PageDto pageDto = new PageDto();
		pageDto.setStart("0");
		pageDto.setLimit("200000");
		pageDto.setWhereMap(dto.getFormMap());
		try {
			//不分页查询所有数据
			pageDto = reviewScoreService.queryPlyPrmListByWhere(pageDto);
			//定义从数据库取出数据顺序数组
			String[] colum_name = {"deptNameTwo", "policyNo", "endorseNo", "salesman", "groupName",
					"paymentDate","insuranceStart","insuranceEnd","realPremium","standardPremium",
					"lineName","busLineRate","productNo","productRate","car","carRate",
					"channelCode","channelName","channelRate","busOrigin", "busOriginRate","createdDate"};
			//模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			String strFileName = "standardPremiumList.xls";
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
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}
	
	//查询赔付率清单 TODO
	@RequestMapping("/queryClmRateList")
	@VisitDesc(label="查询赔付率清单",actionType=4)
	public void queryClmRateList(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reviewScoreService.queryClmRateListByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	//导出赔付率清单 TODO
	@RequestMapping("/exportClmRate")
	@VisitDesc(label="导出赔付率清单",actionType=4)
	public void exportClmRate(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		//查询所有符合条件数据不分页，用来导出Excel
		PageDto pageDto = new PageDto();
		pageDto.setStart("0");
		pageDto.setLimit("200000");
		pageDto.setWhereMap(dto.getFormMap());
		try {
			//不分页查询所有数据
			pageDto = reviewScoreService.queryClmRateListByWhere(pageDto);
			//定义从数据库取出数据顺序数组
			String[] colum_name = {"deptNameTwo", "policyNo", "salesman", "groupName",
					"yjPrm","wjPrm","manQi","bgnDate","endDate","udrDate","createdDate"};
			//模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			String strFileName = "clmRateList.xls";
			
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
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}

}
