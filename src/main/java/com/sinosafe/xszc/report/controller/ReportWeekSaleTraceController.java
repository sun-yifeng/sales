package com.sinosafe.xszc.report.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.ServletOutputStream;
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
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.report.service.ReportWeekSaleTraceService;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/reportWeekSaleTrace")
public class ReportWeekSaleTraceController {

	private static final Log log = LogFactory.getLog(ReportWeekSaleTraceController.class);
	
	@Autowired
	@Qualifier("ReportWeekSaleTraceService")
	private ReportWeekSaleTraceService reportWeekSaleTraceService;

	@Autowired 
	@Qualifier(value = "umService") 
	private UmService umService;
	/**
	 * <pre>
	 * 方法queryReportWeekSaleTrace的详细说明 <br>
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
	@RequestMapping("/queryReportWeekSaleTrace")
	public void queryReportWeekSaleTrace(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		//String parentDept = (String) paramMap.get("parentDept");
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
//		if("".equals(parentDept)){//查询器中二级机构为空时,使用当前登录的用户所在机构的代码作为条件
//			List<Map<String, Object>> list = umService.findDeptListByUserCode(CurrentUser.getUser().getUserCode());
//			if(list != null && list.size() == 1){
//				paramMap.put("parentDept", list.get(0).get("deptCode").toString());
//			}
//		}
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportWeekSaleTraceService.findReportWeekSaleTraceByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 *
	 * 指定模板文件路径,生成Excel <br><pre>
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
		
		//查询所有符合条件数据不分页，用来导出Excel
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		
		try {
			//不分页查询所有数据
			pageDto = reportWeekSaleTraceService.queryDataToExcel(pageDto);

			//定义从数据库取出数据顺序数组
			String[] colum_name = {"deptName", "bizLine", "insureCode", "premiumPlan",
					"weekIncome", "monthIncome","yearIncome", "premiumPlanRate", 
					"schedulePlanRate", "termIncreaseRate", "yearIncreaseRate", 
					"weekSign", "monthSign", "yearSign", "policyIncreaseTate",
					"lastYearCompansation", "toYearCompansation", "linkRelativeRatio"};
			//模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			//	String strFilePath = "/home/xssurport/app/ExportExcel/";
			String strFileName ="reportWeekSaleTraceModel.xls";
			
			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition",
					"attachment;filename=" + strFileName);
			response
					.setContentType("application/x-download; charset=utf-8");
			
			//生成所需的Excel文件
			ExportExcel.dataToExcel(pageDto.getRows(), strFilePath+strFileName,colum_name,response.getOutputStream());
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}
	
	@RequestMapping("/downLoadFile")
	public void downLoadFile(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		FileInputStream input = null;
		ServletOutputStream output = null;
		try {
			String strFileName = "D:/项目资料杨沅/CmszWorkManagement.zip";
			File file = new File( strFileName);
			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"),"ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename="
					+ strFileName);
			response.setContentType("application/x-download; charset=utf-8");

			input = new FileInputStream(file);
			output = response.getOutputStream();
			byte[] block = new byte[1024];
			int len = 0;
			// **************开始下载文件*****************//
			while ((len = input.read(block)) != -1) {
				output.write(block, 0, len);
			}
			output.flush();

		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				if (input != null) {
					input.close();
				}
				if (output != null) {
					output.close();
				}
			} catch (IOException ex) {
				log.error(ex.getMessage());
			}
		}
	}
	
}
