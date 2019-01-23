package com.sinosafe.xszc.review.vo;


public class ReviewRankHistory implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String rankId;
	private java.lang.String pkid;
	private java.lang.String changeuser;
	private java.sql.Timestamp changedate;
	private java.lang.String afterRank;
	private java.lang.String beforeRank;

	public void setRankId ( java.lang.String rankId ) {
		this.rankId = rankId;
	}
	
	public java.lang.String getRankId (){
		return rankId;
	}
	
	public void setPkid ( java.lang.String pkid ) {
		this.pkid = pkid;
	}
	
	public java.lang.String getPkid (){
		return pkid;
	}
	
	public void setChangeuser ( java.lang.String changeuser ) {
		this.changeuser = changeuser;
	}
	
	public java.lang.String getChangeuser (){
		return changeuser;
	}
	
	public void setChangedate ( java.sql.Timestamp changedate ) {
		this.changedate = changedate;
	}
	
	public java.sql.Timestamp getChangedate (){
		return changedate;
	}
	
	public void setAfterRank ( java.lang.String afterRank ) {
		this.afterRank = afterRank;
	}
	
	public java.lang.String getAfterRank (){
		return afterRank;
	}
	
	public void setBeforeRank ( java.lang.String beforeRank ) {
		this.beforeRank = beforeRank;
	}
	
	public java.lang.String getBeforeRank (){
		return beforeRank;
	}
	

}