<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户经理业绩周报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('客户经理业绩周报');
	iniDept('fComName', 'zhComName', 'yinyebuName');
	iniDate('reportWeek');
	iniQuery();
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"fComName", equal:true, dept:true},
    {header:"三级机构", name:"zhComName", equal:true, dept:true},
    {header:"四级单位", name:"yinyebuName", equal:true,dept:true},
    {header:"职员姓名", name:"salesmanCname", like:true},
    {header:"职级名称", name:"rankName", like:true},
    {header:"入司时间", name:"contractDate"},
    {header:"员工类型", name:"salesmanType",like:true},
    {header:"职位分类属性", name:"titleType"},
    {header:"定级标准保费任务<br/>（年化）", name:"normPremium", like:true},
    {header:"本年累计<br/>标准保费", name:"yearNormPrm", like:true},
    {header:"累计年化<br/>标准保费", name:"annNormPrm", like:true}, //10
    {header:"年化标保<br/>时间进度达成率",name:"schedulePlanRate",percent:true},
    {header:"保费收入"},
    {header:"今年再保后承保<br/>年度制满期赔付率（不含间接理赔费用）"},
    //第2行
    		
    {header:"上上周", name:"preWeekIncome"},
    {header:"上周", name:"lastWeekIncome"},
    {header:"本周", name:"weekIncome"},
    {header:"本年累计", name:"yearIncome"},
   {header:"去年同期累计", name:"lastYearIncome"},
    {header:"同比增长率", name:"yearGrouthRate",percent:true},
    
    {header:"上周", name:"toYearCompansation",percent:true},
    {header:"本周", name:"toYearCompansationLw",percent:true},
    
    {header:"报表日期", name:"reportWeek", equal:true, hide:true},
    {header:"金明星期别", name:"saleStar"}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:150},
	{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:150},
	{header:tableCols[2].header,name:tableCols[2].name,rowspan:2,width:150},
	{header:tableCols[3].header,name:tableCols[3].name,rowspan:2,width:100},
	{header:tableCols[4].header,name:tableCols[4].name,rowspan:2,width:120},
	{header:tableCols[5].header,name:tableCols[5].name,rowspan:2,width:100},
	{header:tableCols[6].header,name:tableCols[6].name,rowspan:2,width:100},
	{header:tableCols[7].header,name:tableCols[7].name,rowspan:2,width:100},
	{header:tableCols[8].header,name:tableCols[8].name,rowspan:2,width:120,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[9].header,name:tableCols[9].name,rowspan:2,width:100},
	{header:tableCols[10].header,name:tableCols[10].name,rowspan:2,width:100},
	{header:tableCols[11].header,name:tableCols[11].name,rowspan:2,width:100},
	{header:tableCols[12].header,colspan:6},
	{header:tableCols[13].header,colspan:2},
	{header:tableCols[23].header,name:tableCols[23].name,rowspan:2,width:100}
   ],
   //第2行
   [
	
	{header:tableCols[14].header,name:tableCols[14].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[15].header,name:tableCols[15].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[16].header,name:tableCols[16].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    //
    {header:tableCols[17].header,name:tableCols[17].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[18].header,name:tableCols[18].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[19].header,name:tableCols[19].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[20].header,name:tableCols[20].name,width:120,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[21].header,name:tableCols[21].name,width:120,renderer:function(v,r,i){return alignCell(v);}},
    
   ]
];

</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_WEEK_GROUP_MANAGER_NEW"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportWeekGroupManagerNew"/>
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;三级机构：</span></td>
					<td align="left"><input name="formMap['zhComName']" id="zhComName" class="sele"/></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;四级单位：</span></td>
					<td align="left"><input name="formMap['yinyebuName']" id="yinyebuName" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">职员姓名：</span></td>
					<td><input type="text" name="formMap['salesmanCname']" id="salesmanCname" value="" class="widths"/></td>
				</tr>
				<tr>
				    <td style="padding-left:15px" align="right"><span class="label">职级名称：</span></td>
					<td><input type="text" name="formMap['rankName']" id="rankName" value="" class="widths"/></td>
					<td style="padding-left:15px" align="right"><span class="label">员工类型：</span></td>
					<td><input type="text" name="formMap['salesmanType']" id="salesmanType" value="" class="widths"/></td>
					<td style="padding-left:15px" align="right"><span class="label">开始日期：</span></td>
					<td><input type="text" name="formMap['reportWeekBng']" id="reportWeekBng" value="" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">结束日期：</span></td>
					<td><input type="text" name="formMap['reportWeek']" id="reportWeekEnd" value="" class="sele"/></td>
					
				</tr> 
				<tr>
				<td colspan="8" style="padding-left:15px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>