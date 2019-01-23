<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>单次公告查询</title>
<link rel="stylesheet"  type="text/css"  href="<%=_path%>/view/notice/add.css"/>
<style type="text/css">

.errorImg {
	background: url("<%=_path%>/images/msg.png") no-repeat scroll 0 0 transparent;
	height: 16px;
	width: 16px;
	cursor: pointer;
}

</style>

<script type="text/javascript" src="<%=_path%>/view/notice/deptDropList.js?v=2138746"></script>

<script type="text/javascript">
var dataGrid;
var title1 = "单次公告查询";
var noticeInfoJson = JSON.parse('${param.noticeDetail}');
var noticeJson = JSON.parse('${param.paraMap}');
noticeJson.pppp='665555';
var programTabHand = [ 
                      {header : '序号', name : 'noticeId',width:100,  align : 'left'}, 
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
                      {header : "反馈号",name : "feedbackId",width:200},
                      {header : "反馈人",name : "feedbackUser",width:200},
                      {header : "反馈时间",name : "feedbackDate",width:200},
                      {header : "反馈人电话",name : "tel",width:200},
                      {header : '操作', name : 'operation', width: "autoExpand", align:'center', renderer:function(colValue, rowData, rowIndex){
 	                   	 var data = rowData;
 	                   	 return '<span onclick="showFeedbackDetail('+rowIndex+',event);" class="button-stl-tab">详情</span>';
 	                   }}
                      ];
                      
/**
 * 界面原型初始化
 */
$(function(){
	var noticeId = noticeInfoJson.noticeId;;
	FillForm.fill("filterFrm",noticeInfoJson);
	$(".omDateCalendar").omCalendar();
	$("#noticeInfo-base").omPanel({
    	title : "基本信息",
    	collapsible:true,
    	collapsed:false
    });
	
	$("#noticeFeedback-base").omPanel({
    	title : "基本信息",
    	collapsible:true,
    	collapsed:false
    });
	
	$("#program-upload-download").omGrid(
			{
				dataSource : "<%=_path%>/notice/queryPragramInfo.do?noticeId="+noticeId,
                title: "方案及模板上传",
                limit : 0,
                height : 150,
                showIndex : false,
                colModel : programTabHand,
                method : 'POST'
            });
	
	
	$("#summary-upload-download").omGrid(
			{
                title: "总结上传",
                dataSource : 'column-hide-data.json',
                limit : 0,
                height : 150,
                showIndex : true,
                colModel : summaryTabHand,
                method : 'POST'
            });
	
	$("#jdSummary-upload-download").omGrid(
			{
                title: "活动小结上传",
                dataSource : 'column-hide-data.json',
                limit : 0,
                autoFit : true,
                height : 150,
                width: 676,
                showIndex : true,
                colModel : jdSummaryTabHand,
                method : 'POST'
            });
	
	$("#feedbackTab").omGrid(
			{
                dataSource : "<%=_path%>/notice/findnoticeFeedback.do?noticeId="+noticeInfoJson.noticeId,
                title: "活动反馈",
                limit : 0,
                height : 200,
                showIndex : true,
                autoFit : true,
                colModel : feedbackTabHand,
                method : 'POST'
            });
	
	$("#addFeedBackDiv").omDialog({
			autoOpen : false, 
            resizable: false,
            width: 700,
            buttons: [{
                text : "确定", 
                click : function () {
                    $("#addFeedBackDiv").omDialog("close");
                }
            }]
		}
	);
	
	
	//初始化页面保存、重置、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-reset").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	
	initPage(noticeJson);
	initSelectDept();
	initPeroid ();
	validateForm.validate("#filterFrm");

});

function initPeroid()
{
//每年、半年、每季度、每月、每周，每日
	$("#publishRule").omCombo({
		dataSource : [ {text : '立刻', value : '1'},
		               {text : '定时', value : '2'}
					 ],
		width:"80px",
		emptyText:'请选择',
        editable:false,
        lazyLoad:true
	});

}
/**
初始化部门
*/
function initSelectDept()
{
    var selectedDepts = (noticeInfoJson.depts).split(",");
    
    		
			$('#receiveDept').omItemSelector({
		        availableTitle : '可选择部门',
		        selectedTitle : '已选择部门',
		        height:'350',
		        width:'575',
		        dataSource : "<%=_path%>/notice/queryAllReceiveDept.do",
		        value:selectedDepts ,
		        onSuccess:function(data, textStatus, event){
		            if(data.length==0){
		                 alert('没有可以选择的部门!');
		            }else{
		            	//$('#roleSysUserId').val(cells[0].sysUserId);
		            } 
		        }
			 });
}
/**
 * 初始化页面管控
 */
function initPage(action){
	if(action.actionName == "noticeDetail"){
		$(":input:not(.om-btn-txt)").attr("disabled","disabled");
		$(".omDateCalendar").omCalendar('disable');
		$(".button-stl").hide();
		$("#return-sourse").show().omButton();
	}else if(action.actionName == "noticeAdd") {
		$(".button-stl").omButton();
		$("#summary,#feedback").hide();
	}else if(action.actionName == "noticeModify"){
		$(".button-stl").omButton();
		$("#summary,#feedback").hide();
		$(":input:not(.om-btn-txt,#endDate)").attr("disabled","disabled");
		$(".omDateCalendar:not(#endDate)").omCalendar('disable');
	}else if(action.actionName == "noticeSummary"){
		$(".button-stl").omButton();
		$("#programFileButton").hide();
		$(":input:not(.om-btn-txt)").attr("disabled","disabled");
		$(".omDateCalendar").omCalendar('disable');
	}
}

