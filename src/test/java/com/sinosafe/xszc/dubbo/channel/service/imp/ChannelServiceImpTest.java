package com.sinosafe.xszc.dubbo.channel.service.imp;

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

import com.sinosafe.xszc.dubbo.channel.service.ChannelService;

public class ChannelServiceImpTest {

	private static final Log log = LogFactory.getLog(ChannelServiceImpTest.class);

	private static ClassPathXmlApplicationContext context;
	private static ChannelService channelService;

	@BeforeClass
	public static void setUpBeforeClass() throws Throwable {
		log.debug("测试开始...");
		context = new ClassPathXmlApplicationContext("test-app-context-dubbo.xml");
		channelService = (ChannelService) context.getBean("channelService");
	}

	@Test
	public void testFindPersonByMap() throws Throwable {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("deptCode", "12"); // 机构代码，可选参数
		whereMap.put("channelCode", "1203027915"); // 渠道代码，可选参数
		whereMap.put("channelName", "唐金"); // 渠道名称，可选参数
		List<Map<String, Object>> list = channelService.findPersonByMap(whereMap);
		log.debug("个人代理人的数量:" + list.size());
	}

	@Test
	public void testFindPersonByList() throws Throwable {
		List<String> list = new ArrayList<String>();
		list.add("1203027915"); // 渠道代码
		list.add("0203021720"); // 渠道代码
		list.add("0503032935"); // 渠道代码
		channelService.findPersonByList(list);
	}

	@Test
	public void testFindMediumByMap() throws Throwable {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("deptCode", "10"); // 机构代理
		whereMap.put("channelCode", "10020399019923"); // 渠道代理
		whereMap.put("channelName", "成都"); // 渠道名称
		channelService.findMediumByMap(whereMap);
	}

	@Test
	public void testFindMediumByList() throws Throwable {
		List<String> list = new ArrayList<String>();
		list.add("14020102011534"); // 渠道代码
		list.add("20020103012084"); // 渠道代码
		list.add("20020103012085"); // 渠道代码
		channelService.findMediumByList(list);
	}

	@AfterClass
	public static void tearDownAfterClass() throws Throwable {
		context.close();
		log.debug("测试结束...");
	}

}
