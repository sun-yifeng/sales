package com.sinosafe.xszc.review.service;

import com.alibaba.fastjson.JSONArray;
import com.sinosafe.xszc.review.vo.ReviewSalary;
import com.sinosafe.xszc.util.PageDto;

public interface ReviewSalaryService {

	PageDto findReviewSalaryByWhere(PageDto pageDto);

	PageDto queryDataToExcel(PageDto pageDto);

	void updateReviewSalary(ReviewSalary... reviewSalary);

	PageDto querySalaryConfirm(PageDto pageDto);
	
	void confirmReviewSalary(String deptCodeThree,String statMonth);

	boolean batchConfirmSalary(JSONArray reviewSalaryList);
}
