package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_INDEX_CALC;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_RANK_CALC;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.law.service.TRankCalcService;
import com.sinosafe.xszc.law.vo.TRankCalc;
import com.sinosafe.xszc.util.PageDto;

public class TRankCalcServiceImpl implements TRankCalcService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Override
	public PageDto findTRankCalcByWhere(PageDto pageDto) {
		Long total = dao.selectOne(T_RANK_CALC + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(T_RANK_CALC + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void saveTRankCalc(TRankCalc... tRankCalc) {
		String currentUser = CurrentUser.getUser().getUserCode();
		if (tRankCalc != null && tRankCalc.length > 0) {
			for (int i = 0; i < tRankCalc.length; i++) {
				//根据流水号查询是否存在
				List<Map<String, Object>> rows = dao.selectList(T_RANK_CALC + ".selectByPrimaryKey", tRankCalc[i].getSerno());
				//存在则修改，否则新增
				if(rows.size() > 0){
					tRankCalc[i].setLastOpt(currentUser);
					dao.update(T_RANK_CALC + UPDATE_VO, tRankCalc[i]);
				}else{
					tRankCalc[i].setLastOpt(currentUser);
					dao.insert(T_RANK_CALC + INSERT_VO, tRankCalc[i]);
				}
			}
		} else {
			throw new RuntimeException("没有要保存的版本定义，参数为null或长度为0");
		}
		
	}

	@Override
	public Object getSerialNumber(TRankCalc... tRankCalc) {
		Long total = dao.selectOne(T_RANK_CALC +".serialNumber", tRankCalc);
		return total;
	}

	@Override
	public List<Map<String, Object>> queryTRankCalcToUpdate(String serno) {
		List<Map<String, Object>> rows = dao.selectList(T_RANK_CALC + ".selectByPrimaryKey",serno);
		return rows;
	}

	@Override
	public void deleteTRankCalc(TRankCalc tRankCalc) {
		dao.delete(T_RANK_CALC + ".deleteByPrimaryKeyVo", tRankCalc);
		
	}

}
