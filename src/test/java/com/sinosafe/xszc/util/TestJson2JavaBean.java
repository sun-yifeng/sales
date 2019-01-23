package com.sinosafe.xszc.util;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;

/**
 * JSON同JAVABEAN互转
 */
public class TestJson2JavaBean {

	private static final Log log = LogFactory.getLog(TestJson2JavaBean.class);

	/**
	 * 序列化
	 */
	public void toJsonString() {
		User user = new User("testFastJson001", "maks", 105);
		String text = JSON.toJSONString(user);
		log.debug("toJsonString()方法：text=" + text);
		// 输出结果：text={"age":105,"id":"testFastJson001","name":"maks"}
	}

	/**
	 * 反序列化为json对象
	 */
	public void parseJsonObject() {
		String text = "{\"age\":105,\"id\":\"testFastJson001\",\"name\":\"maks\"}";
		JSONObject json = JSON.parseObject(text);
		log.debug("parseJsonObject()方法：json==" + json);
		// 输出结果：json=={"age":105,"id":"testFastJson001","name":"maks"}
	}

	/**
	 * 反序列化为javaBean对象
	 */
	public void parseBeanObject() {
		String text = "{\"age\":105,\"id\":\"testFastJson001\",\"name\":\"maks\"}";
		User user = (User) JSON.parseObject(text, User.class);
		log.debug("parseBeanObject()方法：user==" + user.getId() + "," + user.getName() + "," + user.getAge());
		// 输出结果：user==testFastJson001,maks,105
	}

	/**
	 * 将javaBean转化为json对象
	 */
	public void bean2Json() {
		User user = new User("testFastJson001", "maks", 105);
		JSONObject jsonObj = (JSONObject) JSON.toJSON(user);
		log.debug("bean2Json()方法：jsonObj==" + jsonObj);
		// 输出结果：jsonObj=={"age":105,"id":"testFastJson001","name":"maks"}
	}

	/**
	 * 全序列化 直接把javaBean序列化为json文本之后，能够按照原来的类型反序列化回来。支持全序列化，需要打开SerializerFeature
	 * .WriteClassName特性
	 */
	public void parseJSONAndBeanEachother() {
		// 1.将javaBean转换为JSON
		User user = new User("testFastJson001", "maks", 105);
		SerializerFeature[] featureArr = { SerializerFeature.WriteClassName };
		String text = JSON.toJSONString(user, featureArr);
		log.debug("parseJSONAndBeanEachother()方法：text==" + text);
		// 输出结果：text=={"@type":"fastJson.test.User","age":105,"id":"testFastJson001","name":"maks"}
		// 2.将JSON转换为javaBean
		User userObj = (User) JSON.parse(text);
		log.debug("parseJSONAndBeanEachother()方法：userObj==" + userObj.getId() + "," + userObj.getName() + "," + userObj.getAge());
		// 输出结果：userObj==testFastJson001,maks,105
	}

	public static void main(String[] args) {
		TestJson2JavaBean test = new TestJson2JavaBean();
		// 序列化
		test.toJsonString();
		// 反序列化为json对象
		test.parseJsonObject();
		// 反序列化为javaBean对象
		test.parseBeanObject();
		// 将javaBean转化为json对象
		test.bean2Json();
		// 全序列化
		test.parseJSONAndBeanEachother();
	}
}