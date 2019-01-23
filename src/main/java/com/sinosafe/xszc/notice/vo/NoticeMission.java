package com.sinosafe.xszc.notice.vo;


public class NoticeMission implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String createdUser;
	private java.lang.String noticId;
	private java.sql.Timestamp updatedDate;
	private java.lang.String nextPublishDate;
	private java.lang.String publishDate;
	private java.lang.String missionId;

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
	
	public void setNextPublishDate ( java.lang.String nextPublishDate ) {
		this.nextPublishDate = nextPublishDate;
	}
	
	public java.lang.String getNextPublishDate (){
		return nextPublishDate;
	}
	
	public void setPublishDate ( java.lang.String publishDate ) {
		this.publishDate = publishDate;
	}
	
	public java.lang.String getPublishDate (){
		return publishDate;
	}
	
	public void setMissionId ( java.lang.String missionId ) {
		this.missionId = missionId;
	}
	
	public java.lang.String getMissionId (){
		return missionId;
	}
	

}