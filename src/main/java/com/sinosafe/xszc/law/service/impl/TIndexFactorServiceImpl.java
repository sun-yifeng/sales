package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_INDEX_FACTOR;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.law.service.TIndexFactorService;
import com.sinosafe.xszc.law.vo.TIndexFactor;
import com.sinosafe.xszc.util.PageDto;

public class TIndexFactorServiceImpl implements TIndexFactorService{
	
	private static final Log log = LogFactory.getLog(TIndexFactorServiceImpl.class);
	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findTIndexFactorByWhere(PageDto pageDto) {
		log.debug("TIndexFactorServiceImpl  findTIndexFactorByWhere start.....");
		Long total = dao.selectOne(T_INDEX_FACTOR + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(T_INDEX_FACTOR + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		log.debug("TIndexFactorServiceImpl  findTIndexFactorByWhere end.....");
		return pageDto;
	}

	@Override
	public void savetIndexFactor(TIndexFactor... tIndexFactor) {
		// TODO Auto-generated method stub
		String currentUser = CurrentUser.getUser().getUserCode();
		if (tIndexFactor != null && tIndexFactor.length > 0) {
			for (int i = 0; i < tIndexFactor.length; i++) {
				//根据流水号查询是否存在
				List<Map<String, Object>> rows = dao.selectList(T_INDEX_FACTOR + ".selectByPrimaryKey", tIndexFactor[i].getSerno());
				//存在则修改，否则新增
				if(rows.size() > 0){
					tIndexFactor[i].setLastOpt(currentUser);
					dao.update(T_INDEX_FACTOR + UPDATE_VO, tIndexFactor[i]);
				}else{
					tIndexFactor[i].setLastOpt(currentUser);
					dao.insert(T_INDEX_FACTOR + INSERT_VO, tIndexFactor[i]);
				}
			}
		} else {
			throw new RuntimeException("没有要保存的版本定义，参数为null或长度为0");
		}
	}

	@Override
	public Long getSerialNumber(TIndexFactor... tIndexFactor) {
		// TODO Auto-generated method stub
		Long total = dao.selectOne(T_INDEX_FACTOR +".serialNumber", tIndexFactor);
		return total;
	}

	@Override
	public List<Map<String, Object>> queryTIndexFactorToUpdate(String serno) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> rows = dao.selectList(T_INDEX_FACTOR + ".selectByPrimaryKey",serno);
		return rows;
	}

	@Override
	public void deleteTIndexFactor(TIndexFactor tIndexFactor) {
		// TODO Auto-generated method stub
		dao.delete(T_INDEX_FACTOR + ".deleteByPrimaryKeyVo", tIndexFactor);
	}

}
