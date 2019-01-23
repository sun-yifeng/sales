package com.sinosafe.xszc.common.vo;


public class SalesmanRank implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String simpleName;
	private java.lang.String createdUser;
	private java.lang.String remark;
	private java.lang.String salerankCname;
	private java.sql.Timestamp updatedDate;
	private java.lang.String salerankEname;
	private java.lang.String salerankCode;
	private java.lang.String managerFlag;

	public java.lang.String getManagerFlag() {
		return managerFlag;
	}

	public void setManagerFlag(java.lang.String managerFlag) {
		this.managerFlag = managerFlag;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public java.lang.String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setValidInd ( java.lang.String validInd ) {
		this.validInd = validInd;
	}
	
	public java.lang.String getValidInd (){
		return validInd;
	}
	
	public void setCreatedDate ( java.sql.Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public java.sql.Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setSimpleName ( java.lang.String simpleName ) {
		this.simpleName = simpleName;
	}
	
	public java.lang.String getSimpleName (){
		return simpleName;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setRemark ( java.lang.String remark ) {
		this.remark = remark;
	}
	
	public java.lang.String getRemark (){
		return remark;
	}
	
	public void setSalerankCname ( java.lang.String salerankCname ) {
		this.salerankCname = salerankCname;
	}
	
	public java.lang.String getSalerankCname (){
		return salerankCname;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setSalerankEname ( java.lang.String salerankEname ) {
		this.salerankEname = salerankEname;
	}
	
	public java.lang.String getSalerankEname (){
		return salerankEname;
	}
	
	public void setSalerankCode ( java.lang.String salerankCode ) {
		this.salerankCode = salerankCode;
	}
	
	public java.lang.String getSalerankCode (){
		return salerankCode;
	}
	

}