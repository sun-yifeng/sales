package com.sinosafe.xszc.group.service;

import com.sinosafe.xszc.group.vo.GroupChangeRecord;

public interface GroupChangeRecordService {

	void saveGroupChangeRecord(GroupChangeRecord... groupChangeRecord);
	
	void updateGroupChangeRecord(GroupChangeRecord... groupChangeRecord);
	
	Long findGroupChangeRecordByCount(GroupChangeRecord... groupChangeRecord);
}
