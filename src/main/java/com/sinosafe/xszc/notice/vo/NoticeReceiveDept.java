package com.sinosafe.xszc.notice.vo;


public class NoticeReceiveDept implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String receiverId; //PK 
	private java.lang.String noticId;  //公告主键
	private java.lang.String deptCode;  // 部门代码.
	
	private java.lang.String validInd; // 1 有效
	
	
	private java.lang.String createdUser; //..非空
	private java.sql.Timestamp createdDate;//..非空
	private java.lang.String updatedUser;//..非空
	
	private java.sql.Timestamp updatedDate;//..非空
	private java.lang.String status; //..非空 状态,1-运行中,2-已停止

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
	
	public void setReceiverId ( java.lang.String receiverId ) {
		this.receiverId = receiverId;
	}
	
	public java.lang.String getReceiverId (){
		return receiverId;
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
	
	public void setNoticId ( java.lang.String noticId ) {
		this.noticId = noticId;
	}
	
	public java.lang.String getNoticId (){
		return noticId;
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
	

}