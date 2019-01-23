package com.sinosafe.xszc.group.service;

import com.sinosafe.xszc.group.vo.SalesmanEmploy;
import com.sinosafe.xszc.util.PageDto;

public interface SalesmanEmployService {
	//分页查询
	PageDto findSalesmanEmployByWhere(PageDto pageDto);
	
	//分页查询销售人员改动前的关联工号
		PageDto findSalesmanEmployHistory(PageDto pageDto);
		
	//新增
	void saveSalesmanEmploy(SalesmanEmploy... salesmanEmploy);
	
	long repeatSalesmanEmploy(SalesmanEmploy salesmanEmploy);
	
	//修改
	void updateSalesmanEmploy(SalesmanEmploy salesmanEmploy);
}
