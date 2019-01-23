package com.sinosafe.xszc.report.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.hf.framework.dao.CommonDaoImpl;

public class TestReportServiceImpl {

	private static final Log log = LogFactory.getLog(TestReportServiceImpl.class);

	private static final String MAPPER_NAME_SPACE = "com.sinosafe.xszc.report.vo.ReportCommon";

	private static ClassPathXmlApplicationContext context;
	// private static ReportCommonServiceImpl reportCommonService;
	private static String tableName;
	private static String jsonStr;
	private static CommonDaoImpl baseDao;

	@BeforeClass
	public static void setUpBeforeClass() {
		log.debug("Junit begin...");
		context = new ClassPathXmlApplicationContext("com/sinosafe/xszc/report/service/impl/test-applicationContext.xml");
		// reportCommonService = (ReportCommonServiceImpl) context.getBean("reportCommonService");
		baseDao = (CommonDaoImpl) context.getBean("baseDao");
		tableName = "REPORT_MONTH_SALE_TRACE_BUIS";
		jsonStr = "[{\"header\":\"分公司\",\"name\":\"deptNameTwo\",\"equalSign\":true}," + "{\"header\":\"三级机构\",\"name\":\"deptNameThree\",\"equalSign\":true},"
				+ "{\"header\":\"险种\",\"name\":\"insureType\",\"equalSign\":true}," + "{\"header\":\"保费计划(元)\",\"name\":\"premiumPlan\"},"
				+ "{\"header\":\"本年累计保费收入\",\"name\":\"incomeThisYear\"}," + "{\"header\":\"上年同期保费收入\",\"name\":\"incomeLastYear\"},"
				+ "{\"header\":\"同比增长率\",\"name\":\"yearIncreaseRate\",\"percent\":true}," + "{\"header\":\"上年同期保费增减值\",\"name\":\"termIncreaseRate\"},"
				+ "{\"header\":\"保费计划达成率\",\"name\":\"premiumPlanRate\",\"percent\":true},"
				+ "{\"header\":\"时间进度达成率\",\"name\":\"schedulePlanRate\",\"percent\":true}," + "{\"header\":\"保费收入（万元）\"}," + "{\"header\":\"签单净保费（万元）\"},"
				+ "{\"header\":\"前日\",\"name\":\"incomeBeforeDay\"}," + "{\"header\":\"昨日\",\"name\":\"incomeLastDay\"},"
				+ "{\"header\":\"今日\",\"name\":\"incomeThisDay\"}," + "{\"header\":\"本月\",\"name\":\"incomeThisMonth\"},"
				+ "{\"header\":\"本年累计\",\"name\":\"incomeThisYear\"}," + "{\"header\":\"前日\",\"name\":\"signBeforeDay\"},"
				+ "{\"header\":\"昨日\",\"name\":\"signLastDay\"}," + "{\"header\":\"今日\",\"name\":\"signThisDay\"},"
				+ "{\"header\":\"本月\",\"name\":\"signThisMonth\"}," + "{\"header\":\"本年\",\"name\":\"signThisYear\"},"
				+ "{\"header\":\"去年同期签单净保费\",\"name\":\"signLastYear\"}," + "{\"header\":\"本年签单净保费同期增长率\",\"name\":\"policyIncreaseRate\"}]";
	}

	@Test
	public void testConvertColName() {
		// 自动生成转换列，配置报表name
		String str = "\n";
		List<Map<String, Object>> list = baseDao.selectList(MAPPER_NAME_SPACE + ".getColumName", "REPORT_DAY_AGENT_CHANNEL_NEW");
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> map = list.get(i);
			String columnName = (String) map.get("columnName");
			String comments = (String) map.get("comments");
			str += i + ": " + columnName + ", " + getCamelStr(columnName) + ", " + comments + "\n";
		}
		log.debug("\n\n列名自动转换:" + str);
	}

	@Test
	public void testGetRreportSql() {
		// reportCommonService.getReportSql(null);
	}

	@Test
	public void testGetCamelStr() {
		// log.debug(reportCommonService.getCamelStr("DEPT_CODE_TWO"));
	}

	@Test
	public void testRemoveDuplicate() {
		log.debug("去除重复前的JSON:" + jsonStr);
		// List<Map<String, Object>> jsonList = reportCommonService.removeDuplicate(jsonStr);
		// log.debug("去除重复后的JSON:" + JSONObject.toJSONString(jsonList));
	}

	@AfterClass
	public static void tearDownAfterClass() throws Throwable {
		context.close();
		log.debug("Junit end...");
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

}
