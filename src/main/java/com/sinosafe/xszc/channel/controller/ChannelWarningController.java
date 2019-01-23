package com.sinosafe.xszc.channel.controller;

import java.io.IOException;
import java.io.PrintWriter;
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
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.channel.service.ChannelWarningService;
import com.sinosafe.xszc.channel.vo.ChannelWarning;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/channelWarning")
public class ChannelWarningController {

	private static final Log log = LogFactory.getLog(ChannelWarningController.class);

	@Autowired
	@Qualifier("ChannelWarningService")
	private ChannelWarningService channelWarningService;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	/**
	 * 查询所有代理人预警信息
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryChannelWarning")
	public void queryChannelWarning(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String deptCode = (String) paramMap.get("deptCode");
		if (deptCode == null || "".equals(deptCode)) {
			String userCode = CurrentUser.getUser().getUserCode();
			// 查询出登录用户的所属机构编码
			List<Map<String, Object>> roleCodeList = umService.findDeptListByUserCode(userCode);
			deptCode = (String) roleCodeList.get(0).get("deptCode");
			if (!"00".equals(deptCode)) {// 如果不属于总公司
				paramMap.put("deptCode", deptCode);
			}
		} else if ("00".equals(deptCode)) {
			paramMap.put("deptCode", "");
		}
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = channelWarningService.findChannelWarningByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 新增代理人预警
	 * 
	 * @param request
	 * @param response
	 * @param channelWarning
	 * @throws GeneralException
	 */
	@RequestMapping("/saveChannelWarning")
	public void saveChannelWarning(HttpServletRequest request, HttpServletResponse response, ChannelWarning channelWarning) throws GeneralException {
		channelWarning.setWarningId(UUIDGenerator.getUUID());
		channelWarning.setCreatedUser(CurrentUser.getUser().getUserCName());
		channelWarning.setUpdatedUser(CurrentUser.getUser().getUserCode());
		channelWarning.setValidInd("1");
		try {
			channelWarningService.saveChannelWarningAgent(channelWarning);
			;
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(channelWarning), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 查询所有中介机构
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryChannelWarningMedium")
	public void queryChannelWarningMedium(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String deptCode = (String) paramMap.get("deptCode");
		if (deptCode == null || "".equals(deptCode)) {
			String userCode = CurrentUser.getUser().getUserCode();
			// 查询出登录用户的所属机构编码
			List<Map<String, Object>> roleCodeList = umService.findDeptListByUserCode(userCode);
			deptCode = (String) roleCodeList.get(0).get("deptCode");
			if (!"00".equals(deptCode)) {// 如果不属于总公司
				paramMap.put("deptCode", deptCode);
			}
		} else if ("00".equals(deptCode)) {
			paramMap.put("deptCode", "");
		}
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = channelWarningService.findChannelWarningMediumByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/**
	 * 新增中介预警
	 * 
	 * @param request
	 * @param response
	 * @param saleUser
	 * @throws GeneralException
	 */
	@RequestMapping("/saveMediumChannelWarning")
	public void saveMediumChannelWarning(HttpServletRequest request, HttpServletResponse response, ChannelWarning channelWarning) throws GeneralException {
		channelWarning.setWarningId(UUIDGenerator.getUUID());
		channelWarning.setCreatedUser(CurrentUser.getUser().getUserCName());
		channelWarning.setUpdatedUser(CurrentUser.getUser().getUserCode());
		channelWarning.setValidInd("1");
		try {
			channelWarningService.saveChannelWarning(channelWarning);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(channelWarning), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 根据机构部门查询下属代理机构
	 * 
	 * @param pageDto
	 * @return
	 */
	@RequestMapping("/queryDeptMedium")
	public void queryDeptMedium(HttpServletRequest request, HttpServletResponse response, String deptCode) throws GeneralException {
		Map<String, Object> mediumMap = new HashMap<String, Object>();

		mediumMap.put("deptCode", deptCode);
		List<Map<String, Object>> resList = (List<Map<String, Object>>) channelWarningService.queryDeptMedium(mediumMap);
		JSONArray result = new JSONArray();
		try {
			if (resList.size() > 0) {
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildUser(resList.get(i).get("channelCode").toString(), resList.get(i).get("mediumCname").toString()));
				}
			} else {
				result.add(buildUser("", "该渠道部门中暂无代理机构！"));
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
	 * 修改代理人预警
	 * 
	 * @param request
	 * @param response
	 * @param channelWarning
	 * @throws GeneralException
	 */
	@RequestMapping("/updateChannelWarning")
	public void updateChannelWarning(HttpServletRequest request, HttpServletResponse response, ChannelWarning channelWarning) throws GeneralException,
			JsonParseException, JsonMappingException, IOException {
		channelWarning.setUpdatedUser(CurrentUser.getUser().getUserCode());
		channelWarning.setValidInd("1");
		try {
			channelWarningService.updateChannelWarning(channelWarning);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(channelWarning), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 修改中介预警
	 * 
	 * @param request
	 * @param response
	 * @param channelWarning
	 * @throws GeneralException
	 */
	@RequestMapping("/updateMediumChannelWarning")
	public void updateChannelWarningMedium(HttpServletRequest request, HttpServletResponse response, ChannelWarning channelWarning) throws GeneralException,
			JsonParseException, JsonMappingException, IOException {
		channelWarning.setUpdatedUser(CurrentUser.getUser().getUserCode());
		channelWarning.setValidInd("1");
		try {
			channelWarningService.updateChannelWarning(channelWarning);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(channelWarning), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 删除代理人预警信息
	 * 
	 * @param request
	 * @param response
	 * @param warningId
	 * @throws GeneralException
	 */
	@RequestMapping("/deleteChannelWarning")
	public void deleteChannelWarning(HttpServletRequest request, HttpServletResponse response, String warningId) throws GeneralException, JsonParseException,
			JsonMappingException, IOException {
		ChannelWarning channelWarning = new ChannelWarning();
		channelWarning.setUpdatedUser(CurrentUser.getUser().getUserCode());
		channelWarning.setWarningId(warningId);
		try {
			channelWarningService.deleteChannelWarning(channelWarning);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(channelWarning), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 查看代理人预警详情
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryAgentWarningDetail")
	public void queryAgentWarningDetail(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = channelWarningService.findChannelWarningsByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	/**
	 * 查看中介预警详情
	 * 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryAgentWarningByWhere")
	public void queryAgentWarningByWhere(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = channelWarningService.findChannelWarningsMediumByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto.getRows());
	}

	/**
	 * 根据机构部门查询下属所有代理人
	 * 
	 * @param pageDto
	 * @return
	 */
	@RequestMapping("/queryDeptAgent")
	public void queryDeptAgent(HttpServletRequest request, HttpServletResponse response, String deptCode) throws GeneralException {
		Map<String, Object> userMap = new HashMap<String, Object>();

		userMap.put("deptCode", deptCode);
		List<Map<String, Object>> resList = (List<Map<String, Object>>) channelWarningService.queryDeptAgent(userMap);
		JSONArray result = new JSONArray();
		try {
			if (resList.size() > 0) {
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildUser(resList.get(i).get("channelCode").toString(), resList.get(i).get("channelName").toString()));
				}
			} else {
				result.add(buildUser("", "该渠道部门中暂无代理人！"));
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

}
