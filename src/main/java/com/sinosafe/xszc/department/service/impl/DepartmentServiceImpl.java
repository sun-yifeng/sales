package com.sinosafe.xszc.department.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DEPARTMENT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UM_DEPARTMENT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SALESMAN;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.department.vo.Department;
import com.sinosafe.xszc.util.PageDto;

public class DepartmentServiceImpl implements DepartmentService {

	private static final Log log = LogFactory.getLog(DepartmentServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@Override
	public Map<String, Object> findUmDepartmentMap(String dptCde) {
		Map<String, Object> deptMap = dao.selectOne(UM_DEPARTMENT + QUERY_ONE, dptCde);
		return deptMap;
	}

	@Override
	public Department findDepartmentVo(String dptCde) {
		Department dept = dao.selectOne(DEPARTMENT + QUERY_ONE_VO, dptCde);
		return dept;
	}

	@Override
	public Map<String, Object> generateDeptInfo(String parentCode) {
		// 自动生成虚拟部门代码
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parentCode", parentCode);
		param.put("deptCode", "");
		param.put("deptName", "");
		param.put("interCode", "");
		dao.selectOne(DEPARTMENT + ".execProcedureDept", param);
		return param;
	}

	@Override
	public List<Map<String, Object>> findParentDept(Map<String, Object> whereMap) {
		List<Map<String, Object>> result = dao.selectList(DEPARTMENT + ".queryParentDept", whereMap);
		return result;
	}

	@Override
	public List<Map<String, Object>> findDepartmentMapByWhere(Map<String, Object> whereMap) {
		List<Map<String, Object>> result = dao.selectList(UM_DEPARTMENT + QUERY, whereMap);
		return result;
	}

	@Override
	public List<Department> findUmDepartmentVoByWhere(Map<String, Object> whereMap) {
		List<Department> result = dao.selectList(UM_DEPARTMENT + QUERY_VO, whereMap);
		return result;
	}

	@Override
	public List<Map<String, Object>> findUmUserToUmDepartment(String dptCde) {
		// FIXME 待业务确定
		return null;
	}

	@Override
	public List<Map<String, Object>> findDepartmenAll(Map<String, Object> map) {
		List<Map<String, Object>> resList = dao.selectList(UM_DEPARTMENT + ".queryDeptByParentCode", map);
		int count = resList.size();
		for (int i = 0; i < count; i++) {
			if (map != null) {
				map.put("id", resList.get(i).get("id"));
			}
			if (dao.selectList(UM_DEPARTMENT + ".queryAll", map).size() > 0) {
				resList.get(i).put("hasChildren", true);
			} else {
				resList.get(i).put("hasChildren", false);
			}
		}
		return resList;
	}

	@Override
	public List<Map<String, Object>> findDepartmenByLevel(Map<String, Object> map) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = dao.selectList(DEPARTMENT + ".queryDeptByDeptLevel", map);
		resultList = dao.selectList(DEPARTMENT + ".queryDeptTreeByUser", map);
		for (int i = 0; i < resultList.size(); i++) {
			String deptCode = (String) resultList.get(i).get("id");
			String deptName = (String) resultList.get(i).get("text");
			if (map != null) {
				map.put("parentCode", deptCode);
			}
			if (dao.selectList(DEPARTMENT + ".queryDeptByParentCode", map).size() > 0) {
				resultList.get(i).put("hasChildren", true);
			} else {
				resultList.get(i).put("hasChildren", false);
			}
			if ("00".equals(deptCode)) {
				whereMap.clear();
				long group = (Long) dao.selectOne(SALESMAN + ".queryGroupCount", whereMap);
				long count = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				whereMap.put("businessLine", "925007"); // 常规925007
				long seven = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				whereMap.put("businessLine", "925003"); // 金融925003
				long three = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				whereMap.put("businessLine", "925006"); // 重客925006
				long six = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				resultList.get(i).put("text",
						deptName + "(" + group + "个团队" + "/" + count + "人" + "/" + "常规" + seven + "人" + "/" + "重客" + six + "人" + "/" + "金融" + three + "人)");
			} else {
				whereMap.clear();
				whereMap.put("deptCode", deptCode);
				long group = (Long) dao.selectOne(SALESMAN + ".queryGroupCount", whereMap);
				long count = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				whereMap.put("businessLine", "925007"); // 常规925007
				long seven = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				whereMap.put("businessLine", "925003"); // 金融925003
				long three = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				whereMap.put("businessLine", "925006"); // 重客925006
				long six = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				resultList.get(i).put("text",
						deptName + "(" + group + "个团队" + "/" + count + "人" + "/" + "常规" + seven + "人" + "/" + "重客" + six + "人" + "/" + "金融" + three + "人)");
			}
		}
		return resultList;
	}

