package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.LAW_TARGET;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.law.service.LawTargetService;
import com.sinosafe.xszc.law.vo.LawTarget;
import com.sinosafe.xszc.util.PageDto;

public class LawTargetServiceImpl implements LawTargetService {

	//private static final Log log = LogFactory.getLog(LawTargetServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findLawTargetByWhere(PageDto pageDto) {
		Long total = dao.selectOne(LAW_TARGET + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_TARGET + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void saveLawTarget(LawTarget... lawTarget) {
		String currentUser = CurrentUser.getUser().getUserCode();
		if (lawTarget != null && lawTarget.length > 0) {
			for (int i = 0; i < lawTarget.length; i++) {
				//根据流水号查询是否存在
				List<Map<String, Object>> rows = dao.selectList(LAW_TARGET + ".selectByPrimaryKey", lawTarget[i].getSerno());
				//存在则修改，否则新增
				if(rows.size() > 0){
					lawTarget[i].setLastOpt(currentUser);
					dao.update(LAW_TARGET + UPDATE_VO, lawTarget[i]);
				}else{
					lawTarget[i].setLastOpt(currentUser);
					dao.insert(LAW_TARGET + INSERT_VO, lawTarget[i]);
				}
			}
		} else {
			throw new RuntimeException("没有要保存的版本定义，参数为null或长度为0");
		}
		
	}

	@Override
	public Long getSerialNumber(LawTarget... lawTarget) {
		// TODO Auto-generated method stub
		Long total = dao.selectOne(LAW_TARGET +".serialNumber", lawTarget);
		return total;
	}

	@Override
	public List<Map<String, Object>> queryLawTargetToUpdate(String serno) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> rows = dao.selectList(LAW_TARGET + ".selectByPrimaryKey",serno);
		return rows;
	}

	@Override
	public void deleteLawTarget(LawTarget lawTarget) {
		// TODO Auto-generated method stub
		dao.delete(LAW_TARGET + ".deleteByPrimaryKeyVo", lawTarget);
	}

	@Override
	public Boolean queryIndexCode(String indexCode) {
		// TODO Auto-generated method stub
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("indexCode", indexCode);
		Long total = dao.selectOne(LAW_TARGET + QUERY_COUNT, map);
		if(total > 0){
			return true;
		}else{
			return false;
		}
	}
	@Override
	public LawTarget selectByPrimaryKey(LawTarget lawTarget) {
		LawTarget lt= (LawTarget)dao.selectOne(LAW_TARGET + QUERY_ONE_VO, lawTarget.getSerno());
		return lt;
	}
	@Override
	public LawTarget queryLawTargetByVo(LawTarget lawTarget) {
		LawTarget lawTargets = this.selectByPrimaryKey(lawTarget);
		return lawTargets;
	}

	@Override
	public List<Map<String, Object>> queryCodeAndName( Map<String, Object> indexMap) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(LAW_TARGET+".queryCodeAndName", indexMap);
		return resultList;
	}

}
