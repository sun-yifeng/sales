package com.sinosafe.xszc.renewal.service;

import java.text.ParseException;
import java.util.Map;

import com.sinosafe.xszc.renewal.vo.Renewal;
import com.sinosafe.xszc.util.PageDto;

public interface RenewalService {

	public PageDto findRenewalByWhere(PageDto pd);

	public Map<String, Object> findRenewalDetailByWhere(Map<String, Object> whereMap);

	public Boolean saveRenewal(Map<String, Object> paraMap);

	public Boolean deleteRenewalByIds(String[] RenewalIdArray) throws ParseException;

	public boolean updateRenewalById(Renewal renewal);

	public Renewal queryRenewalById(String renewalId);

	public PageDto queryDataToExcel(PageDto pageDto);

}
