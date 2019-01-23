package com.sinosafe.xszc.plan.service;

import com.sinosafe.xszc.plan.vo.PlanChannelDetail;
import com.sinosafe.xszc.plan.vo.PlanMain;
import com.sinosafe.xszc.plan.vo.SalePlanChannel;
import com.sinosafe.xszc.util.PageDto;

public interface SalePlanChannelService {
	
	 
	 void saveSalePlanChannel(PlanChannelDetail planChannelDetail );
	
	 PageDto findSalePlanChannelByWhere(PageDto pageDto);

	 void updateSalePlanChannel(PlanMain planMain);
	
	 void saveSallePlanChannel(PlanMain planMain);
	 
	PlanMain querySalePlanChannelByVo(PlanMain planMain,String ChannelRiskType);

	PageDto findSalePlanChannel(PageDto pageDto);

	PlanMain queryPlanMainByVo(PlanMain planMain);

	PageDto queryAllSalePlanChannel(PageDto pageDto);
}
