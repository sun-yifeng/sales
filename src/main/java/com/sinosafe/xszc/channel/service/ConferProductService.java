package com.sinosafe.xszc.channel.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.channel.vo.ChannelConferProduct;
import com.sinosafe.xszc.util.PageDto;


public interface ConferProductService {

	void saveConferProduct(ChannelConferProduct conferProduct);

	PageDto findConferProductByWhere(PageDto pageDto);

	void updateConferProduct(ChannelConferProduct conferProduct);

	List<ChannelConferProduct> queryIdList(String conferCode);

	void deleteConferProduct(Map<String, Object> map);

	void deleteConferProducts(Map<String, Object> map);

	PageDto findConferProductsByWhere(PageDto pageDto);

	PageDto findConferProductsHistoryByWhere(PageDto pageDto);

	void deleteMediumConferProduct(String conferProductId);

	Long queryMediumConferProductCode(Map<String, Object> map);

	
	/**
	 * 查询复制对象产品手续费比例
	 * TODO 方法findConferProdCopyByWhere的简要说明 <br><pre>
	 * 方法findConferProdCopyByWhere的详细说明 <br>
	 * 编写者：李晓亮
	 * 创建时间：2015年1月21日 下午5:42:45 </pre>
	 * @param whereMap
	 * @return
	 * @return List<Map<String,Object>> 说明
	 * @throws 异常类型 说明
	 */
	List<Map<String, Object>> findConferProdCopyByWhere(Map<String, Object> whereMap);
	
	void updateNoTaxRate(Map<String, Object> noTaxMap);
	
	Map<String,Object> queryRateByProduct(String productCode);
	
	Map<String,Object> queryProductName(String productCode);
	
	String queryProductByConferId(Map<String,Object> paraMap);

}
