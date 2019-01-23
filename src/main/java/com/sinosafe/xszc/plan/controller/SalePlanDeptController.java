package com.sinosafe.xszc.plan.controller;

import java.io.IOException;
import java.util.HashSet;
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
import com.sinosafe.xszc.plan.service.SalePlanDeptService;
import com.sinosafe.xszc.plan.vo.PlanDeptDetail;
import com.sinosafe.xszc.plan.vo.PlanMain;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/salePlanDept")
public class SalePlanDeptController {

	private static final Log log = LogFactory.getLog(SalePlanDeptController.class);

	@Autowired
	@Qualifier("SalePlanDeptService")
	private SalePlanDeptService salePlanDeptService;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@RequestMapping("/querySalePlanDept")
	public void querySalePlanDept(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = salePlanDeptService.findSalePlanDept(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/queryAllSalePlanDept")
	public void queryAllSalePlanDept(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());

		// 如果是总公司
		String dept = (String) pageDto.getWhereMap().get("deptCode");
		if (StringUtils.isBlank(dept)) {
			List<Map<String, Object>> list = umService.findDeptListByUserCode(CurrentUser.getUser().getUserCode());
			if (list != null && list.size() == 1) {
				pageDto.getWhereMap().put("deptCode", list.get(0).get("deptCode").toString());
			}
		}

		try {
			pageDto = salePlanDeptService.queryAllSalePlanDept(pageDto);
			
		   //测试查询的数据
		   System.out.println("whereMap:"+pageDto.getWhereMap());
		   List<Map<String,Object>> mapList = pageDto.getRows();
		   for (Map<String, Object> map : mapList) {
			    System.out.println(map);
		   }
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}

	@RequestMapping("/querySalePlanDeptByVo")
	public void querySalePlanDeptByVo(HttpServletRequest request, HttpServletResponse response, String planMainId) throws GeneralException {
		PlanMain planMain = new PlanMain();
		planMain.setPlanMainId(planMainId);
		planMain = salePlanDeptService.querySalePlanDeptByVo(planMain);
		response.setContentType("text/html;charset=UTF-8");
		SendUtil.sendJSON(response, planMain);
	}

	/**
	 * 新增销售保费计划
	 * 
	 * @param request
	 * @param response
	 * @param planMain
	 * @throws GeneralException
	 * @throws JsonParseException
	 * @throws JsonMappingException
	 * @throws IOException
	 */
	@RequestMapping("/saveSalePlanDept")
	public void saveSalePlanDept(HttpServletRequest request, HttpServletResponse response, PlanMain planMain) throws GeneralException,
			JsonParseException, JsonMappingException, IOException {
		long count = salePlanDeptService.querySalePlanOneByDept(planMain.getDeptCode(), planMain.getYear());
		log.debug("统计该机构的计划数:" + count);
		// 机构没有保费计划则新增
		// if(count==0){
		String jsonData = request.getParameter("salePlanDeptSet");
		int beginIndex = jsonData.lastIndexOf("[");
		int endIndex = jsonData.lastIndexOf("]");
		// 获取json中的rows中的有效数据
		jsonData = jsonData.substring(beginIndex, endIndex + 1);
		ObjectMapper objectMapper = new ObjectMapper();

		PlanDeptDetail[] planDeptDetail = objectMapper.readValue(jsonData, PlanDeptDetail[].class);
		Set<PlanDeptDetail> planDeptDetails = new HashSet<PlanDeptDetail>();

		for (int i = 0; i < planDeptDetail.length; i++) {
			planDeptDetail[i].setDeptCode(planMain.getDeptCode());
			planDeptDetails.add(planDeptDetail[i]);
		}
		planMain.setPlanDeptDetail(planDeptDetails);
		try {
			salePlanDeptService.saveSallePlanDept(planMain);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为："+JSONObject.toJSONString(planMain), e);
		}
		SendUtil.sendJSON(response, "success");
		// }else{
		// SendUtil.sendJSON(response, "error");
		// }
	}

	@RequestMapping("/deleteSalePlanDept")
	public void deleteSalePlanDept(HttpServletRequest request, HttpServletResponse response, String planMainId) throws IOException {
		salePlanDeptService.deleteSalePlanDept(planMainId);
	}

	@RequestMapping("/updateStuts")
	public void updateStuts(HttpServletRequest request, HttpServletResponse response, FormDto dto) {
		String resoult = salePlanDeptService.updateStuts(dto.getFormMap());
		SendUtil.sendJSON(response, resoult);
	}
	
	@RequestMapping("/checkExistPlan")
	public void checkExistPlan(HttpServletRequest request, HttpServletResponse response, String deptCode, String year)  throws GeneralException {	
		long count = 1;
		try {
			count = salePlanDeptService.querySalePlanOneByDept(deptCode, Integer.parseInt(year));
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询销售人员管理办法版本代码是否存在时出现异常，传入参数为：" + deptCode + "," + year, e);
		}
		SendUtil.sendJSON(response, count <= 0);
	}


}
