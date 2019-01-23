package com.sinosafe.xszc.report.controller;

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

import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.report.service.ReportGroupSaleService;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/reportGroupSale")
public class ReportGroupSaleController {

	private static final Log log = LogFactory.getLog(ReportGroupSaleController.class);
	
	@Autowired
	@Qualifier("ReportGroupSaleService")
	private ReportGroupSaleService reportGroupSaleService;

	/**
	 * <pre>
	 * 方法queryReportGroupSale的详细说明 <br>
	 * "销售团队业绩日报"列表数据和自定义查询数据
	 * 编写者：黄思凯
	 * 创建时间：2014年10月13日
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryReportDayGroupSale")
	public void queryReportDayGroupSale(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportGroupSaleService.findReportDayGroupSaleByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * <pre>
	 * 方法queryReportGroupSale的详细说明 <br>
	 * "销售团队业绩周报"列表数据和自定义查询数据
	 * 编写者：黄思凯
	 * 创建时间：2014年10月13日
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryReportWeekGroupSale")
	public void queryReportWeekGroupSale(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportGroupSaleService.findReportWeekGroupSaleByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * <pre>
	 * 方法queryReportGroupSale的详细说明 <br>
	 * "销售团队业绩月报"列表数据和自定义查询数据
	 * 编写者：黄思凯
	 * 创建时间：2014年10月13日
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryReportMonthGroupSale")
	public void queryReportMonthGroupSale(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportGroupSaleService.findReportMonthGroupSaleByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 方法queryReportDayToExcel的详细说明 <br>
	 * 编写者：黄思凯
	 * 创建时间：2014-10-14
	 * @param @param request
	 * @param response
	 * @param dto 
	 * @throws 无
	 */
	@RequestMapping("/queryReportDayToExcel")
	public void queryReportDayToExcel(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		//查询所有符合条件数据不分页，用来导出Excel
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			//不分页查询所有数据
			pageDto = reportGroupSaleService.queryReportDayToExcel(pageDto);
			//List<Map<String,Object>> list = pageDto.getRows();
			//定义从数据库取出数据顺序数组
			String[] colum_name = {"deptCode2","deptCode3", "groupCname", "groupCode",
					"groupLeader", "groupPlanYear", //"groupTotalFee","groupPlanPercent", 
					"gotFeeYesterday", "gotFeeToday", "gotFeeMonth", "gotFeeYear"};
			//模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			String strFileName ="reportDayGroupTotal.xls";
			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename=" + strFileName);
			response.setContentType("application/x-download; charset=utf-8");
			//生成所需的Excel文件
			ExportExcel.dataToExcel(pageDto.getRows(), strFilePath+strFileName,colum_name,response.getOutputStream());
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}
	
	/**
	 * 方法queryReportWeekToExcel的详细说明 <br>
	 * 编写者：黄思凯
	 * 创建时间：2014-10-14
	 * @param @param request
	 * @param response
	 * @param dto 
	 * @throws 无
	 */
	@RequestMapping("/queryReportWeekToExcel")
	public void queryReportWeekToExcel(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		//查询所有符合条件数据不分页，用来导出Excel
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			//不分页查询所有数据
			pageDto = reportGroupSaleService.queryReportWeekToExcel(pageDto);
			//定义从数据库取出数据顺序数组
			String[] colum_name = {"deptCode2","deptCode3", "groupCname", "groupCode",
					"groupLeader", "groupPlanYear", //"groupTotalFee","groupPlanPercent", 
					"gotFeeLastWeek", "gotFeeThisWeek", "gotFeeThisYear", "gotFeeLastYear",
					"inceaseRate", "calimRateLastWeek", "calimRateTishWeek"};
			//模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			String strFileName ="reportWeekGroupTotal.xls";
			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename=" + strFileName);
			response.setContentType("application/x-download; charset=utf-8");
			//生成所需的Excel文件
			ExportExcel.dataToExcel(pageDto.getRows(), strFilePath+strFileName,colum_name,response.getOutputStream());
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}
	/**
	 * 方法queryReportMonthToExcel的详细说明 <br>
	 * 编写者：黄思凯
	 * 创建时间：2014-10-14
	 * @param @param request
	 * @param response
	 * @param dto 
	 * @throws 无
	 */
	@RequestMapping("/queryReportMonthToExcel")
	public void queryReportMonthToExcel(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		//查询所有符合条件数据不分页，用来导出Excel
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			//不分页查询所有数据
			pageDto = reportGroupSaleService.queryReportMonthToExcel(pageDto);
			List<Map<String,Object>> list = pageDto.getRows();
			for(int i = 0;i<list.size();i++){
				if(list.get(i).get("claimRateLastMonth") == null){
					list.get(i).put("claimRateLastMonth", "0.00%");
				}
				if(list.get(i).get("claimRateLastMonthYear") == null){
					list.get(i).put("claimRateLastMonthYear", "0.00%");
				}
				if(list.get(i).get("claimRateThisMonth") == null){
					list.get(i).put("claimRateThisMonth", "0.00%");
				}
				if(list.get(i).get("claimRateThisMonthYear") == null){
					list.get(i).put("claimRateThisMonthYear", "0.00%");
				}
			}
			//定义从数据库取出数据顺序数组
			String[] colum_name = {"deptCode2","deptCode3", "groupCname", "groupCode",
					"groupLeader", "groupPlanFee", "groupTotalFee","groupPlanPercetn", 
					"gotFeeLastMonth", "gotFeeThisMonth", "gotFeeThisYeae", "gotFeeLastYeae",
					"gotFeeInceaseRate", "claimRateLastMonth", "claimRateThisMonth","claimRateLastMonthYear", 
					"claimRateThisMonthYear", "menberCountLastYear", "menberCountThisYear", "inceaseCount", 
					"avgFee", "renewalRateCar", "gotFeeNotCar", "percentNotCar"};
			//模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			String strFileName ="reportMonthGroupTotal.xls";
			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename=" + strFileName);
			response.setContentType("application/x-download; charset=utf-8");
			//生成所需的Excel文件
			ExportExcel.dataToExcel(pageDto.getRows(), strFilePath+strFileName,colum_name,response.getOutputStream());
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}
}
