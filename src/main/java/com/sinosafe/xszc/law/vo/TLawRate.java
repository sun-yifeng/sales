package com.sinosafe.xszc.law.vo;

public class TLawRate implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

	private String pkId;
	private String versionId;
	private String rateType;
	private String rateCode;
	private String rateName;
	private Double rate;
	private String remark;
	private String validInd;
	
	// 渠道系数特殊字段
	private String processUserCode;
	private String processDeptCode;
	
	// 操作人信息
	private String createdUser;
	private String createdDate;
	private String updatedUser;
	private String updatedDate;

	public void setUpdatedUser(String updatedUser) {
		this.updatedUser = updatedUser;
	}

	public String getUpdatedUser() {
		return updatedUser;
	}

	public void setValidInd(String validInd) {
		this.validInd = validInd;
	}

	public String getValidInd() {
		return validInd;
	}

	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}

	public String getCreatedDate() {
		return createdDate;
	}

	public void setRate(Double rate) {
		this.rate = rate;
	}

	public Double getRate() {
		return rate;
	}

	public void setPkId(String pkId) {
		this.pkId = pkId;
	}

	public String getPkId() {
		return pkId;
	}

	public void setRateType(String rateType) {
		this.rateType = rateType;
	}

	public String getRateType() {
		return rateType;
	}

	public void setCreatedUser(String createdUser) {
		this.createdUser = createdUser;
	}

	public String getCreatedUser() {
		return createdUser;
	}

	public void setVersionId(String versionId) {
		this.versionId = versionId;
	}

	public String getVersionId() {
		return versionId;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getRemark() {
		return remark;
	}

	public void setRateCode(String rateCode) {
		this.rateCode = rateCode;
	}

	public String getRateCode() {
		return rateCode;
	}

	public void setUpdatedDate(String updatedDate) {
		this.updatedDate = updatedDate;
	}

	public String getUpdatedDate() {
		return updatedDate;
	}

	public void setRateName(String rateName) {
		this.rateName = rateName;
	}

	public String getRateName() {
		return rateName;
	}

	public String getProcessUserCode() {
		return processUserCode;
	}

	public void setProcessUserCode(String processUserCode) {
		this.processUserCode = processUserCode;
	}

	public String getProcessDeptCode() {
		return processDeptCode;
	}

	public void setProcessDeptCode(String processDeptCode) {
		this.processDeptCode = processDeptCode;
	}
}