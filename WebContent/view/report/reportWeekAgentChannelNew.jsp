<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="static com.sinosafe.xszc.report.constant.Constant.JSON" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>中介渠道业绩周报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('中介渠道业绩周报');
	iniDept('fComName', 'zhComName', 'yinyebuName');
	iniDate('reportWeek');
	iniQuery();
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"fComName", equal:true, dept:true},
    {header:"三级机构", name:"zhComName", equal:true, dept:true},
    {header:"四级单位", name:"yinyebuName", equal:true},
    {header:"合作机构渠道名称", name:"agentNme", like:true},
    {header:"协议生效日期", name:"coStartDate"},
    {header:"协作人", name:"supportNme", like:true},
    {header:"出单员", name:"cOperCde", like:true},
    {header:"业务员", name:"cSlsCde", like:true},
    {header:"保费收入（元）"},
    {header:"签单净保费（元）"},//10
    //第2行
    {header:"前第三周", name:"lastThreeWeekIncome"},
    {header:"前第二周", name:"lastTwoWeekIncome"},
    {header:"前一周", name:"lastWeekIncome"},
    {header:"本周", name:"weekIncome"},
    {header:"本年累计", name:"yearIncome"},
    //
    {header:"前第三周", name:"lastThreeWeekSign"},
    {header:"前第二周", name:"lastTwoWeekSign"},
    {header:"前一周", name:"lastWeekSign"},
    {header:"本周", name:"weekSign"},
    {header:"本年累计", name:"yearSign"}, //18
    //
    {header:"报表日期", name:"reportWeek", equal:true, hide:true}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:100},
	{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:150},
	{header:tableCols[2].header,name:tableCols[2].name,rowspan:2,width:150},
	{header:tableCols[3].header,name:tableCols[3].name,rowspan:2,width:200},
	{header:tableCols[4].header,name:tableCols[4].name,rowspan:2,width:100},
	{header:tableCols[5].header,name:tableCols[5].name,rowspan:2,width:150},
	{header:tableCols[6].header,name:tableCols[6].name,rowspan:2,width:150},
	{header:tableCols[7].header,name:tableCols[7].name,rowspan:2,width:150},
	{header:tableCols[8].header,colspan:5},
	{header:tableCols[9].header,colspan:5}
   ],
   //第2行
   [
	{header:tableCols[10].header,name:tableCols[10].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[11].header,name:tableCols[11].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[12].header,name:tableCols[12].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[13].header,name:tableCols[13].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[14].header,name:tableCols[14].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[15].header,name:tableCols[15].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[16].header,name:tableCols[16].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[17].header,name:tableCols[17].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[18].header,name:tableCols[18].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[19].header,name:tableCols[19].name,width:100,renderer:function(v,r,i){return alignCell(v);}}
   ]
];

</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_WEEK_AGENT_CHANNEL_NEW"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportWeekAgentChannelNew"/>
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;三级机构：</span></td>
					<td align="left"><input name="formMap['zhComName']" id="zhComName" class="sele"/></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;四级单位：</span></td>
					<td align="left"><input name="formMap['yinyebuName']" id="yinyebuName" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">开始时间：</span></td>
					<td><input type="text" name="formMap['reportWeekBng']" id="reportWeekBng" value="" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">结束时间：</span></td>
					<td><input type="text" name="formMap['reportWeek']" id="reportWeekEnd" value="" class="sele"/></td>
				</tr>
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">渠道名：</span></td>
					<td align="left"><input type="text" name="formMap['agentNme']" id="formMap['agentNme']" /></td>
					<td align="right"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;协作人：</span></td>
					<td align="left"><input type="text" name="formMap['supportNme']" id="formMap['supportNme']" /></td>
					<td align="right"><span class="label">出单员：</span></td>
					<td align="left"><input type="text" name="formMap['cOperCde']" id="formMap['cOperCde']" /></td>
					<td align="right"><span class="label">业务员：</span></td>
					<td align="left"><input type="text" name="formMap['cSlsCde']" id="formMap['cSlsCde']" /></td>
					<td colspan="2" style="padding-left:15px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>