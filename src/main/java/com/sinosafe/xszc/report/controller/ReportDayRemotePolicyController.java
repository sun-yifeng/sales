package com.sinosafe.xszc.report.controller;

import java.net.URLEncoder;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.report.service.ReportDayRemotePolicyService;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/reportDayRemotePolicy")
public class ReportDayRemotePolicyController {
	private static final Log log = LogFactory.getLog(ReportDayRemotePolicyController.class);
	
	@Autowired
	@Qualifier("ReportDayRemotePolicyService")
	private ReportDayRemotePolicyService reportDayRemotePolicyService;

	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;
	
	@Autowired 
	@Qualifier(value = "umService") 
	private UmService umService;
				 
	@RequestMapping("/queryReportDayRemotePolicy")
	public void queryReportDayRemotePolicy(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportDayRemotePolicyService.findReportDayRemotePolicyByWhere(pageDto);
			List<Map<String,Object>> list = pageDto.getRows();
			for(int i = 0;i<list.size();i++){
				Set<String> keys = list.get(i).keySet();
				if(keys != null){
					Iterator<String> iterator = keys.iterator( );
					while(iterator.hasNext( )) {
						String key = (String) iterator.next( );
						if("foundDate".equals(key)){
							String value=list.get(i).get(key).toString();
							list.get(i).put(key, value.substring(0, 10));
						}
					}
				}
			}
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

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
			pageDto =reportDayRemotePolicyService.queryDataToExcel(pageDto);
			//定义从数据库取出数据顺序数组
			String[] colum_name = {"deptNameTwo", "deptNameThree", "deptNameFour", "chennelName",
					"remoteNodeName", "foundDate","planFee","signLastDay","signThisDay",
					"signThisMonth","signThisYear",
					"incomeLastDay","incomeThisDay","incomeThisMonth","incomeThisYear",
					"incomeLastYear","increateRate"};
			//模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			//String strFilePath = "/home/xssurport/app/ExportExcel/";
			String strFileName ="reportDayRemotePolicyModel.xls";
			
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
}
