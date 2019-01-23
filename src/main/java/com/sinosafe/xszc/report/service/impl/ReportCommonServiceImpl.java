package com.sinosafe.xszc.report.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SALESMAN;

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

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.report.service.ReportCommonService;
import com.sinosafe.xszc.util.PageDto;

public class ReportCommonServiceImpl implements ReportCommonService {

	private static final Log log = LogFactory.getLog(ReportCommonServiceImpl.class);

	private static final String MAPPER_NAME_SPACE = "com.sinosafe.xszc.report.vo.ReportCommon";

	@Autowired
	@Qualifier("baseDao")
	private CommonDao commonDao;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@Override
	public List<Map<String, Object>> findInfo(Map<String, Object> requestMap) {
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		Map<String, Object> resultMap = commonDao.selectOne(MAPPER_NAME_SPACE + ".query", requestMap);
		requestMap.putAll(resultMap);
		Map<String, Object> deptMap = umService.findDefaultDeptCodeByUserCode(CurrentUser.getUser().getUserCode());
		String deptCode = null;
		if (deptMap != null && !deptMap.get("deptCode").equals("00")) {
			deptCode = (String) deptMap.get("deptCode") + "%";
		}
		requestMap.put("param1Value", deptCode);
		resultList = commonDao.selectList(MAPPER_NAME_SPACE + ".queryInfo", requestMap);
		return resultList;
	}

	@Override
	public List<Map<String, Object>> getOptions(Map<String, Object> requestMap) {
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		resultList = commonDao.selectList(MAPPER_NAME_SPACE + ".queryOptions", requestMap);
		return resultList;
	}

	/**
	 * 
	 * 简要说明:查出登录者的团队信息 <br>
	 * 
	 * <pre>
	 * 方法getCurUserGroupMsg的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年8月14日 上午10:05:44
	 * </pre>
	 */
	@Override
	public Map<String, Object> getCurUserGroupMsg() {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		String userName = CurrentUser.getUser().getUsername();
		if (userName.contains("@")) {
			userName = userName.substring(0, userName.indexOf("@"));
		}
		whereMap.put("userName", userName);
		Map<String, Object> resultMap = commonDao.selectOne(MAPPER_NAME_SPACE + ".getCurUserGroupMsg", whereMap);
		if (resultMap != null) {
			resultMap = this.getMultiDeptInfo(resultMap);
		}
		return resultMap;
	}

	public Map<String, Object> getMultiDeptInfo(Map<String, Object> row) {
		log.debug("查询多级机构的代码及名称开始...");
		Map<String, Object> deptMap = new HashMap<String, Object>();
		String deptCode = (String) row.get("deptCode");
		if (deptCode != null) {
			// 由于HR人员的的机构代码，有的是4位，有的两位，有的是00，所以在代码中特殊处理
			if (deptCode.length() == 8) {
				deptMap = commonDao.selectOne(SALESMAN + ".getMultiDeptInfo", deptCode);
			} else if (deptCode.length() == 4) {
				deptMap = commonDao.selectOne(SALESMAN + ".getMultiDeptMark", deptCode);
			} else if (deptCode.length() == 2) {
				deptMap = commonDao.selectOne(SALESMAN + ".getMultiDeptProd", deptCode);
			} else {
				log.warn("查询多级机构的代码及名称时，机构代码异常，机构代码：" + deptCode);
			}

			if (deptMap != null) {
				row.put("deptCodeFour", deptCode);
				row.put("deptNameFour", deptMap.get("deptNameFour"));
				row.put("deptCodeThree", deptMap.get("deptCodeThree"));
				row.put("deptNameThree", deptMap.get("deptNameThree"));
				row.put("deptCodeTwo", deptMap.get("deptCodeTwo"));
				row.put("deptNameTwo", deptMap.get("deptNameTwo"));
			}
		}
		log.debug("查询多级机构的代码及名称结束...");
		return row;
	}

