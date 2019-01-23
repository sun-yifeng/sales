package com.sinosafe.xszc.renewal.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.RENEWAL_LEVEL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.renewal.service.RenewalLevelService;
import com.sinosafe.xszc.renewal.vo.RenewalLevel;
import com.sinosafe.xszc.util.PageDto;

/**
 *
 * 类名:com.sinosafe.xszc.renewal.service.impl.RenewalLevelServiceImpl <pre>
 * 描述:续保级别设置
 * 基本思路:
 * 特别说明:
 * 编写者:mg
 * 创建时间:2014年6月19日 上午11:03:48
 * 修改说明: 类的修改说明
 * </pre>
 */
public class RenewalLevelServiceImpl implements RenewalLevelService
{

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public PageDto findRenewalLevelByWhere(PageDto pageDto, String action)
	{
		// 这里加入了, dept_code 的 条件,而且这两个参数不能为空.
		String querysqlcount = "";
		String querysql = "";

		querysqlcount = RENEWAL_LEVEL + ".queryCount";
		querysql = RENEWAL_LEVEL + ".queryListPage";

		Long total = dao.selectOne(querysqlcount, pageDto.getWhereMap());
		pageDto.setTotal(total);

		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1)
		{
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		}
		else
		{
			pageDto.getWhereMap().put("startpoint", 1);
		}

		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(querysql, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Map<String, Object> findRenewalLevelDetailByWhere(Map<String, Object> whereMap)
	{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> resultList = dao.selectList(RENEWAL_LEVEL + QUERY, whereMap);
		// 这里部门名字要换中文呀.

		//		if (resultList != null && resultList.size() > 0)
		//		{
		//			resultMap = resultList.get(0);
		//			// notice dept
		//			String noticId = (String)resultMap.get("noticId");
		//			List<Map<String,Object>> resultDepts = dao.selectList(NOTICE_DEPT+ QUERY, whereMap);
		//			String resultDept="";
		//			for (Map<String,Object> forDept:resultDepts)
		//			{
		//				resultDept += forDept.get("deptCode")+",";
		//			}
		//			resultMap.put("depts", resultDept);
		//			
		//		}
		return resultMap;
	}

	@Override
	public Boolean saveRenewalLevel(Map<String, Object> paraMap)
	{
		paraMap.put("status", "0");//指定状态为暂存
		boolean result = false;
		try
		{
			paraMap.put("validInd", '1');//状态设置为有效

			String userCode = CurrentUser.getUser().getUserCode();

			if (paraMap.get("noticId") == null || paraMap.get("noticId").equals("undefined"))
			{
				fillParamMap(paraMap, "insert");
				paraMap.put("renewallevelId", UUIDGenerator.getUUID());
				dao.insert(RENEWAL_LEVEL + INSERT, paraMap);
			}
			else
			{
				fillParamMap(paraMap, "update");
				dao.update(RENEWAL_LEVEL + UPDATE_PK, paraMap);
			}
			return true;
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public Boolean deleteRenewalLevelByIds(String[] noticIdArray) throws ParseException
	{

		if (noticIdArray == null || noticIdArray.length == 0)
			return false;

		for (String noticeId : noticIdArray)
		{
			Map<String, Object> paraMap = new HashMap<String, Object>();

			paraMap.put("renewallevelId", noticeId); //状态设置为有效

			//fillParamMap(paraMap, "update");				
			dao.update(RENEWAL_LEVEL + ".deleteByPrimaryKey", paraMap);

		}
		return true;
	}
	
	@Override
	public boolean RenewalLevelValidate(String deptCode) {
		
		Integer count = dao.selectOne(RENEWAL_LEVEL + ".queryCountByDept", deptCode);
		if(count>0)
			return false;
		else
			return true;
		
	}
	
	@Override
	public int findRenewalLevelRoleByUser(Map<String,Object> map) {
		Integer count = dao.selectOne(RENEWAL_LEVEL + ".queryUserLevel", map);
		return count;
	}

	//-------------------------------
	private void fillParamMap(Map<String, Object> paraMap, String action) throws ParseException
	{
		String userCode = CurrentUser.getUser().getUserCode();

		if (action.equals("insert"))
		{
			paraMap.put("createdUser", userCode);
			paraMap.put("updatedUser", userCode);

			trunToDate(paraMap);

		}
		else if (action.equals("update"))
		{
			paraMap.put("updatedUser", userCode);

			trunToDate(paraMap, "update");
		}

	}

	/**
	 * 
	 * 将查数里面的时间转为日期型
	 * 编写者：maguang
	 * 创建时间：2014-7-22 </pre>
	 * 方法trunToDate的详细说明
	 * @param 参数类型
	 * filterPara 过滤条件参数
	 * @return String 说明
	 * @throws 异常类型
	 * @param paraMap
	 * @throws ParseException
	 */
	public static void trunToDate(Map<String, Object> paraMap, String update) throws ParseException
	{
		//if (1==1) return;
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

		if ("update".equalsIgnoreCase(update))
		{
			String updateDateS = (String) paraMap.get("updatedDate");

			if (updateDateS == null || (updateDateS.trim().equals("")))
			{
				paraMap.put("updatedDate", new Timestamp(new Date().getTime()));
			}
			else
			{
				long tt = sf.parse(updateDateS).getTime();
				Timestamp updateDate = new Timestamp(tt);
				paraMap.put("updatedDate", updateDate);
			}

		}
		else
		{
			trunToDate(paraMap);
		}

	}

	/**
	 * 
	 * 将查数里面的时间转为日期型
	 * 编写者：maguang
	 * 创建时间：2014-7-22 </pre>
	 * 方法trunToDate的详细说明
	 * @param 参数类型
	 * filterPara 过滤条件参数
	 * @return String 说明
	 * @throws 异常类型
	 * @param paraMap
	 * @throws ParseException
	 */
	public static void trunToDate(Map<String, Object> paraMap) throws ParseException
	{
		//if (1==1) return;

		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		String createDateS = (String) paraMap.get("createdDate");

		if (createDateS == null || (createDateS.trim().equals("")))
		{
			paraMap.put("createdDate", new Timestamp(new Date().getTime()));
		}
		else
		{
			long tt = sf.parse(createDateS).getTime();
			Timestamp createDate = new Timestamp(tt);
			paraMap.put("createdDate", createDate);
		}

		String updateDateS = (String) paraMap.get("updatedDate");

		if (updateDateS == null || (updateDateS.trim().equals("")))
		{
			paraMap.put("updatedDate", new Timestamp(new Date().getTime()));
		}
		else
		{
			long tt = sf.parse(updateDateS).getTime();
			Timestamp updateDate = new Timestamp(tt);
			paraMap.put("updatedDate", updateDate);
		}

	}

}
