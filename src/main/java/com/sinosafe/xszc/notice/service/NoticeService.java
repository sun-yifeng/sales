package com.sinosafe.xszc.notice.service;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.util.PageDto;

/**
 * 活动管理模块业务处理逻辑接口
 * @author maguang
 *
 */
public interface NoticeService {

	public PageDto findNoticeByWhere(PageDto pd,String action);

	public Map<String, Object> findNoticeDetailByWhere(Map<String, Object> whereMap);

	public PageDto findNoticeFeedbackByWhere(PageDto pd);

	public PageDto findNoticeForDealByWhere(PageDto pd);
	
	public List<Map<String, Object>> findNoticeWithoutWeek();
	
	public Map<String, Object> findNoticeFeedbackForDeal (String feedbackId);

	public Boolean saveNotice(Map<String, Object> paraMap);

	public void saveSubmitNotice(Map<String, Object> paraMap);

	public void updateSummaryNotice(Map<String, Object> paraMap);

	public List<Map<String, Object>> queryAllReceiveDept(Map<String, Object> moveSpaceForMap);
	
	public List<Map<String, Object>> queryAllReceiveRole(Map<String, Object> moveSpaceForMap);

	public Boolean saveNoticeFeedback(Map<String, Object> paraMap);

	public Boolean saveNoticeDeal(Map<String, Object> paraMap);

	public Boolean deleteNoticeByIds(String[] noticIdArray) throws ParseException;
	
	public PageDto findNoticeFeedbackByNoticId(PageDto pd);
	
	public Map<String, Object> findNoticeFeeBackDetailByWhere(Map<String, Object> paraMap);

	public PageDto findNoticeDealByWhere(PageDto pd);

	public Boolean argueNoticeDeal(Map<String, Object> paraMap);

	public void publishNoticeByDate();

	public Boolean validNoticeByIds(String[] noticIdArray) throws ParseException;

	public Boolean updateNotice(Map<String, Object> paraMap);
	
	public List<String> filterSubBusinessLines();
	
	public Map<String,String> getRoleConfigureMap();
	
	public List<Map<String,Object>> queryTimingUploadMajor(Map<String, Object> paraMap);
	
	public List<Map<String,Object>> queryTimingUploadFeedback(Map<String, Object> paraMap);
	
	public List<String> getAllRoleENameByBusinessLine(String[] businessLine);
	
	public boolean feedbackIsEffective(String feedbackId);
	
	public List<Map<String,String>> getBusinessLineInfo(List<String> subBusinessLines);
	
	public List<Map<String, String>> queryBusinessline(List<String> subBusinessLines);
}
