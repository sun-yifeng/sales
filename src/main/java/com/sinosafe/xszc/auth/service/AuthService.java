package com.sinosafe.xszc.auth.service;

import java.util.List;
import java.util.Map;

public interface AuthService {

	public boolean findBtnCfg(String deptCode);

	public List<Map<String, Object>> findBtnHtml();

}
