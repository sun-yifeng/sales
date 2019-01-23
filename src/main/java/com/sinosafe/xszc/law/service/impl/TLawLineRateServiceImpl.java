package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_LAW_LINE_RATE;
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
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.law.service.TLawLineRateService;
import com.sinosafe.xszc.law.vo.TLawLineRate;
import com.sinosafe.xszc.util.PageDto;

public class TLawLineRateServiceImpl implements TLawLineRateService{

	private static final Log log = LogFactory.getLog(TLawLineRateServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findTLawLineRateByWhere(PageDto pageDto) {
		log.debug("TLawLineRateServiceImpl  findTLawLineRateByWhere start.....");
		Long total = dao.selectOne(T_LAW_LINE_RATE + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(T_LAW_LINE_RATE + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		log.debug("TLawLineRateServiceImpl  findTLawLineRateByWhere end.....");
		return pageDto;
	}
//tLawLineRate[i].getLineRateId() != null && (tLawLineRate[i].getLineRateId() !=""||!tLawLineRate[i].getLineRateId() .equals(""))
	@Override
	public void saveTLawLineRate(TLawLineRate... tLawLineRate) {
			// TODO Auto-generated method stub
			if (tLawLineRate != null && tLawLineRate.length > 0) {
				for (int i = 0; i < tLawLineRate.length; i++) {
					//根据主键Id查询是否存在
					//String lineRateId = tLawLineRate[i].getLineRateId();
					//List<Map<String, Object>> rows =this.queryTLawLineRateToUpdate(lineRateId);
					String currentUser = CurrentUser.getUser().getUserCode();
					tLawLineRate[i].setCreatedUser(currentUser);
					tLawLineRate[i].setUpdatedUser(currentUser);
					//存在则修改，否则新增 
					if(tLawLineRate[i].getLineRateId() != null && (tLawLineRate[i].getLineRateId() !=""||!tLawLineRate[i].getLineRateId() .equals(""))){
						tLawLineRate[i].setValidInd("1");
						//tLawLineRate[i].setDeptCode2("04");
						tLawLineRate[i].setLineRateId(tLawLineRate[i].getLineRateId());
						dao.update(T_LAW_LINE_RATE + UPDATE_VO, tLawLineRate[i]);
					}else{
						tLawLineRate[i].setLineRateId(UUIDGenerator.getUUID());
						//tLawLineRate[i].setDeptCode2("04");
						tLawLineRate[i].setValidInd("1");
						dao.insert(T_LAW_LINE_RATE + INSERT_VO, tLawLineRate[i]);
					}
				}
			} else {
				throw new RuntimeException("没有要保存的业务线调整系数，参数为null或长度为0");
			}
		
	}

	@Override
	public List<Map<String, Object>> queryTLawLineRateToUpdate(String lineRateId) {
			// TODO Auto-generated method stub
			List<Map<String, Object>> rows = dao.selectList(T_LAW_LINE_RATE + ".selectByPrimaryKey", lineRateId);
			return rows;
	}

	@Override
	public void deleteTLawLineRate(String lineRateId) {
			// TODO Auto-generated method stub
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("lineRateId", lineRateId);
			map.put("updatedUser", CurrentUser.getUser().getUserCode());
			dao.update(T_LAW_LINE_RATE + DELETE_BY_ID, map);
	}

	
}
