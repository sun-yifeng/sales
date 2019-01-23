<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户经理业绩日报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('客户经理业绩日报');
	iniDept('fComName', 'zhComName', '');
	iniDate('reportDay');
	iniQuery();
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"fComName", equal:true, dept:true},
    {header:"三级机构", name:"zhComName", equal:true, dept:true},
    {header:"销售团队名称", name:"groupName", like:true},
    {header:"职员姓名", name:"salesmanCname"},
    {header:"职级", name:"rankName"},
    {header:"入司时间", name:"contractDate"},
    {header:"员工类型", name:"salesmanType",like:true},
    {header:"职位分类属性", name:"titleType"},
    {header:"定级标准保费任务<br/>（年化）",name:"normPremium"},
    {header:"本年累计标准保费", name:"yearNormPrm"},
    {header:"累计年化标准保费", name:"annNormPrm"},
    {header:"年化标保时间<br/>进度达成率", name:"schedulePlanRate",percent:true},
    {header:"保费收入"}, //12
    //第2行
    //签单保费(元)			
    {header:"前日", name:"preDayIncome"},
    {header:"昨日", name:"lastDayIncome"},
    {header:"本日", name:"thisDayIncome"},
    {header:"本月", name:"monthIncome"},
    {header:"本年累计", name:"yearIncome"},
    //
    {header:"报表日期", name:"reportDay", equal:true, hide:true},
    {header:"金明星期别", name:"saleStar"}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:160},
	{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:160},
	{header:tableCols[2].header,name:tableCols[2].name,rowspan:2,width:160},
	{header:tableCols[3].header,name:tableCols[3].name,rowspan:2,width:120},
	{header:tableCols[4].header,name:tableCols[4].name,rowspan:2,width:100},
	{header:tableCols[5].header,name:tableCols[5].name,rowspan:2,width:150},
	{header:tableCols[6].header,name:tableCols[6].name,rowspan:2,width:100},
	{header:tableCols[7].header,name:tableCols[7].name,rowspan:2,width:100},
	{header:tableCols[8].header,name:tableCols[8].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[9].header,name:tableCols[9].name,rowspan:2,width:120},
	{header:tableCols[10].header,name:tableCols[10].name,rowspan:2,width:120},
	{header:tableCols[11].header,name:tableCols[11].name,rowspan:2,width:120},
	{header:tableCols[12].header,colspan:5},
	{header:tableCols[19].header,name:tableCols[19].name,rowspan:2,width:120}
   ],
   //第2行
   [
	{header:tableCols[13].header,name:tableCols[13].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[14].header,name:tableCols[14].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[15].header,name:tableCols[15].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[16].header,name:tableCols[16].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[17].header,name:tableCols[17].name,width:100,renderer:function(v,r,i){return alignCell(v);}}
   ]
];

</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_DAY_GROUP_MANAGER_NEW"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportDayGroupManagerNew"/>
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;三级机构：</span></td>
					<td align="left"><input name="formMap['zhComName']" id="zhComName" class="sele"/></td>
					<td style="padding-left:15px"><span class="label">销售团队名称：</span></td>
					<td><input type="text" name="formMap['groupName']" id="formMap['groupName']" /></td>
					
				</tr>
				<tr>
				<td style="padding-left:15px"><span class="label">员工类型：</span></td>
					<td><input type="text" name="formMap['employType']" id="formMap['employType']" /></td>
					<td align="right"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;报表日期：</span></td>
					<td align="left"><input type="text" name="formMap['reportDay']" id="reportDay" value="" class="sele"/></td>
					<td colspan="2" style="padding-left:15px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>