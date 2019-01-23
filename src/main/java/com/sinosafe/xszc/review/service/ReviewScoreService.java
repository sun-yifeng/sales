package com.sinosafe.xszc.review.service;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONArray;
import com.sinosafe.xszc.util.PageDto;

public interface ReviewScoreService {

	public PageDto findReviewScoreByWhere(PageDto pageDto);

	public void confirmReviewScore(String deptCode,String time);
	
	public PageDto findScoreCoutApplyByWhere(PageDto pageDto);
	
	PageDto queryStandToExcel(PageDto pageDto);

	public PageDto queryScoreConfirm(PageDto pageDto);
	
	public boolean batchConfirmScore(JSONArray reviewScoreList);
	
	//查询导出标保清单
	public PageDto queryPlyPrmListByWhere(PageDto pageDto);
	
	//查询导出赔付率
	public PageDto queryClmRateListByWhere(PageDto pageDto);
	
	public List<Map<String,Object>> queryTotalPremium(Map<String,Object> parmap);

}
