<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户经理数据导入</title>
<script type="text/javascript">
var lawDefineList = null;
var rateType = "${param.rateType}";
var versionId = "${param.versionId}";
$(function(){
	//初始化导入窗口数据
  	$("#impXlsArea").omDialog({
		autoOpen:false,
		title:"批量导入客户经理数据",
		width:431,
		height: 261,
		modal: true
	});
	
  	$("#button-imp").omButton({
		icons : {left:'<%=_path%>/images/page_white_excel.png'},
		width:80,
		height:30,
		onClick:submitDaoRuData
	});
	
	$('#buttonbar').omButtonbar({
		 btns : [
		     {
			    label:"下载模板",
				id:"downloadModel",
				icons : {left : '<%=_path%>/images/page_white_excel.png'},
				onClick:downloadXlsModel
			 },{
				label:"导入数据",
				id:"daoRuModel",
				icons : {left : '<%=_path%>/images/page_white_excel.png'},
				onClick:importXlsData
			 },{
				 label:"保存修改",
			     id:"updateModel",
		 		 onClick:function(){
		 			saveRowsChange();
		 		 }
			 },{
				 label:"取消修改",
			     id:"cancelUpdate" ,
		 		 onClick:function(){
		 			$("#tables").omGrid("cancelChanges");
		 	     }
	 		 }]
	 });
	
	var panelTitle = "";
	if(rateType=="1"){
		panelTitle = "险种调整系数";
		buttonContr();
	}else if(rateType=="2"){
		panelTitle = "业务线调整系数";
		$("#downloadModel").parent().parent().hide();
		$("#daoRuModel").parent().parent().hide();
	}else if(rateType=="3"){
		panelTitle = "车型调整系数";
		$("#downloadModel").parent().parent().hide();
		$("#daoRuModel").parent().parent().hide();
		buttonContr2();
	}else if(rateType=="4"){
		panelTitle = "渠道调整系数";
		buttonContr3();
	}else if(rateType=="5"){
		panelTitle = "成本调整系数";
	}
	//查询面板
	$("legend").text(panelTitle);
	
	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	//列表高度
  	var width = $(window).width();
  	//alert(width);
	//分页表格
	$("#tables").omGrid({
      	limit : 0,
        height :500,
		colModel:getTableHead(),
		showIndex : true,
        singleSelect : true,
        method : 'POST',
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
        	setTimeout("setTdStyle()",250);
        },
        onRefresh:function(nowPage,pageRecords,event){
        	setTimeout("setTdStyle()",50);
        }
	});
	//加载初始数据
	setTimeout("query()",200);
});

function buttonContr(){
	$.ajax({ 
		url: "<%=_path%>/lawRate/queryButtonStatus.do?versionId="+versionId,
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			var statusStr = $.parseJSON(data);
			//系统因素
			if(statusStr.insuranceSwitch == '0'){
				$("#updateModel").omButton("disable");
			}
		}
	});
}
function buttonContr2(){
	$.ajax({ 
		url: "<%=_path%>/lawRate/queryButtonStatus.do?versionId="+versionId,
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			var statusStr = $.parseJSON(data);
			//系统因素
			if(statusStr.motorSwitch == '0'){
				$("#updateModel").omButton("disable");
			}
		}
	});
}

function buttonContr3(){
	$.ajax({ 
		url: "<%=_path%>/lawRate/queryButtonStatus.do?versionId="+versionId,
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			var statusStr = $.parseJSON(data);
			//系统因素
			if(statusStr.channelSwitch == '0'){
				$("#updateModel").omButton("disable");
			}
		}
	});
}

function getTableHead(){
	var columnFix = "";
	if(rateType=="1"){
		columnFix = "险种";
	}else if(rateType=="2"){
		columnFix = "业务线";
	}else if(rateType=="3"){
		columnFix = "车型";
	}else if(rateType=="4"){
		columnFix = "渠道";
	}else if(rateType=="5"){
		columnFix = "成本";
	}
	//表头
	var tabHand = [
	    [
			{header:columnFix+"代码",name:"rateCode",width:150,align:'left'},
			{header:columnFix+"名称",name:"rateName",width:279,align:'left'},
			{header:columnFix+"系数值",name:"rate",width:200,align:'left',sort:'clientSide',editor:{editable:true,type:"omNumberField",option:{allowNegative:false}}},
		]
	];
	return tabHand;
}

/**
 * 保存更改
 */
