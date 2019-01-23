<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<title>活动查询</title>

<style type="text/css">
	body{margin: 0;}
    .color_red{color: red;}
    .textarea_text {width: 98%;}
    .button-stl-tab{color: blue;text-decoration:underline;}
     input[readonly='readonly'],textarea[readonly='readonly'],input[readonly='true'],textarea[readonly='true']
	 {
	 	background-color:#F0F0F0;
	 	color:gray;
	 }
</style>


<script type="text/javascript">
                    
/**
 * 界面原型初始化
 */
$(function(){
	$("#filterFrm input").css({width:'140px'});
	$(".omDateCalendar").css({width:'121px'});
	$("#issueDiv").omDialog({
		title : '活动下发',
		zIndex : 99999,
		autoOpen : false,
		modal : true,
		height : 425,
		width : 650,
		buttons: [{
            text : "确定", 
            click : function(){
            	fillIssuedDept();
            	activitySubmit();
            	$("#issueDiv").omDialog("close");
            }
        }, {
            text : "取消", 
            click : function () {
            	$("#issueDiv").omDialog("close");
            }
        }]

		})
		.haMltSelect({DataSource:"<%=_path%>/activity/queryDept.do?activityId="+activityInfoJson.activityId});
	activityInfoJson.deptCode = '${sessionScope.defaultDept}';
	FillForm.fill("filterFrm",activityInfoJson);
	$("#beginDate").omCalendar({
		disabledFn : function disFn(date) {
	        var nowMiddle = new Date();
	        if (date < nowMiddle) {
	            return false;
	        }
	    },
		onSelect : function onSelectFn(beginDate,event) {
			var endDate = $("#endDate").omCalendar('getDate');
			if(beginDate>endDate){
				$("#endDate").val('');
			}
			$("#endDate").omCalendar({
				disabledFn : function disFn(date) {
			        if (date < beginDate) {
			            return false;
			        }
			    },
			    disabled :false
			});
		}
	});
	
	
	$("#endDate").omCalendar();
	var today = new Date(); 
	$("#feedbackDate").omCalendar({
		showTime : true,
		date:today,
		disabledFn : function disFn(date) {
	        var nowMiddle = new Date();
	        nowMiddle = new Date(nowMiddle.getTime()-24*60*60*1000);
	        var beginDate = $("#beginDate").omCalendar('getDate');
	        if (date < nowMiddle||date < beginDate) {
	            return false;
	        }
	    }
	});
	
	$("#activityFeedback-base").omPanel({
    	title : "反馈基本信息",
    	collapsible:true,
    	collapsed:false
    });
	
	initPage(actionJson);
	
	validateForm.validate("#filterFrm");
	
});


/***************************** 基本数据初始化**********************************start***/
var dataGrid;
var title1 = "活动查询";
var activityInfoJson = JSON.parse('${param.activityDetail}');
var actionJson = JSON.parse('${param.paraMap}');
var operateEmp = "<%=CurrentUser.getUser().getUserCode()%>";

var feedbackTabHand = [
                      {header : "反馈机构",align:'center',name : "deptName",width:100},
                      {header : "反馈人",align:'center',name : "feedbackUser",width:100},
                      {header : "反馈时间",align:'center',name : "feedbackDate",width:200},
                      {header : "反馈人电话",align:'center',name : "tel",width:200},
                      {header : "反馈状态",align:'center',name : "status",width:100},
                      {header : '操作', name : 'operation', width: "autoExpand", align:'center', renderer:function(colValue, rowData, rowIndex){
 	                   	 return '<span onclick="showFeedbackDetail('+rowIndex+',event);" class="button-stl-tab">详情</span>';
 	                   }}
                      ];
/***************************** 基本数据初始化**********************************end***/



/* *******************************************界面元素初始化start************************************************* */

/**
 * 初始化页面管控<br>
 * 根据程序入口(action.actionName)不同初始化页面相关元素
 */
