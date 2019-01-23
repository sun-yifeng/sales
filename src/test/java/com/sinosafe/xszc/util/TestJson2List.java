package com.sinosafe.xszc.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Test;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;

/**
 * JSON同List互转
 */
public class TestJson2List {

	private static final Log log = LogFactory.getLog(TestJson2List.class);

	// 1.将json字符串转化成JavaBean对象
	@Test
	public void testParseJavaBean() {
		User user = new User("1", "fastjson", 1);
		// 这里将javabean转化成json字符串
		String jsonString = JSON.toJSONString(user);
		log.debug("javaBean的json字符串:" + jsonString);
		// {"age":1,"id":"1","name":"fastjson"}
		// 这里将json字符串转化成javabean对象,
		user = JSON.parseObject(jsonString, User.class);
	}

	// 2将json字符串转化成List<JavaBean>对象
	@Test
	public void testParseList() {
		User user1 = new User("1", "fastjson1", 1);
		User user2 = new User("2", "fastjson2", 2);
		List<User> Users = new ArrayList<User>();
		Users.add(user1);
		Users.add(user2);
		String jsonString = JSON.toJSONString(Users);
		log.debug("List<JavaBean>的json字符串:" + jsonString);
		// [{"age":1,"id":"1","name":"fastjson1"},{"age":2,"id":"2","name":"fastjson2"}]
		// 解析json字符串
		List<User> Users2 = JSON.parseArray(jsonString, User.class);
		log.debug("将json字符串转化成List<JavaBean>对象:" + Users2);
	}

	// 3将json字符串转化成List<String>对象
	@Test
	public void testParseListStr() {
		List<String> list = new ArrayList<String>();
		list.add("fastjson1");
		list.add("fastjson2");
		list.add("fastjson3");
		String jsonString = JSON.toJSONString(list);
		log.debug("List<String>对象的json字符串:" + jsonString);
		// ["fastjson1","fastjson2","fastjson3"]
		// 解析json字符串
		List<String> list2 = JSON.parseObject(jsonString, new TypeReference<List<String>>() {
		});
		log.debug("将json字符串转化成List<String>对象:" + list2);
	}

	// 4将json字符串转化成List<Map<String,Object>>对象
	@Test
	public void testParseListMap() {
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("key1", "value1");
		map1.put("key2", "value2");
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("key1", 1);
		map2.put("key2", 2);
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list.add(map1);
		list.add(map2);
		String jsonString = JSON.toJSONString(list);
		log.debug("List<Map<String,Object>>的json字符串:" + jsonString);
		// [{"key1":"value1","key2":"value2"},{"key1":1,"key2":2}]
		// 解析json字符串
		List<Map<String, Object>> list2 = JSON.parseObject(jsonString, new TypeReference<List<Map<String, Object>>>() {
		});
		log.debug("将json字符串转化成List<Map<String,Object>>:" + list2);
	}
}