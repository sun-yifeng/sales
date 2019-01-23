package com.sinosafe.xszc.activity.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.util.PageDto;

/**
 * 活动管理模块业务处理逻辑接口
 * @author lixiaoliang
 *
 */
public interface ActivityService {

	public PageDto findActivityByWhere(PageDto pd);

	public PageDto findActivityFeedbackByWhere(PageDto pd);

	public Map<String, Object> findActivityForSummary(Map<String, Object> paraMap);

	public Boolean saveActivity(Map<String, Object> paraMap);

	public void saveSubmitActivity(Map<String, Object> paraMap);

	public void updateSummaryActivity(Map<String, Object> paraMap);

	/**
	 * 活动反馈保存
	 * 
	 * TODO 方法saveActivityFeedback的简要说明 <br>
	 * 
	 * <pre>
	 * 方法saveActivityFeedback的详细说明 <br>
	 * 编写者：李晓亮
	 * 创建时间：2014年8月5日 下午3:19:37
	 * </pre>
	 * 
	 * @param paraMap
	 * @return void 说明
	 * @throws 异常类型 说明
	 */
	public void saveActivityFeedback(Map<String, Object> paraMap);

	public Map<String, Object> findActivityDetailForFeedback(Map<String, Object> paraMap);

	public Map<String, Object> findActivityDetailByWhere(Map<String, Object> whereMap);

	public void updateFeedbackSubmit(Map<String, Object> paraMap);

	public PageDto findFeedback(PageDto pd);

	public Map<String, List<Map<String, Object>>> findDept(Map<String, Object> paramMap);

	public void deleteActivity(Map<String, Object> paraMap);
	
}
