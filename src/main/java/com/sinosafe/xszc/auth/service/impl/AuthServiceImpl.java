package com.sinosafe.xszc.auth.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.AUTH;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.auth.service.AuthService;

public class AuthServiceImpl implements AuthService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public boolean findBtnCfg(String deptCode) {
		// 为true则关闭按钮
		return (Long) dao.selectOne(AUTH + ".findBtnCfg", deptCode) > 0;
	};

	@Override
	public List<Map<String, Object>> findBtnHtml() {
		// 为true则关闭按钮
		List<Map<String, Object>> list = dao.selectList(AUTH + ".findBtnHtml", null);
		return list;
	};

}
