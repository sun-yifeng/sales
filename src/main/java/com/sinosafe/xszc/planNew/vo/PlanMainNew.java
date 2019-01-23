package com.sinosafe.xszc.planNew.vo;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 类名:com.sinosafe.xszc.planNew.vo.PlanMainNew
 * 
 * <pre>
 * 描述:一个计划对应多个险种,一个险种对应多个渠道或业务线，每种业务线
 * 基本思路:
 * 特别说明:无
 * 编写者:卢水发
 * 创建时间:2015年6月2日 上午10:53:45
 * 修改说明:无修改说明
 * </pre>
 */
public class PlanMainNew implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

	private String planMainId;// 销售计划主键
	private String deptCode;// 机构代码
	private String planType;// 计划类型:1-销售保费，2-专属保费
	private Integer year;// 计划年度
	private String quarter;// 计划季度
	private double deptPremium;// 总保费
	private double deptUnderwritingPremium;// 本计划总保额
	private String planWriter;// 计划制定人
	private Timestamp planWriteDate;// 计划填写时间

	// 数据状态信息
	private String validInd;// 有效标示位,1-有效,0-失效
	private String status;// 状态，0-草稿，1-下发
	private String approveFlag;// 审核状态:审核标识，0-未审核，1-审核
	private String approveCode;// 审核人工号

	// 操作人信息
	private String createdUser;
	private Timestamp createdDate;
	private String updatedUser;
	private Timestamp updatedDate;

	private Set<PlanDetailNew> planDetailSet = new LinkedHashSet<PlanDetailNew>();
	private List<PlanDetailNew> planDetailList = new ArrayList<PlanDetailNew>();
	private List<Map<String, Object>> planDetailMapList = new ArrayList<Map<String, Object>>();
	private Set<Map<String, Object>> planDetailMapSet = new LinkedHashSet<Map<String, Object>>();

	public void setUpdatedUser(String updatedUser) {
		this.updatedUser = updatedUser;
	}

	public List<Map<String, Object>> getPlanDetailMapList() {
		return planDetailMapList;
	}

	public void setPlanDetailMapList(List<Map<String, Object>> planDetailMapList) {
		this.planDetailMapList = planDetailMapList;
	}

	public String getUpdatedUser() {
		return updatedUser;
	}

	public void setQuarter(String quarter) {
		this.quarter = quarter;
	}

	public String getQuarter() {
		return quarter;
	}

	public void setPlanWriteDate(Timestamp planWriteDate) {
		this.planWriteDate = planWriteDate;
	}

	public Timestamp getPlanWriteDate() {
		return planWriteDate;
	}

	public void setCreatedUser(String createdUser) {
		this.createdUser = createdUser;
	}

	public String getCreatedUser() {
		return createdUser;
	}

	public void setYear(Integer year) {
		this.year = year;
	}

	public Integer getYear() {
		return year;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setPlanType(String planType) {
		this.planType = planType;
	}

	public String getPlanType() {
		return planType;
	}

	public void setUpdatedDate(Timestamp updatedDate) {
		this.updatedDate = updatedDate;
	}

	public Timestamp getUpdatedDate() {
		return updatedDate;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStatus() {
		return status;
	}

	public void setDeptUnderwritingPremium(double deptUnderwritingPremium) {
		this.deptUnderwritingPremium = deptUnderwritingPremium;
	}

	public double getDeptUnderwritingPremium() {
		return deptUnderwritingPremium;
	}

	public void setPlanWriter(String planWriter) {
		this.planWriter = planWriter;
	}

	public String getPlanWriter() {
		return planWriter;
	}

	public void setValidInd(String validInd) {
		this.validInd = validInd;
	}

	public String getValidInd() {
		return validInd;
	}

	public void setDeptPremium(double deptPremium) {
		this.deptPremium = deptPremium;
	}

	public double getDeptPremium() {
		return deptPremium;
	}

	public void setCreatedDate(Timestamp createdDate) {
		this.createdDate = createdDate;
	}

	public Timestamp getCreatedDate() {
		return createdDate;
	}

	public void setPlanMainId(String planMainId) {
		this.planMainId = planMainId;
	}

	public String getPlanMainId() {
		return planMainId;
	}

	public Set<PlanDetailNew> getPlanDetailSet() {
		return planDetailSet;
	}

	public void setPlanDetailSet(Set<PlanDetailNew> planDetailSet) {
		this.planDetailSet = planDetailSet;
	}

	public Set<Map<String, Object>> getPlanDetailMapSet() {
		return planDetailMapSet;
	}

	public void setPlanDetailMapSet(Set<Map<String, Object>> planDetailMapSet) {
		this.planDetailMapSet = planDetailMapSet;
	}

	public String getApproveFlag() {
		return approveFlag;
	}

	public void setApproveFlag(String approveFlag) {
		this.approveFlag = approveFlag;
	}

	public String getApproveCode() {
		return approveCode;
	}

	public void setApproveCode(String approveCode) {
		this.approveCode = approveCode;
	}

	public List<PlanDetailNew> getPlanDetailList() {
		return planDetailList;
	}

	public void setPlanDetailList(List<PlanDetailNew> planDetailList) {
		this.planDetailList = planDetailList;
	}
}