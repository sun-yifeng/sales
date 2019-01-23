package com.sinosafe.xszc.report.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.report.service.ReportMothGroupManagerService;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/reportMothGroupManager")
public class ReportMothGroupManagerController {

	private static final Log log = LogFactory
			.getLog(ReportMonthAgentInfoController.class);

	@Autowired
	@Qualifier("ReportMothGroupManagerService")
	private ReportMothGroupManagerService reportMothGroupManagerService;

	@RequestMapping("/queryReportMothGroupManager")
	private void queryReportMothGroupManager(HttpServletRequest request,
			HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportMothGroupManagerService
					.findReportMonthAgentInfoByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@SuppressWarnings("deprecation")
	@RequestMapping("/queryDataToExcel")
	public void queryDataToExcel(HttpServletRequest request,
			HttpServletResponse response, FormDto dto) throws GeneralException {
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
			pageDto = reportMothGroupManagerService.queryDataToExcel(pageDto);
			// 模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			// String strFilePath = "/home/xssurport/app/ExportExcel/";
			String strFileName = "reportMonthGroupManager.xls";
			String monthLy[] = { "countMonthlyOne", "countMonthlyTwo", "countMonthlyThree", "countMonthlyFour",
											"countMonthlyFive", "countMonthlySix", "countMonthlySeven",
											"countMonthlyEight", "countMonthlyNine", "countMonthlyTen",
											"countMonthlyEleven", "countMonthlyTwelve" };
			List<String> list = new ArrayList<String>();
			list.add("parentDept");
			list.add("deptName");
			list.add("groupCode");
			list.add("manageCode");
			list.add("lastYearCumulative");
			Date date = new Date();

			if (paramMap.get("reportMoth") != null)
				date.setMonth(Integer.parseInt((paramMap.get("reportMoth").toString()).substring(6)));

			int mon = date.getMonth();
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(strFilePath
					+ strFileName));
			int i = 0;
			if (mon != 0) {
				while (i < 12) {
					if (i < mon)
						list.add(monthLy[i]);

					if (i + 1 < mon) {
						wb.removeSheetAt(0);
					} else if (i + 1 > mon) {
						wb.removeSheetAt(1);
					}
					i++;
				}
			} else {
				while (i < monthLy.length) {
					list.add(monthLy[i]);
					if (i != 0) {
						wb.removeSheetAt(0);
					}
					i++;
				}
			}
			list.add("toYearCumulative");
			list.add("roses");
			list.add("growths");
			list.add("lastYaerPayment");
			list.add("lastYearAcciFreq");
			list.add("toyaerPayment");
			list.add("toyearAcciFreq");
			list.add("toyearContriRate");
			list.add("acquisiCostPolicy");
			;
			// 定义从数据库取出数据顺序数组
			final int size = list.size();
			String[] colum_name = (String[]) list.toArray(new String[size]);

			String outFileName = "reportMonthGroupManager" + mon + ".xls";

			wb.write(new FileOutputStream(strFilePath + outFileName));

			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				outFileName = URLEncoder.encode(outFileName, "UTF-8");// IE浏览器
			} else {
				outFileName = new String(outFileName.getBytes("UTF-8"),
						"ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename="
					+ outFileName);
			response.setContentType("application/x-download; charset=utf-8");

			// 生成所需的Excel文件
			ExportExcel.dataToExcel(pageDto.getRows(), strFilePath
					+ outFileName, colum_name, response.getOutputStream());
			File file = new File(strFilePath + outFileName);
			if (file.exists())
				file.delete();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}
}
