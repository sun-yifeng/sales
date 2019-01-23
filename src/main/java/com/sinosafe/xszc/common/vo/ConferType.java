package com.sinosafe.xszc.common.vo;


public class ConferType implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String createdUser;
	private java.lang.String remark;
	private java.sql.Timestamp updatedDate;
	private java.lang.String conferName;
	private java.lang.String conferCode;

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
	
	public void setConferName ( java.lang.String conferName ) {
		this.conferName = conferName;
	}
	
	public java.lang.String getConferName (){
		return conferName;
	}
	
	public void setConferCode ( java.lang.String conferCode ) {
		this.conferCode = conferCode;
	}
	
	public java.lang.String getConferCode (){
		return conferCode;
	}
	

}