<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户经理业绩月报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var curDeptObject = null;
$(function(){
	$.ajax({ 
		url: "<%=_path%>/reportCommon/getCurUserGroupMsg",
		type:"post",
		async: false, 
		dataType: "json",
		success: function(jsonData){
			curDeptObject = jsonData;
		}
	});
	
	iniReportPage('客户经理业绩月报');
	iniReportDept('fComName', 'zhComName', 'yinyebuName');
	iniDate('reportMonth');
	queryReport(1);
});

//机构级联下拉框
function iniReportDept(deptTwo, deptThree,deptFour) {
	// 分公司
	$('#' + deptTwo).omCombo({
		dataSource : Util.appCxtPath + "/department/queryDepartmentByUserCode.do?param=" + Math.random(),
		onSuccess : function(data, textStatus, event) {
			if (data.length == 2)
				$('#' + deptTwo).omCombo({
					value : eval(data)[1].value,
					readOnly : true
				});
		},
		onValueChange : function(target, newValue, oldValue, event) {
			// 加载三级机构
			$('#' + deptThree).val(curDeptObject.deptCodeThree).omCombo('setData', Util.appCxtPath + "/department/queryDepartmentCityByUserCode.do?upDept=" + newValue);
		},
		optionField : function(data, index) {
			return data.text;
		},
		emptyText : "请选择"
	});

	// 三级机构
	$('#' + deptThree).omCombo({
		onSuccess : function(data, textStatus, event) {
			if (data.length === 2) {
				$('#' + deptThree).omCombo("value", data[1].value);
				$('#' + deptThree).omCombo({
					readOnly : true
				});
			}
			
			if(curDeptObject!=null){
				$('#' + deptThree).omCombo({
					value :curDeptObject.deptCodeThree,
					readOnly : true
				});
			}
		},
		onValueChange : function(target, newValue, oldValue, event) {
			// 加载四级单位
			$('#' + deptFour).val('').omCombo('setData', Util.appCxtPath + "/department/queryDepartmentMarketByUserCode.do?upDept=" + newValue);
		},
		emptyText : '请选择'
	});

	// 四级单位
	$('#' + deptFour).omCombo({
		emptyText : "请选择",
		onSuccess : function(data, textStatus, event) {
			if(curDeptObject!=null){
				$('#' + deptFour).omCombo({
					value :curDeptObject.deptCodeFour,
					readOnly : true
				});
			}
		},
	});

} // end iniReportDept()

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
		limit : 30,
		colModel : tableHead,
		showIndex : true,
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
	
	//--设定团队名称
	if(curDeptObject!=null){
		$("#groupName").val(curDeptObject.groupName);
		$("#groupName").attr("readonly",true);
	}
}

