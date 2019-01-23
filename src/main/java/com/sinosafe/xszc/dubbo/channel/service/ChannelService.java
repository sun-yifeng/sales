package com.sinosafe.xszc.dubbo.channel.service;

import java.util.List;
import java.util.Map;

public interface ChannelService {

  // 模糊查询个人代理人
  public List<Map<String, Object>> findPersonByMap(Map<String, Object> whereMap);

  // 精准查询个人代理人
  public List<Map<String, Object>> findPersonByList(List<String> wherelist);

  // 模糊查询中介机构
  public List<Map<String, Object>> findMediumByMap(Map<String, Object> whereMap);

  // 精准查询中介机构
  public List<Map<String, Object>> findMediumByList(List<String> wherelist);

}
