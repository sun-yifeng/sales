package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_RANK_FACTOR;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.law.service.TRankFactorService;
import com.sinosafe.xszc.law.vo.TRankFactor;
import com.sinosafe.xszc.util.PageDto;

public class TRankFactorServiceImpl implements TRankFactorService {
	
	private static final Log log = LogFactory.getLog(TRankFactorServiceImpl.class);
	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findTRankFactorByWhere(PageDto pageDto) {
		log.debug("TRankFactorServiceImpl  findTRankFactorByWhere start.....");
		Long total = dao.selectOne(T_RANK_FACTOR + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(T_RANK_FACTOR + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		log.debug("TRankFactorServiceImpl  findTRankFactorByWhere end.....");
		return pageDto;
	}

	@Override
	public void savetTRankFactor(TRankFactor... tRankFactor) {
		// TODO Auto-generated method stub
		String currentUser = CurrentUser.getUser().getUserCode();
		if (tRankFactor != null && tRankFactor.length > 0) {
			for (int i = 0; i < tRankFactor.length; i++) {
				//根据流水号查询是否存在
				List<Map<String, Object>> rows = dao.selectList(T_RANK_FACTOR + ".selectByPrimaryKey", tRankFactor[i].getSerno());
				//存在则修改，否则新增
				if(rows.size() > 0){
					tRankFactor[i].setLastOpt(currentUser);
					dao.update(T_RANK_FACTOR + UPDATE_VO, tRankFactor[i]);
				}else{
					tRankFactor[i].setLastOpt(currentUser);
					dao.insert(T_RANK_FACTOR + INSERT_VO, tRankFactor[i]);
				}
			}
		} else {
			throw new RuntimeException("没有要保存的版本定义，参数为null或长度为0");
		}
	}

	@Override
	public Long getSerialNumber(TRankFactor... tRankFactor) {
		// TODO Auto-generated method stub
		Long total = dao.selectOne(T_RANK_FACTOR +".serialNumber", tRankFactor);
		return total;
	}

	@Override
	public List<Map<String, Object>> queryTRankFactorToUpdate(String serno) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> rows = dao.selectList(T_RANK_FACTOR + ".selectByPrimaryKey",serno);
		return rows;
	}

	@Override
	public void deleteTRankFactor(TRankFactor tRankFactor) {
		// TODO Auto-generated method stub
		dao.delete(T_RANK_FACTOR + ".deleteByPrimaryKeyVo", tRankFactor);
	}

}
