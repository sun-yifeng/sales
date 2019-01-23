package com.sinosafe.xszc.channel.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.hf.framework.service.mail.Mail;
import com.hf.framework.service.mail.MailType;
import com.sinosafe.xszc.util.MailUtil;

/*
 * 功能描述
 * 
 * 1、测试邮件服务器、用户、密码是否正常
 * 2、测试邮件模板样式、邮件内容是否正常
 * 
 */
public class TestMailServer {

	private static final Log log = LogFactory.getLog(TestMailServer.class);

	private static ClassPathXmlApplicationContext context;
	private static TestMailService testMailService;

	private static Map<String, String> model;
	private static Mail mail;

	@BeforeClass
	public static void setUpBeforeClass() throws Throwable {

		log.debug("测试开始...");

		context = new ClassPathXmlApplicationContext("com/sinosafe/xszc/channel/service/impl/test-applicationContext.xml");

		testMailService = (TestMailService) context.getBean("testMailService");

		// model
		model = new HashMap<String, String>();
		model.put("channelCode", "0503015732");
		model.put("channelName", "廖祖明");
		model.put("conferId", "B416148455");
		model.put("reportDate", new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
		// mail
		mail = new Mail();
		mail.setForm(MailUtil.getMailNick() + "<xszc@sinosafe.com.cn>");
		mail.setTo(new String[] { "sunyifeng@sinosafe.com.cn" });
		mail.setMailType(MailType.HTML_TEMPLATE);
		mail.setModel(model);

	}

	/**
	 * 协议到期预警邮件发送
	 */
	@Test
	public void testMailWarnConfer() {
		model.put("conferCode", "A1236DCC");
		mail.setSubject("销售渠道协议到期预警");
		mail.setTemplate("MailTemplateWarnChannelConfer.vm");
		testMailService.send(mail);
	}

	/**
	 * 资格证到期预警邮件发送
	 */
	@Test
	public void testMailWarnLicence() {
		mail.setSubject("销售渠道经营许可证(或执业证)到期预警");
		mail.setTemplate("MailTemplateWarnChannelLicence.vm");
		testMailService.send(mail);
	}

	/**
	 * 合同到期预警邮件发送
	 */
	@Test
	public void testMailWarnContract() {
		mail.setSubject("销售渠道合同 到期预警");
		mail.setTemplate("MailTemplateWarnChannelContract.vm");
		testMailService.send(mail);
	}

	@AfterClass
	public static void tearDownAfterClass() throws Throwable {
		context.close();
		log.debug("测试结束...");
	}

}
