package com.sinosafe.xszc.dubbo.salesman.service;

import java.util.List;
import java.util.Map;

public interface SalesmanService {

  // 根据工号或姓名查询业务员
  public List<Map<String, Object>> findSalesmanByMap(Map<String, Object> whereMap);

  // 根据工号、证件号、姓名查询业务员
  public List<Map<String, Object>> findSalesmanByEmployCodeCertifyNoNameMap(Map<String, String> whereMap) throws Exception;

  // 根据工号查询业务员，可以一次传入多个工号
  public List<Map<String, Object>> findSalesmanByList(List<String> wherelist);

  // 根据工号查询销售助理
  public List<Map<String, Object>> querySalesAssistant(String employNo);

  // 根据业务员的工号查询个人代理人
  public List<String> queryAllAgentByRecommender(String employNo);
}
