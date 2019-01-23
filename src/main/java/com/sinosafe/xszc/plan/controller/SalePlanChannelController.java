package com.sinosafe.xszc.plan.controller;

import java.beans.IntrospectionException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.plan.service.SalePlanChannelService;
import com.sinosafe.xszc.plan.vo.PlanChannelDetail;
import com.sinosafe.xszc.plan.vo.PlanMain;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.ReflectMatch;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/salePlanChannel")
public class SalePlanChannelController {

	private static final Log log = LogFactory.getLog(SalePlanChannelController.class);

	@Autowired
	@Qualifier("SalePlanChannelService")
	private SalePlanChannelService salePlanChannelService;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	/*
	 * 分页查询总数据
	 */
	@RequestMapping("/querySalePlanChannel")
	public void querySalePlanChannel(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDtoMain = new PageDto();
		pageDtoMain.setStart(startStr);
		pageDtoMain.setLimit(limitStr);
		pageDtoMain.setWhereMap(dto.getFormMap());
		try {
			pageDtoMain = salePlanChannelService.findSalePlanChannel(pageDtoMain);
			//pageDtoChannel = salePlanChannelService.findSalePlanChannelByWhere(pageDtoChannel);
		} catch (Exception e) {
			log.error(paramMap);
			e.printStackTrace();
		}
		SendUtil.sendJSON(response, pageDtoMain);
		//SendUtil.sendJSON(response, pageDtoChannel);
	}
    
