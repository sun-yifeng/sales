package com.sinosafe.xszc.plan.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.PLAN_CHANNEL_DETAIL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.PLAN_MAIN;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_CHANNELONE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;

import java.beans.IntrospectionException;
import java.lang.reflect.InvocationTargetException;
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
import com.sinosafe.xszc.plan.service.SalePlanChannelService;
import com.sinosafe.xszc.plan.vo.PlanChannelDetail;
import com.sinosafe.xszc.plan.vo.PlanMain;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.ReflectMatch;

public class SalePlanChannelServiceImpl implements SalePlanChannelService {

	private static final Log log = LogFactory.getLog(SalePlanChannelServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier("PlanMainService")
	private PlanMainService planMainService;

	@Override
	public PageDto findSalePlanChannelByWhere(PageDto pageDto) {
		Long total = dao.selectOne(PLAN_CHANNEL_DETAIL + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(PLAN_CHANNEL_DETAIL + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto findSalePlanChannel(PageDto pageDto) {
		Long total = dao.selectOne(PLAN_CHANNEL_DETAIL + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(PLAN_CHANNEL_DETAIL + ".queryListPageInfoChannel", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void saveSallePlanChannel(PlanMain planMain) {
		boolean flag = planMainService.saveOrUpdatePlanMain(planMain);
		if (flag) {
			List<PlanChannelDetail> listPcd = new ArrayList<PlanChannelDetail>();
			PlanChannelDetail planCd = null;

			PlanMain pm = this.querySalePlanChannelByVo(planMain, null);
			Set<PlanChannelDetail> pcdSet = pm.getPlanChannelDetail();
			Iterator<PlanChannelDetail> itPcd = pcdSet.iterator();
			while (itPcd.hasNext()) {
				listPcd.add(itPcd.next());
			}
			Set<PlanChannelDetail> planChannelDetail = planMain.getPlanChannelDetail();
			Iterator<PlanChannelDetail> it = planChannelDetail.iterator();
			while (it.hasNext()) {
				PlanChannelDetail p = it.next();
				p.setPlanMainId(planMain.getPlanMainId());
				p.setUpdatedUser(CurrentUser.getUser().getUserCode());
				p.setStatus("1");
				p.setValidInd("1");
				if (p.getPlanChannelId() != null && (p.getPlanChannelId() != "" || !p.getPlanChannelId().equals(""))) {

					for (int i = 0; i < listPcd.size(); i++) {
						planCd = listPcd.get(i);
						if (p.getPlanChannelId().equals(planCd.getPlanChannelId()) || p.getPlanChannelId() == planCd.getPlanChannelId()) {
							listPcd.remove(planCd);
						}
					}
					dao.update(PLAN_CHANNEL_DETAIL + UPDATE_PK_VO, p);
				} else {
					p.setPlanChannelId(UUIDGenerator.getUUID());
					p.setCreatedUser(CurrentUser.getUser().getUserCode());
					dao.insert(PLAN_CHANNEL_DETAIL + INSERT_VO, p);
				}
			}
			for (int i = 0; i < listPcd.size(); i++) {
				//log.debug("执行最后的删除--------------------");
				planCd = listPcd.get(i);
				planCd.setUpdatedUser(CurrentUser.getUser().getUserCode());
				planCd.setValidInd("0");
				dao.update(PLAN_CHANNEL_DETAIL + UPDATE_PK_VO, planCd);
			}
		}
	}

	@Override
	public PlanMain querySalePlanChannelByVo(PlanMain planMain, String ChannelRiskType) {
		Set<PlanChannelDetail> planChannelDetailSet = new HashSet<PlanChannelDetail>();
		PlanMain planMains = planMainService.selectByPrimaryKey(planMain);
		Map<String, String> map = new HashMap<String, String>();
		map.put("planMainId", planMains.getPlanMainId());
		map.put("channelRiskType", ChannelRiskType);
		List<PlanChannelDetail> list = dao.selectList(PLAN_CHANNEL_DETAIL + QUERY_ONE_VO, map);
		for (PlanChannelDetail planChannelDetail : list) {
			planChannelDetailSet.add(planChannelDetail);
		}
		planMains.setPlanChannelDetail(planChannelDetailSet);
		//log.debug(list.size());
		return planMains;
	}

	@Override
	public void updateSalePlanChannel(PlanMain planMain) {

		if (planMain.getPlanMainId() == null && "".equals(planMain.getPlanMainId())) {
			String planMainId = UUIDGenerator.getUUID();
			planMain.setPlanMainId(planMainId);
			if (planMain.getCreatedUser() == null) {
				String username = CurrentUser.getUser().getUserCode();
				planMain.setCreatedUser(username);
				planMain.setUpdatedUser(username);
				planMain.setStatus("1");
				planMain.setValidInd("1");
			}
			dao.insert(PLAN_MAIN + INSERT_VO, planMain);
		} else {
			if (planMain.getUpdatedUser() == null) {
				planMain.setUpdatedUser(CurrentUser.getUser().getUserCode());
			}
			dao.update(PLAN_MAIN + UPDATE_PK_VO, planMain);
		}
	}

	@Override
	public PlanMain queryPlanMainByVo(PlanMain planMain) {
		PlanMain planMains = planMainService.selectByPrimaryKey(planMain);
		return planMains;
	}

	@Override
	public void saveSalePlanChannel(PlanChannelDetail planChannelDetail) {
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageDto queryAllSalePlanChannel(PageDto pageDto) {
		pageDto.getWhereMap().put("validInd", "1");
		pageDto.getWhereMap().put("planType", "2");

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			List<PlanMain> planInfoList = planMainService.queryAllPlanMain(pageDto);
			for (PlanMain planMain : planInfoList) {
				Set<PlanChannelDetail> set = new HashSet<PlanChannelDetail>();
				List<PlanChannelDetail> listChannel = dao.selectList(PLAN_CHANNEL_DETAIL + QUERY_CHANNELONE_VO, planMain.getPlanMainId());
				for (PlanChannelDetail planChannelDetail : listChannel) {
					set.add(planChannelDetail);
				}
				planMain.setPlanChannelDetail(set);
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

}
