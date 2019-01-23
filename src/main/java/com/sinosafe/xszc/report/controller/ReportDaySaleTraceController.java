package com.sinosafe.xszc.report.controller;

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

import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.report.service.ReportDaySaleTraceService;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/reportDaySaleTrace")
public class ReportDaySaleTraceController {

	private static final Log log = LogFactory.getLog(ReportDaySaleTraceController.class);

	@Autowired
	@Qualifier("ReportDaySaleTraceService")
	private ReportDaySaleTraceService reportDaySaleTraceService;

	/**
	 * <pre>
	 * 方法queryReportDaySaleTrace的详细说明 <br>
	 * 此方法用于初始化列表数据和自定义查询数据
	 * 编写者：黄思凯
	 * 创建时间：2014年6月4日
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryReportDaySaleTrace")
	public void queryReportDaySaleTrace(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportDaySaleTraceService.findReportDaySaleTraceByWhere(pageDto);
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
	 * 编写者：黄思凯
	 * 创建时间：2014-6-9
	 * @param @param request
	 * @param response
	 * @param dto
	 * @throws 无
	 */
	@RequestMapping("/queryDataToExcel")
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
			pageDto = reportDaySaleTraceService.queryDataToExcel(pageDto);
			// 定义从数据库取出数据顺序数组
			String[] columName = { "deptNameTwo", "deptNameThree", "bizLine", "insureType", "premiumPlan", "incomeThisDay", "incomeThisMonth",
					"incomeThisYear", "premiumPlanRate", "incomeLastYear", "schedulePlanRate", "termIncreaseRate", "yearIncreaseRate",
					"signThisDay", "signThisMonth", "signThisYear", "signLastYear", "policyIncreaseRate" };
			// 模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			String strFileName = "reportDaySaleTraceModel.xls";
			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename=" + strFileName);
			response.setContentType("application/x-download; charset=utf-8");
			// 生成所需的Excel文件
			ExportExcel.dataToExcel(pageDto.getRows(), strFilePath + strFileName, columName, response.getOutputStream());
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}
}
