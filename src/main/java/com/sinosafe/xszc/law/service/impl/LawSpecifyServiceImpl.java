package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.LAW_DEFINE_DEPT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.law.service.LawSpecifyService;
import com.sinosafe.xszc.law.vo.LawDefineDept;
import com.sinosafe.xszc.util.PageDto;

/**
 * @author 
 * @deprecated 废除
 *
 */
public class LawSpecifyServiceImpl implements LawSpecifyService {

	//private static final Log log = LogFactory.getLog(LawSpecifyServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findLawSpecifyByWhere(PageDto pageDto) {
		Long total = dao.selectOne(LAW_DEFINE_DEPT + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE_DEPT + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void saveLawSpecify(LawDefineDept lawDefineDept) {
		// TODO Auto-generated method stub
		String pkUuid = lawDefineDept.getPkUuid();
		String currentUser = CurrentUser.getUser().getUserCode();
		if (pkUuid != null && !"".equals(pkUuid)) {
			lawDefineDept.setUpdatedUser(currentUser);
			dao.update(LAW_DEFINE_DEPT + UPDATE_VO, lawDefineDept);
		} else {
			lawDefineDept.setPkUuid(UUIDGenerator.getUUID());
			lawDefineDept.setCreatedUser(currentUser);
			lawDefineDept.setUpdatedUser(currentUser);
			lawDefineDept.setValidInd("1");
			dao.insert(LAW_DEFINE_DEPT + INSERT_VO, lawDefineDept);
		}
	}

	@Override
	public List<Map<String, Object>> queryLawSpecifyToUpdate(String pkUuid) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE_DEPT + ".selectByPrimaryKey", pkUuid);
		return rows;
	}

	@Override
	public List<Map<String, Object>> queryLawDefineDeptToUpdate(String versionCode) {
		List<Map<String, Object>> rows = dao.selectList(LAW_DEFINE_DEPT + ".queryLawSpecifyByDept", versionCode);
		return rows;
	}

	@Override
	public void updateLawSpecifyNotValid(String deptCode) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("updatedUser", CurrentUser.getUser().getUserCode());
		m.put("deptCode", deptCode);
		dao.update(LAW_DEFINE_DEPT + ".updateLawSpecifyNotValid", m);
	}

	@Override
	public void updateLawSpecifyIsValid(String pkUuid) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("pkUuid", pkUuid);
		m.put("updatedUser", CurrentUser.getUser().getUserCode());
		dao.update(LAW_DEFINE_DEPT + ".updateLawSpecifyIsValid", m);
	}

	@Override
	public void deleteLawSpecify(String pkUuid) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pkUuid", pkUuid);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());

		dao.update(LAW_DEFINE_DEPT + DELETE_BY_ID, map);
	}

	@Override
	public void deleteLawSpecifyByVersion(String versionCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("versionCode", versionCode);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		dao.update(LAW_DEFINE_DEPT + ".deleteByVersionCode", map);
	}

	@Override
	public void updateLawSpecify(LawDefineDept lawDefineDept) {
		String currentUser = CurrentUser.getUser().getUserCode();
		lawDefineDept.setUpdatedUser(currentUser);
		dao.update(LAW_DEFINE_DEPT + ".updateLawSpecify", lawDefineDept);
	}

}
