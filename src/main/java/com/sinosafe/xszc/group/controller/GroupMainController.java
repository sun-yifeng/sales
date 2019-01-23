package com.sinosafe.xszc.group.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
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
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.constant.Constant;
import com.sinosafe.xszc.group.service.GroupMainService;
import com.sinosafe.xszc.group.service.SalesmanService;
import com.sinosafe.xszc.group.vo.GroupMain;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/groupMain")
public class GroupMainController {

	private static final Log log = LogFactory.getLog(GroupMainController.class);

	@Autowired
	@Qualifier("GroupMainService")
	private GroupMainService groupMainService;

	@Autowired
	@Qualifier("SalesmanService")
	private SalesmanService salesmanService;
	
	@Autowired
	@Qualifier("NoticeService")
	private NoticeService noticeService;

	/**
	 * 查询所有团队
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryGroupMain")
	@VisitDesc(label="查询所有团队",actionType=4)
	public void queryGroupMain(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		//业务线（团队类型）,2016年不分业务线，废除自行代码
		//pageDto.getWhereMap().put("nrl",getGroupBusinessLine());
		try {
			pageDto = groupMainService.findGroupMainByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 获取所属业务线（团队类型）
	 * @return
	 */
	public List<String> getGroupBusinessLine(){
		
		List<String> businessLine = new ArrayList<String>();
		List<String> subBusinessLines = noticeService.filterSubBusinessLines();
		for(String sbl:subBusinessLines){
			for(String[] gt:Constant.groupType){
				if(sbl.equals("92500"+gt[0])){
					businessLine.add(gt[0]);
				}
			}
		}
		
		return businessLine;
	}

	
	

