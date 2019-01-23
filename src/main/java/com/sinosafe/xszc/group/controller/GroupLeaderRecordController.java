package com.sinosafe.xszc.group.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.group.service.GroupLeaderRecordService;
import com.sinosafe.xszc.group.vo.GroupLeaderRecord;
import com.sinosafe.xszc.group.vo.GroupMain;
import com.sinosafe.xszc.group.vo.Salesman;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/groupLeaderRecord")
public class GroupLeaderRecordController {

	private static final Log log = LogFactory.getLog(GroupLeaderRecordController.class);

	@Autowired
	@Qualifier("GroupLeaderRecordService")
	private GroupLeaderRecordService groupLeaderRecordService;

	/**
	 * 团队长添加
	 * 
	 * @param request
	 * @param response
	 * @param GroupLeaderRecord
	 * @throws GeneralException
	 */
	@RequestMapping("/saveGroupLeaderRecord")
	@VisitDesc(label="团队长添加",actionType=1)
	public void saveGroupLeaderRecord(HttpServletRequest request, HttpServletResponse response, GroupLeaderRecord groupLeaderRecord)
			throws GeneralException {
		String userCode = CurrentUser.getUser().getUserCode();
		groupLeaderRecord.setCreatedUser(userCode);
		groupLeaderRecord.setUpdatedUser(CurrentUser.getUser().getUserCode());
		groupLeaderRecord.setLeaderRecordId(UUIDGenerator.getUUID());
		groupLeaderRecord.setStatus("0");
		groupLeaderRecord.setValidInd("1");
		
		try {
			// 更新团队长职级到团队长记录表
			groupLeaderRecordService.saveGroupLeaderRecord(groupLeaderRecord);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(groupLeaderRecord), e);
		}
		SendUtil.sendJSON(response, "OK");
	}

	/**
	 * 团队长撤销
	 * 
	 * @param request
	 * @param response
	 * @param GroupLeaderRecord
	 * @throws GeneralException
	 */
	@RequestMapping("/updateGroupLeaderRecord")
	@VisitDesc(label="团队长撤销",actionType=3)
	public void updateGroupLeaderRecord(HttpServletRequest request, HttpServletResponse response, GroupLeaderRecord groupLeaderRecord)
			throws GeneralException {
		groupLeaderRecord.setUpdatedUser(CurrentUser.getUser().getUserCode());
		groupLeaderRecord.setValidInd("0");

		try {
			groupLeaderRecordService.updateGroupLeaderRecord(groupLeaderRecord);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(groupLeaderRecord), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
}
