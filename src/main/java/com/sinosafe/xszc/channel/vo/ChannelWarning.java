package com.sinosafe.xszc.channel.vo;


public class ChannelWarning implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.lang.String warningId;
	private java.sql.Timestamp createdDate;
	private java.lang.String settingDate;
	private java.lang.String createdUser;
	private java.lang.String channelCode;
	private java.lang.String email;
	private java.sql.Timestamp updatedDate;
	private java.lang.Double waringDay;

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
	
	public void setWarningId ( java.lang.String warningId ) {
		this.warningId = warningId;
	}
	
	public java.lang.String getWarningId (){
		return warningId;
	}
	
	public void setCreatedDate ( java.sql.Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public java.sql.Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public java.lang.String getSettingDate() {
		return settingDate;
	}

	public void setSettingDate(java.lang.String settingDate) {
		this.settingDate = settingDate;
	}

	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setChannelCode ( java.lang.String channelCode ) {
		this.channelCode = channelCode;
	}
	
	public java.lang.String getChannelCode (){
		return channelCode;
	}
	
	public void setEmail ( java.lang.String email ) {
		this.email = email;
	}
	
	public java.lang.String getEmail (){
		return email;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setWaringDay ( java.lang.Double waringDay ) {
		this.waringDay = waringDay;
	}
	
	public java.lang.Double getWaringDay (){
		return waringDay;
	}
	

}