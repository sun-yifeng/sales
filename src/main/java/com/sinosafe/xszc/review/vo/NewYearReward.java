package com.sinosafe.xszc.review.vo;


public class NewYearReward implements java.io.Serializable{

	private static final long serialVersionUID = -4245510270405014607L;
	
	private String pkId;
	private String rewardDate;
	private String deptCode;
	private String rewardName;
	private String employNum;
	private Double reward;
	private String validInd;
	
	// 操作人信息
	private String createdUser;
	private String createdDate;
	private String updatedUser;
	private String updatedDate;
	
	public String getPkId() {
		return pkId;
	}
	public void setPkId(String pkId) {
		this.pkId = pkId;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getRewardName() {
		return rewardName;
	}
	public void setRewardName(String rewardName) {
		this.rewardName = rewardName;
	}
	public String getEmployNum() {
		return employNum;
	}
	public void setEmployNum(String employNum) {
		this.employNum = employNum;
	}
	public Double getReward() {
		return reward;
	}
	public void setReward(Double reward) {
		this.reward = reward;
	}
	public String getValidInd() {
		return validInd;
	}
	public void setValidInd(String validInd) {
		this.validInd = validInd;
	}
	public String getCreatedUser() {
		return createdUser;
	}
	public void setCreatedUser(String createdUser) {
		this.createdUser = createdUser;
	}
	public String getCreatedDate() {
		return createdDate;
	}
	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}
	public String getUpdatedUser() {
		return updatedUser;
	}
	public void setUpdatedUser(String updatedUser) {
		this.updatedUser = updatedUser;
	}
	public String getUpdatedDate() {
		return updatedDate;
	}
	public void setUpdatedDate(String updatedDate) {
		this.updatedDate = updatedDate;
	}
	public String getRewardDate() {
		return rewardDate;
	}
	public void setRewardDate(String rewardDate) {
		this.rewardDate = rewardDate;
	}

	
}