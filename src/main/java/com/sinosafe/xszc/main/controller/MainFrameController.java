package com.sinosafe.xszc.main.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.core.context.PlatformContext;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.common.service.CommonServerice;
import com.sinosafe.xszc.main.service.MainFrameService;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
public class MainFrameController {
   
	private static Logger log = Logger.getLogger(MainFrameController.class);
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日  E", Locale.CHINESE);

	@Autowired
	@Qualifier("MainFrameService")
	private MainFrameService mainFrameService;

	@Autowired
	@Qualifier("umService")
	private UmService umService;
	
	@Autowired
	@Qualifier("NoticeService")
	private NoticeService noticeService;
	
	@Autowired
	@Qualifier("CommonServerice")
	private CommonServerice commonServerice;
	
	String[] roleAll = { "headDeptSalesmanCreditNew", "headDeptSalesmanManageNew", "subDeptMangerNew", "subDeptSalesmanManageNew",
			"headDeptAdminChannelNew", "headDeptCreditChannelNew", "headDeptMediumChanelNew", "subDeptManagerChannelNew", "subDeptMediumChannelNew",
			"headDeptSalesmanAgentNew", "subDeptSalesmanAgentNew","subDeptBusinessDriveNew","subDeptSalesmanXubaoNew", 
			"headDeptBusinessDriveNew","headDeptSalesmanXubaoNew","headDeptMediumNodeNew","subDeptMediumNodeChannelNew","subDeptBusinessDriveChannelNew",
			"thirdDeptManageNew", "thirdDeptBusiManageNew", "groupCaptainNew","xszcAdmin"};
	

