package com.sinosafe.xszc.channel.vo;

import java.util.HashSet;
import java.util.Set;


public class ChannelMediumNode implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String updatedUser;
	private java.lang.String remote;
	private java.lang.Double targetPremium;
	private java.lang.String name;
	private java.lang.String channelPartnerType;
	private java.lang.String createdUser;
	private java.lang.String channelCode;
	private java.lang.String address;
	private java.lang.String deptCode;
	private java.lang.String nodeCode;
	private java.sql.Timestamp updatedDate;
	private java.lang.String account;
	private java.lang.String contact;
	private java.lang.String phone;
	private java.lang.String validInd;
	private java.sql.Timestamp createdDate;
	private java.lang.String mobile;
	private java.lang.String email;
	private java.lang.String nodeName;
	private java.lang.String vpnNo;
	private java.lang.String getFlag;
	private java.lang.String closeFlag;
	private java.lang.String closeDate;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	private Set<ChannelMediumMaintain> channelMediumMaintain = new HashSet<ChannelMediumMaintain>();

	private Set<ChannelMediumNodeAccount> channelMediumNodeAccount = new HashSet<ChannelMediumNodeAccount>();
	
	public Set<ChannelMediumMaintain> getChannelMediumMaintain() {
		return channelMediumMaintain;
	}
	
	public java.lang.String getCloseDate() {
		return closeDate;
	}

	public void setCloseDate(java.lang.String closeDate) {
		this.closeDate = closeDate;
	}


	public java.lang.String getCloseFlag() {
		return closeFlag;
	}

	public void setCloseFlag(java.lang.String closeFlag) {
		this.closeFlag = closeFlag;
	}

	public void setChannelMediumMaintain(
			Set<ChannelMediumMaintain> channelMediumMaintain) {
		this.channelMediumMaintain = channelMediumMaintain;
	}
	
	public Set<ChannelMediumNodeAccount> getChannelMediumNodeAccount() {
		return channelMediumNodeAccount;
	}
	
	public void setChannelMediumNodeAccount(
			Set<ChannelMediumNodeAccount> channelMediumNodeAccount) {
		this.channelMediumNodeAccount = channelMediumNodeAccount;
	}

	public void setUpdatedUser ( java.lang.String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public java.lang.String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setRemote ( java.lang.String remote ) {
		this.remote = remote;
	}
	
	public java.lang.String getRemote (){
		return remote;
	}
	
	public void setTargetPremium ( java.lang.Double targetPremium ) {
		this.targetPremium = targetPremium;
	}
	
	public java.lang.Double getTargetPremium (){
		return targetPremium;
	}
	
	public void setName ( java.lang.String name ) {
		this.name = name;
	}
	
	public java.lang.String getName (){
		return name;
	}
	
	public void setChannelPartnerType ( java.lang.String channelPartnerType ) {
		this.channelPartnerType = channelPartnerType;
	}
	
	public java.lang.String getChannelPartnerType (){
		return channelPartnerType;
	}
	
	public void setCreatedUser ( java.lang.String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public java.lang.String getCreatedUser (){
		return createdUser;
	}
	
	public void setChannelCode ( java.lang.String channelCode ) {
		this.channelCode = channelCode;
	}
	
	public java.lang.String getChannelCode (){
		return channelCode;
	}
	
	public void setAddress ( java.lang.String address ) {
		this.address = address;
	}
	
	public java.lang.String getAddress (){
		return address;
	}
	
	public void setDeptCode ( java.lang.String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public java.lang.String getDeptCode (){
		return deptCode;
	}
	
	public void setNodeCode ( java.lang.String nodeCode ) {
		this.nodeCode = nodeCode;
	}
	
	public java.lang.String getNodeCode (){
		return nodeCode;
	}
	
	public void setUpdatedDate ( java.sql.Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public java.sql.Timestamp getUpdatedDate (){
		return updatedDate;
	}
	
	public void setAccount ( java.lang.String account ) {
		this.account = account;
	}
	
	public java.lang.String getAccount (){
		return account;
	}
	
	public void setContact ( java.lang.String contact ) {
		this.contact = contact;
	}
	
	public java.lang.String getContact (){
		return contact;
	}
	
	public void setPhone ( java.lang.String phone ) {
		this.phone = phone;
	}
	
	public java.lang.String getPhone (){
		return phone;
	}
	
	public void setValidInd ( java.lang.String validInd ) {
		this.validInd = validInd;
	}
	
	public java.lang.String getValidInd (){
		return validInd;
	}
	
	public void setCreatedDate ( java.sql.Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public java.sql.Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setMobile ( java.lang.String mobile ) {
		this.mobile = mobile;
	}
	
	public java.lang.String getMobile (){
		return mobile;
	}
	
	public void setEmail ( java.lang.String email ) {
		this.email = email;
	}
	
	public java.lang.String getEmail (){
		return email;
	}
	
	public void setNodeName ( java.lang.String nodeName ) {
		this.nodeName = nodeName;
	}
	
	public java.lang.String getNodeName (){
		return nodeName;
	}
	
	public void setVpnNo ( java.lang.String vpnNo ) {
		this.vpnNo = vpnNo;
	}
	
	public java.lang.String getVpnNo (){
		return vpnNo;
	}

	public java.lang.String getGetFlag() {
		return getFlag;
	}

	public void setGetFlag(java.lang.String getFlag) {
		this.getFlag = getFlag;
	}
	

}