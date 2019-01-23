<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>计算任务查询</title>
<script type="text/javascript">
$(function(){
	$(".sele").css({"width":"131px"});
	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	//导航面板
	$("#search-panel").omPanel({title : "考核管理  > 计算任务查询",collapsible:true,collapsed:false});
	//二级公司
	$('#deptCodeTwo').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?"+ new Date().toTimeString(),
        emptyText : "请选择",
		filterStrategy : 'anywhere',
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCodeTwo').omCombo({
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        }
    });
    //计算月份
	var date = new Date();
	date.setMonth(date.getMonth()-1, date.getDate());
	$('#statMonth').omCalendar({dateFormat:'yymm'}).val($.omCalendar.formatDate(date,"yymm"));
	//列表高度
	var bdnum = $("body").offset().top + $("body").outerHeight();
  	var btnum = $("#filterFrm").offset().top + $("#filterFrm").outerHeight();
	var topnum = bdnum - btnum;
  	//分页表格
	dataGrid = $("#tables").omGrid({
		colModel:tabHand,
		showIndex : false,
        singleSelect : false,
        height:topnum,
        method : 'POST',
      	limit:20
	});
	//加载数据
	setTimeout("query()","500");
});
//表头
var tabHand = [
	{header:"分公司",name:"deptCodeTwo",width:100},
	{header:"业务线",name:"lineCode",width:100},
	{header:"计算月份",name:"statMonth",width:120},
	{header:"任务开始时间",name:"taskBngDate",width:200},
	{header:"任务结束时间",name:"taskEndDate",width:200},
	{header:"任务执行状态",name:"taskStatus",width:100}
];
//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reviewScore/queryScoreCoutApply.do?"+$("#filterFrm").serialize());
}
</script>
</head>
<body>
	<form id="filterFrm">
	    <input type="hidden" id="missionType"  name="formMap['missionType']" value="1"/>
		<div id="search-panel" class="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">分公司：</span></td>
					<td><input class="sele" id="deptCodeTwo" name="formMap['deptCodeTwo']" type="text"/></td>
					<td style="padding-left:15px" align="right"><span class="label">计算月份：</span></td>
					<td><input class="sele" type="text" name="formMap['statMonth']" id="statMonth" /></td>
					<td colspan="2" style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables" class="tables"></div>
</body>
</html>