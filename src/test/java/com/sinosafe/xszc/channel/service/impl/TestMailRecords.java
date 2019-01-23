package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL_MAIL_RECORD;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.alibaba.fastjson.JSON;
import com.hf.framework.dao.CommonDao;

public class TestMailRecords {

	private static final Log log = LogFactory.getLog(TestMailRecords.class);

	private static ClassPathXmlApplicationContext context;

	CommonDao dao = null;

	@Before
	public void setUp() throws Exception {
		log.debug("取收件人邮件地址,测试开始...");
		context = new ClassPathXmlApplicationContext("com/sinosafe/xszc/channel/service/impl/test-applicationContext.xml");
		dao = (CommonDao) context.getBean("baseDao");
	}

	/**
	 * 取收件人邮件地址
	 */
	@Test
	public void getMails() {
		List<Map<String, Object>> validRows = this.dao.selectList(CHANNEL_MAIL_RECORD + ".findValidRows", 15);
		log.debug("提前15天要发送的邮件,渠道数目:" + validRows.size());
		log.debug("提前15天要发送的邮件:" + JSON.toJSONString(validRows));
	}

	@AfterClass
	public static void tearDownAfterClass() throws Throwable {
		context.close();
		log.debug("取收件人邮件地址，测试结束...");
	}
}
