package com.sinosafe.xszc.common.vo;


public class TPrdKind implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.sql.Timestamp tBgnTm;
	private java.lang.String cKindNo;
	private java.sql.Timestamp tEndTm;
	private java.sql.Timestamp tCrtTm;
	private java.lang.String cNmeEn;
	private java.lang.String cNmeCn;

	public void setTBgnTm ( java.sql.Timestamp tBgnTm ) {
		this.tBgnTm = tBgnTm;
	}
	
	public java.sql.Timestamp getTBgnTm (){
		return tBgnTm;
	}
	
	public void setCKindNo ( java.lang.String cKindNo ) {
		this.cKindNo = cKindNo;
	}
	
	public java.lang.String getCKindNo (){
		return cKindNo;
	}
	
	public void setTEndTm ( java.sql.Timestamp tEndTm ) {
		this.tEndTm = tEndTm;
	}
	
	public java.sql.Timestamp getTEndTm (){
		return tEndTm;
	}
	
	public void setTCrtTm ( java.sql.Timestamp tCrtTm ) {
		this.tCrtTm = tCrtTm;
	}
	
	public java.sql.Timestamp getTCrtTm (){
		return tCrtTm;
	}
	
	public void setCNmeEn ( java.lang.String cNmeEn ) {
		this.cNmeEn = cNmeEn;
	}
	
	public java.lang.String getCNmeEn (){
		return cNmeEn;
	}
	
	public void setCNmeCn ( java.lang.String cNmeCn ) {
		this.cNmeCn = cNmeCn;
	}
	
	public java.lang.String getCNmeCn (){
		return cNmeCn;
	}
	

}