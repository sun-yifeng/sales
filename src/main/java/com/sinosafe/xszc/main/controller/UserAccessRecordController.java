package com.sinosafe.xszc.main.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.common.controller.BaseWebUtil;
import com.sinosafe.xszc.main.service.UserAccessRecordService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.main.vo.UserAccessRecord;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/userAccessRecord")
public class UserAccessRecordController {
    
	@Autowired
	@Qualifier("UserAccessRecordService")
	private UserAccessRecordService userAccessRecordService;
	
	@RequestMapping("/saveVisit")
	public void saveVisit(HttpServletRequest request,HttpServletResponse response){
		try{
			String accessRecordStr = request.getParameter("accessRecord");
			JSONObject jsonObject = JSONObject.parseObject(accessRecordStr);
			String modelClass = jsonObject.get("modelClass").toString().replace("\t", "");
			String modelChildClass = jsonObject.get("modelChildClass").toString().replace("\t", "");
			String actionUrl = jsonObject.get("actionUrl").toString().replace("\t", "");
			String curDeptCode = (String) request.getSession().getAttribute("curDeptCode");
			//当前用户
			IUserDetails curUserInfo = CurrentUser.getUser();
			String currentUser = curUserInfo.getUsername();
			//获取ip地址
			String ipAddress = BaseWebUtil.getIpAddr(request);
			UserAccessRecord uar = new UserAccessRecord();
			uar.setPkId(UUIDGenerator.getUUID());
			uar.setActionDate(DateUtil.getSystemDateStr("yyyy-MM-dd HH:mm:ss"));
			uar.setUserCode(curUserInfo.getUsername());
			uar.setModelClass(modelClass);
			uar.setModelChildClass(modelChildClass);
			uar.setModelClassCode("");
			uar.setModelChildClassCode("");
			uar.setActionLabel("");
			uar.setActionUrl(actionUrl);
			uar.setActionIp(ipAddress);
			uar.setAccessType("页面");
			uar.setDeptCode(curDeptCode);
			uar.setLineCode("");
			uar.setValidInd("1");
			uar.setUserRealName(curUserInfo.getUserCName());
			userAccessRecordService.saveOrUpdateByWhere(uar);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**
	 * 查询系统访问记录
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryVisitRecords")
	@VisitDesc(label="查询系统访问记录",actionType=4)
	public void queryVisitRecords(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = userAccessRecordService.findUserAccessRecordToPage(pageDto);
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response,pageDto);
	}
	
	/**
	 * 查询用户访问记录数
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryUserVisitReport")
	@VisitDesc(label="查询用户访问记录数",actionType=4)
	public void queryUserVisitReport(HttpServletRequest request,HttpServletResponse response,FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = userAccessRecordService.queryUserVisitReport(pageDto);
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap,e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 查询数据访问报表
	 * @param request
	 * @param response
	 * @param dto 
	 * @throws GeneralException
	 * @throws IOException 
	 */
	@RequestMapping("/queryDataVisitReport")
	@VisitDesc(label="查询数据访问报表,用于图表",actionType=4)
	public void queryDataVisitReport(HttpServletRequest request, HttpServletResponse response) throws GeneralException, IOException {
		Map<String,Object> whereMap = new HashMap<String, Object>();
		String actionDate = request.getParameter("actionDate");
		whereMap.put("actionDate", actionDate);
	    List<Map<String,Object>> countList = this.userAccessRecordService.queryDataVisitReport(whereMap);
		String jsonArray = JSONArray.toJSONString(countList);
		response.getWriter().write(jsonArray);
		return;
	}
	
	/**
	 * 查询数据访问报表数据列表
	 * @param request
	 * @param response
	 * @param dto 
	 * @throws GeneralException
	 * @throws IOException 
	 */
	@RequestMapping("/queryDataVisitReportList")
	@VisitDesc(label="查询数据访问报表数据列表",actionType=4)
	public void queryDataVisitReportList(HttpServletRequest request, HttpServletResponse response) throws GeneralException, IOException {
		PageDto pageDto = new PageDto();
		Map<String,Object> whereMap = new HashMap<String, Object>();
		String actionDate = request.getParameter("actionDate");
		whereMap.put("actionDate", actionDate);
	    List<Map<String,Object>> countList = this.userAccessRecordService.queryDataVisitReport(whereMap);
	    Map<String, Object> countRow = new HashMap<String, Object>();
	    for (Map<String, Object> map : countList) {
	    	countRow.put(map.get("modelClass").toString(), map.get("count"));
		}
	    List<Map<String,Object>> countList2 = new ArrayList<Map<String,Object>>();
	    countList2.add(countRow);
	    pageDto.setRows(countList2);
	    pageDto.setTotal((long)countRow.size());
		String jsonArray = JSONObject.toJSONString(pageDto);
		response.getWriter().write(jsonArray);
		return;
	}
	
	
	/**
	 * 查询页面访问报表
	 * @param request
	 * @param response
	 * @param dto 
	 * @throws GeneralException
	 * @throws IOException 
	 */
	@RequestMapping("/queryPageVisitReport")
	@VisitDesc(label="查询数据访问报表,用于图表",actionType=4)
	public void queryPageVisitReport(HttpServletRequest request, HttpServletResponse response) throws GeneralException, IOException {
		Map<String,Object> whereMap = new HashMap<String, Object>();
		String actionDate = request.getParameter("actionDate");
		whereMap.put("actionDate", actionDate);
	    List<Map<String,Object>> countList = this.userAccessRecordService.queryPageVisitReport(whereMap);
		String jsonArray = JSONArray.toJSONString(countList);
		response.getWriter().write(jsonArray);
		return;
	}
	
	/**
	 * 查询页面访问报表数据列表
	 * @param request
	 * @param response
	 * @param dto 
	 * @throws GeneralException
	 * @throws IOException 
	 */
	@RequestMapping("/queryPageVisitReportList")
	@VisitDesc(label="查询页面访问报表数据列表",actionType=4)
	public void queryPageVisitReportList(HttpServletRequest request,HttpServletResponse response) throws GeneralException, IOException {
		PageDto pageDto = new PageDto();
		Map<String,Object> whereMap = new HashMap<String, Object>();
		String actionDate = request.getParameter("actionDate");
		whereMap.put("actionDate", actionDate);
	    List<Map<String,Object>> countList = this.userAccessRecordService.queryPageVisitReport(whereMap);
	    Map<String, Object> countRow = new HashMap<String, Object>();
	    for (Map<String, Object> map : countList) {
	    	countRow.put(map.get("modelClass").toString(),map.get("count"));
		}
	    List<Map<String,Object>> countList2 = new ArrayList<Map<String,Object>>();
	    countList2.add(countRow);
	    pageDto.setRows(countList2);
		String jsonArray = JSONObject.toJSONString(pageDto);
		response.getWriter().write(jsonArray);
		return;
	}
}
