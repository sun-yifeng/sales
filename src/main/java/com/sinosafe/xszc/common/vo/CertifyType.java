package com.sinosafe.xszc.common.vo;


public class CertifyType implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String createdUser;
	private java.lang.String remark;
	private java.lang.String certifyTypeCode;
	private java.sql.Timestamp updatedDate;
	private java.lang.String certifyTypeName;

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
	
	public void setCertifyTypeCode ( java.lang.String certifyTypeCode ) {
		this.certifyTypeCode = certifyTypeCode;
	}
	
	public java.lang.String getCertifyTypeCode (){
		return certifyTypeCode;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setCertifyTypeName ( java.lang.String certifyTypeName ) {
		this.certifyTypeName = certifyTypeName;
	}
	
	public java.lang.String getCertifyTypeName (){
		return certifyTypeName;
	}
	

}