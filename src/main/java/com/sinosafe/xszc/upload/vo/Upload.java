package com.sinosafe.xszc.upload.vo;


public class Upload implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String uploadId;
	private java.lang.String name;
	private java.lang.String content;
	private java.lang.String createdUser;
	private java.lang.String module;
	private java.lang.String deptCode;
	private java.lang.String path;
	private java.sql.Timestamp updatedDate;
	private java.lang.String mainId;

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
	
	public void setUploadId ( java.lang.String uploadId ) {
		this.uploadId = uploadId;
	}
	
	public java.lang.String getUploadId (){
		return uploadId;
	}
	
	public void setName ( java.lang.String name ) {
		this.name = name;
	}
	
	public java.lang.String getName (){
		return name;
	}
	
	public void setContent ( java.lang.String content ) {
		this.content = content;
	}
	
	public java.lang.String getContent (){
		return content;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setModule ( java.lang.String module ) {
		this.module = module;
	}
	
	public java.lang.String getModule (){
		return module;
	}
	
	public void setDeptCode ( java.lang.String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public java.lang.String getDeptCode (){
		return deptCode;
	}
	
	public void setPath ( java.lang.String path ) {
		this.path = path;
	}
	
	public java.lang.String getPath (){
		return path;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setMainId ( java.lang.String mainId ) {
		this.mainId = mainId;
	}
	
	public java.lang.String getMainId (){
		return mainId;
	}
	

}