/**
 * 展现反馈详情
 */
function showFeedbackDetail(index,e){
	$("#addFeedBackDiv").omDialog('open');
	var data = $("#feedbackTab").omGrid("getData").rows[index];
	FillForm.fill("addFeedBackDiv",data);
	return false;
}


/**
 * 活动保存
 */
function noticeSave(){

	

	{
		Util.post("<%=_path%>/notice/noticeSave.do?"+$("#filterFrm").serialize(),{},
				function(data){
					$.omMessageBox.alert({
		                type:'success',
		                title:'成功',
		                content:'<font style="font:bold">保存成功!</font>',
		                onClose:function(value){
		                    $("#filterFrm")[0].reset();
		                }
		            });
				});
	}
	
}

/**
 * 活动提交
 */
 function noticeSubmit(){
	 if($("#filterFrm").validate().form()){
		 if(actionJson.actionName == "noticeSummary"){
			 Util.post("<%=_path%>/notice/noticeSummaryUpdate.do?noticeId="+noticeInfoJson.noticeId,
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
			Util.post("<%=_path%>/notice/noticeSubmit.do?noticeId="+noticeInfoJson.noticeId,
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
deptdrop("<%=_path%>");

});


</script>

</head>
<body>
    <div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
	<form id="filterFrm" >
		<div id="noticeInfo" style="width:950px;">
		    <div>
		    	<table width=100%>
		    	<tr>
			    	<td>单次公告查询：</td>
			    
		    	</tr>
		    	</table>
		    </div>
			<div id="noticeInfo-base" width="100%">
				<table class="tabBase" width="100%">
					<tr>
						<td width="120px" align="right"><span class="color_red"></span><span class="label">公告编码：</span></td>
		                <td ><input disabled = "true" class="disabled:true" name="noticId" id="noticId"/></td>
		                
		                <td style="padding-left:30px" align="right"><span class="label">发布机构部门：</span></td>
						<td><span class="om-combo om-widget om-state-default">
						<input class="sele" type="text" name="deptCname" id="deptCname" readonly="true" />
						<span id="choose" name="choose" class="om-combo-trigger"></span></span><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">机构部门编码：</span></td>
						<td><input name="publishDeptCode" id="publishDeptCode" readonly="true" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                		                		
						
		                </td>
		               
		            </tr>
					<tr>
						<td width="120px" align="right"><span class="color_red">*</span><span class="label">创建人：</span></td>
		                <td ><input class="omRequired" name="publisher" id="publisher"/></td>
		                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
		                <td width="120px" align="right"><span class="color_red">*</span><span class="label">创建日期：</span></td>
		                <td ><input class="omRequired omDateCalendar"  name="createdDate" id="createdDate"/></td>
		                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>

		                
					</tr>
					
					<tr>
						<td width="120px" align="right"><span class="color_red">*</span><span class="label">公告标题：</span></td>
		                <td ><input class="omRequired" name="tiltle" id="tiltle"/></td>
		                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
		                
					</tr>
					
					<tr>
						<td width="120px" align="right"><span class="color_red">*</span><span class="label">公告内容：</span></td>
		                <td ><input class="omRequired" name="content" id="content"/></td>
		                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>   
		                
					</tr>
					<tr>
						<td width="120px" align="right"><span class="color_red">*</span><span class="label">发布对象：</span></td>
		                <td colspan="5"><div  name="receiveDept" id="receiveDept"/></td>
		                
		                
					</tr>
					
					<tr>
						
		                <td height="30" colspan="5"></td>
		                
		                
					</tr>
					<tr>
						<td width="120px" align="right"><span class="color_red">*</span><span class="label">发布规则：</span></td>
		                <td ><input class="omRequired" name="publishRule" id="publishRule"/></td>
		                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
		                
		                <td width="120px" align="right"><span class="color_red">*</span><span class="label">创建日期：</span></td>
		                <td ><input class="omRequired omDateCalendar"  name="publishDate" id="publishDate"/></td>
		                
		                <td width="120px" align="right"><span class="color_red">*</span><span class="label">反馈有效期(天)：</span></td>
		                <td><input class="omRequired " name="feedbackDay" id="feedbackDay" /></td>
		                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
					</tr>
					
				</table>
			</div>
				<!-- 附件上传框 -->
			<div>
				<fieldSet style="margin-top: 10px;">
					<legend style="margin-left: 40px;font-size:12px;"> 附件上传</legend>
					<div id="fileButtonbar"></div>
					<table id="fileTables"></table>
				</fieldSet>
			</div>
			<div>
				
		<table style="width: 100%">
			<tr>
				<td style="padding-left:30px;padding-top:10px" align="right">
	
				<a class="om-button" href="javascript:history.go(-1);" id="button-cancel">返回</a></td>
			</tr>
		</table>
					
			
		</div>
	</form>

</body>
</html>