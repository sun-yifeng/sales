package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_COST_RATE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.law.service.LawCostRateService;
import com.sinosafe.xszc.law.vo.TLawCostRate;
import com.sinosafe.xszc.util.PageDto;

public class LawCostRateServiceImpl implements LawCostRateService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findLawCostRateByWhere(PageDto pageDto) {
		Long total = dao.selectOne(T_COST_RATE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(T_COST_RATE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void saveLawCostRate(TLawCostRate... lawCostRate) {
		String currentUser = CurrentUser.getUser().getUserCode();
		if (lawCostRate != null && lawCostRate.length > 0) {
			for (int i = 0; i < lawCostRate.length; i++) {
				List<Map<String, Object>> rows = dao.selectList(T_COST_RATE + ".selectByPrimaryKey",
						lawCostRate[i].getCostRateId());
				if(rows.size() > 0){
					lawCostRate[i].setUpdatedUser(currentUser);
					dao.update(T_COST_RATE + UPDATE_VO, lawCostRate[i]);
				}else{
					lawCostRate[i].setCostRateId(UUIDGenerator.getUUID());
					lawCostRate[i].setCreatedUser(currentUser);
					lawCostRate[i].setUpdatedUser(currentUser);
					lawCostRate[i].setValidInd("1");
					dao.insert(T_COST_RATE + INSERT_VO, lawCostRate[i]);
				}
			}
		} else {
			throw new RuntimeException("没有要保存的版本定义，参数为null或长度为0");
		}
	}

	@Override
	public List<Map<String, Object>> queryLawCostRateToUpdate(String costRateId) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> rows = dao.selectList(T_COST_RATE + ".selectByPrimaryKey", costRateId);
		return rows;
	}

	@Override
	public void deleteLawCostRate(String costRateId) {
		// TODO Auto-generated method stub
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("costRateId", costRateId);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		
		dao.update(T_COST_RATE + DELETE_BY_ID, map);
	}
}
