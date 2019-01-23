package com.sinosafe.xszc.group.vo;


public class SalesmanVirtual implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String birthday;
	private java.lang.String virtualId;
	private java.lang.String createdUser;
	private java.lang.String deptCode;
	private java.lang.String updatedDate;
	private java.lang.String cname;
	private java.lang.String validInd;
	private java.lang.String createdDate;
	private java.lang.String salesmanCode;
	private java.lang.String certiryNo;
	private java.lang.String enterDate;
	private java.lang.String virtualSalesmanCode;
	private java.lang.String ename;
	private java.lang.String employCode;
	private java.lang.String endDate;
	private java.lang.String salesmanType;
	private java.lang.String salesmanCname;
	private java.lang.String historyId;
	
	public java.lang.String getHistoryId() {
		return historyId;
	}

	public void setHistoryId(java.lang.String historyId) {
		this.historyId = historyId;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public java.lang.String getSalesmanCname() {
		return salesmanCname;
	}

	public void setSalesmanCname(java.lang.String salesmanCname) {
		this.salesmanCname = salesmanCname;
	}

	public java.lang.String getSalesmanType() {
		return salesmanType;
	}

	public void setSalesmanType(java.lang.String salesmanType) {
		this.salesmanType = salesmanType;
	}

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public java.lang.String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setVirtualId ( java.lang.String virtualId ) {
		this.virtualId = virtualId;
	}
	
	public java.lang.String getVirtualId (){
		return virtualId;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setDeptCode ( java.lang.String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public java.lang.String getDeptCode (){
		return deptCode;
	}
	
	public void setCname ( java.lang.String cname ) {
		this.cname = cname;
	}
	
	public java.lang.String getCname (){
		return cname;
	}
	
	public void setValidInd ( java.lang.String validInd ) {
		this.validInd = validInd;
	}
	
	public java.lang.String getValidInd (){
		return validInd;
	}
	
	public void setSalesmanCode ( java.lang.String salesmanCode ) {
		this.salesmanCode = salesmanCode;
	}
	
	public java.lang.String getSalesmanCode (){
		return salesmanCode;
	}
	
	public void setCertiryNo ( java.lang.String certiryNo ) {
		this.certiryNo = certiryNo;
	}
	
	public java.lang.String getCertiryNo (){
		return certiryNo;
	}
	
	public java.lang.String getBirthday() {
		return birthday;
	}

	public void setBirthday(java.lang.String birthday) {
		this.birthday = birthday;
	}

	public java.lang.String getEnterDate() {
		return enterDate;
	}

	public void setEnterDate(java.lang.String enterDate) {
		this.enterDate = enterDate;
	}

	public void setVirtualSalesmanCode ( java.lang.String virtualSalesmanCode ) {
		this.virtualSalesmanCode = virtualSalesmanCode;
	}
	
	public java.lang.String getVirtualSalesmanCode (){
		return virtualSalesmanCode;
	}
	
	public void setEname ( java.lang.String ename ) {
		this.ename = ename;
	}
	
	public java.lang.String getEname (){
		return ename;
	}

	public java.lang.String getEndDate() {
		return endDate;
	}

	public void setEndDate(java.lang.String endDate) {
		this.endDate = endDate;
	}

	public java.lang.String getEmployCode() {
		return employCode;
	}

	public void setEmployCode(java.lang.String employCode) {
		this.employCode = employCode;
	}

	public java.lang.String getUpdatedDate() {
		return updatedDate;
	}

	public void setUpdatedDate(java.lang.String updatedDate) {
		this.updatedDate = updatedDate;
	}

	public java.lang.String getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(java.lang.String createdDate) {
		this.createdDate = createdDate;
	}
	
	
	@Override
	public boolean equals(Object obj) {
		SalesmanVirtual o=(SalesmanVirtual)obj;
		if(this.salesmanCname != o.getSalesmanCname()){
			return false;
		}
		if(!this.salesmanCname.equals(o.getSalesmanCname())){
			return false;
		}
		
		
		
		
		return true;
	}
	
}