package com.sinosafe.xszc.law.vo;


public class LawDefineDept implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.sql.Timestamp createdDate;
	private java.lang.String createdUser;
	private java.sql.Timestamp endDate;
	private java.sql.Timestamp beginDate;
	private java.lang.String deptCode;
	private java.lang.String versionCode;
	private java.lang.String validInd;
	private java.sql.Timestamp updatedDate;
	private java.lang.String pkUuid;
	private java.lang.String isValid;

	public java.lang.String getIsValid() {
		return isValid;
	}

	public void setIsValid(java.lang.String isValid) {
		this.isValid = isValid;
	}

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public java.lang.String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setCreatedDate ( java.sql.Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public java.sql.Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setEndDate ( java.sql.Timestamp endDate ) {
		this.endDate = endDate;
	}
	
	public java.sql.Timestamp getEndDate (){
		return endDate;
	}
	
	public void setBeginDate ( java.sql.Timestamp beginDate ) {
		this.beginDate = beginDate;
	}
	
	public java.sql.Timestamp getBeginDate (){
		return beginDate;
	}
	
	public void setDeptCode ( java.lang.String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public java.lang.String getDeptCode (){
		return deptCode;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setPkUuid ( java.lang.String pkUuid ) {
		this.pkUuid = pkUuid;
	}
	
	public java.lang.String getPkUuid (){
		return pkUuid;
	}
	
	public java.lang.String getVersionCode() {
		return versionCode;
	}

	public void setVersionCode(java.lang.String versionCode) {
		this.versionCode = versionCode;
	}

	public java.lang.String getValidInd() {
		return validInd;
	}

	public void setValidInd(java.lang.String validInd) {
		this.validInd = validInd;
	}

}