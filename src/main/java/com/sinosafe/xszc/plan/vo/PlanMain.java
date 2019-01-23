package com.sinosafe.xszc.plan.vo;

import java.util.Set;

public class PlanMain implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String quarter;
	private java.lang.String planWriteDate;
	private java.lang.String createdUser;
	private java.lang.Integer year;
	private java.lang.String deptCode;
	private java.lang.String planType;
	private java.sql.Timestamp updatedDate;
	private java.lang.String status;
	private java.lang.String planWriter;
	private java.lang.String validInd;
	private java.lang.Double deptPremium;
	private java.sql.Timestamp createdDate;
	private java.lang.String planMainId;

	private Set<PlanDeptDetail> planDeptDetail;
	private Set<PlanChannelDetail> planChannelDetail;

	public void setUpdatedUser(java.lang.String updatedUser) {
		this.updatedUser = updatedUser;
	}

	public java.lang.String getUpdatedUser() {
		return updatedUser;
	}

	public void setQuarter(java.lang.String quarter) {
		this.quarter = quarter;
	}

	public java.lang.String getQuarter() {
		return quarter;
	}

	public java.lang.String getPlanWriteDate() {
		if (planWriteDate == null) {
			return null;
		} else {
			return planWriteDate.substring(0, 10);
		}
	}

	public void setPlanWriteDate(java.lang.String planWriteDate) {
		this.planWriteDate = planWriteDate;
	}

	public void setCreatedUser(java.lang.String createdUser) {
		this.createdUser = createdUser;
	}

	public java.lang.String getCreatedUser() {
		return createdUser;
	}

	public void setYear(java.lang.Integer year) {
		this.year = year;
	}

	public java.lang.Integer getYear() {
		return year;
	}

	public void setDeptCode(java.lang.String deptCode) {
		this.deptCode = deptCode;
	}

	public java.lang.String getDeptCode() {
		return deptCode;
	}

	public void setPlanType(java.lang.String planType) {
		this.planType = planType;
	}

	public java.lang.String getPlanType() {
		return planType;
	}

	public void setUpdatedDate(java.sql.Timestamp updatedDate) {
		this.updatedDate = updatedDate;
	}

	public java.sql.Timestamp getUpdatedDate() {
		return updatedDate;
	}

	public void setStatus(java.lang.String status) {
		this.status = status;
	}

	public java.lang.String getStatus() {
		return status;
	}

	public void setPlanWriter(java.lang.String planWriter) {
		this.planWriter = planWriter;
	}

	public java.lang.String getPlanWriter() {
		return planWriter;
	}

	public void setValidInd(java.lang.String validInd) {
		this.validInd = validInd;
	}

	public java.lang.String getValidInd() {
		return validInd;
	}

	public void setDeptPremium(java.lang.Double deptPremium) {
		this.deptPremium = deptPremium;
	}

	public java.lang.Double getDeptPremium() {
		return deptPremium;
	}

	public void setCreatedDate(java.sql.Timestamp createdDate) {
		this.createdDate = createdDate;
	}

	public java.sql.Timestamp getCreatedDate() {
		return createdDate;
	}

	public void setPlanMainId(java.lang.String planMainId) {
		this.planMainId = planMainId;
	}

	public java.lang.String getPlanMainId() {
		return planMainId;
	}

	public Set<PlanDeptDetail> getPlanDeptDetail() {
		return planDeptDetail;
	}

	public void setPlanDeptDetail(Set<PlanDeptDetail> planDeptDetail) {
		this.planDeptDetail = planDeptDetail;
	}

	public Set<PlanChannelDetail> getPlanChannelDetail() {
		return planChannelDetail;
	}

	public void setPlanChannelDetail(Set<PlanChannelDetail> planChannelDetail) {
		this.planChannelDetail = planChannelDetail;
	}
}