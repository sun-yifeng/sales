package com.sinosafe.xszc.main.vo;

/**
 * 类名:com.sinosafe.xszc.main.vo.UserAccessRecord
 * 
 * <pre>
 * 描述:用户访问记录
 * 基本思路:
 * 特别说明:无
 * 编写者:卢水发
 * 创建时间:2015年7月21日 上午11:02:05
 * 修改说明:无修改说明
 * </pre>
 */
public class UserAccessRecord implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

	private String pkId;
	private String actionDate;
	private String userCode;
	private String userRealName;
	private String modelClass;
	private String modelClassCode;
	private String modelChildClassCode;
	private String modelChildClass;
	private String actionLabel;
	private String actionUrl;
	private String actionIp;
	private String accessType;
	private String deptCode;
	private String lineCode;
	private String validInd;

	public String getPkId() {
		return pkId;
	}

	public void setPkId(String pkId) {
		this.pkId = pkId;
	}

	public String getActionDate() {
		return actionDate;
	}

	public void setActionDate(String actionDate) {
		this.actionDate = actionDate;
	}

	public String getUserCode() {
		return userCode;
	}

	public void setUserCode(String userCode) {
		this.userCode = userCode;
	}

	public String getModelClass() {
		return modelClass;
	}

	public void setModelClass(String modelClass) {
		this.modelClass = modelClass;
	}

	public String getModelClassCode() {
		return modelClassCode;
	}

	public void setModelClassCode(String modelClassCode) {
		this.modelClassCode = modelClassCode;
	}

	public String getModelChildClassCode() {
		return modelChildClassCode;
	}

	public void setModelChildClassCode(String modelChildClassCode) {
		this.modelChildClassCode = modelChildClassCode;
	}

	public String getModelChildClass() {
		return modelChildClass;
	}

	public void setModelChildClass(String modelChildClass) {
		this.modelChildClass = modelChildClass;
	}

	public String getActionLabel() {
		return actionLabel;
	}

	public void setActionLabel(String actionLabel) {
		this.actionLabel = actionLabel;
	}

	public String getActionUrl() {
		return actionUrl;
	}

	public void setActionUrl(String actionUrl) {
		this.actionUrl = actionUrl;
	}

	public String getActionIp() {
		return actionIp;
	}

	public void setActionIp(String actionIp) {
		this.actionIp = actionIp;
	}

	public String getAccessType() {
		return accessType;
	}

	public void setAccessType(String accessType) {
		this.accessType = accessType;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String getLineCode() {
		return lineCode;
	}

	public void setLineCode(String lineCode) {
		this.lineCode = lineCode;
	}

	public String getValidInd() {
		return validInd;
	}

	public void setValidInd(String validInd) {
		this.validInd = validInd;
	}

	public String getUserRealName() {
		return userRealName;
	}

	public void setUserRealName(String userRealName) {
		this.userRealName = userRealName;
	}
}