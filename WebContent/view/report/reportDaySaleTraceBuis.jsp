<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="static com.sinosafe.xszc.report.constant.Constant.JSON" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>整体业绩进度追踪日报（分业务线）</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('整体业绩追踪日报（分业务线）');
	iniDept('parentDept', 'deptName', '');
	iniDate('reportDay');
	iniLine(<%=JSON("bizLine")%>);
	iniQuery();
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"deptNameTwo", equal:true, dept:true},
    {header:"三级机构", name:"deptNameThree", equal:true, dept:true},
    {header:"业务线", name:"bizLine", equal:true},
    {header:"保费计划(元)", name:"premiumPlan"},
    {header:"本年累计保费收入", name:"incomeThisYear1", alias:"incomeThisYear"},
    {header:"上年同期保费收入", name:"incomeLastYear"},//5
    {header:"同比增长率", name:"yearIncreaseRate", percent:true},
    {header:"上年同期保费增减值", name:"termIncreaseRate"},
    {header:"保费计划达成率", name:"premiumPlanRate", percent:true},
    {header:"时间进度达成率", name:"schedulePlanRate", percent:true},
    {header:"保费收入（元）"},
    {header:"签单净保费（元）"},//11
    //第2行
    {header:"前日", name:"incomeBeforeDay"},
    {header:"昨日", name:"incomeLastDay"},
    {header:"今日", name:"incomeThisDay"},
    {header:"本月", name:"incomeThisMonth"},
    {header:"本年累计", name:"incomeThisYear2", alias:"incomeThisYear"},
    {header:"前日", name:"signBeforeDay"},
    {header:"昨日", name:"signLastDay"},
    {header:"今日", name:"signThisDay"},
    {header:"本月", name:"signThisMonth"},
    {header:"本年", name:"signThisYear"},
    {header:"去年同期签单净保费", name:"signLastYear"},
    {header:"本年签单净保费同期增长率", name:"policyIncreaseRate", percent:true}, //23
    {header:"报表日期", name:"reportDay", equal:true, hide:true}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:100},
	//{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:100},
	{header:tableCols[2].header,name:tableCols[2].name,rowspan:2,width:100},
	{header:tableCols[3].header,name:tableCols[3].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[4].header,name:tableCols[4].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[5].header,name:tableCols[5].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[6].header,name:tableCols[6].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[7].header,name:tableCols[7].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[8].header,name:tableCols[8].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[9].header,name:tableCols[9].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[10].header,colspan:5},
	{header:tableCols[11].header,colspan:7}],
   //第2行
   [{header:tableCols[12].header,name:tableCols[12].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[13].header,name:tableCols[13].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[14].header,name:tableCols[14].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[15].header,name:tableCols[15].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[16].header,name:tableCols[16].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[17].header,name:tableCols[17].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[18].header,name:tableCols[18].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[19].header,name:tableCols[19].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[20].header,name:tableCols[20].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[21].header,name:tableCols[21].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[22].header,name:tableCols[22].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[23].header,name:tableCols[23].name,width:150,renderer:function(v,r,i){return alignCell(v);}}
   ]
];

</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_DAY_SALE_TRACE_BUIS"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportDaySaleTraceBizLine"/>
		<div id="search-panel">
			<table >
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">分公司：</span></td>
					<td><input name="formMap['deptNameTwo']" id="parentDept" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">业务线：</span></td>
					<td><input type="text" name="formMap['bizLine']" id="bizLine" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">报表日期：</span></td>
					<td><input type="text" name="formMap['reportDay']" id="reportDay"  value="" class="sele"/></td>
					<td style="padding-left:15px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>