	@RequestMapping("/main")
	public String toMainFramePage(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws GeneralException {

		long l = System.currentTimeMillis();
		Date d = new Date();
		// 加载系统扩展属性
		HttpSession session = request.getSession();
		session.setAttribute("imgUrl", umService.findSystemExtsPropertiesBySysCode("xszc").getProperty("imgUrl"));
		Map<String, Object> deptMap = umService.findDefaultDeptCodeByUserCode(CurrentUser.getUser().getUserCode());
		String defaultDeptString = "###";
		if (deptMap != null) {
			defaultDeptString = (String) deptMap.get("deptCode");
		}
		session.setAttribute("defaultDept", defaultDeptString);
		// 查询对应的系统菜单
		String userCode = CurrentUser.getUser().getUserCode();
		String sysCode = "xszc";
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("userCode", userCode);
		whereMap.put("sysCode", sysCode);
		List<Map<String, Object>> menuList = new ArrayList<Map<String, Object>>();
		try {
			menuList = mainFrameService.findSystemMenus(whereMap);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("查询用户菜单出错", e);
		}

		// 剥离一级菜单
		List<Map<String, Object>> firstMenu = this.getFirstMenuList(menuList);
		// 将一级菜单JSON存放到页面对象中;
		modelMap.put("fMenuJSON", this.getJSONArray(firstMenu));
		// 剥离二级菜单
		Map<String, List<Map<String, Object>>> secondMenu = this.getNextMenuList(menuList, firstMenu);
		// 剥离三级菜单
		Map<String, List<Map<String, Object>>> thirdMenu = new HashMap<String, List<Map<String, Object>>>();
		Iterator<List<Map<String, Object>>> vit = secondMenu.values().iterator();
		Map<String, List<Map<String, Object>>> temp = null;
		while (vit.hasNext()) {
			temp = this.getNextMenuList(menuList, vit.next());
			thirdMenu.putAll(temp);
		}
		modelMap.put("fMenu", firstMenu);
		modelMap.put("sMenu", secondMenu);
		modelMap.put("tMenu", thirdMenu);
		modelMap.put("tMenuJSON", getJSONArrayByMap(thirdMenu));
		modelMap.put("currentUser", CurrentUser.getUser().getUserCode());
		modelMap.put("currentName", CurrentUser.getUser().getUserCName());
		modelMap.put("showDate", sdf.format(d).toString());
		modelMap.put("nameLength", (CurrentUser.getUser().getUserCName().length()) * 15 + 65);
		// 运行环境
		String env = (String) PlatformContext.getGoalbalContext("com.hf.xszc.runtime.env");
		modelMap.put("env", env);
		if (log.isInfoEnabled()) {
			l = System.currentTimeMillis() - l;
			log.info("用户==>" + userCode + ",请求时间==>" + l);
		}
		return "main/mainFrame";
	}

	/**
	 * 
	 * 剥离二级菜单 <br>
	 * 
	 * @param menuList
	 * @param firstMenu
	 * @return
	 * @return List<Map<String,Object>> 说明
	 */
	private Map<String, List<Map<String, Object>>> getNextMenuList(List<Map<String, Object>> menuList, List<Map<String, Object>> nextMenu) {
		Map<String, List<Map<String, Object>>> secondMenu = new HashMap<String, List<Map<String, Object>>>();
		List<Map<String, Object>> secondMenuList = null;
		Iterator<Map<String, Object>> menuIt = null;
		Iterator<Map<String, Object>> firstIt = nextMenu.iterator();
		Map<String, Object> firstMap = null;
		Map<String, Object> menuMap = null;
		String parentId = null;
		while (firstIt.hasNext()) {
			firstMap = firstIt.next();
			menuIt = menuList.iterator();
			secondMenuList = new ArrayList<Map<String, Object>>();
			while (menuIt.hasNext()) {
				menuMap = menuIt.next();
				parentId = menuMap.get("parentId") + "";
				if (firstMap.get("resourceId").toString().equalsIgnoreCase(parentId)) {
					secondMenuList.add(menuMap);
					menuIt.remove();
				}
			}
			secondMenu.put(firstMap.get("resourceId") + "", secondMenuList);
		}
		return secondMenu;
	}

	/**
	 * 
	 * 剥离一级菜单的方法 <br>
	 * 
	 * @param menuList
	 * @return
	 * @return List<Map<String,Object>> 说明
	 * @throws 异常类型
	 */
	private List<Map<String, Object>> getFirstMenuList(List<Map<String, Object>> menuList) {
		List<Map<String, Object>> firstList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = null;
		Iterator<Map<String, Object>> it = menuList.iterator();
		while (it.hasNext()) {
			map = it.next();
			if (map.get("parentId") == null || map.get("parentId").equals("")) {
				firstList.add(map);
				it.remove();
			}
		}
		return firstList;
	}

	/**
	 * 
	 * 转换first菜单为json <br>
	 * 
	 * @param firstMenu
	 * @return
	 * @return JSONArray 说明
	 * @throws 异常类型
	 */
	private JSONArray getJSONArray(List<Map<String, Object>> firstMenu) {
		JSONArray array = new JSONArray();
		JSONObject obj = null;
		Iterator<Map<String, Object>> it = firstMenu.iterator();
		Map<java.lang.String, java.lang.Object> map = null;
		while (it.hasNext()) {
			map = it.next();
			obj = new JSONObject();
			obj.put("id", "nav-panel-" + map.get("resourceId"));
			obj.put("title", map.get("resourceName") + "");
			array.add(obj);
		}
		return array;
	}

	private JSONArray getJSONArrayByMap(Object obj) {
		JSONArray array = new JSONArray();
		array.add(JSONObject.toJSONString(obj));
		return array;
	}

	/**
	 * 在线提醒：
	 * 1.提醒分三类：人员提醒、渠道提醒、公告提醒。
	 * 2.分公司和总公司角色可见提醒框，只是不同角色所见提醒的内容不同；三级机构的角色不可见提醒框。
	 * 3.分公司、总公司人员管理岗可见人员提醒；分公司、总公司渠道管理岗可见渠道提醒；分公司、总公司角色都可见公告提醒。
	 * 4.分公司渠道部门经理可见所有提醒，总公司室主任可见所有提醒，系统管理员可见所有提醒。
	 * 5.提醒数的统计范围是登录用户所在的操作机构及子机构，操作机构是指在UM分配给用户的机构，非用户所属的行政机构。
	 * 
	 * 在线提醒:
	 * 

	 ***名销售人员未配置职级及业务线         ----> 新角色 ----> 管理员 以及 【总公司_室主任_营销管理headDeptSalesmanCreditNew、
	 *                                                总公司_人员管理岗_营销管理headDeptSalesmanManageNew、
	 *                                                分公司_部门总_营销管理subDeptMangerNew、
	 *                                                分公司_人员管理岗_营销管理subDeptSalesmanManageNew】
		
		
	 ***家中介机构的许可证将于七日内到期     ----> 新角色 ----> 管理员 以及 【总公司_管理员_渠道重客headDeptAdminChannelNew、
	 *                                                 总公司_室主任_渠道重客headDeptCreditChannelNew、
	 *                                                 总公司_中介渠道管理_渠道重客headDeptMediumChanelNew、
		                                                                                                                                             分公司_部门总_渠道重客subDeptManagerChannelNew、
		                                                                                                                                             分公司_中介渠道管理岗_渠道重客subDeptMediumChannelNew】 
		
	 ***名个人代理人执业证数将于七日内到期   ----> 新角色 ----> 管理员 以及 【总公司_室主任_营销管理headDeptSalesmanCreditNew、
	 *													总公司_个代管理岗_营销管理headDeptSalesmanAgentNew、
	 *                                                  分公司_部门总_营销管理subDeptMangerNew、
	 *                                                  分公司_个代管理_营销subDeptSalesmanAgentNew】
		
		
	 ***家中介机构的协议即将于七日内到期     ----> 新角色 ----> 管理员 以及 【总公司_管理员_渠道重客headDeptAdminChannelNew、
	 *								                                                         总公司_室主任_渠道重客headDeptCreditChannelNew、
	 *                                                 总公司_中介渠道管理_渠道重客headDeptMediumChanelNew、
		                                                                                                                                             分公司_部门总_渠道重客subDeptManagerChannelNew、
		                                                                                                                                             分公司_中介渠道管理岗_渠道重客subDeptMediumChannelNew】
		
	 ***名个人代理人的协议即将于七日内到期   ----> 新角色 ----> 管理员 以及 【总公司_室主任_营销管理headDeptSalesmanCreditNew、
	 *                                                  总公司_个代管理岗_营销管理headDeptSalesmanAgentNew、
	 *                                                  分公司_部门总_营销管理subDeptMangerNew、
	 *                                                  分公司_个代管理_营销subDeptSalesmanAgentNew】
		
	 ***个公告待反馈 *** 个公告反馈被驳回    ----> 新角色 ----> 所有人

	 * </pre>
	 */
	@RequestMapping("/getWorkMsg")
	public void getWorkMsg(HttpServletRequest request, HttpServletResponse response) throws GeneralException {
		boolean isShowMsg = false;
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> whereMap = new HashMap<String, Object>();

		String[] roleSalesman = {"headDeptSalesmanCreditNew", "headDeptSalesmanManageNew", "subDeptMangerNew", "subDeptSalesmanManageNew", "xszcAdmin"};
		
		String[] roleMediumLicence = {"headDeptAdminChannelNew", "headDeptCreditChannelNew", "headDeptMediumChanelNew", "subDeptManagerChannelNew", "subDeptMediumChannelNew", "xszcAdmin"};
		
		String[] roleAgentQualification = {"headDeptSalesmanCreditNew", "headDeptSalesmanAgentNew", "subDeptMangerNew", "subDeptSalesmanAgentNew", "xszcAdmin"};
		
		String[] roleMediumConfer = {"headDeptAdminChannelNew", "headDeptCreditChannelNew", "headDeptMediumChanelNew", "subDeptManagerChannelNew", "subDeptMediumChannelNew", "xszcAdmin"};
		
		String[] roleAgentConfer = {"headDeptSalesmanCreditNew", "headDeptSalesmanAgentNew", "subDeptMangerNew", "subDeptSalesmanAgentNew", "xszcAdmin"};
				

		// 取用户的角色
		List<Map<String, Object>> roleListUser = mainFrameService.getUmRole();
		isShowMsg = mainFrameService.existsRole(roleAll, roleListUser);

		// 无提醒的角色
		if (!isShowMsg) {
			resultMap.put("show", false);
			SendUtil.sendJSON(response, resultMap);
			return;
		} else {
			resultMap.put("show", true);
			whereMap.put("deptCode", commonServerice.getUserDept());
		}

		// **名销售人员未配置职级及业务线   
		if (mainFrameService.existsRole(roleSalesman, roleListUser)) {
			resultMap.put("roleSalesman", true);
			resultMap.put("count1", mainFrameService.findSalesmanCount(whereMap));
		}
		
		//**家中介机构的许可证将于七日内到期
		if(mainFrameService.existsRole(roleMediumLicence, roleListUser)){
			resultMap.put("roleMediumLicence", true);
			resultMap.put("count2", mainFrameService.findMediumCount(whereMap));
		}
		
		//**名个人代理人执业证数将于七日内到期
		if(mainFrameService.existsRole(roleAgentQualification, roleListUser)){
			resultMap.put("roleAgentQualification", true);
			resultMap.put("count3", mainFrameService.findAgentCount(whereMap));
		}
		
		//**家中介机构的协议即将于七日内到期  
		if(mainFrameService.existsRole(roleMediumConfer, roleListUser)){
			resultMap.put("roleMediumConfer", true);
			resultMap.put("count4", mainFrameService.findConferMediumCount(whereMap));
		}
		
		//**名个人代理人的协议即将于七日内到期 
		if(mainFrameService.existsRole(roleAgentConfer, roleListUser)){
			resultMap.put("roleAgentConfer", true);
			resultMap.put("count5", mainFrameService.findConferAgentCount(whereMap));
		}
		
		// 公告提醒
		//获取登录人的角色权限
		String userCode = CurrentUser.getUser().getUserCode();
		String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
		List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);
		long count = 0;
		for (Map<String, Object> map : roleCodeList) {
			whereMap.put("status", "1");
			String roleName= map.get("roleEname").toString();
			whereMap.put("roleCode", roleName);
			count += mainFrameService.findNoticeCount(whereMap);
		}
		
		resultMap.put("count6", count);
		long count_feedback = 0;
		for (Map<String, Object> map : roleCodeList) {
			whereMap.put("status", "4");
			String roleName= map.get("roleEname").toString();
			whereMap.put("roleCode", roleName);
			count_feedback += mainFrameService.findNoticeCount(whereMap);
		}
		resultMap.put("count7", count_feedback);
		
		//**试用期满三个月至六个月的员工转正自动提醒
		resultMap.put("count8", mainFrameService.findEmployThreeNoticeCount(whereMap));
		
		//**试用期满六个月的员工转正或淘汰提醒
		resultMap.put("count9", mainFrameService.findEmploySixNoticeCount(whereMap));
		
		SendUtil.sendJSON(response, resultMap);
	}
	
