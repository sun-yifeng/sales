package com.sinosafe.xszc.group.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.LAW_DEFINE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_NODE_ACCOUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SALESMAN;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SALESMAN_VIRTUAL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.VIRTUAL_HISTORY;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.group.service.SalesmanService;
import com.sinosafe.xszc.group.service.SalesmanVirtualService;
import com.sinosafe.xszc.group.vo.SalesmanVirtual;
import com.sinosafe.xszc.util.PageDto;

public class SalesmanVirtualServiceImpl implements SalesmanVirtualService {

	private static final Log log = LogFactory.getLog(SalesmanVirtualServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "DepartmentService")
	private DepartmentService departmentService;

	@Autowired
	@Qualifier(value = "SalesmanService")
	private SalesmanService salesmanService;

	/**
	 * 查询所有非HR员工数据
	 */
	@Override
	public PageDto findSalesmanVirtualByWhere(PageDto pageDto) {
		log.debug("查询非HR人员开始.....");
		Long total = dao.selectOne(SALESMAN_VIRTUAL + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(SALESMAN_VIRTUAL + QUERY_LIST_PAGE, pageDto.getWhereMap());
		// pageDto.setRows(rows);
		pageDto.setRows(this.getMultiDeptInfo(rows));
		log.debug("查询非HR人员结束.....");
		return pageDto;
	}

	public PageDto findSalesmanHistoryByWhere(PageDto pageDto) {
		log.debug("开始查询非HR人员的历史修改记录.....");

		Long total = dao.selectOne(SALESMAN_VIRTUAL + VIRTUAL_HISTORY, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);

		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(SALESMAN_VIRTUAL + ".queryListHistory", pageDto.getWhereMap());
		// pageDto.setRows(rows);
		pageDto.setRows(this.getMultiDeptInfo(rows));
		log.debug("查询非HR人员的历史修改记录结束.....");
		return pageDto;
	}

	/**
	 * <pre>
	 * 查询多级机构的代码及名称
	 * @param rows
	 * @return
	 * </pre>
	 */
	public List<Map<String, Object>> getMultiDeptInfo(List<Map<String, Object>> rows) {
		for (Map<String, Object> map : rows) {
			String deptCode = (String) map.get("deptCode");
			Map<String, Object> deptMap = dao.selectOne(SALESMAN + ".getMultiDeptInfo", deptCode);
			map.put("deptCodeFour", deptCode);
			// 取不到机构时，页面显示空白
			if (deptMap != null) {
				map.put("deptNameFour", deptMap.get("deptNameFour"));
				map.put("deptCodeThree", deptMap.get("deptCodeThree"));
				map.put("deptNameThree", deptMap.get("deptNameThree"));
				map.put("deptCodeTwo", deptMap.get("deptCodeTwo"));
				map.put("deptNameTwo", deptMap.get("deptNameTwo"));
			}
		}
		return rows;
	}

	/**
	 * 新增非HR人员
	 */
	@Override
	public void saveSalesmanVirtual(SalesmanVirtual... salesmanVirtual) {
		if (salesmanVirtual != null && salesmanVirtual.length > 0) {
			// 新增人员
			for (int i = 0; i < salesmanVirtual.length; i++) {
				// 如果是销售助理，则在HR人员中失效
				if ("0".equals(salesmanVirtual[i].getSalesmanType())) {
					dao.insert(SALESMAN_VIRTUAL + ".updateHrSalesman", salesmanVirtual[i]);
				}
				dao.insert(SALESMAN_VIRTUAL + INSERT_VO, salesmanVirtual[i]);
			}
		} else {
			throw new RuntimeException("新增非HR人员时出错！参数：" + JSON.toJSONString(salesmanVirtual));
		}
	}

	/**
	 * 修改非HR人员
	 */
	@Override
	public void updateSalesmanVirtual(SalesmanVirtual... salesmanVirtual) {
		if (salesmanVirtual != null && salesmanVirtual.length > 0) {
			dao.insert(SALESMAN_VIRTUAL + ".updaVritualHistory", salesmanVirtual[0]);
			for (int i = 0; i < salesmanVirtual.length; i++) {
				dao.update(SALESMAN_VIRTUAL + ".updateByPrimaryKey", salesmanVirtual[i]);
			}
		} else {
			throw new RuntimeException("修改非HR人员时出错！参数" + JSON.toJSONString(salesmanVirtual));
		}
	}

	@Override
	public Long findCertiryNoByCount(SalesmanVirtual... salesmanVirtual) {
		Long total = dao.selectOne(SALESMAN_VIRTUAL + ".queryCertiryNoCount", salesmanVirtual[0]);
		return total;
	}

	// 判断时间段是否交叉或包含
	@Override
	public Long findDateTime(SalesmanVirtual... salesmanVirtual) {
		// TODO Auto-generated method stub
		Long count = dao.selectOne(SALESMAN_VIRTUAL + ".queryDateTime", salesmanVirtual[0]);
		return count;
	}

	// 判断历史记录的时间段是否交叉或包含
		@Override
		public Long findDateTimeHistory(SalesmanVirtual salesmanVirtual) {
			// TODO Auto-generated method stub
			Long count = dao.selectOne(SALESMAN_VIRTUAL + ".queryDateTimeHistory", salesmanVirtual);
			return count;
		}
	@Override
	public Long findEmployCode(SalesmanVirtual... salesmanVirtual) {
		// TODO Auto-generated method stub
		Long count = dao.selectOne(SALESMAN_VIRTUAL + ".queryEmployCode", salesmanVirtual[0]);
		return count;
	}
	
	@Override
	public Long queryEmployCodeHR(SalesmanVirtual... salesmanVirtual) {
		// TODO Auto-generated method stub
		Long count = dao.selectOne(SALESMAN_VIRTUAL + ".queryEmployCodeHR", salesmanVirtual[0]);
		return count;
	}

	@Override
	public void deleteSalesmanVirtual(SalesmanVirtual salesmanVirtual) {
		// TODO Auto-generated method stub
		dao.update(SALESMAN_VIRTUAL + ".deleteById", salesmanVirtual);
		if (salesmanVirtual.getEmployCode() != "" && !"".equals(salesmanVirtual.getEmployCode())) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("employCode", salesmanVirtual.getEmployCode());
			dao.update(MEDIUM_NODE_ACCOUNT + ".deleteByEmpCode", map);
		}
	}

