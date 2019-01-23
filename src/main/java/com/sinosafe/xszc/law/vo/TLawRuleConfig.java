package com.sinosafe.xszc.law.vo;


public class TLawRuleConfig implements java.io.Serializable{
	private static final long serialVersionUID = 1L;
	
	private java.lang.String versionId;
	
	private String validInd;
	
	private String salaryCalPinDu;//定薪计算频度
	private String levelCalPindu;//定级计算频度
	private String clientManagerKaoHe;//团队长按照客户经理考核
	private java.sql.Timestamp workingAgeCalBegin;//司龄工资计算起期
	private Double salesDirectorBuTie;//销售总监补贴金额
	private Double tmpEmploySalaryRate;//试用期员工固定工资系数
	private String isWorkingAge;//是否配置司龄工资
	private String isArea;//地域标识
	private String passCountMonth;//通算结果应用月份
	
	//暂未使用
	private String configName;
	private String configValue;
	
	//基本法保存按钮开关
	private String salesSysSwitch;
	private String salesImpSwitch;
	private String salesCheckSwitch;
	private String salesExpSwitch;
	private String salesRegSwitch;
	private String groupSysSwitch;
	private String groupImpSwitch;
	private String groupCheckSwitch;
	private String groupExpSwitch;
	private String groupRegSwitch;
	private String insuranceSwitch;
	private String motorSwitch;
	private String channelSwitch;
	private String businessSwitch;
	private String areaSwitch;
	
	// 操作人信息
	private String createdUser;
	private String createdDate;
	private String updatedUser;
	private String updatedDate;
	
	public String getSalesSysSwitch() {
		return salesSysSwitch;
	}
	public void setSalesSysSwitch(String salesSysSwitch) {
		this.salesSysSwitch = salesSysSwitch;
	}
	public String getSalesImpSwitch() {
		return salesImpSwitch;
	}
	public void setSalesImpSwitch(String salesImpSwitch) {
		this.salesImpSwitch = salesImpSwitch;
	}
	public String getSalesCheckSwitch() {
		return salesCheckSwitch;
	}
	public void setSalesCheckSwitch(String salesCheckSwitch) {
		this.salesCheckSwitch = salesCheckSwitch;
	}
	public String getSalesExpSwitch() {
		return salesExpSwitch;
	}
	public void setSalesExpSwitch(String salesExpSwitch) {
		this.salesExpSwitch = salesExpSwitch;
	}
	public String getSalesRegSwitch() {
		return salesRegSwitch;
	}
	public void setSalesRegSwitch(String salesRegSwitch) {
		this.salesRegSwitch = salesRegSwitch;
	}
	public String getGroupSysSwitch() {
		return groupSysSwitch;
	}
	public void setGroupSysSwitch(String groupSysSwitch) {
		this.groupSysSwitch = groupSysSwitch;
	}
	public String getGroupImpSwitch() {
		return groupImpSwitch;
	}
	public void setGroupImpSwitch(String groupImpSwitch) {
		this.groupImpSwitch = groupImpSwitch;
	}
	public String getGroupCheckSwitch() {
		return groupCheckSwitch;
	}
	public void setGroupCheckSwitch(String groupCheckSwitch) {
		this.groupCheckSwitch = groupCheckSwitch;
	}
	public String getGroupExpSwitch() {
		return groupExpSwitch;
	}
	public void setGroupExpSwitch(String groupExpSwitch) {
		this.groupExpSwitch = groupExpSwitch;
	}
	public String getGroupRegSwitch() {
		return groupRegSwitch;
	}
	public void setGroupRegSwitch(String groupRegSwitch) {
		this.groupRegSwitch = groupRegSwitch;
	}
	public String getInsuranceSwitch() {
		return insuranceSwitch;
	}
	public void setInsuranceSwitch(String insuranceSwitch) {
		this.insuranceSwitch = insuranceSwitch;
	}
	public String getMotorSwitch() {
		return motorSwitch;
	}
	public void setMotorSwitch(String motorSwitch) {
		this.motorSwitch = motorSwitch;
	}
	public String getChannelSwitch() {
		return channelSwitch;
	}
	public void setChannelSwitch(String channelSwitch) {
		this.channelSwitch = channelSwitch;
	}
	public String getBusinessSwitch() {
		return businessSwitch;
	}
	public void setBusinessSwitch(String businessSwitch) {
		this.businessSwitch = businessSwitch;
	}
	public String getAreaSwitch() {
		return areaSwitch;
	}
	public void setAreaSwitch(String areaSwitch) {
		this.areaSwitch = areaSwitch;
	}
	public String getPassCountMonth() {
		return passCountMonth;
	}
	public void setPassCountMonth(String passCountMonth) {
		this.passCountMonth = passCountMonth;
	}
	public String getIsArea() {
		return isArea;
	}
	public void setIsArea(String isArea) {
		this.isArea = isArea;
	}
	public String getIsWorkingAge() {
		return isWorkingAge;
	}
	public void setIsWorkingAge(String isWorkingAge) {
		this.isWorkingAge = isWorkingAge;
	}
	public Double getTmpEmploySalaryRate() {
		return tmpEmploySalaryRate;
	}
	public void setTmpEmploySalaryRate(Double tmpEmploySalaryRate) {
		this.tmpEmploySalaryRate = tmpEmploySalaryRate;
	}
	public java.lang.String getVersionId() {
		return versionId;
	}
	public void setVersionId(java.lang.String versionId) {
		this.versionId = versionId;
	}
	public String getValidInd() {
		return validInd;
	}
	public void setValidInd(String validInd) {
		this.validInd = validInd;
	}
	public String getSalaryCalPinDu() {
		return salaryCalPinDu;
	}
	public void setSalaryCalPinDu(String salaryCalPinDu) {
		this.salaryCalPinDu = salaryCalPinDu;
	}
	public String getLevelCalPindu() {
		return levelCalPindu;
	}
	public void setLevelCalPindu(String levelCalPindu) {
		this.levelCalPindu = levelCalPindu;
	}
	public String getClientManagerKaoHe() {
		return clientManagerKaoHe;
	}
	public void setClientManagerKaoHe(String clientManagerKaoHe) {
		this.clientManagerKaoHe = clientManagerKaoHe;
	}
	public java.sql.Timestamp getWorkingAgeCalBegin() {
		return workingAgeCalBegin;
	}
	public void setWorkingAgeCalBegin(java.sql.Timestamp workingAgeCalBegin) {
		this.workingAgeCalBegin = workingAgeCalBegin;
	}
	public Double getSalesDirectorBuTie() {
		return salesDirectorBuTie;
	}
	public void setSalesDirectorBuTie(Double salesDirectorBuTie) {
		this.salesDirectorBuTie = salesDirectorBuTie;
	}
	public String getConfigName() {
		return configName;
	}
	public void setConfigName(String configName) {
		this.configName = configName;
	}
	public String getConfigValue() {
		return configValue;
	}
	public void setConfigValue(String configValue) {
		this.configValue = configValue;
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
