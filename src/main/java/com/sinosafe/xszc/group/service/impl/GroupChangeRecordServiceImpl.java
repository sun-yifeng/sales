package com.sinosafe.xszc.group.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.GROUP_CHANGE_RECORD;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.group.service.GroupChangeRecordService;
import com.sinosafe.xszc.group.vo.GroupChangeRecord;

public class GroupChangeRecordServiceImpl implements GroupChangeRecordService{

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Override
	public void saveGroupChangeRecord(GroupChangeRecord... groupChangeRecord) {
		if (groupChangeRecord != null && groupChangeRecord.length > 0) {
			for (int i = 0; i < groupChangeRecord.length; i++) {
				dao.insert(GROUP_CHANGE_RECORD + INSERT_VO, groupChangeRecord[i]);
			}
		} else {
			throw new RuntimeException("没有要添加的版本定义，参数为null或长度为0");
		}
	}

	@Override
	public void updateGroupChangeRecord(GroupChangeRecord... groupChangeRecord) {
		if (groupChangeRecord != null && groupChangeRecord.length > 0) {
			for (int i = 0; i < groupChangeRecord.length; i++) {
				dao.update(GROUP_CHANGE_RECORD + ".updateGroupChangeRecord", groupChangeRecord[i]);
			}
		} else {
			throw new RuntimeException("没有要修改的版本定义，参数为null或长度为0");
		}
		
	}
	
	//查询机构下级团队，尾数最大的团队加 1
	@Override
	public Long findGroupChangeRecordByCount(GroupChangeRecord... groupChangeRecord) {
		Long total = dao.selectOne(GROUP_CHANGE_RECORD + ".queryCounts", groupChangeRecord[0]);
		return total;
	}

}
