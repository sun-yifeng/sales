package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.LAW_FACTOR;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.law.service.LawFactorService;
import com.sinosafe.xszc.law.vo.LawFactor;
import com.sinosafe.xszc.util.PageDto;

public class LawFactorServiceImpl implements LawFactorService {

	private static final Log log = LogFactory.getLog(LawFactorServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findLawFactorByWhere(PageDto pageDto) {
		log.debug("LawFactorServiceImpl  findLawFactorByWhere start.....");
		Long total = dao.selectOne(LAW_FACTOR + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(LAW_FACTOR + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		log.debug("LawFactorServiceImpl  findLawFactorByWhere end.....");
		return pageDto;
	}
	
	//新增因素
	@Override
	public void saveLawFactor(LawFactor... lawFactor) {
		String currentUser = CurrentUser.getUser().getUserCode();
		if (lawFactor != null && lawFactor.length > 0) {
			for (int i = 0; i < lawFactor.length; i++) {
				//根据流水号查询是否存在
				List<Map<String, Object>> rows = dao.selectList(LAW_FACTOR + ".selectByPrimaryKey", lawFactor[i].getSerno());
				//存在则修改，否则新增
				if(rows.size() > 0){
					lawFactor[i].setLastOpt(currentUser);
					dao.update(LAW_FACTOR + UPDATE_VO, lawFactor[i]);
				}else{
					lawFactor[i].setLastOpt(currentUser);
					dao.insert(LAW_FACTOR + INSERT_VO, lawFactor[i]);
				}
			}
		} else {
			throw new RuntimeException("没有要保存的版本定义，参数为null或长度为0");
		}
	}
	
	//生成流水号
	@Override
	public Long getSerialNumber(LawFactor... lawFactor) {
		// TODO Auto-generated method stub
		Long total = dao.selectOne(LAW_FACTOR +".serialNumber", lawFactor);
		return total;
	}

	@Override
	public List<Map<String, Object>> queryLawFactorToUpdate(String serno) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> rows = dao.selectList(LAW_FACTOR + ".selectByPrimaryKey",serno);
		return rows;
	}

	@Override
	public void deleteLawFactor(LawFactor lawFactor) {
		// TODO Auto-generated method stub
		dao.delete(LAW_FACTOR + ".deleteByPrimaryKeyVo", lawFactor);
	}

	@Override
	public Boolean queryItemCode(String itemCode) {
		// TODO Auto-generated method stub
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("itemCode", itemCode);
		Long total = dao.selectOne(LAW_FACTOR + QUERY_COUNT, map);
		if(total > 0){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public List<Map<String, Object>> queryCodeAndName(Map<String, Object> factorMap) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> resultList = null;
		resultList = dao.selectList(LAW_FACTOR+".queryCodeAndName", factorMap);
		return resultList;
	}

}
