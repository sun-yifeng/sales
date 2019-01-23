package com.sinosafe.xszc.law.vo;

import java.io.Serializable;

public class LawDefineManul implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String versionId;//基本法版本号
	private String deptCode;//机构代码
	private String lineCode;//业务线代码
	private String calcMonth;//计算月份(格式:YYYYMM)
	private String procName;//存过名称
	private String taskCode;//任务代码(1导入MIS数据,2导入考核的销售人员,3计算标保,4计算因素,5计算公式,6计算评分,7计算职级)
	private String taskStatus;//任务状态(1未开始,2正在执行,3执行完成,9执行失败)
	private String remark;//说明
	private String validInd;
	private java.sql.Timestamp taskBeginDate;//任务开始执行时间
	private java.sql.Timestamp taskEndDate;//任务结束执行时间
	
	// 操作人信息
	private String createdUser;
	private String createdDate;
	private String updatedUser;
	private String updatedDate;
	
	//操作人ip地址
	private String operatorId;
	private String taskId;
	
	public String getOperatorId() {
		return operatorId;
	}
	public void setOperatorId(String operatorId) {
		this.operatorId = operatorId;
	}
	public String getTaskId() {
		return taskId;
	}
	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}
	public java.sql.Timestamp getTaskBeginDate() {
		return taskBeginDate;
	}
	public void setTaskBeginDate(java.sql.Timestamp taskBeginDate) {
		this.taskBeginDate = taskBeginDate;
	}
	public java.sql.Timestamp getTaskEndDate() {
		return taskEndDate;
	}
	public void setTaskEndDate(java.sql.Timestamp taskEndDate) {
		this.taskEndDate = taskEndDate;
	}
	public String getVersionId() {
		return versionId;
	}
	public void setVersionId(String versionId) {
		this.versionId = versionId;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getLineCode() {
		return lineCode;
	}
	public void setLineCode(String lineCode) {
		this.lineCode = lineCode;
	}
	public String getCalcMonth() {
		return calcMonth;
	}
	public void setCalcMonth(String calcMonth) {
		this.calcMonth = calcMonth;
	}
	public String getProcName() {
		return procName;
	}
	public void setProcName(String procName) {
		this.procName = procName;
	}
	public String getTaskCode() {
		return taskCode;
	}
	public void setTaskCode(String taskCode) {
		this.taskCode = taskCode;
	}
	public String getTaskStatus() {
		return taskStatus;
	}
	public void setTaskStatus(String taskStatus) {
		this.taskStatus = taskStatus;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
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
	
	
}
