package com.sinosafe.xszc.channel.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.util.PageDto;

public interface RecommenderService {
	
	public PageDto findRecommedersByWhere(PageDto pageDto);
	
	public void saveRecommender(Map<String, Object> paramMap);
	
	public PageDto findRecommenderByDeptCode(PageDto pageDto);
	
	public Map<String, Object> findRecommenderById(String recommenderId);
	
	public void updateRecommender(Map<String, Object> paramMap);
	
	public void deleteRecommenderById(Map<String, Object> paramMap);
	
	public int saveRecommendersApprove(List<String> pkIds);
}
