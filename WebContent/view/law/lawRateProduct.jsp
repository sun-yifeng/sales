<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户经理数据导入</title>
<style>html, body{width: 100%; height:100%; padding: 0; margin: 0; overflow: hidden;}</style>
<link rel="stylesheet" type="text/css" href="<%=_path%>/css/form.css" />
<script type="text/javascript">
var lawDefineList = null;
$(function(){
	// 整体样式
	$("#filterFrm").find("input").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//二级机构
	$('#deptCode').omCombo({
        dataSource :  "<%=_path%>/department/queryDepartmentByUserCode.do?random="+Math.random(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2){
        		$('#deptCode').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
        },
        emptyText : '请选择'
    });
	
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
				id:"addButton",
				icons : {left : '<%=_path%>/images/page_white_excel.png'},
				onClick:downloadXlsModel
			 },{
				label:"导入数据",
				id:"addButton" ,
				icons : {left : '<%=_path%>/images/page_white_excel.png'},
				onClick:importXlsData
			 },
			 {
			 label:"保存",
		     id:"updatePlan" ,
		     icons : {left : '<%=_path%>/images/op-edit.png'},
	 		 onClick:function(){
	 			saveRowsChange();
	 		 }
		 }]
	 });
	
	$('#buttonbar').append("<span style=\"line-height:25px\">温馨提示：双击行进入数据编辑</span>");
	
	//查询面板
	$("#search-panel").omPanel({
    	title : "管理办法  > 客户经理数据导入",
    	collapsible:true,
    	collapsed:false
    });
	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	//列表高度
	var bdnum = $("body").offset().top + $("body").outerHeight();
  	var btnum = $("#search-panel").offset().top + $("#search-panel").outerHeight();
  	var width = $(window).width();
  	//alert(width);
	//分页表格
	$("#tables").omGrid({
      	limit : 25,
        height :bdnum-btnum-20,
        width:1000,
		colModel:getTableHead(),
		showIndex : false,
        singleSelect : true,
        method : 'POST',
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
        	setTimeout("setTdStyle()",250);
        }
	});
	//加载初始数据
	setTimeout("query()",200);
});

function getTableHead(){
	//表头
	var tabHand = [
	    [
			{header:"代码",name:"deptNameTwo",width:200,align:'left'},
			{header:"名称",name:"deptNameThree",width:200,align:'left'},
			{header:"调整系数值",name:"deptNameFour",width:200,align:'left'},
			{header:"录入时间",name:"salesmanCname",width:200,align:'left'}
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
	$.ajax({ 
			url: "<%=_path%>/lawImpValue/saveRowsChange",
			data:{
				impType:"1",
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
	var deptCode = $("#deptCode").val();
	//生成模板
    $.ajax({ 
		url: "<%=_path%>/lawImpValue/getLawImpValueXls",
		data:{
			deptCode:deptCode,
			impType:"1"
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
	$("#tables").omGrid("setData","<%=_path%>/lawImpValue/lawRate.do?"+$("#filterFrm").serialize());
	setTimeout("setTdStyle()",500); 
}

//设置表格样式
function setTdStyle(){
	$("td").css("padding-right","5px");
	$("th").css("padding-right","5px");
}

</script>
</head>
<body>
	<div id="search-panel">
	   <form id="filterFrm">
	        <!-- 系数类型 -->
	        <input type="hidden" name="formMap['rateType']"  value="1" >
			<table>
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">系数名称：</span></td>
					<td><input class="sele" name="formMap['rateName']" id="rateName" /></td>
					<td align="right" colspan="6"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
	    </form>
	</div>
	<div id="buttonbar"></div>
	<div id="tables"></div>
	<div id="impXlsArea" style="display:none">
	    <form action="<%=_path %>/lawImpValue/impLawImpValueInXls" id="impXlsForm" method="post" class="easyWebForm" enctype="multipart/form-data">
			<input type="hidden" name="impType" value="1" >
			<input type="hidden" name="impType" value="1" >
			<table>
				<tr>
					<td style="text-align:right" width="130"><span class="label">选择要导入的文件:</span></td>
					<td><input type="file" name="impFile" id="impFile" /></td>
				</tr>
				<tr>
				  <td style="text-align:center" colspan="2">
				     <button id="button-imp" type="button">导入</button>
				  </td>
				</tr>
				<tr>
				  <td style="text-align:center" colspan="2">
				          导入说明：导入文件必需有数据，否则将被过滤掉<br/>
				     <span id="confirmMsg" ></span>     
				  </td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>