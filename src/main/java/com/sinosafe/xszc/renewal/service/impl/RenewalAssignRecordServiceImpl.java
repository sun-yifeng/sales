package com.sinosafe.xszc.renewal.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.RENEWAL_ASSIGN_RECORD;

import java.sql.Timestamp;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.renewal.service.RenewalAssignRecordService;
import com.sinosafe.xszc.renewal.vo.RenewalAssignRecord;

public class RenewalAssignRecordServiceImpl implements
		RenewalAssignRecordService {
	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Override
	public void saveRenewalAssignRecord(RenewalAssignRecord rarecord) {
		
		rarecord.setAssignId(UUIDGenerator.getUUID());
		rarecord.setCreatedDate(new Timestamp(new Date().getTime()));
		rarecord.setCreatedUser(CurrentUser.getUser().getUserCode());
		rarecord.setUpdatedDate(new Timestamp(new Date().getTime()));
		rarecord.setUpdatedUser(CurrentUser.getUser().getUserCode());
		rarecord.setValidInd("1");
		dao.insert( RENEWAL_ASSIGN_RECORD + INSERT_VO , rarecord );
		
	}

}
