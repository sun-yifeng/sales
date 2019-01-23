package com.sinosafe.xszc.channel.vo;

import java.sql.Timestamp;

/**
 * 类名:com.sinosafe.xszc.channel.vo.ChannelMailRecord <pre>
 * 描述:渠道邮件预警记录
 * 编写者:卢水发
 * 创建时间:2015年6月18日 下午2:28:03
 * </pre>
 */
public class ChannelMailRecord implements java.io.Serializable{

	private static final long serialVersionUID = 1L;
	
	private String pkId;
	private String channelType;//1中介机构 2个人代理
	private String channelName;//渠道名称
	private String channelCode;//渠道代码
	private String lineCode;//业务线
	private String deptCode;//经办机构代码
	private String deptName;//经办机构名称
	private String conferCode;//协议代码
	private String recipients;//接收人邮箱
	private String sendIp;//发送服务器IP
	private String sendName;//发送服务器主机名
	private String sendDate;//发送日期
	private String sendStatus;//发送状态
	private String taskType;//任务类型
	private String mailContent;//邮件内容
	private String createdUser;
	private Timestamp createdDate;
	private String updatedUser;
	private Timestamp updatedDate;
	private String validInd;// 有效标示位,1-有效,0-失效
	private String mailType;// 邮件类型,1-系统默认预警邮件,2-手动添加预警邮件
	private String copyMail; //抄送人邮箱

	public String getMailType() {
		return mailType;
	}

	public void setMailType(String mailType) {
		this.mailType = mailType;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getSendDate() {
		return sendDate;
	}

	public void setSendDate(String sendDate) {
		this.sendDate = sendDate;
	}

	public void setUpdatedUser ( String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setSendIp ( String sendIp ) {
		this.sendIp = sendIp;
	}
	
	public String getSendIp (){
		return sendIp;
	}
	
	public void setLineCode ( String lineCode ) {
		this.lineCode = lineCode;
	}
	
	public String getLineCode (){
		return lineCode;
	}
	
	public void setMailContent ( String mailContent ) {
		this.mailContent = mailContent;
	}
	
	public String getMailContent (){
		return mailContent;
	}
	
	public void setPkId ( String pkId ) {
		this.pkId = pkId;
	}
	
	public String getPkId (){
		return pkId;
	}
	
	public void setRecipients ( String recipients ) {
		this.recipients = recipients;
	}
	
	public String getRecipients (){
		return recipients;
	}
	
	public void setCreatedUser ( String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public String getCreatedUser (){
		return createdUser;
	}
	
	public void setChannelCode ( String channelCode ) {
		this.channelCode = channelCode;
	}
	
	public String getChannelCode (){
		return channelCode;
	}
	
	public void setSendName ( String sendName ) {
		this.sendName = sendName;
	}
	
	public String getSendName (){
		return sendName;
	}
	
	public void setDeptCode ( String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public String getDeptCode (){
		return deptCode;
	}
	
	public void setSendStatus ( String sendStatus ) {
		this.sendStatus = sendStatus;
	}
	
	public String getSendStatus (){
		return sendStatus;
	}
	
	public void setUpdatedDate ( Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setChannelName ( String channelName ) {
		this.channelName = channelName;
	}
	
	public String getChannelName (){
		return channelName;
	}
	
	public void setConferCode ( String conferCode ) {
		this.conferCode = conferCode;
	}
	
	public String getConferCode (){
		return conferCode;
	}
	
	public void setValidInd ( String validInd ) {
		this.validInd = validInd;
	}
	
	public String getValidInd (){
		return validInd;
	}
	
	public void setCreatedDate ( Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setChannelType ( String channelType ) {
		this.channelType = channelType;
	}
	
	public String getChannelType (){
		return channelType;
	}
	
	public void setTaskType ( String taskType ) {
		this.taskType = taskType;
	}
	
	public String getTaskType (){
		return taskType;
	}

	public String getCopyMail() {
		return copyMail;
	}

	public void setCopyMail(String copyMail) {
		this.copyMail = copyMail;
	}
	

}