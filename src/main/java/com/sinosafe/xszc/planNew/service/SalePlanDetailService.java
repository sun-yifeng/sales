package com.sinosafe.xszc.planNew.service;


import java.util.List;
import java.util.Map;
import java.util.Set;

import com.sinosafe.xszc.planNew.vo.PlanDetailNew;
import com.sinosafe.xszc.planNew.vo.PlanMainNew;
import com.sinosafe.xszc.util.PageDto;

public interface SalePlanDetailService {

	void savePlanWithDetail(PlanMainNew planInfo);
	
	void savePlanWithDetail(PlanMainNew planMain,List<PlanDetailNew> detailList);

	PageDto findPlanDetailToPage(PageDto pageDto);

	PlanMainNew queryPlanDetailToVo(PlanMainNew planInfo);

	void delPlanDetail(String planMainId);

	String updateStatus(Map<String, Object> formMap);

	PageDto queryPlanWidthDetailToPage(PageDto pageDto);

	long querySalePlanOneByDept(String deptCode, Integer year);

	boolean isExist(String detailId);

	boolean genDeptPlanDetailXls(String savePath,String deptCode);

	boolean batchSaveDataInXls(String filePath,String planType,String planYear);

	Set<PlanDetailNew> querySalePlanDetailListByPlanId(String planMainId);

	PlanMainNew querySalePlanByVo(String planMainId);


}
