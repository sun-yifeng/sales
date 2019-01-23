package com.sinosafe.xszc.channel.controller;

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
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.channel.service.RecommenderService;
import com.sinosafe.xszc.channel.vo.ChannelRecommendDetail;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/recommender")
public class RecommenderController {
	
	private static final Log log = LogFactory.getLog(AgentController.class);
	
	@Autowired
	@Qualifier(value = "RecommenderService")
	private RecommenderService recommenderService;
	
	@Autowired 
	@Qualifier(value = "umService") 
	private UmService umService;
	
	@RequestMapping("/queryRecommenders")
	@VisitDesc(label = "个代推荐人分页查询", actionType = 4)
	public void queryEnterpriseByWhere(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		PageDto pageDto = new PageDto();
		Map<String, Object> paramMap = dto.getFormMap();
		pageDto.setStart(request.getParameter("start"));
		pageDto.setLimit(request.getParameter("limit"));
		pageDto.setWhereMap(dto.getFormMap());
		
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
		
		try {
			pageDto = recommenderService.findRecommedersByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/saveRecommender")
	@VisitDesc(label = "个代推荐人信息保存", actionType = 2)
	public void saveEnterprise(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> formMap = dto.getFormMap();
		formMap.put("createdUser", CurrentUser.getUser().getUserCode());
		formMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			recommenderService.saveRecommender(formMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("保存操作异常，传入参数为：" + JSONObject.toJSONString(formMap), e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	@RequestMapping("/quertRecommenderByDeptCode")
	@VisitDesc(label = "根据机构代码,查询推荐人信息", actionType = 1)
	public void quertRecommenderByDeptCode(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
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
			pageDto = recommenderService.findRecommenderByDeptCode(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/queryRecommenderDetail")
	@VisitDesc(label = "查询打个推荐人信息", actionType = 3)
	public void queryRecommenderById(HttpServletRequest request, HttpServletResponse response, String recommenderId) throws GeneralException {
		Map<String, Object> resultMap = null;
		try {
			resultMap = recommenderService.findRecommenderById(recommenderId);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + recommenderId, e);
		}
		SendUtil.sendJSON(response, resultMap);
	}
	
	@RequestMapping("/updateRecommender")
	@VisitDesc(label = "修改个代推荐人信息", actionType = 5)
	public void updateRecommender(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> formMap = dto.getFormMap();
		formMap.put("updatedUser", CurrentUser.getUser().getUserCode());
		try {
			recommenderService.updateRecommender(formMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("保存操作异常，传入参数为：" + JSONObject.toJSONString(formMap), e);
		}
		SendUtil.sendJSON(response, "success");
	}
	
	@RequestMapping("/deleteRecommender")
	@VisitDesc(label = "删除个代推荐人信息", actionType = 5)
	public void deleteRecommenderById(HttpServletRequest request, HttpServletResponse response, String recommenderId,String channelCode) throws GeneralException {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("recommenderId", recommenderId);
		paramMap.put("channelCode", channelCode);
		try {
			recommenderService.deleteRecommenderById(paramMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询操作异常，传入参数为：" + recommenderId, e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	@RequestMapping("/saveRecommendersApprove")
	public void saveRowsApprove(HttpServletRequest request,HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		try{
			String selectedRows = request.getParameter("selectedRows");
			List<ChannelRecommendDetail> selectedList = JSONArray.parseArray(selectedRows, ChannelRecommendDetail.class);
			List<String> listRecommenderId = new ArrayList<String>();
			for (ChannelRecommendDetail channelRecommendDetail : selectedList) {
				listRecommenderId.add(channelRecommendDetail.getRecommenderId());
			}
			int approveFileCount = this.recommenderService.saveRecommendersApprove(listRecommenderId);
			if(approveFileCount==0){
				jsonObject.put("actionMsg", "ok");
			}else{
				jsonObject.put("actionCount", approveFileCount);
			}
		}catch(Exception e){
			jsonObject.put("actionMsg", "error");
		}
	    response.getWriter().write(jsonObject.toJSONString());
	}
	
}
