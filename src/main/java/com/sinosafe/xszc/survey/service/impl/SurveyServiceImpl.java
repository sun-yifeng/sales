package com.sinosafe.xszc.survey.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SURVEY;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.survey.service.SurveyService;
import com.sinosafe.xszc.survey.vo.Survey;
import com.sinosafe.xszc.util.PageDto;

public class SurveyServiceImpl implements SurveyService {
	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Override
	public PageDto findSurveyByWhere(PageDto pageDto) {
		Long total = dao.selectOne(SURVEY + ".queryCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(SURVEY+ ".queryListPage", pageDto.getWhereMap());
		
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void saveSurvey(Survey survey) {
		dao.insert(SURVEY+ INSERT_VO, survey);
	}
	
}
