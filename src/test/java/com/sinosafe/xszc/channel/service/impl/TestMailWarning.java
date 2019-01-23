package com.sinosafe.xszc.channel.service.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class TestMailWarning {

	private static final Log log = LogFactory.getLog(TestMailWarning.class);

	private static ClassPathXmlApplicationContext context;
	private static ChannelMailRecordServiceImpl channelMailRecordService;

	@BeforeClass
	public static void setUpBeforeClass() throws Throwable {
		log.debug("测试开始...");
		context = new ClassPathXmlApplicationContext("com/sinosafe/xszc/channel/service/impl/test-applicationContext.xml");
		channelMailRecordService = (ChannelMailRecordServiceImpl) context.getBean("channelMailRecordService");
	}


	@Test
	public void testSendMailByTime() throws Throwable {
		channelMailRecordService.sendMailByTime();
	}

	@AfterClass
	public static void tearDownAfterClass() throws Throwable {
		context.close();
		log.debug("测试结束...");
	}

}
