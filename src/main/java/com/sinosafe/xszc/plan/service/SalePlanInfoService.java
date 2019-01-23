package com.sinosafe.xszc.plan.service;


import com.sinosafe.xszc.plan.vo.PlanMain;
import com.sinosafe.xszc.plan.vo.SalePlanInfo;
import com.sinosafe.xszc.util.PageDto;

public interface SalePlanInfoService {

	public PageDto findSalePlanInfoByWhere(PageDto pageDto);
	
	public void saveSalePlanInfo(SalePlanInfo salePlanInfo);
	
	public PageDto findSalePlanInfosByWhere(PageDto pageDto);

	public void updateSalePlanInfo(SalePlanInfo salePlanInfo);
	
	public boolean saveOrUpdateSalePlanInfo(PlanMain planMain);
	
	public PlanMain selectByPrimaryKey(PlanMain planMain);
}
