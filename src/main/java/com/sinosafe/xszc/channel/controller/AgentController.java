package com.sinosafe.xszc.channel.controller;

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
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.channel.service.AgentService;
import com.sinosafe.xszc.channel.vo.ChannelAgentDetail;
import com.sinosafe.xszc.channel.vo.ChannelMain;
import com.sinosafe.xszc.channel.vo.ChannelMediumContact;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.ReflectMatch;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/agent")
public class AgentController {

	private static final Log log = LogFactory.getLog(AgentController.class);
	
	@Autowired
	@Qualifier("AgentService")
	private AgentService agentService;

	@Autowired 
	@Qualifier(value = "umService") 
	private UmService umService;
	
	@Autowired
	@Qualifier("NoticeService")
	private NoticeService noticeService;

	/**
	 * 代理人列表展示及自定义查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryAgent")
	@VisitDesc(label=" 代理人列表展示及自定义查询",actionType=4)
	public void queryAgent(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String deptCode = (String) paramMap.get("deptCode");
		if(deptCode == null || "".equals(deptCode)){
			String userCode = CurrentUser.getUser().getUserCode();
			//查询出登录用户的所属机构编码
			List<Map<String, Object>> roleCodeList = umService.findDeptListByUserCode(userCode);
			deptCode = (String) roleCodeList.get(0).get("deptCode");
			if(!"00".equals(deptCode)){//如果不属于总公司
				paramMap.put("deptCode", deptCode);
			}
		}else if("00".equals(deptCode)){
			paramMap.put("deptCode", "");
		}
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		
		//业务线
		List<String> subBusinessLines = noticeService.filterSubBusinessLines();
		pageDto.getWhereMap().put("nrl",subBusinessLines);
		try {
			pageDto = agentService.findAgentByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 代理人详情及修改时数据查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryAgents")
	@VisitDesc(label="代理人详情及修改时数据查询",actionType=4)
	public void queryAgents(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = agentService.findAgentsByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	/**
	 * 个人代理人保存
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@RequestMapping("/saveAgent")
	@VisitDesc(label="个人代理人保存",actionType=3)
	public void saveAgent(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		Map<String, Object> paramMap = dto.getFormMap();
		String currentUser = CurrentUser.getUser().getUserCode();
//		String invoiceType = request.getParameter("invoiceType");
		
		ReflectMatch rm = new ReflectMatch();
		ChannelMain channelMain = new ChannelMain();
//		if(invoiceType.equals("2")){
//			channelMain.setInvoiceType("1");
//		}
		rm.setValue(channelMain, paramMap);
		channelMain.setChannelFlag("1");//代理人标识
		channelMain.setCreatedUser(currentUser);
		channelMain.setUpdatedUser(currentUser);
		channelMain.setStatus("1");
		channelMain.setValidInd("1");
		
		ReflectMatch rm1 = new ReflectMatch();
		ChannelAgentDetail channelAgentDetail = new ChannelAgentDetail();
		rm1.setValue(channelAgentDetail, paramMap);
		channelAgentDetail.setCreatedUser(currentUser);
		channelAgentDetail.setUpdatedUser(currentUser);
		channelAgentDetail.setStatus("1");
		channelAgentDetail.setValidInd("1");
		
		// 接收联系人列表信息
		String agentContectJsonStr = request.getParameter("agentContectJsonStr");
		List<ChannelMediumContact> contactList = JSONArray.parseArray(agentContectJsonStr, ChannelMediumContact.class);
		channelAgentDetail.setChannelMediumContact(contactList);

		//附件ID
		String uploadId = request.getParameter("uploadId");
		
		try {
			agentService.saveAgent(channelMain,channelAgentDetail,uploadId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 个人代理人修改
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@RequestMapping("/updateAgent")
	@VisitDesc(label="个人代理人修改",actionType=3)
	public void updateAgent(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		Map<String, Object> paramMap = dto.getFormMap();
		String currentUser = CurrentUser.getUser().getUserCode();
		
		ReflectMatch rm = new ReflectMatch();
		ChannelMain channelMain = new ChannelMain();
		rm.setValue(channelMain, paramMap);
		channelMain.setUpdatedUser(currentUser);
		
		ReflectMatch rm1 = new ReflectMatch();
		ChannelAgentDetail channelAgentDetail = new ChannelAgentDetail();
		rm1.setValue(channelAgentDetail, paramMap);
		channelAgentDetail.setUpdatedUser(currentUser);
		
		//接收联系人列表信息
		String agentContectJsonStr = request.getParameter("agentContectJsonStr");
	    List<ChannelMediumContact> contactList = JSONArray.parseArray(agentContectJsonStr, ChannelMediumContact.class);
		channelAgentDetail.setChannelMediumContact(contactList);

		//附件ID
		String uploadId = request.getParameter("uploadId");
		
		try {
			agentService.updateAgent(paramMap,channelMain,channelAgentDetail,uploadId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 个人代理人编码校验（停用）
	 * @param request
	 * @param response
	 * @param channelCodeformMap
	 * @throws GeneralException
	 */
	@RequestMapping("/queryChannelCode")
	@VisitDesc(label="个人代理人编码校验（停用）",actionType=4)
	public void queryChannelCode(HttpServletRequest request, HttpServletResponse response, String channelCodeformMap) throws GeneralException {
		try {
			Boolean bool = agentService.queryChannelCode(channelCodeformMap);
			request.setCharacterEncoding("utf-8");
	    	response.reset();
	        response.setCharacterEncoding("utf-8");
	        response.setContentType("text/html; charset=UTF-8");
	        PrintWriter writer = response.getWriter();
			writer.write(Boolean.toString(!bool));
	        writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + channelCodeformMap, e);
		}
	}
	
	/**
	 * 个人代理人删除
	 * @param request
	 * @param response
	 * @param channelCode
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteChannelAgents")
	@VisitDesc(label="个人代理人删除",actionType=2)
	public void deleteChannelAgents(HttpServletRequest request, HttpServletResponse response, String channelCode) throws GeneralException {
		try {
			agentService.deleteChannelAgents(channelCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + channelCode, e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	/**
	 * 获取中介机构管理-新增、维护的业务线
	 * @param response
	 */
	@RequestMapping("/getAgentEditBusinessline")
	public void getAgentEditBusinessline(HttpServletResponse response,String channelCode) {
		List<String> subBusinessLines = noticeService.filterSubBusinessLines();
		//查询当前维护数据的业务线
		if(channelCode!=null){
			Map<String, Object> paramMap = new HashMap<String,Object>();
			paramMap.put("channelCode", channelCode);
			PageDto pageDto = new PageDto();
			pageDto.setWhereMap(paramMap);
			pageDto = agentService.findAgentsByWhere(pageDto);
			subBusinessLines.add((String)pageDto.getRows().get(0).get("businessLine"));
		}
		List<Map<String,String>> businessLine = noticeService.getBusinessLineInfo(subBusinessLines);
		Map<String,String> pleaseInput = new HashMap<String,String>();
		pleaseInput.put("value","");
		pleaseInput.put("text","请选择");
		businessLine.add(0,pleaseInput);
		SendUtil.sendJSON(response,businessLine);
	}
	
	/**
	 * 获取个人代理人-查询列表的业务线
	 * @param response
	 */
	@RequestMapping("/getAgentQueryBusinessline")
	public void getAgentQueryBusinessline(HttpServletResponse response) {
		List<String> subBusinessLines = noticeService.filterSubBusinessLines();
		List<Map<String,String>> businessLine = new ArrayList<Map<String,String>>();
		Map<String,String> pleaseInput = new HashMap<String,String>();
		pleaseInput.put("value","");
		pleaseInput.put("text","请选择");
		businessLine.add(pleaseInput);
		businessLine.addAll(noticeService.queryBusinessline(subBusinessLines));
		SendUtil.sendJSON(response,businessLine);
	}
	
	/**
	 * 资格证号管控
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@RequestMapping("/queryChannelLicenseValid")
	@VisitDesc(label="查询资格证号管控",actionType=4)
	public void queryChannelLicenseValid(HttpServletRequest request, HttpServletResponse response){
		
		List<Map<String, Object>> list = umService.findDeptListByUserCode(CurrentUser.getUser().getUserCode());
		String deptCode = (String)list.get(0).get("deptCode");
		
		SendUtil.sendJSON(response, agentService.queryChannelLicenseValid(deptCode));
		
	}
}
