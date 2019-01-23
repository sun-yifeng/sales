package com.sinosafe.xszc.renewal.vo;

public class RenewalLevel implements java.io.Serializable
{

	private static final long serialVersionUID = 1L;// 

	private java.lang.String renewallevelId;

	private java.lang.String deptCode; // 部门 

	private java.lang.String assignLevel; // 设置的下发层级,0-未下发,1-二级机构,2-三级机构,3-营业部,4-团队

	private java.lang.String validInd; // 有效标示位,1-有效,0-删除
	private java.lang.String createdUser;
	private java.lang.String updatedUser;
	private java.sql.Timestamp createdDate;
	private java.sql.Timestamp updatedDate;

	public java.lang.String getRenewallevelId()
	{
		return renewallevelId;
	}

	public void setRenewallevelId(java.lang.String renewallevelId)
	{
		this.renewallevelId = renewallevelId;
	}

	public java.lang.String getDeptCode()
	{
		return deptCode;
	}

	public void setDeptCode(java.lang.String deptCode)
	{
		this.deptCode = deptCode;
	}

	public java.lang.String getAssignLevel()
	{
		return assignLevel;
	}

	public void setAssignLevel(java.lang.String assignLevel)
	{
		this.assignLevel = assignLevel;
	}

	public java.lang.String getValidInd()
	{
		return validInd;
	}

	public void setValidInd(java.lang.String validInd)
	{
		this.validInd = validInd;
	}

	public java.lang.String getCreatedUser()
	{
		return createdUser;
	}

	public void setCreatedUser(java.lang.String createdUser)
	{
		this.createdUser = createdUser;
	}

	public java.lang.String getUpdatedUser()
	{
		return updatedUser;
	}

	public void setUpdatedUser(java.lang.String updatedUser)
	{
		this.updatedUser = updatedUser;
	}

	public java.sql.Timestamp getCreatedDate()
	{
		return createdDate;
	}

	public void setCreatedDate(java.sql.Timestamp createdDate)
	{
		this.createdDate = createdDate;
	}

	public java.sql.Timestamp getUpdatedDate()
	{
		return updatedDate;
	}

	public void setUpdatedDate(java.sql.Timestamp updatedDate)
	{
		this.updatedDate = updatedDate;
	}

}