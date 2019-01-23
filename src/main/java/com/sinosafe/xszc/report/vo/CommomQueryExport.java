package com.sinosafe.xszc.report.vo;


public class CommomQueryExport implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.lang.String execSql;
	private java.sql.Timestamp createdDate;
	private java.lang.String queryName;
	private java.lang.String createdUser;
	private java.lang.String queryId;
	private java.sql.Timestamp updatedDate;

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
	
	public void setExecSql ( java.lang.String execSql ) {
		this.execSql = execSql;
	}
	
	public java.lang.String getExecSql (){
		return execSql;
	}
	
	public void setCreatedDate ( java.sql.Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public java.sql.Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setQueryName ( java.lang.String queryName ) {
		this.queryName = queryName;
	}
	
	public java.lang.String getQueryName (){
		return queryName;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setQueryId ( java.lang.String queryId ) {
		this.queryId = queryId;
	}
	
	public java.lang.String getQueryId (){
		return queryId;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	

}