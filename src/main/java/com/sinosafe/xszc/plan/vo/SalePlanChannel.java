package com.sinosafe.xszc.plan.vo;


public class SalePlanChannel implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.sql.Timestamp createdDate;
	private java.lang.Double targetPremium;
	private java.lang.String channelPlanId;
	private java.lang.String content;
	private java.lang.String createdUser;
	private java.lang.String desc;
	private java.lang.String channelCode;
	private java.lang.String channelRiskType;
	private java.sql.Timestamp updatedDate;
	private java.lang.String salePlanId;

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public java.lang.String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setCreatedDate ( java.sql.Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public java.sql.Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setTargetPremium ( java.lang.Double targetPremium ) {
		this.targetPremium = targetPremium;
	}
	
	public java.lang.Double getTargetPremium (){
		return targetPremium;
	}
	
	public void setChannelPlanId ( java.lang.String channelPlanId ) {
		this.channelPlanId = channelPlanId;
	}
	
	public java.lang.String getChannelPlanId (){
		return channelPlanId;
	}
	
	public void setContent ( java.lang.String content ) {
		this.content = content;
	}
	
	public java.lang.String getContent (){
		return content;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setDesc ( java.lang.String desc ) {
		this.desc = desc;
	}
	
	public java.lang.String getDesc (){
		return desc;
	}
	
	public void setChannelCode ( java.lang.String channelCode ) {
		this.channelCode = channelCode;
	}
	
	public java.lang.String getChannelCode (){
		return channelCode;
	}
	
	public void setChannelRiskType ( java.lang.String channelRiskType ) {
		this.channelRiskType = channelRiskType;
	}
	
	public java.lang.String getChannelRiskType (){
		return channelRiskType;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setSalePlanId ( java.lang.String salePlanId ) {
		this.salePlanId = salePlanId;
	}
	
	public java.lang.String getSalePlanId (){
		return salePlanId;
	}
	

}