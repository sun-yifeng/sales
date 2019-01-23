<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>单次公告发布</title>

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

<script type="text/javascript" src="<%=_path%>/view/notice/deptDropList.js?v=2138746"></script>
<script type="text/javascript" src="<%=_path%>/core/js/ref/operamasks-ui-2.1/ui/om-itemselector.js?v=12433"></script>
<script type="text/javascript">

// 设置全局上下文路径
Util.appCxtPath = "/xszc";

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
var title1 = "单次公告查询";
var noticeInfoJson = JSON.parse('${noticeDetail}');
var noticeJson = JSON.parse('${paraMap}');
var operateEmp = "mg";

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
	$("#filterFrm").find("input[type!='checkbox']").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$(".omDateCalendar").css({"width":"139px"});
	
	var noticId = noticeInfoJson.noticId;;
	FillForm.fill("filterFrm",noticeInfoJson);
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
	
	$("#program-upload-download").omGrid(
			{
				dataSource : "<%=_path%>/notice/queryPragramInfo.do?noticId="+noticId,
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
                showIndex : false,
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
                showIndex : false,
                colModel : jdSummaryTabHand,
                method : 'POST'
            });
	
	$("#feedbackTab").omGrid(
			{
                dataSource : "<%=_path%>/notice/findnoticeFeedback.do?noticId="+noticeInfoJson.noticId,
                title: "活动反馈",
                limit : 0,
                height : 200,
                showIndex : false,
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
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:60});
	$("#button-pub").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	
	initPage(noticeJson);
	initSelectDept();
	initSelectUserRole();
	initPeroid ();
	initUpload();
	validateForm.validate("#filterFrm");
	
	$("#publisher").val(noticeJson.userCName);
	$("#publisher").attr("readonly","true");
	$("#createdDate").val(getnowDate());
	$('#createdDate').omCalendar({editable : false,disabled : true});
});


function initUpload()
{
/* 上传下载初始化 */
		$("#upload_download").haImg(
				{
					title:'公告附件文件',
					modelCode:'XSZC010301',
					mainBillNo:"",
					seriesNo:noticeInfoJson.batchNumber,
					srcUrl:'${sessionScope.imgUrl}',
					operateEmp:operateEmp
				});
}

function initPeroid()
{
//每年、半年、每季度、每月、每周，每日
	$("#publishRule").omCombo({
		dataSource : [ {text : '立刻', value : '1'},
		               {text : '定时', value : '0'}
					 ],
		emptyText:'请选择',
        editable:false,
        lazyLoad:true,
        onValueChange:function(target,newValue,oldValue,event){ 
		   var publishR = newValue;
			if (publishR=='1'){
				$("#publishDate").focus();
				$("#publishDate").val(getnowDate());
				$('#publishDate').omCalendar({editable : false,disabled : true});
			}else{
				$('#publishDate').attr("value","");
				$('#publishDate').omCalendar({
					editable : false,
					disabled : false,
					disabledFn : disFn
				});
			}
		 }
	});
	
	//关系类型：总-分（0）、分-支（1）、总-支（2）
	$("#relationType").omCombo({
		dataSource : getRelationType(),
		emptyText:'请选择',
        editable:false,
        lazyLoad:true,
        onValueChange:function(target,newValue,oldValue,event){ 
        	initSelectUserRole();
        }
	});
	
	//反馈类型：所有接收岗位必反馈（0）、任意接收岗位反馈（1）
	$("#feedbackType").omCombo({
		dataSource : [ {text : '所有接收岗位必反馈', value : '0'},
                       {text : '任意接收岗位反馈', value : '1'}],
		emptyText:'请选择',
        editable:false,
        lazyLoad:true,
	});

}

function disFn(date) {
	var nowMiddle = new Date();
	var day = appendZero(nowMiddle.getDate());
    nowMiddle.setDate(day);
    if (date < nowMiddle) {
        return false;
    }
}

