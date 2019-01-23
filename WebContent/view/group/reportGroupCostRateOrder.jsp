<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>团队边际贡献排行</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniReportPage('团队边际贡献排行');
	iniDept('fComName', 'zhComName', 'yinyebuName');
	iniDate('reportMonth');
	queryReport(1);
});

//报表页面初始化
function iniReportPage(panelTile) {
	// 样式
	$("#filterFrm").find("input[name^='formMap']").css({
		"width" : "150px"
	});
	
	$(".sele").css({
		"width" : "132px"
	});
	
    // 导航
	$("#search-panel").omPanel({
		title : (panelTile=="客户经理考核评分查询"||panelTile=="团队经理考核评分查询")? "考核评分管理  > " + panelTile:"报表管理  > " + panelTile,
		collapsible : true,
		collapsed : false
	});

	// 报表表格
	dataGrid = $("#tables").omGrid({
		limit : 0,
		colModel : tableHead,
		showIndex : false,
		height : calcHeight("search-panel"),
		method : 'POST'
	});

	// 按钮样式
	$("#button-search").omButton({
		icons : {
			left : Util.appCxtPath + '/images/search.png'
		},
		width : 50
	});
	$("#button-dataToExcel").omButton({
		icons : {
			left : Util.appCxtPath + '/images/op-edit.png'
		},
		width : 60
	});
}

function queryReport(operType) {
	$('#operType').val(operType);
	var url = Util.appCxtPath + "/reportCommon/queryMonthGroupPaihangList.do?" + $("#filterFrm").serialize();
	if (operType === 1) {
		$("#tables").omGrid("setData",url);
	} else if (operType === 2) {
		$("#filterFrm").attr("method","post").attr("action", Util.appCxtPath + "/reportCommon/queryReportList.do").submit();
	} 
	else {
		alert("操作类型错误！");
	}
}

//表头样式
var tableHead = [
   //第1行
   [
     {header:"名次", name:"paimingIndex",width:60,renderer:function(v,r,i){
    	 return i+1;
	 }},//名次
     {header:"分公司", name:"deptName2",width:120},//分公司
	 {header:"三级机构", name:"deptName3",width:120},//三级机构
	 {header:"团队名称", name:"groupName",width:120},//团队名称
	 {header:"团队长", name:"groupLeader",width:130},//团队长
	 {header:"边际贡献额",name:"policyConRateCount",width:100,renderer:function(v,r,i){
		 if(v==''||v=="%"){
		     return '---';
		 }else{
			 return v;
		 }
	 }},//边际贡献额
	 {header:"保费达成率",name:"schemRate",width:100,renderer:function(v,r,i){
		 if(v==''||v=="%"){
		     return '---';
		 }else{
			 return v;
		 }
	 }},//标准保费达成率
	 {header:"保费收入(万元)",name:"yearIncome",width:100,renderer:function(v,r,i){
		 if(v==''){
		     return '---';
		 }else{
			 return v;
		 }
	 }},//保费收入(万元)
	 {header:"当年保单赔付率",name:"toYearCompansation",width:100,renderer:function(v,r,i){
		 if(v==''||v=="%"){
		     return '---';
		 }else{
			 return v;
		 }
	 }},//当年保单赔付率
	 {header:"保单获取成本",name:"policyCostRate",width:100,renderer:function(v,r,i){
		 if(v==''||v=="%"){
		     return '---';
		 }else{
			 return v;
		 }
	 }},//保单获取成本
	 {header:"本年保单承保边际贡献率",name:"policyConRate",width:100,renderer:function(v,r,i){
		 if(v==''||v=="%"){
		     return '---';
		 }else{
			 return v;
		 }
	 }},//本年保单承保边际贡献率
	 {header:"再保后历年制赔付率",name:"policyCostRate",width:100,renderer:function(v,r,i){
		 if(v==''||v=="%"){
		     return '---';
		 }else{
			 return v;
		 }
	 }},//再保后历年制赔付率
	 {header:"金明星",name:"saleStar",width:100}//金明星
   ]
];

function changeTwoDecimal_f(x) {
    var f_x = parseFloat(x);
    if (isNaN(f_x)) {
        alert('function:changeTwoDecimal->parameter error');
        return false;
    }
    var f_x = Math.round(x * 100) / 100;
    var s_x = f_x.toString();
    var pos_decimal = s_x.indexOf('.');
    if (pos_decimal < 0) {
        pos_decimal = s_x.length;
        s_x += '.';
    }
    while (s_x.length <= pos_decimal + 2) {
        s_x += '0';
    }
    return s_x;
}
</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['orderType']" id="orderType" value="reportGroupCostRateOrder"/>
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;三级机构：</span></td>
					<td align="left"><input name="formMap['zhComName']" id="zhComName" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">报表日期：</span></td>
					<td><input type="text" name="formMap['reportMonth']" id="reportMonth" value="" class="sele"/></td>
				    <td style="padding-left:15px;" align="right"><span id="button-search" onclick="queryReport(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>