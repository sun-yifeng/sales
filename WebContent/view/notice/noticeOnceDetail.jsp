<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>单次公告详情</title>
<link rel="stylesheet"  type="text/css"  href="<%=_path%>/view/notice/add.css"/>
<style type="text/css">

.errorImg {
	background: url("<%=_path%>/images/msg.png") no-repeat scroll 0 0 transparent;
	height: 16px;
	width: 16px;
	cursor: pointer;
}

</style>
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>

<script type="text/javascript" src="<%=_path%>/view/notice/deptDropListReadOnly.js?v=2132138746"></script>
<script type="text/javascript" src="<%=_path%>/core/js/ref/operamasks-ui-2.1/ui/om-itemselectorReadonly.js?v=12433"></script>
<script type="text/javascript">

// 设置全局上下文路径
Util.appCxtPath = "/xszc";

var operateEmp = "mg";

//禁用删除键的返回作用
document.onkeydown = function() {
	 // 如果按下的是退格键
     if(event.keyCode == 8) {
     // 如果是在textarea内不执行任何操作
	        if(event.srcElement.tagName.toLowerCase() != "input"  && event.srcElement.tagName.toLowerCase() != "textarea" && event.srcElement.tagName.toLowerCase() != "password"){
	            event.returnValue = false;
	        }
	        // 如果是readOnly或者disable不执行任何操作
	        if(event.srcElement.readOnly == true || event.srcElement.disabled == true){
	            event.returnValue = false;
	        }
     }
}

</script>

<script type="text/javascript">
var dataGrid;
var title1 = "单次公告详情";
var noticeInfoJson = JSON.parse('${noticeDetail}');
var noticeJson = JSON.parse('${paraMap}');

var programTabHand = [ 
                      {header : '序号', name : 'noticId',width:100,  align : 'left'}, 
	                    {header : '附件', name : 'name',width:400,  align : 'left'},
	                    {header : '上传日期', name : 'createdDate',width:250, align : 'left'}, 
	                    {header : '操作', name : 'operation', width: "autoExpand", align:'center', renderer:function(colValue, rowData, rowIndex){
	                   	 var data = rowData;
	                   	 return '<button onClick="showRowdata('+rowIndex+',event)" class="button-stl">下载</button>';
	                    }}
                    ];
                    
var summaryTabHand = [ 
                     	{header : '序号', name : 'uploadId',width:100,  align : 'left'}, 
	                    {header : '附件', name : 'name',width:400,  align : 'left'},
	                    {header : '上传日期', name : 'createdDate',width:250, align : 'left'}, 
	                    {header : '操作', name : 'operation', width: "autoExpand", align:'center', renderer:function(colValue, rowData, rowIndex){
	                   	 var data = rowData;
	                   	 return '<button onClick="showRowdata('+rowIndex+',event)" class="button-stl">下载</button>';
	                    }}
                  	 ];
                  	 
var jdSummaryTabHand = [ 
                     	{header : '序号', name : 'uploadId',width:80,  align : 'left'}, 
	                    {header : '附件', name : 'name',width:150,  align : 'left'},
	                    {header : '上传日期', name : 'createdDate',width:100, align : 'left'}, 
	                    {header : '操作', name : 'operation', width: 100, align:'center', renderer:function(colValue, rowData, rowIndex){
	                   	 var data = rowData;
	                   	 return '<button onClick="showRowdata()" class="button-stl">下载</button>';
	                    }}
                  	 	];

var feedbackTabHand = [
                       {header : "反馈机构",align:'center',name : "deptName",width:100},
                       /* {header : "业务线",align:'center',name : "lineName",width:100}, */
                       {header : "反馈人",align:'center',name : "feedbackUser",width:100},
                       {header : "反馈时间",align:'center',name : "feedbackDate",width:200},
                       {header : "反馈内容",name : "feedbackContent",width:200},
                       {header : "反馈状态",align:'center',name : "status",width:100,renderer:function(value,rowData,rowIndex){
                      	 if(value=="0"){ return "未下发"; }else if(value=="1"){return "未反馈";}else if(value=="2"){return "已反馈";}else if(value=="3"){return "已处理";}
                    	 else if(value=="4"){return "已驳回";}else if(value=="5"){return "待发布";}else if(value=="9"){return "已终止";}
                        }},
                       {header : '操作', name : 'operation', width: "autoExpand", align:'center', renderer:function(colValue, rowData, rowIndex){
                      	 return '<span onclick="showFeedbackDetail('+rowIndex+',event);" class="button-stl-tab">详情</span>';
                  }}];
                      
/**
 * 界面原型初始化
 */
