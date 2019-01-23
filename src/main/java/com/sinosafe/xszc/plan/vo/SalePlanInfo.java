package com.sinosafe.xszc.plan.vo;

import java.util.HashSet;
import java.util.Set;



public class SalePlanInfo implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String createdDate;
	private java.lang.Double deptPremium;
	private java.lang.String quarter;
	private java.lang.String createdUser;
	private java.lang.Integer year;
	private java.lang.String deptCode;
	private java.lang.String planType;
	private java.sql.Timestamp updatedDate;
	private java.lang.String salePlanId;
	
	private Set<SalePlanDept> salePlanDept;
	
	private Set<SalePlanChannel> salePlanChannel = new HashSet<SalePlanChannel>();

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public Set<SalePlanChannel> getSalePlanChannel() {
		return salePlanChannel;
	}

	public void setSalePlanChannel(Set<SalePlanChannel> salePlanChannel) {
		this.salePlanChannel = salePlanChannel;
	}

	public java.lang.String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setDeptPremium ( java.lang.Double deptPremium ) {
		this.deptPremium = deptPremium;
	}
	
	public java.lang.Double getDeptPremium (){
		return deptPremium;
	}
	
	public void setQuarter ( java.lang.String quarter ) {
		this.quarter = quarter;
	}
	
	public java.lang.String getQuarter (){
		return quarter;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setYear ( java.lang.Integer year ) {
		this.year = year;
	}
	
	public java.lang.Integer getYear (){
		return year;
	}
	
	public void setDeptCode ( java.lang.String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public java.lang.String getDeptCode (){
		return deptCode;
	}
	
	public void setPlanType ( java.lang.String planType ) {
		this.planType = planType;
	}
	
	public java.lang.String getPlanType (){
		return planType;
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

	public java.lang.String getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(java.lang.String createdDate) {
		this.createdDate = createdDate;
	}

	public Set<SalePlanDept> getSalePlanDept() {
		return salePlanDept;
	}

	public void setSalePlanDept(Set<SalePlanDept> salePlanDept) {
		this.salePlanDept = salePlanDept;
	}
	

}