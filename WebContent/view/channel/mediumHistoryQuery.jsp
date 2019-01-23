<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<title>合作机构历史轨迹详情</title>
<%
String historyId = request.getParameter("historyId");
%>
<script type="text/javascript">
var historyId = '<%=historyId%>';
$(function(){
	$("#baseInfo").find("input[name^='formMap']").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#mediumCode_fk").val(historyId);
	//是否协作人
	$('#supportFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        editable : false,
        emptyText : '请选择',
        readOnly : true
    });
	//合作层级
	$('#parterLevel').omCombo({
        dataSource : <%=Constant.getCombo("isParterLevel")%>,
        emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	//是否理财险渠道
	$('#financeFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	//渠道大类
	$('#channelCategory').omCombo({
		dataSource : "<%=_path%>/common/queryCategory.do",
		optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	//渠道类型
	$('#channelType').omCombo({
		optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	//渠道性质
	$('#channelProperty').omCombo({
		optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	//渠道属类
	$('#channelOwnType').omCombo({
		optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	//渠道特征
	$('#channelFeature').omCombo({
		dataSource : "<%=_path%>/common/queryChannelFeature.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	//开户行所在省
	$('#bankProvince').omCombo({
        dataSource : "<%=_path%>/common/queryProvince.do",
        onValueChange : function(target, newValue, oldValue, event) {
        	//清空市的所有选项
            $('#bankCity').omCombo("setData",[]);
            //清空银行网点中的所有选项
        	$('#bankNode').omCombo("setData",[]);
            if(newValue != ''){
            	$('#bankCity').omCombo({
	                 dataSource : "<%=_path%>/common/queryCity.do?province="+newValue,
	                 emptyText : '请选择'
	                 /* onSuccess:function(data, textStatus, event){
	                	 alert(data[0].value);
	                	 $('#bankCity').omCombo({value : data[0].value});
	                 } */
	            });
            }
        },optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
		filterStrategy : 'anywhere',
        readOnly : true
    });
	//开户行所在市
	$('#bankCity').omCombo({
		optionField : function(data, index) {
	        return data.text;
		},
		filterStrategy : 'anywhere',
		onValueChange : function(target, newValue, oldValue, event) {
            if(newValue != ''){
            	//清空银行网点中的所有选项
            	$('#bankNode').omCombo("setData",[]);
            	
            	var bankReceiveVal = $('#bankReceive').val();
            	if(bankReceiveVal != ''){
	            	$('#bankNode').omCombo({
		                 dataSource : "<%=_path%>/common/queryBankNode.do?city="+newValue+"&bank="+bankReceiveVal,
		                 emptyText : '请选择',
		                 listAutoWidth : true
		            });
            	}
            }
        },
        readOnly : true
	});
	//收款方银行
	$('#bankReceive').omCombo({
		dataSource : "<%=_path%>/common/queryBank.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
		onValueChange : function(target, newValue, oldValue, event) {
            if(newValue != ''){
            	//清空银行网点中的所有选项
            	$('#bankNode').omCombo("setData",[]);
            	
            	var bankCityVal = $('#bankCity').val();
            	if(bankCityVal != ''){
	            	$('#bankNode').omCombo({
		                 dataSource : "<%=_path%>/common/queryBankNode.do?bank="+newValue+"&city="+bankCityVal,
		                 emptyText : '请选择',
		                 listAutoWidth : true
		            });
            	}
            }
        },
        readOnly : true
    });
	//银行网点
	$("#bankNode").omCombo({
		optionField : function(data, index) {
	        return data.text;
		},
		filterStrategy : 'anywhere',
        readOnly : true
	});
	//业务线
	$('#businessLine').omCombo({
		dataSource : "<%=_path%>/common/queryBusinessLine.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	//国家地区
	$('#country').omCombo({
		dataSource : "<%=_path%>/common/queryCountry.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	//渠道层级
	$('#channelLevel').omCombo({
        dataSource : "<%=_path%>/common/queryChannelLevel.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	//所属行业
	$('#profession').omCombo({
		dataSource : "<%=_path%>/common/queryProfession.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	//是否有不良记录
	$('#mistakeFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	//下级单位可以查看
	$('#childDeptLook').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        emptyText : '请选择',
        editable : false,
        readOnly : true
    });

	//理财险保单标示
	$('#financePolicyFlag').omCombo({
		dataSource : "<%=_path%>/common/queryFinancePolicyFlag.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	/*******基本信息**********/
	//加载合作机构详细信息
	Util.post(
		"<%=_path%>/mediumHistory/queryMediumHistorys.do",
		$("#mediumContectFrm").serialize(),
		function(data) {
			$("#baseInfo").find(":input").each(function(){
				if($(this).val() != null || $(this).val() != "")
				$(this).val(data[0][$(this).attr("id")]);
			});
			//是否协作人
			$('#supportFlag').omCombo({value : data[0].supportFlag});
			//合作层级
			$('#parterLevel').omCombo({value : data[0].parterLevel});
			//是否理财险渠道
			$('#financeFlag').omCombo({value : data[0].financeFlag});
			//渠道大类
			$('#channelCategory').omCombo({value : data[0].channelCategory});
			//渠道类型
			$('#channelType').omCombo({
				dataSource : "<%=_path%>/common/queryProperty.do?parentCode="+data[0].channelCategory,
				value : data[0].channelType
			});
			//渠道性质
			$('#channelProperty').omCombo({
				dataSource : "<%=_path%>/common/queryProperty.do?parentCode="+data[0].channelType,
				value : data[0].channelProperty
			});
			//渠道属类
			$('#channelOwnType').omCombo({
				dataSource : "<%=_path%>/common/queryProperty.do?parentCode="+data[0].channelProperty,
				value : data[0].channelOwnType
			});
			//渠道特征
			$('#channelFeature').omCombo({value : data[0].channelFeature});
			//开户行所在省
			$('#bankProvince').omCombo({value : data[0].bankProvince});
			//开户行所在市
			$('#bankCity').omCombo({
				dataSource : "<%=_path%>/common/queryCity.do?province="+data[0].bankProvince,
				value : data[0].bankCity
			});
			//收款方银行
			$('#bankReceive').omCombo({value : data[0].bankReceive});
			//开户行网点
			$('#bankNode').omCombo({
				dataSource : "<%=_path%>/common/queryBankNode.do?bank="+data[0].bankReceive+"&city="+data[0].bankCity,
				value : data[0].bankNode
			});
			//业务线
			$('#businessLine').omCombo({value : data[0].businessLine});
			//国家地区
			$('#country').omCombo({value : data[0].country});
			//渠道层级
			$('#channelLevel').omCombo({value : data[0].channelLevel});
			//所属行业
			$('#profession').omCombo({value : data[0].profession});
			//是否有不良记录
			$('#mistakeFlag').omCombo({value : data[0].mistakeFlag});
			//下级单位可以查看
			$('#childDeptLook').omCombo({value : data[0].childDeptLook});
			//理财险保单标示
			$('#financePolicyFlag').omCombo({value : data[0].financePolicyFlag});
    });
	
	//加载日期控件
    $('#validDate').omCalendar({editable : false,disabled : true});
    $('#expireDate').omCalendar({editable : false,disabled : true});
    $('#signDate').omCalendar({editable : false,disabled : true});
	
	//初始化页面取消按钮
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
});

//取消操作
function cancel(){
	window.location.href = "mediumHistorys.jsp?channelCode="+$("#channelCode").val();
}
</script>
</head>
<body>
	<div>
		<table class="navi-no-tab">
			<tr><td>合作机构历史轨迹详情</td></tr>
		</table>
	</div>
	<div>
			<form id="baseInfo">
			<fieldSet>
			<legend>基本信息</legend>
				<table>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">合作机构名称：</span></td>
						<td><input name="formMap['mediumCname']" id="mediumCname" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">合作机构英文名称：</span></td>
						<td><input type="text" name="formMap['mediumEname']" id="mediumEname" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">合作机构编码：</span></td>
						<td><input type="text" name="formMap['channelCode']" id="channelCode" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">业务线：</span></td>
						<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
						<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['deptCname']" id="deptCname" readonly="readonly" /><span id="choose" name="choose" class="om-combo-trigger"></span></span></td>
						<!-- <td style="padding-left:30px" align="right"><span class="label">机构部门编码：</span></td>
						<td><input name="formMap['deptCode']" id="deptCode" readonly="readonly" /></td> -->
						<td style="padding-left:30px" align="right"><span class="label">经办人：</span></td>
						<td><input name="formMap['processUserCode']" id="processUserCode" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">渠道大类：</span></td>
						<td><input class="sele" name="formMap['channelCategory']" id="channelCategory" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">渠道类型：</span></td>
						<td><input class="sele" name="formMap['channelType']" id="channelType" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">渠道性质：</span></td>
						<td><input class="sele" name="formMap['channelProperty']" id="channelProperty" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">渠道属类：</span></td>
						<td><input class="sele" name="formMap['channelOwnType']" id="channelOwnType" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">上级渠道：</span></td>
						<td><input name="formMap['parentChannelCode']" id="parentChannelCode" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">合作层级：</span></td>
						<td><input class="sele" name="formMap['parterLevel']" id="parterLevel" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">经营许可证：</span></td>
						<td><input name="formMap['licence']" id="licence" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">办公地址：</span></td>
						<td><input name="formMap['officeAddress']" id="officeAddress" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">注册地址：</span></td>
						<td><input name="formMap['registerAddress']" id="registerAddress" readonly="readonly" /></td>
						<!-- <td style="padding-left:30px" align="right"><span class="label">经办部门编码：</span></td>
						<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['processDeptCode']" id="processDeptCode" readonly="readonly" /><span id="processDeptChoose" name="processDeptChoose" class="om-combo-trigger"></span></span></td> -->
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">许可证颁发时间：</span></td>
						<td><input class="sele" name="formMap['validDate']" id="validDate" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">许可证有效时间至：</span></td>
						<td><input class="sele" name="formMap['expireDate']" id="expireDate" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">与合作机构签约时间：</span></td>
						<td><input class="sele" type="text" name="formMap['signDate']" id="signDate" readonly="readonly" /></td>
					</tr>
					<!-- <tr>
						<td style="padding-left:30px" align="right"><span class="label">渠道联系人：</span></td>
						<td><input name="formMap['contact']" id="contact" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">联系电话：</span></td>
						<td><input type="text" name="formMap['tel']" id="tel" readonly="readonly" /></td>
					</tr> -->
					<tr>
						<!-- <td style="padding-left:30px" align="right"><span class="label">上级合作机构名称：</span></td>
						<td><input name="formMap['parentMediumName']" id="parentMediumName" readonly="readonly" /></td> -->
						<td style="padding-left:30px" align="right"><span class="label">是否协作人：</span></td>
						<td><input class="sele" name="formMap['supportFlag']" id="supportFlag" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">协议代理人：</span></td>
						<td><input name="formMap['agentCode']" id="agentCode" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">下级单位可以查看：</span></td>
						<td><input class="sele" type="text" name="formMap['childDeptLook']" id="childDeptLook" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">是否有不良记录：</span></td>
						<td><input class="sele" name="formMap['mistakeFlag']" id="mistakeFlag" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">不良记录：</span></td>
						<td><input type="text" name="formMap['mistakeContent']" id="mistakeContent" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">渠道系数：</span></td>
						<td><input name="formMap['channelRate']" id="channelRate" readonly="readonly" /></td>
						<!-- <td style="padding-left:30px" align="right"><span class="label">出单点名称：</span></td>
						<td><input name="formMap['salePolicyName']" id="salePolicyName" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">出单点地址：</span></td>
						<td><input name="formMap['salePolicyAddress']" id="salePolicyAddress" readonly="readonly" /></td> -->
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">内部码：</span></td>
						<td><input type="text" name="formMap['innerCode']" id="innerCode" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">渠道外部码：</span></td>
						<td><input name="formMap['channelOuterCode']" id="channelOuterCode" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">渠道代码：</span></td>
						<td><input name="formMap['channelExtendCode']" id="channelExtendCode" readonly="readonly" /></td>
					</tr>
					<tr>
						
						<td style="padding-left:30px" align="right"><span class="label">渠道层级：</span></td>
						<td><input class="sele" name="formMap['channelLevel']" id="channelLevel" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">所属行业：</span></td>
						<td><input class="sele" name="formMap['profession']" id="profession" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">法人代表：</span></td>
						<td><input type="text" name="formMap['legal']" id="legal" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">网站地址：</span></td>
						<td><input name="formMap['website']" id="website" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">国家地区：</span></td>
						<td><input class="sele" type="text" name="formMap['country']" id="country" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">地区代码：</span></td>
						<td><input type="text" name="formMap['areaCode']" id="areaCode" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">省、市代码：</span></td>
						<td><input name="formMap['cityCode']" id="cityCode" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">是否理财险渠道：</span></td>
						<td><input class="sele" type="text" name="formMap['financeFlag']" id="financeFlag" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">理财险保单标识：</span></td>
						<td><input class="sele" type="text" name="formMap['financePolicyFlag']" id="financePolicyFlag" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">组织机构代码：</span></td>
						<td><input name="formMap['cAgentorgCde']" id="cAgentorgCde" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">数字证书编码：</span></td>
						<td><input type="text" name="formMap['cUkeyCde']" id="cUkeyCde" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">渠道特征：</span></td>
						<td><input class="sele" name="formMap['channelFeature']" id="channelFeature" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">车险平台备案代码：</span></td>
						<td><input name="formMap['cheatCode']" id="cheatCode"  readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">备注：</span></td>
						<td colspan="3"><textarea class="fontClass" rows="2" style="width:99%;" name="formMap['remark']" id="remark" readonly="readonly" ></textarea></td>
					</tr>
				</table>
		     </fieldSet>
		     <fieldSet>
			<legend>账户信息</legend>
			<table>
			       <tr>
							<td style="padding-left:80px" align="right"><span class="label">银行帐号：</span></td>
							<td><input type="text" name="formMap['bankAccount']" id="bankAccount"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:80px" align="right"><span class="label">账户名称：</span></td>
							<td><input name="formMap['bankName']" id="bankName"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:65px" align="right"><span class="label">开户行所在省：</span></td>
							<td><input class="sele" name="formMap['bankProvince']" id="bankProvince"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">开户行所在市：</span></td>
							<td><input class="sele" type="text" name="formMap['bankCity']" id="bankCity"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">收款方银行：</span></td>
							<td><input class="sele" name="formMap['bankReceive']" id="bankReceive"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">开户行网点：</span></td>
							<td><input class="sele" name="formMap['bankNode']" id="bankNode" readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
			</table>
			</fieldSet>
			<!-- <fieldSet>
			            <legend>纳税信息</legend>
			            <table>
			            <tr>
							<td style="padding-left:70px" align="right"><span class="label">纳税人名称：</span></td>
							<td><input type="text" name="formMap['taxpayerName']" id="taxpayerName"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:50px" align="right"><span class="label">纳税人识别号：</span></td>
							<td><input name="formMap['taxpayerIdNum']" id="taxpayerIdNum"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:80px" align="right"><span class="label">纳税人资质：</span></td>
							<td><input class="sele" name="formMap['taxpayerQualify']" id="taxpayerQualify"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">发票开具类型：</span></td>
							<td><input class="sele" type="text" name="formMap['invoiceType']" id="invoiceType"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">税率：</span></td>
							<td><input class="sele" name="formMap['taxRate']" id="taxRate"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
			            </table>
			  </fieldSet> -->
		</form>
	</div>
	<div>
		<form id="mediumContectFrm">
			<input type="hidden" name="formMap['historyId']" id="mediumCode_fk" value="" />
		</form>
		<table style="width: 100%;">
			<tr>
				<td style="padding-right:10px;padding-top:10px;" align="center">
				<a id="button-cancel" onclick="cancel()">返回</a></td>
			</tr>
		</table>
	</div>
</body>
</html>