function initPage(action){
	//初始化活动方案影像批次号
	$("#programUploadId").val(activityInfoJson.uploadId);
	
	//活动反馈初始化
	if(action.actionName == "activityFeedback"){
		title1 = '活动反馈';
		$(":input:not(.om-btn-txt,#activityFeedback-base :input)").attr("readonly","readonly");
		$(".omDateCalendar:not(#activityFeedback-base .omDateCalendar)").omCalendar('disable');
		
		$("#activity-submit,#activity-save").omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'
		    }
		});
		$("#return-sourse").omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/remove.png'
		    }
		});
		$("#feedbackUser").val(operateEmp).attr("readonly","readonly");
		$(".omTimeCalendar").omCalendar({showTime : true});
		getImg("#jdSummary-upload-download",{method:"queryUploadWithDpt",module:"06",deptCode:activityInfoJson.defaultDept});//反馈上传下载
	}else{
		$("#feedbackTab").omGrid(
				{
	                dataSource : "<%=_path%>/activity/findActivityFeedback.do?activityId="+activityInfoJson.activityId,
	                title: "活动反馈",
	                limit : 0,
	                height : 200,
	                showIndex : true,
	                autoFit : true,
	                colModel : feedbackTabHand,
	                method : 'POST'
	            });
		
		$("#addFeedBackDiv").omDialog(
				{
					autoOpen : false,
					modal : true,
					zIndex : 99999,
		            width: 700,
		            height: 450,
		            buttons: [{
		                text : "确定", 
		                click : function () {
		                    $("#addFeedBackDiv").omDialog("close");
		                }
		            }]
				});
	}
	
	//其余入口初始化工作
	if(action.actionName == "activityDetail"){
		/* 上传下载初始化 */
		title1 = '活动详情';
		getImg("#program-upload-download",{method:"queryUpload",module:"05",operateCode:'none'});
		getImg("#summary-upload-download",{method:"queryUpload",module:"07",operateCode:'none'});
		$(":input:not(.om-btn-txt)").attr("readonly","readonly");
		$(".omDateCalendar,.omTimeCalendar").omCalendar('disable');
		$(".button-stl").hide();
		$("#return-sourse").show().omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/remove.png'
		    }
		});
	}else if(action.actionName == "activityAdd") {
		title1 = '活动新增';
		$(".button-stl").omButton();
		/* 上传下载初始化 */
		$("#program-upload-download").haImg(
				{
					title:'活动方案文件',
					modelCode:'XSZC010201',
					mainBillNo:"",
					seriesNo:activityInfoJson.uploadId,
					srcUrl:'${sessionScope.imgUrl}',
					operateEmp:operateEmp
				});
		$("#activity-submit,#activity-save").omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'
		    }
		});
		$("#return-sourse").omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/remove.png'
		    }
		});
		$("#summary,#feedback").hide();
	}else if(action.actionName == "activityModify"){
		title1 = '活动修改';
		getImg("#program-upload-download",{method:"queryUpload",module:"05"});
		
		$("#activity-submit").hide();
		$("#activity-save").omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'
		    }
		});
		$("#return-sourse").omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/remove.png'
		    }
		});
		
		
		$("#summary,#feedback").hide();
		$(":input:not(.om-btn-txt,#endDate),.omTimeCalendar").attr("readonly","readonly");
		$(".omDateCalendar:not(#endDate)").omCalendar('disable');
	}else if(action.actionName == "activitySummary"){
		title1 = '活动总结';
		getImg("#summary-upload-download",{method:"queryUpload",module:"07"});
		getImg("#program-upload-download",{method:"queryUpload",module:"05",operateCode:'none'});
		$("#activity-submit,#activity-save").omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'
		    }
		});
		$("#return-sourse").omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/remove.png'
		    }
		});
		$(":input:not(.om-btn-txt)").attr("readonly","readonly");
		$(".omDateCalendar,.omTimeCalendar").omCalendar('disable');
	}else if(action.actionName == "activityIssue"){
		title1 = '活动下发';
		getImg("#program-upload-download",{method:"queryUpload",module:"05",operateCode:'none'});
		$("#activity-save").remove();
		$("#activity-submit").omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'
		    }
		});
		$("#return-sourse").omButton({
			icons:{
				left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/remove.png'
		    }
		});
		$(".button-stl").omButton();
		$("#summary,#feedback").hide();
		$(":input:not(:button,#leftSlt,#rightSlt,#issuedDepts),.omTimeCalendar").attr("readonly","readonly");
		$(".omDateCalendar").omCalendar('disable');
	}
	
	$("#title1").text(title1);
}
/* *******************************************界面元素初始化end************************************************* */
 
 
/**
 * 装填已下发机构
 * author: 李晓亮
 */
function fillIssuedDept(){
	 var issuedDepts = new Array();
	 $("#rightSlt option").each(function(){
		 issuedDepts.push($(this).val());
	 });
	 $("#issuedDepts").val(issuedDepts);
}

/**
 * 文件上传下载通用方法（异步获取数据）
 * author: 李晓亮
 */
