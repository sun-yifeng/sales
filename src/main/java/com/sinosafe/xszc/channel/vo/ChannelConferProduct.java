package com.sinosafe.xszc.channel.vo;


public class ChannelConferProduct implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.Double commissionRate;
	private java.lang.String conferProductId;
	private java.lang.Double endorseRate;
	private java.lang.String createdUser;
	private java.lang.String productCode;
	private java.sql.Timestamp updatedDate;
	private java.lang.String conferCode;
	private java.lang.String extendConferCode;
	private java.lang.String conferId;
	private java.lang.Double commRate;
	

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
	
	public void setCommissionRate ( java.lang.Double commissionRate ) {
		this.commissionRate = commissionRate;
	}
	
	public java.lang.Double getCommissionRate (){
		return commissionRate;
	}
	
	public void setConferProductId ( java.lang.String conferProductId ) {
		this.conferProductId = conferProductId;
	}
	
	public java.lang.String getConferProductId (){
		return conferProductId;
	}
	
	public void setEndorseRate ( java.lang.Double endorseRate ) {
		this.endorseRate = endorseRate;
	}
	
	public java.lang.Double getEndorseRate (){
		return endorseRate;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setProductCode ( java.lang.String productCode ) {
		this.productCode = productCode;
	}
	
	public java.lang.String getProductCode (){
		return productCode;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setConferCode ( java.lang.String conferCode ) {
		this.conferCode = conferCode;
	}
	
	public java.lang.String getConferCode (){
		return conferCode;
	}

	public java.lang.String getExtendConferCode() {
		return extendConferCode;
	}

	public void setExtendConferCode(java.lang.String extendConferCode) {
		this.extendConferCode = extendConferCode;
	}

	public java.lang.String getConferId() {
		return conferId;
	}

	public void setConferId(java.lang.String conferId) {
		this.conferId = conferId;
	}

	public java.lang.Double getCommRate() {
		return commRate;
	}

	public void setCommRate(java.lang.Double commRate) {
		this.commRate = commRate;
	}

}