$(function(){
	$("#filterFrm").find("input[type!='checkbox']").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$(".omDateCalendar").css({"width":"139px"});
	
	var noticId = noticeInfoJson.noticId;;
	FillForm.fill("filterFrm",noticeInfoJson);
	
	/* var businessLine = noticeInfoJson.businessLine.split(",");
	for(var index=0;index<businessLine.length;index++){
		$("input[name='businessLine'][value='"+ businessLine[index] +"']").attr("checked","checked");
	}
	$("input[name='businessLine']").attr("disabled",true); */
		
	$("#publishRule").omCombo({value:noticeInfoJson.publishRule});
	
	$(".omDateCalendar").omCalendar();
	$(".omDateCalendar").css({"width":"129px"});
	$("#noticeInfo-base").omPanel({
    	title : "基本信息",
    	collapsible:true,
    	collapsed:false,
    });
	
	$("#noticeFeedback-base").omPanel({
    	title : "基本信息",
    	collapsible:true,
    	collapsed:false,
    });

	//初始化页面保存、重置、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-reset").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	
	initPage(noticeJson);
	initSelectDept();
	initSelectUserRole();
	initPeroid ();
	validateForm.validate("#filterFrm");
	showUploadFile();
});

function showUploadFile(){
	$("#jdSummary-upload-download").html("");
	getImg("#jdSummary-upload-download",{method:"queryTimingUploadMajor",module:"08",mainId:noticeInfoJson.noticId,operateCode:'none'});
}

function initPeroid()
{
//每年、半年、每季度、每月、每周，每日
	$("#publishRule").omCombo({
		dataSource : [{text : '立刻', value : '1'},
		               {text : '定时', value : '0'}
					 ],
		emptyText:'请选择',
		editable : false,
        readOnly : true,
        lazyLoad:true
	});

	//关系类型：总-分（0）、分-支（1）、总-支（2）
	$("#relationType").omCombo({
		dataSource : [ {text : '总公司-分公司', value : '0'},
		               {text : '分公司-支公司', value : '1'}, 
                       {text : '总公司-支公司', value : '2'}
					 ],
		emptyText:'请选择',
		value:noticeInfoJson.RELATION_TYPE,
        editable:false,
        lazyLoad:true,
        disabled : true	
	});
	
	//反馈类型：所有接收岗位必反馈（0）、任意接收岗位反馈（1）
	$("#feedbackType").omCombo({
		dataSource : [ {text : '所有接收岗位必反馈', value : '0'},
                       {text : '任意接收岗位反馈', value : '1'}],
		emptyText:'请选择',
        editable:false,
        lazyLoad:true,
        value:noticeInfoJson.feedbackType,
        disabled : true
	});
}
/**
初始化部门
*/
function initSelectDept()
{
    var selectedDepts = (noticeInfoJson.depts).split(",");
    var deptDataUrl = "<%=_path%>/notice/queryAllReceiveDept.do"; 
    var deptCode = 	noticeInfoJson.publishDeptCode;
    		
     $.post(deptDataUrl,"deptCode="+deptCode,function(objData){
		$('#receiveDept').omItemSelector({
	        availableTitle : '可选择部门',
	        selectedTitle : '已选择部门',
	        height:'350',
	        width:'450',

		dataSource : objData ,
		
		     value:selectedDepts ,
		     onBeforeItemDeselect:function(itemDatas,event){
	    	      return false;
	    	},onBeforeItemSelect:function(itemDatas,event){
	    		return false;
	    	}
			 });
		
	},'json');
}

/**
初始化角色
*/
function initSelectUserRole()
{    		
	var selectedRoles = (noticeInfoJson.roles).split(",");
	var roleDataUrl = "<%=_path%>/notice/queryAllReceiveRole.do?relationType="+noticeInfoJson.RELATION_TYPE+"&createdUserRole="+noticeInfoJson.createdUserRole;
	     $.post(roleDataUrl,"",function(objData){
			$('#receiveRole').omItemSelector({
		        availableTitle : '可选择角色',
		        selectedTitle : '已选择角色',
		        height:'350',
		        width:'450',
			    dataSource : objData,
			    value:selectedRoles ,
			     onBeforeItemDeselect:function(itemDatas,event){
		    	      return false;
		    	},onBeforeItemSelect:function(itemDatas,event){
		    		return false;
		    	}
			});
		
	},'json');
		
}
/**
 * 初始化页面管控
 */
