package com.sinosafe.xszc.main.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.util.PageDto;

public interface MainFrameService {

	List<Map<String, Object>> findSystemMenus(Map<String, Object> whereMap);

	List<Map<String, Object>> findSystemMenus(String userCode, String sysCode);

	long findSalesmanCount(Map<String, Object> whereMap);

	long findMediumCount(Map<String, Object> whereMap);
	
	long findAgentCount(Map<String, Object> whereMap);
	
	long findConferMediumCount(Map<String, Object> whereMap);
	
	long findConferAgentCount(Map<String, Object> whereMap);

	long findNoticeCount(Map<String, Object> whereMap);
	
	long findEmployThreeNoticeCount(Map<String, Object> whereMap);
	
	long findEmploySixNoticeCount(Map<String, Object> whereMap);

	PageDto getMediumValidList(PageDto pageDto);

	PageDto getAgentValidList(PageDto pageDto);

	PageDto getMediumConferValidList(PageDto pageDto);

	PageDto getAgentConferValidList(PageDto pageDto);

	PageDto findSalesmanTipList(PageDto pageDto);

	PageDto findNoticeTipList(PageDto pageDto);
	
	PageDto findEmployThreeNotice(PageDto pageDto);
	
	PageDto findEmploySixNotice(PageDto pageDto);

	/**
	 * <pre>
	 * 取登录用户在UM的角色
	 * @return
	 * </pre>
	 */
	List<Map<String, Object>> getUmRole();

	/**
	 * 简要说明:是否存在某个角色 <br><pre>
	 * 编写者:卢水发
	 */
	boolean existsRole(String[] roleArray,List<Map<String, Object>> roleListUser);

}
