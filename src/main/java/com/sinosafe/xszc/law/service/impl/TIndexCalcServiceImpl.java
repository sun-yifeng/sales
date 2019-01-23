package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.LAW_TARGET;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_INDEX_CALC;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_INDEX_FACTOR;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.law.service.TIndexCalcService;
import com.sinosafe.xszc.law.vo.LawTarget;
import com.sinosafe.xszc.law.vo.TIndexCalc;
import com.sinosafe.xszc.law.vo.TIndexFactor;
import com.sinosafe.xszc.util.PageDto;

public class TIndexCalcServiceImpl implements TIndexCalcService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	@Override
	public PageDto findTIndexCalcByWhere(PageDto pageDto) {
			Long total = dao.selectOne(T_INDEX_CALC + QUERY_COUNT, pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> rows = dao.selectList(T_INDEX_CALC + QUERY_LIST_PAGE, pageDto.getWhereMap());
			pageDto.setRows(rows);
			return pageDto;
		}

	@Override
	public void saveTIndexCalc(TIndexCalc[] tIndexCalc) {
			String currentUser = CurrentUser.getUser().getUserCode();
			if (tIndexCalc != null && tIndexCalc.length > 0) {
				for (int i = 0; i < tIndexCalc.length; i++) {
					//根据流水号查询是否存在
					List<Map<String, Object>> rows = dao.selectList(T_INDEX_CALC + ".selectByPrimaryKey", tIndexCalc[i].getSerno());
					//存在则修改，否则新增
					if(rows.size() > 0){
						tIndexCalc[i].setLastOpt(currentUser);
						dao.update(T_INDEX_CALC + UPDATE_VO, tIndexCalc[i]);
					}else{
						tIndexCalc[i].setLastOpt(currentUser);
						dao.insert(T_INDEX_CALC + INSERT_VO, tIndexCalc[i]);
					}
				}
			} else {
				throw new RuntimeException("没有要保存的版本定义，参数为null或长度为0");
			}
			
		}

	@Override
	public Long getSerialNumber(TIndexCalc... tIndexCalc) {
		Long total = dao.selectOne(T_INDEX_CALC +".serialNumber", tIndexCalc);
		return total;
	}
	
	@Override
	public List<Map<String, Object>> queryTIndexFactorToUpdate(String serno) {
		List<Map<String, Object>> rows = dao.selectList(T_INDEX_CALC + ".selectByPrimaryKey",serno);
		return rows;
	}
	
	@Override
	public void deleteTIndexCalc(TIndexCalc tIndexCalc) {
		dao.delete(T_INDEX_CALC + ".deleteByPrimaryKeyVo", tIndexCalc);
	}

}