	/*
	 * 根据表名生成报表查询或导出,通用方法
	 */
	@Override
	public PageDto queryReportList(PageDto pageDto) {
		String operType = (String) pageDto.getWhereMap().get("operType");
		String tableCols = (String) pageDto.getWhereMap().get("tableCols");
		Map<String, Object> sqlMap = getReportSql(pageDto);
		System.out.println("reportSql:" + sqlMap.get("execSql"));
		pageDto.getWhereMap().put("execSql", sqlMap.get("execSql"));
		pageDto.getWhereMap().put("columName", sqlMap.get("columName"));
		Long total = commonDao.selectOne(MAPPER_NAME_SPACE + ".queryReportCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		//
		if ("1".equals(operType)) {
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		} else if ("2".equals(operType)) {
			pageDto.getWhereMap().put("endpoint", total);
		}
		List<Map<String, Object>> resultList = commonDao.selectList(MAPPER_NAME_SPACE + ".queryReportListPage", pageDto.getWhereMap());
		pageDto.setRows(addDuplicate(tableCols, resultList));
		return pageDto;
	}

	/**
	 * 业绩跟踪日报表
	 * 
	 * @see com.sinosafe.xszc.report.service.ReportCommonService#queryDayGroupReportList(com.sinosafe.xszc.util.PageDto)
	 */
	public PageDto queryDayGroupReportList(PageDto pageDto) {
		String operType = (String) pageDto.getWhereMap().get("operType");
		String curDeptCode = (String) pageDto.getWhereMap().get("curDeptCode");
		// 如果当前登录的用户非总部管理员或分公司人员慢传入当前用户进行判断
		if (curDeptCode.length() > 2) {
			IUserDetails curuser = CurrentUser.getUser();
			String loginCode = curuser.getUserCode();
			if (loginCode.indexOf("@") > -1) {
				loginCode = loginCode.split("@")[0];
			}
			pageDto.getWhereMap().put("loginCode", loginCode);
		}
		Long total = commonDao.selectOne(MAPPER_NAME_SPACE + ".queryDayGroupReportListCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		if ("1".equals(operType)) {
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		} else if ("2".equals(operType)) {
			pageDto.getWhereMap().put("endpoint", total);
		}
		List<Map<String, Object>> resultList = commonDao.selectList(MAPPER_NAME_SPACE + ".queryDayGroupReportListByPage", pageDto.getWhereMap());
		pageDto.setRows(resultList);
		return pageDto;
	}

	/**
	 * 业绩跟踪月报表
	 * 
	 * @see com.sinosafe.xszc.report.service.ReportCommonService#queryMonthGroupReportList(com.sinosafe.xszc.util.PageDto)
	 */
	@Override
	public PageDto queryMonthGroupReportList(PageDto pageDto) {
		String operType = (String) pageDto.getWhereMap().get("operType");
		Long total = commonDao.selectOne(MAPPER_NAME_SPACE + ".queryMonthGroupReportListCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}

		if ("1".equals(operType)) {
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		} else if ("2".equals(operType)) {
			pageDto.getWhereMap().put("endpoint", total);
		}
		List<Map<String, Object>> resultList = commonDao.selectList(MAPPER_NAME_SPACE + ".queryMonthGroupReportListByPage", pageDto.getWhereMap());
		pageDto.setRows(resultList);
		return pageDto;
	}

	/**
	 * 团队排行榜查询
	 */
	@Override
	public PageDto queryMonthGroupPaihangList(PageDto pageDto) {
		String operType = (String) pageDto.getWhereMap().get("operType");
		Long total = commonDao.selectOne(MAPPER_NAME_SPACE + ".queryGroupPaihangCount", pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}

		if ("1".equals(operType)) {
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		} else if ("2".equals(operType)) {
			pageDto.getWhereMap().put("endpoint", total);
		}
		List<Map<String, Object>> resultList = commonDao.selectList(MAPPER_NAME_SPACE + ".queryGroupPaihang", pageDto.getWhereMap());
		pageDto.setRows(resultList);
		return pageDto;
	}

	/**
	 * 根据表名生成报表查询或导出的SQL
	 * 
	 * @param tableName
	 * @return sql
	 */
	public Map<String, Object> getReportSql(PageDto pageDto) {
		String tableName = (String) pageDto.getWhereMap().get("tableName");
		String tableCols = (String) pageDto.getWhereMap().get("tableCols");
		Map<String, Object> paramMap = pageDto.getWhereMap();
		log.debug("页面配置table:" + tableName);
		log.debug("页面配置json :" + tableCols);
		String execSql = "select ", whereSql = "", orderBySql = "";
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList1 = removeDuplicate(tableCols);
		List<Map<String, Object>> resultList2 = getColumName(tableName);
		// select
		for (Iterator<Map<String, Object>> iterator1 = resultList1.iterator(); iterator1.hasNext();) {
			Map<String, Object> map1 = (Map<String, Object>) iterator1.next();
			String colName1 = StringUtils.trim((String) map1.get("name"));
			String alias = StringUtils.trim((String) map1.get("alias"));
			Boolean percent = (Boolean) map1.get("percent");
			Boolean equal = (Boolean) map1.get("equal");
			Boolean like = (Boolean) map1.get("like");
			Boolean dept = (Boolean) map1.get("dept");
			Boolean round = (Boolean) map1.get("round");
			colName1 = StringUtils.isBlank(alias) ? colName1 : alias;
			for (Iterator<Map<String, Object>> iterator = resultList2.iterator(); iterator.hasNext();) {
				Map<String, Object> map2 = (Map<String, Object>) iterator.next();
				String colName2 = (String) map2.get("columnName");
				String dataType = (String) map2.get("dataType");
				String camelStr = getCamelStr(colName2);
				if (colName1 != null && colName1.equals(camelStr)) {
					if ("NUMBER".equals(dataType)) {
						if (percent != null && percent) {
							execSql += "to_char(" + colName2.toUpperCase() + "*100, \'fm99999999999990.00\') || \'%\'";
						} else if (round != null && round) {
							execSql += "to_char(" + colName2.toUpperCase() + ", \'fm99999999999990\')";
						} else {
							execSql += "to_char(" + colName2.toUpperCase() + ", \'fm99999999999990.00\')";
						}
					} else if ("DATE".equals(dataType)) {
						execSql += "to_char(" + colName2.toUpperCase() + ", \'yyyy-mm-dd\')";
					} else {
						execSql += colName2.toUpperCase();
					}
					// 拼装as
					execSql += " as \"" + camelStr;
					execSql += "\",";
					// where
					String value = StringUtils.trim((String) paramMap.get(colName1));
					if (null != equal && equal && StringUtils.isNotBlank(value)) {
						if (null != dept && dept) {
							whereSql += " and " + colName2.toUpperCase() + " = F_GET_REPORT_DEPT(\'" + value + "\')";
						} else {
							whereSql += " and " + colName2.toUpperCase() + " = \'" + value + "\'";
						}
					} else if (like != null && like && StringUtils.isNotBlank(value)) {
						whereSql += " and " + colName2.toUpperCase() + " like \'%" + value + "%\'";
					}
					// order by
					if(null != dept && dept){				
						orderBySql += "," + colName2.toUpperCase();
					}
					if("insureType".equals(colName1) && colName1.equals(camelStr)){
						orderBySql += "," + "DECODE(INSURE_TYPE, '车险',1,'财产险',2,'人身险',3,'')";
					}
				}
			}
		}
		// end for
		execSql = execSql.substring(0, execSql.length() - 1);
		// from
		execSql += " from " + tableName;
		// where
		execSql += " where 1=1 " + whereSql;
		// order by
		if (StringUtils.isNotBlank(orderBySql)) {
			orderBySql = orderBySql.trim();
			execSql += " order by " + orderBySql.substring(1);
		}
		log.debug("动态生成报表的sql:" + execSql);
		log.debug("页面配置导出列col:" + JSONObject.toJSONString(getExpColumn(tableCols)));
		returnMap.put("execSql", execSql);
		returnMap.put("columName", getExpColumn(tableCols));
		return returnMap;
	}

	public List<Map<String, Object>> getColumName(String tableName) {
		Long count = (Long) commonDao.selectOne(MAPPER_NAME_SPACE + ".existsTable", tableName);
		if (count < 1)
			throw new RuntimeException("数据库中找不到表:" + tableName);
		return commonDao.selectList(MAPPER_NAME_SPACE + ".getColumName", tableName);
	}

	public String getCamelStr(String colName) {
		String str = "";
		String arr[] = colName.toLowerCase().split("_");
		str += arr[0];
		for (int i = 1; i < arr.length; i++) {
			str += arr[i].substring(0, 1).toUpperCase() + arr[i].substring(1);
		}
		return str;
	}

	public List<Map<String, Object>> removeDuplicate(String tableCols) {
		List<Map<String, Object>> jsonList = JSON.parseObject(tableCols, new TypeReference<List<Map<String, Object>>>() {
		});
		for (int i = 0; i < jsonList.size(); i++) {
			Map<String, Object> map1 = (Map<String, Object>) jsonList.get(i);
			String alias1 = (String) map1.get("alias");
			String name1 = (String) map1.get("name");
			for (int j = jsonList.size() - 1; j > i; j--) {
				Map<String, Object> map2 = (Map<String, Object>) jsonList.get(j);
				String alias2 = (String) map2.get("alias");
				String name2 = (String) map2.get("name");
				if (alias1 != null && alias1.equals(alias2)) {
					jsonList.remove(j);
					log.debug("提示！配置项有重复的alias:" + alias1);
				}
				if (name1 != null && name1.equals(name2)) {
					String header = (String) map2.get("header");
					throw new RuntimeException("错误！配置项有重复的name:" + name1 + ",header:" + header);
				}
			}
		}
		return jsonList;
	}

	public List<Map<String, Object>> addDuplicate(String tableCols, List<Map<String, Object>> resultList) {
		List<Map<String, Object>> jsonList = JSON.parseObject(tableCols, new TypeReference<List<Map<String, Object>>>() {
		});
		for (Iterator<Map<String, Object>> iterator1 = jsonList.iterator(); iterator1.hasNext();) {
			Map<String, Object> map = (Map<String, Object>) iterator1.next();
			String alias = (String) map.get("alias");
			String name = (String) map.get("name");
			for (int i = 0; i < resultList.size(); i++) {
				if (StringUtils.isNotBlank(alias)) {
					String value = (String) resultList.get(i).get(alias);
					resultList.get(i).put(name, value);
				}
				if (StringUtils.isNotBlank(name)) {
					String value = (String) resultList.get(i).get(name);
					if (StringUtils.isBlank(value) || value.equals("%"))
						resultList.get(i).put(name, "---");
				}
			}
		}
		return resultList;
	}

	public String[] getExpColumn(String tableCols) {
		int k = 0;
		List<Map<String, Object>> jsonList = JSON.parseObject(tableCols, new TypeReference<List<Map<String, Object>>>() {
		});
		String[] columnName = new String[jsonList.size()];
		for (int i = 0; i < jsonList.size(); i++) {
			Map<String, Object> map1 = (Map<String, Object>) jsonList.get(i);
			Boolean hide = (Boolean) map1.get("hide");
			String name = (String) map1.get("name");
			if ((hide != null && hide) || StringUtils.isBlank(name))
				continue;
			columnName[k] = name;
			k++;
		}
		return columnName;
	}
}
