package com.sinosafe.xszc.group.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.group.vo.SalesmanVirtual;
import com.sinosafe.xszc.util.PageDto;

public interface SalesmanVirtualService {

	PageDto findSalesmanVirtualByWhere(PageDto pageDto);
	List<Map<String,Object>> selectSalesmanVirtual(String salesmanCode);
	PageDto findSalesmanHistoryByWhere(PageDto pageDto);
	Map<String, Object> querySalesmanVirtualDetial(String virtualId);
	Map<String, Object> querySalesmanVirtualDetial2(String historyId);
	void saveSalesmanVirtual(SalesmanVirtual... salesmanVirtual);

	void updateSalesmanVirtual(SalesmanVirtual... salesmanVirtual);

	// 根据身份证查询人员是否已经存在
	Long findCertiryNoByCount(SalesmanVirtual... salesmanVirtual);

	// 查询工号是否存在
	Long findEmployCode(SalesmanVirtual... SalesmanVirtual);
	
	Long queryEmployCodeHR(SalesmanVirtual... SalesmanVirtual);

	// 判断时间段是否交叉或包含
	Long findDateTime(SalesmanVirtual... SalesmanVirtual);
	// 判断历史记录的时间段与修改后是否交叉或包含
	Long findDateTimeHistory(SalesmanVirtual  SalesmanVirtual);
	// 删除非HR人员
	void deleteSalesmanVirtual(SalesmanVirtual salesmanVirtual);

	//void updateInfoBySalesCode(SalesmanVirtual salesmanVirtual);
	
	void updateInfoBySalesCode(SalesmanVirtual salesmanVirtual,List<Map<String,Object>> rows);
	
	PageDto findSalesmanVirtualRecordByWhere(PageDto pageDto);
	
	void updateSalesmanVirtualRecord(Map<String, Object> paraMap);
	
	String queryMaxEndDate(String employCode);
	
	String validateDate(Map<String, Object> paraMap);
	
	String querySalesmanName(String salesCode);
	
	String querySalesmanType(String employCode);
	String queryVirtualName(String employCode);
}
