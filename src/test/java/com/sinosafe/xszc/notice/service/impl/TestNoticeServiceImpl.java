package com.sinosafe.xszc.notice.service.impl;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.sinosafe.xszc.notice.service.NoticeService;

public class TestNoticeServiceImpl {
	
	private static final Log log = LogFactory.getLog(TestNoticeServiceImpl.class);
	private static NoticeService noticeService;
	private static ApplicationContext  context;
	
	@Before
	public void beforeMethod(){
		log.info("测试开始...");
		try{
		 context = new ClassPathXmlApplicationContext("com/sinosafe/xszc/notice/service/impl/test-applicationContext.xml");
		}catch(Exception e){
			e.printStackTrace();
		}
		noticeService = (NoticeService)context.getBean("noticeService");
		log.info("context:"+ context);
		log.info("noticeService:"+ noticeService);
	}
	
	@Test
	public void test1(){
		noticeService.publishNoticeByDate();
	}
	
	@After
	public void afterMethod(){
		log.info("测试结束...");
	}

}
