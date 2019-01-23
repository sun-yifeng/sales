package com.sinosafe.xszc.department.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.department.vo.Department;
import com.sinosafe.xszc.group.vo.Salesman;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;
import com.sinosafe.xszc.util.StringUtil;

@Controller
@RequestMapping("/department")
public class DepartmentController {

	private static final Log log = LogFactory.getLog(DepartmentController.class);

	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@RequestMapping("/queryDepartment")
	public void queryDepartment(HttpServletRequest request, HttpServletResponse response, Long id) {
		Map<String, Object> map = null;
		if (id != null) {
			map = new HashMap<String, Object>();
			map.put("id", id);
		}

		List<Map<String, Object>> list = departmentService.findDepartmenAll(map);
		SendUtil.sendJSON(response, list);
	}

	@RequestMapping("/queryDepart")
	public void queryDepart(HttpServletRequest request, HttpServletResponse response, String id) {
		Map<String, Object> sendMap = null;
		List<Map<String, Object>> resList = null;

		if (" ".equals(id)) {
			// resList = departmentService.queryDepartByDeptCode(paramList);
			resList = departmentService.findDepartmenAll(sendMap);
			// resList = null;
		} else {
			sendMap = new HashMap<String, Object>();
			sendMap.put("id", id);
			resList = departmentService.findDepartmenAll(sendMap);
		}
		SendUtil.sendJSON(response, resList);
	}

	/**
	 * 组织管理树
	 * 
	 * @param request
	 * @param response
	 * @param parentCode
	 */
	@RequestMapping("/queryDeptByParentCode")
	public void queryDeptByParentCode(HttpServletRequest request, HttpServletResponse response, String parentCode) {
		log.debug("父级机构的代码parentCode:" + parentCode);
		Map<String, Object> paraMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = null;

		List<Map<String, Object>> list = umService.findDeptListByUserCode(getUser());

		if (StringUtils.isBlank(parentCode)) {
			if (list.size() == 1) {
				paraMap.put("deptCode", list.get(0).get("deptCode").toString());
				paraMap.put("deptLevel", "0");
				resultList = departmentService.findDepartmenByLevel(paraMap);
			}
		} else {
			paraMap.put("parentCode", parentCode);
			resultList = departmentService.findDepartmenByParent(paraMap);
		}

		if (resultList == null || list == null) {
			SendUtil.sendString(response, "");
		} else {
			SendUtil.sendJSON(response, resultList);
		}

	}

	@RequestMapping("/queryDeptDropList")
	public void queryDeptDropList(HttpServletRequest request, HttpServletResponse response, String parentCode, String deptCode) {
		log.debug("父机构代码parentCode:" + parentCode + ",机构代码deptCode:" + deptCode);
		Map<String, Object> paraMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = null;

		List<Map<String, Object>> umDeptlist = umService.findDeptListByUserCode(getUser());
		log.debug("登录用户在UM分配的机构:" + JSON.toJSONString(umDeptlist));
		//获取登录用户的机构，设置初始值
		if (StringUtils.isNotBlank(parentCode)) {
			paraMap.put("parentCode", parentCode);
			resultList = departmentService.findDeptDropListByParent(paraMap);
		} else if (StringUtils.isNotBlank(deptCode)) {
			paraMap.put("deptCode", deptCode);
			resultList = departmentService.findDeptDropListByDept(paraMap);
		} else {
			if (umDeptlist.size() == 1) {
				paraMap.put("deptCode", umDeptlist.get(0).get("deptCode").toString());
				resultList = departmentService.findDeptDropListByLevel(paraMap);
			}
		}
		
		if (resultList == null || umDeptlist == null) {
			SendUtil.sendString(response, "");
		} else {
			SendUtil.sendJSON(response, resultList);
		}
	}

	@RequestMapping("/queryDeptInfo")
	public void queryDeptInfo(HttpServletRequest request, HttpServletResponse response, String deptCode) {
		log.debug("机构的代码parentCode:" + deptCode);
		Department dept = departmentService.findDepartmentVo(deptCode);
		// 如果是总公司
		if (StringUtils.isBlank(dept.getParentDeptCode())) {
			dept.setParentDeptCode(dept.getDeptCode());
			dept.setParentDeptName(dept.getDeptSimpleName());
		} else {
			Department parentDept = departmentService.findDepartmentVo(dept.getParentDeptCode());
			dept.setParentDeptName(parentDept.getDeptSimpleName());
		}
		SendUtil.sendJSON(response, dept);
	}

