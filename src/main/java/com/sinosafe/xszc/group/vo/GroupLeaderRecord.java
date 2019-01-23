package com.sinosafe.xszc.group.vo;


public class GroupLeaderRecord implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;		    //有效标示位,1-有效,0-删除
	private java.sql.Timestamp createdDate;
	private java.lang.String leaderRecordId;	//团队长记录主键
	private java.lang.String createdUser;
	private java.lang.String groupLeader;		//团队长
	private java.sql.Timestamp updatedDate;
	private java.lang.String status;			//状态,0-未生效,1-已经生效
	private java.lang.String statistic;			//业绩统计,0-本级,1-上级
	private java.lang.String groupCode;			//团队代码
	private java.lang.String historyId;

	public java.lang.String getHistoryId() {
		return historyId;
	}

	public void setHistoryId(java.lang.String historyId) {
		this.historyId = historyId;
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
	
	public void setCreatedDate ( java.sql.Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public java.sql.Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setLeaderRecordId ( java.lang.String leaderRecordId ) {
		this.leaderRecordId = leaderRecordId;
	}
	
	public java.lang.String getLeaderRecordId (){
		return leaderRecordId;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setGroupLeader ( java.lang.String groupLeader ) {
		this.groupLeader = groupLeader;
	}
	
	public java.lang.String getGroupLeader (){
		return groupLeader;
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
	
	public void setStatistic ( java.lang.String statistic ) {
		this.statistic = statistic;
	}
	
	public java.lang.String getStatistic (){
		return statistic;
	}
	
	public void setGroupCode ( java.lang.String groupCode ) {
		this.groupCode = groupCode;
	}
	
	public java.lang.String getGroupCode (){
		return groupCode;
	}
	

}