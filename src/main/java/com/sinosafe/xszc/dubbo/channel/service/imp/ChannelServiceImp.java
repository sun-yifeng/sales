package com.sinosafe.xszc.dubbo.channel.service.imp;

import static com.sinosafe.xszc.dubbo.sqlmapper.MapperNameSpace.CHANNEL;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.dubbo.channel.service.ChannelService;

@Service("channelService")
public class ChannelServiceImp implements ChannelService {

	private static final Log log = LogFactory.getLog(ChannelServiceImp.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public List<Map<String, Object>> findPersonByMap(Map<String, Object> whereMap) {
		List<Map<String, Object>> resultList = dao.selectList(CHANNEL + ".findPersonByMap", whereMap);
		log.debug("模糊查询个人代理人返回的结果：" + JSON.toJSONString(resultList));
		return resultList;
	}

	@Override
	public List<Map<String, Object>> findPersonByList(List<String> wherelist) {
		List<Map<String, Object>> resultList = dao.selectList(CHANNEL + ".findPersonByList", wherelist);
		log.debug("精准查询个人代理人返回的结果：" + JSON.toJSONString(resultList));
		return resultList;
	}

	@Override
	public List<Map<String, Object>> findMediumByMap(Map<String, Object> whereMap) {
		List<Map<String, Object>> resultList = dao.selectList(CHANNEL + ".findMediumByMap", whereMap);
		log.debug("模糊查询中介机构返回的结果：" + JSON.toJSONString(resultList));
		return resultList;
	}

	@Override
	public List<Map<String, Object>> findMediumByList(List<String> wherelist) {
		List<Map<String, Object>> resultList = dao.selectList(CHANNEL + ".findMediumByList", wherelist);
		log.debug("精准查询中介机构返回的结果：" + JSON.toJSONString(resultList));
		return resultList;
	}

}
