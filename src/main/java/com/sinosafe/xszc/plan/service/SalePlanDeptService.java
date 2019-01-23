package com.sinosafe.xszc.plan.service;


import java.util.Map;

import com.sinosafe.xszc.plan.vo.PlanMain;
import com.sinosafe.xszc.util.PageDto;

public interface SalePlanDeptService {

	void saveSallePlanDept(PlanMain planInfo);

	PageDto findSalePlanDept(PageDto pageDto);

	PlanMain querySalePlanDeptByVo(PlanMain planInfo);

	void deleteSalePlanDept(String planMainId);

	String updateStuts(Map<String, Object> formMap);

	PageDto queryAllSalePlanDept(PageDto pageDto);

	long querySalePlanOneByDept(String deptCode, Integer year);

}
