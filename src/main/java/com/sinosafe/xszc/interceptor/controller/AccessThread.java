package com.sinosafe.xszc.interceptor.controller;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.main.service.UserAccessRecordService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.main.vo.UserAccessRecord;

public class AccessThread extends Thread{
	
	protected final static Log log = LogFactory.getLog(UserAccessInterceptor.class);
	
	private Method actionMethod = null;
	private UserAccessRecordService userAccessRecordService;
	private Map<String,Object> paramMap = new HashMap<String, Object>();
	
	public AccessThread(Method actionMethod,UserAccessRecordService userAccessRecordService,Map<String,Object> paramMap){
		this.actionMethod = actionMethod;
		this.paramMap = paramMap;
		this.userAccessRecordService = userAccessRecordService;
	}
	
	    //当前用户
		static IUserDetails curUserInfo = CurrentUser.getUser();
		
		@Override
		public void run() {
			try{
				RequestMapping requestMapping = actionMethod.getAnnotation(RequestMapping.class);
				VisitDesc visitDesc = actionMethod.getAnnotation(VisitDesc.class);
				boolean hiddenVisit = false;
				if(visitDesc!=null){
					hiddenVisit = visitDesc.hidden();
				}
				
				if(!hiddenVisit){
					String userName = curUserInfo.getUserCName();
					String userCode = curUserInfo.getUserCode();
					String controllerJavaName = actionMethod.getDeclaringClass().getName();
					String parentValue = controllerJavaName.split("\\.")[3];
					String chlidValue = controllerJavaName.split("\\.")[5];
					String[] valArr = requestMapping.value();
					//得到requestMapping的映射的方法
					String methodUrl = valArr[0];
					String accessType = getActionType(methodUrl);
					String acltionLabel = "";
					if(visitDesc!=null){
						int ty = visitDesc.actionType();
						if(ty==1){
							accessType = "保存";
						}else if(ty==2){
							accessType = "删除";
						}else if(ty==3){
							accessType = "修改";
						}else{
							accessType = "查询";
						}
						
						acltionLabel = visitDesc.label();
					}
					//得到前用户信息
					Map<String,String> model = getModelClass(controllerJavaName);
					String parentClass = "未知";
					String childClass = "未知子模块";
					if(model!=null){
						parentClass = model.get("parentClass");
						childClass = model.get("childClass");
					}
					StringBuffer sb = new StringBuffer();
					sb.append("模块大类:"+parentClass);
					sb.append("模块小类:"+childClass);
					sb.append("请求类型:"+accessType);
					sb.append("请求地址:" + this.paramMap.get("url"));
					sb.append("请求用户:" + userName);
					sb.append("请求用户编码:" + userCode);
					sb.append("请求部门编码:" + this.paramMap.get("deptCode"));
					sb.append("请求IP:" + this.paramMap.get("ip"));
					sb.append("请求时间:" + DateUtil.getSystemDateStr("yyyy-MM-dd HH:mm:ss"));
					log.debug(sb.toString());
					//设置值
					UserAccessRecord uar = new UserAccessRecord();
					uar.setPkId(UUIDGenerator.getUUID());
					uar.setActionDate(DateUtil.getSystemDateStr("yyyy-MM-dd HH:mm:ss"));
					uar.setUserCode(userCode);
					uar.setModelClass(parentClass);
					uar.setModelChildClass(childClass);
					uar.setModelClassCode(parentValue);
					uar.setModelChildClassCode(chlidValue);
					uar.setActionLabel(acltionLabel);
					uar.setActionUrl(this.paramMap.get("url").toString());
					uar.setActionIp(this.paramMap.get("ip").toString());
					uar.setAccessType(accessType);
					uar.setDeptCode(this.paramMap.get("deptCode").toString());
					uar.setLineCode("");
					uar.setValidInd("1");
					uar.setUserRealName(userName);
					userAccessRecordService.saveOrUpdateByWhere(uar);
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		/**
		 * 简要说明:查出操作类型 <br><pre>
		 */
		protected String getActionType(String methodUrl) {
			if(methodUrl.contains("save")){
				return "保存";
			}else if(methodUrl.contains("query")){
				return "查询";
			}else if(methodUrl.contains("delete")){
				return "删除";
			}else if(methodUrl.contains("del")){
				return "删除";
			}else if(methodUrl.contains("get")){
				return "查询";
			}else if(methodUrl.contains("update")){
				return "修改";
			}else if(methodUrl.contains("modify")){
				return "修改";
			}
			return "查询";
		}
		
		
		
		//得到模块分类
		public static List<Map<String,Object>> getModelClass(){
			List<Map<String,Object>> parentList = new ArrayList<Map<String,Object>>();
			Map<String,Object> child = new HashMap<String, Object>();
			//活动开始
			Map<String,Object> parentItem = new HashMap<String, Object>();
			parentItem.put("activity", "活动管理");
			child.put("ActivityController","活动管理操作");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			//活动结束
			
			//渠道开始
			parentItem = new HashMap<String, Object>();
			parentItem.put("channel", "销售渠道管理");
			child = new HashMap<String, Object>();
			child.put("AgentController","个人代理人管理");
			child.put("AgentHistoryController","个人代理人历史记录");
			child.put("ChannelMainController","渠道管理");
			child.put("ChannelMaintainController","渠道远程出单点维护人");
			child.put("ChannelWarningController","渠道预警");
			child.put("ConferProductController","协议产品");
			child.put("MailRecordController","渠道预警邮件记录");
			child.put("MediumConferController","中介机构协议");
			child.put("MediumContectController","渠道联系人");
			child.put("MediumController","中介机构管理");
			child.put("MediumHistoryController","中介机构历史记录管理");
			child.put("MediumNodeController","远程出单点");
			child.put("ChannelMailWarningController","手动预警邮件管理");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			//渠道结束
			
			// 销售团队管理
			parentItem = new HashMap<String, Object>();
			parentItem.put("group", "销售团队管理");
			child = new HashMap<String, Object>();
			child.put("GroupChangeRecordController", "异动人员记录");
			child.put("GroupLeaderRecordController", "团队长变更管理");
			child.put("GroupMainController", "团队管理");
			child.put("SalesmanController", "销售人员管理");
			child.put("SalesmanEmployController", "关联工号管理");
			child.put("SalesmanVirtualController", "非HR人员管理");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			// 销售团队管理结束
			
			// 管理办法
			parentItem = new HashMap<String, Object>();
			parentItem.put("law", "销售人员管理办法");
			child = new HashMap<String, Object>();
			child.put("LawCalcProceController", "指标计算过程");
			child.put("LawCostRateController", "成本调整系数");
			child.put("LawDefineController", "基本法版本定义");
			child.put("LawFactorController", "基本法管理");
			child.put("LawRankDefController", "基本法职级定义");
			child.put("LawRateController", "标准保费调整系数");
			child.put("LawSpecifyController", "基本法版本定义与机构关系");
			child.put("LawSpecifyController", "指标定义");
			child.put("TIndexFactorController","指标因素关系");
			child.put("TLawFactorImpValueController","个人经理/团队经理数值导入");
			child.put("TLawLineRateController","业务调整系数");
			child.put("TLawOriginRateController","业务来源调整系数");
			child.put("TLawProductRateController","产品(险种)调整系数");
			child.put("TRankCalcController","职级考核公式");
			child.put("TRankFactorController","职级及考核评分关系");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			// 管理办法结束
			
			// 公告管理
			parentItem = new HashMap<String, Object>();
			parentItem.put("notice", "公告管理");
			child = new HashMap<String, Object>();
			child.put("NoticeController", "公告管理");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			// 公告管理结束
			
			// 旧销售计划 功能
			parentItem = new HashMap<String, Object>();
			parentItem.put("plan", "销售计划管理");
			child = new HashMap<String, Object>();
			child.put("SalePlanChannelController", "专属保费计划");
			child.put("SalePlanDeptController", "销售保费计划");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			// 销售计划结束
			
			// 销售计划
			parentItem = new HashMap<String, Object>();
			parentItem.put("planNew", "销售计划管理");
			child = new HashMap<String, Object>();
			child.put("SalePlanController", "销售计划");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			// 销售计划结束
			
			
			
			// 续保管理
			parentItem = new HashMap<String, Object>();
			parentItem.put("renewal", "续保管理");
			child = new HashMap<String, Object>();
			child.put("RenewalController", "续保管理");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			// 续保管理 结束
			
			// 考核管理
			parentItem = new HashMap<String, Object>();
			parentItem.put("review", "考核管理");
			child = new HashMap<String, Object>();
			child.put("ReviewRankController", "考核职级管理");
			child.put("ReviewSalaryController", "考核薪酬管理");
			child.put("ReviewScoreController", "考核评分管理");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			// 考核管理 结束
			
			// 续保管理
			parentItem = new HashMap<String, Object>();
			parentItem.put("survey", "市场调研管理");
			child = new HashMap<String, Object>();
			child.put("SurveyController", "市场调研");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			// 续保管理
			
			// 报表管理
			parentItem = new HashMap<String, Object>();
			parentItem.put("report", "报表管理");
			child = new HashMap<String,Object>();
			child.put("ReportCommonController","报表管理");
			child.put("ReportDayAgentChannelController","业绩追踪日报-中介渠道业务数据日报表（常规业务）");
			child.put("ReportDayGroupManagerController","");
			child.put("ReportDayRemotePolicyController","");
			child.put("ReportDaySaleTraceController","整体业绩进度追踪日报(分险种)");
			child.put("ReportDayTraceHebeiController","");
			child.put("ReportFoundationMediumNewController","");
			child.put("ReportGroupSaleController","");
			child.put("ReportMonthAgentInfoController","");
			child.put("ReportMonthRemotePolicyController","");
			child.put("ReportMothGroupManagerController","");
			child.put("ReportTotalAgentInfoController","");
			child.put("ReportTotalGroupMenberController","");
			child.put("ReportWeekAgentChannelController","");
			child.put("ReportWeekGroupManagerController","");
			child.put("ReportWeekRemotePolicyController","");
			child.put("ReportWeekSaleTraceController","");
			parentItem.put("childList", child);
			parentList.add(parentItem);
			// 报表管理结束
			return parentList;
		}
		
		//得到模块
		public static Map<String,String> getModelClass(String controllerJavaName){
			try {
				String parentValue = controllerJavaName.split("\\.")[3];
				String chlidValue = controllerJavaName.split("\\.")[5];
				String parentText = "";
				String chlidText = "";
				List<Map<String,Object>> allModelClass =  getModelClass();
				for (Map<String, Object> map : allModelClass) {
					//找到父级
					if(map.containsKey(parentValue)){
						parentText = map.get(parentValue).toString();
						Map<String,Object> childList = (Map<String, Object>) map.get("childList");
						//找出子级
						chlidText = childList.get(chlidValue).toString();
						break;
					}
				}
				Map<String,String> model = new HashMap<String, String>();
				model.put("parentClass", parentText);
				model.put("childClass", chlidText);
				return model;
			} catch (Exception e) {
				log.info(e.getMessage());
				return null;
			}
		}

}
