package com.sinosafe.xszc.group.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.group.service.GroupChangeRecordService;
import com.sinosafe.xszc.group.service.SalesmanService;
import com.sinosafe.xszc.group.service.SalesmanVirtualService;
import com.sinosafe.xszc.group.vo.GroupChangeRecord;
import com.sinosafe.xszc.group.vo.Salesman;
import com.sinosafe.xszc.group.vo.SalesmanVirtual;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.ReflectMatch;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/groupChangeRecord")
public class GroupChangeRecordController {
	
	//生成团队成员编码用到的集合
	private static HashMap<String, Integer> reqIdxHm = new HashMap<String, Integer>();
	
	private static final Log log = LogFactory.getLog(GroupLeaderRecordController.class);
	
	@Autowired
	@Qualifier("GroupChangeRecordService")
	private GroupChangeRecordService groupChangeRecordService;
	
	@Autowired
	@Qualifier("SalesmanService")
	private SalesmanService salesmanService;

	@Autowired
	@Qualifier("SalesmanVirtualService")
	private SalesmanVirtualService salesmanVirtualService;
	
	/**
	 * 异动人员记录增加
	 * @param request
	 * @param response
	 * @param groupChangeRecord
	 * @throws GeneralException
	 */
	@RequestMapping("/saveGroupChangeRecord")
	@VisitDesc(label="远程出单点删除",actionType=1)
	public void saveGroupChangeRecord(HttpServletRequest request, HttpServletResponse response, GroupChangeRecord groupChangeRecord) throws GeneralException {
		groupChangeRecord.setCreatedUser(CurrentUser.getUser().getUserCode());
		groupChangeRecord.setUpdatedUser(CurrentUser.getUser().getUserCode());
		groupChangeRecord.setRecordId(UUIDGenerator.getUUID());
		groupChangeRecord.setStatus("0");
		groupChangeRecord.setValidInd("1");
		try {
			groupChangeRecordService.saveGroupChangeRecord(groupChangeRecord);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(groupChangeRecord), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	
	/**
	 * 异动人员记录修改
	 * @param request
	 * @param response
	 * @param groupChangeRecord
	 * @throws GeneralException
	 * @throws IOException 
	 * @throws JsonMappingException 
	 * @throws JsonParseException 
	 */
	@RequestMapping("/updateGroupChangeRecord")
	@VisitDesc(label="异动人员记录修改",actionType=3)
	public void updateGroupChangeRecord(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		String currentUser = CurrentUser.getUser().getUserCode();
		//把前台传过来的Map集合保存到对象
		Map<String, Object> paramMap = dto.getFormMap();
		ReflectMatch rm = new ReflectMatch();
		GroupChangeRecord groupChangeRecordTemp = new GroupChangeRecord();
		rm.setValue(groupChangeRecordTemp, paramMap);
		
		//接收人员信息
		String jsonData = request.getParameter("updateSalesman");
		int beginIndex = jsonData.lastIndexOf("[");
		int endIndex = jsonData.lastIndexOf("]");
		//获取json中的rows中的有效数据
		ObjectMapper objectMapper = new ObjectMapper();
		String jsonSalseman = jsonData.substring(beginIndex+1, endIndex);
		Salesman salesman = objectMapper.readValue(jsonSalseman,Salesman.class);
		
		SalesmanVirtual salesmanVirtual = new SalesmanVirtual();
		salesmanVirtual.setSalesmanCode(salesman.getSalesmanCode());
		salesmanVirtual.setDeptCode(salesman.getDeptCode());
		
		//获取数据用于修改人员异动
		GroupChangeRecord groupChangeRecord = new GroupChangeRecord();
		groupChangeRecord.setUpdatedUser(currentUser);
		groupChangeRecord.setValidInd("0");
		groupChangeRecord.setSalesmanCode(groupChangeRecordTemp.getSalesmanCode());
		try {
			//修改人员异动
			groupChangeRecordService.updateGroupChangeRecord(groupChangeRecord);
			
			//修改人员信息
			salesman.setUpdatedUser(CurrentUser.getUser().getUserCode());
			salesman.setProcessStatus("2");
			salesman.setValidInd("1");
			
			salesmanService.updateSalesman(salesman);
			
			//修改非HR人员信息
			//salesmanVirtualService.updateInfoBySalesCode(salesmanVirtual);
			
			//新增异动信息
			groupChangeRecordTemp.setCreatedUser(currentUser);
			groupChangeRecordTemp.setUpdatedUser(currentUser);
			groupChangeRecordTemp.setRecordId(UUIDGenerator.getUUID());
			//查询出传入进来的团队代码的尾数为最大的数 加 1
			Long maxNum = groupChangeRecordService.findGroupChangeRecordByCount(groupChangeRecordTemp);
			//生成团队成员代码
			if(maxNum == null || maxNum == 0){
				groupChangeRecordTemp.setGroupMemberCode(groupChangeRecordTemp.getGroupCode()  + "000"+ 1 );
			}else if(maxNum < 10){
				groupChangeRecordTemp.setGroupMemberCode(groupChangeRecordTemp.getGroupCode()  + "000"+maxNum);
			}else if(maxNum < 100 && maxNum > 10){
				groupChangeRecordTemp.setGroupMemberCode(groupChangeRecordTemp.getGroupCode() + "00"+maxNum);
			}else if(maxNum < 1000 && maxNum > 100){
				groupChangeRecordTemp.setGroupMemberCode(groupChangeRecordTemp.getGroupCode() + "0"+maxNum);
			}else{
				groupChangeRecordTemp.setGroupMemberCode(groupChangeRecordTemp.getGroupCode() + maxNum);
			}
			groupChangeRecordTemp.setStatus("0");
			groupChangeRecordTemp.setValidInd("1");
			groupChangeRecordService.saveGroupChangeRecord(groupChangeRecordTemp);
			
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(groupChangeRecord), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	
	
	@RequestMapping("/updateSalesmanHistoryidong")
	@VisitDesc(label="修改异动记录",actionType=3)
	public void updateSalesmanHistoryidong(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException, JsonParseException, JsonMappingException, IOException {
		String currentUser = CurrentUser.getUser().getUserCode();
		//把前台传过来的Map集合保存到对象
		Map<String, Object> paramMap = dto.getFormMap();
		ReflectMatch rm = new ReflectMatch();
		GroupChangeRecord groupChangeRecordTemp = new GroupChangeRecord();
		rm.setValue(groupChangeRecordTemp, paramMap);
		//接收人员信息
		String jsonData = request.getParameter("updateSalesman");
		int beginIndex = jsonData.lastIndexOf("[");
		int endIndex = jsonData.lastIndexOf("]");
		//获取json中的rows中的有效数据
		ObjectMapper objectMapper = new ObjectMapper();
		String jsonSalseman = jsonData.substring(beginIndex+1, endIndex);
		Salesman salesman = objectMapper.readValue(jsonSalseman,Salesman.class);
		
		SalesmanVirtual salesmanVirtual = new SalesmanVirtual();
		salesmanVirtual.setSalesmanCode(salesman.getSalesmanCode());
		salesmanVirtual.setDeptCode(groupChangeRecordTemp.getDeptCode());
		
		try {
			//查询出传入进来的团队代码的尾数为最大的数 加 1
			Long maxNum = groupChangeRecordService.findGroupChangeRecordByCount(groupChangeRecordTemp);
			//生成团队成员代码
			if(maxNum == null || maxNum == 0){
				groupChangeRecordTemp.setGroupMemberCode(groupChangeRecordTemp.getGroupCode()  + "000"+ 1 );
			}else if(maxNum < 10){
				groupChangeRecordTemp.setGroupMemberCode(groupChangeRecordTemp.getGroupCode()  + "000"+maxNum);
			}else if(maxNum < 100 && maxNum > 10){
				groupChangeRecordTemp.setGroupMemberCode(groupChangeRecordTemp.getGroupCode() + "00"+maxNum);
			}else if(maxNum < 1000 && maxNum > 100){
				groupChangeRecordTemp.setGroupMemberCode(groupChangeRecordTemp.getGroupCode() + "0"+maxNum);
			}else{
				groupChangeRecordTemp.setGroupMemberCode(groupChangeRecordTemp.getGroupCode() + maxNum);
			}
			String groupMemberCode=groupChangeRecordTemp.getGroupMemberCode();
			//修改人员信息
			salesman.setValidDate((String)paramMap.get("validDate"));
			salesman.setGroupMemberCode(groupMemberCode);
			salesman.setUpdatedUser(CurrentUser.getUser().getUserCode());
			salesman.setProcessStatus("2");
			salesman.setValidInd("1");
			salesman.setHistoryId(UUIDGenerator.getUUID());
			//团队成员表，更新该人员的离团时间，插入新的数据
			paramMap.put("currentUser", currentUser);
			salesmanService.updateGroupMember(paramMap);
			
			salesmanService.updateSalesman(salesman);
			//查找出那些那些非HR人员要更改的。
			List<Map<String,Object>> rows=new ArrayList<Map<String,Object>>();
			rows=salesmanVirtualService.selectSalesmanVirtual(salesman.getSalesmanCode());
			//HR人员异动后，他对应的销售助理的部门信息也要更改。同时保存销售助理的历史记录
		    salesmanVirtualService.updateInfoBySalesCode(salesmanVirtual,rows);
			
		    
			} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(salesman), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 团队成员编码生成
	 * @return
	 */
	  public static String getReqIdx()
	    {
	        Integer reqIdx = reqIdxHm.get("index");
	        if (reqIdx == null)
	        {
	            reqIdx = initReqIdx();
	        }
	        if (reqIdx < 10)
	        {
	            reqIdx = reqIdxHm.put("index", reqIdx+1);
	            return "000" + reqIdx;
	        }
	        else if (reqIdx < 100)
	        {
	            reqIdx = reqIdxHm.put("index", reqIdx+1);
	            return "00" + reqIdx;
	        }
	        else if (reqIdx < 1000)
	        {
	            reqIdx = reqIdxHm.put("index", reqIdx+1);
	            return "0" + reqIdx;
	        }
	        else
	        {
	            reqIdx = reqIdxHm.put("index", reqIdx+1);
	            return "" + reqIdx;
	        }
	    }

	    private static Integer initReqIdx()
	    {
	        Integer reqIdx = new Integer(1);
	        reqIdxHm.put("index", reqIdx);
	        return reqIdx;
	    }

	    public static HashMap<String, Integer> getReqIdxHm()
	    {
	        return reqIdxHm;
	    }

	    public static void setReqIdxHm(HashMap<String, Integer> reqIdxHm)
	    {
	    	GroupChangeRecordController.reqIdxHm = reqIdxHm;
	    }
	
}
