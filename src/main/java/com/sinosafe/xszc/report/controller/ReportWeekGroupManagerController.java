package com.sinosafe.xszc.report.controller;

import java.io.PrintWriter;
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
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.report.service.ReportWeekGroupManagerService;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/reportWeekGroupManager")
public class ReportWeekGroupManagerController {

	private static final Log log = LogFactory.getLog(ReportWeekGroupManagerController.class);
	
	@Autowired
	@Qualifier("ReportWeekGroupManagerService")
	private ReportWeekGroupManagerService reportWeekGroupManagerService;

	/**
	 * <pre>
	 * 方法queryReportGroupManagerTrace的详细说明 <br>
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
	@RequestMapping("/queryReportWeekGroupManager")
	public void queryReportWeekGroupManager(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportWeekGroupManagerService.findReportWeekGroupManagerByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	/**
	 * <pre>
	 * 方法queryParentDept的详细说明 <br>
	 * 此方法用于加载二级机构
	 * 编写者：黄思凯
	 * 创建时间：2014年5月30日
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryParentDept")
	public void queryParentDept(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		JSONArray result=new JSONArray();
		result.add(buildDept("","查询全部"));
		try {
			pageDto = reportWeekGroupManagerService.queryParentDept(pageDto);
			for(int i=0;i<pageDto.getRows().size();i++){
				result.add(buildDept(pageDto.getRows().get(i).get("C_INTER_CDE").toString(),pageDto.getRows().get(i).get("YINYEBU_NAME").toString()));
			}
			response.reset();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = response.getWriter();
			writer.write(result.toString());
			writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("二级机构查询异常，传入参数为：" + paramMap, e);
		}
	}
	
	/**
	 * <pre>
	 * 方法queryDeptName的详细说明 <br>
	 * 此方法用于加载三级机构
	 * 编写者：黄思凯
	 * 创建时间：2014年6月3日
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryDeptName")
	public void queryDeptName(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		JSONArray result=new JSONArray();
		result.add(buildDept("","查询全部"));
		try {
			pageDto = reportWeekGroupManagerService.queryDeptName(pageDto);
			for(int i=0;i<pageDto.getRows().size();i++){
				result.add(buildDept(pageDto.getRows().get(i).get("C_INTER_CDE").toString(),pageDto.getRows().get(i).get("YINYEBU_NAME").toString()));
			}
			response.reset();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = response.getWriter();
			writer.write(result.toString());
			writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("三级机构查询异常，传入参数为：" + paramMap, e);
		}
	}
	
	/**
	 * 拼装json字符串
	 * @param id
	 * @param name
	 * @return JSONObject
	 */
	private JSONObject buildDept(String id,String name){
	    JSONObject result=new JSONObject();
	    result.put("value", id);
	    result.put("text", name);
	    return result;
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
			pageDto = reportWeekGroupManagerService.queryDataToExcel(pageDto);

			//定义从数据库取出数据顺序数组
			String[] colum_name = {"parentDept" ,"deptName", "deptUnit", "employMode", "employType", 
			          "employCode", "yearStandartPlan","yearPremiumPlan", "daySign",
			          "monthSign", "yearSign","standardPremium","premiumPlanRate","lastYearCompansation","toYearCompansation","linkRelativeRatio"};
			//模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
//			String strFilePath = "/home/xssurport/app/ExportExcel/";
			String strFileName ="reportWeekGroupManagerModel.xls";
			
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
