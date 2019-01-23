package com.sinosafe.xszc.common.vo;


public class BusinessLine implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.lang.String lineCode;
	private java.sql.Timestamp createdDate;
	private java.lang.String createdUser;
	private java.lang.String remark;
	private java.sql.Timestamp updatedDate;
	private java.lang.String lineDict;
	private java.lang.String lineName;

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
	
	public void setLineCode ( java.lang.String lineCode ) {
		this.lineCode = lineCode;
	}
	
	public java.lang.String getLineCode (){
		return lineCode;
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
	
	public void setLineDict ( java.lang.String lineDict ) {
		this.lineDict = lineDict;
	}
	
	public java.lang.String getLineDict (){
		return lineDict;
	}
	
	public void setLineName ( java.lang.String lineName ) {
		this.lineName = lineName;
	}
	
	public java.lang.String getLineName (){
		return lineName;
	}
	

}