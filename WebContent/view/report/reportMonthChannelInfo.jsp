<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>渠道信息统计月报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('渠道信息统计月报');
	iniDept('fComName', 'zhComName', 'yinyebuName');
	iniDate('reportMonth');
	iniQuery();
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"fComName", equal:true, dept:true},
    {header:"三级机构",name:"zhComName", equal:true, dept:true},
    {header:"四级单位",name:"yinyebuName", equal:true, dept:true},
    {header:"渠道名称",name:"mediumCname",like:true},
    {header:"渠道大类",name:"channelHead"},
    {header:"渠道类型",name:"channelType",like:true},
    {header:"渠道性质",name:"channelProperty"},
    {header:"上级渠道", name:"parentChannel"},
    {header:"渠道层级", name:"chaLevel",round:true},
    {header:"协议起期" , name:"validDate"},
    {header:"协议止期", name:"expireDate"}, //10
    {header:"证照止期",name:"licenseExpireDate"},
    {header:"合作状态",name:"coFlag",like:true},
    {header:"预警提醒",name:"warFlag"},
    
    
    {header:"报表日期", name:"reportMonth", equal:true, hide:true}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,width:150},
	{header:tableCols[1].header,name:tableCols[1].name,width:150},
	{header:tableCols[2].header,name:tableCols[2].name,width:150},
	{header:tableCols[3].header,name:tableCols[3].name,width:280},
	{header:tableCols[4].header,name:tableCols[4].name,width:100},
	{header:tableCols[5].header,name:tableCols[5].name,width:150},
	{header:tableCols[6].header,name:tableCols[6].name,width:150},
	{header:tableCols[7].header,name:tableCols[7].name,width:140},
	{header:tableCols[8].header,name:tableCols[8].name,width:100},
	{header:tableCols[9].header,name:tableCols[9].name,width:100},
	{header:tableCols[10].header,name:tableCols[10].name,width:100},
	{header:tableCols[11].header,name:tableCols[11].name,width:100},
	{header:tableCols[12].header,name:tableCols[12].name,width:100},
	{header:tableCols[13].header,name:tableCols[13].name,width:100}]];

</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_MONTH_CHANNEL_INFO"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportMonthChannelInfo"/>
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					<td align="right" style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td align="left"><input name="formMap['zhComName']" id="zhComName" class="sele"/></td>
					<td align="right" style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td align="left"><input name="formMap['yinyebuName']" id="yinyebuName" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">渠道名称：</span></td>
					<td><input type="text" name="formMap['mediumCname']" id="mediumCname" value="" style="width:150px" class=""/></td>
					
				</tr>
				<tr>
				    <td align="right" style="padding-left:15px"><span class="label">渠道类型：</span></td>
					<td align="left"><input name="formMap['channelType']" id="channelType" style="width:150px" class=""/></td>
					<td align="right" style="padding-left:15px"><span class="label">合作状态：</span></td>
					<td align="left"><input name="formMap['coFlag']" id="coFlag" style="width:150px" class=""/></td>
					<td style="padding-left:15px" align="right"><span class="label">报表日期：</span></td>
					<td><input type="text" name="formMap['reportMonth']" id="reportMonth" value="" class="sele"/></td>
				<td colspan="2" style="padding-left:15px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>