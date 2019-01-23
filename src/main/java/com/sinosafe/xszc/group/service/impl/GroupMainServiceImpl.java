package com.sinosafe.xszc.group.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.GROUP_MAIN;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_CONFER;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_GROUP_LISTS_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.group.service.GroupLeaderRecordService;
import com.sinosafe.xszc.group.service.GroupMainService;
import com.sinosafe.xszc.group.vo.GroupMain;
import com.sinosafe.xszc.util.PageDto;

public class GroupMainServiceImpl implements GroupMainService {

	private static final Log log = LogFactory.getLog(GroupMainServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "DepartmentService")
	private DepartmentService departmentService;

	@Autowired
	@Qualifier(value = "GroupLeaderRecordService")
	private GroupLeaderRecordService groupLeaderRecordService;

	@Override
	public PageDto findGroupMainByWhere(PageDto pageDto) {
		log.debug("GroupMainServiceImpl findGroupMainByWhere start.....");
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		List<Map<String, Object>> rows =new ArrayList<Map<String,Object>>();
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		 String readpg=(String)pageDto.getWhereMap().get("readPage");
		// 查团队总数页面
		if (readpg.equals("groupPage")){
			Long total = dao.selectOne(GROUP_MAIN + ".queryListCount", pageDto.getWhereMap());
			pageDto.setTotal(total);
		 rows = dao.selectList(GROUP_MAIN + QUERY_LIST_PAGE, pageDto.getWhereMap());}
		// 查团队历史记录
		if (readpg.equals("groupHistoryPage")){
			Long total = dao.selectOne(GROUP_MAIN +".queryHistoryCount", pageDto.getWhereMap());
			pageDto.setTotal(total);
			 rows=dao.selectList(GROUP_MAIN+".queryHistoryListPage", pageDto.getWhereMap());
		}
		
		// 显示是否已设置团队长
		for (int i = 0; i < rows.size(); i++) {
			Map<String, Object> map = rows.get(i);
			String groupCode = (String) map.get("groupCode");
			Long count = dao.selectOne(GROUP_MAIN + ".existsGroupLeader", groupCode);
			if (count == 0) {
				rows.get(i).put("existLeader", "0");
				rows.get(i).put("leaderCname", "");
			} else {
				String leaderCname = dao.selectOne(GROUP_MAIN + ".queryGroupLeaderCname", groupCode);
				rows.get(i).put("existLeader", "1");
				rows.get(i).put("leaderCname", leaderCname);
			}
		}
		pageDto.setRows(rows);
		log.debug("GroupMainServiceImpl findGroupMainByWhere end.....");
		return pageDto;
	}

	@Override
	public void saveGroupMain(GroupMain... groupMain) {
		if (groupMain != null && groupMain.length > 0) {
			for (int i = 0; i < groupMain.length; i++) {
				dao.insert(GROUP_MAIN + INSERT_VO, groupMain[i]);
			}
		} else {
			throw new RuntimeException("没有要添加的版本定义，参数为null或长度为0");
		}
	}

	@Override
	public void updateGroupMain(GroupMain... groupMain) {
		if (groupMain != null && groupMain.length > 0) {
			//把修改前的信息保存到历史轨迹表里
			dao.insert(GROUP_MAIN+".insertGroupMainHistory",groupMain[0]);
			for (int i = 0; i < groupMain.length; i++) {
				dao.update(GROUP_MAIN + UPDATE_PK_VO, groupMain[i]);
			}
		} else {
			throw new RuntimeException("没有要修改的版本定义，参数为null或长度为0");
		}
	}
	
	