function getImg (domId,paramJson){
	 var moduleJson = 
	 	{'01':{modulId:'XSZC010101',title:'合作机构证书'},
		 '02':{modulId:'XSZC010102',title:'合作机构协议'},
		 '03':{modulId:'XSZC010103',title:'代理人证件'},
		 '04':{modulId:'XSZC010104',title:'代理人协议'},
		 '05':{modulId:'XSZC010201',title:'活动方案文件'},
		 '06':{modulId:'XSZC010202',title:'活动反馈文件'},
		 '07':{modulId:'XSZC010203',title:'活动总结文'},
		 '08':{modulId:'XSZC010301',title:'公告附件文件'},
		 '09':{modulId:'XSZC010401',title:'市场调研文档'}};
	var postUrl = "<%=_path%>/upload/"+paramJson.method+".do";
	var paramStr = "mainId="+activityInfoJson.activityId+"&module="+paramJson.module;
	if(paramJson.deptCode!=""&&paramJson.deptCode!=undefined){
		paramStr+="&deptCode="+paramJson.deptCode;
	}
	Util.post(postUrl,paramStr,
			function(data){
				for(var i=0;i<data.length;i++){
					data[i].uploadId;
					$(domId).haImg(
							{
								title:moduleJson[paramJson.module].title,
								modelCode:moduleJson[paramJson.module].modulId,
								mainBillNo:activityInfoJson.activityId,
								seriesNo:data[i].uploadId,
								srcUrl:'${sessionScope.imgUrl}',
								operateEmp:operateEmp,
								operateCode:paramJson.operateCode==undefined||paramJson.operateCode==''?'AD':paramJson.operateCode
				            });
				}
			});
}

/**
 * 展现反馈详情
 */
function showFeedbackDetail(index,e){
	$("#addFeedBackDiv").omDialog('open');
	var data = $("#feedbackTab").omGrid("getData").rows[index];
	$("#jdSummary-upload-download").html("");
	getImg("#jdSummary-upload-download",{method:"queryUploadWithDpt",module:"06",deptCode:data.deptCode,operateCode:'none'});
	FillForm.fill("addFeedBackDiv",data);
	return false;
}


/**
 * 活动保存
 */
function activitySave(){
	$('#feedbackDate').omCalendar('setDate', new Date());
	if($("#filterFrm").validate().form()){
		if(actionJson.actionName == "activitySummary"){
			$.omMessageBox.alert({
	            type:'success',
	            title:'成功',
	            onClose:function(){returnSourse();},
	            content:'<font style="font:bold">保存成功!</font>'
	        });
		}else if(actionJson.actionName == "activityFeedback"){
			postUrl = "<%=_path%>/activity/activityFeedbackSave.do?activityId="+activityInfoJson.activityId+"&feedbackId="+activityInfoJson.feedbackId;
		}else{
			postUrl = "<%=_path%>/activity/activitySave.do?activityId="+activityInfoJson.activityId;
		}
		Util.post(postUrl,$("#filterFrm").serialize(),
				function(data){
					$.omMessageBox.alert({
		                type:'success',
		                title:'成功',
		                content:'<font style="font:bold">保存成功!</font>',
		                onClose:function(){returnSourse();}
		            });
				});
	}else {
		 $.omMessageBox.alert({
            type:'error',
            title:'警告！',
            content:'<font style="font:bold">校验失败！！</font>',
            onClose:function(value){
            	return false;
            }
        });
	}
}

/**
 * 活动提交前事务处理
 */
function activityBeforeSubmit(){
	if (actionJson.actionName == "activityFeedback"||actionJson.actionName == "activitySummary"){
		activitySubmit();
	}else if($("#filterFrm").validate().form()){
		$("#issueDiv").omDialog("open");
	}
}

/**
 * 活动提交
 */
 function activitySubmit(){
	var date = new Date();
	 $('#feedbackDate').omCalendar('setDate',date);
	 if($("#filterFrm").validate().form()){
		var postUrl = '';
		if(actionJson.actionName == "activityFeedback"){
			postUrl = "<%=_path%>/activity/activityFeedbackSubmit.do?activityId="+activityInfoJson.activityId+"&feedbackId="+activityInfoJson.feedbackId;
		}else if(actionJson.actionName == "activitySummary"){
			postUrl = "<%=_path%>/activity/activitySummaryUpdate.do?activityId="+activityInfoJson.activityId;
		}else{
			postUrl = "<%=_path%>/activity/activitySubmit.do?activityId="+activityInfoJson.activityId;
		}
		Util.post(postUrl,$("#filterFrm").serialize(),
				function(data){
					$.omMessageBox.alert({
		                type:'success',
		                title:'成功',
		                content:'<font style="font:bold">提交成功！！</font>',
		                onClose:function(value){
		                	returnSourse();
		                }
		            });
				}
		);
	 }else {
		 $.omMessageBox.alert({
             type:'error',
             title:'警告！',
             content:'<font style="font:bold">校验失败！！</font>',
             onClose:function(value){
            	 return false;
             }
         });
	 }
}

/**
 * 返回请求界面
 */
function returnSourse(){
	location.href = "<%=_path%>/view/activity/"+actionJson.soursePage+".jsp";
}



