package com.sinosafe.xszc.channel.service.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.quartz.Scheduler;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class TestMailQuartz {

	private static final Log log = LogFactory.getLog(TestMailQuartz.class);

	private static ClassPathXmlApplicationContext context;
	private static Scheduler scheduler;

	@BeforeClass
	public static void setUpBeforeClass() throws Throwable {

		log.debug("测试开始...");
		context = new ClassPathXmlApplicationContext("com/sinosafe/xszc/channel/service/impl/test-applicationContext.xml");
		scheduler = (Scheduler) context.getBean("scheduler");
		log.info("启动定时任务调度器...");
		scheduler.start();

	}

	@Test
	@SuppressWarnings("static-access")
	public void testQuartzScheduler() throws Throwable {
		Thread.currentThread().sleep(1000 * 180); // 运行180秒后停止
	}

	@AfterClass
	public static void tearDownAfterClass() throws Throwable {
		context.close();
		log.debug("测试结束...");
	}

}
