package com.sinosafe.xszc.main.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.USER_ACCESS;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.main.service.UserAccessRecordService;
import com.sinosafe.xszc.main.vo.UserAccessRecord;
import com.sinosafe.xszc.util.PageDto;

public class UserAccessRecordServiceImpl implements UserAccessRecordService{
	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findUserAccessRecordToPage(PageDto pageDto) {
		try {
			Long total = dao.selectOne(USER_ACCESS + ".queryListPageCount", pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> list = dao.selectList(USER_ACCESS + ".queryListPage", pageDto.getWhereMap());
			pageDto.setRows(list);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}
	
	/**
	 * 简要说明: 查询数据访问报表<br><pre>
	 * 方法queryDataVisitReport的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年8月17日 下午2:31:55 </pre>
	 */
	@Override
	public List<Map<String,Object>> queryDataVisitReport(Map<String,Object> whereMap){
		List<Map<String,Object>> countList = dao.selectList(USER_ACCESS + ".queryDataVisitReport",whereMap);
		return countList;
	}
	
	/**
	 * 简要说明: 查询页面访问报表<br><pre>
	 * 方法queryPageVisitReport的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年8月17日 下午2:31:55 </pre>
	 */
	@Override
	public List<Map<String,Object>> queryPageVisitReport(Map<String,Object> whereMap){
		List<Map<String,Object>> countList = dao.selectList(USER_ACCESS + ".queryPageVisitReport",whereMap);
		return countList;
	}
	
	/**
	 * 简要说明: 查询用户访问报表<br><pre>
	 * 方法queryPageVisitReport的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年8月17日 下午2:31:55 </pre>
	 */
	@Override
	public PageDto queryUserVisitReport(PageDto pageDto){
		try {
			Long total = dao.selectOne(USER_ACCESS + ".queryUserVisitReportCount", pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String,Object>> countList = dao.selectList(USER_ACCESS + ".queryUserVisitReport",pageDto.getWhereMap());
			pageDto.setRows(countList);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}

	/**
	 * 说明:判断是否在在<br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月2日 下午4:31:22
	 */
	@Override
	public boolean isExist(String pkId) {
		Map<String,Object> whereMap = new HashMap<String,Object>();
		whereMap.put("pkId", pkId);
		long count = (Long) dao.selectOne(USER_ACCESS + ".queryCount", whereMap );
		return count > 0;
	}

	/**
	 * 简要说明: 通过销售人员判断是否存在<br>
	 * 方法isExistByWhere的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月2日 下午4:20:56
	 * </pre>
	 */
	public boolean isExistByWhere(Map<String, Object> whereMap) {
		long count = (Long) dao.selectOne(USER_ACCESS + ".queryCount", whereMap);
		return count > 0;
	}

	/**
	 * 保存访问记录<br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月21日 上午11:56:32 </pre>
	 * @see com.sinosafe.xszc.main.service.UserAccessRecordService#saveOrUpdateByWhere(com.sinosafe.xszc.main.vo.UserAccessRecord)
	 */
	@Override
	public boolean saveOrUpdateByWhere(UserAccessRecord uar) {
		boolean flag = false;
		// 判断数据库是否存在，存在作修改,不存在作添加
		if (this.isExist(uar.getPkId())) {
			dao.update(USER_ACCESS + UPDATE_PK_VO, uar);
			flag = true;
		} else {
			dao.insert(USER_ACCESS + INSERT_VO, uar);
			flag = true;
		}
		return flag;
	}
}