	@Override
	public Map<String, Object> querySalesmanVirtualDetial(String virtualId) {
		// TODO Auto-generated method stub
		Map<String, Object> salesmanVirtual = dao.selectOne(SALESMAN_VIRTUAL + ".selectByPrimaryKeyMap", virtualId);
		return salesmanVirtual;
	}

	@Override
	public Map<String, Object> querySalesmanVirtualDetial2(String historyId) {
		// TODO Auto-generated method stub
		Map<String, Object> salesmanVirtual = dao.selectOne(SALESMAN_VIRTUAL + ".selectByPrimaryKeyMap2", historyId);
		return salesmanVirtual;
	}

	@Override
	public void updateInfoBySalesCode(SalesmanVirtual salesmanVirtual,List<Map<String,Object>> rows ) {
		// TODO Auto-generated method stub
		for(int i=0;i<rows.size();i++){
			SalesmanVirtual sv =new SalesmanVirtual();
			sv.setVirtualId((String)rows.get(i).get("virtualId"));
			sv.setUpdatedUser(CurrentUser.getUser().getUserCode());
			sv.setHistoryId(UUIDGenerator.getUUID());
			
			dao.insert(SALESMAN_VIRTUAL+".updaVritualHistory",sv);
			
		}
		dao.update(SALESMAN_VIRTUAL + ".updateInfoBySalesCode", salesmanVirtual);
		
	}
	@Override
	public List<Map<String,Object>> selectSalesmanVirtual(String salesmanCode){
	List<Map<String,Object>> rows=new ArrayList<Map<String,Object>>();
	rows=dao.selectList(SALESMAN_VIRTUAL+".queryVirtualbySalseCode",salesmanCode);
	return rows;
	}

