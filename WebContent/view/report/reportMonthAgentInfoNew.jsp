<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>渠道发展情况月报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('渠道发展情况月报');
	iniDept('fComName', 'zhComName', 'yinyebuName');
	iniDate('reportMonth');
	iniQuery();
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"fComName", equal:true, dept:true},
    {header:"中支机构", name:"zhComName", equal:true, dept:true},
    {header:"四级单位", name:"yinyebuName", equal:true, dept:true},
    {header:"合作机构渠道数量"},
    {header:"个人代理人数量"},
    {header:"渠道数量（按照渠道性质分类统计）"},
    {header:"合作机构渠道本年度产能（年化）（年化产能=当年度实际产能/当年合作天数*本年度天数，当年度合作天数=当前日期-协议生效日期）"},
    //第2行
    {header:"有效", name:"zjYxAmt",round:true},
    {header:"失效", name:"zjSxAmt",round:true},
    {header:"本年新增有效渠道", name:"zjXzYear",round:true},
    {header:"现有", name:"grYxAmt",round:true},
    {header:"新增", name:"grXzAmt",round:true}, //10
    {header:"失效",name:"grSxAmt",round:true},
    {header:"银保",name:"ybAmt",round:true},
    {header:"非银保金融渠道",name:"fybAmt",round:true},
    {header:"邮政",name:"yzAmt",round:true},
    {header:"车行",name:"chAmt",round:true},
    {header:"网代",name:"wdAmt",round:true},
    {header:"专代",name:"zyAmt",round:true},
    {header:"经纪",name:"jjAmt",round:true},
    {header:"个代",name:"grAmt",round:true},
    {header:"0≤A＜10",name:"incomeLevelJ",round:true},
    {header:"10≤A＜50", name:"incomeLevelI",round:true},
    {header:"50≤A＜100", name:"incomeLevelH",round:true},
    {header:"100≤A＜300", name:"incomeLevelG",round:true},
    {header:"300≤A＜500", name:"incomeLevelF",round:true},
    {header:"500≤A＜1000", name:"incomeLevelE",round:true},
    {header:"1000≤A＜2000", name:"incomeLevelD",round:true},
    {header:"2000≤A＜3000", name:"incomeLevelC",round:true},
    {header:"3000≤A＜5000", name:"incomeLevelB",round:true},
    {header:"5000≤A", name:"incomeLevelA",round:true},
  {header:"报表日期", name:"reportMonth", equal:true, hide:true}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:150},
	{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:150},
	{header:tableCols[2].header,name:tableCols[2].name,rowspan:2,width:150},
	{header:tableCols[3].header,colspan:3},
	{header:tableCols[4].header,colspan:3},
	{header:tableCols[5].header,colspan:8},
	{header:tableCols[6].header,colspan:10},
   ],
   //第2行
   [
	{header:tableCols[7].header,name:tableCols[7].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[8].header,name:tableCols[8].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[9].header,name:tableCols[9].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[10].header,name:tableCols[10].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[11].header,name:tableCols[11].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[12].header,name:tableCols[12].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[13].header,name:tableCols[13].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
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
    {header:tableCols[30].header,name:tableCols[30].name,width:100,renderer:function(v,r,i){return alignCell(v);}}
    ]];

</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_MONTH_AGENT_INFO_NEW"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportMonthAgentInfoNew"/>
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					<td align="right" style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td align="left"><input name="formMap['zhComName']" id="zhComName" class="sele"/></td>
                    <td align="right" style="padding-left:15px"><span class="label">四级单位：</span></td>
                    <td align="left"><input name="formMap['yinyebuName']" id="yinyebuName" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">报表日期：</span></td>
					<td><input type="text" name="formMap['reportMonth']" id="reportMonth" value="" class="sele"/></td>
					<td style="padding-left:15px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr>
				
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>