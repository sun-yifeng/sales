package com.sinosafe.xszc.review.service;

import java.util.Map;

import com.sinosafe.xszc.review.vo.ReviewRank;
import com.sinosafe.xszc.util.PageDto;

public interface ReviewRankService {

	// 职级查询
	PageDto findReviewRankByWhere(PageDto pageDto);

	// 导出
	PageDto queryDataToExcel(PageDto pageDto);

	void saveReviewRank(ReviewRank... reviewRank);

	// 修改确认状态
	void updateReviewRank(ReviewRank... reviewRank);

	void changeReviewRank(Map<String, Object> whereMap);

	// 职级调整
	void updateRankAdjust(ReviewRank... reviewRank);

	// 人员职级调整
	void updateSalesRank(ReviewRank... reviewRank);

	// 查询单条数据详细
	ReviewRank findReviewRankDetailByPK(String rankId);
	
	Map<Object,String> queryComAndCusRank(String rankId);

	boolean findRankAuditFlag(String rankCode);

	//批量
	boolean batchConfirmRank(String rankIds);

	PageDto queryReviewRankHistory(PageDto pageDto);
	
	long queryReviewRank(String salesmanCode);
	
	//月度固定工资
	boolean queryMonthSalary(Map<String,Object> parmMap);
	
	String queryRankName(String rankCode);

	boolean batchRecoverRank(String salesmanCodes, String calcMonth);
	
}
