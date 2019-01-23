package com.sinosafe.xszc.group.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_SALESMAN_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SALESMAN;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.group.service.GroupMainService;
import com.sinosafe.xszc.group.service.SalesmanEmployService;
import com.sinosafe.xszc.group.service.SalesmanService;
import com.sinosafe.xszc.group.vo.Salesman;
import com.sinosafe.xszc.group.vo.SalesmanEmploy;
import com.sinosafe.xszc.util.PageDto;

public class SalesmanServiceImpl implements SalesmanService {

	private static final Log log = LogFactory.getLog(SalesmanServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@Autowired
	@Qualifier(value = "DepartmentService")
	private DepartmentService departmentService;

	@Autowired
	@Qualifier(value = "GroupMainService")
	private GroupMainService groupMainService;

	@Autowired
	@Qualifier(value = "SalesmanEmployService")
	private SalesmanEmployService salesmanEmployService;

	@Override
	public PageDto findSalesmanByWhere(PageDto pageDto) {
		Long total = dao.selectOne(SALESMAN + ".queryPageListCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		// 二级机构
		String twoDeptCode = (String) pageDto.getWhereMap().get("twoDeptCode");
		// 如果二级机构为空，则用户为总公司，获得当前用户的机构代码
		if (StringUtils.isBlank(twoDeptCode)) {
			List<Map<String, Object>> list = umService.findDeptListByUserCode(CurrentUser.getUser().getUserCode());
			if (list != null && list.size() == 1) {
				pageDto.getWhereMap().put("twoDeptCode", list.get(0).get("deptCode").toString());
			}
		}
		List<Map<String, Object>> rows = dao.selectList(SALESMAN + ".queryPageList", pageDto.getWhereMap());
		pageDto.setRows(this.getMultiDeptInfo(rows));
		return pageDto;
	}

	// 查看业务线变更记录
	@Override
	public PageDto findSalesmanHistoryByWhere(PageDto pageDto) {
		Long total = dao.selectOne(SALESMAN + ".querysalesmanhistory", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		// 二级机构
		String twoDeptCode = (String) pageDto.getWhereMap().get("twoDeptCode");
		// 如果二级机构为空，则用户为总公司，获得当前用户的机构代码
		if (StringUtils.isBlank(twoDeptCode)) {
			List<Map<String, Object>> list = umService.findDeptListByUserCode(CurrentUser.getUser().getUserCode());
			if (list != null && list.size() == 1) {
				pageDto.getWhereMap().put("twoDeptCode", list.get(0).get("deptCode").toString());
			}
		}
		List<Map<String, Object>> rows = dao.selectList(SALESMAN + ".queryPageHistoryList", pageDto.getWhereMap());
		pageDto.setRows(this.getMultiDeptInfo(rows));
		return pageDto;
	}

	@Override
	public List<Map<String, Object>> getMultiDeptInfo(List<Map<String, Object>> rows) {
		log.debug("查询多级机构的代码及名称开始...");
		for (Map<String, Object> map : rows) {
			Map<String, Object> deptMap = new HashMap<String, Object>();
			String deptCode = (String) map.get("deptCode");
			if (deptCode != null) {
				// 由于HR人员的的机构代码，有的是4位，有的两位，有的是00，所以在代码中特殊处理
				if (deptCode.length() == 8) {
					deptMap = dao.selectOne(SALESMAN + ".getMultiDeptInfo", deptCode);
				} else if (deptCode.length() == 4) {
					deptMap = dao.selectOne(SALESMAN + ".getMultiDeptMark", deptCode);
				} else if (deptCode.length() == 2) {
					deptMap = dao.selectOne(SALESMAN + ".getMultiDeptProd", deptCode);
				} else {
					log.warn("查询多级机构的代码及名称时，机构代码异常，机构代码：" + deptCode);
				}
			}
			if (deptMap != null) {
				map.put("deptCodeFour", deptCode);
				map.put("deptNameFour", deptMap.get("deptNameFour"));
				map.put("deptCodeThree", deptMap.get("deptCodeThree"));
				map.put("deptNameThree", deptMap.get("deptNameThree"));
				map.put("deptCodeTwo", deptMap.get("deptCodeTwo"));
				map.put("deptNameTwo", deptMap.get("deptNameTwo"));
			}
		}
		log.debug("查询多级机构的代码及名称结束...");
		return rows;
	}

	// 新增
	@Override
	public void saveSalesman(Salesman... salesman) {
		if (salesman != null && salesman.length > 0) {
			for (int i = 0; i < salesman.length; i++) {
				dao.insert(SALESMAN + INSERT_VO, salesman[i]);
			}
		} else {
			throw new RuntimeException("没有要添加的版本定义，参数为null或长度为0");
		}
	}

	// 查询单条数据详细
	@Override
	public PageDto findSalesmansByWhere(PageDto pageDto) {
		Long total = dao.selectOne(SALESMAN + QUERY_COUNT_VO, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(SALESMAN + QUERY_SALESMAN_LIST_PAGE, pageDto.getWhereMap());

		pageDto.setRows(rows);
		return pageDto;
	}

	// 查询历史记录单条数据详细
	@Override
	public PageDto findSalesmansDetailByWhere(PageDto pageDto) {
		/*
		 * Long total = dao.selectOne(SALESMAN + QUERY_COUNT_VO, pageDto.getWhereMap()); pageDto.setTotal(total);
		 */
		/*
		 * if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) { pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1); } else {
		 * pageDto.getWhereMap().put("startpoint", 1); } pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		 */
		List<Map<String, Object>> rows = dao.selectList(SALESMAN + ".querySalesmanHistoryList", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	// 根据主键查出销售人员
	@Override
	public Salesman findSalesmanByPrimaryKey(String salesmanCode) {
		Salesman salesman = (Salesman) dao.selectOne(SALESMAN + ".selectByPKyVo", salesmanCode);
		return salesman;
	}

	// 查询单条数据详细
	@Override
	public PageDto findSalesmansOfLastInfoByWhere(PageDto pageDto) {
		Long total = dao.selectOne(SALESMAN + QUERY_COUNT_VO, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(SALESMAN + ".querySalesmanOfLastInfoListPage", pageDto.getWhereMap());

		pageDto.setRows(rows);
		return pageDto;
	}

	// 处理HR人员信息
	@Override
	public void updateSalesman(Salesman salesman) {

		String userCode = CurrentUser.getUser().getUserCode();

		// 修改HR人员信息,flag等于 1 则标识是人员异动操作，执行不同SQL
		if ("1".equals(salesman.getFlag())) {
			dao.insert(SALESMAN + ".insertsalemanyidonghistory", salesman);
			dao.update(SALESMAN + ".updateChangeByPrimaryKeyVo", salesman);
		}
		// 处理HR人员
		else {
			dao.insert(SALESMAN + ".insertsalemanhistory", salesman);
			// 职级是否参与统计
			String rankCode = salesman.getSaleRank();
			String statFlag = (String) dao.selectOne(SALESMAN + ".getRankStatFlag", rankCode);
			salesman.setStatFlag(statFlag);
			// 处理HR人员信息
			dao.update(SALESMAN + ".updateByPrimaryKeyVo", salesman);
			
		}

		// 如果选择了“其他”，则将此HR人员信息失效，并将此人员信息（复制）插入或更新到销售助理表。如果选择“其他（返聘）”，“其他（内勤用编）”则不作处理（不用插入到销售助理里面）。
		long total = (Long) dao.selectOne(SALESMAN + ".lawRankDefByRankCode", salesman.getSaleRank());
		if (total > 0) {
			// 如果销售助理表中已经存在记录则更新，反之则插入
			long isExist = (Long) dao.selectOne(SALESMAN + ".isExistSalesmanVirtual", salesman.getEmployCode());
			if (isExist > 0) {
				dao.update(SALESMAN + ".copyAndUpdateSalesmanVirtual", salesman);
			} else {
				dao.insert(SALESMAN + ".copyAndInsertSalesmanVirtual", salesman);
			}
			// 将此HR人员失效
			dao.update(SALESMAN + ".validateInfoSalesman", salesman.getSalesmanCode());
		}

		// 循环插入关联工号
		if (salesman.getSalesmanEmploy().size() > 0) {
			for (SalesmanEmploy salesmanEmploy : salesman.getSalesmanEmploy()) {
				salesmanEmploy.getPkId();
				// ID相同的做修改，新添加的数据做保存处理；
				long repeat = salesmanEmployService.repeatSalesmanEmploy(salesmanEmploy);
				if (repeat > 0) {
					salesmanEmployService.updateSalesmanEmploy(salesmanEmploy);
				} else {
					salesmanEmploy.setPkId(UUIDGenerator.getUUID());
					salesmanEmploy.setCreatedUser(userCode);
					salesmanEmploy.setUpdatedUser(userCode);
					salesmanEmploy.setValidInd("1");
					salesmanEmployService.saveSalesmanEmploy(salesmanEmploy);
				}
			}
		}
		// throw new RuntimeException("没有要修改的版本定义，参数为null或长度为0");
	}
	
	

	// 查询HR人员的姓名
	@Override
	public List<Map<String, Object>> queryUserCname(Map<String, Object> whereMap) {
		List<Map<String, Object>> result = dao.selectList(SALESMAN + ".queryUserCname", whereMap);
		return result;
	}

	@Override
	public List<Map<String, Object>> queryGroupSalesman(Map<String, Object> userMap) {
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(SALESMAN + ".queryGroupSalesman", userMap);
		return resultList;
	}

	// 查询人员的姓名还有代码
	@Override
	public List<Map<String, Object>> queryNameAndCode(Map<String, Object> userMap) {
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(SALESMAN + ".queryNameAndCode", userMap);
		return resultList;
	}

	@Override
	public List<Map<String, Object>> querySalesmanInfoByCode(String salesmanCode) {
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(SALESMAN + ".querySalesmanInfoByCode", salesmanCode);
		return resultList;
	}

	@Override
	public void resetSalesman(String salesmanCode) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		String updatedUser = CurrentUser.getUser().getUserCode();
		whereMap.put("updatedUser", updatedUser);
		String[] arr = salesmanCode.split(",");
		for (int i = 0; i < arr.length; i++) {
			String historyId = UUIDGenerator.getUUID();
			whereMap.put("historyId", historyId);
			whereMap.put("salesmanCode", arr[i]);
			dao.insert(SALESMAN + ".insertSalesmanHistory2", whereMap);
			dao.update(SALESMAN + ".resetSalesman", whereMap);
			dao.update(SALESMAN + ".delGroupMenber", whereMap);
			whereMap.remove("salesmanCode");
		}
	}

	/**
	 * 详细说明:查询销售人员列表<br>
	 * 编写者:卢水发 创建时间:2015年6月30日 下午3:52:47 </pre>
	 * 
	 * @see com.sinosafe.xszc.group.service.SalesmanService#querySaleManList(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> querySaleManList(Map<String, Object> whereMap) {
		whereMap.put("validInd", "1");
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(SALESMAN + ".queryListByWhere", whereMap);
		return resultList;
	}

	/**
	 * 详细说明:查询销售人员列表<br>
	 * 编写者:卢水发 创建时间:2015年6月30日 下午3:52:47 </pre>
	 * 
	 * @see com.sinosafe.xszc.group.service.SalesmanService#querySaleManList(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> querySalemanForLawImp(Map<String, Object> whereMap) {
		whereMap.put("validInd", "1");
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(SALESMAN + ".querySalemanForLawImp", whereMap);
		return resultList;
	}

	@Override
	public String querySalesDirector(String salesmanCode) {
		String list = dao.selectOne(SALESMAN + ".querySalesDirector", salesmanCode);
		return list;
	}

	@Override
	public void recoverDelStatus(String salesmanCode) {
		Map<String,Object> params = new HashMap<String, Object>();
		String userCode = CurrentUser.getUser().getUserCode().split("@")[0];
		params.put("salesmanCode", salesmanCode);
		params.put("userCode", userCode);
		dao.update(SALESMAN + ".recoverDelStatus", params);
	}
	
	@Override
	public void updateGroupMember(Map<String, Object> whereMap) {
		dao.insert(SALESMAN + ".insertMember", whereMap);
		String groupCode = dao.selectOne(SALESMAN + ".queryGroupCode", whereMap);
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("validDate", whereMap.get("validDate"));
		params.put("currentUser", whereMap.get("currentUser"));
		params.put("salesCode", whereMap.get("salesmanCode"));
		params.put("groupCode", groupCode);
		dao.update(SALESMAN + ".updateMember", params);
	}
	@Override
	public void insertGroupMember(Map<String, Object> whereMap) {
		//插入GROUP_MENBER
		dao.insert(SALESMAN+".insertGroupMember", whereMap);
	}

	@Override
	public List<Map<String, Object>> querySalesmanHisHr(Map<String, Object> whereMap) {
		return dao.selectList(SALESMAN+".querySalesmanHisHr", whereMap);
	}

	@Override
	public void updateSalesmanDate(Map<String, Object> whereMap) {
		dao.update(SALESMAN + ".updateSalesmanMenberDate", whereMap);
		dao.update(SALESMAN + ".updateSalesmanFrontDate" ,whereMap);
		dao.update(SALESMAN + ".insertSalesmanRecord", whereMap);
	}

	@Override
	public PageDto querySalesmanRecord(PageDto pageDto) {
		List<Map<String, Object>>rows = dao.selectList(SALESMAN + ".querySalesmanRecord", pageDto.getWhereMap());
		pageDto.setRows(this.getMultiDeptInfo(rows));
		return pageDto;
	}
}
