package com.sinosafe.xszc.util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class FormDto implements Serializable {

	private static final long serialVersionUID = 1L;

	private Map<String, Object> formMap = new LinkedHashMap<String, Object>();

	private List<Map<String, Object>> formList = new ArrayList<Map<String, Object>>();

	public Map<String, Object> getFormMap() {
		return formMap;
	}

	public void setFormMap(Map<String, Object> formMap) {
		this.formMap = formMap;
	}

	public List<Map<String, Object>> getFormList() {
		return formList;
	}

	public void setFormList(List<Map<String, Object>> formList) {
		this.formList = formList;
	}

}
