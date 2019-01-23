package com.sinosafe.xszc.plan.vo;


public class SalePlanDept implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.sql.Timestamp createdDate;
	private java.lang.Double normalPremium;
	private java.lang.String content;
	private java.lang.String createdUser;
	private java.lang.String desc;
	private java.lang.String deptRiskType;
	private java.lang.Double iportantPremium;
	private java.sql.Timestamp updatedDate;
	private java.lang.String salePlanId;
	private java.lang.String deptPlanId;
	private java.lang.Double financePreminum;
	private java.lang.String status;

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public java.lang.String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setCreatedDate ( java.sql.Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public java.sql.Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setNormalPremium ( java.lang.Double normalPremium ) {
		this.normalPremium = normalPremium;
	}
	
	public java.lang.Double getNormalPremium (){
		return normalPremium;
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
	
	public void setDesc ( java.lang.String desc ) {
		this.desc = desc;
	}
	
	public java.lang.String getDesc (){
		return desc;
	}
	
	public void setDeptRiskType ( java.lang.String deptRiskType ) {
		this.deptRiskType = deptRiskType;
	}
	
	public java.lang.String getDeptRiskType (){
		return deptRiskType;
	}
	
	public void setIportantPremium ( java.lang.Double iportantPremium ) {
		this.iportantPremium = iportantPremium;
	}
	
	public java.lang.Double getIportantPremium (){
		return iportantPremium;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setSalePlanId ( java.lang.String salePlanId ) {
		this.salePlanId = salePlanId;
	}
	
	public java.lang.String getSalePlanId (){
		return salePlanId;
	}
	
	public void setDeptPlanId ( java.lang.String deptPlanId ) {
		this.deptPlanId = deptPlanId;
	}
	
	public java.lang.String getDeptPlanId (){
		return deptPlanId;
	}
	
	public void setFinancePreminum ( java.lang.Double financePreminum ) {
		this.financePreminum = financePreminum;
	}
	
	public java.lang.String getStatus() {
		return status;
	}

	public void setStatus(java.lang.String status) {
		this.status = status;
	}

	public java.lang.Double getFinancePreminum (){
		return financePreminum;
	}
	

}