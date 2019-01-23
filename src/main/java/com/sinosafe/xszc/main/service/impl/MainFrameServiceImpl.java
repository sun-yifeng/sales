package com.sinosafe.xszc.main.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MAIN_RESOURCE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.SALESMAN;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.core.context.PlatformContext;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.group.service.SalesmanService;
import com.sinosafe.xszc.main.service.MainFrameService;
import com.sinosafe.xszc.util.PageDto;

public class MainFrameServiceImpl implements MainFrameService {
	
	private static Logger log = Logger.getLogger(MainFrameServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier("SalesmanService")
	private SalesmanService salesmanService;
	
	@Autowired
	@Qualifier("umService")
	private UmService umService;

	@Override
	public List<Map<String, Object>> findSystemMenus(Map<String, Object> whereMap) {
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		// 查询系统一级系统管理员是否有对应的用户
		Long l = (Long) dao.selectOne(MAIN_RESOURCE + ".querySysManager", whereMap);
		if (l.longValue() == 0) {
			// 查询系统用户是否有对应的用户
			l = dao.selectOne(MAIN_RESOURCE + ".querySysUser", whereMap);
			if (l.longValue() == 0) {
				// 系统用户都没有返回空的集合；
				return result;
			} else {
				result = dao.selectList(MAIN_RESOURCE + ".querySysUserMenus", whereMap);
				return result;
			}
		} else {
			result = dao.selectList(MAIN_RESOURCE + ".querySystemMenus", whereMap);
			return result;
		}
	}

	@Override
	public List<Map<String, Object>> findSystemMenus(String userCode, String sysCode) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("sysCode", sysCode);
		whereMap.put("userCode", userCode);
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		// 查询系统一级系统管理员是否有对应的用户
		Long l = (Long) dao.selectOne(MAIN_RESOURCE + ".querySysManager", whereMap);
		if (l.longValue() == 0l) {
			// 查询系统用户是否有对应的用户
			l = dao.selectOne(MAIN_RESOURCE + ".querySysUser", whereMap);
			if (l.longValue() == 0l) {
				// 系统用户都没有返回空的集合；
				return result;
			} else {
				result = dao.selectList(MAIN_RESOURCE + ".querySysUserMenus", whereMap);
				return result;
			}
		} else {
			result = dao.selectList(MAIN_RESOURCE + ".querySystemMenus", whereMap);
			return result;
		}
	}

	@Override
	public long findSalesmanCount(Map<String, Object> whereMap) {
		//======================判断是否要过滤信保数据=开始=======================
		boolean xbFlag = false;
		List<Map<String,Object>> roeList = this.getUmRole();
		for (Map<String, Object> map : roeList) {
			if(map.get("roleEname").equals("xszcAdmin")){
				xbFlag = true;
			}
		}
		
		if(!xbFlag){
			whereMap.put("xbFilter", "true");
		}else{
			whereMap.put("xbFilter", "false");
		}
		//======================判断是否要过滤信保数据=结束=======================
		return (Long) dao.selectOne(MAIN_RESOURCE + ".findSalesmanCount", whereMap);
	}

	@Override
	public long findMediumCount(Map<String, Object> whereMap) {
		return (Long) dao.selectOne(MAIN_RESOURCE + ".findMediumCount", whereMap);
	}

	@Override
	public long findAgentCount(Map<String, Object> whereMap) {
		return (Long) dao.selectOne(MAIN_RESOURCE + ".findAgentCount", whereMap);
	}

	@Override
	public long findConferMediumCount(Map<String, Object> whereMap) {
		return (Long) dao.selectOne(MAIN_RESOURCE + ".findConferMediumCount", whereMap);
	}

	@Override
	public long findConferAgentCount(Map<String, Object> whereMap) {
		return (Long) dao.selectOne(MAIN_RESOURCE + ".findConferAgentCount", whereMap);
	}

	@Override
	public long findNoticeCount(Map<String, Object> whereMap) {
		return (Long) dao.selectOne(MAIN_RESOURCE + ".findNoticeCount", whereMap);
	}

