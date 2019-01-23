package com.sinosafe.xszc.upload.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPLOAD;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.upload.service.UploadService;

public class UploadServiceImpl implements UploadService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public List<Object> findUploadInfo(Map<String, Object> paramMap) {
		List<Object> resultList = dao.selectList(UPLOAD + QUERY, paramMap);
		return resultList;
	}

	@Override
	public List<Map<String, Object>> queryUploadByMainId(Map<String, Object> paramMap) {
		List<Map<String, Object>> resultList = dao.selectList(UPLOAD + QUERY, paramMap);
		return resultList;
	}

}
