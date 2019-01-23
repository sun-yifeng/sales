package com.sinosafe.xszc.activity.controller;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.activity.service.ActivityService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.GetRequestMap;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;
import com.sinosafe.xszc.util.StringUtil;

@Controller
@RequestMapping("/activity")
public class ActivityController {
	private static Logger logger = Logger.getLogger(ActivityController.class);
	
	@Autowired
	@Qualifier("ActivityService")
	private ActivityService activityService;
	
	@RequestMapping("/queryActivity")
	@VisitDesc(label="查询活动",actionType=4)
	public void queryActivity(HttpServletRequest request,HttpServletResponse response,FormDto dto)throws GeneralException{
		String startStr = request.getParameter("start");
	    String limitStr = request.getParameter("limit");
	    if(dto.getFormMap().get("validInd")!=null && dto.getFormMap().get("validInd").toString().equalsIgnoreCase("2")){
	    	dto.getFormMap().remove("validInd");
	    }
	    if(dto.getFormMap().get("authType")!=null && dto.getFormMap().get("authType").toString().equalsIgnoreCase("0")){
	    	dto.getFormMap().remove("authType");
	    }
	    PageDto pd = new PageDto();
	    pd.setStart(startStr);
	    pd.setLimit(limitStr);
	    pd.setWhereMap(StringUtil.moveSpaceForMap(dto.getFormMap()));
	    try {
	    	pd = activityService.findActivityByWhere(pd);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(dto.getFormMap()), e);
		}
	    SendUtil.sendJSON(response, pd);
	}
	
	@RequestMapping("/activityDetail")
	@VisitDesc(label="查询活动详细内容",actionType=4)
	public ModelAndView activityDetail(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
	    Map<String, Object> paraMap = new HashMap<String, Object>();
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    paraMap = new GetRequestMap().getRequstMap(request);
	    try {
	    	resultMap = activityService.findActivityDetailByWhere(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
	    ModelMap modelMap = new ModelMap();
	    String resultJson = JSONObject.toJSONString(resultMap);
	    modelMap.addAttribute("activityDetail", resultJson);
	    modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
	    return new ModelAndView("redirect:/view/activity/activityDetail.jsp", modelMap);
	}
	
	@RequestMapping("/activityFeedbackQuery")
	@VisitDesc(label="查询活动反馈查询",actionType=4)
	public ModelAndView activityFeedbackQuery(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		try {
			resultMap = activityService.findActivityDetailForFeedback(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
		ModelMap modelMap = new ModelMap();
		String resultJson = JSONObject.toJSONString(resultMap);
		modelMap.addAttribute("activityDetail", resultJson);
		modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
		return new ModelAndView("redirect:/view/activity/activityDetail.jsp", modelMap);
	}
	
	@RequestMapping("/activityRedirect")
	public ModelAndView activityRedirect(HttpServletRequest request,HttpServletResponse response)throws UnsupportedEncodingException  {
	    Map<String, Object> paraMap = new HashMap<String, Object>();
	    paraMap = new GetRequestMap().getRequstMap(request);
	    ModelMap modelMap = new ModelMap();
		Map<String, String> resultMap = new HashMap<String, String>();
		resultMap.put("uploadId", UUIDGenerator.getUUID());
		String resultJson = JSONObject.toJSONString(resultMap);
		modelMap.addAttribute("activityDetail", resultJson);
	    modelMap.addAttribute("paraMap", JSONObject.toJSONString(paraMap));
	    return new ModelAndView("redirect:/view/activity/activityDetail.jsp", modelMap);
	}
	
	@RequestMapping("/findActivityFeedback")
	@VisitDesc(label="查询活动反馈",actionType=4)
	public void findActivityFeedback(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
	    Map<String, Object> paraMap = new HashMap<String, Object>();
	    paraMap = new GetRequestMap().getRequstMap(request);
		String startStr = request.getParameter("start");
	    String limitStr = request.getParameter("limit");
	    PageDto pd = new PageDto();
	    pd.setStart(startStr);
	    pd.setLimit(limitStr);
	    pd.setWhereMap(StringUtil.moveSpaceForMap(paraMap));
	    try {
	    	pd = activityService.findActivityFeedbackByWhere(pd);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
	    SendUtil.sendJSON(response, pd);
	}
	
	@RequestMapping("/activitySummary")
	@VisitDesc(label="获取指定活动未完成反馈数",actionType=4)
	public void activitySummary(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
	    Map<String, Object> paraMap = new HashMap<String, Object>();
	    paraMap = new GetRequestMap().getRequstMap(request);
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    try {
	    	resultMap = activityService.findActivityForSummary(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
	    SendUtil.sendJSON(response, resultMap);
	}
	
	@RequestMapping("/activitySave")
	@VisitDesc(label="保存活动信息",actionType=1)
	public void activitySave(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
	    Map<String, Object> paraMap = new HashMap<String, Object>();
	    paraMap = new GetRequestMap().getRequstMap(request);
	    Boolean result = false;
	    try {
	    	result = activityService.saveActivity(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("活动保存出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
	    SendUtil.sendJSON(response, result);
	}
	
	@RequestMapping("/activitySubmit")
	@VisitDesc(label="保存活动信息",actionType=1)
	public void activitySubmit(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		String[] issuedDeptsArray = ((String) paraMap.get("issuedDepts")).split(",");
		paraMap.put("issuedDepts", issuedDeptsArray);
		try {
			activityService.saveSubmitActivity(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, true);
	}
	
	@RequestMapping("/activitySummaryUpdate")
	@VisitDesc(label="活动总结",actionType=3)
	public void activitySummaryUpdate(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		try {
			activityService.updateSummaryActivity(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, true);
	}
	
	@RequestMapping("/activityFeedbackSave")
	@VisitDesc(label="活动总结",actionType=3)
	public void activityFeedbackSave(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		try {
			activityService.saveActivityFeedback(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, true);
	}
	
	@RequestMapping("/activityFeedbackSubmit")
	public void activityFeedbackSubmit(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		try {
			activityService.updateFeedbackSubmit(paraMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, true);
	}
	
	@RequestMapping("/queryFeedback")
	@VisitDesc(label="待反馈活动分页查询",actionType=4)
	public void queryFeedback(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		if (dto.getFormMap().get("validInd") != null && dto.getFormMap().get("validInd").toString().equalsIgnoreCase("2")) {
			dto.getFormMap().remove("validInd");
		}
		PageDto pd = new PageDto();
		pd.setStart(startStr);
		pd.setLimit(limitStr);
		pd.setWhereMap(StringUtil.moveSpaceForMap(dto.getFormMap()));
		try {
			pd = activityService.findFeedback(pd);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(dto.getFormMap()), e);
		}
		SendUtil.sendJSON(response, pd);
	}

	@RequestMapping("/queryDept")
	@VisitDesc(label="查询下发机构",actionType=4)
	public void queryDept(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = new GetRequestMap().getRequstMap(request);
		Map<String, List<Map<String, Object>>> resultMap = new HashMap<String, List<Map<String, Object>>>();
		try {
			resultMap = activityService.findDept(paramMap);
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为：" + JSONObject.toJSONString(dto.getFormMap()), e);
		}
		SendUtil.sendJSON(response, resultMap);
	}
	
	
	@RequestMapping("/activityDelete")
	@VisitDesc(label="删除活动",actionType=2)
	public void activityDelete(HttpServletRequest request,HttpServletResponse response)throws GeneralException, UnsupportedEncodingException  {
		Map<String, Object> paraMap = new HashMap<String, Object>();
		paraMap = new GetRequestMap().getRequstMap(request);
		try {
			activityService.deleteActivity(paraMap);;
		} catch (Exception e) {
			logger.error(e);
			throw new ServiceException("条件查询出现异常，数据参数为："+JSONObject.toJSONString(paraMap), e);
		}
		SendUtil.sendJSON(response, true);
	}

}
