package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_RANK_DEF;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSON;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.StringUtil;
import com.sinosafe.xszc.law.service.TRankDefService;
import com.sinosafe.xszc.law.vo.TRankDef;
import com.sinosafe.xszc.util.PageDto;

public class TRankDefServiceImpl implements TRankDefService {

	private static final Log log = LogFactory.getLog(TRankDefServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findLawRankByWhere(PageDto pageDto) {
		log.debug("TRankDefServiceImpl  findLawRankByWhere start.....");
		Long total = dao.selectOne(T_RANK_DEF + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(T_RANK_DEF + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		log.debug("TRankDefServiceImpl  findLawRankByWhere end.....");
		return pageDto;
	}

	@Override
	public void saveLawRank(TRankDef... tRankDef) {
		String currentUser = CurrentUser.getUser().getUserCode();
		if (tRankDef != null && tRankDef.length > 0) {
			for (int i = 0; i < tRankDef.length; i++) {
				// 根据流水号查询是否存在
				List<Map<String, Object>> rows = dao.selectList(T_RANK_DEF + ".selectByPrimaryKey", tRankDef[i].getPkId());
				// 存在则修改，否则新增
				if (rows.size() > 0) {
					tRankDef[i].setLastOpt(currentUser);
					dao.update(T_RANK_DEF + UPDATE_VO, tRankDef[i]);
				} else {
					tRankDef[i].setLastOpt(currentUser);
					dao.insert(T_RANK_DEF + INSERT_VO, tRankDef[i]);
				}
			}
		} else {
			throw new RuntimeException("没有要保存的版本定义，参数为null或长度为0");
		}
	}

	@Override
	public List<Map<String, Object>> queryLawRankToUpdate(String serno) {
		List<Map<String, Object>> rows = dao.selectList(T_RANK_DEF + ".selectByPrimaryKey", serno);
		return rows;
	}

	@Override
	public Long getSerialNumber(TRankDef... tRankDef) {
		Long total = dao.selectOne(T_RANK_DEF + ".serialNumber", tRankDef);
		return total;
	}

	@Override
	public void deleteLawRank(TRankDef tRankDef) {
		// TODO Auto-generated method stub
		dao.delete(T_RANK_DEF + ".deleteByPrimaryKeyVo", tRankDef);
	}

	@Override
	public Boolean queryRankCode(String rankCode) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rankCode", rankCode);
		Long total = dao.selectOne(T_RANK_DEF + QUERY_COUNT, map);
		if (total > 0) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public List<Map<String, Object>> queryRankByLineCode(Map<String, Object> rankMap) {
		List<Map<String, Object>> resultList = dao.selectList(T_RANK_DEF + ".queryRankByLineCode", rankMap);
		return resultList;
	}
	
	@Override
	public String queryRankNameByRankCode(String rankCode) {
		String result = dao.selectOne(T_RANK_DEF + ".queryRankNameByRankCode", rankCode);
		return result;
	}
	
	@Override
	public List<Map<String, Object>> queryManagerRankByLineCode(Map<String, Object> rankMap) {
		List<Map<String, Object>> resultList = dao.selectList(T_RANK_DEF + ".queryManagerRankByLineCode", rankMap);
		return resultList;
	}

	@Override
	public List<Map<String, Object>> queryConfirmRank(Map<String, Object> rankMap) {
		List<Map<String, Object>> resultList = null;
		//先判断该销售人员的当前职级
		Map<String, Object> rankType = dao.selectOne(T_RANK_DEF + ".queryCurrentRank", rankMap.get("rankCode").toString());
		Map<String, Object> reviewRank = dao.selectOne(T_RANK_DEF + ".queryReviewRank", rankMap.get("rankId").toString());
		String resultRank =  reviewRank.get("result").toString();
		if(rankMap.get("curDeptCode").toString().equals("00")){
			rankMap.put("recommendRank", reviewRank.get("r_rank"));
			if(rankType.get("managerFlag").equals("0")){
				resultList = dao.selectList(T_RANK_DEF + ".queryConfirmRankCus", rankMap);
			}else if(rankType.get("managerFlag").equals("1")){
				resultList = dao.selectList(T_RANK_DEF + ".queryConfirmRankTeam", rankMap);
			}else{
				resultList = null;
			}
		}else{
			if(StringUtil.isNotEmpty(resultRank) && !resultRank.equals("T")){
				rankMap.put("recommendRank", reviewRank.get("r_rank"));
				if(rankType.get("managerFlag").equals("0")){
					resultList = dao.selectList(T_RANK_DEF + ".queryConfirmRankCus", rankMap);
				}else if(rankType.get("managerFlag").equals("1")){
					resultList = dao.selectList(T_RANK_DEF + ".queryConfirmRankTeam", rankMap);
				}else{
					resultList = null;
				}
			}
		}
		return resultList;
	}
	
	@Override
	public List<Map<String, Object>> queryCusAdjustRank(Map<String, Object> rankMap) {
		List<Map<String, Object>> resultList = null;
		Map<String, Object> reviewRank = dao.selectOne(T_RANK_DEF + ".queryReviewRank", rankMap.get("rankId").toString());
		String curDeptCode = rankMap.get("curDeptCode").toString();
		String rank = "";
		if(!reviewRank.get("c_rank").toString().equals("---")){
			rank = reviewRank.get("c_rank").toString();
		}
		if(curDeptCode.equals("00")){
			rankMap.put("recommendRank", reviewRank.get("c_rank"));
			resultList = dao.selectList(T_RANK_DEF + ".queryConfirmRankCus", rankMap);
		}else{
			if(!rank.equals("T") && StringUtil.isNotEmpty(rank)){
				rankMap.put("recommendRank", reviewRank.get("c_rank"));
				resultList = dao.selectList(T_RANK_DEF + ".queryConfirmRankCus", rankMap);
			}else{
				resultList = null;
			}
		}
		return resultList;
	}

	@Override
	public Map<String, Object> generateRankCode(TRankDef rankDef) {
		// 生成基本法代码
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("deptCode", rankDef.getDeptCode());
		param.put("lineCode", rankDef.getLineCode());
		param.put("managerFlag", rankDef.getManagerFlag());
		param.put("mapRank", rankDef.getMapRank());
		param.put("rankCode", "");
		log.debug("生成职级代码提交的参数:" + JSON.toJSONString(param));
		dao.selectOne(T_RANK_DEF + ".generateRankCode", param);
		return param;
	}

}
