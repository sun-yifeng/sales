package com.sinosafe.xszc.report.vo;


public class ReportDaySaleTrace implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String pkId;
	private java.lang.String reportDay;
	private java.lang.String deptCodeTwo;
	private java.lang.String deptNameTwo;
	private java.lang.String deptCodeThree;
	private java.lang.String deptNameThree;
	private java.lang.String deptCodeFour;
	private java.lang.String deptNameFour;
	// 险种业务
	private java.lang.String bizLine;
	private java.lang.String insureType;
	// 保费收入
	private java.lang.Double incomeThisDay;
	private java.lang.Double incomeThisMonth;
	private java.lang.Double incomeThisYear;
	private java.lang.Double incomeLastYear;
	// 签单保费
	private java.lang.Double signThisDay;
	private java.lang.Double signThisMonth;
	private java.lang.Double signThisYear;
	private java.lang.Double signLastYear;
	// 保费计划
	private java.lang.Double premiumPlan;
	private java.lang.Double premiumPlanRate;
	private java.lang.Double schedulePlanRate;
	private java.lang.Double termIncreaseRate;
	private java.lang.Double yearIncreaseRate;
	private java.lang.Double policyIncreaseRate;
	// 创建时间
	private java.lang.String createUser;
	private java.sql.Timestamp createDate;
	private java.sql.Timestamp updateDate;
	private java.lang.String updateUser;

	public void setSignThisDay ( java.lang.Double signThisDay ) {
		this.signThisDay = signThisDay;
	}
	
	public java.lang.Double getSignThisDay (){
		return signThisDay;
	}
	
	public void setReportDay ( java.lang.String reportDay ) {
		this.reportDay = reportDay;
	}
	
	public java.lang.String getReportDay (){
		return reportDay;
	}
	
	public void setPkId ( java.lang.String pkId ) {
		this.pkId = pkId;
	}
	
	public java.lang.String getPkId (){
		return pkId;
	}
	
	public void setSignLastYear ( java.lang.Double signLastYear ) {
		this.signLastYear = signLastYear;
	}
	
	public java.lang.Double getSignLastYear (){
		return signLastYear;
	}
	
	public void setUpdateDate ( java.sql.Timestamp updateDate ) {
		this.updateDate = updateDate;
	}
	
	public java.sql.Timestamp getUpdateDate (){
		return updateDate;
	}
	
	public void setTermIncreaseRate ( java.lang.Double termIncreaseRate ) {
		this.termIncreaseRate = termIncreaseRate;
	}
	
	public java.lang.Double getTermIncreaseRate (){
		return termIncreaseRate;
	}
	
	public void setPolicyIncreaseRate ( java.lang.Double policyIncreaseRate ) {
		this.policyIncreaseRate = policyIncreaseRate;
	}
	
	public java.lang.Double getPolicyIncreaseRate (){
		return policyIncreaseRate;
	}
	
	public void setDeptCodeFour ( java.lang.String deptCodeFour ) {
		this.deptCodeFour = deptCodeFour;
	}
	
	public java.lang.String getDeptCodeFour (){
		return deptCodeFour;
	}
	
	public void setSignThisYear ( java.lang.Double signThisYear ) {
		this.signThisYear = signThisYear;
	}
	
	public java.lang.Double getSignThisYear (){
		return signThisYear;
	}
	
	public void setIncomeThisMonth ( java.lang.Double incomeThisMonth ) {
		this.incomeThisMonth = incomeThisMonth;
	}
	
	public java.lang.Double getIncomeThisMonth (){
		return incomeThisMonth;
	}
	
	public void setCreateUser ( java.lang.String createUser ) {
		this.createUser = createUser;
	}
	
	public java.lang.String getCreateUser (){
		return createUser;
	}
	
	public void setInsureType ( java.lang.String insureType ) {
		this.insureType = insureType;
	}
	
	public java.lang.String getInsureType (){
		return insureType;
	}
	
	public void setDeptCodeTwo ( java.lang.String deptCodeTwo ) {
		this.deptCodeTwo = deptCodeTwo;
	}
	
	public java.lang.String getDeptCodeTwo (){
		return deptCodeTwo;
	}
	
	public void setIncomeThisYear ( java.lang.Double incomeThisYear ) {
		this.incomeThisYear = incomeThisYear;
	}
	
	public java.lang.Double getIncomeThisYear (){
		return incomeThisYear;
	}
	
	public void setIncomeThisDay ( java.lang.Double incomeThisDay ) {
		this.incomeThisDay = incomeThisDay;
	}
	
	public java.lang.Double getIncomeThisDay (){
		return incomeThisDay;
	}
	
	public void setIncomeLastYear ( java.lang.Double incomeLastYear ) {
		this.incomeLastYear = incomeLastYear;
	}
	
	public java.lang.Double getIncomeLastYear (){
		return incomeLastYear;
	}
	
	public void setPremiumPlanRate ( java.lang.Double premiumPlanRate ) {
		this.premiumPlanRate = premiumPlanRate;
	}
	
	public java.lang.Double getPremiumPlanRate (){
		return premiumPlanRate;
	}
	
	public void setYearIncreaseRate ( java.lang.Double yearIncreaseRate ) {
		this.yearIncreaseRate = yearIncreaseRate;
	}
	
	public java.lang.Double getYearIncreaseRate (){
		return yearIncreaseRate;
	}
	
	public void setBizLine ( java.lang.String bizLine ) {
		this.bizLine = bizLine;
	}
	
	public java.lang.String getBizLine (){
		return bizLine;
	}
	
	public void setSchedulePlanRate ( java.lang.Double schedulePlanRate ) {
		this.schedulePlanRate = schedulePlanRate;
	}
	
	public java.lang.Double getSchedulePlanRate (){
		return schedulePlanRate;
	}
	
	public void setDeptNameThree ( java.lang.String deptNameThree ) {
		this.deptNameThree = deptNameThree;
	}
	
	public java.lang.String getDeptNameThree (){
		return deptNameThree;
	}
	
	public void setDeptNameTwo ( java.lang.String deptNameTwo ) {
		this.deptNameTwo = deptNameTwo;
	}
	
	public java.lang.String getDeptNameTwo (){
		return deptNameTwo;
	}
	
	public void setSignThisMonth ( java.lang.Double signThisMonth ) {
		this.signThisMonth = signThisMonth;
	}
	
	public java.lang.Double getSignThisMonth (){
		return signThisMonth;
	}
	
	public void setDeptCodeThree ( java.lang.String deptCodeThree ) {
		this.deptCodeThree = deptCodeThree;
	}
	
	public java.lang.String getDeptCodeThree (){
		return deptCodeThree;
	}
	
	public void setPremiumPlan ( java.lang.Double premiumPlan ) {
		this.premiumPlan = premiumPlan;
	}
	
	public java.lang.Double getPremiumPlan (){
		return premiumPlan;
	}
	
	public void setDeptNameFour ( java.lang.String deptNameFour ) {
		this.deptNameFour = deptNameFour;
	}
	
	public java.lang.String getDeptNameFour (){
		return deptNameFour;
	}
	
	public void setCreateDate ( java.sql.Timestamp createDate ) {
		this.createDate = createDate;
	}
	
	public java.sql.Timestamp getCreateDate (){
		return createDate;
	}
	
	public void setUpdateUser ( java.lang.String updateUser ) {
		this.updateUser = updateUser;
	}
	
	public java.lang.String getUpdateUser (){
		return updateUser;
	}
	

}