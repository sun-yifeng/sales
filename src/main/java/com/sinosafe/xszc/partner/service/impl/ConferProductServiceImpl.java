package com.sinosafe.xszc.partner.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CONFER_PRODUCT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.partner.service.ConferProductService;
import com.sinosafe.xszc.partner.vo.ConferProduct;

public class ConferProductServiceImpl implements ConferProductService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public void saveConferProduct(ConferProduct conferProduct) {
		dao.insert(CONFER_PRODUCT + INSERT_VO, conferProduct);
	}

	@Override
	public void updateConferProduct(ConferProduct conferProduct) {
		dao.update(CONFER_PRODUCT + UPDATE_PK_VO, conferProduct);
	}

}