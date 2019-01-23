<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>团队人员组织发展总表（月报）</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('团队人员组织发展总表（月报）');
	iniDept('fComName', 'zhComName', '');
	iniDate('reportMonth');
	iniQuery();
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"fComName", equal:true, dept:true},
    {header:"三级机构", name:"zhComName", equal:true, dept:true},
    {header:"总体情况"},
    {header:"现有客户经理（人数）"},
    {header:"现有团队经理（人数）"},
    {header:"客户经理年化产能区间人数（万元）"},
    {header:"团队年化产能区间人数情况（万元）"},
    //第二行；
    {header:"现有销售人员", name:"salesAmt",round:true},
    {header:"其中：本年新入司<br/>人员", name:"entryAmt",round:true},
    {header:"本年离职人员" },
    //第三行；
    {header:"本年新入司", name:"tisyearDismissAmt",round:true}, //10
    {header:"以往年度入司",name:"preyearDismissAmt",round:true},
    {header:"资深客户经理",name:"mangerLevelA",round:true},
    {header:"高级客户经理",name:"mangerLevelB",round:true},
    {header:"中级客户经理",name:"mangerLevelC",round:true},
    {header:"初级客户经理",name:"mangerLevelD",round:true},
    {header:"试用期",name:"mangerProbation",round:true},
    {header:"其他",name:"mangerElse",round:true},
    
    {header:"资深团队经理",name:"learderLevelA",round:true},
    {header:"高级团队经理",name:"learderLevelB",round:true},
    {header:"中级团队经理",name:"learderLevelC",round:true},
    {header:"初级团队经理",name:"learderLevelD",round:true},
    {header:"试用期",name:"learderProbation",round:true},
    {header:"其他",name:"learderElse",round:true},
    
    
    {header:"0-50",name:"manProductLevelF",round:true},
    {header:"50-100",name:"manProductLevelE",round:true},
    {header:"100-200",name:"manProductLevelD",round:true},
    {header:"200-300",name:"manProductLevelC",round:true},
    {header:"300-500",name:"manProductLevelB",round:true},
    {header:"500万以上",name:"manProductLevelA",round:true},
    
    {header:"0-300",name:"groupProductLevelF",round:true},
    {header:"300-500",name:"groupProductLevelE",round:true},
    {header:"500-800",name:"groupProductLevelD",round:true},
    {header:"800-1000",name:"groupProductLevelC",round:true},
    {header:"1000-2000",name:"groupProductLevelB",round:true},
    {header:"2000万以上",name:"groupProductLevelA",round:true},
    
    
    {header:"报表日期", name:"reportMonth", equal:true, hide:true}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:3,width:150},
	{header:tableCols[1].header,name:tableCols[1].name,rowspan:3,width:150},
	{header:tableCols[2].header,name:tableCols[2].name,colspan:4},
	{header:tableCols[3].header,name:tableCols[3].name,rowspan:2,colspan:6},
	{header:tableCols[4].header,name:tableCols[4].name,rowspan:2,colspan:6},
	{header:tableCols[5].header,name:tableCols[5].name,rowspan:2,colspan:6},
	{header:tableCols[6].header,name:tableCols[6].name,rowspan:2,colspan:6}],
	//第二行
	[{header:tableCols[7].header,name:tableCols[7].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[8].header,name:tableCols[8].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[9].header,name:tableCols[9].name,colspan:2,width:100}],
	//第三行
	[{header:tableCols[10].header,name:tableCols[10].name,width:100 ,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[11].header,name:tableCols[11].name,width:100, renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[12].header,name:tableCols[12].name,width:100 ,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[13].header,name:tableCols[13].name,width:100 ,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[14].header,name:tableCols[14].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[15].header,name:tableCols[15].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[16].header,name:tableCols[16].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[17].header,name:tableCols[17].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[18].header,name:tableCols[18].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[19].header,name:tableCols[19].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[20].header,name:tableCols[20].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[21].header,name:tableCols[21].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[22].header,name:tableCols[22].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[23].header,name:tableCols[23].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[24].header,name:tableCols[24].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[25].header,name:tableCols[25].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[26].header,name:tableCols[26].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[27].header,name:tableCols[27].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[28].header,name:tableCols[28].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[29].header,name:tableCols[29].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[30].header,name:tableCols[30].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[31].header,name:tableCols[31].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[32].header,name:tableCols[32].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[33].header,name:tableCols[33].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[34].header,name:tableCols[34].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[35].header,name:tableCols[35].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	
   ]
   
   
];


</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_MONTH_GROUP_MENBER_NEW"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportTotalGroupMenberNew"/>
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;三级机构：</span></td>
					<td align="left"><input name="formMap['zhComName']" id="zhComName" class="sele"/></td>
					
					<td style="padding-left:15px" align="right"><span class="label">报表日期：</span></td>
					<td><input type="text" name="formMap['reportMonth']" id="reportMonth" value="" class="sele"/></td>
					<td colspan="6" style="padding-left:15px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr>
				
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>