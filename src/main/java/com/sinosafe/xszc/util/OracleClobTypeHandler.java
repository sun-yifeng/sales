
/**
 *
 * 文件名:OracleClobTypeHandler.java
 * 包名:com.sinosafe.xszc.util
 * 项目名:xszc
 * 文件说明:
 * 作者:lixiaoliang
 * 创建时间:2015年1月14日 下午5:12:03
 */
package com.sinosafe.xszc.util;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import oracle.sql.CLOB;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

/**
 * Mybatis Clob字段转换
 * 类名:com.sinosafe.xszc.util.OracleClobTypeHandler <pre>
 * 描述:
 * 基本思路:
 * 特别说明:
 * 编写者:李晓亮
 * 创建时间:2015年1月14日 下午5:12:03
 * 修改说明: 类的修改说明
 * </pre>
 */


public class OracleClobTypeHandler implements TypeHandler<Object> {
  
  public Object valueOf(String param) {
    return null;
  }

  @Override
  public Object getResult(ResultSet arg0, String arg1) throws SQLException {
    CLOB clob = (CLOB) arg0.getClob(arg1);
    return (clob == null || clob.length() == 0) ? null : clob.getSubString((long) 1, (int) clob.length());
  }

  @Override
  public Object getResult(ResultSet arg0, int arg1) throws SQLException {
    return null;
  }

  @Override
  public Object getResult(CallableStatement arg0, int arg1) throws SQLException {
    return null;
  }

  @Override
  public void setParameter(PreparedStatement arg0, int arg1, Object arg2, JdbcType arg3) throws SQLException {
    CLOB clob = CLOB.getEmptyCLOB();
    clob.setString(1, (String) arg2);
    arg0.setClob(arg1, clob);
  }
}

