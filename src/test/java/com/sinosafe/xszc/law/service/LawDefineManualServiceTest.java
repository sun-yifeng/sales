package com.sinosafe.xszc.law.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class LawDefineManualServiceTest {

	private static final Log log = LogFactory.getLog(LawDefineManualServiceTest.class);

	private static ClassPathXmlApplicationContext context;
	private static LawDefineManualStepService lawDefineManualStepService;

	@BeforeClass
	public static void setUpBeforeClass() throws Throwable {
		log.debug("测试开始...");
		context = new ClassPathXmlApplicationContext("com/sinosafe/xszc/law/service/test-applicationContext.xml");
		lawDefineManualStepService = (LawDefineManualStepService) context.getBean("testService");
	}

	@Test
	public void testSaveManualTaskList() throws Throwable {
		lawDefineManualStepService.saveManualTaskList("");
	}

	@AfterClass
	public static void tearDownAfterClass() throws Throwable {
		context.close();
		log.debug("测试结束...");
	}
}