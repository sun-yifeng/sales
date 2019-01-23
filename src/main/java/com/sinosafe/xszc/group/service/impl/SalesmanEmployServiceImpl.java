package com.sinosafe.xszc.group.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SALESMAN_EMPLOY;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.group.service.SalesmanEmployService;
import com.sinosafe.xszc.group.vo.SalesmanEmploy;
import com.sinosafe.xszc.util.PageDto;

public class SalesmanEmployServiceImpl implements SalesmanEmployService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Override
	public PageDto findSalesmanEmployByWhere(PageDto pageDto) {
		// TODO Auto-generated method stub
		Long total = dao.selectOne(SALESMAN_EMPLOY + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(SALESMAN_EMPLOY + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	
	
	@Override
	public PageDto findSalesmanEmployHistory(PageDto pageDto) {
		// TODO Auto-generated method stub
		//Long total = dao.selectOne(SALESMAN_EMPLOY + QUERY_COUNT, pageDto.getWhereMap());
		//pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(SALESMAN_EMPLOY + ".querySalesmanEmployHistory", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
	@Override
	public void saveSalesmanEmploy(SalesmanEmploy... salesmanEmploy) {
		// TODO Auto-generated method stub
		if (salesmanEmploy != null && salesmanEmploy.length > 0) {
			for (int i = 0; i < salesmanEmploy.length; i++) {
				dao.insert(SALESMAN_EMPLOY + INSERT_VO, salesmanEmploy[i]);
			}
		} else {
			throw new RuntimeException("没有要添加的版本定义，参数为null或长度为0");
		}
	}
	@Override
	 public long repeatSalesmanEmploy(SalesmanEmploy salesmanEmploy){
		long repeat=dao.selectOne(SALESMAN_EMPLOY+".queryRepeatSalesmanEmploy",salesmanEmploy);
		return repeat;
		
	}
	
	public void updateSalesmanEmploy(SalesmanEmploy salesmanEmploy){
		dao.update(SALESMAN_EMPLOY+".updateSalesmanEmploy",salesmanEmploy);
	}

}
