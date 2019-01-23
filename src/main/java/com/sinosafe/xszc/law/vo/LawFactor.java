package com.sinosafe.xszc.law.vo;


public class LawFactor implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String dataUnit;
	private java.lang.String channelId;
	private java.lang.String funcName;
	private java.lang.String itemName;
	private java.lang.String lastOpt;
	private java.lang.String orderNo;
	private java.lang.String itemCode;
	private java.lang.String itemNote;
	private java.sql.Timestamp optDate;
	private java.lang.String serno;
	private java.lang.String dataType;
	private java.lang.String validInd;
	private java.lang.String deptCode;
	private java.lang.String lineCode;

	public java.lang.String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(java.lang.String deptCode) {
		this.deptCode = deptCode;
	}

	public java.lang.String getLineCode() {
		return lineCode;
	}

	public void setLineCode(java.lang.String lineCode) {
		this.lineCode = lineCode;
	}

	public void setDataUnit ( java.lang.String dataUnit ) {
		this.dataUnit = dataUnit;
	}
	
	public java.lang.String getDataUnit (){
		return dataUnit;
	}
	
	public void setChannelId ( java.lang.String channelId ) {
		this.channelId = channelId;
	}
	
	public java.lang.String getChannelId (){
		return channelId;
	}
	
	public void setFuncName ( java.lang.String funcName ) {
		this.funcName = funcName;
	}
	
	public java.lang.String getFuncName (){
		return funcName;
	}
	
	public void setItemName ( java.lang.String itemName ) {
		this.itemName = itemName;
	}
	
	public java.lang.String getItemName (){
		return itemName;
	}
	
	public void setLastOpt ( java.lang.String lastOpt ) {
		this.lastOpt = lastOpt;
	}
	
	public java.lang.String getLastOpt (){
		return lastOpt;
	}
	
	public void setOrderNo ( java.lang.String orderNo ) {
		this.orderNo = orderNo;
	}
	
	public java.lang.String getOrderNo (){
		return orderNo;
	}
	
	public void setItemCode ( java.lang.String itemCode ) {
		this.itemCode = itemCode;
	}
	
	public java.lang.String getItemCode (){
		return itemCode;
	}
	
	public void setItemNote ( java.lang.String itemNote ) {
		this.itemNote = itemNote;
	}
	
	public java.lang.String getItemNote (){
		return itemNote;
	}
	
	public void setOptDate ( java.sql.Timestamp optDate ) {
		this.optDate = optDate;
	}
	
	public java.sql.Timestamp getOptDate (){
		return optDate;
	}
	
	public void setSerno ( java.lang.String serno ) {
		this.serno = serno;
	}
	
	public java.lang.String getSerno (){
		return serno;
	}
	
	public void setDataType ( java.lang.String dataType ) {
		this.dataType = dataType;
	}
	
	public java.lang.String getDataType (){
		return dataType;
	}

	public java.lang.String getValidInd() {
		return validInd;
	}

	public void setValidInd(java.lang.String validInd) {
		this.validInd = validInd;
	}

}