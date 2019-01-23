<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>销售团队业绩周报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('销售团队业绩周报');
	iniDept('deptName2', 'deptName3', '');
	iniDate('reportWeek');
	iniQuery();
	
});

//表头列名
var tableCols = eval([
	{header:"分公司", name:"deptName2", equal:true, dept:true},
	{header:"三级机构", name:"deptName3", equal:true, dept:true},
	{header:"销售团队名称", name:"groupName", like:true},
	{header:"设立时间", name:"foundDate"},
	{header:"团队代码", name:"groupCode", like:true},
	{header:"团队经理", name:"groupLeader", like:true},
	{header:"团队级别", name:"groupLevel"},
	{header:"团队现有人数",name:"groupAmt", round:true},
	{header:"团队定级年化</br>标保计划", name:"normPremium"},
	{header:"本年累计</br>标准保费", name:"yearStanPrm"},
	{header:"累计年化标准保费", name:"annualStanPrm" },
	{header:"年化标保时间</br>进度达成率", name:"schemRate",percent:true },
	{header:"保费收入（元）"},
	{header:"本年再保后承保年度制满期赔付率</br>(不含间接理赔费用)"  },
	//第二行
	{header:"上上周", name:"preWeekIncome"} ,
	{header:"上周", name:"lastWeekIncome"},
	{header:"本周", name:"thisWeekIncome"},
	{header:"本年累计", name:"yearIncome"},
	{header:"去年同期累计", name:"lastYearIncome"},
	{header:"同比增长率", name:"toYearCompansation",percent:true},
	{header:"上周", name:"toYearCompansationLm",percent:true},
	{header:"本周", name:"yearGrouthRate",percent:true},
	//
    {header:"报表日期", name:"reportWeek", equal:true, hide:true},
    {header:"金明星期别", name:"saleStar"}
	
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:100},
	{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:100},
	{header:tableCols[2].header,name:tableCols[2].name,rowspan:2,width:150},
	{header:tableCols[3].header,name:tableCols[3].name,rowspan:2,width:100},
	{header:tableCols[4].header,name:tableCols[4].name,rowspan:2,width:100},
	{header:tableCols[5].header,name:tableCols[5].name,rowspan:2,width:100},
	{header:tableCols[6].header,name:tableCols[6].name,rowspan:2,width:100},
	{header:tableCols[7].header,name:tableCols[7].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[8].header,name:tableCols[8].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[9].header,name:tableCols[9].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[10].header,name:tableCols[10].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[11].header,name:tableCols[11].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[12].header,colspan:6},
	{header:tableCols[13].header,colspan:2},
	{header:tableCols[23].header,name:tableCols[23].name,rowspan:2,width:100}
	],
	
	
   //第2行
   [{header:tableCols[14].header,name:tableCols[14].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[15].header,name:tableCols[15].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[16].header,name:tableCols[16].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[17].header,name:tableCols[17].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[18].header,name:tableCols[18].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[19].header,name:tableCols[19].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[20].header,name:tableCols[20].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[21].header,name:tableCols[21].name,width:100,renderer:function(v,r,i){return alignCell(v);}}
    
   ]
];

</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_WEEK_GROUP_TOTAL_NEW"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportWeekGroupTotalNew"/>
		<div id="search-panel">
			<table >
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">分公司：</span></td>
					<td><input name="formMap['deptName2']" id="deptName2" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptName3']" id="deptName3" class="sele"/></td>
					<td style="padding-left:15px"><span class="label">销售团队名称：</span></td>
					<td><input type="text" name="formMap['groupName']" id="formMap['groupCname']" /></td>
					<td style="padding-left:15px"><span class="label">团队代码：</span></td>
					<td><input class="sele" type="text" name="formMap['groupCode']" id="formMap['groupCode']" /></td>
					
				</tr> 
				<tr>
				<td style="padding-left:15px"><span class="label">团队经理：</span></td>
					<td><input type="text" name="formMap['groupLeader']" id="formMap['groupLeader']" /></td>
				<td align="right"><span class="label">开始时间：</span></td>
					<td><input type="text" name="formMap['reportStartWeek']" id="reportWeekBng" value="" class="sele"/></td>
					<td align="right"><span class="label">结束时间：</span></td>
					<td><input type="text" name="formMap['reportWeek']" id="reportWeekEnd" value="" class="sele"/></td>
					<td colspan="2" style="padding-left:30px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>