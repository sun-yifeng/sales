package com.sinosafe.xszc.channel.controller;

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

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.channel.service.MediumNodeService;
import com.sinosafe.xszc.channel.vo.ChannelMediumMaintain;
import com.sinosafe.xszc.channel.vo.ChannelMediumNode;
import com.sinosafe.xszc.channel.vo.ChannelMediumNodeAccount;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/mediumNode")
public class MediumNodeController {

	private static final Log log = LogFactory.getLog(MediumNodeController.class);

	@Autowired
	@Qualifier("MediumNodeService")
	private MediumNodeService mediumNodeService;
	
	@Autowired 
	@Qualifier(value = "umService") 
	private UmService umService;
	
	@Autowired
	@Qualifier("NoticeService")
	private NoticeService noticeService;


	/**
	 * 远程出单点列表及自定义查询
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediumNode")
	@VisitDesc(label="中介机构历史轨迹详情",actionType=4)
	public void queryMediumNode(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
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
			pageDto = mediumNodeService.findMediumNodeByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 远程出单点详情及修改时数据查询
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryMediumNodes")
	@VisitDesc(label="远程出单点详情及修改时数据查询",actionType=4)
	public void queryMediumNodes(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		PageDto pageDto = new PageDto();
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumNodeService.findMediumNodesByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	/**
	 * 远程出单点保存
	 * 
	 * @param request
	 * @param response
	 * @param mediumNode
	 * @throws GeneralException
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@RequestMapping("/saveMediumNode")
	@VisitDesc(label="远程出单点保存",actionType=4)
	public void saveMediumNode(HttpServletRequest request, HttpServletResponse response, ChannelMediumNode mediumNode) throws GeneralException,
			JsonParseException, JsonMappingException, IOException {
		// 接收出单账号列表信息
		Map<String, String> resultMap = new HashMap<String, String>();
		String jsonDataStrAccount = request.getParameter("jsonDataStrAccount");
		log.debug("接收出单账号列表信息:\n" + jsonDataStrAccount);
		int bngInd = jsonDataStrAccount.lastIndexOf("[");
		int endInd = jsonDataStrAccount.lastIndexOf("]");
		// 获取JSON中的rows中的有效数据
		jsonDataStrAccount = jsonDataStrAccount.substring(bngInd, endInd + 1);
		ObjectMapper objectMapperAccount = new ObjectMapper();
		ChannelMediumNodeAccount[] channelMediumNodeAccount = objectMapperAccount.readValue(jsonDataStrAccount, ChannelMediumNodeAccount[].class);
		Set<ChannelMediumNodeAccount> channelMediumNodeAccounts = new HashSet<ChannelMediumNodeAccount>();
		for (int i = 0; i < channelMediumNodeAccount.length; i++) {
			channelMediumNodeAccounts.add(channelMediumNodeAccount[i]);
		}
		mediumNode.setChannelMediumNodeAccount(channelMediumNodeAccounts);

		// 接收维护人列表信息
		String jsonDataStrMaintain = request.getParameter("jsonDataStrMaintain");
		log.debug("接收维护人列表信息:\n" + jsonDataStrMaintain);
		int beginIndex = jsonDataStrMaintain.lastIndexOf("[");
		int endIndex = jsonDataStrMaintain.lastIndexOf("]");
		// 获取JSON中的rows中的有效数据
		jsonDataStrMaintain = jsonDataStrMaintain.substring(beginIndex, endIndex + 1);
		ObjectMapper objectMapperMaintain = new ObjectMapper();
		ChannelMediumMaintain[] channelMaintain = objectMapperMaintain.readValue(jsonDataStrMaintain, ChannelMediumMaintain[].class);
		Set<ChannelMediumMaintain> channelMaintains = new HashSet<ChannelMediumMaintain>();
		for (int i = 0; i < channelMaintain.length; i++) {
			channelMaintains.add(channelMaintain[i]);
		}
		mediumNode.setChannelMediumMaintain(channelMaintains);

		mediumNode.setCreatedUser(CurrentUser.getUser().getUserCode());
		mediumNode.setUpdatedUser(CurrentUser.getUser().getUserCode());
		mediumNode.setValidInd("1");
		try {
			resultMap = mediumNodeService.saveMediumNode(mediumNode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(mediumNode), e);
		}
		SendUtil.sendJSON(response, resultMap);
	}

	/**
	 * 远程出单点修改
	 * 
	 * @param request
	 * @param response
	 * @param mediumNode
	 * @throws GeneralException
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@RequestMapping("/updateMediumNode")
	@VisitDesc(label="远程出单点修改",actionType=4)
	public void updateMediumNode(HttpServletRequest request, HttpServletResponse response, ChannelMediumNode mediumNode)
			throws GeneralException, JsonParseException, JsonMappingException, IOException {
		// 接收出单账号列表信息
		Map<String, String> resultMap = new HashMap<String, String>();
		String jsonDataStrAccount = request.getParameter("jsonDataStrAccount");
		int bngInd = jsonDataStrAccount.lastIndexOf("[");
		int endInd = jsonDataStrAccount.lastIndexOf("]");
		// 获取JSON中的rows中的有效数据
		jsonDataStrAccount = jsonDataStrAccount.substring(bngInd, endInd + 1);
		log.debug("接收出单账号列表信息:\n" + jsonDataStrAccount);
		ObjectMapper accountObjectMapper = new ObjectMapper();
		ChannelMediumNodeAccount[] channelMediumNodeAccount = accountObjectMapper.readValue(jsonDataStrAccount, ChannelMediumNodeAccount[].class);
		Set<ChannelMediumNodeAccount> channelMediumNodeAccounts = new HashSet<ChannelMediumNodeAccount>();
		for (int i = 0; i < channelMediumNodeAccount.length; i++) {
			channelMediumNodeAccounts.add(channelMediumNodeAccount[i]);
		}
		mediumNode.setChannelMediumNodeAccount(channelMediumNodeAccounts);

		// 接收维护人列表信息
		String jsonDataStrMaintain = request.getParameter("jsonDataStrMaintain");
		log.debug("接收维护人列表信息:\n" + jsonDataStrMaintain);
		int beginIndex = jsonDataStrMaintain.lastIndexOf("[");
		int endIndex = jsonDataStrMaintain.lastIndexOf("]");
		// 获取JSON中的rows中的有效数据
		jsonDataStrMaintain = jsonDataStrMaintain.substring(beginIndex, endIndex + 1);
		ObjectMapper objectMapper = new ObjectMapper();
		ChannelMediumMaintain[] channelMaintain = objectMapper.readValue(jsonDataStrMaintain, ChannelMediumMaintain[].class);
		Set<ChannelMediumMaintain> channelMaintains = new HashSet<ChannelMediumMaintain>();
		for (int i = 0; i < channelMaintain.length; i++) {
			channelMaintains.add(channelMaintain[i]);
		}
		mediumNode.setChannelMediumMaintain(channelMaintains);
		
		mediumNode.setUpdatedUser(CurrentUser.getUser().getUserCode());
		try {
			resultMap = mediumNodeService.updateMediumNode(mediumNode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(mediumNode), e);
		}
		SendUtil.sendJSON(response, resultMap);
	}

	/**
	 * 远程出单点编码校验
	 * 
	 * @param request
	 * @param response
	 * @param nodeCode
	 * @throws GeneralException
	 */
	@RequestMapping("/queryNodeCode")
	@VisitDesc(label="远程出单点编码校验",actionType=4)
	public void queryNodeCode(HttpServletRequest request, HttpServletResponse response, String nodeCode) throws GeneralException {
		try {
			Boolean bool = mediumNodeService.queryChannelCode(nodeCode);
			request.setCharacterEncoding("utf-8");
			response.reset();
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = response.getWriter();
			writer.write(Boolean.toString(!bool));
			writer.flush();
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + nodeCode, e);
		}
	}

	/**
	 * 远程出单点出单账号信息列表展示
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryChannelMediumNodeAccount")
	@VisitDesc(label="远程出单点出单账号信息列表展示",actionType=4)
	public void queryChannelMediumNodeAccount(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		String queryFlag = paramMap.get("queryFlag").toString();
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = mediumNodeService.findMediumNodeAccountByWhere(pageDto);
			if (pageDto.getRows().size() > 0) {
				for (int i = 0; i < pageDto.getRows().size(); i++) {
					if (pageDto.getRows().get(i).get("salesmanCname") == null || "".equals(pageDto.getRows().get(i).get("salesmanCname"))) {
						break;
					} else {
						String salesmanCname = pageDto.getRows().get(i).get("salesmanCname").toString();
						// 如果是详情页面查询，则将人员名称赋值给人员代码字段显示
						if (queryFlag.equals("yes")) {
							pageDto.getRows().get(i).put("issuingerCode", salesmanCname);
						}
						// 使用完名称后去掉该列，否则修改保存的时候会报多余salesmanCname异常
						pageDto.getRows().get(i).remove("salesmanCname");
					}
				}
			}
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 根据本门编码查询HR人员(人员代码和名称)
	 * 
	 * @param request
	 * @param response
	 * @param deptCode
	 * @throws GeneralException
	 */
	@RequestMapping("/queryDeptSalesman")
	@VisitDesc(label="根据本门编码查询HR人员(人员代码和名称)",actionType=4)
	public void queryDeptSalesman(HttpServletRequest request, HttpServletResponse response, String deptCode) throws GeneralException {
		Map<String, Object> userMap = new HashMap<String, Object>();
		userMap.put("deptCode", deptCode);
		List<Map<String, Object>> resList = (List<Map<String, Object>>) mediumNodeService.queryDeptSalesman(userMap);
		JSONArray result = new JSONArray();
		try {
			if (resList.size() > 0) {
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildUser(resList.get(i).get("salesmanCode").toString(), resList.get(i).get("salesmanCname").toString()));
				}
			} else {
				result.add(buildUser("", "该部门中暂无人员！"));
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
	 * 根据本门编码查询HR人员(人员工号和名称)
	 * 
	 * @param request
	 * @param response
	 * @param deptCode
	 * @throws GeneralException
	 */
	@RequestMapping("/querySalesmanEmpCode")
	@VisitDesc(label="根据本门编码查询HR人员(人员工号和名称)",actionType=4)
	public void querySalesmanEmpCode(HttpServletRequest request, HttpServletResponse response, String deptCode, String salesmanType)
			throws GeneralException {
		Map<String, Object> userMap = new HashMap<String, Object>();
		userMap.put("deptCode", deptCode);
		userMap.put("salesmanType", salesmanType);
		List<Map<String, Object>> resList = (List<Map<String, Object>>) mediumNodeService.querySalesmanEmpCode(userMap);
		JSONArray result = new JSONArray();
		try {
			if (resList != null && resList.size() > 0) {
				for (int i = 0; i < resList.size(); i++) {
					if(resList.get(i).get("employCode") != null && resList.get(i).get("salesmanCname")!=null){
						result.add(buildUser(resList.get(i).get("employCode").toString(), resList.get(i).get("salesmanCname").toString()));	
					}
				}
			} else {
				if("1".equals(salesmanType)){
					result.add(buildUser("", "暂无我司人员！"));
				} else if("0".equals(salesmanType)){
					result.add(buildUser("", "暂无非HR人员！"));
				} else {
					//
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

	/**
	 * 根据本门编码查询非HR人员(人员代码和名称)
	 * 
	 * @param request
	 * @param response
	 * @param deptCode
	 * @throws GeneralException
	 */
	@RequestMapping("/queryDeptVirSalesman")
	@VisitDesc(label="根据本门编码查询非HR人员(人员代码和名称)",actionType=4)
	public void queryDeptVirSalesman(HttpServletRequest request, HttpServletResponse response, String deptCode) throws GeneralException {
		Map<String, Object> userMap = new HashMap<String, Object>();
		userMap.put("deptCode", deptCode);
		List<Map<String, Object>> resList = (List<Map<String, Object>>) mediumNodeService.queryDeptVirSalesman(userMap);
		JSONArray result = new JSONArray();
		try {
			if (resList.size() > 0) {
				for (int i = 0; i < resList.size(); i++) {
					if(resList.get(i).get("employCode") != null && resList.get(i).get("cname") != null){
						result.add(buildUser(resList.get(i).get("employCode").toString(), resList.get(i).get("cname").toString()));
					}
				}
			} else {
				result.add(buildUser("", "该部门中暂无人员！"));
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
	 * 根据本门编码查询HR与非HR人员(人员代码和名称)
	 * 
	 * @param request
	 * @param response
	 * @param deptCode
	 * @throws GeneralException
	 */
	@RequestMapping("/queryAllSalesmans")
	@VisitDesc(label="根据本门编码查询HR与非HR人员(人员代码和名称)",actionType=4)
	public void queryAllSalesmans(HttpServletRequest request, HttpServletResponse response, String deptCode) throws GeneralException {
		Map<String, Object> userMap = new HashMap<String, Object>();
		userMap.put("deptCode", deptCode);
		List<Map<String, Object>> resList = (List<Map<String, Object>>) mediumNodeService.queryAllSalesmans(userMap);
		JSONArray result = new JSONArray();
		try {
			if (resList.size() > 0) {
				for (int i = 0; i < resList.size(); i++) {
					if(resList.get(i).get("employCode") != null && resList.get(i).get("cname") !=null){
						result.add(buildUser(resList.get(i).get("employCode").toString(), resList.get(i).get("cname").toString()));
					}
				}
			} else {
				result.add(buildUser("", "该部门中暂无人员！"));
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
	 * 拼装JSON字符串
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
	 * 远程出单点删除
	 * 
	 * @param request
	 * @param response
	 * @param nodeCode
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteMediumNode")
	@VisitDesc(label="远程出单点删除",actionType=2)
	public void deleteMediumNode(HttpServletRequest request, HttpServletResponse response, String nodeCode, String channelCode)
			throws GeneralException {
		try {
			mediumNodeService.deleteMediumNode(nodeCode, channelCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + nodeCode, e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	/**
	 * 关停出单点
	 * 
	 * @param request
	 * @param response
	 * @param nodeCode
	 * @throws GeneralException
	 */
	@RequestMapping("/closeMediumNode")
	@VisitDesc(label="关停出单点",actionType=3)
	public void closeMediumNode(HttpServletRequest request, HttpServletResponse response, String nodeCode, String channelCode)
			throws GeneralException {
		try {
			mediumNodeService.closeMediumNode(nodeCode, channelCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("操作异常，传入参数为：" + nodeCode, e);
		}
		SendUtil.sendJSON(response, "success");
	}
}
