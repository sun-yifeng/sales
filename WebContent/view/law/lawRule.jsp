<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%String versionId = (String) request.getParameter("versionId");%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>销售人员管理办法-规则</title>
<script type="text/javascript">
$(function() {
	//页钱切换
	$('#make-tab').omTabs({
		closable : false,
		switchMode : 'mouseover'
	});
	
	tabsContr(0);
	tabsContr(1);
});
//设置iframe的高度
window.setInterval(function(){
  var num = 600;
  for(var i = 1; i <= 15; i++) {
	  var iframe = document.getElementById("iframe"+i);   
	  try {  
		  var var1 = iframe.contentWindow.document.documentElement.offsetHeight + 100;
		  if (var1 < num) {
	        iframe.height =  num;   
		  } else {
		  	iframe.height = var1;
		  }
	  } catch (e) {;}
  }
}, 200);

function tabsContr(type){
	$.ajax({ 
		url: "<%=_path%>/lawRate/queryFactorImp.do?versionId=<%=versionId%>&itemType="+type,
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			if(type=='0'){
				if(data=='false'){
					$("#ruleSale").remove();
				}
			}else if(type=='1'){
				if(data=='false'){
					$("#ruleGroup").remove();
				}
			}
			
		}
	});
}

</script>
</head>
<body>
	<div id="make-tab">
		<ul id="tabs">
			<li><a href="#tab1">客户经理规则</a></li>
			<li><a href="#tab2">团队经理规则</a></li>
			<li><a href="#tab3">险种调整系数</a></li>
			<!-- <li><a href="#tab4">业务线调整系数</a></li> -->
            <li><a href="#tab5">车型调整系数</a></li>
			<li><a href="#tab6">渠道调整系数</a></li>
			<li><a href="#tab13">业务来源调整系数</a></li>
			<li><a href="#tab12">区域薪酬系数</a></li>
			<li id="salesRank"><a href="#tab7">销售人员职级</a></li>
			<li id="ruleSale"><a href="#tab8">个人数据导入</a></li>
			<li id="ruleGroup"><a href="#tab9">团队数据导入</a></li>
<!-- 			<li><a href="#tab10">电销保单导入</a></li> -->
			<li id="ruleConfig"><a href="#tab11">其他配置项</a></li>
			<li id="ruleSwitch"><a href="#tab14">权限开关</a></li>
		</ul>
		<div id="tab1"><iframe id="iframe1" frameborder="no" style="width:100%;" src="lawRuleSales.jsp?versionId=<%=versionId%>"></iframe></div>
		<div id="tab2"><iframe id="iframe2" frameborder="no" style="width:100%;" src="lawRuleGroup.jsp?versionId=<%=versionId%>"></iframe></div>
		<div id="tab3"><iframe id="iframe3" frameborder="no" style="width:100%;" src="lawRateCommon.jsp?versionId=<%=versionId%>&&rateType=1"></iframe></div>
		<div id="tab4"><iframe id="iframe4" frameborder="no" style="width:100%;" src="lawRateBizLine.jsp?versionId=<%=versionId%>&&rateType=2"></iframe></div>
		<div id="tab5"><iframe id="iframe5" frameborder="no" style="width:100%;" src="lawRateCommon.jsp?versionId=<%=versionId%>&&rateType=3"></iframe></div>
		<div id="tab6"><iframe id="iframe6" frameborder="no" style="width:100%;" src="lawRateCommon.jsp?versionId=<%=versionId%>&&rateType=4"></iframe></div>
		<div id="tab13"><iframe id="iframe13" frameborder="no" style="width:100%;" src="lawRateBizOrigin.jsp?versionId=<%=versionId%>&&rateType=5"></iframe></div>
		<div id="tab12"><iframe id="iframe12" frameborder="no" style="width:100%;" src="lawAreaRateCommon.jsp?versionId=<%=versionId%>"></iframe></div>
		<div id="tab7"><iframe id="iframe7" frameborder="no" style="width:100%;" src="lawRuleRank.jsp?versionId=<%=versionId%>"></iframe></div>
		<div id="tab8"><iframe id="iframe8" frameborder="no" style="width:100%;" src="lawImpSales.jsp?versionId=<%=versionId%>"></iframe></div>
		<div id="tab9"><iframe id="iframe9" frameborder="no" style="width:100%;" src="lawImpGroup.jsp?versionId=<%=versionId%>"></iframe></div>
		<div id="tab10"><iframe id="iframe10" frameborder="no" style="width:100%;" src="lawElectricPolicy.jsp?versionId=<%=versionId%>"></iframe></div>
		<div id="tab11"><iframe id="iframe11" frameborder="no" style="width:100%;" src="lawRuleConfig.jsp?versionId=<%=versionId%>"></iframe></div>
		<div id="tab14"><iframe id="iframe14" frameborder="no" style="width:100%;" src="lawRuleSwitch.jsp?versionId=<%=versionId%>"></iframe></div>
	</div>
	<!-- 
	<div>
		<table id="buttonDiv" style="width:100%; margin-top:20px;display:none;">
			<tr>
				<td align="center"><a class="om-button" href="javascript:history.go(-1);" id="button-cancel">返回主页</a></td>
			</tr>
	     </table>
	</div>
	-->
</body>
<!-- 1、关闭分公司对考核职级配置项的调整权限，即基本法配置中考核职级信息页面对分公司用户只读； -->
<script type="text/javascript">
	$.ajax({ 
		url: "<%=_path%>/common/queryCurrUserRoleEname.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			if(data.indexOf("xszcAdmin") == -1 
					&& data.indexOf("headDeptSalesmanCreditNew") == -1  
					&& data.indexOf("headDeptSalesmanManageNew") == -1  ){
				$("#ruleConfig").remove();
				$("#ruleSwitch").remove();
			}
		}
	});
</script>
</html>