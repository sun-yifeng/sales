package com.sinosafe.xszc.group.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.GROUP_LEADER_RECORD;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.GROUP_MAIN;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SALESMAN;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.group.service.GroupLeaderRecordService;
import com.sinosafe.xszc.group.vo.GroupLeaderRecord;
import com.sinosafe.xszc.group.vo.GroupMain;
import com.sinosafe.xszc.group.vo.Salesman;

public class GroupLeaderRecordServiceImpl implements GroupLeaderRecordService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public void saveGroupLeaderRecord(GroupLeaderRecord... groupLeaderRecord) {
		if (groupLeaderRecord != null && groupLeaderRecord.length > 0) {
			// 设置团队长前把团队信息保存到历史记录
			GroupMain groupMain = new GroupMain();
			groupMain.setUpdatedUser(CurrentUser.getUser().getUserCode());
			groupMain.setHistoryId(UUIDGenerator.getUUID());
			groupMain.setGroupCode(groupLeaderRecord[0].getGroupCode());
			dao.insert(GROUP_MAIN + ".insertGroupMainHistory", groupMain);
			for (int i = 0; i < groupLeaderRecord.length; i++) {
				dao.insert(GROUP_LEADER_RECORD + ".insertVo", groupLeaderRecord[i]);
				// 更新团队统计标志位
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("statFlag", "1");
				paramMap.put("groupCode", groupLeaderRecord[i].getGroupCode());			
				dao.update(GROUP_LEADER_RECORD + ".updateGroupMainStatFlag", paramMap);
			}
		} else {
			throw new RuntimeException("设置团队长时，出现异常！");
		}

	}

	@Override
	public void updateGroupLeaderRecord(GroupLeaderRecord... groupLeaderRecord) {
		if (groupLeaderRecord != null && groupLeaderRecord.length > 0) {
			// 撤销团队长前保存历史记录
			GroupMain groupMain = new GroupMain();
			String idNumber = UUIDGenerator.getUUID();
			groupMain.setHistoryId(idNumber);
			groupMain.setUpdatedUser(CurrentUser.getUser().getUsername());
			groupMain.setGroupCode(groupLeaderRecord[0].getGroupCode());
			// 把修改的团队信息保存到团队历史轨迹表里group_main_history
			dao.insert(GROUP_MAIN + ".insertGroupMainHistory", groupMain);
			// 把之前的团队长信息保存到历史轨迹表里group_leader_history
			groupLeaderRecord[0].setHistoryId(idNumber);
			dao.insert(GROUP_LEADER_RECORD + ".insertLeaderHistory", groupLeaderRecord[0]);
			for (int i = 0; i < groupLeaderRecord.length; i++) {
				dao.update(GROUP_LEADER_RECORD + ".updateByPrimaryKeySelectiveVo", groupLeaderRecord[i]);
				// 更新团队统计标志位
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("statFlag", "0");
				paramMap.put("groupCode", groupLeaderRecord[i].getGroupCode());			
				dao.update(GROUP_LEADER_RECORD + ".updateGroupMainStatFlag", paramMap);
			}
		} else {
			throw new RuntimeException("撤销团队长时，出现异常！");
		}
	}

	@Override
	public List<Map<String, Object>> queryGroupLeaderName(Map<String, Object> whereMap) {
		List<Map<String, Object>> result = dao.selectList(GROUP_LEADER_RECORD + ".queryGroupLeaderName", whereMap);
		return result;
	}

	@Override
	public void updateSaleRank(Salesman salesman) {
		dao.update(SALESMAN + ".updateSaleRank", salesman);
	}

}
