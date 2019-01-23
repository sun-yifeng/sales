package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_ORIGIN_RATE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.law.service.TLawOriginRateService;
import com.sinosafe.xszc.law.vo.TLawOriginRate;
import com.sinosafe.xszc.util.PageDto;

public class TLawOriginRateServiceImpl implements TLawOriginRateService {

	private static final Log log = LogFactory.getLog(TLawOriginRateServiceImpl.class);
	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Override
	public PageDto findTLawOriginRateByWhere(PageDto pageDto) {
		log.debug("TLawOriginRateServiceImpl  findTLawOriginRateByWhere start.....");
		Long total = dao.selectOne(T_ORIGIN_RATE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(T_ORIGIN_RATE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		log.debug("TLawOriginRateServiceImpl  findTLawOriginRateByWhere end.....");
		return pageDto;
	}

	@Override
	public void saveTLawOriginRate(TLawOriginRate... tLawOriginRate) {
		// TODO Auto-generated method stub
		String currentUser = CurrentUser.getUser().getUserCode();
		if (tLawOriginRate != null && tLawOriginRate.length > 0) {
			for (int i = 0; i < tLawOriginRate.length; i++) {
				//根据流水号查询是否存在
				List<Map<String, Object>> rows = dao.selectList(T_ORIGIN_RATE + ".selectByPrimaryKey", tLawOriginRate[i].getOriginRateId());
				//存在则修改，否则新增
				if(rows.size() > 0){
					tLawOriginRate[i].setUpdatedUser(currentUser);
					dao.update(T_ORIGIN_RATE + UPDATE_VO, tLawOriginRate[i]);
				}else{
					tLawOriginRate[i].setOriginRateId(UUIDGenerator.getUUID());
					tLawOriginRate[i].setUpdatedUser(currentUser);
					tLawOriginRate[i].setCreatedUser(currentUser);
					tLawOriginRate[i].setValidInd("1");
					dao.insert(T_ORIGIN_RATE + INSERT_VO, tLawOriginRate[i]);
				}
			}
		} else {
			throw new RuntimeException("没有要保存的版本定义，参数为null或长度为0");
		}
	}

	@Override
	public List<Map<String, Object>> queryTLawOriginRateToUpdate(String originRateId) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> rows = dao.selectList(T_ORIGIN_RATE + ".selectByPrimaryKey",originRateId);
		return rows;
	}

	@Override
	public void deleteTLawOriginRate(TLawOriginRate tLawOriginRate) {
		// TODO Auto-generated method stub
		dao.delete(T_ORIGIN_RATE + ".deleteByPrimaryKeyVo", tLawOriginRate);
	}

}
