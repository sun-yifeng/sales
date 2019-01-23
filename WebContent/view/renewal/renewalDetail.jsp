<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<% 
String renewalId = request.getParameter("renewalId") == null ? "" : request.getParameter("renewalId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
html, body{ height:100%; margin:0px; padding:0px;}
body {font-size:12px;}
input {
	height:18px;
	border: 1px solid #A1B9DF;
	vertical-align: middle;
}
</style>
<title>续保保单详情</title>
<script type="text/javascript">
var renewalId = "<%=renewalId %>";
$(function(){
	$("#button-cancel").omButton({
		icons : {left : '<%=_path%>/images/remove.png' },
		onClick:function(event){
			 history.back();
		}
	});
	
	//
	Util.post("<%=_path%>/renewal/queryRenewalById.do?renewalId="+renewalId,"",
			function(data){
				$("#queryRenewal").find(":input").each(function(){
    				$(this).val(data[$(this).attr("name")]);
    				
    				var date = new Date(data[$("#safeBeginDate").attr("name")]);
    				$("#safeBeginDate").val($.omCalendar.formatDate(date, 'yy-mm-dd'));
    				
    				var date1 = new Date(data[$("#safeEndDate").attr("name")]);
    				$("#safeEndDate").val($.omCalendar.formatDate(date1, 'yy-mm-dd'));
    				
    				var date2 = new Date(data[$("#renewalDate").attr("name")]);
    				$("#renewalDate").val($.omCalendar.formatDate(date2, 'yy-mm-dd'));
    				
    				var date3 = new Date(data[$("#monthsRenewal").attr("name")]);
    				$("#monthsRenewal").val($.omCalendar.formatDate(date3, 'yy-mm-dd'));
    				
    				var policyHolderPhone = data[$("#policyHolderPhone").attr("name")];
    				$("#policyHolderPhone").val(checkPhone(policyHolderPhone));
    				
    				var recognizeePhone = data[$("#recognizeePhone").attr("name")];
    				$("#recognizeePhone").val(checkPhone(recognizeePhone));
    			});
			}
	);
	
});

//隐藏电话号码
function checkPhone(value){
	if(value.substring(0,1) == "1"){
		return value;
	}else{
		if(value.length <= 8){
			value = "****" + value.substr(4);
			return value;
		}else{
			value = value.substring(0,4) + "****" + value.substr(8);
			return value;
		}
	}
}
	
</script>
</head>
<body>
        <div id="saleGroup">
			<table style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
				<tr><td>续保保单详情</td></tr>
			</table>
			<form id="renewalQuery">
				<input type="hidden" name="formMap['insuraName']"  id="insuraName_fk1"  value=""/>
			</form>
			<div>
			<fieldSet style="margin-top: 10px;">
				<legend style="margin-left: 40px;font-size:12px;">续保保单详细信息</legend>
					<form id="queryRenewal">
					<center>
						<table style="width:100%">
							<tr>
								<td  align="right"><span class="label">出单业务员编号：</span></td>
								<td><input name="salesmanNo" id="salesmanNo_fk"  readOnly="true"/></td>
								<td  align="right"><span class="label">所属分公司：</span></td>
								<td><input name="deptNameTwo"  id="deptNameTwo"  readOnly="true"/></td>
								<td  align="right"><span class="label">出单机构：</span></td>
								<td  align="left" style="padding-left:10px;"><input name="deptNameFour"  id="deptNameFour"  readOnly="true"/></td>
							</tr>
							<tr>
								<td  align="right"><span class="label">报案人电话：</span></td>
								<td><input name="alarmPhone" id="alarmPhone" readOnly="true" /></td>
								<td  align="right"><span class="label">出险次数：</span></td>
								<td><input name="claimCount" id="claimCount" readOnly="true" /></td>
								<td  align="right"><span class="label">是否亏损单：</span></td>
								<td  align="left" style="padding-left:10px;"><input name="lossFlag"  id="lossFlag"  readOnly="true" /></td>
							</tr>
							<tr>
								<td  align="right">续保保单号：</td>
								<td><input type="text" name="renewalPolicyNo" id="renewalPolicyNo"  readOnly="true"/></td>
								<td  align="right">发动机号：</td>
								<td><input type="text" name="engineNumber"  id="engineNumber" readOnly="true"/></td>
								<td  align="right">车架号：</td>
								<td  align="left" style="padding-left:10px;"><input type="text" name="vin"  id="vin"  readOnly="true" /></td>
							</tr>
							<tr>
								<td  align="right">投保人电话：</td>
								<td><input type="text" name="policyHolderPhone"  id="policyHolderPhone" readOnly="true" /></td>
								<td  align="right">险种：</td>
								<td><input type="text" name="insuraName"  id="insuraName"  readOnly="true"/></td>
								<td  align="right">报案人：</td>
								<td  align="left" style="padding-left:10px;"><input type="text" name="alarmName"  id="alarmName"  readOnly="true"/></td>
							</tr>
							<tr>
								<td  align="right">被保人姓名：</td>
								<td><input type="text" name="recognizeeName"  id="recognizeeName"  readOnly="true"/></td>
								<td  align="right">保险起期：</td>
								<td><input type="text" name="safeBeginDate"  id="safeBeginDate" readOnly="true" /></td>
								<td  align="right">保险止期：</td>
								<td  align="left" style="padding-left:10px;"><input type="text" name="safeEndDate"  id="safeEndDate" readOnly="true" /></td>
							</tr>
							<tr>
								<td  align="right">初次登记日：</td>
								<td><input type="text" name="fristRegetDate"  id="fristRegetDate"  readOnly="true"/></td>
								<td  align="right">被保人电话：</td>
								<td><input type="text" name="recognizeePhone"  id="recognizeePhone" readOnly="true"/></td>
								<td  align="right">核保时间：</td>
								<td  align="left" style="padding-left:10px;"><input type="text" name="renewalDate"  id="renewalDate" readOnly="true" /></td>
							</tr>
							<tr>
								<td  align="right">已下发的层级：</td>
								<td><input type="text" name="assignLevel"  id="assignLevel" readOnly="true" /></td>
								<td  align="right">续保机构：</td>
								<td><input type="text" name="renewalBusiDept"  id="renewalBusiDept" readOnly="true" /></td>
								<td  align="right">续保业务员：</td>
								<td  align="left" style="padding-left:10px;"><input type="text" name="renewalSalesmanCode"  id="renewalSalesmanCode" readOnly="true" /></td>
							</tr>
							<tr>
								<td  align="right">所属分公司：</td>
								<td><input type="text" name="deptNameTwo"  id="deptNameTwo" readOnly="true" /></td>
								<td  align="right">赔付率：</td>
								<td><input type="text" name="lossRatio"  id="lossRatio" readOnly="true" /></td>
								<td  align="right">处理月份：</td>
								<td  align="left" style="padding-left:10px;"><input type="text" name="monthsRenewal"  id="monthsRenewal" readOnly="true" /></td>
							</tr>
							<tr>
								<td  align="right">代理人名称：</td>
								<td><input type="text" name="agentName"  id="agentName" readOnly="true"/></td>
								<td  align="right">代理人代码：</td>
								<td><input type="text" name="agentCode"  id="agentCode" readOnly="true" /></td>
								<td  align="right">保费收入：</td>
								<td  align="left" style="padding-left:10px;"><input type="text" name="premium"  id="premium"  readOnly="true"/></td>
							</tr>
							<tr>
								<td  align="right">客户类型：</td>
								<td><input type="text" name="custType"  id="custType"  readOnly="true"/></td>
								<td  align="right">保单号：</td>
								<td><input type="text" name="policyNo"  id="policyNo"  readOnly="true"/></td>
								<td  align="right" rowspan=2 >厂牌车型：</td>
								<td  rowspan=2   align="left" style="padding-left:10px;"> <textarea rows="3" cols="30"  name="brnd"  id="brnd" readOnly="true"></textarea> </td>
								<!-- <input type="text" name="brnd"  id="brnd" readOnly="true" /> -->
							</tr>
							<tr>
								<td  align="right">投保人姓名：</td>
								<td><input type="text" name="policyHolderName" id="policyHolderName" readOnly="true" /></td>
								<td  align="right">车牌号：</td>
								<td><input type="text" name="vehicleCode"  id="vehicleCode" readOnly="true" /></td>
							</tr>
						</table>
					</center>
					</form>
				</fieldSet>
			</div>
			<div>
				<table style="width: 100%">
					<tr>
						<td style="padding-left:30px;padding-top:10px" align="center">
						<a id="button-cancel" >取消</a></td>
					</tr>
				</table>
			</div>
		</div>
</body>
</html>