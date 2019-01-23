package com.sinosafe.xszc.report.controller;

import java.io.IOException;
import java.io.PrintWriter;
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
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.report.service.ReportDayAgentChannelService;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/reportDayAgentChannel")
public class ReportDayAgentChannelController {

	private static final Log log = LogFactory.getLog(ReportDayAgentChannelController.class);
	
	@Autowired
	@Qualifier("ReportDayAgentChannelService")
	private ReportDayAgentChannelService reportDayAgentChannelService;

	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;
	
	@Autowired 
	@Qualifier(value = "umService") 
	private UmService umService;
	
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
	@RequestMapping("/queryReportDayAgentChannel")
	public void queryReportDayAgentChannel(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = reportDayAgentChannelService.findReportDayAgentChannelByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	private String getUser() {
		return CurrentUser.getUser().getUserCode();
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
		List<Map<String, Object>> list = umService.findDeptListByUserCode(getUser());
		List<Map<String, Object>> resList = null;
		if(list.size() == 1){
			resList  = departmentService.queryDepartmentByUserCode(list.get(0));
			JSONArray result = new JSONArray();
			try {
				if (resList != null && resList.size() != 0) {
					result.add(buildDept("", "请选择"));
					for (int i = 0; i < resList.size(); i++) {
						result.add(buildDept('9'+resList.get(i).get("deptCode").toString(), resList.get(i).get("deptName").toString()));
					}
				}
				response.reset();
				response.setCharacterEncoding("utf-8");
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter writer;
				writer = response.getWriter();
				writer.write(result.toString());
				writer.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
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
	public void queryDeptName(HttpServletRequest request, HttpServletResponse response,String upDept) throws GeneralException {
		List<Map<String, Object>> list = umService.findDeptListByUserCode(getUser());
		List<Map<String, Object>> resList = null;
		upDept = upDept.substring(1);
		if(list.size() == 1){
			resList = departmentService.queryDepartmentCityByUserCode(list.get(0),upDept);
			JSONArray result = new JSONArray();
			try {
				if (resList != null && resList.size() != 0) {
					result.add(buildDept("", "请选择"));
					for (int i = 0; i < resList.size(); i++) {
						result.add(buildDept('9'+resList.get(i).get("deptCode").toString(), resList.get(i).get("deptName").toString()));
					}
				}
				response.reset();
				response.setCharacterEncoding("utf-8");
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter writer;
				writer = response.getWriter();
				writer.write(result.toString());
				writer.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
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
	 * 创建时间：2014-6-7
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
			pageDto = reportDayAgentChannelService.queryDataToExcel(pageDto);

			//定义从数据库取出数据顺序数组
			String[] colum_name = {"parentDept", "deptName", "insureCode", "agentCode","bizCode", "supportCode", "signCode","lastDaySign", "monthSign", "yearSign"};
			//模板路径
			String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
			//String strFilePath = "/home/xssurport/app/ExportExcel/";
			String strFileName ="reportDayAgentChannelModel.xls";
			
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
