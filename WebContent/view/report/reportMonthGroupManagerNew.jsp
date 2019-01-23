<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户经理业绩月报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('客户经理业绩月报');
	iniDept('fComName', 'zhComName', 'yinyebuName');
	iniDate('reportMonth');
	iniQuery();
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"fComName", equal:true, dept:true},
    {header:"三级机构", name:"zhComName", equal:true, dept:true},
    {header:"组织单位", name:"yinyebuName", equal:true,dept:true},
    {header:"职员姓名", name:"salesmanCname", like:true},
    {header:"职位名称", name:"position"},
    {header:"职务名称", name:"title"},
    {header:"职级名称", name:"rankName"},
    {header:"员工类型", name:"salesmanType"},
    {header:"是否劳务派遣", name:"lwpqFlag"},
    {header:"职位分类属性", name:"titleType"},
    {header:"入司时间", name:"contractDate"}, //10
    {header:"入职时间",name:"entryDate"},
    {header:"转正时间",name:"regularDate"},
    {header:"离职时间",name:"dimissionDate"},
    {header:"定级标准保费任务",name:"normPremium"},
    {header:"本年累计标准保费",name:"yearNormPrm"},
    {header:"累计年化标准保费",name:"annNormPrm"},
    {header:"年化标保时间<br/>进度达成率",name:"schedulePlanRate",percent:true},
    {header:"保费收入"},
    {header:"本年再保后承保年度制<br/>满期赔付率（不含间接理赔费用）"},
    {header:"去年再保后承保年度制<br/>满期赔付率（不含间接理赔费用）"},
    
    //第2行
    //保费收入			
    {header:"上月", name:"lastMonthIncome"},
    {header:"本月", name:"monthIncome"},
    {header:"本年累计", name:"yearIncome"},
    {header:"去年同期累计", name:"lastYearIncome"},
    {header:"同比增长率", name:"yearGrouth"},
    {header:"非车险保费", name:"properIncome"},
    //本年再保后承保年度制<br/>满期赔付率（不含间接理赔费用）
    {header:"上月", name:"toYearCompansationLm",percent:true},
    {header:"本月", name:"toYearCompansation",percent:true},
    //去年再保后承保年度制<br/>满期赔付率（不含间接理赔费用）
    {header:"上月", name:"lastYearCompansationLm",percent:true},
    {header:"本月", name:"lastYearCompansation",percent:true},
    {header:"保单获取成本率",name:"policyCostRate",percent:true},
	{header:"本年保单承保</br>边际贡献率",name:"policyConRate",percent:true},
	{header:"再保后历年制赔付率",name:"linianRateZb",percent:true},
    
    {header:"报表日期", name:"reportMonth", equal:true, hide:true},
	{header:"金明星期别",name:"saleStar"}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:150},
	{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:150},
	{header:tableCols[2].header,name:tableCols[2].name,rowspan:2,width:150},
	{header:tableCols[3].header,name:tableCols[3].name,rowspan:2,width:100},
	{header:tableCols[4].header,name:tableCols[4].name,rowspan:2,width:100},
	{header:tableCols[5].header,name:tableCols[5].name,rowspan:2,width:100},
	{header:tableCols[6].header,name:tableCols[6].name,rowspan:2,width:100},
	{header:tableCols[7].header,name:tableCols[7].name,rowspan:2,width:100},
	{header:tableCols[8].header,name:tableCols[8].name,rowspan:2,width:100},
	{header:tableCols[9].header,name:tableCols[9].name,rowspan:2,width:100},
	{header:tableCols[10].header,name:tableCols[10].name,rowspan:2,width:100},
	{header:tableCols[11].header,name:tableCols[11].name,rowspan:2,width:100},
	{header:tableCols[12].header,name:tableCols[12].name,rowspan:2,width:100},
	{header:tableCols[13].header,name:tableCols[13].name,rowspan:2,width:100},
	{header:tableCols[14].header,name:tableCols[14].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[15].header,name:tableCols[15].name,rowspan:2,width:110,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[16].header,name:tableCols[16].name,rowspan:2,width:110,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[17].header,name:tableCols[17].name,rowspan:2,width:120,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[18].header,colspan:6},
	{header:tableCols[19].header,colspan:2},
	{header:tableCols[20].header,colspan:2},
	{header:tableCols[31].header,name:tableCols[31].name,rowspan:2,width:110,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[32].header,name:tableCols[32].name,rowspan:2,width:110,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[33].header,name:tableCols[33].name,rowspan:2,width:110,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[35].header,name:tableCols[35].name,rowspan:2,width:110}
	],
   //第2行
   [
	{header:tableCols[21].header,name:tableCols[21].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[22].header,name:tableCols[22].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[23].header,name:tableCols[23].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[24].header,name:tableCols[24].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    //
    {header:tableCols[25].header,name:tableCols[25].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[26].header,name:tableCols[26].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[27].header,name:tableCols[27].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[28].header,name:tableCols[28].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[29].header,name:tableCols[29].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[30].header,name:tableCols[30].name,width:100,renderer:function(v,r,i){return alignCell(v);}}]
];

</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_MOTH_GROUP_MANAGER_NEW"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportMonthGroupManagerNew"/>
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;三级机构：</span></td>
					<td align="left"><input name="formMap['zhComName']" id="zhComName" class="sele"/></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;四级单位：</span></td>
					<td align="left"><input name="formMap['yinyebuName']" id="yinyebuName" class="sele"/></td>
					
					<td style="padding-left:15px" align="right"><span class="label">报表日期：</span></td>
					<td><input type="text" name="formMap['reportMonth']" id="reportMonth" value="" class="sele"/></td>
				</tr>
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">职员姓名：</span></td>
					<td align="left"><input type="text" name="formMap['salesmanCname']" id="formMap['salesmanCname']" /></td>
					
					<td colspan="6" style="padding-left:15px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>