function publicRuleCh()
{
	var publishR = $("#publishRule").val();
	if (publishR=='1')
	{
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
var deptDataUrl = "<%=_path%>/notice/queryAllReceiveDept.do";

     $.post(deptDataUrl,"",function(objData){
		$('#receiveDept').omItemSelector({
	        availableTitle : '可选择部门',
	        selectedTitle : '已选择部门',
	        height:'350',
	        width:'450',

		    dataSource : objData ,
		    
		    /*
		    onItemDeselect:function(item,e){
	    		for ( var i = 0; i < item.length; i++) {
	    			var v = item[i].value;
			    	valArray = $.grep(valArray,function(n){
						if(n!=v){
							return n;
						}
	    			});
				}
	    		window.parent.document.getElementById("${param.eid}").value=valArray;
		    },
		    onItemSelect:function(item,e){
		    	for ( var i = 0; i < item.length; i++) {
					valArray.push(item[i].value);
				}
		    	window.parent.document.getElementById("${param.eid}").value=valArray;
		    },
		    value:op.value,
		    */
		});
		
	},'json');
		
}

/**
初始化角色
*/
function initSelectUserRole()
{    		
var roleDataUrl = "<%=_path%>/notice/queryAllReceiveRole.do?relationType="+$("#relationType").val();
     $.post(roleDataUrl,"",function(objData){
		$('#receiveRole').omItemSelector({
	        availableTitle : '可选择角色',
	        selectedTitle : '已选择角色',
	        height:'350',
	        width:'450',
		    dataSource : objData
		});
		
	},'json');
		
}
/**
 * 初始化页面管控
 */
function initPage(action){
    $("#batchNumber").val(noticeInfoJson.batchNumber);

	if(action.actionName == "noticeDetail"){
		$(":input:not(.om-btn-txt)").attr("readonly","true");
		$(".omDateCalendar").omCalendar('disable');
		$(".button-stl").hide();
		$("#return-sourse").show().omButton();
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
	FillForm.fill("addFeedBackDiv",data);
	return false;
}


/**
 * 活动保存
 */
function noticeSave(status)
{
	$("#status").val(status);
	if(status==5&&$("#publishRule").val()=="1"){
		$("#status").val("1");
	}
	//统计业务线被选中的数量
	var total = $("#relationType").val();
	
	var publishDate = $("#publishDate").val();
    if($("#filterFrm").validate().form()){

		var deptvalue = $("#receiveDept").omItemSelector('value');
		var rolevalue = $("#receiveRole").omItemSelector('value');
		var pub = $("#publishRule").val();
		
		if (deptvalue=='' || deptvalue=='undefined' || deptvalue==undefined)
		{
			$.omMessageBox.alert({
	 	        content:'您还没有选择要发布的部门',
	 	        onClose:function(value){
	 	        	return false;
	 	        }
	 	    });
		}else if (rolevalue=='' || rolevalue=='undefined' || rolevalue==undefined)
		{
			$.omMessageBox.alert({
	 	        content:'您还没有选择要发布的角色',
	 	        onClose:function(value){
	 	        	return false;
	 	        }
	 	    });
		}else if(total=='' || total=='undefined' || total==undefined){
			$.omMessageBox.alert({
	 	        content:'您还没有选择业务线',
	 	        onClose:function(value){
	 	        	return false;
	 	        }
	 	    });	
		}else{
			$("#receiveDeptId").attr("value",deptvalue);
			$("#receiveRoleId").attr("value",rolevalue);
	
			Util.post("<%=_path%>/notice/noticeSave.do?"+$("#filterFrm").serialize(),{publishDate:publishDate},
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
				}
			 );
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
	deptdrop("<%=_path%>");
	$.ajax({
		url:"<%=_path%>/notice/queryCurrentUserDepartment.do",
		type:"post",
		data:{},
		dataType:"json",
		async:false,
		success:function(msg){
			$("#deptCname").val(msg.deptName);
			$("#publishDeptCode").val(msg.deptCode);
		}
	});
});

//获取发送层级
function getRelationType(){
	$.ajax({ 
		url: "<%=_path%>/notice/getRelationType.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			if(data == "00"){
				dataRelationType=[ {text : '总公司-分公司', value : '0'},
			                       {text : '总公司-支公司', value : '2'}];
			}else{
				dataRelationType=[{text : '分公司-支公司', value : '1'}];
			}
		}
	});
	return dataRelationType;
}

