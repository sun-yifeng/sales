package com.sinosafe.xszc.group.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.HashSet;
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

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.group.service.GroupMainService;
import com.sinosafe.xszc.group.service.SalesmanService;
import com.sinosafe.xszc.group.vo.Salesman;
import com.sinosafe.xszc.group.vo.SalesmanEmploy;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.main.service.MainFrameService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/salesman")
public class SalesmanController {

	private static final Log log = LogFactory.getLog(SalesmanController.class);

	@Autowired
	@Qualifier("SalesmanService")
	private SalesmanService salesmanService;
	
	@Autowired
	@Qualifier("NoticeService")
	private NoticeService noticeService;
	
	@Autowired
	@Qualifier("MainFrameService")
	private MainFrameService mainFrameService;
	
	@Autowired
	@Qualifier("GroupMainService")
	private GroupMainService groupMainService;

	/**
	 * HR人员查询
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/querySalesman")
	@VisitDesc(label="HR人员查询",actionType=4)
	public void querySalesman(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		
		//======================判断是否要过滤信保数据=开始=======================
		boolean xbFlag = false;
		List<Map<String,Object>> roeList = mainFrameService.getUmRole();
		for (Map<String, Object> map : roeList) {
			if(map.get("roleEname").equals("xszcAdmin")){
				xbFlag = true;
			}
		}
		
		if(!xbFlag){
			pageDto.getWhereMap().put("xbFilter", "true");
		}else{
			pageDto.getWhereMap().put("xbFilter", "false");
		}
		//======================判断是否要过滤信保数据=结束=======================
		
		//业务线
		//List<String> subBusinessLines = noticeService.filterSubBusinessLines();
		//pageDto.getWhereMap().put("nrl",subBusinessLines);
		
		try {
			pageDto = salesmanService.findSalesmanByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	//查询更改后的记录
	@RequestMapping("/querySalesmanhistory")
	@VisitDesc(label="查询更改后的记录",actionType=4)
	public void querySalesmanhistory(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = salesmanService.findSalesmanHistoryByWhere(pageDto);
			
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	/**
	 * 人员新增
	 * 
	 * @param request
	 * @param response
	 * @param saleUser
	 * @throws GeneralException
	 */
	@RequestMapping("/saveSalesman")
	@VisitDesc(label="新增人员",actionType=1)
	public void saveSalesman(HttpServletRequest request, HttpServletResponse response, Salesman salesman) throws GeneralException {
		salesman.setCreatedUser(CurrentUser.getUser().getUserCode());
		try {
			salesmanService.saveSalesman(salesman);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(salesman), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 处理
	 * @param request
	 * @param response
	 * @param saleUser
	 * @throws GeneralException
	 */
	@RequestMapping("/updateSalesman")
	@VisitDesc(label="员工修改",actionType=3)
	public void updateSalesman(HttpServletRequest request, HttpServletResponse response, Salesman salesman) throws GeneralException,
			JsonParseException, JsonMappingException, IOException {
		String historyId=UUIDGenerator.getUUID();
		String entryGroupDate = request.getParameter("entryGroupDate");
		salesman.setHistoryId(historyId);
		salesman.setUpdatedUser(CurrentUser.getUser().getUserCode());
		salesman.setProcessStatus("2");
		salesman.setValidInd("1");

		// 接收联系人列表信息
		String jsonData = request.getParameter("salesmanEmployJsonStr") == null ? "" : request.getParameter("salesmanEmployJsonStr");
		if (!jsonData.equals("")) {
			int beginIndex = jsonData.lastIndexOf("[");
			int endIndex = jsonData.lastIndexOf("]");
			// 获取json中的rows中的有效数据
			jsonData = jsonData.substring(beginIndex, endIndex + 1);
			ObjectMapper objectMapper = new ObjectMapper();
			SalesmanEmploy[] salesmanEmploy = objectMapper.readValue(jsonData, SalesmanEmploy[].class);
			Set<SalesmanEmploy> salesmanEmploySet = new HashSet<SalesmanEmploy>();
			for (int i = 0; i < salesmanEmploy.length; i++) {
				salesmanEmploySet.add(salesmanEmploy[i]);
			}
			salesman.setSalesmanEmploy(salesmanEmploySet);
		}
		try {
			salesmanService.updateSalesman(salesman);
			Map<String, Object> paraMap = new HashMap<String,Object>();
			paraMap.put("currentUser", CurrentUser.getUser().getUserCode());
			paraMap.put("groupCode", salesman.getGroupCode());
			paraMap.put("salesCode", salesman.getSalesmanCode());
			paraMap.put("entryGroupDate", entryGroupDate);
			String groupType = groupMainService.quertGroupType(paraMap);
			if(!"2".equals(groupType)){
				salesmanService.insertGroupMember(paraMap);
			}
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(salesman), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 处理
	 * @param request
	 * @param response
	 * @param saleUser
	 * @throws GeneralException
	 */
	@RequestMapping("/updateSalemanDate")
	@VisitDesc(label="员工修改",actionType=3)
	public void updateSalemanDate(HttpServletRequest request, HttpServletResponse response, Salesman salesman) throws GeneralException,
			JsonParseException, JsonMappingException, IOException {
		String historyId=UUIDGenerator.getUUID();
		String entryGroupDate = request.getParameter("entryGroupDate");
		String leaveGroupDate = request.getParameter("leaveGroupDate");
		String frontDate = request.getParameter("frontDate");
		String signNum = request.getParameter("signNum");
		String pkId = request.getParameter("pkId");
		salesman.setHistoryId(historyId);
		salesman.setUpdatedUser(CurrentUser.getUser().getUserCode());
		salesman.setProcessStatus("2");
		salesman.setValidInd("1");

		try {
			Map<String, Object> paraMap = new HashMap<String,Object>();
			paraMap.put("currentUser", CurrentUser.getUser().getUserCode());
			paraMap.put("groupCode", salesman.getGroupCode());
			paraMap.put("salesCode", salesman.getSalesmanCode());
			paraMap.put("employCode", salesman.getEmployCode());
			paraMap.put("pkId", pkId);
			paraMap.put("entryGroupDate", entryGroupDate);
			paraMap.put("leaveGroupDate", leaveGroupDate);
			paraMap.put("frontDate", frontDate);
			paraMap.put("signNum", signNum);
			salesmanService.updateSalesmanDate(paraMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(salesman), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 重置
	 * @param request
	 * @param response
	 * @param salesmanCode
	 * @throws GeneralException
	 */
	@RequestMapping("/resetSalesman")
	@VisitDesc(hidden=true)
	public void resetSalesman(HttpServletRequest request, HttpServletResponse response, String salesmanCode) throws GeneralException {
		try {
			salesmanService.resetSalesman(salesmanCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("重置操作异常，传入参数为：" + salesmanCode, e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 查询详情
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/salesmanDetail")
	@VisitDesc(label="查询员工详情",actionType=4)
	public void salesmanDetail(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = salesmanService.findSalesmansByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	
	@RequestMapping("/salesmanHistoryDetail")
	@VisitDesc(label="查询员工历史信息",actionType=4)
	public void salesmanHistoryDetail(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = salesmanService.findSalesmansDetailByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	/**
	 * 查询详情(人员异动)
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/querySalesmansByLastDept")
	@VisitDesc(label="查询人员异动",actionType=4)
	public void querySalesmansByLastDept(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = salesmanService.findSalesmansOfLastInfoByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	/**
	 * 查询HR人员的name和code，用于非HR人员新增
	 * 
	 * @param pageDto
	 * @return
	 */
	@RequestMapping("/queryNameAndCode")
	@VisitDesc(hidden=true)
	public void queryNameAndCode(HttpServletRequest request, HttpServletResponse response, String deptCode) throws GeneralException {
		Map<String, Object> userMap = new HashMap<String, Object>();

		userMap.put("deptCode", deptCode);
		List<Map<String, Object>> resList = (List<Map<String, Object>>) salesmanService.queryNameAndCode(userMap);
		
		JSONArray result = new JSONArray();
		try {
			if (resList.size() > 0) {
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildUser(resList.get(i).get("value").toString(), resList.get(i).get("text").toString()));
				}
			} else {
				result.add(buildUser("", "该营销部门中暂无HR人员！"));
			}
			outPut(response, result);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 根据人员编码查询电话、邮箱和工号
	 * @param response
	 * @param salesmanCode
	 * 人员编码
	 */
	@RequestMapping("/querySalesmanInfoByCode")
	@VisitDesc(hidden=true)
	public void querySalesmanInfoByCode(HttpServletResponse response, String salesmanCode) {
		List<Map<String, Object>> resList = null;
		try {
			resList = salesmanService.querySalesmanInfoByCode(salesmanCode);
			// 判断人员编码中是否存在@符号
			if (salesmanCode.lastIndexOf("@") == -1) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("salesmanCode", salesmanCode + "@sinosafe.com.cn");
				map.put("tel", resList.get(0).get("tel"));
				map.put("employCode", resList.get(0).get("employCode"));
				resList.set(0, map);
			}
		} catch (Exception e) {
			log.debug("查询错误！！");
			e.printStackTrace();
		}
		SendUtil.sendJSON(response, resList);
	}

	/**
	 * 拼装json字符串
	 * 
	 * @param id
	 * @param name
	 * @return JSONObject
	 */
	private JSONObject buildUser(String id, String name) {
		JSONObject result = new JSONObject();
		result.put("value", id);
		result.put("text", name);
		return result;
	}
	
	/**
	 * 是否是销售总监
	 * 
	 * @param response
	 */
	@RequestMapping("/querySalesDirector")
	public void querySalesDirector(HttpServletRequest request,HttpServletResponse response) {
		JSONArray result = new JSONArray();
		try {
			String salesmanCode = request.getParameter("salesmanCode");
			String  resList = salesmanService.querySalesDirector(salesmanCode);
			result.add(resList);
		} catch (Exception e) {
			log.debug("没有查询到改信息！！");
			e.printStackTrace();
		}
		SendUtil.sendJSON(response, result);
	}
	
	/**
	 * 恢复员工删除状态
	 * @param request
	 * @param response
	 * @param salesmanCode
	 * @throws GeneralException
	 */
	@RequestMapping("/recoverDelStatus")
	@VisitDesc(hidden=true)
	public void recoverDelStatus(HttpServletRequest request, HttpServletResponse response, String salesmanCode) throws GeneralException {
		try {
			
			salesmanService.recoverDelStatus(salesmanCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("重置操作异常，传入参数为：" + salesmanCode, e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	private void outPut(HttpServletResponse response, JSONArray result) throws IOException {
		response.reset();
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter writer;
		writer = response.getWriter();
		writer.write(result.toString());
		writer.flush();
	}
	
	@RequestMapping("/queryHisHr")
	@VisitDesc(label="查询HR人员入职记录",actionType=4)
	public void queryHisHr(HttpServletRequest request, HttpServletResponse response, FormDto dto, String salesmanCode) throws ServiceException {
		PageDto pageDto = new PageDto();
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("salesmanCode", salesmanCode);
		try {
			pageDto.setRows(salesmanService.querySalesmanHisHr(paraMap));
		} catch (Exception e) {
			throw new ServiceException("分页查询操作异常，传入参数为：" + JSON.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	//查询加入团队时间，离开团队时间，考核时间记录
	@RequestMapping("/querySalesmanRecord")
	@VisitDesc(label="查询更改后的记录",actionType=4)
	public void querySalesmanRecord(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = salesmanService.querySalesmanRecord(pageDto);
			
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

}
