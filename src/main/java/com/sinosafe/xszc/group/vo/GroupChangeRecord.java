package com.sinosafe.xszc.group.vo;


public class GroupChangeRecord implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String createdUser;
	private java.lang.String deptCode;
	private java.lang.String remark;
	private java.sql.Timestamp updatedDate;
	private java.lang.String status;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String recordId;
	private java.lang.String salesmanCode;
	private java.lang.String validDate;
	private java.lang.String changeDate;
	private java.lang.String groupCode;
	private java.lang.String groupMemberCode;

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public java.lang.String getUpdatedUser (){
		return updatedUser;
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
	
	public void setRemark ( java.lang.String remark ) {
		this.remark = remark;
	}
	
	public java.lang.String getRemark (){
		return remark;
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
	
	public void setRecordId ( java.lang.String recordId ) {
		this.recordId = recordId;
	}
	
	public java.lang.String getRecordId (){
		return recordId;
	}
	
	public void setSalesmanCode ( java.lang.String salesmanCode ) {
		this.salesmanCode = salesmanCode;
	}
	
	public java.lang.String getSalesmanCode (){
		return salesmanCode;
	}
	
	public java.lang.String getValidDate() {
		return validDate;
	}

	public void setValidDate(java.lang.String validDate) {
		this.validDate = validDate;
	}

	public java.lang.String getChangeDate() {
		return changeDate;
	}

	public void setChangeDate(java.lang.String changeDate) {
		this.changeDate = changeDate;
	}

	public void setGroupCode ( java.lang.String groupCode ) {
		this.groupCode = groupCode;
	}
	
	public java.lang.String getGroupCode (){
		return groupCode;
	}
	
	public void setGroupMemberCode ( java.lang.String groupMemberCode ) {
		this.groupMemberCode = groupMemberCode;
	}
	
	public java.lang.String getGroupMemberCode (){
		return groupMemberCode;
	}
	

}