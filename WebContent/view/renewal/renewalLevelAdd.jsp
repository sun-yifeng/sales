<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>续保下发级别增加</title>

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
var title1 = "续保下发级别增加";
var noticeInfoJson = JSON.parse('${param.RenewalDetail}');
var noticeJson = JSON.parse('${param.paraMap}');

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
    	collapsed:false,
    });
	
	//初始化页面保存、重置、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	
	initPage(noticeJson);
	initSelectDept();
	initPeroid ();
	validateForm.validate("#filterFrm");
	
	$("#publisher").val(noticeJson.userCName);
	$("#publisher").attr("readonly","true");
	$("#createdDate").val(getnowDate());

});

function initPeroid()
{
//每年、半年、每季度、每月、每周，每日
	$("#publishRule").omCombo({
		dataSource : [ {text : '立刻', value : '1'},
		               {text : '定时', value : '2'}
					 ],
		emptyText:'请选择',
        editable:false,
        lazyLoad:true,
        onValueChange:function(target,newValue,oldValue,event){ 
		   var publishR = newValue;
			if (publishR=='1')
			{
				//publishDate
				$("#publishDate").val(getnowDate());
			}
		 }
	});

}
function publicRuleCh()
{
	var publishR = $("#publishRule").val();
	if (publishR=='1')
	{
		//publishDate
		$("#publishDate").val(getnowDate());
	}

}
function appendZero(s){return ("00"+ s).substr((s+"").length);} 

function getnowDate() 
{   
    var d = new Date();  
    
    var result = d.getFullYear() + "-" + appendZero(d.getMonth() + 1) + "-" + appendZero(d.getDate());  
    return result;  
}  
/**
初始化部门
*/
function initSelectDept()
{
    		
		$('#receiveDept').omItemSelector({
	        availableTitle : '可选择部门',
	        selectedTitle : '已选择部门',
	        height:'350',
	        width:'575',
	        dataSource : "<%=_path%>/notice/queryAllReceiveDept.do",
	        value:[],
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
 * 活动保存
 */
function noticeSave()
{
    if($("#filterFrm").validate().form()){

		//var deptvalue = $("#receiveDept").omItemSelector('value');
		
		//$("#receiveDeptId").attr("value",deptvalue);
	
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
	
}


/**
 * 返回请求界面
 */
function returnSourse(){
	location.href = "<%=_path%>/view/renewal/renewalLevelQuery.jsp";
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
				<table class="fontClass" style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
					<tr><td>单次公告新增</td></tr>
				</table>
			</div>
		    <div>
		    
			<fieldSet style="margin-top: 10px;">
			<legend class="fontClass" style="margin-left: 40px;">基本信息</legend>
			
				<table class="fontClass" style="">
					<tr>
						<td style="padding-left:30px" align="right" nowrap><span class="label">公告编码：</span></td>
		                <td  nowrap><input disabled = "true" class="disabled:true" name="noticId" id="noticId"/>
		                <span style="color:red">*</span></td>
		                <td><span class="errorImg"></span><span class="errorMsg" ></span>
		                </td>
		                
		                <td style="padding-left:30px" align="right" nowrap><span class="label">发布机构部门：</span></td>
						<td  nowrap><span class="om-combo om-widget om-state-default">
						<input class="sele" type="text" name="deptCname" id="deptCname" readonly="true"  style="width:123px;"/>
						<span id="choose" name="choose" class="om-combo-trigger"></span></span>
						 <span style="color:red">*</span></td>
						 <td><span class="errorImg"></span><span class="errorMsg" ></span>
						 </td>
						
						<td style="padding-left:30px" align="right" nowrap><span class="label">机构部门编码：</span></td>
						<td  nowrap><input name="publishDeptCode" id="publishDeptCode" readonly="true" />
						<span style="color:red">*</span>
						<span class="errorImg"></span><span class="errorMsg"></span>
						</td>
		              
		               
		            </tr>
					<tr>
					<td width="120px" align="right" nowrap><span class="label">下发级别：</span></td>
		                <td  nowrap><input class="omRequired" name="assignLevel" id="assignLevel"/>
		                <span class="color_red">*</span></td>
		                <td>
		                <span class="errorImg"></span><span class="errorMsg" ></span></td>
		                
					</tr>
					
									
					<tr>
						
		                <td height="30" colspan="6"></td>		                
		                
					</tr>
					
					
				</table>
			</div>
				
		<div>
				
		<table style="width: 100%">
			<tr>
				<td style="padding-left:30px;padding-top:10px" align="center">
				<a class="om-button" id="button-save" onclick="noticeSave()">保存</a>
				
				<a class="om-button" href="javascript:history.go(-1);" id="button-cancel" onclick="returnSourse()">取消</a></td>
			</tr>
		</table>
					
			
		</div>
	</form>

</body>
</html>