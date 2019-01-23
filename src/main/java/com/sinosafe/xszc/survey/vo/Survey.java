package com.sinosafe.xszc.survey.vo;


public class Survey implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.lang.String docName;
	private java.sql.Timestamp uploadEndDate;
	private java.lang.String sruveryId;
	private java.sql.Timestamp createdDate;
	private java.sql.Timestamp uploadBeginDate;
	private java.lang.String createdUser;
	private java.lang.String docType;
	private java.lang.String deptCode;
	private java.sql.Timestamp updatedDate;
	private java.lang.String docPath;

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
	
	public void setDocName ( java.lang.String docName ) {
		this.docName = docName;
	}
	
	public java.lang.String getDocName (){
		return docName;
	}
	
	public void setUploadEndDate ( java.sql.Timestamp uploadEndDate ) {
		this.uploadEndDate = uploadEndDate;
	}
	
	public java.sql.Timestamp getUploadEndDate (){
		return uploadEndDate;
	}
	
	public void setSruveryId ( java.lang.String sruveryId ) {
		this.sruveryId = sruveryId;
	}
	
	public java.lang.String getSruveryId (){
		return sruveryId;
	}
	
	public void setCreatedDate ( java.sql.Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public java.sql.Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setUploadBeginDate ( java.sql.Timestamp uploadBeginDate ) {
		this.uploadBeginDate = uploadBeginDate;
	}
	
	public java.sql.Timestamp getUploadBeginDate (){
		return uploadBeginDate;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setDocType ( java.lang.String docType ) {
		this.docType = docType;
	}
	
	public java.lang.String getDocType (){
		return docType;
	}
	
	public void setDeptCode ( java.lang.String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public java.lang.String getDeptCode (){
		return deptCode;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setDocPath ( java.lang.String docPath ) {
		this.docPath = docPath;
	}
	
	public java.lang.String getDocPath (){
		return docPath;
	}
	

}