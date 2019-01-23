package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.RECOMMENDER;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.channel.service.RecommenderService;
import com.sinosafe.xszc.util.PageDto;

public class RecommenderServiceImpl implements RecommenderService {
	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	
	
	@Override
	public PageDto findRecommedersByWhere(PageDto pageDto) {
		Long total = dao.selectOne(RECOMMENDER + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(RECOMMENDER + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}



	@Override
	public void saveRecommender(Map<String, Object> paramMap) {
		paramMap.put("channelFlag", '4');
		dao.update(RECOMMENDER+".updateChannelFlag", paramMap);
		dao.insert(RECOMMENDER+".insertRecommender",paramMap);
	}



	@Override
	public PageDto findRecommenderByDeptCode(PageDto pageDto) {
		Long total = dao.selectOne(RECOMMENDER + ".queryRecommenderCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(RECOMMENDER + ".queryRecommenderByDeptCode", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}



	@Override
	public Map<String, Object> findRecommenderById(String recommenderId) {
		return dao.selectOne(RECOMMENDER + QUERY_ONE, recommenderId);
	}



	@Override
	public void updateRecommender(Map<String, Object> paramMap) {
		dao.update(RECOMMENDER + ".updateRecommender", paramMap);
	}



	@Override
	public void deleteRecommenderById(Map<String, Object> paramMap) {
		paramMap.put("channelFlag", '1');
		dao.update(RECOMMENDER+".updateChannelFlag",paramMap);
		dao.update(RECOMMENDER + ".deleteRecommenderById", paramMap);
	}



	@Override
	public int saveRecommendersApprove(List<String> recommenderIds) {
		Map<String, Object> param = null;
		int approveFail = 0;
		try {
			for (String recommenderId : recommenderIds) {
				param = new HashMap<String, Object>();
				param.put("recommender_id", recommenderId);
				dao.selectOne(RECOMMENDER + ".syncRecommenders", param);
				String resultCode = param.get("o_result_code").toString();
				if(resultCode.equals("1")){
					dao.update(RECOMMENDER + ".updateRowsApprove", recommenderId);
				}else{
					approveFail +=1;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return approveFail;
	}

}
