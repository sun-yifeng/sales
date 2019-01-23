package com.sinosafe.xszc.group.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.group.vo.Salesman;
import com.sinosafe.xszc.util.PageDto;

public interface SalesmanService {

	PageDto findSalesmanByWhere(PageDto pageDto);

	PageDto findSalesmanHistoryByWhere(PageDto pageDto);

	PageDto findSalesmansByWhere(PageDto pageDto);

	PageDto findSalesmansDetailByWhere(PageDto pageDto);

	PageDto findSalesmansOfLastInfoByWhere(PageDto pageDto);

	void saveSalesman(Salesman... salesman);

	void updateSalesman(Salesman salesman);
	
	void insertGroupMember(Map<String, Object> whereMap);

	// 主页查询团队长名称用于显示
	List<Map<String, Object>> queryUserCname(Map<String, Object> whereMap);

	// 查询团队下的所有员工
	List<Map<String, Object>> queryGroupSalesman(Map<String, Object> userMap);

	// 查询HR人员的name和code，用于非HR人员新增
	List<Map<String, Object>> queryNameAndCode(Map<String, Object> userMap);

	List<Map<String, Object>> querySalesmanInfoByCode(String salesmanCode);

	void resetSalesman(String salesmanCode);

	List<Map<String, Object>> getMultiDeptInfo(List<Map<String, Object>> rows);

	List<Map<String, Object>> querySaleManList(Map<String, Object> whereMap);

	Salesman findSalesmanByPrimaryKey(String salesmanCode);

	List<Map<String, Object>> querySalemanForLawImp(Map<String, Object> whereMap);
	
	String querySalesDirector(String salesmanCode);
	
	void recoverDelStatus(String salesmanCode);
	
	void updateGroupMember(Map<String, Object> whereMap);
	
	List<Map<String, Object>> querySalesmanHisHr(Map<String, Object> whereMap);
	
	void updateSalesmanDate(Map<String, Object> whereMap);

	PageDto querySalesmanRecord(PageDto pageDto);
}
