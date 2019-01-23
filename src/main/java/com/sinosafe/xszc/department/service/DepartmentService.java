package com.sinosafe.xszc.department.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.department.vo.Department;
import com.sinosafe.xszc.util.PageDto;

public interface DepartmentService {

	Map<String, Object> findUmDepartmentMap(String dptCde);

	Department findDepartmentVo(String deptCode);

	Map<String, Object> generateDeptInfo(String parentCode);

	List<Map<String, Object>> findDepartmenByLevel(Map<String, Object> map);

	List<Map<String, Object>> findParentDept(Map<String, Object> whereMap);

	List<Map<String, Object>> findDeptDropListByLevel(Map<String, Object> map);

	List<Map<String, Object>> findDeptDropListByParent(Map<String, Object> whereMap);
	
	List<Map<String, Object>> findDeptDropListByDept(Map<String, Object> whereMap);

	List<Map<String, Object>> findDepartmentMapByWhere(Map<String, Object> whereMap);

	List<Department> findUmDepartmentVoByWhere(Map<String, Object> whereMap);

	List<Map<String, Object>> findUmUserToUmDepartment(String dptCde);

	List<Map<String, Object>> findDepartmenAll(Map<String, Object> map);

	List<Map<String, Object>> findDepartmenByParent(Map<String, Object> map);

	List<Map<String, Object>> findHrDepartmenAll(Map<String, Object> map);

	List<Map<String, Object>> queryPidByUserCode(Map<String, Object> map);

	List<Map<String, Object>> queryDeptCodeByUserCode(Map<String, Object> map);

	List<Map<String, Object>> queryDepartByDeptCode(List<String> list);

	List<Map<String, Object>> queryHrDepartByUserCode(Map<String, Object> map);

	List<Map<String, Object>> queryProvince(Map<String, Object> map);

	List<Map<String, Object>> queryCity(Map<String, Object> departMap);

	List<Map<String, Object>> queryMarketingDept(Map<String, Object> departMap);

	// 查询本级的名称用于修改页面显示
	List<Map<String, Object>> findParentDepts(Map<String, Object> whereMap);

	List<Map<String, Object>> findDeptDataGridByWhere(Map<String, Object> map);

	List<Map<String, Object>> queryDepartmentByUserCode(Map<String, Object> map);

	List<Map<String, Object>> queryDepartmentCityByUserCode(Map<String, Object> map, String upDept);

	List<Map<String, Object>> queryDepartmentMarketByUserCode(Map<String, Object> map, String upDept);

	String saveDepartment(Department dept);

	int findDeptLevel(String deptCode);

	boolean existDeptpartment(String deptCode);

	String updateDepartment(Department dept);

	String removeDepartment(Map<String, Object> whereMap);

	PageDto findUserByWhere(PageDto pageDto);

	String getDeptCodeByUser(String UserCode);

	boolean existChildDepartment(String deptCode);

	PageDto queryAllPrinceDept(PageDto pd);

	PageDto queryGroupByCityOrMarket(PageDto pd);

	PageDto queryGroupUserByCityOrMarket(PageDto pd);

	String getDefaultDeptCodeByUser(String loginUserCode);

	List<Map<String, Object>> findDeptListByParentCode(String deptCode);

	public List<Map<String, Object>> queryDeptLevelInfo(Map<String,String> parameter);
}
