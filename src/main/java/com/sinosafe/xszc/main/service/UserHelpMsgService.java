package com.sinosafe.xszc.main.service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.sinosafe.xszc.main.vo.UserHelpMsg;

public interface UserHelpMsgService {

	JSONObject readyPageMsg(String pageCode);

	boolean updateData(UserHelpMsg uhm);

	JSONArray selectListForTree();

	JSONObject getMsgDetail(String pkid);

}
