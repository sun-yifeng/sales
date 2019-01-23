package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.constant.Constant.deptTwo;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.LAW_DEFINE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.common.service.CommonServerice;
import com.sinosafe.xszc.law.service.LawDefineService;
import com.sinosafe.xszc.law.service.LawRateService;
import com.sinosafe.xszc.law.vo.LawDefine;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.util.PageDto;

public class LawDefineServiceImpl implements LawDefineService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "noticeService")
	private NoticeService noticeService;

	@Autowired
	@Qualifier("CommonServerice")
	private CommonServerice commonServerice;

	@Autowired
	@Qualifier("LawRateService")
	private LawRateService lawRateService;

	// 初始化业务线数据
	public void initRateData() {
		//FormDto dto = new FormDto();
		PageDto pageDto = new PageDto();
		pageDto.setStart("0");
		pageDto.setLimit("10000");
		// 查出基本法列表
		pageDto = findList(pageDto);
		List<Map<String, Object>> rows = pageDto.getRows();
		//
		lawRateService.initRateData(rows);
	}

	private PageDto findList(PageDto pageDto) {
		Long total = dao.selectOne(LAW_DEFINE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto findLawDefineByWhere(PageDto pageDto) {
		Long total = dao.selectOne(LAW_DEFINE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		// 查询出基本法版本信息
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		// 查询出基本法版本配置 TODO
		// for (Map<String, Object> map : rows) {
		// List<Map<String, Object>> configList = dao.selectList(LAW_DEFINE + ".getConfigList", map);
		// for (Map<String, Object> map2 : configList) {
		// String configName = (String) map2.get("configName");
		// }
		// }
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void saveOrUpdateLawDefine(Map<String, Object> paraMap) {
		String jsonStr = (String) paraMap.get("jsonStr");
		String updatedUser = (String) paraMap.get("updatedUser");
		List<Map<String, Object>> list = JSON.parseObject(jsonStr, new TypeReference<List<Map<String, Object>>>() {
		});
		for (Map<String, Object> map : list) {
			map.put("updatedUser", updatedUser);
			map.put("createdUser", updatedUser);
			String versionId = (String) map.get("versionId");
			if (StringUtils.isBlank(versionId)) {
				// 某个分公司业务线如果已经存在正在使用的基本法，则不新增
				boolean exist = (Long) dao.selectOne(LAW_DEFINE + ".querylawCount", map) > 0;
				if (!exist) {
					dao.update(LAW_DEFINE + ".insertLawVersion", map);
				}
			} else {
				dao.update(LAW_DEFINE + ".updateLawVersion", map);
			}
		}
	}

	@Override
	public List<Map<String, Object>> queryLawDefineInfo(String versionCode) {
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + ".queryLawDefineInfo", versionCode);
		return rows;
	}

	@Override
	public void deleteLawDefine(String versionCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("versionCode", versionCode);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		dao.update(LAW_DEFINE + DELETE_BY_ID, map);
	}

	@Override
	public PageDto queryLawDefineOmcombo(PageDto pageDto) {
		Long total = dao.selectOne(LAW_DEFINE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		pageDto.setStart("1");
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public long queryVersionCode(String versionCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("versionCode", versionCode);
		return (Long) dao.selectOne(LAW_DEFINE + ".queryVersionCode", map);
	}

	@Override
	public List<Map<String, Object>> queryDefineCode(Map<String, Object> defineMap) {
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(LAW_DEFINE + ".queryCodeAndName", defineMap);
		return resultList;
	}

	@Override
	public Map<String, Object> generateVersionCode(LawDefine lawDefine) {
		// 生成基本法代码
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("deptCode", lawDefine.getDeptCode());
		param.put("lineCode", lawDefine.getLineCode());
		// param.put("lawBgnDate", lawDefine.getLawBgnDate());
		param.put("versionCode", "");
		param.put("versionCname", "");
		dao.selectOne(LAW_DEFINE + ".generateVersionCode", param);
		return param;
	}

	// 查询基本法,根据机构与业务线
	public Map<String, Object> getLawDefineByDeptCode(String deptCode, String lineCode) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("deptCode", deptCode);
		whereMap.put("lineCode", lineCode);
		return dao.selectOne(LAW_DEFINE + ".queryLawDefineByDeptCode", whereMap);
	}

	// 查询基本法 根据versionId
	public LawDefine getLawDefineByPkId(String pkid) {
		return dao.selectOne(LAW_DEFINE + ".selectByPrimaryKeyVo", pkid);
	}

	@Override
	public boolean saveDefine(LawDefine... lawDefine) {
		return false;
	}

	@Override
	public List<Map<String, Object>> queryImportList(Map<String, Object> whereMap) {
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + ".queryImportList", whereMap);
		return rows;
	}

	@Override
	public boolean existValidVersion(Map<String, Object> whereMap) {
		return ((Long) dao.selectOne(LAW_DEFINE + ".existValidVersion", whereMap)) > 0;
	}

	@Override
	public void updateLawDefine(Map<String, Object> whereMap) {
		dao.update(LAW_DEFINE + ".updateLawDefineByPK", whereMap);
	}

	// 查询管理办法，用于下拉框
	public List<Map<String, Object>> queryLawDefineForSelect(String deptCode) {
		return dao.selectList(LAW_DEFINE + ".queryLawDefineForSelect", deptCode);
	}

	@Override
	public PageDto queryPageFactor(PageDto pageDto) {
		pageDto.setTotal(100000000l);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + ".queryPageFactor", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto queryPageImport(PageDto pageDto) {
		pageDto.setTotal(100000000l);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + ".queryPageImport", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto queryPageExamine(PageDto pageDto) {
		pageDto.setTotal(100000000l);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + ".queryPageExamine", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto queryPageIndex(PageDto pageDto) {
		pageDto.setTotal(100000000l);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + ".queryPageIndex", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto queryPageRank(PageDto pageDto) {
		pageDto.setTotal(100000000l);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + ".queryPageRank", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto queryPageReview(PageDto pageDto) {
		pageDto.setTotal(100000000l);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE + ".queryPageReview", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	/**
	 * <pre>
	 * 功能：保存系统因素 
	 * 说明：系统因素代码不可以重复添加，所以通itemCode和versionId判断是新增还是修改。
	 * </pre>
	 */
	@Override
	public void updateFactorSystem(Map<String, Object> paraMap) {
		String jsonStr = (String) paraMap.get("jsonStr");
		String versionId = (String) paraMap.get("versionId");
		String updatedUser = (String) paraMap.get("updatedUser");
		String itemType = (String) paraMap.get("itemType");
		List<Map<String, Object>> list = JSON.parseObject(jsonStr, new TypeReference<List<Map<String, Object>>>() {
		});
		for (Map<String, Object> map : list) {
			map.put("versionId", versionId);
			map.put("createdUser", updatedUser);
			map.put("updatedUser", updatedUser);
			map.put("itemType", itemType);
			boolean existsFlag = ((Long) dao.selectOne(LAW_DEFINE + ".existsFactorSystem", map)) > 0;
			if (existsFlag) {
				dao.update(LAW_DEFINE + ".updateFactorSystem", map);
			} else {
				dao.update(LAW_DEFINE + ".insertFactorSystem", map);
			}
		}
	}

	/**
	 * <pre>
	 * 功能：保存导入因素 
	 * 说明：导入因素代码不可以重复添加，所以通itemCode和versionId判断是新增还是修改。
	 * </pre>
	 */
	@Override
	public void updateFactorImport(Map<String, Object> paraMap) {
		String jsonStr = (String) paraMap.get("jsonStr");
		String versionId = (String) paraMap.get("versionId");
		String updatedUser = (String) paraMap.get("updatedUser");
		String itemType = (String) paraMap.get("itemType");
		List<Map<String, Object>> list = JSON.parseObject(jsonStr, new TypeReference<List<Map<String, Object>>>() {
		});
		for (Map<String, Object> map : list) {
			map.put("versionId", versionId);
			map.put("createdUser", updatedUser);
			map.put("updatedUser", updatedUser);
			map.put("itemType", itemType);
			String itemCode = (String) map.get("itemCode");
			String itemName = (String) map.get("itemName");
			if (StringUtils.isBlank(itemCode) || StringUtils.isBlank(itemName))
				continue;
			boolean existsFlag = ((Long) dao.selectOne(LAW_DEFINE + ".existsFactorImport", map)) > 0;
			if (existsFlag) {
				dao.update(LAW_DEFINE + ".updateFactorImport", map);
			} else {
				dao.update(LAW_DEFINE + ".insertFactorImport", map);
			}
		}
	}

	/**
	 * <pre>
	 * 功能：保存考核因素 
	 * 说明：考核因素代码不可以重复添加，所以通itemCode和versionId判断是新增还是修改。
	 * </pre>
	 */
	@Override
	public void updateFactorExamine(Map<String, Object> paraMap) {
		String jsonStr = (String) paraMap.get("jsonStr");
		String versionId = (String) paraMap.get("versionId");
		String updatedUser = (String) paraMap.get("updatedUser");
		String itemType = (String) paraMap.get("itemType");
		List<Map<String, Object>> list = JSON.parseObject(jsonStr, new TypeReference<List<Map<String, Object>>>() {
		});
		for (Map<String, Object> map : list) {
			map.put("versionId", versionId);
			map.put("createdUser", updatedUser);
			map.put("updatedUser", updatedUser);
			map.put("itemType", itemType);
			boolean existsFlag = ((Long) dao.selectOne(LAW_DEFINE + ".existsFactorExamine", map)) > 0;
			if (existsFlag) {
				dao.update(LAW_DEFINE + ".updateFactorExamine", map);
			} else {
				dao.update(LAW_DEFINE + ".insertFactorExamine", map);
			}
		}
	}

	/**
	 * <pre>
	 * 功能：保存计算公式 
	 * 说明：计算公式的代码可以重复添加，所以通itemCode和versionId判断是新增还是修改。
	 * </pre>
	 */
	@Override
	public void updateLawIndex(Map<String, Object> paraMap) {
		String pkId = "";
		String jsonStr = (String) paraMap.get("jsonStr");
		String versionId = (String) paraMap.get("versionId");
		String updatedUser = (String) paraMap.get("updatedUser");
		String itemType = (String) paraMap.get("itemType");
		List<Map<String, Object>> list = JSON.parseObject(jsonStr, new TypeReference<List<Map<String, Object>>>() {
		});
		for (Map<String, Object> map : list) {
			map.put("versionId", versionId);
			map.put("createdUser", updatedUser);
			map.put("updatedUser", updatedUser);
			map.put("itemType", itemType);
			pkId = (String) map.get("pkId");
			// 如果页面上pkid为空
			if (StringUtils.isBlank(pkId)) {
				// 数据库是否存在
				pkId = (String) dao.selectOne(LAW_DEFINE + ".existsFormulaCalc", map);
				// 数据库也不存在，则插入
				if (StringUtils.isBlank(pkId)) {
					dao.update(LAW_DEFINE + ".insertLawIndex", map);
				} else {
					map.put("pkId", pkId);
					dao.update(LAW_DEFINE + ".updateLawIndex", map);
				}
			} else {
				// 如果页面上pkid非空
				dao.update(LAW_DEFINE + ".updateLawIndex", map);
			}
		}
	}

	/**
	 * <pre>
	 * 功能：保存考核公式 
	 * 说明：考核公式的代码可以重复添加，所以通itemCode和versionId判断是新增还是修改。
	 * </pre>
	 */
	@Override
	public void updateLawReview(Map<String, Object> paraMap) {
		String pkId = "";
		String jsonStr = (String) paraMap.get("jsonStr");
		String versionId = (String) paraMap.get("versionId");
		String updatedUser = (String) paraMap.get("updatedUser");
		String itemType = (String) paraMap.get("itemType");
		List<Map<String, Object>> list = JSON.parseObject(jsonStr, new TypeReference<List<Map<String, Object>>>() {
		});
		for (Map<String, Object> map : list) {
			map.put("versionId", versionId);
			map.put("createdUser", updatedUser);
			map.put("updatedUser", updatedUser);
			map.put("itemType", itemType);
			pkId = (String) map.get("pkId");
			// 如果页面上pkid为空
			if (StringUtils.isBlank(pkId)) {
				// 数据库是否存在
				pkId = (String) dao.selectOne(LAW_DEFINE + ".existsFormulaReview", map);
				// 数据库也不存在，则插入
				if (StringUtils.isBlank(pkId)) {
					dao.update(LAW_DEFINE + ".insertLawReview", map);
				} else {
					map.put("pkId", pkId);
					dao.update(LAW_DEFINE + ".updateLawReview", map);
				}
			} else {
				// 如果页面上pkid非空
				dao.update(LAW_DEFINE + ".updateLawReview", map);
			}
		}
	}

	/**
	 * <pre>
	 * 功能：新增基本法时，如果部门已经存在基本法，则下拉框中移除该部门 
	 * 说明：功能不实用，已经废除。
	 * </pre>
	 */
	@Override
	public List<Map<String, Object>> queryDeptCodeList() {
		String arr[][] = deptTwo;
		List<Map<String, Object>> list1 = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> list2 = dao.selectList(LAW_DEFINE + ".queryDeptCodeList", "");
		List<Map<String, Object>> list3 = new ArrayList<Map<String, Object>>();
		// 数组转为list
		for (int i = 0; i < arr.length; i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("value", arr[i][0]);
			map.put("text", arr[i][1]);
			list1.add(map);
		}
		// 去除已有的部门
		for (int i = 0; i < list1.size(); i++) {
			boolean flag = true;
			String str1 = (String) list1.get(i).get("value");
			for (int j = 0; j < list2.size(); j++) {
				String str2 = (String) list2.get(j).get("deptCode");
				if (str1.equals(str2)) {
					flag = false;
				}
			}
			if (flag)
				list3.add(list1.get(i));
		}
		return list3;
	}

	@Override
	public void updateLawRank(Map<String, Object> paraMap) {
		String jsonStr = (String) paraMap.get("jsonStr");
		String updatedUser = (String) paraMap.get("updatedUser");
		List<Map<String, Object>> list = JSON.parseObject(jsonStr, new TypeReference<List<Map<String, Object>>>() {
		});
		for (Map<String, Object> map : list) {
			map.put("updatedUser", updatedUser);
			dao.update(LAW_DEFINE + ".updateLawRank", map);
		}
	}

	@Override
	public void manualCalculation(String versionId, String deptCode, String lineCode) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("versionId", versionId);
		parameter.put("deptCode", deptCode);
		parameter.put("lineCode", "925007");
		parameter.put("username", CurrentUser.getUser().getUserCode().split("@")[0]);
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, -1);
		parameter.put("calcMonth", new SimpleDateFormat("yyyyMM").format(calendar.getTime()));
		dao.selectOne(LAW_DEFINE + ".manualCalculation", parameter);
	}

	@Override
	public Long queryBasicLaw(String deptCode) {
		Long basicLaw = dao.selectOne(LAW_DEFINE + ".queryBasicLaw", deptCode);
		return basicLaw;
	}

	@Override
	public Long queryBasicLawArea(String deptCode) {
		Long basicLawArea = dao.selectOne(LAW_DEFINE + ".queryBasicLawArea", deptCode);
		return basicLawArea;
	}
	/**
	 * 查询客户经理（团队经理）规则
	 */
	public List<Map<String, Object>> queryRules(Map<String, Object> map) {
		List<Map<String, Object>> list = dao.selectList(LAW_DEFINE + ".queryRules", map);
		return list;
	}

	@Override
	public String validateFormula(String versionId) {
		Map<String,Object> param = new HashMap<String, Object>();
		param.put("i_version_id", versionId);
		dao.selectOne(LAW_DEFINE + ".validateFormula", param);
		String resultMsg = param.get("result").toString();
		return resultMsg;
	}
}
