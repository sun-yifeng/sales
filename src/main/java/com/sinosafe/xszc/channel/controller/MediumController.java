package com.sinosafe.xszc.channel.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.channel.service.MediumService;
import com.sinosafe.xszc.channel.vo.ChannelMain;
import com.sinosafe.xszc.channel.vo.ChannelMediumContact;
import com.sinosafe.xszc.channel.vo.ChannelMediumDetail;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.ReflectMatch;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/medium")
public class MediumController {

	private static final Log log = LogFactory.getLog(MediumController.class);
	
	@Autowired
	@Qualifier("MediumService")
	private MediumService mediumService;
	
	@Autowired 
	@Qualifier(value = "umService") 
	private UmService umService;
	
	@Autowired
	@Qualifier("NoticeService")
	private NoticeService noticeService;

	/**
	 * <pre>
	 * 方法queryMedium的详细说明 <br>
	 * 此方法用于初始化中介机构渠道列表数据和自定义查询
	 * 编写者：黄思凯
	 * 创建时间：2014年6月10日
	 * </pre>
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMedium")
	@VisitDesc(label="初始化中介机构渠道列表数据和自定义查询",actionType=4)
	public void queryMedium(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
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
			pageDto = mediumService.findMediumByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 中介机构详情和修改中介机构时数据查询
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediums")
	@VisitDesc(label="介机构详情和修改中介机构时数据查询",actionType=4)
	public void queryMediums(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumService.findMediumsByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	/**
	 * 中介机构保存
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@RequestMapping("/saveMedium")
	@VisitDesc(label="中介机构保存",actionType=1)
	public void saveMedium(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		Map<String, Object> paramMap = dto.getFormMap();
		String currentUser = CurrentUser.getUser().getUserCode();
		String invoiceType = request.getParameter("invoiceType");
		
		ReflectMatch rm = new ReflectMatch();
		ChannelMain channelMain = new ChannelMain();
		if(invoiceType.equals("2")){
			channelMain.setInvoiceType("1");
		}
		rm.setValue(channelMain, paramMap);
		channelMain.setChannelFlag("0");//中介机构标识
		channelMain.setCreatedUser(currentUser);
		channelMain.setUpdatedUser(currentUser);
		channelMain.setStatus("1");
		channelMain.setValidInd("1");
		
		ReflectMatch rm1 = new ReflectMatch();
		ChannelMediumDetail channelMediumDetail = new ChannelMediumDetail();
		rm1.setValue(channelMediumDetail, paramMap);
		channelMediumDetail.setCreatedUser(currentUser);
		channelMediumDetail.setUpdatedUser(currentUser);
		channelMediumDetail.setStatus("1");
		channelMediumDetail.setValidInd("1");
		
		//接收联系人列表信息
		String jsonData = request.getParameter("mediumContectJsonStr");
		int beginIndex = jsonData.lastIndexOf("[");
		int endIndex = jsonData.lastIndexOf("]");
		//获取json中的rows中的有效数据
		jsonData = jsonData.substring(beginIndex, endIndex+1);
		ObjectMapper objectMapper = new ObjectMapper();
		ChannelMediumContact[] channelMediumContact = objectMapper.readValue(jsonData, ChannelMediumContact[].class);
		Set<ChannelMediumContact> channelMediumContacts = new HashSet<ChannelMediumContact>();
		for(int i = 0 ; i < channelMediumContact.length ; i++){
			channelMediumContacts.add(channelMediumContact[i]);
		}
		channelMediumDetail.setChannelMediumContact(channelMediumContacts);
		
		//附件ID
		String uploadId = request.getParameter("uploadId");
		
		try {
			mediumService.saveMedium(channelMain,channelMediumDetail,uploadId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	/**
	 * 中介机构修改保存
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@RequestMapping("/updateMedium")
	@VisitDesc(label="中介机构修改",actionType=3)
	public void updateMedium(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		String invoiceType = request.getParameter("invoiceType");
		Map<String, Object> paramMap = dto.getFormMap();
		String currentUser = CurrentUser.getUser().getUserCode();
		
		ReflectMatch rm = new ReflectMatch();
		ChannelMain channelMain = new ChannelMain();
		if(invoiceType.equals("2")){
			channelMain.setInvoiceType("1");
		}
		rm.setValue(channelMain, paramMap);
		channelMain.setUpdatedUser(currentUser);
		
		ReflectMatch rm1 = new ReflectMatch();
		ChannelMediumDetail channelMediumDetail = new ChannelMediumDetail();
		rm1.setValue(channelMediumDetail, paramMap);
		channelMediumDetail.setUpdatedUser(currentUser);
		channelMediumDetail.setProcessDeptCode(channelMain.getDeptCode()); //经办机构
		
		//接收联系人列表信息
		String jsonData = request.getParameter("mediumContectJsonStr");
		int beginIndex = jsonData.lastIndexOf("[");
		int endIndex = jsonData.lastIndexOf("]");
		//获取json中的rows中的有效数据
		jsonData = jsonData.substring(beginIndex, endIndex+1);
		ObjectMapper objectMapper = new ObjectMapper();
		ChannelMediumContact[] channelMediumContact = objectMapper.readValue(jsonData, ChannelMediumContact[].class);
		Set<ChannelMediumContact> channelMediumContacts = new HashSet<ChannelMediumContact>();
		for(int i = 0 ; i < channelMediumContact.length ; i++){
			channelMediumContacts.add(channelMediumContact[i]);
		}
		channelMediumDetail.setChannelMediumContact(channelMediumContacts);

		//附件ID
		String uploadId = request.getParameter("uploadId");
		
		try {
			mediumService.updateMedium(paramMap,channelMain,channelMediumDetail,uploadId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(paramMap), e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	/**
	 * 管理办法->成本调整系数模块
	 * 根据所选的机构编码查询相关所有渠道
	 * @param response
	 * @param deptCode
	 */
	@RequestMapping("/queryParentMedium")
	@VisitDesc(label="中介机构修改",actionType=3)
	public void queryParentMedium(HttpServletResponse response,String deptCode) {
		List<Map<String,Object>> resList = mediumService.queryParentMedium(deptCode);
		JSONArray result = new JSONArray();
		result.add(buildJson("","请选择"));
		try {
			for (int i = 0; i < resList.size(); i++) {
				result.add(buildJson(resList.get(i).get("channelCode").toString(), resList.get(i).get("mediumCname").toString()));
			}
			response.reset();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer;
			writer = response.getWriter();
			writer.write(result.toString());
			writer.flush();
		}catch(IOException e) {
			log.debug("查询上级中介机构错误！！");
			e.printStackTrace();
		}
	}
	
