package com.sinosafe.xszc.law.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.law.vo.LawDefineDept;
import com.sinosafe.xszc.util.PageDto;

public interface LawSpecifyService {

	public PageDto findLawSpecifyByWhere(PageDto pageDto);

	public void saveLawSpecify(LawDefineDept lawDefineDept);

	public List<Map<String, Object>> queryLawSpecifyToUpdate(String pkUuid);

	public void deleteLawSpecify(String pkUuid);

	public void updateLawSpecifyNotValid(String deptCode);

	public void updateLawSpecifyIsValid(String pkUuid);

	public List<Map<String, Object>> queryLawDefineDeptToUpdate(String versionCode);

	public void deleteLawSpecifyByVersion(String versionCode);

	public void updateLawSpecify(LawDefineDept lawDefineDept);

}
