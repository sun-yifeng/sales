package com.sinosafe.xszc.survey.vo;

import java.util.List;


public class MarketResInforMain implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private java.lang.String pkId;
	private java.sql.Timestamp updateDate;
	private java.lang.String agencyMeasuresCp;
	private java.lang.String sameIndusPremiumId;
	private java.lang.String agencyMeasuresChannel;
	private java.lang.String agencyMeasuresSism;
	private java.lang.String validInd;
	private java.lang.String agencyMeasuresSip;
	private java.lang.String createUser;
	private java.lang.String agencyInfluenceSip;
	private java.lang.String sameIndusTeleSales;
	private java.lang.String agencyInfluenceCp;
	private java.lang.String agencyInfluenceSism;
	private java.lang.String agencyInfluenceSd;
	private java.lang.String sameIndusServMeasures;
	private java.lang.String deptCode;
	private java.lang.String channelBank;
	private java.lang.String agencyInfluenceChannel;
	private java.lang.String insertMonth;
	private java.lang.String superviseDynamic;
	private java.lang.String channelPremiumId;
	private java.lang.String agencyInfluenceSits;
	private java.lang.String agencyMeasuresSits;
	private java.lang.String localMarketId;
	private java.sql.Timestamp createDate;
	private java.lang.String agencyMeasuresLm;
	private java.lang.String agencyInfluenceLm;
	private java.lang.String channelConventional;
	private java.lang.String channelVip;
	private java.lang.String updateUser;
	private java.lang.String agencyMeasuresSd;
	private java.lang.String others;
	private List<MarketResInforChannel>marketResInforChannel;
	private List<MarketResInforLocal>marketResInforLocal;
	private List<MarketResInforPremium>marketResInforPremium;
	
	public List<MarketResInforChannel> getMarketResInforChannel() {
		return marketResInforChannel;
	}

	public void setMarketResInforChannel(
			List<MarketResInforChannel> marketResInforChannel) {
		this.marketResInforChannel = marketResInforChannel;
	}

	public List<MarketResInforLocal> getMarketResInforLocal() {
		return marketResInforLocal;
	}

	public void setMarketResInforLocal(List<MarketResInforLocal> marketResInforLocal) {
		this.marketResInforLocal = marketResInforLocal;
	}

	public List<MarketResInforPremium> getMarketResInforPremium() {
		return marketResInforPremium;
	}

	public void setMarketResInforPremium(
			List<MarketResInforPremium> marketResInforPremium) {
		this.marketResInforPremium = marketResInforPremium;
	}

	public void setPkId ( java.lang.String pkId ) {
		this.pkId = pkId;
	}
	
	public java.lang.String getPkId (){
		return pkId;
	}
	
	public void setUpdateDate ( java.sql.Timestamp updateDate ) {
		this.updateDate = updateDate;
	}
	
	public java.sql.Timestamp getUpdateDate (){
		return updateDate;
	}
	
	public void setAgencyMeasuresCp ( java.lang.String agencyMeasuresCp ) {
		this.agencyMeasuresCp = agencyMeasuresCp;
	}
	
	public java.lang.String getAgencyMeasuresCp (){
		return agencyMeasuresCp;
	}
	
	public void setSameIndusPremiumId ( java.lang.String sameIndusPremiumId ) {
		this.sameIndusPremiumId = sameIndusPremiumId;
	}
	
	public java.lang.String getSameIndusPremiumId (){
		return sameIndusPremiumId;
	}
	
	public void setAgencyMeasuresChannel ( java.lang.String agencyMeasuresChannel ) {
		this.agencyMeasuresChannel = agencyMeasuresChannel;
	}
	
	public java.lang.String getAgencyMeasuresChannel (){
		return agencyMeasuresChannel;
	}
	
	public void setAgencyMeasuresSism ( java.lang.String agencyMeasuresSism ) {
		this.agencyMeasuresSism = agencyMeasuresSism;
	}
	
	public java.lang.String getAgencyMeasuresSism (){
		return agencyMeasuresSism;
	}
	
	public void setValidInd ( java.lang.String validInd ) {
		this.validInd = validInd;
	}
	
	public java.lang.String getValidInd (){
		return validInd;
	}
	
	public void setAgencyMeasuresSip ( java.lang.String agencyMeasuresSip ) {
		this.agencyMeasuresSip = agencyMeasuresSip;
	}
	
	public java.lang.String getAgencyMeasuresSip (){
		return agencyMeasuresSip;
	}
	
	public void setCreateUser ( java.lang.String createUser ) {
		this.createUser = createUser;
	}
	
	public java.lang.String getCreateUser (){
		return createUser;
	}
	
	public void setAgencyInfluenceSip ( java.lang.String agencyInfluenceSip ) {
		this.agencyInfluenceSip = agencyInfluenceSip;
	}
	
	public java.lang.String getAgencyInfluenceSip (){
		return agencyInfluenceSip;
	}
	
	public void setSameIndusTeleSales ( java.lang.String sameIndusTeleSales ) {
		this.sameIndusTeleSales = sameIndusTeleSales;
	}
	
	public java.lang.String getSameIndusTeleSales (){
		return sameIndusTeleSales;
	}
	
	public void setAgencyInfluenceCp ( java.lang.String agencyInfluenceCp ) {
		this.agencyInfluenceCp = agencyInfluenceCp;
	}
	
	public java.lang.String getAgencyInfluenceCp (){
		return agencyInfluenceCp;
	}
	
	public void setAgencyInfluenceSism ( java.lang.String agencyInfluenceSism ) {
		this.agencyInfluenceSism = agencyInfluenceSism;
	}
	
	public java.lang.String getAgencyInfluenceSism (){
		return agencyInfluenceSism;
	}
	
	public void setAgencyInfluenceSd ( java.lang.String agencyInfluenceSd ) {
		this.agencyInfluenceSd = agencyInfluenceSd;
	}
	
	public java.lang.String getAgencyInfluenceSd (){
		return agencyInfluenceSd;
	}
	
	public void setSameIndusServMeasures ( java.lang.String sameIndusServMeasures ) {
		this.sameIndusServMeasures = sameIndusServMeasures;
	}
	
	public java.lang.String getSameIndusServMeasures (){
		return sameIndusServMeasures;
	}
	
	public void setDeptCode ( java.lang.String deptCode ) {
		this.deptCode = deptCode;
	}
	
	public java.lang.String getDeptCode (){
		return deptCode;
	}
	
	public void setChannelBank ( java.lang.String channelBank ) {
		this.channelBank = channelBank;
	}
	
	public java.lang.String getChannelBank (){
		return channelBank;
	}
	
	public void setAgencyInfluenceChannel ( java.lang.String agencyInfluenceChannel ) {
		this.agencyInfluenceChannel = agencyInfluenceChannel;
	}
	
	public java.lang.String getAgencyInfluenceChannel (){
		return agencyInfluenceChannel;
	}
	
	public void setInsertMonth ( java.lang.String insertMonth ) {
		this.insertMonth = insertMonth;
	}
	
	public java.lang.String getInsertMonth (){
		return insertMonth;
	}
	
	public void setSuperviseDynamic ( java.lang.String superviseDynamic ) {
		this.superviseDynamic = superviseDynamic;
	}
	
	public java.lang.String getSuperviseDynamic (){
		return superviseDynamic;
	}
	
	public void setChannelPremiumId ( java.lang.String channelPremiumId ) {
		this.channelPremiumId = channelPremiumId;
	}
	
	public java.lang.String getChannelPremiumId (){
		return channelPremiumId;
	}
	
	public void setAgencyInfluenceSits ( java.lang.String agencyInfluenceSits ) {
		this.agencyInfluenceSits = agencyInfluenceSits;
	}
	
	public java.lang.String getAgencyInfluenceSits (){
		return agencyInfluenceSits;
	}
	
	public void setAgencyMeasuresSits ( java.lang.String agencyMeasuresSits ) {
		this.agencyMeasuresSits = agencyMeasuresSits;
	}
	
	public java.lang.String getAgencyMeasuresSits (){
		return agencyMeasuresSits;
	}
	
	public void setLocalMarketId ( java.lang.String localMarketId ) {
		this.localMarketId = localMarketId;
	}
	
	public java.lang.String getLocalMarketId (){
		return localMarketId;
	}
	
	public void setCreateDate ( java.sql.Timestamp createDate ) {
		this.createDate = createDate;
	}
	
	public java.sql.Timestamp getCreateDate (){
		return createDate;
	}
	
	public void setAgencyMeasuresLm ( java.lang.String agencyMeasuresLm ) {
		this.agencyMeasuresLm = agencyMeasuresLm;
	}
	
	public java.lang.String getAgencyMeasuresLm (){
		return agencyMeasuresLm;
	}
	
	public void setAgencyInfluenceLm ( java.lang.String agencyInfluenceLm ) {
		this.agencyInfluenceLm = agencyInfluenceLm;
	}
	
	public java.lang.String getAgencyInfluenceLm (){
		return agencyInfluenceLm;
	}
	
	public void setChannelConventional ( java.lang.String channelConventional ) {
		this.channelConventional = channelConventional;
	}
	
	public java.lang.String getChannelConventional (){
		return channelConventional;
	}
	
	public void setChannelVip ( java.lang.String channelVip ) {
		this.channelVip = channelVip;
	}
	
	public java.lang.String getChannelVip (){
		return channelVip;
	}
	
	public void setUpdateUser ( java.lang.String updateUser ) {
		this.updateUser = updateUser;
	}
	
	public java.lang.String getUpdateUser (){
		return updateUser;
	}
	
	public void setAgencyMeasuresSd ( java.lang.String agencyMeasuresSd ) {
		this.agencyMeasuresSd = agencyMeasuresSd;
	}
	
	public java.lang.String getAgencyMeasuresSd (){
		return agencyMeasuresSd;
	}
	
	public void setOthers ( java.lang.String others ) {
		this.others = others;
	}
	
	public java.lang.String getOthers (){
		return others;
	}
	

}