package com.sinosafe.xszc.planNew.vo;

import java.sql.Timestamp;

public class PlanDetailNew implements java.io.Serializable {

	private static final long serialVersionUID = 1L;
	
	// 机构计划主键
	private String planMainId;
	// 销售计划明细主键
	private String planDeptId;

	private String deptCode;// 机构代码

	private String deptRiskType;// 险种，1-车险，2-财险，3-寿险
	private String lineCode;// 业务线 某一种保险对应多条业务线，每条业务线对应一个保费值
	private double planFee;// 保费值
	private String content;// 发展及举措
	private String remark;// 备注

	// 数据状态信息
	private String validInd;// 有效标示位,1-有效,0-失效
	private String status;// 状态，0-草稿，1-下发
	
	// 操作人信息
	private String createdUser;
	private Timestamp createdDate;
	private String updatedUser;
	private Timestamp updatedDate;

	public void setPlanDeptId(String planDeptId) {
		this.planDeptId = planDeptId;
	}

	public String getPlanDeptId() {
		return planDeptId;
	}

	public void setUpdatedUser(String updatedUser) {
		this.updatedUser = updatedUser;
	}

	public String getUpdatedUser() {
		return updatedUser;
	}

	public void setLineCode(String lineCode) {
		this.lineCode = lineCode;
	}

	public String getLineCode() {
		return lineCode;
	}

	public void setCreatedUser(String createdUser) {
		this.createdUser = createdUser;
	}

	public String getCreatedUser() {
		return createdUser;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptRiskType(String deptRiskType) {
		this.deptRiskType = deptRiskType;
	}

	public String getDeptRiskType() {
		return deptRiskType;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getRemark() {
		return remark;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStatus() {
		return status;
	}

	public void setUpdatedDate(Timestamp updatedDate) {
		this.updatedDate = updatedDate;
	}

	public Timestamp getUpdatedDate() {
		return updatedDate;
	}

	public void setValidInd(String validInd) {
		this.validInd = validInd;
	}

	public String getValidInd() {
		return validInd;
	}

	public void setCreatedDate(Timestamp createdDate) {
		this.createdDate = createdDate;
	}

	public Timestamp getCreatedDate() {
		return createdDate;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getContent() {
		return content;
	}

	public void setPlanMainId(String planMainId) {
		this.planMainId = planMainId;
	}

	public String getPlanMainId() {
		return planMainId;
	}

	public void setPlanFee(double planFee) {
		this.planFee = planFee;
	}

	public double getPlanFee() {
		return planFee;
	}
}