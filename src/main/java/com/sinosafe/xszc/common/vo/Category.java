package com.sinosafe.xszc.common.vo;


public class Category implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String categoryCode;
	private java.lang.String validInd;
	private java.lang.String categoryName;
	private java.sql.Timestamp createdDate;
	private java.lang.String createdUser;
	private java.lang.String remark;
	private java.sql.Timestamp updatedDate;

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public java.lang.String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setCategoryCode ( java.lang.String categoryCode ) {
		this.categoryCode = categoryCode;
	}
	
	public java.lang.String getCategoryCode (){
		return categoryCode;
	}
	
	public void setValidInd ( java.lang.String validInd ) {
		this.validInd = validInd;
	}
	
	public java.lang.String getValidInd (){
		return validInd;
	}
	
	public void setCategoryName ( java.lang.String categoryName ) {
		this.categoryName = categoryName;
	}
	
	public java.lang.String getCategoryName (){
		return categoryName;
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