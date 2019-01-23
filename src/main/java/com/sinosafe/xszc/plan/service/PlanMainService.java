package com.sinosafe.xszc.plan.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.plan.vo.PlanMain;
import com.sinosafe.xszc.util.PageDto;

public interface PlanMainService {
	
	public boolean saveOrUpdatePlanMain(PlanMain planMain);
	
	public PlanMain selectByPrimaryKey(PlanMain planMain);

	public void deleteSalePlanDept(String planMainId);

	public void updateStuts(Map<String, Object> formMap);

	public List<PlanMain> queryAllPlanMain(PageDto pageDto);

	public long queryPlanOneByDept(Map<String, String> map);

}
