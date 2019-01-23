package com.sinosafe.xszc.plan.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.PLAN_MAIN;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;

import java.util.List;
import java.util.Map;

import com.hf.framework.util.UUIDGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.plan.service.PlanMainService;
import com.sinosafe.xszc.plan.vo.PlanMain;
import com.sinosafe.xszc.util.PageDto;

public class PlanMainServiceImpl implements PlanMainService {
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Override
	public boolean saveOrUpdatePlanMain(PlanMain planMain) {
		boolean flag = false;
		if(planMain.getPlanMainId() != null && (planMain.getPlanMainId() != "" || !planMain.getPlanMainId().equals("") )){
			if(planMain.getUpdatedUser() == null){
				planMain.setUpdatedUser(CurrentUser.getUser().getUserCode());
			}
			dao.update(PLAN_MAIN + UPDATE_PK_VO, planMain);
			flag = true;
		}else{
			String planMainId=UUIDGenerator.getUUID();
			planMain.setPlanMainId(planMainId);
			if(planMain.getCreatedUser() == null){
				String username = CurrentUser.getUser().getUserCode();
				planMain.setCreatedUser(username);
				planMain.setUpdatedUser(username);
				planMain.setValidInd("1");
			}
			dao.insert(PLAN_MAIN + INSERT_VO, planMain);
			flag = true;
		}
		return flag;
	}
	
	@Override
	public PlanMain selectByPrimaryKey(PlanMain planMain) {
		PlanMain spi = (PlanMain)dao.selectOne(PLAN_MAIN + QUERY_ONE_VO, planMain.getPlanMainId());
		return spi;
	}
	
	@Override
	public List<PlanMain> queryAllPlanMain(PageDto pageDto) {
		Long total = dao.selectOne(PLAN_MAIN + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<PlanMain> list = dao.selectList(PLAN_MAIN + QUERY_LIST_PAGE,pageDto.getWhereMap());
		return list;
	}
	
	@Override
	public void deleteSalePlanDept(String planMainId) {
		dao.update(PLAN_MAIN + ".deletePlanMain", planMainId);
	}
	
	@Override
	public void updateStuts(Map<String, Object> formMap) {
		dao.update(PLAN_MAIN + ".updatePlanMainStuts", formMap);
	}
	
	@Override
	public long queryPlanOneByDept(Map<String, String> map) {
		long count = (Long)dao.selectOne(PLAN_MAIN + ".querySalePlanOneByDept", map);
		return count;
	}
	
/*	@Override
	public void deleteSalePlanDept(String planMainId) {
		dao.update(PLAN_MAIN + ".deletePlanMain", planMainId);
	}*/
	
}
