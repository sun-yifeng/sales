<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<% 
   String versionId = (String) request.getParameter("versionId"); 
   String versionCname = (String) request.getParameter("versionCname"); 
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>管理办法</title>
<style>
</style>
<script type="text/javascript">
$(function(){
	//导航菜单
	$("#search-panel").omPanel({
    	title : "管理办法复制 > 复制计算规则",
    	collapsible : false,
    	collapsed : false
    });
	//按钮样式
	$("#button-confirm").omButton();
	$("#button-cancel").omButton();
	//全选复制内容
	$("#checkAll").click(function() {
		$("#checkAllDel").attr("checked",false);
		$("input[name^='rule").each(function() {
			$(this).attr("checked", true);
		});
	});
	//反选复制内容
	$("#checkAllDel").click(function() {
		$("#checkAll").attr("checked",false);
		$("input[name^='rule']").each(function() {
			$(this).attr("checked", false);
		});
	});

});
</script>
</head>
<body>
	<div id="search-panel">
	            操作步骤如下<br><br>
		<form action="">
		1、您选择了《<span style="color:red;font-weight:bold;"><%=versionCname%></span>》作为复制的数据来源，您确定吗？<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="" value="">确定&nbsp;&nbsp;<input type="checkbox" name="" value="">待定<br><br>
		2、请选择需要复制的内容（可多选）<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="checkAll" value="">全选
		&nbsp;&nbsp;<input type="checkbox" name="" id="checkAllDel" value="">反选<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;客户经理规则：
		&nbsp;&nbsp;<input type="checkbox" name="ruleSalesSys" value="">系统因素
		&nbsp;&nbsp;<input type="checkbox" name="ruleSalesImp" value="">导入因素
		&nbsp;&nbsp;<input type="checkbox" name="ruleSalesRev" value="">考核因素
		&nbsp;&nbsp;<input type="checkbox" name="ruleSalesCal" value="">计算公式
		&nbsp;&nbsp;<input type="checkbox" name="ruleSalesChe" value="">考核规则<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;团队经理规则：
		&nbsp;&nbsp;<input type="checkbox" name="ruleGroupSys" value="">系统因素
		&nbsp;&nbsp;<input type="checkbox" name="ruleGroupImp" value="">导入因素
		&nbsp;&nbsp;<input type="checkbox" name="ruleGroupRev" value="">考核因素
		&nbsp;&nbsp;<input type="checkbox" name="ruleGroupCal" value="">计算公式
		&nbsp;&nbsp;<input type="checkbox" name="ruleGroupChe" value="">考核规则<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;标保调整系数：
		&nbsp;&nbsp;<input type="checkbox" name="ruleRateProd" value="">险种系数
		&nbsp;&nbsp;<input type="checkbox" name="ruleRateLine" value="">业务线调整系数
		&nbsp;&nbsp;<input type="checkbox" name="ruleRatevehi" value="">车型调整系统
		&nbsp;&nbsp;<input type="checkbox" name="ruleRateChan" value="">渠道调整系数
		&nbsp;&nbsp;<input type="checkbox" name="ruleRateCost" value="">成本调整系数
		<br>
		<br>
		3、请选择复制的目的地（可多选）<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="" value="">全选
		&nbsp;&nbsp;<input type="checkbox" name="" value="">反选<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		&nbsp;&nbsp;<input type="checkbox" name="" value="">深圳分公司常规渠道销售人员管理办法2015版
		<br>
		<br>
		4、如果目的地已存在计算规则，您是要求覆盖还是忽略（跳过）呢？<br>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="" value="">覆盖
		&nbsp;&nbsp;<input type="checkbox" name="" value="">忽略<br>
		</form>
		<div>
			<table style="width:100%; margin-top:20px;">
				<tr>
					<td align="center">
					<a class="om-button" id="button-confirm" onclick="save()">开始复制</a>
					<a class="om-button" href="javascript:history.go(-1);" id="button-cancel">取消复制</a></td>
				</tr>
		     </table>
		</div>
	</div>
</body>
<script type="text/javascript">
function save(){
	//
}
</script>
</html>