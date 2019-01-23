package com.sinosafe.xszc.main.vo;

import java.io.Serializable;

public class UserRole implements Serializable{
  /**
   * 
   */
  private static final long serialVersionUID = 1L;
  private String deptCode;
  private String deptName;
  private String userCode;
  private String roleCname;
  private String roleEname;
  private String roleDesc;
  
  public String getDeptCode() {
    return deptCode;
  }
  public void setDeptCode(String deptCode) {
    this.deptCode = deptCode;
  }
  public String getDeptName() {
    return deptName;
  }
  public void setDeptName(String deptName) {
    this.deptName = deptName;
  }
  public String getUserCode() {
    return userCode;
  }
  public void setUserCode(String userCode) {
    this.userCode = userCode;
  }
  public String getRoleCname() {
    return roleCname;
  }
  public void setRoleCname(String roleCname) {
    this.roleCname = roleCname;
  }
  public String getRoleEname() {
    return roleEname;
  }
  public void setRoleEname(String roleEname) {
    this.roleEname = roleEname;
  }
  public String getRoleDesc() {
    return roleDesc;
  }
  public void setRoleDesc(String roleDesc) {
    this.roleDesc = roleDesc;
  }
  
  
  
}
