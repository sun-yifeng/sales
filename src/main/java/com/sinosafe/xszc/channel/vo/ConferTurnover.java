package com.sinosafe.xszc.channel.vo;


public class ConferTurnover implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String pkId;
	private java.lang.String createdUser;
	private java.lang.Double lastNumber;
	private java.lang.String year;
	private java.lang.String deptCode;
	private java.sql.Timestamp updatedDate;
	private java.lang.String conferType;

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
	
	public void setPkId ( java.lang.String pkId ) {
		this.pkId = pkId;
	}
	
	public java.lang.String getPkId (){
		return pkId;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setLastNumber ( java.lang.Double lastNumber ) {
		this.lastNumber = lastNumber;
	}
	
	public java.lang.Double getLastNumber (){
		return lastNumber;
	}
	
	public void setYear ( java.lang.String year ) {
		this.year = year;
	}
	
	public java.lang.String getYear (){
		return year;
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
	
	public void setConferType ( java.lang.String conferType ) {
		this.conferType = conferType;
	}
	
	public java.lang.String getConferType (){
		return conferType;
	}
	

}