	@RequestMapping("/saveDept")
	public void saveDept(HttpServletRequest request, HttpServletResponse response, Department dept) {
		String msg = "";
		// 新增
		if ("save".equals(dept.getOperateType())) {
			// 是否已经存在机构代码
			if (departmentService.existDeptpartment(dept.getDeptCode())) {
				SendUtil.sendJSON(response, "已经存在机构代码" + dept.getDeptCode());
				return;
			}
			// 父机构代码是否存在
			if (StringUtils.isNotBlank(dept.getParentDeptCode())) {
				if (!departmentService.existDeptpartment(dept.getParentDeptCode())) {
					SendUtil.sendJSON(response, "父机构代码" + dept.getParentDeptCode() + "不存在，请重新填写父机构代码！");
					return;
				} else {
					int deptLevel = departmentService.findDeptLevel(dept.getParentDeptCode());
					dept.setDeptLevel(deptLevel + 1);
				}
			} else {
				dept.setDeptLevel(0);
			}

			dept.setValidInd("1");
			dept.setCreatedUser(getUser());
			dept.setUpdatedUser(getUser());
			msg = departmentService.saveDepartment(dept);
			SendUtil.sendJSON(response, msg);
		}
		// 修改
		else if ("update".equals(dept.getOperateType())) {
			// 机构代码是否存在,不存在不能修改
			if (!departmentService.existDeptpartment(dept.getDeptCode())) {
				SendUtil.sendJSON(response, "机构代码" + dept.getDeptCode() + "不存在！");
				return;
			}
			// 如果有子机构，不许修改机构代码
			if (StringUtils.isNotBlank(dept.getOldDeptCode())) {
				if (!dept.getOldDeptCode().equals(dept.getDeptCode())) {
					if (departmentService.existChildDepartment(dept.getOldDeptCode())) {
						SendUtil.sendJSON(response, "该机构存在子机构，请将子机构删除后，再修改机构代码！");
						return;
					}
				}
			}
			// 不能修改总公司的机构级别和父机构代码。如果是总公司，则机构级别为0，父机构代码为空。
			if ("00".equals(dept.getDeptCode())) {
				dept.setDeptLevel(0);
				dept.setParentDeptCode(null);
			} else {
				int deptLevel = departmentService.findDeptLevel(dept.getParentDeptCode());
				dept.setDeptLevel(deptLevel + 1);
			}

			dept.setUpdatedUser(getUser());
			dept.setValidInd("1");
			msg = departmentService.updateDepartment(dept);
			SendUtil.sendJSON(response, msg);
		} else {
			// do nothing
		}
	}

	@RequestMapping("/updateDept")
	public void updateDept(HttpServletRequest request, HttpServletResponse response, Department dept) {
		String msg = "";
		if (departmentService.existChildDepartment(dept.getOldDeptCode())) {
			SendUtil.sendJSON(response, "该机构存在子机构，请将子机构删除后，再修改机构代码！");
			return;
		}

		if (StringUtils.isNotBlank(dept.getParentDeptCode())) {
			if (!departmentService.existDeptpartment(dept.getParentDeptCode())) {
				SendUtil.sendJSON(response, "父机构代码" + dept.getParentDeptCode() + "不存在，请重新填写父机构代码！");
				return;
			} else {
				int deptLevel = departmentService.findDeptLevel(dept.getParentDeptCode());
				dept.setDeptLevel(deptLevel + 1);
			}
		} else {
			dept.setDeptLevel(0);
		}

		dept.setUpdatedUser(getUser());
		msg = departmentService.updateDepartment(dept);
		SendUtil.sendJSON(response, msg);
	}

