package com.sinosafe.xszc.planNew.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.PLAN_MAIN_NEW;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.planNew.service.PlanMainService;
import com.sinosafe.xszc.planNew.vo.PlanMainNew;
import com.sinosafe.xszc.util.PageDto;

public class PlanMainServiceImpl implements PlanMainService {
	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	/**
	 * TODO 覆盖方法saveOrUpdate简单说明:<br><pre>
	 * 覆盖方法saveOrUpdate详细说明:<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月2日 下午4:42:27 </pre>
	 * @param 参数名 说明
	 * @return 返回值类型 说明
	 * @throws 异常类型 说明
	 * @see com.sinosafe.xszc.planNew.service.PlanMainService#saveOrUpdate(com.sinosafe.xszc.planNew.vo.PlanMainNew)
	 */
	@Override
	public boolean saveOrUpdate(PlanMainNew planMain) {
		boolean flag = false;
		//判断数据库是否存在，存在作修改，不存在作添加
		if(this.isExist(planMain.getPlanMainId())){
			dao.update(PLAN_MAIN_NEW + UPDATE_PK_VO, planMain);
			flag = true;
		}else{
			planMain.setPlanMainId(planMain.getPlanMainId());
			dao.insert(PLAN_MAIN_NEW + INSERT_VO, planMain);
			flag = true;
		}
		return flag;
	}
	
	@Override
	public PlanMainNew selectByPrimaryKey(PlanMainNew planMain) {
		PlanMainNew spi = (PlanMainNew)dao.selectOne(PLAN_MAIN_NEW + QUERY_ONE_VO, planMain.getPlanMainId());
		return spi;
	}
	
	/**
	 * 详细说明:根据提供的条件查询所有销售计划<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月3日 上午8:34:59 </pre>
	 * @param pageDto
	 * @return List<PlanMainNew> 返回列表
	 * @see com.sinosafe.xszc.planNew.service.PlanMainService#queryAllPlanMain(com.sinosafe.xszc.util.PageDto)
	 */
	@Override
	public List<PlanMainNew> queryAllPlanMain(PageDto pageDto) {
		Long total = dao.selectOne(PLAN_MAIN_NEW + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<PlanMainNew> list = dao.selectList(PLAN_MAIN_NEW + ".queryListPage",pageDto.getWhereMap());
		return list;
	}
	
	@Override
	public void deleteSalePlanDept(String planMainId) {
		dao.update(PLAN_MAIN_NEW + ".deletePlanMain", planMainId);
	}
	
	@Override
	public void updateStuts(Map<String, Object> formMap) {
		dao.update(PLAN_MAIN_NEW + ".updatePlanMainStuts", formMap);
	}
	
	@Override
	public long queryPlanOneByDept(Map<String, String> map) {
		long count = (Long)dao.selectOne(PLAN_MAIN_NEW + ".querySalePlanOneByDept", map);
		return count;
	}
	
	/**
	 * TODO 覆盖方法isExist简单说明:<br><pre>
	 * 覆盖方法isExist详细说明:查看表中是否存在某条计划,根据主键值<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月2日 下午4:59:28 </pre>
	 * @param planMainId主键
	 * @return 返回是否成功
	 * @see com.sinosafe.xszc.planNew.service.PlanMainService#isExist(java.lang.String)
	 */
	@Override
	public boolean isExist(String planMainId) {
		long count = (Long)dao.selectOne(PLAN_MAIN_NEW + ".countByPrimaryKey", planMainId);
		return count>0;
	}
	
	/**
	 * 覆盖方法isExist详细说明:判断计划是否存在<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月15日 下午3:37:25 </pre>
	 * @param deptCode机构编码
	 * @param year年份
	 * @return boolean 返回是否存在
	 * @see com.sinosafe.xszc.planNew.service.PlanMainService#isExist(java.lang.String, java.lang.Integer)
	 */
	public boolean isExist(String deptCode, Integer year){
		Map<String,Object> whereMap = new HashMap<String,Object>();
		whereMap.put("deptCode", deptCode);
		whereMap.put("year", year);
		long count = (Long)dao.selectOne(PLAN_MAIN_NEW + ".countByDeptYear", whereMap);
		return count>0;
	}

	/**
	 * 覆盖方法isExist详细说明:查询计划信息<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月15日 下午3:37:25 </pre>
	 * @param deptCode机构编码
	 * @param year年份
	 * @return PlanMainNew 返回计划信息
	 * @see com.sinosafe.xszc.planNew.service.PlanMainService#selectByDeptYear(java.lang.String, java.lang.Integer)
	 */
	public PlanMainNew selectByDeptYear(String deptCode, Integer year){
		Map<String,Object> whereMap = new HashMap<String,Object>();
		whereMap.put("deptCode", deptCode);
		whereMap.put("year", year);
		PlanMainNew planMainNew = (PlanMainNew)dao.selectOne(PLAN_MAIN_NEW + ".selectByDeptYear", whereMap);
		return planMainNew;
	}
	
	/**
	 * 覆盖方法isExist详细说明:将计划设置成无效<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月15日 下午3:37:25 </pre>
	 * @param deptCode机构编码
	 * @param year年份
	 * @return PlanMainNew 返回计划信息
	 * @see com.sinosafe.xszc.planNew.service.PlanMainService#selectByDeptYear(java.lang.String, java.lang.Integer)
	 */
	public void delPlanMainById(String planMainId){
		Map<String,Object> whereMap = new HashMap<String,Object>();
		whereMap.put("validInd", "0");
		whereMap.put("planMainId", planMainId);
		dao.delete(PLAN_MAIN_NEW + ".updateByPrimaryKeySelective", whereMap);
	}
	
/*	@Override
	public void deleteSalePlanDept(String planMainId) {
		dao.update(PLAN_MAIN_NEW + ".deletePlanMain", planMainId);
	}*/
	
}