function queryReport(operType) {
	$('#operType').val(operType);
	var url = Util.appCxtPath + "/reportCommon/queryMonthGroupReportList.do?" + $("#filterFrm").serialize();
	if (operType === 1) {
		$("#tables").omGrid("setData",url);
	} else if (operType === 2) {
		$("#filterFrm").attr("method","post").attr("action", Util.appCxtPath + "/reportCommon/queryReportList.do").submit();
	} 
	else {
		alert("操作类型错误！");
	}
}

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"fComName",equal:true, dept:true},
    {header:"三级机构", name:"zhComName",equal:true, dept:true},
    {header:"组织单位", name:"yinyebuName",equal:true,dept:true},
    {header:"团队名称", name:"groupName"},
    {header:"团队经理", name:"groupLeader"},
    {header:"近三个月签单保费", name:"jiansanyue1"},
    {header:"最近三月保费收入", name:"jiansanyue2"},
    {header:"本年累计签单净保费",name:"yearSign"},
    {header:"本年电销签单净保费",name:"yearSignDx"},
    {header:"本年累计保费收入",name:"yearIncome"},
    {header:"本年度保单获取成本率",name:"policyCostRate"},
    {header:"本年再保后承保年度制<br/>满期赔付率（不含间接理赔费用）",name:"toYearCompansation"},
    {header:"上年再保后承保年度制<br/>满期赔付率（不含间接理赔费用）",name:"lastYearCompansation"},
    
    //第2行
    //近三个月签单保费			
    {header:"上上月", name:"preMonthSign"},
    {header:"上月", name:"lastMonthSign"},
    {header:"本月", name:"thisMonthSign"},
    
    //最近三月保费收入
    {header:"上上月", name:"preMonthIncome"},
    {header:"上月", name:"lastMonthIncome"},
    {header:"本月", name:"thisMonthIncome"},
    
    {header:"查询月份", name:"reportMonth"},
    {header:"边际贡献额",name:"policyConRateCount"}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[19].header,name:tableCols[19].name,rowspan:2,width:60},//分公司
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:120},//分公司
	{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:120},//三级机构
	{header:tableCols[3].header,name:tableCols[3].name,rowspan:2,width:100},//团队名称
	{header:tableCols[4].header,name:tableCols[4].name,rowspan:2,width:100,renderer:function(v,r,i){
		if(v==""){
			  return "---";
		  }
		  return v;
	}},//职员姓名
	{header:tableCols[5].header,colspan:3},//近三个月签单保费
	{header:tableCols[6].header,colspan:3},//最近三月保费收入
	{header:tableCols[7].header,name:tableCols[7].name,rowspan:2,width:100},//本年累计签单净保费
	{header:tableCols[8].header,name:tableCols[8].name,rowspan:2,width:100},//本年电销签单净保费
	{header:tableCols[9].header,name:tableCols[9].name,rowspan:2,width:100},//本年累计保费收入
	{header:tableCols[10].header,name:tableCols[10].name,rowspan:2,width:100,
		renderer:function(v,r,i){
			if(v===""){
				return '---';
			}else{
				var floatV = changeTwoDecimal_f(v*100);
				return floatV+"%";
			}
	}},//本年度保单获取成本率
	{header:tableCols[11].header,name:tableCols[11].name,rowspan:2,width:100,
		renderer:function(v,r,i){
			if(v===""){
				return '---';
			}else{
				var floatV = changeTwoDecimal_f(v*100);
				return floatV+"%";
			}
	}},//上年保单再保后满期赔付率（不含理赔费用）
	{header:tableCols[12].header,name:tableCols[12].name,rowspan:2,width:100,
		renderer:function(v,r,i){
			if(v===""){
				return '---';
			}else{
				var floatV = changeTwoDecimal_f(v*100);
				return floatV+"%";
			}
			
	}},//本年保单再保后满期赔付率（不含理赔费用）
	{header:tableCols[20].header,name:tableCols[20].name,rowspan:2,width:100,
		renderer:function(v,r,i){
			if(v===""){
				return '---';
			}else{
				return v;
			}
	}},//边际贡献额
   ],
   //第2行
   [
     //近三个月签单保费
	 {header:tableCols[13].header,name:tableCols[13].name,width:100,renderer:function(v,r,i){
			if(v===""){
				return '---';
			}else{
				return v;
			}
	}},
	 {header:tableCols[14].header,name:tableCols[14].name,width:100,renderer:function(v,r,i){
			if(v===""){
				return '---';
			}else{
				return v;
			}
	}},
     {header:tableCols[15].header,name:tableCols[15].name,width:100,renderer:function(v,r,i){
			if(v===""){
				return '---';
			}else{
				return v;
			}
	}},
     //最近三月保费收入
     {header:tableCols[16].header,name:tableCols[16].name,width:100,renderer:function(v,r,i){
			if(v===""){
				return '---';
			}else{
				return v;
			}
	}},
     {header:tableCols[17].header,name:tableCols[17].name,width:100,renderer:function(v,r,i){
			if(v===""){
				return '---';
			}else{
				return v;
			}
	}},
     {header:tableCols[18].header,name:tableCols[18].name,width:100,renderer:function(v,r,i){
			if(v===""){
				return '---';
			}else{
				return v;
			}
	}},
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
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;三级机构：</span></td>
					<td align="left"><input name="formMap['zhComName']" id="zhComName" class="sele"/></td>
					<!-- 
					  <td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;营业部：</span></td>
					  <td align="left"><input name="formMap['yinyebuName']" id="yinyebuName" class="sele"/></td> 
					 -->
					<td style="padding-left:15px"><span class="label">销售团队名称：</span></td>
					<td><input type="text" name="formMap['groupName']" id="groupName" /></td>
					<td align="right"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;查询日期：</span></td>
					<td align="left"><input type="text" name="formMap['reportMonth']" id="reportMonth" value="" class="sele"/></td>
					<td colspan="2" style="padding-left:15px;" align="right"><span id="button-search" onclick="queryReport(1)">查询</span></td>
				</tr>
				<!-- <tr>
					<td align="right"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;查询日期：</span></td>
					<td align="left"><input type="text" name="formMap['reportMonth']" id="reportMonth" value="" class="sele"/></td>
					<td colspan="6" style="padding-left:15px;" align="right"><span id="button-search" onclick="queryReport(1)">查询</span></td>
				</tr>  -->
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>