	@RequestMapping("/removeDept")
	public void removeDept(HttpServletRequest request, HttpServletResponse response, Department dept) {
		String msg = "";
		if (departmentService.existChildDepartment(dept.getDeptCode())) {
			SendUtil.sendJSON(response, "该机构存在子机构，请先删除子机构！");
			return;
		}
		if (!departmentService.existDeptpartment(dept.getDeptCode())) {
			SendUtil.sendJSON(response, "该机构不存在，请确定机构代码是否正确！");
			return;
		}
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("deptCode", dept.getDeptCode());
		whereMap.put("updatedUser", getUser());
		msg = departmentService.removeDepartment(whereMap);
		SendUtil.sendJSON(response, msg);
	}

	/**
	 * <pre>
	 * 根据部门选择用户 
	 * 方法queryUserByDeptCode的详细说明:查询条件(工号或姓名)
	 * 编写者:孙益峰
	 * 创建时间:2014年8月7日 下午3:01:10
	 * @param 参数名说明
	 * @return void 说明
	 * @throws 异常类型 说明
	 * </pre>
	 */
	@RequestMapping("/queryUserByDeptCode")
	public void queryUserByDeptCode(HttpServletRequest request, HttpServletResponse response, String deptCode, Salesman salesman) {
		String loginUserCode = "";
		HashMap<String, Object> whereMap = new HashMap<String, Object>();
		// 如果没有选择树上的机构，则取登录用户的机构
		if (StringUtils.isBlank(salesman.getDeptCode())) {
			loginUserCode = CurrentUser.getUser().getUserCode();
			deptCode = departmentService.getDeptCodeByUser(loginUserCode);
			if (StringUtils.isBlank(deptCode)) {
				throw new RuntimeException("没有取到用户所在的部门，用户代码:" + CurrentUser.getUser().getUserCode());
			} else {
				// 如果登录用户是总公司
				if (deptCode.startsWith("00")) {
					deptCode = "";
				}
			}

		}
		// 如果选择了机构
		else {
			// 如果选择的是总公司
			if ("00".equals(deptCode)) {
				deptCode = "";
			}
		}

		whereMap.put("deptCode", deptCode);
		whereMap.put("salesmanCname", StringUtils.trim(salesman.getSalesmanCname()));
		PageDto pageDto = new PageDto();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(whereMap);
		pageDto = departmentService.findUserByWhere(pageDto);
		SendUtil.sendJSON(response, pageDto);
	}

	private String getUser() {
		return CurrentUser.getUser().getUserCode();
	}
	