</script>
</head>
<body>
	<form id="filterFrm" class="om-widget">
		<div id="activityInfo" >
		    <div>
		    	<fieldset>
		    		<table width=100%>
			    	<tr>
				    	<td id="title1">活动查询：</td>
			    	</tr>
			    	</table>
		    	</fieldset>
		    	
		    </div>
		    <fieldset>
		    	<legend style="margin-left: 40px; font-size: 14px;">基本信息</legend>
				<div id="activityInfo-base">
					<table >
						<tr>
							<td width="120px" align="right"><span class="label">活动名称：</span></td>
			                <td >
				                <input class="omRequired" name="activityName" id="activityName"/><span class="color_red">*</span>
				                <input id="issuedDepts" name="issuedDepts" type="hidden" value=""/>
				                <input id="programUploadId" name="programUploadId" type="hidden" value=""/>
			                </td>
			                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
			            </tr>
						<tr>
							<td width="120px" align="right"><span class="label">项目负责人：</span></td>
			                <td ><input class="omRequired" name="projectUser" id="projectUser"/><span class="color_red">*</span></td>
			                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
			                <td width="120px" align="right"><span class="label">小组成员：</span></td>
			                <td ><input class="omRequired" name="activityMember" id="activityMember"/><span class="color_red">*</span></td>
			                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
			                <td width="120px" align="right"><span class="label">销售活动目的：</span></td>
			                <td ><input class="omRequired" name="activityTarget"  id="activityTarget"/><span class="color_red">*</span></td>
			                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
						</tr>
						<tr>
							<td width="120px" align="right"><span class="label">参与对象：</span></td>
			                <td ><input class="omRequired" name="attend" id="attend"/><span class="color_red">*</span></td>
			                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
			                <td width="120px" align="right"><span class="label">目标客户：</span></td>
			                <td ><input class="omRequired" name="client" id="client"/><span class="color_red">*</span></td>
			                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
			                <td width="120px" align="right"><span class="label">考核频度：</span></td>
			                <td ><input class="omRequired" name="frequency" id="frequency"/><span class="color_red">*</span></td>
			                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
						</tr>
						<tr>
							<td width="120px" align="right"><span class="label">活动管理机构：</span></td>
			                <td ><input readonly="readonly" class="omRequired" name="deptCode" id="deptCode" value=""/><span class="color_red">*</span></td>
			                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
			                <td width="120px" align="right"><span class="label">活动时间起：</span></td>
			                <td ><input class="omRequired omDateCalendar" name="beginDate" id="beginDate" /><span class="color_red">*</span></td>
			                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
			                <td width="120px" align="right"><span class="label">活动时间止：</span></td>
			                <td><input class="omRequired omDateCalendar" name="endDate" id="endDate" /><span class="color_red">*</span></td>
			                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
						</tr>
						<tr>
			                <td align="right">预期目标：</td>
			                <td  colspan=5 >
			                  <textarea rows= 3 class="omRequired textarea_text" omMaxLength=1000 style="height: 50px;" name="expect" id="expect" cols="55"></textarea><span class="color_red">*</span>
			                </td>
			                <td><span class="errorImg"></span><span class="errorMsg"></td>
			            </tr>
					</table>
				</div>
		    </fieldset>
			<div id="program">
				<div id="program-upload-download"></div>
			</div>
			<div id="summary">
				<div id="summary-upload-download"></div>
			</div>
			<div id="feedback">
				<div id = "feedbackTab"></div>
				<div id="addFeedBackDiv">
					<div id="activityFeedback-base">
						<table>
							<tr>
								<td width="100px" align="right"><span class="label">填报日期：</span></td>
				                <td ><input class="omRequired omTimeCalendar" name="feedbackDate" id="feedbackDate" /><span class="color_red">*</span></td>
				                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
				                <td width="100px" align="right"><span class="label">填报人：</span></td>
				                <td ><input class="omRequired" name="feedbackUser" id="feedbackUser" /><span class="color_red">*</span></td>
				                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
				                <td width="100px" align="right"><span class="label">联系电话：</span></td>
				                <td ><input class="omRequired omTel" name="tel" id="tel"/><span class="color_red">*</span></td>
				                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
							</tr>
						</table>
					</div>
					<div id="jdSummary-upload-download"></div>
				</div>
			</div>
			<div id="issueDiv" align="center">
			</div>
			<div align="center">
				<span id="activity-submit" onclick="activityBeforeSubmit()" class="button-stl">提交</span>
	    		<span id="activity-save" onclick="activitySave()" class="button-stl">保存</span>
	    		<span id="return-sourse" onclick="returnSourse()" class="button-stl">返回</span>
    		</div>
		</div>
	</form>

</body>
</html>