	@Override
	public List<Map<String, Object>> findDeptListByParentCode(String deptCode) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("parentCode", deptCode);
		List<Map<String, Object>> queryList = dao.selectList(DEPARTMENT + ".queryDeptByParentCode", whereMap);
		return queryList;
	}

	/**
	 * 组织架构统计规则： <br>
	 * 1、销售人员统计时，统计的条件是，已处理的销售人员+前台销售人员+在职的销售人员+其他（不包括其他中其他，剔除其他中返聘）。<br>
	 * 2、团队数量统计时，剔除“虚拟团队”，剔除没有团队长的真实团队。<br>
	 * 3、统计人数时，虚拟团队里面的销售人员要统计。 4、机构下没有销售人员，则屏蔽（不显示）该机构。
	 */
	@Override
	public List<Map<String, Object>> findDepartmenByParent(Map<String, Object> paraMap) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		List<Map<String, Object>> arrayList = new ArrayList<Map<String, Object>>(10000);
		List<Map<String, Object>> queryList = dao.selectList(DEPARTMENT + ".queryDeptByParentCode", paraMap);

		for (Iterator<Map<String, Object>> iterator = queryList.iterator(); iterator.hasNext();) {
			Map<String, Object> map = (Map<String, Object>) iterator.next();
			String deptCode = (String) map.get("id");
			String deptName = (String) map.get("text");
			if (paraMap != null) {
				paraMap.put("parentCode", deptCode);
			}
			if (dao.selectList(DEPARTMENT + ".queryDeptByParentCode", paraMap).size() > 0) {
				map.put("hasChildren", true);
			} else {
				// 如果是6位机构，并且无子机构，则不显示,否则团队重复统计
				if (deptCode.length() == 6) {
					continue;
				}
				map.put("hasChildren", false);
			}
			whereMap.clear();
			whereMap.put("deptCode", deptCode);
			// 机构下是否有人员，无人则屏蔽
			long count = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
			// 统计各个业务线的人数，销售人员统计规则： 已处理的销售人员+前台销售人员+在职的销售人员+其他（不包括其他中其他，剔除其他中返聘）。
			if (count > 0) {
				// 统计团队数量
				long group = (Long) dao.selectOne(SALESMAN + ".queryGroupCount", whereMap);
				// 常规人数925007
				whereMap.put("businessLine", "925007");
				// 金融人数925003
				long seven = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				whereMap.put("businessLine", "925003");
				long three = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				// 重客人数925006
				whereMap.put("businessLine", "925006");
				long six = (Long) dao.selectOne(SALESMAN + ".querySalesmanCount", whereMap);
				// 页面显示
				map.put("text", deptName + "(" + group + "个团队" + "/" + count + "人" + "/" + "常规" + seven + "人" + "/" + "重客" + six + "人" + "/" + "金融" + three
						+ "人)");
				arrayList.add(map);
			} else {
				log.debug("屏蔽的机构:" + deptCode + deptName);
			}
		}
		return arrayList;
	}

	@Override
	public List<Map<String, Object>> findDeptDropListByLevel(Map<String, Object> whereMap) {
		List<Map<String, Object>> resultList = dao.selectList(DEPARTMENT + ".queryDeptTreeByUser", whereMap);
		for (int i = 0; i < resultList.size(); i++) {
			String deptCode = (String) resultList.get(i).get("id");
			// String deptCode = (String) resultList.get(i).get("deptCode");
			if (whereMap != null) {
				whereMap.put("parentCode", deptCode);
			}
			if (dao.selectList(DEPARTMENT + ".queryDeptByParentCode", whereMap).size() > 0) {
				resultList.get(i).put("hasChildren", true);
			} else {
				resultList.get(i).put("hasChildren", false);
			}
		}
		return resultList;
	}

	@Override
	public List<Map<String, Object>> findDeptDropListByParent(Map<String, Object> whereMap) {
		List<Map<String, Object>> resultList = dao.selectList(DEPARTMENT + ".queryDeptByParentCode", whereMap);
		for (int i = 0; i < resultList.size(); i++) {
			String deptCode = (String) resultList.get(i).get("id");
			if (whereMap != null) {
				whereMap.put("parentCode", deptCode);
			}
			if (dao.selectList(DEPARTMENT + ".queryDeptByParentCode", whereMap).size() > 0) {
				resultList.get(i).put("hasChildren", true);
			} else {
				resultList.get(i).put("hasChildren", false);
			}
		}
		return resultList;
	}

	@Override
	public List<Map<String, Object>> findDeptDropListByDept(Map<String, Object> whereMap) {
		List<Map<String, Object>> resultList = dao.selectList(DEPARTMENT + ".queryDeptByDeptCode", whereMap);
		for (int i = 0; i < resultList.size(); i++) {
			String deptCode = (String) resultList.get(i).get("id");
			if (whereMap != null) {
				whereMap.put("parentCode", deptCode);
			}
			if (dao.selectList(DEPARTMENT + ".queryDeptByParentCode", whereMap).size() > 0) {
				resultList.get(i).put("hasChildren", true);
			} else {
				resultList.get(i).put("hasChildren", false);
			}
		}
		return resultList;
	}

	@Override
	public List<Map<String, Object>> findHrDepartmenAll(Map<String, Object> map) {
		List<Map<String, Object>> resList = dao.selectList(UM_DEPARTMENT + ".queryAll", map);
		int count = resList.size();
		for (int i = 0; i < count; i++) {
			if (map != null) {
				map.put("id", resList.get(i).get("id"));
			}
			if (dao.selectList(UM_DEPARTMENT + ".queryAll", map).size() > 0) {
				resList.get(i).put("hasChildren", true);
			} else {
				resList.get(i).put("hasChildren", false);
			}
		}
		return resList;
	}

	@Override
	public List<Map<String, Object>> queryPidByUserCode(Map<String, Object> map) {
		List<Map<String, Object>> resList = dao.selectList(UM_DEPARTMENT + ".queryPidByUserCode", map);
		return resList;
	}

	@Override
	public List<Map<String, Object>> queryDeptCodeByUserCode(Map<String, Object> map) {
		List<Map<String, Object>> resList = dao.selectList(UM_DEPARTMENT + ".queryDeptCodeByUserCode", map);
		return resList;
	}

	@Override
	public List<Map<String, Object>> queryDepartByDeptCode(List<String> list) {
		List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();
		if (list != null && list.size() > 0) {
			resList = dao.selectList(UM_DEPARTMENT + ".queryDepartByDeptCode", list);
			int count = resList.size();
			Map<String, Object> map = new HashMap<String, Object>();
			for (int i = 0; i < count; i++) {
				map.put("id", resList.get(i).get("id"));
				if (dao.selectList(UM_DEPARTMENT + ".queryAll", map).size() > 0) {
					resList.get(i).put("hasChildren", true);
				} else {
					resList.get(i).put("hasChildren", false);
				}
			}
		}
		return resList;
	}

	@Override
	public List<Map<String, Object>> queryHrDepartByUserCode(Map<String, Object> map) {
		List<Map<String, Object>> resList = dao.selectList(UM_DEPARTMENT + ".queryHrDepartByUserCode", map);
		int count = resList.size();
		for (int i = 0; i < count; i++) {
			if (map != null) {
				map.put("id", resList.get(i).get("id"));
			}
			if (dao.selectList(UM_DEPARTMENT + ".queryHrAll", map).size() > 0) {
				resList.get(i).put("hasChildren", true);
			} else {
				resList.get(i).put("hasChildren", false);
			}
		}
		return resList;
	}

	@Override
	public List<Map<String, Object>> queryProvince(Map<String, Object> map) {
		List<Map<String, Object>> resList = dao.selectList(DEPARTMENT + ".queryProvince", map);
		List<Map<String, Object>> resultList = null;
		if (resList.size() == 1) {
			Map<String, Object> mapLevel = resList.get(0);
			String deptLevel = mapLevel.get("deptLevel").toString();
			switch (Integer.parseInt(deptLevel)) {
			case 0:
				resultList = dao.selectList(DEPARTMENT + ".queryProvinceLevel0", mapLevel);
				break;
			case 1:
				resultList = dao.selectList(DEPARTMENT + ".queryProvinceLevel1", mapLevel);
				break;
			case 2:
				resultList = dao.selectList(DEPARTMENT + ".queryProvinceLevel2", mapLevel);
				break;
			default:
				resultList = dao.selectList(DEPARTMENT + ".queryProvinceLevel3", mapLevel);
				break;
			}
		}
		return resultList;
	}

	@Override
	public List<Map<String, Object>> queryCity(Map<String, Object> departMap) {
		List<Map<String, Object>> resList = dao.selectList(DEPARTMENT + ".queryProvince", departMap);
		List<Map<String, Object>> resultList = null;
		if (resList.size() == 1) {
			Map<String, Object> mapLevel = resList.get(0);
			String deptLevel = mapLevel.get("deptLevel").toString();
			if (Integer.parseInt(deptLevel) < 2) {
				resultList = dao.selectList(DEPARTMENT + ".queryCityAll", departMap);
			} else if (Integer.parseInt(deptLevel) == 2) {
				resultList = dao.selectList(DEPARTMENT + ".queryProvinceLevel1", mapLevel);
			} else if (Integer.parseInt(deptLevel) == 3) {
				resultList = dao.selectList(DEPARTMENT + ".queryProvinceLevel2", mapLevel);
			}
		}

		return resultList;
	}

	@Override
	public List<Map<String, Object>> queryMarketingDept(Map<String, Object> departMap) {
		List<Map<String, Object>> resList = dao.selectList(DEPARTMENT + ".queryProvince", departMap);
		List<Map<String, Object>> resultList = null;
		if (resList.size() == 1) {
			Map<String, Object> mapLevel = resList.get(0);
			String deptLevel = mapLevel.get("deptLevel").toString();
			if (Integer.parseInt(deptLevel) < 3) {
				resultList = dao.selectList(DEPARTMENT + ".queryCityAll", departMap);
			} else {
				resultList = dao.selectList(DEPARTMENT + ".queryProvinceLevel1", mapLevel);
			}
		}

		return resultList;
	}

	@Override
	public String saveDepartment(Department dept) {
		String msg = "新增成功！";
		if (dept != null) {
			dao.insert(DEPARTMENT + INSERT_VO, dept);
		} else {
			throw new RuntimeException("新增机构信息，参数为空！");
		}
		return msg;
	}

	@Override
	public String updateDepartment(Department dept) {
		String msg = "修改成功！";
		if (dept != null) {
			dao.update(DEPARTMENT + ".updateByPrimaryKeySelectiveVo", dept);
		} else {
			throw new RuntimeException("修改机构信息，参数为空！");
		}
		return msg;
	}

	@Override
	public int findDeptLevel(String deptCode) {
		int deptLevel = 0;
		if (StringUtils.isNotBlank(deptCode)) {
			deptLevel = (Integer) dao.selectOne(DEPARTMENT + ".queryDeptLevel", deptCode);
		} else {
			throw new RuntimeException("查询机构级别时，传入空的机构代码！");
		}
		return deptLevel;
	}

	@Override
	public boolean existChildDepartment(String parentDeptCode) {
		long count = (Long) dao.selectOne(DEPARTMENT + ".existChildDept", parentDeptCode);
		return count > 0;
	}

	/**
	 * 查询本级的名称用于修改页面显示
	 */
	@Override
	public List<Map<String, Object>> findParentDepts(Map<String, Object> whereMap) {
		List<Map<String, Object>> result = dao.selectList(DEPARTMENT + ".queryParentDepts", whereMap);
		return result;
	}

	@Override
	public boolean existDeptpartment(String deptCode) {
		long count = (Long) dao.selectOne(DEPARTMENT + ".existDept", deptCode);
		return count > 0;
	}

	@Override
	public String removeDepartment(Map<String, Object> whereMap) {
		dao.update(DEPARTMENT + ".removeDept", whereMap);
		return "机构信息删除成功！";
	}

	/**
	 * <pre>
	 * 选择用户弹出页面<br>
	 * 覆盖方法findUserByWhere详细说明:<br>
	 * 编写者:孙益峰
	 * 创建时间:2014年8月7日 下午4:29:07
	 * @param 参数名 说明
	 * @return 返回值类型 说明
	 * @throws 异常类型 说明
	 * @see com.sinosafe.xszc.department.service.DepartmentService#findUserByWhere(com.sinosafe.xszc.util.PageDto)
	 * </pre>
	 */
	@Override
	public PageDto findUserByWhere(PageDto pageDto) {
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		Long total = -1l;
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		total = (Long) dao.selectOne(DEPARTMENT + ".queryListPageUserByCodeOrNameCount", pageDto.getWhereMap());
		resultList = dao.selectList(DEPARTMENT + ".queryListPageUserByCodeOrName", pageDto.getWhereMap());
		pageDto.setTotal(total);
		// 组装选择用户的数据
		for (int i = 0; i < resultList.size(); i++) {
			String deptCode = (String) resultList.get(i).get("deptCode");
			String deptName = dao.selectOne(DEPARTMENT + ".queryDeptNameFromCore", deptCode);
			resultList.get(i).put("deptName", deptName == null ? "(" + deptCode + ")" : deptName + "(" + deptCode + ")");
		}
		pageDto.setRows(resultList);
		return pageDto;
	}

	@Override
	public List<Map<String, Object>> findDeptDataGridByWhere(Map<String, Object> map) {
		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();

		List<Map<String, Object>> city = null;

		int level = (Integer) dao.selectOne(DEPARTMENT + ".queryDeptLevel", map);

		switch (level) {
		case 0:
			returnList = dao.selectList(DEPARTMENT + ".queryChildCompany", "");
			break;
		case 1:
			returnList = dao.selectList(DEPARTMENT + ".queryDeptNameByUser", map);
			break;
		case 2:
			returnList = dao.selectList(DEPARTMENT + ".queryParentDeptByUser", map);
			break;
		case 4:
			city = dao.selectList(DEPARTMENT + ".queryParentDeptByUser", map);
			returnList = dao.selectList(DEPARTMENT + ".queryParentDeptByUser", city.get(0));
			break;
		default:
			break;
		}
		return returnList;
	}

	/*
	 * 查询分公司（二级机构）
	 */
	@Override
	public List<Map<String, Object>> queryDepartmentByUserCode(Map<String, Object> map) {
		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
		int level = (Integer) dao.selectOne(DEPARTMENT + ".queryDeptLevel", map); // 通过机构代码查询机构级别
		map.put("deptLevel", level + 1);
		switch (level) {
		case 0:
			map.put("deptLength", 3); // 机构内码的长度
			returnList = dao.selectList(DEPARTMENT + ".queryLowerDeptByUser", map);
			break;
		case 1:
			returnList = dao.selectList(DEPARTMENT + ".queryDeptNameByUser", map);
			break;
		case 2:
			returnList = dao.selectList(DEPARTMENT + ".queryParentDeptByUser", map);
			break;
		case 4:
			List<Map<String, Object>> city = dao.selectList(DEPARTMENT + ".queryParentDeptByUser", map);
			returnList = dao.selectList(DEPARTMENT + ".queryParentDeptByUser", city.get(0));
			break;
		default:
			break;
		}
		return returnList;
	}

	@Override
	public List<Map<String, Object>> queryDeptLevelInfo(Map<String, String> parameter) {
		return dao.selectList(DEPARTMENT + ".queryDeptLevelInfo", parameter);
	}

	/*
	 * 查询支公司（三级机构）
	 */
	@Override
	public List<Map<String, Object>> queryDepartmentCityByUserCode(Map<String, Object> map, String upDept) {
		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
		map.put("deptCode", upDept);

		int level = (Integer) dao.selectOne(DEPARTMENT + ".queryDeptLevel", map);
		map.put("deptLevel", level + 1);
		if (level < 2) {
			map.put("deptLength", 5);
			returnList = dao.selectList(DEPARTMENT + ".queryLowerDeptByUser", map);
		} else if (level == 2)
			returnList = dao.selectList(DEPARTMENT + ".queryDeptNameByUser", map);
		else if (level == 4)
			returnList = dao.selectList(DEPARTMENT + ".queryParentDeptByUser", map);

		return returnList;
	}

	/*
	 * 查询四级单位（四级机构
	 */
	@Override
	public List<Map<String, Object>> queryDepartmentMarketByUserCode(Map<String, Object> map, String upDept) {
		List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
		int level = (Integer) dao.selectOne(DEPARTMENT + ".queryDeptLevel", map);
		if (level <= 2)
			returnList = dao.selectList(DEPARTMENT + ".queryLowerDeptLeveFourByUser", upDept);
		else if (level == 4)
			returnList = dao.selectList(DEPARTMENT + ".queryDeptNameByUser", map);

		return returnList;
	}

	@Override
	public String getDeptCodeByUser(String UserCode) {
		return dao.selectOne(DEPARTMENT + ".getDeptCodeByUser", UserCode);
	}

	/**
	 * 找出所有机构
	 */
	@Override
	public PageDto queryAllPrinceDept(PageDto pageDto) {
		Map<String, Object> total = dao.selectOne(DEPARTMENT + ".queryDeptByAll", pageDto.getWhereMap());
		BigDecimal bd = (BigDecimal) total.get("count");
		pageDto.setTotal(bd.longValue());

		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}

		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(DEPARTMENT + ".queryDeptByAll", pageDto.getWhereMap());
		pageDto.setRows(rows);

		return pageDto;
	}

	/**
	 * 根据机构找出团队
	 */
	@Override
	public PageDto queryGroupByCityOrMarket(PageDto pageDto) {
		Map<String, Object> total = dao.selectOne(DEPARTMENT + ".queryGroupByCityOrMarket", pageDto.getWhereMap());
		BigDecimal bd = (BigDecimal) total.get("count");
		pageDto.setTotal(bd.longValue());

		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}

		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(DEPARTMENT + ".queryGroupByCityOrMarket", pageDto.getWhereMap());
		pageDto.setRows(rows);

		return pageDto;
	}

	/**
	 * 根据机构找出团队下的所有客户经理
	 */
	@Override
	public PageDto queryGroupUserByCityOrMarket(PageDto pageDto) {
		Map<String, Object> total = dao.selectOne(DEPARTMENT + ".queryGroupUserByCityOrMarket", pageDto.getWhereMap());
		BigDecimal bd = (BigDecimal) total.get("count");
		pageDto.setTotal(bd.longValue());

		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}

		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(DEPARTMENT + ".queryGroupUserByCityOrMarket", pageDto.getWhereMap());
		pageDto.setRows(rows);

		return pageDto;
	}

	@Override
	public String getDefaultDeptCodeByUser(String loginUserCode) {
		Map<String, Object> deptMap = umService.findDefaultDeptCodeByUserCode(loginUserCode);
		String deptCode = "";
		if (deptMap != null) {
			deptCode = (String) deptMap.get("deptCode");
		}
		return deptCode;
	}
}
