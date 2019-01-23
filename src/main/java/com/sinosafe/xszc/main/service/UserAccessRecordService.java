package com.sinosafe.xszc.main.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.main.vo.UserAccessRecord;
import com.sinosafe.xszc.util.PageDto;

/**
 * 类名:com.sinosafe.xszc.main.service.UserAccessRecordService <pre>
 * 描述:用户访问记录服务接口
 * 编写者:卢水发
 * 创建时间:2015年7月21日 上午11:28:41
 * </pre>
 */
public interface UserAccessRecordService {
	
	PageDto findUserAccessRecordToPage(PageDto pageDto);
	
	boolean isExist(String pkid);

	boolean saveOrUpdateByWhere(UserAccessRecord uar);

	List<Map<String, Object>> queryDataVisitReport(Map<String, Object> whereMap);

	List<Map<String, Object>> queryPageVisitReport(Map<String, Object> whereMap);

	PageDto queryUserVisitReport(PageDto pageDto);
	
}
