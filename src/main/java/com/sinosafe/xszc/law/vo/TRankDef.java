package com.sinosafe.xszc.law.vo;


public class TRankDef implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String pkId;
	private java.lang.String validInd;
	private java.lang.String channelId;
	private java.lang.String versionCode;
	private java.lang.String lastOpt;
	private java.lang.String deptCode;
	private java.lang.String rankNote;
	private java.lang.String rankName;
	private java.lang.String rankCode;
	private java.sql.Timestamp optDate;
	private java.lang.Double normPremium;
	private java.lang.Double baseSalary;	//月度固定工资
	private java.lang.Double caclSalary;	//	月度绩效工资
	private java.lang.Double baseTotal;	//月度固定工资总额
	private java.lang.Double baseRate;		//月度绩效工资总额计提标准
	private java.lang.String mapRank;
	private java.lang.String auditFlag;
	private java.lang.String lineCode;
	private java.lang.String managerFlag;

	public java.lang.String getPkId() {
		return pkId;
	}

	public void setPkId(java.lang.String pkId) {
		this.pkId = pkId;
	}

	public java.lang.String getLineCode() {
		return lineCode;
	}

	public void setLineCode(java.lang.String lineCode) {
		this.lineCode = lineCode;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public void setValidInd ( java.lang.String validInd ) {
		this.validInd = validInd;
	}
	
	public java.lang.String getValidInd (){
		return validInd;
	}
	
	public void setChannelId ( java.lang.String channelId ) {
		this.channelId = channelId;
	}
	
	public java.lang.String getChannelId (){
		return channelId;
	}
	
	public void setVersionCode ( java.lang.String versionCode ) {
		this.versionCode = versionCode;
	}
	
	public java.lang.String getVersionCode (){
		return versionCode;
	}
	
	public void setLastOpt ( java.lang.String lastOpt ) {
		this.lastOpt = lastOpt;
	}
	
	public java.lang.String getLastOpt (){
		return lastOpt;
	}
	
	public void setDeptCode ( java.lang.String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public java.lang.String getDeptCode (){
		return deptCode;
	}
	
	public void setRankNote ( java.lang.String rankNote ) {
		this.rankNote = rankNote;
	}
	
	public java.lang.String getRankNote (){
		return rankNote;
	}
	
	public void setRankName ( java.lang.String rankName ) {
		this.rankName = rankName;
	}
	
	public java.lang.String getRankName (){
		return rankName;
	}
	
	public void setRankCode ( java.lang.String rankCode ) {
		this.rankCode = rankCode;
	}
	
	public java.lang.String getRankCode (){
		return rankCode;
	}
	
	public void setOptDate ( java.sql.Timestamp optDate ) {
		this.optDate = optDate;
	}
	
	public java.sql.Timestamp getOptDate (){
		return optDate;
	}

	public java.lang.String getManagerFlag() {
		return managerFlag;
	}

	public void setManagerFlag(java.lang.String managerFlag) {
		this.managerFlag = managerFlag;
	}

	public java.lang.Double getNormPremium() {
		return normPremium;
	}

	public void setNormPremium(java.lang.Double normPremium) {
		this.normPremium = normPremium;
	}

	public java.lang.Double getBaseSalary() {
		return baseSalary;
	}

	public void setBaseSalary(java.lang.Double baseSalary) {
		this.baseSalary = baseSalary;
	}

	public java.lang.Double getCaclSalary() {
		return caclSalary;
	}

	public void setCaclSalary(java.lang.Double caclSalary) {
		this.caclSalary = caclSalary;
	}

	public java.lang.Double getBaseTotal() {
		return baseTotal;
	}

	public void setBaseTotal(java.lang.Double baseTotal) {
		this.baseTotal = baseTotal;
	}

	public java.lang.Double getBaseRate() {
		return baseRate;
	}

	public void setBaseRate(java.lang.Double baseRate) {
		this.baseRate = baseRate;
	}
	
	public java.lang.String getMapRank() {
		return mapRank;
	}

	public void setMapRank(java.lang.String mapRank) {
		this.mapRank = mapRank;
	}

	public java.lang.String getAuditFlag() {
		return auditFlag;
	}

	public void setAuditFlag(java.lang.String auditFlag) {
		this.auditFlag = auditFlag;
	}

}