function saveRowsChange(){
	//先获取到更改过的行
	var rows = $("#tables").omGrid("getChanges" , "update");
	if(rateType=="3"){
		var rateGridData = $("#tables").omGrid("getData");
		rows = rateGridData["rows"];
	}
	$.ajax({ 
			url: "<%=_path%>/lawRate/saveRowsChange",
			data:{
			   rateType:rateType,
			   versionId:versionId,
			   changeRows:JSON.stringify(rows)
			},
			type:"post",
			async: true, 
			dataType: "json",
			success: function(data){
				//关闭提示
	            $.omMessageBox.waiting('close');
				if(data.actionFlag){
					$.omMessageBox.alert({
		                type:'success',
		                title:'操作成功!',
		                content:"恭喜你保存成功"
		            });
				}else{
					$.omMessageBox.alert({
		                type:'error',
		                title:'操作失败',
		                content:"处理失败,请重试！"
		            });
				}
			}
	});
}

/**
 * 生成excel模板并下载
 */
function downloadXlsModel(){
	//弹出提示
    $.omMessageBox.waiting({
        title:'请稍候',
        content:'服务器正在生成模板，请稍候...',
    });
	//生成模板
    $.ajax({ 
		url: "<%=_path%>/lawRate/getLawRateValueXls",
		data:{
			versionId:versionId,
			rateType:rateType
		},
		type:"post",
		async: true, 
		dataType: "json",
		success: function(data){
			//关闭提示
            $.omMessageBox.waiting('close');
			if(data.actionFlag){
				window.location.href="<%=_path %>/"+data.fileUrl;
			}else{
				$.omMessageBox.alert({
	                type:'error',
	                title:'失败',
	                content:data.actionMsg
	            });
			}
		}
	});
}

/**
 * 提交导入表单
 */
function submitDaoRuData(){
	var impFile = $("#impFile").val();
	if(impFile==""){
		$("#confirmMsg").html("<font color=red>请选择文件后再提交！</font>");
		return;
	}else{
		var extStr = impFile.substring(impFile.length-4,impFile.length);
		if(extStr.indexOf("xls")==-1){
			$("#confirmMsg").html("<font color=red>请选择拓展名为.xls文件后再提交！</font>");
			return;
		};
	}
	
	$.omMessageBox.waiting({
        title:'请稍候',
        content:'服务器正在导入数据...',
    });
	
	$("#impXlsForm").submit();
}

/**
 * 导入excel数据
 */
function importXlsData(){
	$("#impXlsArea").omDialog("open");
}

//查询操作
function query() {
	$("#tables").omGrid("setData","<%=_path%>/lawRate/queryLawRate.do?"+$("#filterFrm").serialize());
	setTimeout("setTdStyle()",500); 
}

//设置表格样式
function setTdStyle(){
	$("td").css("padding-right","5px");
	$("th").css("padding-right","5px");
}

function closeWait(){
	$.omMessageBox.waiting('close');
}
</script>
</head>
<body>
<form id="filterFrm" style="display: none">
    <input type="hidden" name="formMap['rateType']" value="${param.rateType }" >
	<input type="hidden" name="formMap['versionId']" value="${param.versionId }" >
</form>
<div>提示：双击可以编辑数据</div>
	<fieldSet>
	<legend></legend>
	<div id="buttonbar"></div>
	<div id="tables"></div>
	<div id="impXlsArea" style="display:none">
	    <!-- 指向iframe实现无刷新 -->
	    <iframe style="width:0; height:0; margin-top:-10px;" name="submitFrame" src="about:blank"></iframe>
	    <form action="<%=_path %>/lawRate/impLawImpValueInXls" id="impXlsForm" method="post" class="easyWebForm" target="submitFrame" enctype="multipart/form-data">
			<input type="hidden" name="rateType" value="${param.rateType }" >
			<input type="hidden" name="versionId" value="${param.versionId }" >
			<table>
				<tr>
					<td style="text-align:right" width="130" height="30"><span class="label">选择要导入的文件:</span></td>
					<td><input type="file" name="impFile" id="impFile" /></td>
				</tr>
				<tr>
				  <td style="text-align:center" colspan="2" height="30">
				     <button id="button-imp" type="button">导入</button>
				  </td>
				</tr>
				<tr>
				  <td style="text-align:center" colspan="2" height="30">
				          导入说明：导入文件必需有数据，否则将被过滤掉<br/>
				     <span id="confirmMsg" ></span>     
				  </td>
				</tr>
			</table>
		</form>
	</div>
  </fieldSet>
</body>
</html>