	/**
	 * 查询单条数据
	 */
	@Override
	public PageDto findGroupMainsByWhere(PageDto pageDto) {
		Long total = dao.selectOne(GROUP_MAIN + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(GROUP_MAIN + QUERY_GROUP_LISTS_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	/**
	 * 查询单条历史轨迹数据
	 */
	@Override
	public PageDto findGroupMainDetailByWhere(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(GROUP_MAIN + ".groupMainHistoryDetail", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	/**
	 * 查询四级机构下的团队
	 */
	@Override
	public List<Map<String, Object>> queryDeptGroup(Map<String, Object> userMap) {
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(GROUP_MAIN + ".queryDeptGroup", userMap);
		return resultList;
	}
	
	/**
	 * 查询四级机构下的团队
	 */
	@Override
	public List<Map<String, Object>> queryGroupListForLawImp(Map<String, Object> whereMap) {
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(GROUP_MAIN + ".queryGroupListForLawImp", whereMap);
		return resultList;
	}
	
	/**
	 * 根据主键查询团队
	 */
	public GroupMain findGroupByPrimaryKey(String groupCode){
		GroupMain groupMain = (GroupMain)dao.selectOne(GROUP_MAIN + ".selectByPrimaryKeyVo", groupCode);
	    return groupMain;
	}

	/**
	 * 查询团队名称用于人员管理界面的显示
	 */
	@Override
	public List<Map<String, Object>> queryGroupCname(Map<String, Object> whereMap) {
		List<Map<String, Object>> result = dao.selectList(GROUP_MAIN + ".queryGroupCname", whereMap);
		return result;
	}

	@Override
	public PageDto findGroupMainByWheres(PageDto pageDto) {
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		String qh=(String)pageDto.getWhereMap().get("queryHistory");
		List<Map<String,Object>> rows=new ArrayList<Map<String,Object>>();
		//查询leader的历史轨迹 
		if (qh.equals("queryHistory")){
			Long total = dao.selectOne(GROUP_MAIN +".queryCountHistory", pageDto.getWhereMap());
			pageDto.setTotal(total);
			 rows = dao.selectList(GROUP_MAIN + ".queryLeaderHistoryList", pageDto.getWhereMap());
		}
		else if(qh.equals("queryList")){
			Long total = dao.selectOne(GROUP_MAIN + QUERY_COUNT, pageDto.getWhereMap());
			pageDto.setTotal(total);
		//查看leader的信息
		    rows = dao.selectList(GROUP_MAIN + ".queryListPages", pageDto.getWhereMap());
		}
		// 遍历List
		for (int i = 0; i < rows.size(); i++) {
			String groupLeaders = (String) rows.get(i).get("groupLeader");
			Map<String, Object> whereMap = new HashMap<String, Object>();
            // 团队长名称
			if (groupLeaders != null && !"".equals(groupLeaders)) {
				whereMap.clear();
				whereMap.put("groupLeader", groupLeaders);
				List<Map<String, Object>> leaderNameList = groupLeaderRecordService.queryGroupLeaderName(whereMap);
				//当groupLeader存在但在salesman表被失效时，会出现leanderNameList为空。
				if(leaderNameList==null || leaderNameList.isEmpty()){
					rows.get(i).put("salesmanCode", "");
					rows.get(i).put("salesmanCname", "");
					continue;
				}
				String salesmanCode = (String) leaderNameList.get(0).get("salesmanCode");
				String salesmanCname = (String) leaderNameList.get(0).get("salesmanCname");
				rows.get(i).put("salesmanCode", salesmanCode);
				rows.get(i).put("salesmanCname", salesmanCname);
			} else {
				rows.get(i).put("salesmanCode", "");
				rows.get(i).put("salesmanCname", "");
			}
		}
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Long findGroupMainByCount(GroupMain... groupMain) {
		// 查询机构下级团队，尾数最大的团队加 1
		Long total = dao.selectOne(GROUP_MAIN + ".queryCounts", groupMain[0]);
		return total;
	}

	@Override
	public Long findGroupNameByCount(Map<String, Object> whereMap) {
		Long total = dao.selectOne(GROUP_MAIN + ".queryGroupNameCount", whereMap);
		return total;
	}

	@Override
	public void deleteGroupMain(GroupMain groupMain) {
		dao.update(GROUP_MAIN + ".deleteById", groupMain);
	}

	@Override
	public String findGroupLeaderCname(String groupCode) {
		return (String) dao.selectOne(GROUP_MAIN + ".queryGroupLeaderCname", groupCode);
	}

	@Override
	public PageDto queryGroupMember(PageDto pageDto) {
		Long total = dao.selectOne(GROUP_MAIN + ".queryGroupMemberCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(GROUP_MAIN + ".queryGroupMember", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	
	@Override
	public PageDto queryTrueGroupMember(PageDto pageDto) {
		Long total = dao.selectOne(GROUP_MAIN + ".queryTrueGroupMemberCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(GROUP_MAIN + ".queryTrueGroupMember", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	
	@Override
	public PageDto queryGroupMemberDetail(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(GROUP_MAIN + ".queryGroupMemberDetail", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public String quertGroupType(Map<String, Object> whereMap) {
		return dao.selectOne(GROUP_MAIN + ".queryGroupType", whereMap);
	}
}
