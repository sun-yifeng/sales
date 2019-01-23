package com.sinosafe.xszc.notice.vo;


public class NoticeFeedback implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String feedbackId;        //公告反馈主键
	
	private java.lang.String createdUser; //..非空
	private java.lang.String updatedUser;//..非空
	private java.sql.Timestamp createdDate;//..非空
	private java.sql.Timestamp updatedDate;//..非空
	
	private java.lang.String feedbackUser; // 反馈人代码
	
	private java.lang.String feedbackContent;  // 反馈内容
	
	private java.lang.String status;           //公告状态,1-待反馈,2-待处理,3-已发布
	
	private java.lang.String validInd;         //有效标示位,1-有效,0-失效
		
	private java.lang.String noticeId;        //公告主键
	private java.lang.String feedbackDate;   //反馈时间
	private java.lang.String processor;      //处理人
	private java.lang.String processDate;      //处理时间
	private java.lang.String processContent;  //  处理说明
	private java.lang.String deptCode;  //  接收部门编码
	private java.lang.String businessLine; //业务线
	
	public void setBusinessLine(java.lang.String businessLine) {
		this.businessLine = businessLine;
	}
	
	public java.lang.String getBusinessLine() {
		return businessLine;
	}

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public java.lang.String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setFeedbackUser ( java.lang.String feedbackUser ) {
		this.feedbackUser = feedbackUser;
	}
	
	public java.lang.String getFeedbackUser (){
		return feedbackUser;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setFeedbackContent ( java.lang.String feedbackContent ) {
		this.feedbackContent = feedbackContent;
	}
	
	public java.lang.String getFeedbackContent (){
		return feedbackContent;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setStatus ( java.lang.String status ) {
		this.status = status;
	}
	
	public java.lang.String getStatus (){
		return status;
	}
	
	public void setProcessor ( java.lang.String processor ) {
		this.processor = processor;
	}
	
	public java.lang.String getProcessor (){
		return processor;
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
	
	public void setProcessContent ( java.lang.String processContent ) {
		this.processContent = processContent;
	}
	
	public java.lang.String getProcessContent (){
		return processContent;
	}
	
	public void setNoticeId ( java.lang.String noticeId ) {
		this.noticeId = noticeId;
	}
	
	public java.lang.String getNoticeId (){
		return noticeId;
	}
	
	public void setFeedbackDate ( java.lang.String feedbackDate ) {
		this.feedbackDate = feedbackDate;
	}
	
	public java.lang.String getFeedbackDate (){
		return feedbackDate;
	}
	
	public void setProcessDate ( java.lang.String processDate ) {
		this.processDate = processDate;
	}
	
	public java.lang.String getProcessDate (){
		return processDate;
	}
	
	public void setFeedbackId ( java.lang.String feedbackId ) {
		this.feedbackId = feedbackId;
	}
	
	public java.lang.String getFeedbackId (){
		return feedbackId;
	}

	public java.lang.String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(java.lang.String deptCode) {
		this.deptCode = deptCode;
	}
	

}