	/**
	 * 团队新增
	 * 
	 * @param request
	 * @param response
	 * @param groupMain
	 * @throws GeneralException
	 */
	@RequestMapping("/saveGroupMain")
	@VisitDesc(label="团队新增",actionType=1)
	public void saveGroupMain(HttpServletRequest request, HttpServletResponse response, GroupMain groupMain) throws GeneralException {
		groupMain.setCreatedUser(CurrentUser.getUser().getUserCode());
		groupMain.setUpdatedUser(CurrentUser.getUser().getUserCode());
		groupMain.setStatus("0");
		groupMain.setValidInd("1");
		Long maxNum = groupMainService.findGroupMainByCount(groupMain);
		// 生成团队代码
		if (maxNum == null || maxNum == 0) {
			groupMain.setGroupCode(groupMain.getDeptCode() + "000" + 1);
		} else if (maxNum < 10) {
			groupMain.setGroupCode(groupMain.getDeptCode() + "000" + maxNum);
		} else if (maxNum < 100 && maxNum > 10) {
			groupMain.setGroupCode(groupMain.getDeptCode() + "00" + maxNum);
		} else if (maxNum < 1000 && maxNum > 100) {
			groupMain.setGroupCode(groupMain.getDeptCode() + "0" + maxNum);
		} else {
			groupMain.setGroupCode(groupMain.getDeptCode() + maxNum);
		}
		try {
			groupMainService.saveGroupMain(groupMain);

		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(groupMain), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 团队修改
	 * 
	 * @param request
	 * @param response
	 * @param groupMain
	 * @throws GeneralException
	 */
	@RequestMapping("/updateGroupMain")
	@VisitDesc(label="团队修改",actionType=3)
	public void updateGroupMain(HttpServletRequest request, HttpServletResponse response, GroupMain groupMain) throws GeneralException {
		groupMain.setUpdatedUser(CurrentUser.getUser().getUserCode());
		groupMain.setHistoryId(UUIDGenerator.getUUID());
		try {
			groupMainService.updateGroupMain(groupMain);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(groupMain), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 查询单条数据的详细
	 * 
	 * @deprecated
	 */
	@RequestMapping("/queryGroupMains")
	public void queryGroupMains(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		//业务线（团队类型）
		pageDto.getWhereMap().put("nrl",getGroupBusinessLine());
		
		try {
			pageDto = groupMainService.findGroupMainsByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("单条数据查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}
	
	/**
	 * 查询单条数据的详细
	 * 
	 * @deprecated
	 */
	@RequestMapping("/queryGroupMainDetail")
	public void queryGroupMainDetail(HttpServletRequest request,HttpServletResponse response,FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = groupMainService.findGroupMainDetailByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("单条数据查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	/**
	 * 查询团队下的员工
	 * 
	 * @param pageDto
	 * @return
	 */
	@RequestMapping("/queryGroupSalesman")
	@VisitDesc(label="查询团队下的员工",actionType=4)
	public void queryGroupSalesman(HttpServletRequest request, HttpServletResponse response, String groupCode, String salesmanCode)
			throws GeneralException {
		Map<String, Object> userMap = new HashMap<String, Object>();

		userMap.put("groupCode", groupCode);
		userMap.put("salesmanCode", salesmanCode);
		List<Map<String, Object>> resList = (List<Map<String, Object>>) salesmanService.queryGroupSalesman(userMap);
		JSONArray result = new JSONArray();
		try {
			if (resList.size() > 0) {
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildUser(resList.get(i).get("salesmanCode").toString(), resList.get(i).get("salesmanCname").toString()));
				}
			} else {
				result.add(buildUser("", "该团队中暂无人员！"));
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

	/**
	 * 查询四级机构下的团队
	 * 
	 * @param pageDto
	 * @return
	 */
	@RequestMapping("/queryDeptGroup")
	@VisitDesc(label="查询四级机构下的团队",actionType=4)
	public void queryDeptGroup(HttpServletRequest request, HttpServletResponse response, String deptCode) throws GeneralException {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("deptCode", deptCode);
		List<Map<String, Object>> resultList = groupMainService.queryDeptGroup(paraMap);
		if (resultList.size() < 1) {
			resultList.add(buildUser("", "营销服务部下无团队！"));
		}
		SendUtil.sendJSONList(response, resultList);
	}
	@RequestMapping("/getGroupType")
	@VisitDesc(label="查询四级机构下的团队",actionType=4)
	public void getGroupType(HttpServletRequest request, HttpServletResponse response, String deptCode) throws GeneralException {
		String groupType = "";
		String groupCode = request.getParameter("groupCode");
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap.put("groupCode", groupCode);
		groupType = groupMainService.quertGroupType(paraMap);
		paraMap.put("groupType", groupType);
		SendUtil.sendJSON(response, paraMap);
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
	 * 分页查询团队，附加是否设定团队长
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryGroupLeader")
	@VisitDesc(label="查询团队长",actionType=4)
	public void queryGroupLeader(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		//业务线（团队类型）2016年基本法不分业务线
		//pageDto.getWhereMap().put("nrl",getGroupBusinessLine());
		try {
			pageDto = groupMainService.findGroupMainByWheres(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 查询团队名称是否存在
	 * 
	 */
	@RequestMapping("/queryGroupNameCount")
	@VisitDesc(label="查询团队长是否存在",actionType=4)
	public void queryGroupNameCount(HttpServletRequest request, HttpServletResponse response, String groupName, String deptCode,
			String groupCode) throws GeneralException {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("groupName", groupName);
		whereMap.put("deptCode", deptCode);
		whereMap.put("groupCode", groupCode);
		Long maxNum = 1l;
		try {
			maxNum = groupMainService.findGroupNameByCount(whereMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询团队名称时出错!", e);
		}
		SendUtil.sendJSON(response, maxNum);
	}

	@RequestMapping("/queryGroupLeaderCname")
	@VisitDesc(label="查询团队长中文名字",actionType=4)
	public void queryGroupLeaderCname(HttpServletRequest request, HttpServletResponse response, String groupCode) throws GeneralException {
		try {
			PrintWriter printWriter = response.getWriter();
			String groupLeader = groupMainService.findGroupLeaderCname(groupCode);
			printWriter.write(groupLeader);
			printWriter.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询团队长姓名时出错", e);
		}
		// SendUtil.sendJSON(response, maxNum);
	}

	/**
	 * 删除团队信息
	 * @param request
	 * @param response
	 * @param groupCode
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteGroupMain")
	@VisitDesc(label="删除团队长信息",actionType=2)
	public void deleteGroupMain(HttpServletRequest request, HttpServletResponse response, String groupCode) throws GeneralException,
			JsonParseException, JsonMappingException, IOException {
		GroupMain groupMain = new GroupMain();
		groupMain.setUpdatedUser(CurrentUser.getUser().getUserCode());
		groupMain.setGroupCode(groupCode);
		try {
			groupMainService.deleteGroupMain(groupMain);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(groupMain), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 查询团队类型
	 * @param request
	 * @param response
	 */
	@RequestMapping("/queryGroupType")
	public void queryGroupType(HttpServletRequest request, HttpServletResponse response){
		
		List<Map<String, String>> businessLine = new ArrayList<Map<String, String>>();
		Map<String,String> groupTypeMap = null;
		
		groupTypeMap = new HashMap<String,String>();
		groupTypeMap.put("value","");
		groupTypeMap.put("text", "请选择");
		businessLine.add(groupTypeMap);
		
		List<String> subBusinessLines = noticeService.filterSubBusinessLines();
		for(String sbl:subBusinessLines){
			for(String[] gt:Constant.groupType){
				if(sbl.equals("92500"+gt[0])){
					groupTypeMap = new HashMap<String,String>();
					groupTypeMap.put("value", gt[0]);
					groupTypeMap.put("text", gt[1]);
					businessLine.add(groupTypeMap);
				}
			}
		}
		
		SendUtil.sendJSON(response, businessLine);
	}
	
	@RequestMapping("/queryGroupMember")
	public void queryGroupMember(HttpServletRequest request, HttpServletResponse response,FormDto dto) {
		Map<String, Object> paramMap = dto.getFormMap();
		paramMap.put("groupCode", request.getParameter("groupCode"));
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = groupMainService.queryGroupMember(pageDto);
		} catch (Exception e) {
			log.error(e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/queryTrueGroupMember")
	public void queryTrueGroupMember(HttpServletRequest request, HttpServletResponse response,FormDto dto) {
		Map<String, Object> paramMap = dto.getFormMap();
		paramMap.put("groupCode", request.getParameter("groupCode"));
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = groupMainService.queryTrueGroupMember(pageDto);
		} catch (Exception e) {
			log.error(e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/queryGroupMemberDetail")
	public void queryGroupMemberDetail(HttpServletRequest request,HttpServletResponse response,FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String groupCode = request.getParameter("groupCode");
		PageDto pageDto = new PageDto();
		paramMap.put("groupCode", groupCode);
		pageDto.setWhereMap(paramMap);
		try {
			pageDto = groupMainService.queryGroupMemberDetail(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("单条数据查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}
	
	@RequestMapping("/queryGroupFoundDate")
	public void queryGroupFoundDate(HttpServletRequest request,HttpServletResponse response,FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String groupCode = request.getParameter("groupCode");
		PageDto pageDto = new PageDto();
		paramMap.put("groupCode", groupCode);
		pageDto.setWhereMap(paramMap);
		try {
			pageDto = groupMainService.queryGroupMemberDetail(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("单条数据查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows().get(0));
	}
	
}
