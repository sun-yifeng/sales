package com.sinosafe.xszc.report.controller;

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
import com.sinosafe.xszc.report.service.ReportFoundationMediumService;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.ExportExcelNew;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/reportFoundationMediumNew")
public class ReportFoundationMediumNewController {

	private static final Log log = LogFactory.getLog(ReportFoundationMediumNewController.class);
	
	@Autowired
	@Qualifier("ReportFoundationMediumService")
	private ReportFoundationMediumService reportFoundationMediumService;
	

	/**
	 * <pre>
	 * 方法queryReportDayAgentChannel的详细说明 <br>
	 * 此方法用于初始化列表数据和自定义查询数据
	 * 编写者：黄思凯
	 * 创建时间：2014年5月29日
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryReportDayAgentChannelNew")
	public void queryReportDayAgentChannelNew(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportFoundationMediumService.findReportDayAgentChannelByWhereNew(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/queryDataToExcelNew")
	public void queryDataToExcelNew(HttpServletRequest request, HttpServletResponse response, FormDto dto){
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportFoundationMediumService.findReportDayAgentChannelByWhereNew(pageDto);
			
			ExportExcelNew.reportFM(request,response, pageDto);
			
		} catch (Exception e) {
			log.error(e);
			try {
				throw new ServiceException("分页查询操作异常，传入参数为：" + dto.getFormMap(), e);
			} catch (ServiceException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	}

	
	
	/**
	 *
	 * 指定文件路径,生成Excel <br><pre>
	 * 方法queryDataToExcel的详细说明 <br>
	 * 编写者：黄思凯
	 * 创建时间：2014-6-7
	 * @param @param request
	 * @param response
	 * @param dto 
	 * @throws 无
	 */
	/*@RequestMapping("/queryDataToExcel")
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
			pageDto = reportFoundationMediumService.queryDataToExcel(pageDto);

			//定义从数据库取出数据顺序数组
			String[] colum_name = {"deptName", "insureCode", "agentCode","bizCode", "supportCode", "signCode","lastDaySign", "monthSign", "yearSign"};
			//模板路径
			String strFileName = "D://reportDayAgentChannelModel.xls";
			
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
			ExportExcel.dataToExcel(pageDto.getRows(), strFileName,colum_name,response.getOutputStream());
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("导出Excel操作异常，传入参数为：" + paramMap, e);
		}
	}*/
	
}
