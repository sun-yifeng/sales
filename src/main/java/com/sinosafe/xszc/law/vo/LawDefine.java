package com.sinosafe.xszc.law.vo;

import java.sql.Timestamp;


/**
 * @author Administrator
 *
 */
public class LawDefine implements java.io.Serializable{

	private static final long serialVersionUID = 1L;

	private String updatedUser;
	private Timestamp createdDate;
	private String versionEname;
	private String fatherVersionCode;
	private String createdUser;
	private String defineMemo;
	private String versionId;
	private String versionCname;
	private String versionStatus;
	private Timestamp updatedDate;
	private String lawBgnDate;
	private String lawEndDate;
	private String validInd;
	private String deptCode;
	private String lineCode;
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getVersionStatus() {
		return versionStatus;
	}

	public void setVersionStatus(String versionStatus) {
		this.versionStatus = versionStatus;
	}

	public String getLineCode() {
		return lineCode;
	}

	public void setLineCode(String lineCode) {
		this.lineCode = lineCode;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String getLawBgnDate() {
		return lawBgnDate;
	}

	public void setLawBgnDate(String lawBgnDate) {
		this.lawBgnDate = lawBgnDate;
	}
	
	public String getLawEndDate() {
		return lawEndDate;
	}

	public void setLawEndDate(String lawEndDate) {
		this.lawEndDate = lawEndDate;
	}

	public void setUpdatedUser ( String updatedUser ) {
		this.updatedUser = updatedUser;
	}
	
	public String getUpdatedUser (){
		return updatedUser;
	}
	
	public void setCreatedDate ( Timestamp createdDate ) {
		this.createdDate = createdDate;
	}
	
	public Timestamp getCreatedDate (){
		return createdDate;
	}
	
	public void setVersionEname ( String versionEname ) {
		this.versionEname = versionEname;
	}
	
	public String getVersionEname (){
		return versionEname;
	}
	
	public void setFatherVersionCode ( String fatherVersionCode ) {
		this.fatherVersionCode = fatherVersionCode;
	}
	
	public String getFatherVersionCode (){
		return fatherVersionCode;
	}
	
	public void setCreatedUser ( String createdUser ) {
		this.createdUser = createdUser;
	}
	
	public String getCreatedUser (){
		return createdUser;
	}
	
	public void setDefineMemo ( String defineMemo ) {
		this.defineMemo = defineMemo;
	}
	
	public String getDefineMemo (){
		return defineMemo;
	}
	
	public void setVersionCname ( String versionCname ) {
		this.versionCname = versionCname;
	}
	
	public String getVersionCname (){
		return versionCname;
	}
	
	public void setUpdatedDate ( Timestamp updatedDate ) {
		this.updatedDate = updatedDate;
	}
	
	public Timestamp getUpdatedDate (){
		return updatedDate;
	}

	public String getValidInd() {
		return validInd;
	}

	public void setValidInd(String validInd) {
		this.validInd = validInd;
	}

	public String getVersionId() {
		return versionId;
	}

	public void setVersionId(String versionId) {
		this.versionId = versionId;
	}
}