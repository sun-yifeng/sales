<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>试用期满三个月至六个月的员工转正自动提醒列表</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<link rel="stylesheet" type="text/css" href="<%=_path%>/css/form.css" />
<script type="text/javascript">
//定义表格对象
var dataGrid;
var bzlineData = null;
$(function(){
	//加载业务线
	$.ajax({ 
		url: "<%=_path%>/common/loadBline",
		type:"post",
		async: false, 
		dataType: "json",
		success: function(data){
			bzlineData = data;
		}
	});
	$("#filterFrm").find("input").css({"width":"150px"});
	$(".sele").css({"width":"130px"});
	var btInput = $("#buttonbar");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight()+72;
  	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }

	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});

	//查询面板
	var searchPanelTitle = "系统提示信息  > 试用期满三个月至六个月的员工转正自动提醒列表";
	$("#search-panel").omPanel({
    	title : searchPanelTitle,
    	collapsible:true,
    	collapsed:false
    });
	//----------查询表单初始化开始-------------
	//加载二级机构名称
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
	$('#startDate').omCalendar();
	$('#endDate').omCalendar();
	//----------查询表单初始化结束-------------
	//初始化数据列表
	dataGrid = $("#tables").omGrid({
		limit : 100,
		colModel:tabHand,
		showIndex : true,
        height:topnum,
        method : 'POST',
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
           setTimeout("setTdStyle()",200); 
        }
	});
	
	 $('#lineCode').omCombo({
         dataSource:bzlineData,
         editable:false
     });
	
	//加载初始数据
	setTimeout("query()",500);
	setTimeout("setTdStyle()",800); 
});

//设置表格样式
function setTdStyle(){
	$("td").css("padding-right","5px");
	$("th").css("padding-right","5px");
}

//表头
var tabHand = [
    [
	    {header:"员工姓名",name:"salesmanCname",width:100,align:'center'},
	    {header:"员工编码编码",name:"employCode",width:100,align:'center'},
		{header:"当前职级名称",name:"rankName",width:200,align:'center'},
		{header:"当年累计标准保费",name:"standFee",width:200,align:'center'},
		{header:"入职时间",name:"entryDate",width:120,align:'center',
			renderer : function(value, rowData , rowIndex){
				return formatDate(value,"yyyy-MM-dd");
			}
		},
		{header:"转正时间",name:"regularDate",width:120,align:'center',
			renderer : function(value, rowData , rowIndex){
				return formatDate(value,"yyyy-MM-dd");
			}
		}
	]
];

//权限管控
function isSelected(){
	$.ajax({ 
		url: "<%=_path%>/reviewRank/findRolesInSystemByUserCode.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			roleEname = data;
		}
	});
	
	if(roleEname == "headDeptDirector"){
		$("#deptPlanAdd").omButton("disable");
		$("#updatePlan").omButton("disable");
	}else if(roleEname == "subDeptAdmin"){
	    $("#deptPlanAdd").omButton("disable");
		$("#updatePlan").omButton("disable");
	}else if(roleEname == "thirdDeptMiddle"){
		$("#deptPlanAdd").omButton("disable");
		$("#updatePlan").omButton("disable");
	}else{
		$("#deptPlanAdd").omButton("enable");
		$("#updatePlan").omButton("enable");
	}
}

//得到业务线文本
function getBzlineText(codeV){
	var lineText = "";
	$.each(bzlineData,function(i,bzline){
		if(bzline.value==codeV){
			lineText = bzline.text;
		}
	});
	return lineText;
}

//格式化日期
function formatDate(value,pattern){
	    if(value==""||value==null){
	    	return "";
	    }
	    var actionDate = new Date(value);
		var fullYear = actionDate.getFullYear();
		var month = (actionDate.getMonth() + 1);
		if (month < 10) {
			month = "0" + month;
		}
		var day = actionDate.getDate();
		if (day < 10) {
			day = "0" + day;
		}
		var hours = actionDate.getHours();
		if (hours < 10) {
			hours = "0" + hours;
		}
		var minutes = actionDate.getMinutes();
		if (minutes < 10) {
			minutes = "0" + minutes;
		}
		var seconds = actionDate.getSeconds();
		if (seconds < 10) {
			seconds = "0" + seconds;
		}
		var timeV = fullYear + "-" + month + "-" + day + " " + hours + ":"+ minutes + ":" + seconds;
		if(pattern=="yyyy-MM-dd"){
			timeV = fullYear + "-" + month + "-" + day;
		}
		return timeV;
}

//查询操作
function query() {
	$("#tables").omGrid("setData","<%=_path%>/queryEmployThreeNotice.do?"+$("#filterFrm").serialize());
	//setTimeout("isSelected()",300) ; 
	setTimeout("setTdStyle()",200); 
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">员工编码：</span></td>
					<td align="left"><input class="sele" name="formMap['employCode']" id="employCode" style="width:100px;" /></td>
					<td align="right"><span class="label">员工名称：</span></td>
					<td align="left"><input name="formMap['salesmanCname']" id="salesmanCname" style="width:118px;" /></td>
					<td align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>