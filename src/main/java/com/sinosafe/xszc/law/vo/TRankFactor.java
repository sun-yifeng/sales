package com.sinosafe.xszc.law.vo;


public class TRankFactor implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String validInd;
	private java.lang.String factorCode;
	private java.lang.String channelId;
	private java.lang.String lastOpt;
	private java.lang.String orderNo;
	private java.lang.String versionId;
	private java.lang.String rankCode;
	private java.sql.Timestamp optDate;
	private java.lang.String exhibitType;
	private java.lang.String serno;

	public void setValidInd ( java.lang.String validInd ) {
		this.validInd = validInd;
	}
	
	public java.lang.String getValidInd (){
		return validInd;
	}
	
	public void setFactorCode ( java.lang.String factorCode ) {
		this.factorCode = factorCode;
	}
	
	public java.lang.String getFactorCode (){
		return factorCode;
	}
	
	public void setChannelId ( java.lang.String channelId ) {
		this.channelId = channelId;
	}
	
	public java.lang.String getChannelId (){
		return channelId;
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
	
	public void setVersionId ( java.lang.String versionId ) {
		this.versionId = versionId;
	}
	
	public java.lang.String getVersionId (){
		return versionId;
	}
	
	public void setRankCode ( java.lang.String rankCode ) {
		this.rankCode = rankCode;
	}
	
	public java.lang.String getRankCode (){
		return rankCode;
	}
	
	public void setOptDate ( java.sql.Timestamp optDate ) {
		this.optDate = optDate;
	}
	
	public java.sql.Timestamp getOptDate (){
		return optDate;
	}
	
	public void setExhibitType ( java.lang.String exhibitType ) {
		this.exhibitType = exhibitType;
	}
	
	public java.lang.String getExhibitType (){
		return exhibitType;
	}
	
	public void setSerno ( java.lang.String serno ) {
		this.serno = serno;
	}
	
	public java.lang.String getSerno (){
		return serno;
	}
	

}