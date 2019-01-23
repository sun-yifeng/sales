package com.sinosafe.xszc.group.vo;


public class GroupMain implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String groupCode;
	private java.lang.String groupName;
	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String createdUser;
	private java.lang.String remark;
	private java.lang.String deptCode;
	private java.lang.String foundDate;
	private java.sql.Timestamp updatedDate;
	private java.lang.String status; 
	private java.lang.String groupType;
	private java.lang.String identify;
	private java.lang.String virtualFlag;
	private java.lang.String historyId;

	public java.lang.String getHistoryId() {
		return historyId;
	}

	public void setHistoryId(java.lang.String historyId) {
		this.historyId = historyId;
	}

	public java.lang.String getIdentify() {
		return identify;
	}

	public void setIdentify(java.lang.String identify) {
		this.identify = identify;
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
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setGroupName ( java.lang.String groupName ) {
		this.groupName = groupName;
	}
	
	public java.lang.String getGroupName (){
		return groupName;
	}
	
	public void setRemark ( java.lang.String remark ) {
		this.remark = remark;
	}
	
	public java.lang.String getRemark (){
		return remark;
	}
	
	public void setDeptCode ( java.lang.String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public java.lang.String getDeptCode (){
		return deptCode;
	}
	
	public void setFoundDate (  java.lang.String  foundDate ) {
		this.foundDate = foundDate;
	}
	
	public java.lang.String  getFoundDate (){
		return foundDate;
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
	
	public void setGroupType ( java.lang.String groupType ) {
		this.groupType = groupType;
	}
	
	public java.lang.String getGroupType (){
		return groupType;
	}
	
	public void setGroupCode ( java.lang.String groupCode ) {
		this.groupCode = groupCode;
	}
	
	public java.lang.String getGroupCode (){
		return groupCode;
	}

	public java.lang.String getVirtualFlag() {
		return virtualFlag;
	}

	public void setVirtualFlag(java.lang.String virtualFlag) {
		this.virtualFlag = virtualFlag;
	}



}