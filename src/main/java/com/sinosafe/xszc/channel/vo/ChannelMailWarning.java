package com.sinosafe.xszc.channel.vo;


@SuppressWarnings("serial")
public class ChannelMailWarning implements java.io.Serializable{

	private static long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.lang.String sendDate;
	private java.sql.Timestamp createdDate;
	private java.lang.String recipients;
	private java.lang.String createdUser;
	private java.lang.String channelCode;
	private java.lang.String sendStatus;
	private java.lang.String taskId;
	private java.sql.Timestamp updatedDate;
	private java.lang.String conferCode;
	private java.lang.String channelName;
	private java.lang.String taskType;
	private java.lang.String warmingDay;
	private java.lang.String ServerIP;
	private java.lang.String deptCode;
	private java.lang.String deptName;
	private java.lang.String businessLine;
	
	public java.lang.String getBusinessLine() {
		return businessLine;
	}

	public void setBusinessLine(java.lang.String businessLine) {
		this.businessLine = businessLine;
	}

	public static void setSerialversionuid(long serialversionuid) {
		serialVersionUID = serialversionuid;
	}

	public java.lang.String getServerIP() {
		return ServerIP;
	}

	public void setServerIP(java.lang.String serverIP) {
		ServerIP = serverIP;
	}

	public java.lang.String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(java.lang.String deptCode) {
		this.deptCode = deptCode;
	}

	public java.lang.String getDeptName() {
		return deptName;
	}

	public void setDeptName(java.lang.String deptName) {
		this.deptName = deptName;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

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
	
	public void setSendDate ( java.lang.String sendDate ) {
		this.sendDate = sendDate;
	}
	
	public java.lang.String getSendDate (){
		return sendDate;
	}
	
	public void setCreatedDate ( java.sql.Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public java.sql.Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setRecipients ( java.lang.String recipients ) {
		this.recipients = recipients;
	}
	
	public java.lang.String getRecipients (){
		return recipients;
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
	
	public void setSendStatus ( java.lang.String sendStatus ) {
		this.sendStatus = sendStatus;
	}
	
	public java.lang.String getSendStatus (){
		return sendStatus;
	}
	
	public void setTaskId ( java.lang.String taskId ) {
		this.taskId = taskId;
	}
	
	public java.lang.String getTaskId (){
		return taskId;
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

	public java.lang.String getChannelName() {
		return channelName;
	}

	public void setChannelName(java.lang.String channelName) {
		this.channelName = channelName;
	}

	public java.lang.String getTaskType() {
		return taskType;
	}

	public void setTaskType(java.lang.String taskType) {
		this.taskType = taskType;
	}

	public java.lang.String getWarmingDay() {
		return warmingDay;
	}

	public void setWarmingDay(java.lang.String warmingDay) {
		this.warmingDay = warmingDay;
	}
	

}