package com.sinosafe.xszc.main.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;

public interface UserRoleService {
  
  public PageDto queryUserRoles(PageDto pageDto);

  public List<Map<String,Object>> queryRoleNames(FormDto dto);
  
}
