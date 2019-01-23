package com.sinosafe.xszc.util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PageDto implements Serializable {

	private static final long serialVersionUID = 1L;

	private Long total = 0L;

	private String start = "1";

	private String limit = "10";

	private Map<String, Object> whereMap = new HashMap<String, Object>(0);

	private List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>(0);

	public Long getTotal() {
		return total;
	}

	public void setTotal(Long total) {
		this.total = total;
	}

	public List<Map<String, Object>> getRows() {
		return rows;
	}

	public void setRows(List<Map<String, Object>> rows) {
		this.rows = rows;
	}

	public Integer getStart() {
		return Integer.parseInt((start != null ? start : "1"));
	}

	public void setStart(String start) {
		this.start = start;
	}

	public Integer getLimit() {
		return Integer.parseInt((limit != null ? limit : "10"));
	}

	public void setLimit(String limit) {
		this.limit = limit;
	}

	public Map<String, Object> getWhereMap() {
		return whereMap;
	}

	public void setWhereMap(Map<String, Object> whereMap) {
		this.whereMap = whereMap;
	}

	public Long getEnd() {
		long page = 0l;
		if (getStart().intValue() > 1) {
			page = ((getStart() / getLimit()) + 1) * getLimit();
		} else {
			page = getLimit();
		}
		return page;
	}

}
