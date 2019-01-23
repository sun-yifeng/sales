package com.sinosafe.xszc.review.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.TLawRate;
import com.sinosafe.xszc.review.vo.NewYearReward;
import com.sinosafe.xszc.util.PageDto;

public interface NewYearRewardService {

	//批量
	boolean saveNewYearRewardInXls(Map<String, Object> rewardMap);
	
	PageDto queryNewYearRewardToPage(PageDto pageDto);
	
	public boolean genRateSafeTypeModelXls(Map<String, Object> paramMap);
	
	public boolean updateChange(List<NewYearReward> rewardList);
	
	public Map<String, Object> queryAllEmployAndSalary(Map<String, Object> paramMap);
	
}
