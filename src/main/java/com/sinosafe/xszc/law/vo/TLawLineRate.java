package com.sinosafe.xszc.law.vo;


public class TLawLineRate implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.lang.String lineCode;
	private java.sql.Timestamp createdDate;
	private java.lang.Double lineRate;
	private java.lang.String lineRateId;
	private java.lang.String createdUser;
	private java.sql.Timestamp updatedDate;
	private java.lang.String deptCode2;

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
	
	public void setLineRate ( java.lang.Double lineRate ) {
		this.lineRate = lineRate;
	}
	
	public java.lang.Double getLineRate (){
		return lineRate;
	}
	
	public void setLineRateId ( java.lang.String lineRateId ) {
		this.lineRateId = lineRateId;
	}
	
	public java.lang.String getLineRateId (){
		return lineRateId;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setDeptCode2 ( java.lang.String deptCode2 ) {
		this.deptCode2 = deptCode2;
	}
	
	public java.lang.String getDeptCode2 (){
		return deptCode2;
	}
	

}