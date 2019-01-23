package com.sinosafe.xszc.survey.controller;

import java.beans.IntrospectionException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.lang.StringUtils;
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
import com.sinosafe.xszc.survey.service.MarketResInforChannelService;
import com.sinosafe.xszc.survey.service.MarketResInforLocalService;
import com.sinosafe.xszc.survey.service.MarketResInforMainService;
import com.sinosafe.xszc.survey.service.MarketResInforPremiumService;
import com.sinosafe.xszc.survey.vo.MarketResInforChannel;
import com.sinosafe.xszc.survey.vo.MarketResInforLocal;
import com.sinosafe.xszc.survey.vo.MarketResInforMain;
import com.sinosafe.xszc.survey.vo.MarketResInforPremium;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/marketResInforMain")
public class MarketResInforMainController {

	private static final Log log = LogFactory.getLog(MarketResInforMainController.class);

	@Autowired
	@Qualifier("MarketResInforMainService")
	private MarketResInforMainService marketResInforMainService;

	@Autowired
	@Qualifier("MarketResInforChannelService")
	private MarketResInforChannelService marketResInforChannelService;

	@Autowired
	@Qualifier("MarketResInforLocalService")
	private MarketResInforLocalService marketResInforLocalService;

	@Autowired
	@Qualifier("MarketResInforPremiumService")
	private MarketResInforPremiumService marketResInforPremiumService;
	
	@Autowired 
	@Qualifier(value = "umService") 
	private UmService umService;

	/*
	 * 新增市场调研
	 */
	@RequestMapping("/saveMarketResInforMain")
	public void saveMarketResInforMain(HttpServletRequest request, HttpServletResponse response, MarketResInforMain marketResInforMain)
			throws GeneralException, JsonParseException, JsonMappingException, IOException {

		String jsonLocalData = "";
		String jsonChannelData = "";
		String jsonPremiumData = "";

		String setLocal = request.getParameter("setLocal");
		String setPremium = request.getParameter("setPremium");
		String setChannel = request.getParameter("setChannel");

		jsonLocalData = setLocal.substring(setLocal.indexOf("["), setLocal.indexOf("]") + 1);
		jsonChannelData = setChannel.substring(setChannel.indexOf("["), setChannel.indexOf("]") + 1);
		jsonPremiumData = setPremium.substring(setPremium.indexOf("["), setPremium.indexOf("]") + 1);

		ObjectMapper objectMapper = new ObjectMapper();

		MarketResInforChannel[] marketResInforChannel = objectMapper.readValue(jsonChannelData, MarketResInforChannel[].class);
		marketResInforMain.setMarketResInforChannel(Arrays.asList(marketResInforChannel));

		MarketResInforLocal[] marketResInforLocal = objectMapper.readValue(jsonLocalData, MarketResInforLocal[].class);
		marketResInforMain.setMarketResInforLocal(Arrays.asList(marketResInforLocal));

		MarketResInforPremium[] marketResInforPremium = objectMapper.readValue(jsonPremiumData, MarketResInforPremium[].class);
		marketResInforMain.setMarketResInforPremium(Arrays.asList(marketResInforPremium));

		marketResInforMain.setUpdateUser(CurrentUser.getUser().getUserCode());
		try {
			marketResInforMainService.saveMarketResInforMain(marketResInforMain);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(marketResInforMain), e);
		}
	}

	/**
	 * 查询市场调研管理信息 yaya
	 */
	@RequestMapping("/queryMarketResInforMain")
	public void queryMarketResInforMain(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		
		//如果是总公司
		String dept = (String)pageDto.getWhereMap().get("deptCode");
		if(StringUtils.isBlank(dept)){
			List<Map<String, Object>> list = umService.findDeptListByUserCode(getUser());
			if(list != null && list.size() == 1){
				pageDto.getWhereMap().put("deptCode", list.get(0).get("deptCode").toString());
			}
		}

		try {
			pageDto = marketResInforMainService.findMarketResInforMainByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/queryMarketResInforMainByVo")
	public void queryMarketResInforMainByVo(HttpServletRequest request, HttpServletResponse response, String pkId) throws GeneralException {
		MarketResInforMain marketResInforMain = new MarketResInforMain();
		marketResInforMain.setPkId(pkId);
		marketResInforMain = marketResInforMainService.queryMarketResInforMainByVo(marketResInforMain);
		response.setContentType("text/html;charset=UTF-8");
		SendUtil.sendJSON(response, marketResInforMain);
	}

	/*
	 * 根据相关参数子表查询
	 */
	@RequestMapping("/queryMarketResInforPremiumByVo")
	public void queryMarketResInforPremiumByVo(HttpServletRequest request, HttpServletResponse response, String pkId) throws GeneralException,
			IntrospectionException, IllegalAccessException, InvocationTargetException {
		PageDto pageDto = new PageDto();
		List<Map<String, Object>> list = marketResInforPremiumService.queryMarketResInforPremiumByVo(pkId);
		if (!(pkId == "" || pkId.equals("") || pkId == "undefined" || pkId.equals("undefined"))) {
			pageDto.setRows(list);
			pageDto.setTotal((long) list.size());
			response.setContentType("text/html;charset=UTF-8");
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/*
	 * 根据相关参数子表查询
	 */
	@RequestMapping("/queryMarketResInforLocalByVo")
	public void queryMarketResInforLocalByVo(HttpServletRequest request, HttpServletResponse response, String pkId) throws GeneralException,
			IntrospectionException, IllegalAccessException, InvocationTargetException {
		PageDto pageDto = new PageDto();
		List<Map<String, Object>> list = marketResInforLocalService.queryMarketResInforLocalByVo(pkId);
		if (!(pkId == "" || pkId.equals("") || pkId == "undefined" || pkId.equals("undefined"))) {
			pageDto.setRows(list);
			pageDto.setTotal((long) list.size());
			response.setContentType("text/html;charset=UTF-8");
		}
		SendUtil.sendJSON(response, pageDto);
	}

	/*
	 * 根据相关参数子表查询
	 */
	@RequestMapping("/queryMarketResInforChannelByVo")
	public void queryMarketResInforChannelByVo(HttpServletRequest request, HttpServletResponse response, String pkId) throws GeneralException,
			IntrospectionException, IllegalAccessException, InvocationTargetException {
		PageDto pageDto = new PageDto();
		List<Map<String, Object>> list = marketResInforChannelService.queryMarketResInforChannelByVo(pkId);
		if (!(pkId == "" || pkId.equals("") || pkId == "undefined" || pkId.equals("undefined"))) {
			pageDto.setRows(list);
			pageDto.setTotal((long) list.size());
			response.setContentType("text/html;charset=UTF-8");
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/deleteMarketResInfor")
	public void deleteMarketResInfor(HttpServletRequest request, HttpServletResponse response, String pkId) throws IOException {
		boolean flag = false;

		if (pkId.indexOf(",") > 0) {
			for (int i = 0; i < pkId.split(",").length; i++) {
				flag = marketResInforMainService.deleteMarketResInforMain(pkId.split(",")[i]);
			}
		} else {
			flag = marketResInforMainService.deleteMarketResInforMain(pkId);
		}

		response.getWriter().print(flag);
	}
	
	private String getUser() {
		return CurrentUser.getUser().getUserCode();
	}

}
