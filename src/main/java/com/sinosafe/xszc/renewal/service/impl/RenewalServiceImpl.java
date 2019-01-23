package com.sinosafe.xszc.renewal.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.RENEWAL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.renewal.service.RenewalAssignRecordService;
import com.sinosafe.xszc.renewal.service.RenewalService;
import com.sinosafe.xszc.renewal.vo.Renewal;
import com.sinosafe.xszc.renewal.vo.RenewalAssignRecord;
import com.sinosafe.xszc.util.PageDto;

public class RenewalServiceImpl implements RenewalService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier("RenewalAssignRecordService")
	private RenewalAssignRecordService renewalAssignRecordService;

	/* 
	 * 分页查询
	 * (non-Javadoc)
	 * @see com.sinosafe.xszc.renewal.service.RenewalService#findRenewalByWhere(com.sinosafe.xszc.util.PageDto)
	 */
	@Override
	public PageDto findRenewalByWhere(PageDto pageDto) {
		Long total = dao.selectOne(RENEWAL + ".queryCount", pageDto.getWhereMap());
		pageDto.setTotal(total);

		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		
		List<Map<String, Object>> rows = dao.selectList(RENEWAL + ".queryListPage", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Map<String, Object> findRenewalDetailByWhere(Map<String, Object> whereMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		//List<Map<String, Object>> resultList = dao.selectList(RENEWAL + QUERY, whereMap);

		// if (resultList != null && resultList.size() > 0)
		// {
		// resultMap = resultList.get(0);
		// // notice dept
		// String noticId = (String)resultMap.get("noticId");
		// List<Map<String,Object>> resultDepts = dao.selectList(NOTICE_DEPT+
		// QUERY, whereMap);
		// String resultDept="";
		// for (Map<String,Object> forDept:resultDepts)
		// {
		// resultDept += forDept.get("deptCode")+",";
		// }
		// resultMap.put("depts", resultDept);
		//
		// }
		return resultMap;
	}

	@Override
	public Boolean saveRenewal(Map<String, Object> paraMap) {
		paraMap.put("status", "0");// 指定状态为暂存
		try {
			paraMap.put("validInd", '1');// 状态设置为有效

			String userCode = CurrentUser.getUser().getUserCode();

			if (paraMap.get("noticId") == null || paraMap.get("noticId").equals("undefined")) {
				fillParamMap(paraMap, "insert");
				paraMap.put("noticId", UUIDGenerator.getUUID());
				paraMap.put("publisher", userCode);
				dao.insert(RENEWAL + INSERT, paraMap);
			} else {
				fillParamMap(paraMap, "update");
				dao.update(RENEWAL + UPDATE_PK, paraMap);
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public Boolean deleteRenewalByIds(String[] noticIdArray) throws ParseException {

		if (noticIdArray == null || noticIdArray.length == 0)
			return false;

		for (String noticeId : noticIdArray) {
			Map<String, Object> paraMap = new HashMap<String, Object>();

			paraMap.put("renewalId", noticeId); // 状态设置为有效

			// fillParamMap(paraMap, "update");
			dao.update(RENEWAL + "deleteByPrimaryKey", paraMap);

		}
		return true;
	}

	@Override
	public boolean updateRenewalById(Renewal renewal) {

		RenewalAssignRecord rarecord = new RenewalAssignRecord();
		rarecord.setAssignLevel(renewal.getAssignLevel());
		rarecord.setRenewalDeptCode(renewal.getRenewalBusiDept());
		rarecord.setRenewalGroupCode(renewal.getRenewalGroupCode());
		rarecord.setRenewalSalesman(renewal.getRenewalSalesmanCode());

		//
		String renewalIds = renewal.getRenewalId();

		if (renewalIds.split(",") != null) {
			Renewal re = renewal;
			for (String renewalId : renewalIds.split(",")) {
				re.setRenewalId(renewalId);
				re.setUpdateDate(new Timestamp(new Date().getTime()));
				re.setUpdateUser(CurrentUser.getUser().getUserCode());
				dao.update(RENEWAL + ".updateByPrimaryKeySelective", re);

				rarecord.setRenewalId(renewal.getRenewalId());
				renewalAssignRecordService.saveRenewalAssignRecord(rarecord);

			}
		} else {
			renewal.setUpdateDate(new Timestamp(new Date().getTime()));
			renewal.setUpdateUser(CurrentUser.getUser().getUserCode());

			dao.update(RENEWAL + ".updateByPrimaryKeySelective", renewal);

			renewalAssignRecordService.saveRenewalAssignRecord(rarecord);

		}

		return false;
	}

	@Override
	public Renewal queryRenewalById(String renewalId) {
		Renewal renewal = dao.selectOne(RENEWAL + QUERY_ONE_VO, renewalId);
		return renewal;
	}

	private void fillParamMap(Map<String, Object> paraMap, String action) throws ParseException {
		String userCode = CurrentUser.getUser().getUserCode();

		if (action.equals("insert")) {
			paraMap.put("createdUser", userCode);
			paraMap.put("updatedUser", userCode);

			trunToDate(paraMap);

		} else if (action.equals("update")) {
			paraMap.put("updatedUser", userCode);

			trunToDate(paraMap, "update");
		}

	}

	public static void trunToDate(Map<String, Object> paraMap, String update) throws ParseException {
		// if (1==1) return;
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

		if ("update".equalsIgnoreCase(update)) {
			String updateDateS = (String) paraMap.get("updatedDate");

			if (updateDateS == null || (updateDateS.trim().equals(""))) {
				paraMap.put("updatedDate", new Timestamp(new Date().getTime()));
			} else {
				long tt = sf.parse(updateDateS).getTime();
				Timestamp updateDate = new Timestamp(tt);
				paraMap.put("updatedDate", updateDate);
			}

		} else {
			trunToDate(paraMap);
		}

	}

	public static void trunToDate(Map<String, Object> paraMap) throws ParseException {
		// if (1==1) return;
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		String createDateS = (String) paraMap.get("createdDate");

		if (createDateS == null || (createDateS.trim().equals(""))) {
			paraMap.put("createdDate", new Timestamp(new Date().getTime()));
		} else {
			long tt = sf.parse(createDateS).getTime();
			Timestamp createDate = new Timestamp(tt);
			paraMap.put("createdDate", createDate);
		}

		String updateDateS = (String) paraMap.get("updatedDate");

		if (updateDateS == null || (updateDateS.trim().equals(""))) {
			paraMap.put("updatedDate", new Timestamp(new Date().getTime()));
		} else {
			long tt = sf.parse(updateDateS).getTime();
			Timestamp updateDate = new Timestamp(tt);
			paraMap.put("updatedDate", updateDate);
		}

	}

	@Override
	public PageDto queryDataToExcel(PageDto pageDto) {
		Long total = dao.selectOne(RENEWAL + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		pageDto.setLimit(total.toString());
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", total);
		List<Map<String, Object>> rows = dao.selectList(RENEWAL + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}
}