</script>

</head>
<body>
    <div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
	<form id="filterFrm" >
		<input type="hidden" id="status" name="status" />
		<div id="noticeInfo" style="width: 100%;">
		   
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
		                <td  nowrap><input disabled="disabled" name="noticId" id="noticId"/>
		                <span style="color:red">*</span></td>
		                <td><span class="errorImg"></span><span class="errorMsg" ></span>
		                <input id="batchNumber" name="batchNumber" type="hidden" value=""/>
		                </td>
		                
		                <td style="padding-left:30px" align="right" nowrap><span class="label">发布机构部门：</span></td>
						<td  nowrap>
							<span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="deptCname" id="deptCname"/><span id="choose" name="choose" class="om-combo-trigger"></span></span>
						 <span style="color:red">*</span></td>
						 <td><span class="errorImg"></span><span class="errorMsg" ></span>
						 </td>
						
						<td style="padding-left:30px" align="right" nowrap><span class="label">机构部门编码：</span></td>
						<td  nowrap><input name="publishDeptCode" id="publishDeptCode" readonly="readonly"  class="omRequired" />
						<span style="color:red">*</span>
						<span class="errorImg"></span><span class="errorMsg"></span>
						</td>
		              
		               
		            </tr>
					<tr>
						<td width="120px" align="right" nowrap><span class="label">公告标题：</span></td>
		                <td  nowrap><input class="omRequired" name="tiltle" id="tiltle"/>
		                <span class="color_red">*</span></td>
		                <td><span class="errorImg"></span><span class="errorMsg" ></span></td>
		                
						<td width="120px" align="right" nowrap><span class="label">发布人：</span></td>
		                <td  nowrap><input class="omRequired" name="publisher" id="publisher"/>
		                <span class="color_red">*</span></td>
		                <td><span class="errorImg"></span><span class="errorMsg" ></span></td>
		                
		                <td width="120px" align="right"><span class="label">反馈有效期(天)：</span></td>
		                <td nowrap="nowrap">
		                	<input class="omRequired omIsNum" name="feedbackDay" id="feedbackDay" />
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
		                <td ><input class="sele omRequired omDateCalendar"  name="publishDate" id="publishDate"/>
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
		                <td>
		                <span class="errorImg"></span><span class="errorMsg" ></span></td>
					</tr>
					<tr>
						<td width="120px" align="right"><span class="color_red">*</span><span class="label">公告内容：</span></td>
		                <td  colspan="7"><textarea rows="8" cols="102" class="omRequired "  omMaxLength=300 name="content" id="content" ></textarea>
		                </td>
		                <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>   
		                
					</tr>
					<tr>
						<td width="120px" align="right"><span class="color_red">*</span><span class="label">发布对象：</span></td>
		                <td colspan="5"><div  name="receiveDept" id="receiveDept" ></div>
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
			
<!-- 			<div> -->
<!-- 				<div id="upload_download"></div> -->
<!-- 			</div> -->
<!-- 			<div> -->

  <!-- 新影像系统bgn -->
  <div>
    <fieldSet>
      <legend>影像资料</legend>
      <div style="margin-left: 20px;margin-bottom: 10px;">
        <a href='http://ecmp.sinosafe.com.cn:8080/Interface_Cluster/FileUpLoadAction?SystemCode=XSZC01&FunctionCode=XSZC0103&OrgCode=01010000&UserCode=100052692&BatchFlg=0&AuthorizCode=1111&BusinessCode=xszc' target="_blank">公告附件</a>
      </div>
    </fieldSet>
  </div>
  <!-- 新影像系统end -->
				
		<table style="width: 100%">
			<tr>
				<td style="padding-left:30px;padding-top:10px" align="center">
				<!-- <a class="om-button" id="button-save" onclick="noticeSave(0)">存为草稿</a> -->
				<a class="om-button" id="button-save" onclick="noticeSave(0)">保存草稿</a>
				<a class="om-button" id="button-pub" onclick="noticeSave(5)">发布</a>
				<a class="om-button" href="javascript:history.go(-1);" id="button-cancel" >取消</a></td>
			</tr>
		</table>
					
			
		</div>
	</form>

</body>
</html>