package com.sinosafe.xszc.main.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.USER_HELP_MSG;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.main.service.UserHelpMsgService;
import com.sinosafe.xszc.main.vo.UserHelpMsg;


/**
 * 类名:com.sinosafe.xszc.main.service.impl.UserHelpMsgServiceImpl <pre>
 * 描述:页面帮助信息处理
 * 编写者:卢水发
 * 创建时间:2015年9月17日 下午3:58:29
 * </pre>
 */
public class UserHelpMsgServiceImpl implements UserHelpMsgService{
	
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	/**
	 * 页面预处理
	 * 编写者:卢水发
	 * 创建时间:2015年9月17日 下午3:54:26 </pre>
	 * @see com.sinosafe.xszc.main.service.UserHelpMsgService#readyPageMsg(java.lang.String)
	 */
	@Override
	public JSONObject readyPageMsg(String pageCode) {
		try {
			long count = this.dao.selectOne(USER_HELP_MSG+".countByPageCode", pageCode);
			if(count>0){
				Map<String,Object> beanObject =  this.dao.selectOne(USER_HELP_MSG+".selectByPageCode", pageCode);
			    return (JSONObject) JSON.toJSON(beanObject);
			}else{
				String pageName = pageCode.substring(pageCode.lastIndexOf("/"), pageCode.length());
				IUserDetails curUserInfo = CurrentUser.getUser();
				String currentUser = curUserInfo.getUsername();
				String curDateTime = DateUtil.dateToStr(new Date());
				UserHelpMsg uhm = new UserHelpMsg();
				uhm.setValidInd("1");
				uhm.setEditDate(curDateTime);
				uhm.setEditUser(currentUser);
				uhm.setCreateDate(curDateTime);
				uhm.setCreateUser(currentUser);
				uhm.setPkId(UUIDGenerator.getUUID());
				uhm.setPageName(pageName);
				uhm.setPageCode(pageCode);
				uhm.setParentPkid("0");
				uhm.setHelpContent("未配置,请配置帮助信息！");
				this.dao.insert(USER_HELP_MSG + INSERT_VO, uhm);
				return (JSONObject) JSON.toJSON(uhm);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public JSONObject getMsgDetail(String pkid){
		Map<String,Object> detail = this.dao.selectOne(USER_HELP_MSG + ".getMsgDetailByPrimaryKey",pkid);
	    JSONObject jaList = (JSONObject) JSON.toJSON(detail);
		return jaList;
	}

	@Override
	public boolean updateData(UserHelpMsg uhm) {
		try {
			this.dao.update(USER_HELP_MSG+".updateByPrimaryKey", uhm);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/**
	 * 得到树列表
	 * @see com.sinosafe.xszc.main.service.UserHelpMsgService#selectListForTree()
	 */
	@Override
	public JSONArray selectListForTree(){
		Map<String,Object> whereMap = new HashMap<String,Object>();
		List<Map<String,Object>> treeList = this.dao.selectList(USER_HELP_MSG + ".selectListForTree",whereMap);
	    JSONArray jaList = (JSONArray) JSON.toJSON(treeList);
		return jaList;
	}
}
