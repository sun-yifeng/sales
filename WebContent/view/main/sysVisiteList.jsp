<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>系统访问记录</title>
<script type="text/javascript">
$(function(){
	//$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//考核职级年月
	$('#actionDate').omCalendar({
		  dateFormat : "yyyy-MM-dd"
	});
	$("#button-search").omButton({icons:{left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons:{left : '<%=_path%>/images/op-edit.png'},width:57});
	//
	$("#search-panel").omPanel({
    	title : "系统管理  > 访问记录",
    	collapsible:true,
    	collapsed:false
    });	
	//评分月份
	var date = new Date();
	date.setMonth(date.getMonth(), date.getDate());
	$('#actionDate').omCalendar({dateFormat:'yymm'});
	$('#actionDate').val($.omCalendar.formatDate(date,"yymm"));
	//列表高度
	var bdnum = $("body").offset().top + $("body").outerHeight();
  	var btnum = $("#filterFrm").offset().top + $("#filterFrm").outerHeight();
	var topnum = bdnum - btnum;
  	//分页表格
	dataGrid = $("#tables").omGrid({
		colModel : tabHand,
		showIndex : false,
        singleSelect : false,
        height : topnum,
        method : 'POST',
      	limit : 50
	});
	//初始化加载数据
	setTimeout("query()", 500) ; 
});

//表头
var tabHand = [ 
	{header : "访问时间",name : "actionDate",rowspan : 2,width : 149},
	{header : "登录ID",name : "userCode",rowspan : 2,width : 164},
	{header : "访问人",name : "userRealName",rowspan : 2,width : 110},
	{header : "所属部门",name : "deptName",rowspan : 2,width : 120},
	{header : "访问模块",name : "modelClass",rowspan : 2,width : 110},
	{header : "子模块",name : "modelChildClass",rowspan : 2,width : 110},
	{header : "功能标签",name : "actionLabel",rowspan : 2,width : 110},
	{header : "访问地址",name : "actionUrl",rowspan : 2,width : 210},
	{header : "访问IP",name : "actionIp",rowspan : 2,width : 110},
	{header : "访问类型",name : "accessType",rowspan : 2,width : 110}
];

//查询操作
function query(){
	$("#actionDateNew").val($("#actionDate").val());
	$("#tables").omGrid("setData","<%=_path%>/userAccessRecord/queryVisitRecords.do?"+$("#filterFrm").serialize());
}

</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">查询年月：</span></td>
					<td><input class="sele" name="formMap['actionDate']" id="actionDate" /></td>
					<td style="padding-left:15px"><span class="label">访问类型：</span></td>
					<td>
					   <input type="radio" name="formMap['accessType']" value="1" style="width:20px"/>数据访问记录&nbsp;
					   <input type="radio" name="formMap['accessType']" value="2" style="width:20px" />页面访问记录&nbsp;
					</td>
					<td colspan="4" align="right"><span id="button-search" onclick="query()">查询</span>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>