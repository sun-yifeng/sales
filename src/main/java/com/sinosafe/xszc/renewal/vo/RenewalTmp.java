package com.sinosafe.xszc.renewal.vo;

public class RenewalTmp implements java.io.Serializable
{

	private static final long serialVersionUID = 1L;// SD.

	private java.lang.String pkId;    // 主键.
	private java.lang.String saleCode; //业务员
	private java.lang.String riskType; //险种

	private java.lang.String policyNo; //保单号
	private java.lang.String processStatus;
	
	
	private java.lang.String managerCode; 
	private java.lang.String alarmName;
	private java.lang.String failReason; // 续保失败原因
	private java.lang.String assingStatus;
	private java.lang.String dptCde;
	private java.lang.String agentStatus; // 1-有效、0-失效
	private java.lang.Integer impMonth;
	private java.lang.Double expire; //距离到期天数	
	private java.lang.Double premium; //保费
	private java.lang.String deptCode; //机构代码
	private java.lang.String recognizee; //被保险人
	private java.lang.Double riskTerm; // 出险次数
	private java.lang.String contactWay; //联系方式
	private java.lang.String contact; //联系人
	private java.lang.String checkCode; //出单员	
	private java.lang.String renewalStatus; //续保状态
	private java.lang.String supportCode; //协作人	
	private java.lang.String agentCode; //代理人
	private java.lang.String groupCode; //团队编码
	
	private java.lang.String vehicleNo; //车牌号  vehicleNo
	
	private java.lang.String createdUser;
	private java.lang.String updatedUser;

	private java.sql.Timestamp createdDate;
	private java.sql.Timestamp updatedDate;


	public void setPkId(java.lang.String pkId)
	{
		this.pkId = pkId;
	}

	public java.lang.String getPkId()
	{
		return pkId;
	}

	public void setCreatedUser(java.lang.String createdUser)
	{
		this.createdUser = createdUser;
	}

	public java.lang.String getCreatedUser()
	{
		return createdUser;
	}

	public void setSaleCode(java.lang.String saleCode)
	{
		this.saleCode = saleCode;
	}

	public java.lang.String getSaleCode()
	{
		return saleCode;
	}

	public void setRiskType(java.lang.String riskType)
	{
		this.riskType = riskType;
	}

	public java.lang.String getRiskType()
	{
		return riskType;
	}

	public void setUpdatedDate(java.sql.Timestamp updatedDate)
	{
		this.updatedDate = updatedDate;
	}

	public java.sql.Timestamp getUpdatedDate()
	{
		return updatedDate;
	}

	public void setAlarmName(java.lang.String alarmName)
	{
		this.alarmName = alarmName;
	}

	public java.lang.String getAlarmName()
	{
		return alarmName;
	}

	public void setFailReason(java.lang.String failReason)
	{
		this.failReason = failReason;
	}

	public java.lang.String getFailReason()
	{
		return failReason;
	}

	public void setCreatedDate(java.sql.Timestamp createdDate)
	{
		this.createdDate = createdDate;
	}

	public java.sql.Timestamp getCreatedDate()
	{
		return createdDate;
	}

	public void setAssingStatus(java.lang.String assingStatus)
	{
		this.assingStatus = assingStatus;
	}

	public java.lang.String getAssingStatus()
	{
		return assingStatus;
	}

	public void setDptCde(java.lang.String dptCde)
	{
		this.dptCde = dptCde;
	}

	public java.lang.String getDptCde()
	{
		return dptCde;
	}

	public void setAgentStatus(java.lang.String agentStatus)
	{
		this.agentStatus = agentStatus;
	}

	public java.lang.String getAgentStatus()
	{
		return agentStatus;
	}

	public void setImpMonth(java.lang.Integer impMonth)
	{
		this.impMonth = impMonth;
	}

	public java.lang.Integer getImpMonth()
	{
		return impMonth;
	}

	public void setUpdatedUser(java.lang.String updatedUser)
	{
		this.updatedUser = updatedUser;
	}

	public java.lang.String getUpdatedUser()
	{
		return updatedUser;
	}

	public void setExpire(java.lang.Double expire)
	{
		this.expire = expire;
	}

	public java.lang.Double getExpire()
	{
		return expire;
	}

	public void setManagerCode(java.lang.String managerCode)
	{
		this.managerCode = managerCode;
	}

	public java.lang.String getManagerCode()
	{
		return managerCode;
	}

	public void setPremium(java.lang.Double premium)
	{
		this.premium = premium;
	}

	public java.lang.Double getPremium()
	{
		return premium;
	}

	public void setDeptCode(java.lang.String deptCode)
	{
		this.deptCode = deptCode;
	}

	public java.lang.String getDeptCode()
	{
		return deptCode;
	}

	public void setVehicleNo(java.lang.String vehicleNo)
	{
		this.vehicleNo = vehicleNo;
	}

	public java.lang.String getVehicleNo()
	{
		return vehicleNo;
	}

	public void setRecognizee(java.lang.String recognizee)
	{
		this.recognizee = recognizee;
	}

	public java.lang.String getRecognizee()
	{
		return recognizee;
	}

	public void setRiskTerm(java.lang.Double riskTerm)
	{
		this.riskTerm = riskTerm;
	}

	public java.lang.Double getRiskTerm()
	{
		return riskTerm;
	}

	public void setContactWay(java.lang.String contactWay)
	{
		this.contactWay = contactWay;
	}

	public java.lang.String getContactWay()
	{
		return contactWay;
	}

	public void setContact(java.lang.String contact)
	{
		this.contact = contact;
	}

	public java.lang.String getContact()
	{
		return contact;
	}

	public void setCheckCode(java.lang.String checkCode)
	{
		this.checkCode = checkCode;
	}

	public java.lang.String getCheckCode()
	{
		return checkCode;
	}

	public void setPolicyNo(java.lang.String policyNo)
	{
		this.policyNo = policyNo;
	}

	public java.lang.String getPolicyNo()
	{
		return policyNo;
	}

	public void setProcessStatus(java.lang.String processStatus)
	{
		this.processStatus = processStatus;
	}

	public java.lang.String getProcessStatus()
	{
		return processStatus;
	}

	public void setRenewalStatus(java.lang.String renewalStatus)
	{
		this.renewalStatus = renewalStatus;
	}

	public java.lang.String getRenewalStatus()
	{
		return renewalStatus;
	}

	public void setSupportCode(java.lang.String supportCode)
	{
		this.supportCode = supportCode;
	}

	public java.lang.String getSupportCode()
	{
		return supportCode;
	}

	public void setAgentCode(java.lang.String agentCode)
	{
		this.agentCode = agentCode;
	}

	public java.lang.String getAgentCode()
	{
		return agentCode;
	}

	public void setGroupCode(java.lang.String groupCode)
	{
		this.groupCode = groupCode;
	}

	public java.lang.String getGroupCode()
	{
		return groupCode;
	}

}