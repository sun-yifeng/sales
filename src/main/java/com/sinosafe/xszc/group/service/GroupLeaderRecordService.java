package com.sinosafe.xszc.group.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.group.vo.GroupLeaderRecord;
import com.sinosafe.xszc.group.vo.Salesman;

public interface GroupLeaderRecordService {
	
	void saveGroupLeaderRecord(GroupLeaderRecord... groupLeaderRecord);
	
	void updateGroupLeaderRecord(GroupLeaderRecord... groupLeaderRecord);
	
	void updateSaleRank(Salesman salesman);
	
	//查询团队长名称
	List<Map<String,Object>> queryGroupLeaderName(Map<String,Object> whereMap);
}
