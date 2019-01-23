package com.sinosafe.xszc.main.controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.DateUtil;
import com.sinosafe.xszc.main.service.MainFrameService;
import com.sinosafe.xszc.main.service.UserHelpMsgService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.main.vo.UserHelpMsg;
import com.sinosafe.xszc.util.FormDto;

@Controller
@RequestMapping("/userHelpMsg")
public class UserHelpMsgController {
    
	@Autowired
	@Qualifier("UserHelpMsgService")
	private UserHelpMsgService userHelpMsgService;
	
	@Autowired
	@Qualifier("MainFrameService")
	private MainFrameService mainFrameService;
	
	/**
	 * 简要说明:保存帮助信息 <br><pre>
	 * 编写者:卢水发
	 * 创建时间:2015年9月16日 下午2:25:32 </pre>
	 * @throws IOException 
	 */
	@RequestMapping("/saveHelpMsg")
	public void saveHelpMsg(HttpServletRequest request,HttpServletResponse response) throws IOException{
		JSONObject jo = new JSONObject();
		try{
			//接收客户端的值
			String pkId  = request.getParameter("pkId");
			String parentPkid  = request.getParameter("parentPkid");
			String pageName    = request.getParameter("pageName");
			String pageCode    = request.getParameter("pageCode");
			String helpContent = request.getParameter("helpContent");
			String curDateTime = DateUtil.dateToStr(new Date());
			//当前用户
			IUserDetails curUserInfo = CurrentUser.getUser();
			String currentUser = curUserInfo.getUsername();
			UserHelpMsg uhm = new UserHelpMsg();
			uhm.setValidInd("1");
			uhm.setEditDate(curDateTime);
			uhm.setEditUser(currentUser);
			uhm.setPkId(pkId);
			uhm.setPageName(pageName);
			uhm.setPageCode(pageCode);
			uhm.setParentPkid(parentPkid);
			uhm.setHelpContent(helpContent);
			boolean actionFlag = userHelpMsgService.updateData(uhm);
			jo.put("actionFlag", actionFlag);
		}catch(Exception e){
			e.printStackTrace();
			jo.put("actionFlag", false);
		}
		response.getWriter().write(jo.toJSONString());
		response.getWriter().flush();
		response.getWriter().close();
		return;
	}
	
	/**
	 * 查询帮助详细信息
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws IOException 
	 */
	@RequestMapping("/getMsgDetail")
	@VisitDesc(label="查询帮助详细信息",actionType=4)
	public void getMsgDetail(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException, IOException {
		String pkid = request.getParameter("pkid");
		JSONObject jsonObject =  this.userHelpMsgService.getMsgDetail(pkid);
	    response.getWriter().write(jsonObject.toJSONString());
	    response.getWriter().flush();
	    response.getWriter().close();
	    return;
	}
	
	/**
	 * 页面预处理,如果存在信息则取出,不存在信息则添加一条记录
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws IOException 
	 */
	@RequestMapping("/readyCurPageMsg")
	@VisitDesc(label="帮助信息页面预处理",actionType=4)
	public void readyCurPageMsg(HttpServletRequest request,HttpServletResponse response) throws GeneralException, IOException {
		//查看自己是否有权限修改帮助信息
		String[] alllowRoles = {"xszcAdmin","editHelpText"};
		List<Map<String,Object>> roleList =  mainFrameService.getUmRole();
		boolean allowFlag = false;
		if(mainFrameService.existsRole(alllowRoles,roleList)){
			allowFlag = true;
		}
		String pageCode = request.getParameter("pageCode");
		JSONObject jsonObject =  this.userHelpMsgService.readyPageMsg(pageCode);
		jsonObject.put("allowFlag", allowFlag);
	    response.getWriter().write(jsonObject.toJSONString());
	    response.getWriter().flush();
	    response.getWriter().close();
	    return;
	}
	
	/**
	 * 页面预处理,如果存在信息则取出,不存在信息则添加一条记录
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws IOException 
	 */
	@RequestMapping("/getTreeList")
	@VisitDesc(label="查询帮助详细信息",actionType=4)
	public void getTreeList(HttpServletRequest request,HttpServletResponse response) throws GeneralException, IOException {
		JSONObject root = new JSONObject();
		root.put("id","0");
		root.put("pid","-1");
		root.put("text","根目录");
		root.put("expanded",true);
		JSONArray jsonArray =  this.userHelpMsgService.selectListForTree();
		jsonArray.add(root);
		response.getWriter().write(jsonArray.toJSONString());
	    response.getWriter().flush();
	    response.getWriter().close();
	    return;
	}
	
	/**
	 * 转换一下内容值 
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 * @throws IOException 
	 */
	@RequestMapping("/revertContent")
	public void revertContent(HttpServletRequest request,HttpServletResponse response) throws GeneralException, IOException {
		String helpContent = request.getParameter("helpContent");
		helpContent = Text2Html(helpContent);
		response.getWriter().write(helpContent);
		return;
	}
	
	/**
	 * Html转换为TextArea文本:编辑时拿来做转换
	 * 
	 * @author zhengxingmiao
	 * @param str
	 * @return
	 */
	public static String Html2Text(String str) {
		if (str == null) {
			return "";
		} else if (str.length() == 0) {
			return "";
		}
		str = str.replaceAll("<br />", "\n");
		str = str.replaceAll("<br />", "\r");
		return str;
	}

	/**
	 * TextArea文本转换为Html:写入数据库时使用
	 * 
	 * @author zhengxingmiao
	 * @param str
	 * @return
	 */
	public static String Text2Html(String str) {
		if (str == null) {
			return "";
		} else if (str.length() == 0) {
			return "";
		}
		str = str.replaceAll("\n", "<br />");
		str = str.replaceAll("\r", "<br />");
		return str;
	}

}
