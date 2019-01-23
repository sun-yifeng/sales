package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_NODE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_NODE_ACCOUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ID_LIST;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LISTS_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SALESMAN;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SALESMAN_VIRTUAL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.channel.service.ChannelMainService;
import com.sinosafe.xszc.channel.service.ChannelMaintainService;
import com.sinosafe.xszc.channel.service.MediumNodeService;
import com.sinosafe.xszc.channel.vo.ChannelMediumMaintain;
import com.sinosafe.xszc.channel.vo.ChannelMediumNode;
import com.sinosafe.xszc.channel.vo.ChannelMediumNodeAccount;
import com.sinosafe.xszc.util.PageDto;

public class MediumNodeServiceImpl implements MediumNodeService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "ChannelMaintainService")
	private ChannelMaintainService channelMaintainService;
	
	@Autowired
	@Qualifier("ChannelMainService")
	private ChannelMainService channelMainService;

	@Override
	public Map<String, String> saveMediumNode(ChannelMediumNode mediumNode) {
		// 查询该网点所属中介机构是否还有其他网点
		Long total = dao.selectOne(MEDIUM_NODE + QUERY_COUNT_VO, mediumNode);
		if (total == 0) {
			mediumNode.setGetFlag("1"); //核心取数标识
		}

		mediumNode.setNodeCode(UUIDGenerator.getUUID());
		mediumNode.setCloseFlag("0"); //未关停
		
		// 保存远程出单点
		dao.insert(MEDIUM_NODE + INSERT_VO, mediumNode);

		// 保存出单点账户
		if (mediumNode.getChannelMediumNodeAccount().size() > 0) {
			for (ChannelMediumNodeAccount channelMediumNodeAccount : mediumNode.getChannelMediumNodeAccount()) {
				String accountId = UUIDGenerator.getUUID();// 生成主键
				channelMediumNodeAccount.setAccountId(accountId);
				channelMediumNodeAccount.setNodeCode(mediumNode.getNodeCode());
				channelMediumNodeAccount.setCreatedUser(mediumNode.getCreatedUser());
				channelMediumNodeAccount.setUpdatedUser(mediumNode.getUpdatedUser());
				channelMediumNodeAccount.setValidInd("1");
				dao.insert(MEDIUM_NODE_ACCOUNT + INSERT_VO, channelMediumNodeAccount);
			}
		}

		// 保存维护人信息
		if (mediumNode.getChannelMediumMaintain().size() > 0) {
			for (ChannelMediumMaintain channelMaintain : mediumNode.getChannelMediumMaintain()) {
				String pkId = UUIDGenerator.getUUID();// 生成主键
				channelMaintain.setMaintainId(pkId);
				channelMaintain.setNodeCode(mediumNode.getNodeCode());
				channelMaintain.setChannelCode(mediumNode.getChannelCode());
				channelMaintain.setCreatedUser(mediumNode.getCreatedUser());
				channelMaintain.setUpdatedUser(mediumNode.getUpdatedUser());
				channelMaintain.setValidInd("1");
				channelMaintainService.saveChannelMaintain(channelMaintain);
			}
		}
		return channelMainService.channelSync(mediumNode.getChannelCode().split(","));
	}

	@Override
	public PageDto findMediumNodeByWhere(PageDto pageDto) {
		Long total = dao.selectOne(MEDIUM_NODE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_NODE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Map<String, String> updateMediumNode(ChannelMediumNode mediumNode) {
		// 更新网点信息
		dao.update(MEDIUM_NODE + UPDATE_VO, mediumNode);

		// 查询该网点数据库中原有的所有有效出单点
		List<ChannelMediumNodeAccount> accountIdListDB = dao.selectList(MEDIUM_NODE_ACCOUNT + QUERY_ID_LIST, mediumNode.getNodeCode());
		// 查询该中介数据库中原有的所有有效维护人
		List<ChannelMediumMaintain> maintainDB = channelMaintainService.queryIdList(mediumNode.getNodeCode());

		// 保存出单账号信息
		if (mediumNode.getChannelMediumNodeAccount().size() > 0) {
			for (ChannelMediumNodeAccount channelMediumNodeAccount : mediumNode.getChannelMediumNodeAccount()) {
				String accountId = channelMediumNodeAccount.getAccountId();
				// 如果账号ID非空，则是已有账号
				if (accountId != null && accountId != "") {
					if (accountIdListDB.size() > 0) {
						// 拿前台数据与数据库的对比，如果匹配则从accountIdListDB中移除，accountIdListDB中余下的则是要删除的数据
						for (int i = 0; i < accountIdListDB.size(); i++) {
							ChannelMediumNodeAccount tmpAccount = accountIdListDB.get(i);
							if (channelMediumNodeAccount.getAccountId().equals(tmpAccount.getAccountId())) {
								accountIdListDB.remove(tmpAccount);
								continue;
							}
						}
					}
					channelMediumNodeAccount.setUpdatedUser(mediumNode.getUpdatedUser());
					dao.update(MEDIUM_NODE_ACCOUNT + UPDATE_VO, channelMediumNodeAccount);
				}
				// 如果账号ID为空，则是新增账号
				else {
					String accountId1 = UUIDGenerator.getUUID();
					channelMediumNodeAccount.setAccountId(accountId1);
					channelMediumNodeAccount.setNodeCode(mediumNode.getNodeCode());
					channelMediumNodeAccount.setCreatedUser(mediumNode.getUpdatedUser());
					channelMediumNodeAccount.setUpdatedUser(mediumNode.getUpdatedUser());
					channelMediumNodeAccount.setValidInd("1");
					dao.insert(MEDIUM_NODE_ACCOUNT + INSERT_VO, channelMediumNodeAccount);
				}
			}
		}

		// 保存维护人信息
		if (mediumNode.getChannelMediumMaintain().size() > 0) {
			for (ChannelMediumMaintain channelMaintain : mediumNode.getChannelMediumMaintain()) {
				String pkId = channelMaintain.getMaintainId();
				// 如果pkId非空，则是已有维护人
				if (pkId != null && pkId != "") {
					if (maintainDB.size() > 0) {
						// 拿前台数据与数据库的对比，如果匹配则从maintainDB中移除，maintainDB中余下的则是要删除的数据
						for (int i = 0; i < maintainDB.size(); i++) {
							ChannelMediumMaintain tmpMaintain = maintainDB.get(i);
							if (channelMaintain.getMaintainId().equals(tmpMaintain.getMaintainId())) {
								maintainDB.remove(tmpMaintain);
								continue;
							}
						}
					}
					channelMaintain.setUpdatedUser(mediumNode.getUpdatedUser());
					channelMaintainService.updateChannelMaintain(channelMaintain);
				}
				// 如果账号pkId为空，则是新增维护人
				else {
					pkId = UUIDGenerator.getUUID();
					channelMaintain.setMaintainId(pkId);
					channelMaintain.setNodeCode(mediumNode.getNodeCode());
					channelMaintain.setChannelCode(mediumNode.getChannelCode());
					channelMaintain.setCreatedUser(mediumNode.getUpdatedUser());
					channelMaintain.setUpdatedUser(mediumNode.getUpdatedUser());
					channelMaintain.setValidInd("1");
					channelMaintainService.saveChannelMaintain(channelMaintain);
				}
			}
		}
		
		// 删除出单点
		String accountIds = "";
		Map<String, Object> whereMap1 = new HashMap<String, Object>();
		for (int i = 0; i < accountIdListDB.size(); i++) {
			accountIds += "," + accountIdListDB.get(i).getAccountId();
		}
		if (accountIds != "") {
			whereMap1.put("updatedUser", CurrentUser.getUser().getUserCode());
			whereMap1.put("pkIds", accountIds.substring(1).split(","));
			dao.update(MEDIUM_NODE_ACCOUNT + ".deleteAccount", whereMap1);
		}
		
		// 删除维护人
		String pkIds = "";
		Map<String, Object> whereMap2 = new HashMap<String, Object>();
		for (int i = 0; i < maintainDB.size(); i++) {
			pkIds += "," + maintainDB.get(i).getMaintainId();
		}
		if (pkIds != "") {
			whereMap2.put("updatedUser", CurrentUser.getUser().getUserCode());
			whereMap2.put("pkIds", pkIds.substring(1).split(","));
			channelMaintainService.deleteChannelMediumMaintain(whereMap2);
		}
		return channelMainService.channelSync(mediumNode.getChannelCode().split(","));
	}

	@Override
	public PageDto findMediumNodesByWhere(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_NODE + QUERY_LISTS_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Boolean queryChannelCode(String nodeCode) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("nodeCode", nodeCode);
		Long total = dao.selectOne(MEDIUM_NODE + QUERY_COUNT, map);
		if (total > 0) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public PageDto findMediumNodeAccountByWhere(PageDto pageDto) {
		Long total = dao.selectOne(MEDIUM_NODE_ACCOUNT + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_NODE_ACCOUNT + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public List<Map<String, Object>> queryDeptSalesman(Map<String, Object> userMap) {
		List<Map<String, Object>> resultList = dao.selectList(SALESMAN + ".queryDeptSalesman", userMap);
		return resultList;
	}

	@Override
	public void deleteMediumNode(String nodeCode, String channelCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("nodeCode", nodeCode);
		map.put("channelCode", channelCode);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		// 删除网点主表信息
		dao.update(MEDIUM_NODE + DELETE_BY_ID, map);
		// 更新删除操作影响到的核心取数标记字段相关的网点
		dao.update(MEDIUM_NODE + ".updaGetFlagByChannelCode", map);
	}
	
	@Override
	public void closeMediumNode(String nodeCode, String channelCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("nodeCode", nodeCode);
		map.put("channelCode", channelCode);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		// 关停远程出单点
		dao.update(MEDIUM_NODE + ".closeChannelMediumNode", map);
		// 更新关停操作影响到的核心取数标记字段相关的网点
		dao.update(MEDIUM_NODE + ".updaGetFlagByChannelCode", map);
		
	}

	@Override
	public List<Map<String, Object>> querySalesmanEmpCode(Map<String, Object> userMap) {
		List<Map<String, Object>> resultList = null;
		String salesmanType = (String) userMap.get("salesmanType");
		if ("1".equals(salesmanType)) {
			resultList = dao.selectList(SALESMAN + ".querySalesmanEmpCode", userMap);
		} else if ("0".equals(salesmanType)) {
			resultList = dao.selectList(SALESMAN_VIRTUAL + ".queryDeptVirSalesman", userMap);
		} else {
			//
		}
		return resultList;
	}

	@Override
	public List<Map<String, Object>> queryDeptVirSalesman(Map<String, Object> userMap) {
		List<Map<String, Object>> resultList = dao.selectList(SALESMAN_VIRTUAL + ".queryDeptVirSalesman", userMap);
		return resultList;
	}

	@Override
	public List<Map<String, Object>> queryAllSalesmans(Map<String, Object> userMap) {
		List<Map<String, Object>> resultList = dao.selectList(MEDIUM_NODE_ACCOUNT + ".queryAllSalesmans", userMap);
		return resultList;
	}

}
