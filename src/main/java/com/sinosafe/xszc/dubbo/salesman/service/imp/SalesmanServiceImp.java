package com.sinosafe.xszc.dubbo.salesman.service.imp;

import static com.sinosafe.xszc.dubbo.sqlmapper.MapperNameSpace.SALESMAN;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.dubbo.salesman.service.SalesmanService;

/**
 * 要打印日志，不要catch异常，异常抛出给服务调用方
 */
@Service("salesmanService")
public class SalesmanServiceImp implements SalesmanService {

  private static final Log log = LogFactory.getLog(SalesmanServiceImp.class);

  @Autowired
  @Qualifier(value = "baseDao")
  private CommonDao dao;

  @Override
  public List<Map<String, Object>> findSalesmanByMap(Map<String, Object> whereMap) {
    List<Map<String, Object>> resultList = dao.selectList(SALESMAN + ".findSalesmanByMap", whereMap);
    log.debug("模糊查询销售人员返回的结果：" + JSON.toJSONString(resultList));
    return resultList;
  }

  @Override
  public List<Map<String, Object>> findSalesmanByList(List<String> wherelist) {
    List<Map<String, Object>> resultList = dao.selectList(SALESMAN + ".findSalesmanByList", wherelist);
    log.debug("精确查询销售人员返回的结果：" + JSON.toJSONString(resultList));
    return resultList;
  }

  @Override
  public List<String> queryAllAgentByRecommender(String employNo) {
    List<String> resultList = dao.selectList(SALESMAN + ".queryAllAgentByRecommender", employNo);
    log.debug("查询推荐人返回的结果：" + JSON.toJSONString(resultList));
    return resultList;
  }

  @Override
  public List<Map<String, Object>> querySalesAssistant(String employNo) {
    List<Map<String, Object>> resultList = dao.selectList(SALESMAN + ".querySalesAssistant", employNo);
    log.debug("查询销售助理返回的结果：" + JSON.toJSONString(resultList));
    return resultList;
  }

  @Override
  public List<Map<String, Object>> findSalesmanByEmployCodeCertifyNoNameMap(Map<String, String> whereMap) throws Exception {
    if (whereMap.get("employCode") == null) {
      throw new Exception("工号为空");
    }
    if (whereMap.get("certifyNo") == null) {
      throw new Exception("证件号为空");
    }
    if (whereMap.get("salesmanCname") == null) {
      throw new Exception("姓名为空");
    }
    List<Map<String, Object>> resultList = dao.selectList(SALESMAN + ".findSalesmanByEmployCodeCertifyNoNameMap", whereMap);
    log.debug("查询销售人员返回的结果：" + JSON.toJSONString(resultList));
    return resultList;
  }
}
