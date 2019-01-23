package com.sinosafe.xszc.plan.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.PLAN_DEPT_DETAIL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;

import java.beans.IntrospectionException;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import com.hf.framework.util.UUIDGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.plan.service.PlanMainService;
import com.sinosafe.xszc.plan.service.SalePlanDeptService;
import com.sinosafe.xszc.plan.vo.PlanDeptDetail;
import com.sinosafe.xszc.plan.vo.PlanMain;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.ReflectMatch;

public class SalePlanDeptServiceImpl implements SalePlanDeptService {

	private static final Log log = LogFactory.getLog(SalePlanDeptServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier("PlanMainService")
	private PlanMainService planMainService;

	@Override
	public PageDto findSalePlanDept(PageDto pageDto) {
		Long total = dao.selectOne(PLAN_DEPT_DETAIL + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(PLAN_DEPT_DETAIL + ".queryListPageInfoDept", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageDto queryAllSalePlanDept(PageDto pageDto) {

		pageDto.getWhereMap().put("validInd", "1");
		pageDto.getWhereMap().put("planType", "1");

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			// 取主表的数据
			List<PlanMain> planInfoList = planMainService.queryAllPlanMain(pageDto);
			// 取子表的数据
			for (PlanMain planMain : planInfoList) {
				Set<PlanDeptDetail> set = new HashSet<PlanDeptDetail>();
				List<PlanDeptDetail> listDept = dao.selectList(PLAN_DEPT_DETAIL + QUERY_ONE_VO, planMain.getPlanMainId());
				for (PlanDeptDetail planDeptDetail : listDept) {
					set.add(planDeptDetail);
				}
				planMain.setPlanDeptDetail(set);
				Map<String, Object> map = ReflectMatch.convertBean(planMain);
				list.add(map);
			}
		} catch (IntrospectionException e) {
			log.debug(list);
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		pageDto.setRows(list);
		return pageDto;
	}

	@Override
	public PlanMain querySalePlanDeptByVo(PlanMain planInfo) {
		Set<PlanDeptDetail> planDeptDetailSet = new HashSet<PlanDeptDetail>();
		PlanMain planInfos = planMainService.selectByPrimaryKey(planInfo);
		List<PlanDeptDetail> list = dao.selectList(PLAN_DEPT_DETAIL + QUERY_ONE, planInfos.getPlanMainId());

		for (PlanDeptDetail planDeptDetail : list) {
			planDeptDetailSet.add(planDeptDetail);
		}

		planInfos.setPlanDeptDetail(planDeptDetailSet);
		return planInfos;
	}

	@Override
	public void saveSallePlanDept(PlanMain planMain) {
		boolean flag = planMainService.saveOrUpdatePlanMain(planMain);
		if (flag) {

			Set<PlanDeptDetail> planDeptDetail = planMain.getPlanDeptDetail();
			Iterator<PlanDeptDetail> it = planDeptDetail.iterator();
			while (it.hasNext()) {
				PlanDeptDetail spd = it.next();
				spd.setPlanMainId(planMain.getPlanMainId());
				spd.setUpdatedUser(CurrentUser.getUser().getUserCode());
				spd.setValidInd("1");
				if (spd.getPlanDeptId() != null && (spd.getPlanDeptId() != "" || !spd.getPlanDeptId().equals(""))) {
					dao.update(PLAN_DEPT_DETAIL + UPDATE_PK_VO, spd);
				} else {
					spd.setPlanDeptId(UUIDGenerator.getUUID());
					spd.setCreatedUser(planMain.getCreatedUser());
					spd.setStatus("0");
					dao.insert(PLAN_DEPT_DETAIL + INSERT_VO, spd);
				}
			}
		}
	}

	@Override
	public void deleteSalePlanDept(String planMainId) {
		planMainService.deleteSalePlanDept(planMainId);
		dao.update(PLAN_DEPT_DETAIL + ".deletePlanDeptDetail", planMainId);
	}

	@Override
	public String updateStuts(Map<String, Object> formMap) {
		StringBuffer result = new StringBuffer("");
		formMap.put("userCode", "fengongsi@virtual.com.cn");// CurrentUser.getUser().getUserCode()
		List<Map<String, Object>> list = dao.selectList(PLAN_DEPT_DETAIL + ".comparePlanMain", formMap);
		if (list.size() == 1 && list != null) {
			Map<String, Object> map = list.get(0);
			BigDecimal deptPremiuPro = (BigDecimal) map.get("deptPremiumPro");
			BigDecimal deptPremiumAll = (BigDecimal) map.get("deptPremiumAll");
			if (deptPremiuPro.doubleValue() > deptPremiumAll.doubleValue()) {
				result.append("中支机构保费之和应大于或等于该省分公司的保费，中支公司的保费为：" + deptPremiumAll + ";");
			}
			BigDecimal financePreminumPro = (BigDecimal) map.get("financePreminumPro");
			BigDecimal financePreminumAll = (BigDecimal) map.get("financePreminumAll");
			if (financePreminumPro.doubleValue() > financePreminumAll.doubleValue()) {
				result.append("中支机构金融报销保费之和应大于或等于该省分公司的金融报销保费，中支公司的金融报销保费为：" + financePreminumAll + ";");
			}
			BigDecimal iportantPremiumPro = (BigDecimal) map.get("iportantPremiumPro");
			BigDecimal iportantPremiumAll = (BigDecimal) map.get("iportantPremiumAll");
			if (iportantPremiumPro.doubleValue() > iportantPremiumAll.doubleValue()) {
				result.append("中支机构渠道重客保费之和应大于或等于该省分公司的渠道重客保费，中支公司的渠道重客保费为：" + iportantPremiumAll + ";");
			}
			BigDecimal normalPremiumPro = (BigDecimal) map.get("normalPremiumPro");
			BigDecimal normalPremiumAll = (BigDecimal) map.get("normalPremiumAll");
			if (normalPremiumPro.doubleValue() > normalPremiumAll.doubleValue()) {
				result.append("中支机构其他业务保费之和应大于或等于该省分公司的其他业务保费，中支公司的其他业务保费为：" + normalPremiumAll + ";");
			}
		}
		if (result.toString().equals("")) {
			result.append("审核通过");
			planMainService.updateStuts(formMap);
			dao.update(PLAN_DEPT_DETAIL + ".updatePlanDeptDetailStatus", formMap);
		}

		return result.toString();
	}

	@Override
	public long querySalePlanOneByDept(String deptCode, Integer year) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("deptCode", deptCode);
		map.put("year", String.valueOf(year));
		map.put("planType", "1");
		long count = planMainService.queryPlanOneByDept(map);
		return count;
	}
}
