package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_PID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CONFER_PRODUCT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ID_LIST;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LISTS_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CONFER_PRODUCT_HISTORY;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.channel.service.ConferProductService;
import com.sinosafe.xszc.channel.vo.ChannelConferProduct;
import com.sinosafe.xszc.util.PageDto;

public class ConferProductServiceImpl implements ConferProductService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public void saveConferProduct(ChannelConferProduct conferProduct) {
		dao.insert(CONFER_PRODUCT + INSERT_VO, conferProduct);
	}

	@Override
	public PageDto findConferProductByWhere(PageDto pageDto) {
		Long total = dao.selectOne(CONFER_PRODUCT + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(CONFER_PRODUCT + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void updateConferProduct(ChannelConferProduct conferProduct) {
		dao.update(CONFER_PRODUCT + UPDATE_PK_VO, conferProduct);
	}

	@Override
	public List<ChannelConferProduct> queryIdList(String conferCode) {
		List<ChannelConferProduct> list = dao.selectList(CONFER_PRODUCT + QUERY_ID_LIST, conferCode);
		return list;
	}

	@Override
	public void deleteConferProduct(Map<String, Object> map) {
		// TODO Auto-generated method stub
		dao.update(CONFER_PRODUCT + DELETE_BY_ID, map);
	}

	@Override
	public void deleteConferProducts(Map<String, Object> map) {
		dao.update(CONFER_PRODUCT + DELETE_BY_PID, map);
	}

	@Override
	public PageDto findConferProductsByWhere(PageDto pageDto) {
		Long total = dao.selectOne(CONFER_PRODUCT + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(CONFER_PRODUCT + QUERY_LISTS_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto findConferProductsHistoryByWhere(PageDto pageDto) {
		Long total = dao.selectOne(CONFER_PRODUCT_HISTORY + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(CONFER_PRODUCT_HISTORY + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void deleteMediumConferProduct(String conferProductId) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (conferProductId != "") {
			map.put("updatedUser", CurrentUser.getUser().getUserCode());
			map.put("pkIds", conferProductId.split(","));
			dao.update(CONFER_PRODUCT + DELETE_BY_ID, map);
		}
	}

	@Override
	public Long queryMediumConferProductCode(Map<String, Object> map) {
		Long total = dao.selectOne(CONFER_PRODUCT + ".queryCountByWhere", map);
		return total;
	}

	/**
	 * <pre>
	 * 查询复制对象产品手续费比例
	 * 覆盖方法findConferProdCopyByWhere简单说明 <br>
	 * 覆盖方法findConferProdCopyByWhere详细说明 <br>
	 * 编写者：李晓亮
	 * 创建时间：2015年1月21日 下午5:43:00
	 * </pre>
	 * 
	 * @param 参数名说明
	 * @return 返回值类型说明
	 * @throws 异常类型说明
	 * @see com.sinosafe.xszc.channel.service.ConferProductService#findConferProdCopyByWhere(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> findConferProdCopyByWhere(Map<String, Object> whereMap) {
		whereMap.put("conferId", whereMap.get("conferId") == null ? "XXXX" : whereMap.get("conferId"));
		whereMap.put("extendConferCode", whereMap.get("extendConferCode") == null ? "XXXX" : whereMap.get("extendConferCode"));
		List<Map<String, Object>> rows = dao.selectList(CONFER_PRODUCT + ".queryCopyProd", whereMap);
		return rows;
	}
	
	@Override
	public void updateNoTaxRate(Map<String, Object> noTaxMap) {
		dao.update(CONFER_PRODUCT + ".updateNoTaxRate", noTaxMap);
	}
	
	@Override
	public Map<String,Object> queryRateByProduct(String productCode) {
		long count = dao.selectOne(CONFER_PRODUCT + ".queryCountByProduct", productCode);
		Map<String,Object> map = null;
		if(count>0){
			map = dao.selectOne(CONFER_PRODUCT + ".queryRateByProduct", productCode);
		}
		return map;
	}
	
	@Override
	public Map<String,Object> queryProductName(String productCode) {
		Map<String,Object> map = dao.selectOne(CONFER_PRODUCT + ".queryProductName", productCode);
		return map;
	}
	
	@Override
	public String queryProductByConferId(Map<String,Object> paraMap) {
		String result = dao.selectOne(CONFER_PRODUCT + ".queryProductByConferId", paraMap);
		return result;
	}
}
