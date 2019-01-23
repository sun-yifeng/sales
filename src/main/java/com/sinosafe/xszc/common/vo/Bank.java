package com.sinosafe.xszc.common.vo;


public class Bank implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String simpleName;
	private java.lang.String bankEname;
	private java.lang.String createdUser;
	private java.lang.String bankCode;
	private java.lang.String remark;
	private java.sql.Timestamp updatedDate;
	private java.lang.String bankCname;

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
	
	public void setBankEname ( java.lang.String bankEname ) {
		this.bankEname = bankEname;
	}
	
	public java.lang.String getBankEname (){
		return bankEname;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setBankCode ( java.lang.String bankCode ) {
		this.bankCode = bankCode;
	}
	
	public java.lang.String getBankCode (){
		return bankCode;
	}
	
	public void setRemark ( java.lang.String remark ) {
		this.remark = remark;
	}
	
	public java.lang.String getRemark (){
		return remark;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setBankCname ( java.lang.String bankCname ) {
		this.bankCname = bankCname;
	}
	
	public java.lang.String getBankCname (){
		return bankCname;
	}
	

}