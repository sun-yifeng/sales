package com.sinosafe.xszc.survey.service;

import com.sinosafe.xszc.survey.vo.Survey;
import com.sinosafe.xszc.util.PageDto;

public interface SurveyService {

	 PageDto findSurveyByWhere(PageDto pageDto);

	void saveSurvey(Survey survey);

}
