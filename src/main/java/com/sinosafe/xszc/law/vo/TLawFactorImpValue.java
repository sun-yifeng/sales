package com.sinosafe.xszc.law.vo;


public class TLawFactorImpValue implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

	private String pkId;
	private String deptCode;
    private String calcMonth;
    private String versionId;
	
	private String impType;//导入类型，1代表个人经理导入  2代表团队导入
	private String indexCode;
	private String indexName;
	private double indexValue;
	
	private String salesmanCode;
	private String salesmanCname;
	private String groupName;
	
	private String groupCode;
	private String employCode;
	
	private String validInd;

	// 操作人信息
	private String createdUser;
	private String createdDate;
	private String updatedUser;
	private String updatedDate;
	
	public String getCalcMonth() {
		return calcMonth;
	}

	public void setCalcMonth(String calcMonth) {
		this.calcMonth = calcMonth;
	}

	public String getVersionId() {
		return versionId;
	}

	public void setVersionId(String versionId) {
		this.versionId = versionId;
	}

	public void setUpdatedUser(String updatedUser) {
		this.updatedUser = updatedUser;
	}

	public String getUpdatedUser() {
		return updatedUser;
	}

	public void setPkId(String pkId) {
		this.pkId = pkId;
	}

	public String getPkId() {
		return pkId;
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

	public void setUpdatedDate(String updatedDate) {
		this.updatedDate = updatedDate;
	}

	public String getUpdatedDate() {
		return updatedDate;
	}

	public void setSalesmanCname(String salesmanCname) {
		this.salesmanCname = salesmanCname;
	}

	public String getSalesmanCname() {
		return salesmanCname;
	}

	public void setValidInd(String validInd) {
		this.validInd = validInd;
	}

	public String getValidInd() {
		return validInd;
	}

	public void setIndexCode(String indexCode) {
		this.indexCode = indexCode;
	}

	public String getIndexCode() {
		return indexCode;
	}

	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}

	public String getCreatedDate() {
		return createdDate;
	}

	public double getIndexValue() {
		return indexValue;
	}

	public void setIndexValue(double indexValue) {
		this.indexValue = indexValue;
	}

	public void setImpType(String impType) {
		this.impType = impType;
	}

	public String getImpType() {
		return impType;
	}

	public void setSalesmanCode(String salesmanCode) {
		this.salesmanCode = salesmanCode;
	}

	public String getSalesmanCode() {
		return salesmanCode;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setIndexName(String indexName) {
		this.indexName = indexName;
	}

	public String getIndexName() {
		return indexName;
	}

	public void setGroupCode(String groupCode) {
		this.groupCode = groupCode;
	}

	public String getGroupCode() {
		return groupCode;
	}

	public void setEmployCode(String employCode) {
		this.employCode = employCode;
	}

	public String getEmployCode() {
		return employCode;
	}

}