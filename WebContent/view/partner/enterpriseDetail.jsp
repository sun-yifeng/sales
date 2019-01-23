<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
html, body{width: 100%; height: 100%; padding: 0; margin: 0; overflow: hidden;}
/*校验星号*/
span.asterisk{color:red;position:relative;top:4px;}
</style>
<title>企业合作伙伴详情</title>
<%String channelCode = request.getParameter("channelCode");%>
<script type="text/javascript">
$(function(){
	$("#baseInfo").find("input[name^='formMap']").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#processDeptCode").css({"background-color":"#fff"});
	$("#parentChannelCode").css({"background-color":"#fff"});
	/************************************************************ 企业基本信息 开始  *********************************************************************/
	Util.post("<%=_path%>/enterprise/queryEnterpriseByPk.do?channelCode=<%=channelCode%>", "",function(data) {
	        $("#baseInfo").find(":input").each(function(){
	            if($(this).val() != null || $(this).val() != "")
	            $(this).val(data[$(this).attr("id")]);
	        });
			$("#baseInfo").find("input[name^='formMap']").each(function(){
			    $(this).attr({disabled:"disabled"});
			});
	        $('#signDate').omCalendar({disabled: true});
	        $('#bankProvince').omCombo({dataSource: "<%=_path%>/common/queryProvince.do", value: data.bankProvince, disabled: true});
	        $('#bankCity').omCombo({dataSource: "<%=_path%>/common/queryCity.do?province="+data.bankProvince, value: data.bankCity, disabled: true});
	        $('#bankReceive').omCombo({value: data.bankReceive, disabled: true});
	        $('#bankNode').omCombo({dataSource: "<%=_path%>/common/queryBankNode.do?bank="+data.bankReceive+"&city="+data.bankCity,value: data.bankNode, disabled: true});
	        $('#parterLevel').omCombo({dataSource:<%=Constant.getCombo("isParterLevel")%>, value: data.parterLevel, disabled: true});
	        $('#businessLine').omCombo({dataSource: <%=Constant.getCombo("businessLine")%>, value: data.businessLine, disabled: true});
	        $('#channelCategory').omCombo({dataSource: <%=Constant.getCombo("channelCategory1")%>, value: data.channelCategory, disabled: true});
	        $('#channelFlag').omCombo({dataSource: [{"text":"请选择","value":""},{"text":"内部（传统渠道）","value":"0"},{"text":"外部（电商渠道）","value":"2"}],value: data.channelFlag});
	        $('#profession').omCombo({dataSource: "<%=_path%>/common/queryProfession.do", value: data.profession, disabled: true});
	});

	$("#button-cancel").omButton({icons:{left:'<%=_path%>/images/remove.png'}, width:50});
  
  /************************************************************ 企业基本信息 结束 *********************************************************************/
});

//取消操作
function cancel(){
	window.location.href = "enterprise.jsp?paramChannelCode=${param.paramChannelCode}";
}
</script>
</head>
<body>
	<div>
		<table class="navi-no-tab">
			<tr><td>企业合作伙伴详情</td></tr>
		</table>
	</div>
	<div>
		<fieldSet>
			<legend>基本信息</legend>
                    <form id="baseInfo" >
                        <!-- 隐藏域参数 -->
                        <input type="hidden" name="formMap['processDeptCode']" id="processDeptCode" />
                        <input type="hidden" name="formMap['parentChannelCode']" id="parentChannelCode" />
                        <input type="hidden" name="formMap['processUserCode']" id="processUserCode" />
                        <div id="leftDiv" style="float: left;">
                            <table>
                                <tr>
                                    <td style="padding-left:30px" align="right"><span class="label">企业中文名称：</span></td>
                                    <td style="vertical-align: middle;"><input name="formMap['mediumCname']" id="mediumCname" /><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">企业英文名称：</span></td>
                                    <td><input type="text" name="formMap['mediumEname']" id="mediumEname" /></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">渠道编码：</span></td>
                                    <td><input type="text" name="formMap['channelCode']" id="channelCode" readonly="readonly" value="系统生成"/></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                </tr>
                                <tr>    
                                    <td style="padding-left:30px" align="right"><span class="label">签约时间：</span></td>
                                    <td><input class="sele" type="text" name="formMap['signDate']" id="signDate" readonly="readonly"/><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">业务线：</span></td>
                                    <td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" readonly="readonly"/><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">渠道大类：</span></td>
                                    <td><input class="sele" name="formMap['channelCategory']" id="channelCategory" readonly="readonly"/><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:30px" align="right"><span class="label">渠道来源：</span></td>
                                    <td><input class="sele" name="formMap['channelFlag']" id="channelFlag" readonly="readonly" /><span id="channelFlag" class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
                                    <td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['processDeptCname']" id="processDeptCname" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" readonly="readonly"/><span id="choose" name="choose" class="om-combo-trigger"></span></span><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">上级渠道：</span></td>
                                    <td><input name="formMap['parentChannelName']" id="parentChannelName" onclick="selParentMedium();" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" /><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                </tr>
                                <tr>    
                                    <td style="padding-left:30px" align="right"><span class="label">合作层级：</span></td>
                                    <td><input class="sele" name="formMap['parterLevel']" id="parterLevel" readonly="readonly"/><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">经办人：</span></td>
                                    <td><input name="formMap['processUserName']" id="processUserName" onclick="selPerson();" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';"/><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">银行帐号：</span></td>
                                    <td><input type="text" name="formMap['bankAccount']" id="bankAccount" /><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:30px" align="right"><span class="label">开户行所在省：</span></td>
                                    <td><input class="sele" name="formMap['bankProvince']" id="bankProvince" readonly="readonly"/><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">开户行所在市：</span></td>
                                    <td><input class="sele" type="text" name="formMap['bankCity']" id="bankCity" readonly="readonly"/><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">收款方银行：</span></td>
                                    <td><input class="sele" name="formMap['bankReceive']" id="bankReceive" readonly="readonly"/><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:30px" align="right"><span class="label">开户行网点：</span></td>
                                    <td><input class="sele" name="formMap['bankNode']" id="bankNode" readonly="readonly"/><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">账户名称：</span></td>
                                    <td><input name="formMap['bankName']" id="bankName" /><span class="asterisk">*</span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">所属行业：</span></td>
                                    <td><input class="sele" name="formMap['profession']" id="profession" readonly="readonly"/></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:30px" align="right"><span class="label">公司联系人：</span></td>
                                    <td><input name="formMap['contact']" id="contact" /><span class="asterisk"></span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">联系电话：</span></td>
                                    <td><input name="formMap['tel']" id="tel" /><span class="asterisk"></span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                    <td style="padding-left:30px" align="right"><span class="label">办公地址：</span></td>
                                    <td><input name="formMap['officeAddress']" id="officeAddress" /><span class="asterisk"></span></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:30px" align="right"><span class="label">地区代码：</span></td>
                                    <td><input type="text" name="formMap['areaCode']" id="areaCode" /></td>
                                    <td><span class="errorImg"></span><span class="errorMsg"></span></td>   
                                    <td style="padding-left:30px" align="right"><span class="label">备注：</span></td>
                                    <td colspan="12"><textarea style="width:450px;" rows="2" name="formMap['remark']" id="remark" readonly="readonly"></textarea>
                                </tr>
                            </table>
                        </div>
                    </form>
		</fieldSet>
	</div>
	<div>
		<table style="width: 100%; margin-top: 20px;">
			<tr>
				<td align="center"><a class="fontClass" id="button-cancel" onclick="cancel()">返回</a></td>
			</tr>
		</table>
	</div>
</body>
</html>