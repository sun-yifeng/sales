package com.sinosafe.xszc.planNew.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.planNew.vo.PlanMainNew;
import com.sinosafe.xszc.util.PageDto;

public interface PlanMainService {
	
	public boolean saveOrUpdate(PlanMainNew PlanMainNew);
	
	public PlanMainNew selectByPrimaryKey(PlanMainNew PlanMainNew);

	public void deleteSalePlanDept(String PlanMainNewId);

	public void updateStuts(Map<String, Object> formMap);

	public List<PlanMainNew> queryAllPlanMain(PageDto pageDto);

	public long queryPlanOneByDept(Map<String, String> map);

	boolean isExist(String planMainId);

	public boolean isExist(String deptCode, Integer year);

	public PlanMainNew selectByDeptYear(String deptCode, Integer year);

	public void delPlanMainById(String planMainId);

}
