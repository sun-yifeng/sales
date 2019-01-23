package com.sinosafe.xszc.partner.vo;

import java.util.HashSet;
import java.util.Set;

public class Confer implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String expireDate;
	private java.lang.Double calclatePeriod;
	private java.lang.String signDate;
	private java.lang.Double rate;
	private java.lang.String createdUser;
	private java.lang.String channelCode;
	private java.lang.String financeChannel;
	private java.lang.String remark;
	private java.lang.String deptCode;
	private java.sql.Timestamp updatedDate;
	private java.lang.String conferType;
	private java.lang.String conferCode;
	private java.lang.String extendConferCode;
	private java.lang.String grantFlag;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String validDate;
	private java.lang.String feature;
	private java.lang.String grantDept;
	private java.lang.String conferId;
	private java.lang.String approveFlag;
	private java.lang.String approveCode;
	private java.lang.String calclateFlag;
	private java.lang.String channelFlag;

	public java.lang.String getChannelFlag() {
		return channelFlag;
	}

	public void setChannelFlag(java.lang.String channelFlag) {
		this.channelFlag = channelFlag;
	}

	public java.lang.String getCalclateFlag() {
		return calclateFlag;
	}

	public void setCalclateFlag(java.lang.String calclateFlag) {
		this.calclateFlag = calclateFlag;
	}

	private Set<ConferProduct> conferProduct = new HashSet<ConferProduct>();

	public Set<ConferProduct> getConferProduct() {
		return conferProduct;
	}

	public void setConferProduct(Set<ConferProduct> conferProduct) {
		this.conferProduct = conferProduct;
	}

	public void setUpdatedUser(java.lang.String updatedUser) {
		this.updatedUser = updatedUser;
	}

	public java.lang.String getUpdatedUser() {
		return updatedUser;
	}

	public void setExpireDate(java.lang.String expireDate) {
		this.expireDate = expireDate;
	}

	public java.lang.String getExpireDate() {
		return expireDate;
	}

	public void setCalclatePeriod(java.lang.Double calclatePeriod) {
		this.calclatePeriod = calclatePeriod;
	}

	public java.lang.Double getCalclatePeriod() {
		return calclatePeriod;
	}

	public void setSignDate(java.lang.String signDate) {
		this.signDate = signDate;
	}

	public java.lang.String getSignDate() {
		return signDate;
	}

	public void setRate(java.lang.Double rate) {
		this.rate = rate;
	}

	public java.lang.Double getRate() {
		return rate;
	}

	public void setCreatedUser(java.lang.String createdUser) {
		this.createdUser = createdUser;
	}

	public java.lang.String getCreatedUser() {
		return createdUser;
	}

	public void setChannelCode(java.lang.String channelCode) {
		this.channelCode = channelCode;
	}

	public java.lang.String getChannelCode() {
		return channelCode;
	}

	public void setFinanceChannel(java.lang.String financeChannel) {
		this.financeChannel = financeChannel;
	}

	public java.lang.String getFinanceChannel() {
		return financeChannel;
	}

	public void setRemark(java.lang.String remark) {
		this.remark = remark;
	}

	public java.lang.String getRemark() {
		return remark;
	}

	public void setDeptCode(java.lang.String deptCode) {
		this.deptCode = deptCode;
	}

	public java.lang.String getDeptCode() {
		return deptCode;
	}

	public void setUpdatedDate(java.sql.Timestamp updatedDate) {
		this.updatedDate = updatedDate;
	}

	public java.sql.Timestamp getUpdatedDate() {
		return updatedDate;
	}

	public void setConferType(java.lang.String conferType) {
		this.conferType = conferType;
	}

	public java.lang.String getConferType() {
		return conferType;
	}

	public void setConferCode(java.lang.String conferCode) {
		this.conferCode = conferCode;
	}

	public java.lang.String getConferCode() {
		return conferCode;
	}

	public void setExtendConferCode(java.lang.String extendConferCode) {
		this.extendConferCode = extendConferCode;
	}

	public java.lang.String getExtendConferCode() {
		return extendConferCode;
	}

	public void setGrantFlag(java.lang.String grantFlag) {
		this.grantFlag = grantFlag;
	}

	public java.lang.String getGrantFlag() {
		return grantFlag;
	}

	public void setValidInd(java.lang.String validInd) {
		this.validInd = validInd;
	}

	public java.lang.String getValidInd() {
		return validInd;
	}

	public void setCreatedDate(java.sql.Timestamp createdDate) {
		this.createdDate = createdDate;
	}

	public java.sql.Timestamp getCreatedDate() {
		return createdDate;
	}

	public void setValidDate(java.lang.String validDate) {
		this.validDate = validDate;
	}

	public java.lang.String getValidDate() {
		return validDate;
	}

	public void setFeature(java.lang.String feature) {
		this.feature = feature;
	}

	public java.lang.String getFeature() {
		return feature;
	}

	public void setGrantDept(java.lang.String grantDept) {
		this.grantDept = grantDept;
	}

	public java.lang.String getGrantDept() {
		return grantDept;
	}

	public java.lang.String getConferId() {
		return conferId;
	}

	public void setConferId(java.lang.String conferId) {
		this.conferId = conferId;
	}

	public java.lang.String getApproveFlag() {
		return approveFlag;
	}

	public void setApproveFlag(java.lang.String approveFlag) {
		this.approveFlag = approveFlag;
	}

	public java.lang.String getApproveCode() {
		return approveCode;
	}

	public void setApproveCode(java.lang.String approveCode) {
		this.approveCode = approveCode;
	}

}