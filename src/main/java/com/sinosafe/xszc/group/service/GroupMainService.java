package com.sinosafe.xszc.group.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.group.vo.GroupMain;
import com.sinosafe.xszc.util.PageDto;

public interface GroupMainService {
	
	PageDto findGroupMainByWhere(PageDto pageDto);
	
	PageDto findGroupMainsByWhere(PageDto pageDto);
	
	PageDto findGroupMainDetailByWhere(PageDto pageDto);
	
	void saveGroupMain(GroupMain... groupMain);
	
	void updateGroupMain(GroupMain... groupMain);
	  
	Long findGroupMainByCount(GroupMain... groupMain);
	
	//查询四级机构下的所有团队
	List<Map<String, Object>> queryDeptGroup(Map<String, Object> userMap);
	
	//主页查询团队长名称用于显示
	List<Map<String,Object>> queryGroupCname(Map<String,Object> whereMap);
	
	//分页查询团队，附加是否设定团队长
	PageDto findGroupMainByWheres(PageDto pageDto);
	
	//根据团队名称查询是否已经存在
	Long findGroupNameByCount(Map<String,Object> whereMap);
	
	String findGroupLeaderCname(String groupCode);
	
	//软删除非HR人员
	void deleteGroupMain(GroupMain groupMain);

	List<Map<String, Object>> queryGroupListForLawImp(Map<String, Object> whereMap);

	GroupMain findGroupByPrimaryKey(String groupCode);
	
	PageDto queryGroupMember(PageDto pageDto);
	
	PageDto queryTrueGroupMember(PageDto pageDto);
	
	PageDto queryGroupMemberDetail(PageDto pageDto);
	
	String quertGroupType(Map<String,Object> whereMap);
}
