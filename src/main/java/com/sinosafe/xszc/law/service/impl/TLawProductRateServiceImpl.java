package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_LAW_PRODUCT_RATE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.law.service.TLawProductRateService;
import com.sinosafe.xszc.law.vo.TLawProductRate;
import com.sinosafe.xszc.util.PageDto;

public class TLawProductRateServiceImpl implements TLawProductRateService{
	
	private static final Log log = LogFactory.getLog(TLawProductRateServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findTLawProductRateByWhere(PageDto pageDto){
		Long total = dao.selectOne(T_LAW_PRODUCT_RATE+QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if(pageDto.getStart() != null && pageDto.getStart().intValue() != 1){
			pageDto.getWhereMap().put("startpoint", pageDto.getStart()+1);
		}else{
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String,Object>>rows=dao.selectList(T_LAW_PRODUCT_RATE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	
	@Override
	public void saveTLawProductRate(TLawProductRate... tLawProductRate){
		if(tLawProductRate != null && tLawProductRate.length > 0){
			for(int i = 0; i < tLawProductRate.length; i++){
				String currentUser = CurrentUser.getUser().getUserCode();
				tLawProductRate[i].setCreatedUser(currentUser);
				tLawProductRate[i].setUpdatedUser(currentUser);
				if(tLawProductRate[i].getProductRateId()!=null && ( tLawProductRate[i].getProductRateId()!="") ){
					tLawProductRate[i].setValidInd("1");
					//tLawProductRate[i].setDeptCode2("04");
					tLawProductRate[i].setProductRateId(tLawProductRate[i].getProductRateId());
					dao.update(T_LAW_PRODUCT_RATE+ UPDATE_VO, tLawProductRate[i]);
				}else{
					tLawProductRate[i].setValidInd("1");
					//tLawProductRate[i].setDeptCode2("04");
					tLawProductRate[i].setProductRateId(UUIDGenerator.getUUID());
					dao.insert(T_LAW_PRODUCT_RATE + INSERT_VO, tLawProductRate[i]);
				}
			}
		}else {
			throw new RuntimeException("没有要保存的产品调整系数，参数为null或长度为0");
		}
	}

	@Override
	public void deleteTLawLineRate(String productRateId) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("productRateId", productRateId);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		dao.update(T_LAW_PRODUCT_RATE + DELETE_BY_ID, map);
	}

	@Override
	public List<Map<String, Object>> queryTLawProductRateToUpdate(
			String productRateId) {
		List<Map<String, Object>> rows = dao.selectList(T_LAW_PRODUCT_RATE + ".selectByPrimaryKey", productRateId);
		return rows;
	}
}
