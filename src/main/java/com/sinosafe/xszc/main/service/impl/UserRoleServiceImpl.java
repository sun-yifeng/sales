package com.sinosafe.xszc.main.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.USER_ROLE;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.main.service.UserRoleService;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;

public class UserRoleServiceImpl implements UserRoleService {
  
  @Autowired
  @Qualifier(value = "baseDao")
  private CommonDao dao;
  
  @Override
  public PageDto queryUserRoles(PageDto pageDto) {
    try {
      Long total = dao.selectOne(USER_ROLE + ".queryUserRoleCounts", pageDto.getWhereMap());
      pageDto.setTotal(total);
      if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
        pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
      } else {
        pageDto.getWhereMap().put("startpoint", 1);
      }
      pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
      List<Map<String, Object>> list = dao.selectList(USER_ROLE + ".queryUserRoles", pageDto.getWhereMap());
      pageDto.setRows(list);
      return pageDto;
    } catch (Exception e) {
      e.printStackTrace();
      pageDto.setRows(null);
      return pageDto;
    }
  }

  @Override
  public List<Map<String, Object>> queryRoleNames(FormDto dto) {
    return dao.selectList(USER_ROLE + ".queryRoleNames", dto.getFormMap());
  }

}