	@RequestMapping("/queryDepartmentByUserCode")
	public void queryDepartmentByUserCode(HttpServletRequest request, HttpServletResponse response) {
		// 查询出登录用户的角色
		List<Map<String, Object>> list1 = umService.findDeptListByUserCode(getUser());
		List<Map<String, Object>> list2 = null;
		if (list1.size() == 1) {
			// 查询出登录用户的机构
			list2 = departmentService.queryDepartmentByUserCode(list1.get(0));
			JSONArray result = new JSONArray();
			try {
				if (list2 != null && list2.size() != 0) {
					result.add(buildDept("", "请选择"));
					for (int i = 0; i < list2.size(); i++) {
						result.add(buildDept(list2.get(i).get("deptCode").toString(),list2.get(i).get("deptName").toString()));
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
	}
	
	@RequestMapping("/isThirdDepartment")
	public void isThirdDepartment(HttpServletRequest request, HttpServletResponse response) {
		
		JSONArray result = new JSONArray();
		
		List<Map<String, Object>> list = umService.findDeptListByUserCode(getUser());
		String deptCode = (String)list.get(0).get("deptCode");
		Map<String,String> parameter = new HashMap<String,String>();
		parameter.put("deptCode",deptCode);
		
		list = departmentService.queryDeptLevelInfo(parameter);
		Map<String,Object> resultMap = departmentService.queryDeptLevelInfo(parameter).get(0);
			
		if("2".equals(resultMap.get("deptLevel").toString())){
			result.add(buildDept(resultMap.get("DEPTCODE").toString(),resultMap.get("DEPTSIMPLENAME").toString()));
		}
		
		response.reset();
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter writer = null;
		try {
			writer = response.getWriter();
			writer.write(result.toString());
			writer.flush();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	@RequestMapping("/queryDepartmentCityByUserCode")
	public void queryDepartmentCityByUserCode(HttpServletRequest request, HttpServletResponse response, String upDept) {
		List<Map<String, Object>> list = umService.findDeptListByUserCode(getUser());
		List<Map<String, Object>> resList = null;
		if (list.size() == 1) {
			resList = departmentService.queryDepartmentCityByUserCode(list.get(0), upDept);
			JSONArray result = new JSONArray();
			try {
				if (resList != null && resList.size() != 0) {
					result.add(buildDept("", "请选择"));
					for (int i = 0; i < resList.size(); i++) {
						result.add(buildDept(resList.get(i).get("deptCode").toString(), resList.get(i).get("deptName").toString()));
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
	}

	@RequestMapping("/queryDepartmentCityBySaleman")
	public void queryDepartmentCityBySaleman(HttpServletRequest request, HttpServletResponse response, String upDept, String deptCode) {
		List<Map<String, Object>> resList = null;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptCode", deptCode);
		resList = departmentService.queryDepartmentCityByUserCode(map, upDept);

		JSONArray result = new JSONArray();
		try {
			if (resList != null && resList.size() != 0) {
				result.add(buildDept("", "请选择"));
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildDept(resList.get(i).get("deptCode").toString(), resList.get(i).get("deptName").toString()));
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

	@RequestMapping("/queryDepartmentMarketByUserCode")
	public void queryDepartmentMarketByUserCode(HttpServletRequest request, HttpServletResponse response, String upDept) {
		List<Map<String, Object>> list = umService.findDeptListByUserCode(getUser());
		List<Map<String, Object>> resList = null;
		if (list.size() == 1) {
			resList = departmentService.queryDepartmentMarketByUserCode(list.get(0), upDept);
			JSONArray result = new JSONArray();
			try {
				if (resList != null && resList.size() != 0) {
					result.add(buildDept("", "请选择"));
					for (int i = 0; i < resList.size(); i++) {
						result.add(buildDept(resList.get(i).get("deptCode").toString(), resList.get(i).get("deptName").toString()));
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
	}

	@RequestMapping("/queryDepartmentMarketBySaleman")
	public void queryDepartmentMarketBySaleman(HttpServletRequest request, HttpServletResponse response, String upDept, String deptCode) {
		List<Map<String, Object>> resList = null;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptCode", deptCode);
		resList = departmentService.queryDepartmentMarketByUserCode(map, upDept);
		JSONArray result = new JSONArray();
		try {
			if (resList != null && resList.size() != 0) {
				result.add(buildDept("", "请选择"));
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildDept(resList.get(i).get("deptCode").toString(), resList.get(i).get("deptName").toString()));
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
	 * 
	 * @param request
	 * @param response
	 * @param flag 传入的权限信息
	 * @author 康立新
	 */
	@RequestMapping("/queryProvinceCompany")
	public void queryProvinceCompany(HttpServletRequest request, HttpServletResponse response, String flag) {
		Map<String, Object> departMap = new HashMap<String, Object>();

		if (flag != null && (flag == "true" || flag.equals("true"))) {
			departMap.put("loginUserCode", "admin");
		} else {
			departMap.put("loginUserCode", getUser());
		}

		List<Map<String, Object>> resList = departmentService.queryProvince(departMap);

		JSONArray result = new JSONArray();
		try {
			if (resList != null && resList.size() != 0) {
				result.add(buildDept("", "请选择"));
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildDept(resList.get(i).get("deptCode").toString(), resList.get(i).get("deptSimepleName").toString()));
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
		// SendUtil.sendJSON(response, resList);
	}

	/**
	 * 根据权限查询用户所在机构
	 * 
	 * @param request
	 * @param response
	 * @param province
	 * @param flag 是否显示全部
	 * @author 康立新
	 */
	@RequestMapping("/queryCityCompany")
	public void queryCityCompany(HttpServletRequest request, HttpServletResponse response, String province, String flag) {
		Map<String, Object> departMap = new HashMap<String, Object>();

		if (flag != null && (flag == "true" || flag.equals("true"))) {
			departMap.put("loginUserCode", "admin");
		} else {
			departMap.put("loginUserCode", getUser());
		}

		departMap.put("province", province);
		List<Map<String, Object>> resList = departmentService.queryCity(departMap);
		JSONArray result = new JSONArray();
		try {
			if (resList != null && resList.size() != 0) {
				result.add(buildDept("", "请选择"));
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildDept(resList.get(i).get("deptCode").toString(), resList.get(i).get("deptSimepleName").toString()));
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
	 * 显示营服
	 * 
	 * @param request
	 * @param response
	 * @param city
	 * @param flag 是否显示全部
	 * @author 康立新
	 */
	@RequestMapping("/queryMarketingDept")
	public void queryMarketingDept(HttpServletRequest request, HttpServletResponse response, String city, String flag) {
		Map<String, Object> departMap = new HashMap<String, Object>();

		if (flag != null && (flag == "true" || flag.equals("true"))) {
			departMap.put("loginUserCode", "admin");
		} else {
			departMap.put("loginUserCode", getUser());
		}

		departMap.put("province", city);
		List<Map<String, Object>> resList = departmentService.queryMarketingDept(departMap);
		JSONArray result = new JSONArray();
		try {
			if (resList != null && resList.size() != 0) {
				result.add(buildDept("", "请选择"));
				for (int i = 0; i < resList.size(); i++) {
					result.add(buildDept(resList.get(i).get("deptCode").toString(), resList.get(i).get("deptSimepleName").toString()));
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

	@RequestMapping("/queryDeptDataGrid")
	public void queryDeptDataGrid(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		List<Map<String, Object>> list = umService.findDeptListByUserCode(getUser());
		List<Map<String, Object>> resList = null;
		if (list.size() == 1) {
			resList = departmentService.findDeptDataGridByWhere(list.get(0));
			JSONArray result = new JSONArray();
			try {
				if (resList != null && resList.size() != 0) {
					result.add(buildDept("", "请选择"));
					for (int i = 0; i < resList.size(); i++) {
						result.add(buildDept(resList.get(i).get("deptCode").toString(), resList.get(i).get("deptName").toString()));
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
	}

	@RequestMapping("/queryAllPrince")
	public void queryAllPrinceDept(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");

		PageDto pd = new PageDto();
		pd.setStart(startStr);
		pd.setLimit(limitStr);

		pd.setWhereMap(StringUtil.moveSpaceForMap(dto.getFormMap()));

		String level = dto.getFormMap().get("assignLevel").toString();

		if (level.equals("1")) {
			pd.getWhereMap().put("parentDept", "00");
			pd = departmentService.queryAllPrinceDept(pd);
		} else if (level.equals("2")) {
			pd = departmentService.queryAllPrinceDept(pd);
		} else if (level.equals("3")) {
			pd = departmentService.queryGroupByCityOrMarket(pd);
		} else if (level.equals("4")) {
			pd = departmentService.queryGroupUserByCityOrMarket(pd);
		}
		SendUtil.sendJSON(response, pd);
	}

	@RequestMapping("/generateDeptInfo")
	public void generateDeptInfo(HttpServletRequest request, HttpServletResponse response, String parentCode) throws GeneralException {
		Map<String, Object> param;
		try {
			param = departmentService.generateDeptInfo(parentCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("生成结构代码时出错，传入参数为：" + parentCode, e);
		}
		SendUtil.sendJSON(response, param);
	}

	@RequestMapping("/getDeptCodeByUser")
	public void getDeptCodeByUser(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		String deptCode = "";
		try {
			String loginUserCode = CurrentUser.getUser().getUserCode();
			deptCode = departmentService.getDefaultDeptCodeByUser(loginUserCode);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询登录用户所属机构错误！", e);
		}
		SendUtil.sendJSON(response, deptCode);
	}

	/**
	 * 拼装json字符串
	 * 
	 * @param id
	 * @param name
	 * @return JSONObject
	 */
	private JSONObject buildDept(String id, String name) {
		JSONObject result = new JSONObject();
		result.put("value", id);
		result.put("text", name);
		return result;
	}

}
