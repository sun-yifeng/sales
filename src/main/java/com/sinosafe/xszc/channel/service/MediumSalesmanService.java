package com.sinosafe.xszc.channel.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.channel.vo.MediumSalesman;
import com.sinosafe.xszc.law.vo.TLawRate;
import com.sinosafe.xszc.review.vo.NewYearReward;
import com.sinosafe.xszc.util.PageDto;

public interface MediumSalesmanService {

	Map<String,Object> saveMediumSalesmanInXls(Map<String, Object> salesman);
	
	PageDto queryMediumSalesmanToPage(PageDto pageDto);
	
	public boolean downloadSalesmanModel(Map<String, Object> paramMap);
	
	public boolean updateChange(List<MediumSalesman> rewardList);
	
	public int saveRowsApprove(List<String> pkIds);
	
	public void saveSalesmanAdd(Map<String, Object> paramMap);
	
	boolean querySalesmanId(String idCard);
	
}
