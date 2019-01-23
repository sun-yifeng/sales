<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>合作机构的许可证到期机构</title>
<script type="text/javascript">
//定义表格对象
var dataGrid;
var bzlineData = null;
$(function(){
	//----------查询表单初始化结束-------------
	//初始化数据列表
	dataGrid = $("#tables").omGrid({
		limit : 0,
		colModel : tabHand,
		showIndex : true,
        height : $(window).height(),
        method : 'POST',
        onSuccess : function(data,testStatus,XMLHttpRequest,event){
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
		{header:"所属机构",name:"deptName",width:200,align:'center',
		    renderer : function(value, rowData , rowIndex){
		    	return value.substr(value.indexOf("-")+1);
			}},
	    {header:"公告标题",name:"title",width:200,align:'center'},
	    {header:"公告内容",name:"content",width:200,align:'center'},
		{header:"发布日期",name:"publishDate",width:200,align:'center',
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
	$("#tables").omGrid("setData","<%=_path%>/findNoticeTipList.do?"+$("#filterFrm").serialize());
	setTimeout("setTdStyle()",200);
}
</script>
</head>
<body>
	<form id="filterFrm" style="display: none">
	    <input name="formMap['status']" value="${param.status }"/>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>