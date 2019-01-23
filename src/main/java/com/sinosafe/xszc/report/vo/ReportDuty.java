package com.sinosafe.xszc.report.vo;


public class ReportDuty implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String vhlType;//客户类别
	private java.lang.Double nPrm;//签单保费
	private java.lang.String updateDate;//核保日期
	private java.lang.String cInterCde;//中支机构
	private java.lang.String primaryCProdName;//险种大类

	public void setVhlType ( java.lang.String vhlType ) {
		this.vhlType = vhlType;
	}
	
	public java.lang.String getVhlType (){
		return vhlType;
	}
	
	public void setNPrm ( java.lang.Double nPrm ) {
		this.nPrm = nPrm;
	}
	
	public java.lang.Double getNPrm (){
		return nPrm;
	}
	
	public void setUpdateDate ( java.lang.String updateDate ) {
		this.updateDate = updateDate;
	}
	
	public java.lang.String getUpdateDate (){
		return updateDate;
	}
	
	public void setCInterCde ( java.lang.String cInterCde ) {
		this.cInterCde = cInterCde;
	}
	
	public java.lang.String getCInterCde (){
		return cInterCde;
	}
	
	public void setPrimaryCProdName ( java.lang.String primaryCProdName ) {
		this.primaryCProdName = primaryCProdName;
	}
	
	public java.lang.String getPrimaryCProdName (){
		return primaryCProdName;
	}
	

}