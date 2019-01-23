package com.sinosafe.xszc.common.vo;


public class Educatioin implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String educatioinName;
	private java.lang.String createdUser;
	private java.lang.String educatioinCode;
	private java.lang.String remark;
	private java.sql.Timestamp updatedDate;

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
	
	public void setEducatioinName ( java.lang.String educatioinName ) {
		this.educatioinName = educatioinName;
	}
	
	public java.lang.String getEducatioinName (){
		return educatioinName;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setEducatioinCode ( java.lang.String educatioinCode ) {
		this.educatioinCode = educatioinCode;
	}
	
	public java.lang.String getEducatioinCode (){
		return educatioinCode;
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
	

}