	/**
	 * 查询上级渠道
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryParentChannel")
	@VisitDesc(label="查询上级渠道",actionType=4)
	public void queryParentChannel(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumService.queryParentChannel(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 渠道编码校验（停用）
	 * @param request
	 * @param response
	 * @param channelCodeformMap
	 * @throws GeneralException
	 */
	@RequestMapping("/queryChannelCode")
	@VisitDesc(label="渠道编码校验",actionType=4)
	public void queryChannelCode(HttpServletRequest request, HttpServletResponse response, String channelCodeformMap) throws GeneralException {
		try {
			Boolean bool = mediumService.queryChannelCode(channelCodeformMap);
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
	 * 拼装json字符串
	 * @param id
	 * @param name
	 * @return JSONObject
	 */
	private JSONObject buildJson(String id,String name){
	    JSONObject result=new JSONObject();
	    result.put("value", id);
	    result.put("text", name);
	    return result;
	}
	
	/**
	 * 删除中介机构
	 * @param request
	 * @param response
	 * @param channelCode
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteMediums")
	@VisitDesc(label="删除中介机构",actionType=2)
	public void deleteMediums(HttpServletRequest request, HttpServletResponse response, String channelCode) throws GeneralException {
		try {
			mediumService.deleteMediums(channelCode);
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
	@RequestMapping("/getMediumEditBusinessline")
	public void getMediumEditBusinessline(HttpServletResponse response,String channelCode) {
		List<String> subBusinessLines = noticeService.filterSubBusinessLines();
		//查询当前维护数据的业务线
		if(channelCode!=null){
			Map<String, Object> paramMap = new HashMap<String,Object>();
			paramMap.put("channelCode", channelCode);
			PageDto pageDto = new PageDto();
			pageDto.setWhereMap(paramMap);
			pageDto = mediumService.findMediumsByWhere(pageDto);
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
	 * 获取中介机构管理-查询列表的业务线
	 * @param response
	 */
	@RequestMapping("/getMediumQueryBusinessline")
	public void getMediumQueryBusinessline(HttpServletResponse response){
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
	 * 根据经办机构，查询出经办机构下面的代理机构代码和名称
	 * @param request
	 * @param response
	 * @param dto
	 * @throws ServiceException 
	 */
	@RequestMapping("/queryMediumInfoByDeptCode")
	public void queryMediumInfoByDeptCode(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException{
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumService.queryMediumInfoByDeptCode(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/queryMediumGetSalesman")
	public void queryMediumGetSalesman(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
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
		try {
			pageDto = mediumService.queryChooseMedium(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response,pageDto);
	}
	
}
