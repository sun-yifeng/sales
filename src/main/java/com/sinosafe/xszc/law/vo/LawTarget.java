package com.sinosafe.xszc.law.vo;


public class LawTarget implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String indexCode;
	private java.lang.String dataUnit;
	private java.lang.String channelId;
	private java.lang.String indexGroup;
	private java.lang.String lastOpt;
	private java.lang.String orderNo;
	private java.lang.String indexName;
	private java.sql.Timestamp optDate;
	private java.lang.String indexNote;
	private java.lang.String serno;
	private java.lang.String dataType;
	private java.lang.String validInd;
	private java.lang.String versionId;

	public void setIndexCode ( java.lang.String indexCode ) {
		this.indexCode = indexCode;
	}
	
	public java.lang.String getIndexCode (){
		return indexCode;
	}
	
	public void setDataUnit ( java.lang.String dataUnit ) {
		this.dataUnit = dataUnit;
	}
	
	public java.lang.String getDataUnit (){
		return dataUnit;
	}
	
	public void setChannelId ( java.lang.String channelId ) {
		this.channelId = channelId;
	}
	
	public java.lang.String getChannelId (){
		return channelId;
	}
	
	public void setIndexGroup ( java.lang.String indexGroup ) {
		this.indexGroup = indexGroup;
	}
	
	public java.lang.String getIndexGroup (){
		return indexGroup;
	}
	
	public void setLastOpt ( java.lang.String lastOpt ) {
		this.lastOpt = lastOpt;
	}
	
	public java.lang.String getLastOpt (){
		return lastOpt;
	}
	
	public void setOrderNo ( java.lang.String orderNo ) {
		this.orderNo = orderNo;
	}
	
	public java.lang.String getOrderNo (){
		return orderNo;
	}
	
	public void setIndexName ( java.lang.String indexName ) {
		this.indexName = indexName;
	}
	
	public java.lang.String getIndexName (){
		return indexName;
	}
	
	public void setOptDate ( java.sql.Timestamp optDate ) {
		this.optDate = optDate;
	}
	
	public java.sql.Timestamp getOptDate (){
		return optDate;
	}
	
	public void setIndexNote ( java.lang.String indexNote ) {
		this.indexNote = indexNote;
	}
	
	public java.lang.String getIndexNote (){
		return indexNote;
	}
	
	public void setSerno ( java.lang.String serno ) {
		this.serno = serno;
	}
	
	public java.lang.String getSerno (){
		return serno;
	}
	
	public void setDataType ( java.lang.String dataType ) {
		this.dataType = dataType;
	}
	
	public java.lang.String getDataType (){
		return dataType;
	}

	public java.lang.String getValidInd() {
		return validInd;
	}

	public void setValidInd(java.lang.String validInd) {
		this.validInd = validInd;
	}

	public java.lang.String getVersionId() {
		return versionId;
	}

	public void setVersionId(java.lang.String versionId) {
		this.versionId = versionId;
	}
	

}