	@Override
	public PageDto findSalesmanVirtualRecordByWhere(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(SALESMAN_VIRTUAL + ".selectSalesmanVirtualRecord", pageDto.getWhereMap());
		// pageDto.setRows(rows);
		pageDto.setRows(this.getMultiDeptInfo(rows));
		log.debug("查询非HR人员结束.....");
		return pageDto;
	}

	@Override
	public void updateSalesmanVirtualRecord(Map<String, Object> paraMap) {
		String jsonStr = (String) paraMap.get("jsonStr");
		String updatedUser = (String) paraMap.get("updatedUser");
		List<Map<String, Object>> list = JSON.parseObject(jsonStr, new TypeReference<List<Map<String, Object>>>() {
		});
		for (Map<String, Object> map : list) {
			map.put("updatedUser", updatedUser);
			boolean existsFlag = ((Long) dao.selectOne(SALESMAN_VIRTUAL + ".existsSalesmanVirtualRecord", map)) > 0;
			if (existsFlag) {
				dao.update(SALESMAN_VIRTUAL + ".updateSalesmanVirtualRecord", map);
			} else {
				dao.update(SALESMAN_VIRTUAL + ".insertSalesmanVirtualRecord", map);
			}
		}
		
	}

	@Override
	public String queryMaxEndDate(String employCode) {
		return dao.selectOne(SALESMAN_VIRTUAL + ".queryMaxEndDate", employCode);
	}
	
	@Override
	public String querySalesmanName(String salesCode) {
		return dao.selectOne(SALESMAN_VIRTUAL + ".querySalesmanName", salesCode);
	}
	@Override
	public String querySalesmanType(String employCode) {
		return dao.selectOne(SALESMAN_VIRTUAL + ".querySalesmanType", employCode);
	}

	@Override
	public String validateDate(Map<String, Object> paraMap) {
		try {
			String jsonStr = (String) paraMap.get("jsonStr1");
			List<Map<String, Object>> list = JSON.parseObject(jsonStr, new TypeReference<List<Map<String, Object>>>() {
			});
			List<Map<String, Object>> rows = dao.selectList(SALESMAN_VIRTUAL + ".selectSalesmanVirtualRecord", paraMap);
			//获取销售助理下所有的异动记录
			
				
				for (Map<String, Object> map : list) {
					String bgnDateStr = (String) map.get("bgnDate");
					String endDateStr = (String) map.get("endDate");
					String pkIdStr = (String) map.get("pkId");
					
					long bgnTime =  new SimpleDateFormat("yyyy-MM-dd").parse(bgnDateStr).getTime();
					long endTime =  new SimpleDateFormat("yyyy-MM-dd").parse(endDateStr).getTime();
					
					if(bgnTime > endTime){
						return "1";
					}
					
					for (int i = 0; i < rows.size(); i++) {
						Map<String, Object> mp = rows.get(i);
						String bgnDate = (String)mp.get("bgnDate");
						String endDate = (String)mp.get("endDate");
						long bgnDateTime =  new SimpleDateFormat("yyyy-MM-dd").parse(bgnDate).getTime();
						long endDateTime =  new SimpleDateFormat("yyyy-MM-dd").parse(endDate).getTime();
						String pkId = (String)mp.get("pkId");
					
						if(pkId.equals(pkIdStr)){
							continue;
						}else{
							long maxTime = getMaxTime(bgnDateTime,bgnTime);
							long minTime = getMinTime(endDateTime,endTime);
							if(minTime-maxTime>0){
								return "2";
							}
						}
					}
				}
			
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return "3";
	}
	
	private long getMaxTime(long a,long b){
		return a-b>0?a:b;
	}
	
	private long getMinTime(long a,long b){
		return a-b<0?a:b;
	}

	@Override
	public String queryVirtualName(String employCode) {
		return dao.selectOne(SALESMAN_VIRTUAL + ".queryVirtualName", employCode);
	}

}
