package com.sinosafe.xszc.notice.vo;


public class Notice implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	
	private java.lang.Double periodValue;// 周期性公告. ..
	
	private java.lang.String deptCode;  //机构代码 ????
	private java.lang.String publisher;  // 发布人
	private java.lang.String period; //PERIOD	CHAR(1)	Y 周期 每年、半年、每季度、每月、每周，每日 这里有一个问题就是,每年的不一定是每年第一天呀

	 
	private java.lang.String status; //公告状态,0-草稿,1-运行中,2-已停止
	private java.lang.Double feedbackDay;  //反馈有效期（天）
	private java.lang.String validInd; //有效标示位,1-有效,0-失效	

	
	private java.lang.String publishDeptCode;  //发布机构代码
	private java.lang.String publishRule; // 发布规则 . 用于单次.
	private java.lang.String publishDate;  // 发布日期
	private java.lang.String content;  //公告内容
	private java.lang.String tiltle;//标题 
	private java.lang.String noticId; // 公告主键
	private java.lang.String noticGroupId;
	
	private java.sql.Timestamp createdDate;
	private java.lang.String createdUser;
	
	private java.lang.String updatedUser;
	private java.sql.Timestamp updatedDate;
	private java.lang.String businessLine;
	
	public java.lang.String getBusinessLine() {
		return businessLine;
	}

	public void setBusinessLine(java.lang.String businessLine) {
		this.businessLine = businessLine;
	}

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public java.lang.String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setPeriodValue ( java.lang.Double periodValue ) {
		this.periodValue = periodValue;
	}
	
	public java.lang.Double getPeriodValue (){
		return periodValue;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setDeptCode ( java.lang.String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public java.lang.String getDeptCode (){
		return deptCode;
	}
	
	public void setPublisher ( java.lang.String publisher ) {
		this.publisher = publisher;
	}
	
	public java.lang.String getPublisher (){
		return publisher;
	}
	
	public void setPeriod ( java.lang.String period ) {
		this.period = period;
	}
	
	public java.lang.String getPeriod (){
		return period;
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
	
	public void setPublishDate ( java.lang.String publishDate ) {
		this.publishDate = publishDate;
	}
	
	public java.lang.String getPublishDate (){
		return publishDate;
	}
	
	public void setFeedbackDay ( java.lang.Double feedbackDay ) {
		this.feedbackDay = feedbackDay;
	}
	
	public java.lang.Double getFeedbackDay (){
		return feedbackDay;
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
	
	public void setPublishDeptCode ( java.lang.String publishDeptCode ) {
		this.publishDeptCode = publishDeptCode;
	}
	
	public java.lang.String getPublishDeptCode (){
		return publishDeptCode;
	}
	
	public void setPublishRule ( java.lang.String publishRule ) {
		this.publishRule = publishRule;
	}
	
	public java.lang.String getPublishRule (){
		return publishRule;
	}
	
	public void setContent ( java.lang.String content ) {
		this.content = content;
	}
	
	public java.lang.String getContent (){
		return content;
	}
	
	public void setTiltle ( java.lang.String tiltle ) {
		this.tiltle = tiltle;
	}
	
	public java.lang.String getTiltle (){
		return tiltle;
	}
	
	public void setNoticId ( java.lang.String noticId ) {
		this.noticId = noticId;
	}
	
	public java.lang.String getNoticId (){
		return noticId;
	}

	public java.lang.String getNoticGroupId() {
		return noticGroupId;
	}

	public void setNoticGroupId(java.lang.String noticGroupId) {
		this.noticGroupId = noticGroupId;
	}
	

}