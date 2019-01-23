<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>团队经理业绩跟踪报表</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var curDeptObject = null;
$(function(){
	//加载分公司
	$.ajax({ 
		url: "<%=_path%>/reportCommon/getCurUserGroupMsg",
		type:"post",
		async: false, 
		dataType: "json",
		success: function(jsonData){
			curDeptObject = jsonData;
		}
	});
	
	iniReportPage('团队经理业绩跟踪报表');
	iniReportDept('fComName', 'zhComName', 'yinyebuName');
	iniDate('reportDay');
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
	var url = Util.appCxtPath + "/reportCommon/queryDayGroupReportList.do?" + $("#filterFrm").serialize();
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
    {header:"查询日期", name:"reportDay",rowspan:2,width:100},//报表时间
    {header:"分公司", name:"fComName",rowspan:2,width:100},//分公司
	{header:"三级机构", name:"zhComName",rowspan:2,width:100},//三级机构
	{header:"销售团队名称", name:"groupName",rowspan:2,width:130},//销售团队名称
	{header:"团队经理", name:"groupLeader",rowspan:2,width:100,renderer:function(v,r,i){
		if(v==""){
		   return "---";
		}
		return v;
	}},//团队经理
	{header:"本日",colspan:3},//本日
	{header:"本月累计", name:"monthIncome",rowspan:2,width:100},//本月累计
	{header:"本年累计", name:"yearSignTotal",rowspan:2,width:100,renderer:function(v,r,i){return v}},//本年累计
	{header:"本年电销", name:"yearSignDx",rowspan:2,width:100,renderer:function(v,r,i){
		if(v==""){
			  return "---";
		  }
		  return v;
	}},//本年电销
	{header:"本年保费收入", name:"yearIncome",rowspan:2,width:100}//本年保费收入
   ],
   //第2行
   [
	  {header:"非电销", name:"daySign",width:80,renderer:function(v,r,i){return alignCell(v);}},//非电销
	  {header:"电销", name:"daySignDx",width:80,renderer:function(v,r,i){
		  if(v==""){
			  return "---";
		  }
		  return v;
      }},//电销
      {header:"小计", name:"daySignTotal",width:80,renderer:function(v,r,i){return r.thisDayIncome;}}//小计
   ]
];

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
					<td align="right" style="padding-left:15px"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;营业部：</span></td>
					<td align="left"><input name="formMap['yinyebuName']" id="yinyebuName" class="sele"/></td>
					<td style="padding-left:15px"><span class="label">销售团队名称：</span></td>
					<td><input type="text" name="formMap['groupName']" id="groupName" /></td>
				</tr>
				<tr>
					<td align="right"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;查询日期：</span></td>
					<td align="left"><input type="text" name="formMap['reportDay']" id="reportDay" value="" class="sele"/></td>
					<td colspan="2" style="padding-left:15px;" align="right"><span id="button-search" onclick="queryReport(1)">查询</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>