	/**
	 * TODO 查询所有的专属保费计划<br><pre>
	 * 方法queryAllSalePlanChannel的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月1日 上午10:20:00 </pre>
	 * @param 参数名 说明
	 * @return void 说明
	 * @throws 异常类型 说明
	 */
	@RequestMapping("/queryAllSalePlanChannel")
	public void queryAllSalePlanChannel(HttpServletRequest request,HttpServletResponse response,FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		//如果是总公司
		String dept = (String) pageDto.getWhereMap().get("deptCode");
		if (StringUtils.isBlank(dept)) {
			List<Map<String, Object>> list = umService.findDeptListByUserCode(CurrentUser.getUser().getUserCode());
			if (list != null && list.size() == 1) {
				pageDto.getWhereMap().put("deptCode", list.get(0).get("deptCode").toString());
			}
		}

		try {
			pageDto = salePlanChannelService.queryAllSalePlanChannel(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/*
	 * 根据相关参数子表查询
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/querySalePlanChannelByVo")
	public void querySalePlanChannelByVo(HttpServletRequest request, HttpServletResponse response, String planMainId, String ChannelRiskType)
			throws GeneralException, IntrospectionException, IllegalAccessException, InvocationTargetException {
		PageDto pageDto = new PageDto();
		PlanMain planMain = new PlanMain();
		if (!(planMainId == "" || planMainId.equals("") || planMainId == "undefined" || planMainId.equals("undefined"))) {
			planMain.setPlanMainId(planMainId);
			planMain = salePlanChannelService.querySalePlanChannelByVo(planMain, ChannelRiskType);

			Set<PlanChannelDetail> planChannelDetail = planMain.getPlanChannelDetail();
			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

			Iterator<PlanChannelDetail> it = planChannelDetail.iterator();
			while (it.hasNext()) {
				PlanChannelDetail pcd = it.next();
				list.add(ReflectMatch.convertBean(pcd));
			}
			pageDto.setRows(list);
			pageDto.setTotal((long) list.size());
			response.setContentType("text/html;charset=UTF-8");
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/*
	 * 根据相关参数主表查询
	 */
	@RequestMapping("/queryPlanMainByVo")
	public void queryPlanMainByVo(HttpServletRequest request, HttpServletResponse response, String planMainId) throws GeneralException {
		PlanMain planMain = new PlanMain();
		if (!(planMainId == "" || planMainId.equals("") || planMainId == "undefined" || planMainId.equals("undefined"))) {
			planMain.setPlanMainId(planMainId);
			planMain = salePlanChannelService.queryPlanMainByVo(planMain);
		}
		response.setContentType("text/html;charset=UTF-8");
		SendUtil.sendJSON(response, planMain);
	}

	/*
	 *新增保存数据 
	 */
	@RequestMapping("/saveSalePlanChannel")
	public void saveSalePlanChannel(HttpServletRequest request, HttpServletResponse response, PlanMain planMain, String autoGrid, String propertyGrid,
			String lifeGrid, String spicJsonStr) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		String jsonData = "";
		planMain.setValidInd("1");
		planMain.setStatus("1");
		int beginIndex = spicJsonStr.lastIndexOf("[");
		int endIndex = spicJsonStr.lastIndexOf("]");
		//获取json中的rows中的有效数据
		jsonData = spicJsonStr.substring(beginIndex, endIndex + 1);
		ObjectMapper objectMapper = new ObjectMapper();

		PlanChannelDetail[] planChanneDetail = objectMapper.readValue(jsonData, PlanChannelDetail[].class);
		Set<PlanChannelDetail> planChannelDetails = new HashSet<PlanChannelDetail>();

		for (int i = 0; i < planChanneDetail.length; i++) {
			PlanChannelDetail pcd = new PlanChannelDetail();
			if (planChanneDetail[i].getChannelRiskType() == "1" || planChanneDetail[i].getChannelRiskType().equals("1")) {
				List<PlanChannelDetail> list = JSONObject.parseArray(autoGrid, PlanChannelDetail.class);
				for (int j = 0; j < list.size(); j++) {
					pcd = new PlanChannelDetail();
					PlanChannelDetail channelType = list.get(j);
					pcd.setPlanChannelId(channelType.getPlanChannelId());
					pcd.setChannelCode(channelType.getChannelCode());
					pcd.setTargetPremium(channelType.getTargetPremium());
					pcd.setChannelRiskType(planChanneDetail[i].getChannelRiskType());
					pcd.setContent(planChanneDetail[i].getContent());
					pcd.setRemark(planChanneDetail[i].getRemark());
					planChannelDetails.add(pcd);
				}
			} else if (planChanneDetail[i].getChannelRiskType() == "2" || planChanneDetail[i].getChannelRiskType().equals("2")) {
				List<PlanChannelDetail> list = JSONObject.parseArray(propertyGrid, PlanChannelDetail.class);
				for (int k = 0; k < list.size(); k++) {
					pcd = new PlanChannelDetail();
					PlanChannelDetail channelType = list.get(k);
					pcd.setPlanChannelId(channelType.getPlanChannelId());
					pcd.setChannelCode(channelType.getChannelCode());
					pcd.setTargetPremium(channelType.getTargetPremium());
					pcd.setChannelRiskType(planChanneDetail[i].getChannelRiskType());
					pcd.setContent(planChanneDetail[i].getContent());
					pcd.setRemark(planChanneDetail[i].getRemark());
					planChannelDetails.add(pcd);
				}
			} else if (planChanneDetail[i].getChannelRiskType() == "3" || planChanneDetail[i].getChannelRiskType().equals("3")) {
				List<PlanChannelDetail> list = JSONObject.parseArray(lifeGrid, PlanChannelDetail.class);
				for (int m = 0; m < list.size(); m++) {
					pcd = new PlanChannelDetail();
					PlanChannelDetail channelType = list.get(m);
					pcd.setPlanChannelId(channelType.getPlanChannelId());
					pcd.setChannelCode(channelType.getChannelCode());
					pcd.setTargetPremium(channelType.getTargetPremium());
					pcd.setChannelRiskType(planChanneDetail[i].getChannelRiskType());
					pcd.setContent(planChanneDetail[i].getContent());
					pcd.setRemark(planChanneDetail[i].getRemark());
					planChannelDetails.add(pcd);
				}
			}
		}
		planMain.setPlanChannelDetail(planChannelDetails);
		planMain.setUpdatedUser(CurrentUser.getUser().getUserCode());
		try {
			salePlanChannelService.saveSallePlanChannel(planMain);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(planMain), e);
		}
	}

}
