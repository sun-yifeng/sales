package com.sinosafe.xszc.dubbo.salesman.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.sinosafe.xszc.dubbo.salesman.service.SalesmanService;

public class SalesmanServiceTest {
	
	private static final Log log = LogFactory.getLog(SalesmanServiceTest.class);

	private static ClassPathXmlApplicationContext context;
	private static SalesmanService salesmanService;

	@BeforeClass
	public static void setUpBeforeClass() throws Throwable {
		log.debug("测试开始...");
		context = new ClassPathXmlApplicationContext("test-app-context-dubbo.xml");
		salesmanService = (SalesmanService) context.getBean("salesmanService");
	}

	@Test
	public void testFindSalesmanByMap() throws Throwable {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("deptCode", "12"); // 机构代码,可选
		whereMap.put("employCode", "112058376"); // 工号,可选
		whereMap.put("salesmanName", "陈"); // 姓名,可选
		salesmanService.findSalesmanByMap(whereMap);
	}
	
	@Test
	public void testFindSalesmanByList() throws Throwable {
		List<String> list = new ArrayList<String>();
		list.add("126030456"); // 工号
		list.add("119067222"); // 工号
		list.add("108061122"); // 工号
		list.add("125029403"); // 工号
		salesmanService.findSalesmanByList(list);
	}
	@Test
	public void TestFindSalesmanByEmploy_codeAndCertify_noMap() throws Exception{
	  for(int i=0; i<5; i++){
		Map<String, String> map=new HashMap<String, String>();
//		map.put("employCode", "125029403");//工号不能为空
//		map.put("certifyNo", "130722198306230012");//证件号不能为空
//		map.put("salesmanCname", "底晓勇");//姓名不能为空
		salesmanService.findSalesmanByEmployCodeCertifyNoNameMap(map);
	  }
	}
	
	

	@AfterClass
	public static void tearDownAfterClass() throws Throwable {
		context.close();
		log.debug("测试结束...");
	}

}