function initPage(action){
	if(action.actionName == "noticeDetail"){
		$(":input:not(.om-btn-txt)").attr("readonly","true");
		$(".omDateCalendar").omCalendar('disable');
		$(".button-stl").hide();
		$("#return-sourse").show().omButton();
		
		$("#feedbackTab").omGrid(
				{
	                dataSource : "<%=_path%>/notice/findNoticeFeedbackByNoticId.do?noticeId="+action.noticId,
	                title: "公告反馈 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox'  id='noFeedback' value='1' onclick='notFeedback()'/>未反馈 &nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' value='2' id='hasFeedback' onclick='notFeedback()'/>已反馈&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' value='4' id='hasReject' onclick='notFeedback()'/>已驳回&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' value='3' id='hasDeal' onclick='notFeedback()'/>已处理",
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
	}else if(action.actionName == "noticeAdd") {
		$(".button-stl").omButton();
		$("#summary,#feedback").hide();
	}else if(action.actionName == "noticeModify"){
		$(".button-stl").omButton();
		$("#summary,#feedback").hide();
		$(":input:not(.om-btn-txt,#endDate)").attr("readonly","true");
		$(".omDateCalendar:not(#endDate)").omCalendar('disable');
	}else if(action.actionName == "noticeSummary"){
		$(".button-stl").omButton();
		$("#programFileButton").hide();
		$(":input:not(.om-btn-txt)").attr("readonly","true");
		$(".omDateCalendar").omCalendar('disable');
	}
}

/**
 * 展现反馈详情
 */
function showFeedbackDetail(index,e){
	$("#addFeedBackDiv").omDialog('open');
	var data = $("#feedbackTab").omGrid("getData").rows[index];
	$("#feedBack-upload-download").html("");
	getImg("#feedBack-upload-download",{method:"queryUploadWithDpt",module:"10",mainId:noticeInfoJson.noticId,deptCode:data.deptCode,operateCode:'none'});
	FillForm.fill("addFeedBackDiv",data);
	return false;
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
 		 '09':{modulId:'XSZC010401',title:'市场调研文档'},
 		 '10':{modulId:'XSZC010302',title:'公告反馈附件'}};
 	var postUrl = "<%=_path%>/notice/"+ paramJson.method +".do";
 	var paramStr = "mainId="+paramJson.mainId+"&module="+paramJson.module;
 	
 	if(paramJson.deptCode!=""&&paramJson.deptCode!=undefined){
 		paramStr+="&deptCode="+paramJson.deptCode;
 	}
 	if(paramJson.feedbackId!=""&&paramJson.feedbackId!=undefined){
 		paramStr+="&feedbackId="+paramJson.feedbackId;
 	}
 	
 	Util.post(postUrl,paramStr,
 			function(data){
 				if(data != "" && data != undefined && data != "undefined"){
 					for(var i=0;i<data.length;i++){
 						data[i].uploadId;
 						$(domId).haImg({
 							title:moduleJson[paramJson.module].title,
 							modelCode:moduleJson[paramJson.module].modulId,
 							mainBillNo:"",
 							seriesNo:data[i].batchNumber,
 							srcUrl:'${sessionScope.imgUrl}',
 							operateEmp:operateEmp,
 							operateCode:paramJson.operateCode==undefined||paramJson.operateCode==''?'AD':paramJson.operateCode
 			            });
 					}
 				}else{
 					$("#uploadId").val(uploadId);
 					$(domId).haImg({
 						title:'公告反馈附件',
 						modelCode:'XSZC010302',
 						mainBillNo:"",
 						seriesNo:uploadId,
 						srcUrl:'${sessionScope.imgUrl}',
 						operateEmp:operateEmp,
 						operateCode:paramJson.operateCode==undefined||paramJson.operateCode==''?'AD':paramJson.operateCode
 		            });
 				}
 			});
 }

/**
 * 活动保存
 */
function noticeSave()
{
     if($("#filterFrm").validate().form()){

		var deptvalue = $("#receiveDept").omItemSelector('value');
	
	
		$("#receiveDeptId").attr("value",deptvalue);
	
		{
			Util.post("<%=_path%>/notice/noticeSave.do?"+$("#filterFrm").serialize(),{},
					function(data){
						$.omMessageBox.alert({
			                type:'success',
			                title:'成功',
			                content:'<font style="font:bold">保存成功!</font>',
			                onClose:function(value){
			                    $("#filterFrm")[0].reset();
			                    window.location.href = "<%=_path%>/view/notice/noticeOnceQuery.jsp";
			                }
			            });
					});
		}
	}
	
}

/**
 * 活动提交
 */
 function noticeSubmit(){
	 if($("#filterFrm").validate().form()){
		 if(actionJson.actionName == "noticeSummary"){
			 Util.post("<%=_path%>/notice/noticeSummaryUpdate.do?noticId="+noticeInfoJson.noticId,
						$("#filterFrm").serialize(),
						function(data){
							$.omMessageBox.alert({
				                type:'success',
				                title:'成功',
				                content:'<font style="font:bold">提交成功！！</font>',
				                onClose:function(value){
				                    $("#filterFrm")[0].reset();
				                }
				            });
						});
		}else{
			Util.post("<%=_path%>/notice/noticeSubmit.do?noticId="+noticeInfoJson.noticId,
					$("#filterFrm").serialize(),
					function(data){
						$.omMessageBox.alert({
			                type:'success',
			                title:'成功',
			                content:'<font style="font:bold">提交成功！！</font>',
			                onClose:function(value){
			                    $("#filterFrm")[0].reset();
			                }
			            });
					});
		}
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
	location.href = "<%=_path%>/view/notice/"+actionJson.soursePage+".jsp";
}


$(document).ready(function()
{
// 这里是加入下拉的部门
deptdrop("<%=_path%>");

});

function search(status){
	 $('#feedbackTab').omGrid('setData', "<%=_path%>/notice/findNoticeFeedbackByNoticId.do?noticeId="+noticeJson.noticId+"&statusNum="+status); 
}
//复选框操作事件
function notFeedback(){
	 var check1 = $('#noFeedback').is(':checked');
	  var check2 = $('#hasFeedback').is(':checked');
	  var check3 = $('#hasReject').is(':checked');
	  var check4 = $('#hasDeal').is(':checked');
	  var status;
	  var status1;
	  var status2;
	  var status3;
	  var status4;
	if(check1){
		status1='1';
	}else{
		status1='';
	}
	if(check2){
		status2='2';
	}else{
		status2='';
	} 
	if(check3){
		status3='4';
	}else{
		status3='';
	} 
	if(check4){
		status4='3';
	}else{
		status4='';
	} 
	status = status1+","+status2+","+status3+","+status4;
	search(status);
}

</script>

</head>
<body>
    <div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
	<form id="filterFrm" >
		<div id="noticeInfo" style="width: 100%;">
		    
		    <div>
			<table class="fontClass" style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
		    	<tr>
			    	<td>单次公告详情</td>
			    
		    	</tr>
		    	</table>
		    </div>
		    <div>
		    
			<fieldSet style="margin-top: 10px;">
			<legend class="fontClass" style="margin-left: 40px;">基本信息</legend>
			
				<table class="fontClass" style="">
					<tr>
						<td style="padding-left:30px" align="right" nowrap><span class="label">公告编码：</span></td>
		                <td  nowrap><input readOnly = "true" class="disabled:true" name="noticId" id="noticId"/>
		                <span style="color:red">*</span></td>
		                <td><span class="errorImg"></span><span class="errorMsg" ></span>
		                </td>
		                
		                <td style="padding-left:30px" align="right" nowrap><span class="label">发布机构部门：</span></td>
						<td  nowrap> 
							<span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="deptCname" id="deptCname"/><span id="choose" name="choose" class="om-combo-trigger"></span></span>
						 <span style="color:red">*</span></td>
						 <td><span class="errorImg"></span><span class="errorMsg" ></span>
						 </td>
						
						<td style="padding-left:30px" align="right" nowrap><span class="label">机构部门编码：</span></td>
						<td  nowrap><input name="publishDeptCode" id="publishDeptCode" readonly="readonly" />
						<span style="color:red">*</span>
						<span class="errorImg"></span><span class="errorMsg"></span>
						</td>
		              
		               
		            </tr>
					<tr>
					<td width="120px" align="right" nowrap><span class="label">公告标题：</span></td>
		                <td  nowrap><input class="omRequired" name="tiltle" id="tiltle" readonly = "readonly"/>
		                <span class="color_red">*</span></td>
		                <td>
		                <span class="errorImg"></span><span class="errorMsg" ></span></td>
		                
						<td width="120px" align="right" nowrap><span class="label">发布人：</span></td>
		                <td  nowrap><input class="omRequired" name="publisher" id="publisher" readonly = "readonly"/>
		                <span class="color_red">*</span></td>
		                <td>
		                <span class="errorImg"></span><span class="errorMsg" ></span></td>
		                
		                <td width="120px" align="right"><span class="label">反馈有效期(天)：</span></td>
		                <td><input class="omRequired " name="feedbackDay" id="feedbackDay" readonly = "readonly"/>
		                <span class="color_red">*</span>
		                </td>
		                <td><span class="errorImg"></span><span class="errorMsg" ></span></td>
		                
					</tr>
					
					<tr>
						<td width="120px" align="right"><span class="label">发布规则：</span></td>
		                <td ><input class="sele omRequired" name="publishRule" id="publishRule" style="width:136px;" />
			                <span class="color_red">*</span>
			               </td>
		                <td><span class="errorImg"></span><span class="errorMsg" ></span></td>
		                
		                <td width="120px" align="right"><span class="label">发布日期：</span></td>
		                <td ><input class="sele omRequired omDateCalendar"  name="publishDate" id="publishDate" readonly = "readonly"/>
		                	<span class="color_red">*</span></td>
		                <td>
		                <span class="errorImg"></span><span class="errorMsg" ></span></td>
		                <td width="120px" align="right" nowrap><span class="label">发送层级：</span></td>
		                <td ><input class="sele omRequired" name="relationType" id="relationType"  />
		                <span class="color_red">*</span>
		                </td>
		                <td><span class="errorImg"></span><span class="errorMsg" ></span></td>
					</tr>
					
					<tr>
		                <td width="120px" align="right"><span class="label">反馈类型：</span></td>
		                <td ><input class="sele omRequired"  name="feedbackType" id="feedbackType"/>
		                	<span class="color_red">*</span></td>
		                <td><span class="errorImg"></span><span class="errorMsg" ></span></td>
					</tr>
					<tr>
						<td width="120px" align="right"><span class="color_red">*</span><span class="label">公告内容：</span></td>
		                <td  colspan="7"><textarea rows="8" cols="102" class="omRequired" name="content" id="content" readonly = "readonly"></textarea>
		                </td>
		                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>   
					</tr>

					<tr>
						<td width="120px" align="right"><span class="color_red">*</span><span class="label">发布对象：</span></td>
		                <td colspan="5"><div name="receiveDept" id="receiveDept" readonly = "readonly"></div>
		                </td>
		                <td colspan="5"><div id="receiveRole"></div>
		                </td>
		                <td><input type="hidden" value="121" id="receiveDeptId" name="receiveDeptId">
		                </td>
		                <td><input type="hidden" value="121" id="receiveRoleId" name="receiveRoleId">
		                </td>		                
					</tr>					
					<tr>
		                <td height="30" colspan="6"></td>
					</tr>
					
				</table>
			</div>
			
			
			<!-- 附件上传框 -->
<!-- 			<div id="jdSummary-upload-download"  style="width: 100%;"></div> -->
	  
			<div id="feedback">
				<div id = "feedbackTab"></div>
				<div id="addFeedBackDiv">
					<div id="activityFeedback-base">
						<table>
							<tr>
								<td width="100px" align="right"><span class="label">反馈时间：</span></td>
				                <td ><input class="omRequired omTimeCalendar" type = "text" name="feedbackDate" id="feedbackDate" /></td>
				                <td width="100px" align="right"><span class="label">反馈人：</span></td>
				                <td ><input class="omRequired" type = "text" name="feedbackUser" id="feedbackUser" /></td>
				            </tr>
				            <tr>
				                <td width="100px" align="right"><span class="label">反馈内容：</span></td>
				                <td colspan="3"><textarea style="height:50px;" cols="60" class="omRequired omTel" name="feedbackContent" id="feedbackContent"></textarea></td>
							</tr>
				            <tr>
				                <td width="100px" align="right"><span class="label">处理内容：</span></td>
				                <td colspan="3"><textarea style="height:50px;" cols="60" class="omRequired omTel" name="processContent" id="processContent"></textarea></td>
							</tr>
						</table>
					</div>
<!-- 					<div id="feedBack-upload-download"></div> -->

				</div>
			</div>
			<div>
				
		<!-- 新影像系统bgn -->
    <div>
      <fieldSet>
        <legend>影像资料</legend>
        <div style="margin-left: 20px;margin-bottom: 10px;">
          <a href='http://ecmp.sinosafe.com.cn:8080/Interface_Cluster/FileShowAction?SystemCode=XSZC01&FunctionCode=XSZC0103&OrgCode=01010000&UserCode=100052692&BatchFlg=0&AuthorizCode=1111&BusinessCode=xszc' target="_blank">公告附件</a>
        </div>
      </fieldSet>
    </div>
    <!-- 新影像系统end -->		
				
		<table style="width: 100%">
			<tr>
				<td style="padding-left:30px;padding-top:10px" align="center">
	
				<a class="om-button" href="javascript:history.go(-1);" id="button-cancel">返回</a></td>
			</tr>
		</table>
					
			
		</div>
		</div>
	</form>

</body>
</html>