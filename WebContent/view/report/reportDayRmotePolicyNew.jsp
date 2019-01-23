<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>远程出单点业绩日报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('远程出单点业绩日报');
	iniDept('fComName', 'zhComName', 'yinyebuName');
	iniDate('reportDay');
	iniQuery();
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"fComName", equal:true, dept:true},
    {header:"三级机构", name:"zhComName", equal:true, dept:true},
    {header:"四级单位", name:"yinyebuName", equal:true},
    {header:"合作机构渠道名称", name:"cChaNme", like:true},
    {header:"远程出单点<br/>销售团队代码", name:"remoteCde", like:true},
    {header:"远程出单点名称", name:"nodeName", like:true},
    {header:"设立时间", name:"createdDate"},
    {header:"设立时预计保费", name:"targetPremium"},
    {header:"出单员", name:"cOperCde", like:true},
    {header:"业务员", name:"cSlsCde", like:true},
    {header:"协作人", name:"cTrueAgtNme", like:true}, //10
    {header:"签单保费（元）"},
    {header:"保费收入（元）"},
    //第2行
    //签单保费(元)			
    {header:"昨日", name:"lastDaySign"},
    {header:"本日", name:"thisDaySign"},
    {header:"本月", name:"monthSign"},
    {header:"本年累计", name:"yearSign"},
    //保费收入(元)
    {header:"昨日", name:"lastDayIncome"},
    {header:"本日", name:"thisDayIncome"},
    {header:"本月", name:"monthIncome"},
    {header:"本年累计", name:"yearIncome"},
    {header:"去年同期", name:"lastYearIncome"},
    {header:"同比增长率", name:"yearGrouthRate",percent:true},
    //
    {header:"报表日期", name:"reportDay", equal:true, hide:true}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:100},
	{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:150},
	{header:tableCols[2].header,name:tableCols[2].name,rowspan:2,width:150},
	{header:tableCols[3].header,name:tableCols[3].name,rowspan:2,width:280},
	{header:tableCols[4].header,name:tableCols[4].name,rowspan:2,width:150},
	{header:tableCols[5].header,name:tableCols[5].name,rowspan:2,width:280},
	{header:tableCols[6].header,name:tableCols[6].name,rowspan:2,width:150},
	{header:tableCols[7].header,name:tableCols[7].name,rowspan:2,width:150},
	{header:tableCols[8].header,name:tableCols[8].name,rowspan:2,width:150},
	{header:tableCols[9].header,name:tableCols[9].name,rowspan:2,width:150},
	{header:tableCols[10].header,name:tableCols[10].name,rowspan:2,width:280},
	{header:tableCols[11].header,colspan:4},
	{header:tableCols[12].header,colspan:6}
   ],
   //第2行
   [
	{header:tableCols[13].header,name:tableCols[13].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[14].header,name:tableCols[14].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[15].header,name:tableCols[15].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[16].header,name:tableCols[16].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    //
    {header:tableCols[17].header,name:tableCols[17].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[18].header,name:tableCols[18].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[19].header,name:tableCols[19].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[20].header,name:tableCols[20].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[21].header,name:tableCols[21].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[22].header,name:tableCols[22].name,width:100,renderer:function(v,r,i){return alignCell(v);}}
   ]
];

</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_DAY_REMOTE_POLICY_NEW"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportDayRemotePolicyNew"/>
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;三级机构：</span></td>
					<td align="left"><input name="formMap['zhComName']" id="zhComName" class="sele"/></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;四级单位：</span></td>
					<td align="left"><input name="formMap['yinyebuName']" id="yinyebuName" class="sele"/></td>
					<td align="right"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;报表日期：</span></td>
					<td align="left"><input type="text" name="formMap['reportDay']" id="reportDay" value="" class="sele"/></td>
				</tr>
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">渠道名：</span></td>
					<td align="left"><input type="text" name="formMap['cChaNme']" id="formMap['cChaNme']" /></td>
					<td align="right"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;协作人：</span></td>
					<td align="left"><input type="text" name="formMap['cTrueAgtNme']" id="formMap['cTrueAgtNme']" /></td>
					<td align="right"><span class="label">出单员：</span></td>
					<td align="left"><input type="text" name="formMap['cOperCde']" id="formMap['cOperCde']" /></td>
					<td align="right"><span class="label">业务员：</span></td>
					<td align="left"><input type="text" name="formMap['cSlsCde']" id="formMap['cSlsCde']" /></td>
					
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