	/**
	 * 简要说明:销售人员未配置列表 <br><pre>
	 * 编写者:卢水发
	 * 创建时间:2015年6月24日 下午3:03:57 </pre>
	 * @throws ServiceException 
	 */
	@RequestMapping("/findSalesmanTipList")
	public void findSalesmanTipList(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException{
		boolean isShowMsg = false;
		Map<String, Object> whereMap = new HashMap<String, Object>();
		
		String[] roleSalesman = {"headDeptSalesmanCreditNew", "headDeptSalesmanManageNew", "subDeptMangerNew", "subDeptSalesmanManageNew", "xszcAdmin"};
		
		// 取用户的角色
		List<Map<String, Object>> roleListUser = mainFrameService.getUmRole();
		isShowMsg = mainFrameService.existsRole(roleAll, roleListUser);

		// 无提醒的角色
		if (!isShowMsg) {
			return;
		} else {
			whereMap.put("deptCode", commonServerice.getUserDept());
		}
		
		// 查询列表
		if (mainFrameService.existsRole(roleSalesman, roleListUser)) {
			Map<String, Object> paramMap = dto.getFormMap();
			String startStr = request.getParameter("start");
			String limitStr = request.getParameter("limit");
			PageDto pageDto = new PageDto();
			pageDto.setStart(startStr);
			pageDto.setLimit(limitStr);
			pageDto.setWhereMap(dto.getFormMap());
			//======================判断是否要过滤信保数据=开始=======================
			boolean xbFlag = false;
			List<Map<String,Object>> roeList = mainFrameService.getUmRole();
			for (Map<String, Object> map : roeList) {
				if(map.get("roleEname").equals("xszcAdmin")){
					xbFlag = true;
				}
			}
			
			if(!xbFlag){
				pageDto.getWhereMap().put("xbFilter", "true");
			}else{
				pageDto.getWhereMap().put("xbFilter", "false");
			}
			//======================判断是否要过滤信保数据=结束=======================
			try {
				pageDto = mainFrameService.findSalesmanTipList(pageDto);
			} catch (Exception e) {
				log.error(e);
				throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
			}
			SendUtil.sendJSON(response, pageDto);
			return;
		}
	}
	
	/**
	 * 简要说明:公告提醒列表 <br><pre>
	 * 编写者:卢水发
	 * 创建时间:2015年6月24日 下午3:03:57 </pre>
	 * @throws ServiceException 
	 */
	@RequestMapping("/findNoticeTipList")
	public void findNoticeTipList(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException{
		// 查询列表
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		pageDto.getWhereMap().put("deptCode", commonServerice.getUserDept());
		
		try {
			pageDto = mainFrameService.findNoticeTipList(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
		return;
	}
	
	/**
	 * 简要说明:查出中介机构渠道7日到期列表 <br><pre>
	 * 方法getMediumValidList的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月24日 下午3:03:57 </pre>
	 * @throws ServiceException 
	 */
	@RequestMapping("/getMediumValidList")
	public void getMediumValidList(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException{
		boolean isShowMsg = false;
		Map<String, Object> whereMap = new HashMap<String, Object>();
		
		String[] roleMediumLicence = {"headDeptAdminChannelNew", "headDeptCreditChannelNew", "headDeptMediumChanelNew", "subDeptManagerChannelNew", "subDeptMediumChannelNew", "xszcAdmin"};

		// 取用户的角色
		List<Map<String, Object>> roleListUser = mainFrameService.getUmRole();
		isShowMsg = mainFrameService.existsRole(roleAll, roleListUser);

		// 无提醒的角色
		if (!isShowMsg) {
			return;
		} else {
			whereMap.put("deptCode", commonServerice.getUserDept());
		}
		
		// 查询列表
		if (mainFrameService.existsRole(roleMediumLicence, roleListUser)) {
			Map<String, Object> paramMap = dto.getFormMap();
			String startStr = request.getParameter("start");
			String limitStr = request.getParameter("limit");
			PageDto pageDto = new PageDto();
			pageDto.setStart(startStr);
			pageDto.setLimit(limitStr);
			pageDto.setWhereMap(dto.getFormMap());
			try {
				pageDto = mainFrameService.getMediumValidList(pageDto);
			} catch (Exception e) {
				log.error(e);
				throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
			}
			SendUtil.sendJSON(response, pageDto);
			return;
		}
	}
	
	/**
	 * 简要说明:查出个人代理人个人代理人的资格证
	 * 或展业证将于七日内到期的渠道7日到期列表 <br><pre>
	 * 方法getMediumValidList的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月24日 下午3:03:57 </pre>
	 * @throws ServiceException 
	 */
	@RequestMapping("/queryAgentValidList")
	public void queryAgentValidList(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException{
		boolean isShowMsg = false;
		Map<String, Object> whereMap = new HashMap<String, Object>();
		
		String[] roleAgentQualification = {"headDeptSalesmanCreditNew", "headDeptSalesmanAgentNew", "subDeptMangerNew", "subDeptSalesmanAgentNew", "xszcAdmin"};

		// 取用户的角色
		List<Map<String, Object>> roleListUser = mainFrameService.getUmRole();
		isShowMsg = mainFrameService.existsRole(roleAll, roleListUser);

		// 无提醒的角色
		if (!isShowMsg) {
			return;
		} else {
			whereMap.put("deptCode", commonServerice.getUserDept());
		}
		
		// 查询列表
		if (mainFrameService.existsRole(roleAgentQualification, roleListUser)) {
			Map<String, Object> paramMap = dto.getFormMap();
			String startStr = request.getParameter("start");
			String limitStr = request.getParameter("limit");
			PageDto pageDto = new PageDto();
			pageDto.setStart(startStr);
			pageDto.setLimit(limitStr);
			pageDto.setWhereMap(dto.getFormMap());
			try {
				pageDto = mainFrameService.getAgentValidList(pageDto);
			} catch (Exception e) {
				log.error(e);
				throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
			}
			SendUtil.sendJSON(response, pageDto);
			return;
		}
	}
	
	/**
	 * 简要说明:中介机构协议7日过期列表
	 * 方法getMediumValidList的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月24日 下午3:03:57 </pre>
	 * @throws ServiceException 
	 */
	@RequestMapping("/queryMediumConferValidList")
	public void queryMediumConferValidList(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException{
		boolean isShowMsg = false;
		Map<String, Object> whereMap = new HashMap<String, Object>();
		String[] roleMediumConfer = {"headDeptAdminChannelNew", "headDeptCreditChannelNew", "headDeptMediumChanelNew", "subDeptManagerChannelNew", "subDeptMediumChannelNew", "xszcAdmin"};
		// 取用户的角色
		List<Map<String, Object>> roleListUser = mainFrameService.getUmRole();
		isShowMsg = mainFrameService.existsRole(roleAll, roleListUser);
		// 无提醒的角色
		if (!isShowMsg) {
			return;
		} else {
			whereMap.put("deptCode", commonServerice.getUserDept());
		}
		// 查询列表
		if (mainFrameService.existsRole(roleMediumConfer, roleListUser)) {
			Map<String, Object> paramMap = dto.getFormMap();
			String startStr = request.getParameter("start");
			String limitStr = request.getParameter("limit");
			PageDto pageDto = new PageDto();
			pageDto.setStart(startStr);
			pageDto.setLimit(limitStr);
			pageDto.setWhereMap(dto.getFormMap());
			try {
				pageDto = mainFrameService.getMediumConferValidList(pageDto);
			} catch (Exception e) {
				log.error(e);
				throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
			}
			SendUtil.sendJSON(response, pageDto);
			return;
		}
	}
	
	
	/**
	 * 简要说明:个人代理协议7日过期列表
	 * 方法getMediumValidList的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月24日 下午3:03:57 </pre>
	 * @throws ServiceException 
	 */
	@RequestMapping("/queryAgentConferValidList")
	public void queryAgentConferValidList(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException{
		boolean isShowMsg = false;
		Map<String, Object> whereMap = new HashMap<String, Object>();
		
		
		String[] roleAgentConfer = {"headDeptSalesmanCreditNew", "headDeptSalesmanAgentNew", "subDeptMangerNew", "subDeptSalesmanAgentNew", "xszcAdmin"};
		// 取用户的角色
		List<Map<String, Object>> roleListUser = mainFrameService.getUmRole();
		isShowMsg = mainFrameService.existsRole(roleAll, roleListUser);
		// 无提醒的角色
		if (!isShowMsg) {
			return;
		} else {
			whereMap.put("deptCode",commonServerice.getUserDept());
		}
		// 查询列表
		if (mainFrameService.existsRole(roleAgentConfer, roleListUser)) {
			Map<String, Object> paramMap = dto.getFormMap();
			String startStr = request.getParameter("start");
			String limitStr = request.getParameter("limit");
			PageDto pageDto = new PageDto();
			pageDto.setStart(startStr);
			pageDto.setLimit(limitStr);
			pageDto.setWhereMap(dto.getFormMap());
			try {
				pageDto = mainFrameService.getAgentConferValidList(pageDto);
			} catch (Exception e) {
				log.error(e);
				throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
			}
			SendUtil.sendJSON(response, pageDto);
			return;
		}
	}
	
	/**
	 * 试用期满三个月至六个月的员工转正自动提醒 查询列表
	 * @throws ServiceException 
	 */
	@RequestMapping("/queryEmployThreeNotice")
	public void findEmployThreeNotice(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException{
		// 查询列表
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		pageDto.getWhereMap().put("deptCode", commonServerice.getUserDept());
		
		try {
			pageDto = mainFrameService.findEmployThreeNotice(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
		return;
	}
	
	@RequestMapping("/queryEmploySixNotice")
	public void findEmploySixNotice(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws ServiceException{
		// 查询列表
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		pageDto.getWhereMap().put("deptCode", commonServerice.getUserDept());
		
		try {
			pageDto = mainFrameService.findEmploySixNotice(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
		return;
	}
	
}
