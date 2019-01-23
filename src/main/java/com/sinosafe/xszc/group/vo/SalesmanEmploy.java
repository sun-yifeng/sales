package com.sinosafe.xszc.group.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesmanEmploy implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String associateCode;
	private java.lang.String pkId;
	private java.lang.String salesmanCode;
	private java.lang.String createdUser;
	private java.sql.Timestamp updatedDate;
	private java.lang.String employCode;
	private java.lang.String certifyNo;
	private java.lang.String salesmanCname;

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
	
	public void setAssociateCode ( java.lang.String associateCode ) {
		this.associateCode = associateCode;
	}
	
	public java.lang.String getAssociateCode (){
		return associateCode;
	}
	
	public void setPkId ( java.lang.String pkId ) {
		this.pkId = pkId;
	}
	
	public java.lang.String getPkId (){
		return pkId;
	}
	
	public void setSalesmanCode ( java.lang.String salesmanCode ) {
		this.salesmanCode = salesmanCode;
	}
	
	public java.lang.String getSalesmanCode (){
		return salesmanCode;
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
	
	public void setEmployCode ( java.lang.String employCode ) {
		this.employCode = employCode;
	}
	
	public java.lang.String getEmployCode (){
		return employCode;
	}
	
	public void setCertifyNo ( java.lang.String certifyNo ) {
		this.certifyNo = certifyNo;
	}
	
	public java.lang.String getCertifyNo (){
		return certifyNo;
	}
	
	public void setSalesmanCname ( java.lang.String salesmanCname ) {
		this.salesmanCname = salesmanCname;
	}
	
	public java.lang.String getSalesmanCname (){
		return salesmanCname;
	}

}