package com.sinosafe.xszc.law.vo;


public class TRankCalc implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String validInd;
	private java.lang.String channelId;
	private java.lang.String changeType;
	private java.lang.String lastOpt;
	private java.lang.String condType;
	private java.lang.String targetRankCode;
	private java.lang.Double orderNo;
	private java.lang.String versionId;
	private java.lang.String cond;
	private java.lang.String rankCode;
	private java.sql.Timestamp optDate;
	private java.lang.String serno;

	public void setValidInd ( java.lang.String validInd ) {
		this.validInd = validInd;
	}
	
	public java.lang.String getValidInd (){
		return validInd;
	}
	
	public void setChannelId ( java.lang.String channelId ) {
		this.channelId = channelId;
	}
	
	public java.lang.String getChannelId (){
		return channelId;
	}
	
	public void setChangeType ( java.lang.String changeType ) {
		this.changeType = changeType;
	}
	
	public java.lang.String getChangeType (){
		return changeType;
	}
	
	public void setLastOpt ( java.lang.String lastOpt ) {
		this.lastOpt = lastOpt;
	}
	
	public java.lang.String getLastOpt (){
		return lastOpt;
	}
	
	public void setCondType ( java.lang.String condType ) {
		this.condType = condType;
	}
	
	public java.lang.String getCondType (){
		return condType;
	}
	
	public void setTargetRankCode ( java.lang.String targetRankCode ) {
		this.targetRankCode = targetRankCode;
	}
	
	public java.lang.String getTargetRankCode (){
		return targetRankCode;
	}
	
	public void setOrderNo ( java.lang.Double orderNo ) {
		this.orderNo = orderNo;
	}
	
	public java.lang.Double getOrderNo (){
		return orderNo;
	}
	
	public void setVersionId ( java.lang.String versionId ) {
		this.versionId = versionId;
	}
	
	public java.lang.String getVersionId (){
		return versionId;
	}
	
	public void setCond ( java.lang.String cond ) {
		this.cond = cond;
	}
	
	public java.lang.String getCond (){
		return cond;
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
	
	public void setSerno ( java.lang.String serno ) {
		this.serno = serno;
	}
	
	public java.lang.String getSerno (){
		return serno;
	}
	

}