	/**
	 * 销售人员提示列表<br>
	 * 编写者:卢水发 创建时间:2015年6月24日 下午3:26:36 </pre>
	 */
	public PageDto findSalesmanTipList(PageDto pageDto) {
		try {
			Long total = (Long) dao.selectOne(MAIN_RESOURCE + ".findSalesmanCount", pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint",pageDto.getEnd());
			List<Map<String, Object>> list = dao.selectList(MAIN_RESOURCE + ".findSalesmanTipList", pageDto.getWhereMap());
			pageDto.setRows(this.getMultiDeptInfo(list));
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}

	private List<Map<String, Object>> getMultiDeptInfo(List<Map<String, Object>> list) {
		for (Map<String, Object> map : list) {
			Map<String, Object> deptMap = new HashMap<String, Object>();
			String deptCode = (String) map.get("DEPTCODE");
			// 由于HR人员的的机构代码，有的是4位，有的两位，有的是00，所以在代码中特殊处理
			if (deptCode.length() == 8) {
				deptMap = dao.selectOne(SALESMAN + ".getMultiDeptInfo", deptCode);
			} else if (deptCode.length() == 4) {
				deptMap = dao.selectOne(SALESMAN + ".getMultiDeptMark", deptCode);
			} else if (deptCode.length() == 2) {
				deptMap = dao.selectOne(SALESMAN + ".getMultiDeptProd", deptCode);
			} else {
			}
			map.put("deptCodeFour", deptCode);
			if (deptMap != null) {
				map.put("deptNameFour", deptMap.get("deptNameFour"));
				map.put("deptCodeThree", deptMap.get("deptCodeThree"));
				map.put("deptNameThree", deptMap.get("deptNameThree"));
				map.put("deptCodeTwo", deptMap.get("deptCodeTwo"));
				map.put("deptNameTwo", deptMap.get("deptNameTwo"));
			}
		}
		return list;
	}

	/**
	 * 公告提醒 列表<br>
	 * 编写者:卢水发 创建时间:2015年6月24日 下午3:26:36 </pre>
	 * @see com.sinosafe.xszc.main.service.MainFrameService#getMediumValidList(com.sinosafe.xszc.util.PageDto)
	 */
	public PageDto findNoticeTipList(PageDto pageDto) {
		try {
			List<Map<String, Object>> list = dao.selectList(MAIN_RESOURCE + ".findNoticeTipList", pageDto.getWhereMap());
			pageDto.setRows(list);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}
	
	/**
	 * 中介机构许可证到期列表<br>
	 * 编写者:卢水发 创建时间:2015年6月24日 下午3:26:36 </pre>
	 * 
	 * @param 参数名 说明
	 * @return 返回值类型 说明
	 * @throws 异常类型 说明
	 * @see com.sinosafe.xszc.main.service.MainFrameService#getMediumValidList(com.sinosafe.xszc.util.PageDto)
	 */
	public PageDto getMediumValidList(PageDto pageDto) {
		try {
			Long total = (Long) dao.selectOne(MAIN_RESOURCE + ".findMediumCount", pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> list = dao.selectList(MAIN_RESOURCE + ".queryMediumValidList", pageDto.getWhereMap());
			pageDto.setRows(list);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}

	/**
	 * 简要说明:查出个人代理人执业证书将于七日内到期的列表 <br>
	 * <pre>
	 * 编写者:卢水发
	 * 创建时间:2015年6月24日 下午3:26:36
	 * </pre>
	 */
	public PageDto getAgentValidList(PageDto pageDto) {
		try {
			Long total = (Long) dao.selectOne(MAIN_RESOURCE + ".findAgentCount", pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint",pageDto.getEnd());
			List<Map<String, Object>> list = dao.selectList(MAIN_RESOURCE + ".queryAgentValidList", pageDto.getWhereMap());
			pageDto.setRows(list);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}

	/**
	 * 简要说明:查出中介机构协议过期列表 编写者:卢水发 创建时间:2015年6月24日 下午3:26:36 </pre>
	 */
	public PageDto getMediumConferValidList(PageDto pageDto) {
		try {
			Long total = (Long) dao.selectOne(MAIN_RESOURCE + ".findConferMediumCount", pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> list = dao.selectList(MAIN_RESOURCE + ".queryMediumConferValidList", pageDto.getWhereMap());
			pageDto.setRows(list);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}

	/**
	 * 简要说明:查出个人代理协议过期列表 编写者:卢水发 创建时间:2015年6月24日 下午3:26:36 </pre>
	 */
	public PageDto getAgentConferValidList(PageDto pageDto) {
		try {
			Long total = (Long) dao.selectOne(MAIN_RESOURCE + ".findConferAgentCount", pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> list = dao.selectList(MAIN_RESOURCE + ".queryAgentConferValidList", pageDto.getWhereMap());
			pageDto.setRows(list);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}
	
	/**
	 * <pre>
	 * 取登录用户在UM的角色
	 * @param request
	 * @param response
	 * @return
	 * </pre>
	 */
	@Override
	public List<Map<String,Object>> getUmRole() {
		String currentUser = CurrentUser.getUser().getUserCode();
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> roleList = umService.findRolesInSystemByUserCode(currentUser, systemCode);
		log.info("登录用户" + currentUser + "在UM分配的权限为:" + roleList);
		if (roleList == null || roleList.size() == 0) {
			throw new RuntimeException("登录用户" + currentUser + "在UM系统没有分配权限!");
		}
		return roleList;
	}
	
	/**
	 * <pre>
	 * 是否存在某个角色
	 * @param roleArray
	 * @param roleListUser
	 * @return
	 * </pre>
	 */
	@Override
	public boolean existsRole(String[] roleArray, List<Map<String, Object>> roleListUser) {
		boolean result = false;
		for (int i = 0; i < roleArray.length; i++) {
			for (int j = 0; j < roleListUser.size(); j++) {
				if (roleArray[i].equals((String) roleListUser.get(j).get("roleEname"))) {
					result = true;
					break;
				}
			}
			if (result) {
				break;
			}
		}
		return result;
	}

	@Override
	public PageDto findEmployThreeNotice(PageDto pageDto) {
		try {
			long total = dao.selectOne(MAIN_RESOURCE + ".findEmployThreeNoticeCount",pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> list = dao.selectList(MAIN_RESOURCE + ".findEmployThreeNotice", pageDto.getWhereMap());
			pageDto.setRows(list);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
		
	}

	@Override
	public long findEmployThreeNoticeCount(Map<String, Object> whereMap) {
		return (Long) dao.selectOne(MAIN_RESOURCE + ".findEmployThreeNoticeCount", whereMap);
	}

	@Override
	public PageDto findEmploySixNotice(PageDto pageDto) {
		try {
			long total = dao.selectOne(MAIN_RESOURCE + ".findEmploySixNoticeCount",pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> list = dao.selectList(MAIN_RESOURCE + ".findEmploySixNotice", pageDto.getWhereMap());
			pageDto.setRows(list);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}
	
	@Override
	public long findEmploySixNoticeCount(Map<String, Object> whereMap) {
		return (Long) dao.selectOne(MAIN_RESOURCE + ".findEmploySixNoticeCount", whereMap);
	}
}
