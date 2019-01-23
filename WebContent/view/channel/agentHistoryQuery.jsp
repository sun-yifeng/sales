<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>个人代理人历史轨迹详情</title>
<style>
html, body{ height:100%; margin:0px; padding:0px;}

input {
	height:18px;
	border: 1px solid #A1B9DF;
	vertical-align: middle;
}

input:focus {
	border: 1px solid #3A76C2;
}

.fontClass{
	font-size:12px;
	font-family: 微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun;
}
</style>
<%
String historyId = request.getParameter("historyId");
%>
<script type="text/javascript">
var historyId = '<%=historyId%>';

$(function(){
	$("#baseInfo").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	
	$('#channelCode_fk').val(historyId);
	
	/*******基本信息**********/
	//渠道大类
	$('#channelCategory').omCombo({
		dataSource : [{text:'代理业务',value:'19002'}],
        editable : false,
        readOnly : true
    });
	
	//渠道类型
	$('#channelType').omCombo({
		dataSource : [{text:'个人代理',value:'1900203'}],
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
    
    //身份证件类型
	$('#certifyType').omCombo({
		dataSource : "<%=_path%>/common/queryCertifyType.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : true,
		filterStrategy : 'anywhere',
        readOnly : true
    });
    
	//性别
	$('#sex').omCombo({
        dataSource : <%=Constant.getCombo("sex")%>,
        emptyText : '请选择',
        editable : false,
        readOnly : true
    });
    
    //学历
	$('#educatioin').omCombo({
		dataSource : "<%=_path%>/common/queryEducatioin.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : true,
		filterStrategy : 'anywhere',
        readOnly : true
    });
    
	//职业
	$('#title').omCombo({
		dataSource : "<%=_path%>/common/queryTitle.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : true,
		filterStrategy : 'anywhere',
        readOnly : true
    });
	
	//收款方银行
	$('#bankReceive').omCombo({
		dataSource : "<%=_path%>/common/queryBank.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : true,
		filterStrategy : 'anywhere',
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
	                	 $('#bankCity').omCombo({value:data[0].value});
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

	//下级单位可以查看
	$('#childDeptLook').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        editable : false,
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
	
	//是否有不良记录
	$('#mistakeFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        editable : false,
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
	
	//加载个人代理人详细信息
	Util.post(
		"<%=_path%>/agentHistory/queryAgentHistorys.do",
		$("#agentContectFrm").serialize(),
		function(data) {
			$("#baseInfo").find(":input").each(function(){
				if($(this).val() != null || $(this).val() != "")
				$(this).val(data[0][$(this).attr("id")]);
			});
			//渠道大类
			$('#channelCategory').omCombo({value : data[0].channelCategory});
			//渠道类别
			$('#channelType').omCombo({value : data[0].channelType});
			//是否理财险渠道
			$('#financeFlag').omCombo({value : data[0].financeFlag});
			//渠道特征
			$('#channelFeature').omCombo({value : data[0].channelFeature});
		    //身份证件类型
			$('#certifyType').omCombo({value : data[0].certifyType});
			//性别
			$('#sex').omCombo({value : data[0].sex});
		    //学历
			$('#educatioin').omCombo({value : data[0].educatioin});
			//职业
			$('#title').omCombo({value : data[0].title});
			//收款方银行
			$('#bankReceive').omCombo({value : data[0].bankReceive});
			//开户行所在省
			$('#bankProvince').omCombo({value : data[0].bankProvince});
			//开户行所在市
			$('#bankCity').omCombo({
				dataSource : "<%=_path%>/common/queryCity.do?province="+data[0].bankProvince,
		        value : data[0].bankCity
			});
			//下级单位可以查看
			$('#childDeptLook').omCombo({value : data[0].childDeptLook});
			//开户行网点
			$('#bankNode').omCombo({
				dataSource : "<%=_path%>/common/queryBankNode.do?bank="+data[0].bankReceive+"&city="+data[0].bankCity,
				value : data[0].bankNode
			});
			//是否有不良记录
			$('#mistakeFlag').omCombo({value : data[0].mistakeFlag});
			//业务线
			$('#businessLine').omCombo({value : data[0].businessLine});
    });
	
	//加载日期控件
    $('#licenseValidDate').omCalendar({editable : false,disabled : true});
    $('#licenseExpireDate').omCalendar({editable : false,disabled : true});
    $('#businessValidDate').omCalendar({editable : false,disabled : true});
    $('#businessExpireDate').omCalendar({editable : false,disabled : true});
    $('#qualificationValidDate').omCalendar({editable : false,disabled : true});
    $('#qualificationExpireDate').omCalendar({editable : false,disabled : true});
    $('#birthday').omCalendar({editable : false,disabled : true});
    
	//初始化页面取消按钮
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
});

//取消操作
function cancel(){
	window.location.href = "agentHistorys.jsp?channelCode="+$("#channelCode").val();
}
</script>
</head>
<body>
	<div>
		<table class="fontClass" style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
			<tr><td>个人代理人历史轨迹详情</td></tr>
		</table>
	</div>
	<div>
			<form id="baseInfo">
					<fieldSet style="margin-top: 10px;">
					<legend style="margin-left: 40px;">基本信息</legend>
						<table>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">个人代理人姓名：</span></td>
								<td><input name="formMap['channelName']" id="channelName"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">个人代理人编码：</span></td>
								<td><input type="text" name="formMap['channelCode']" id="channelCode" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
								<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['deptCname']" id="deptCname"/><span id="choose" name="choose" class="om-combo-trigger"></span></span><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span>
								<input type="hidden" name="formMap['deptCode']" id="deptCode" /></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">渠道大类：</span></td>
								<td><input class="sele" name="formMap['channelCategory']" id="channelCategory" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">渠道类型：</span></td>
								<td><input class="sele" name="formMap['channelType']" id="channelType" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">业务线：</span></td>
								<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span>
								<!--附件id字符串 --> 
								<input type="hidden" name="uploadId" id="uploadId" /></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">是否理财险渠道：</span></td>
								<td><input class="sele" type="text" name="formMap['financeFlag']" id="financeFlag"/></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">渠道系数：</span></td>
								<td><input name="formMap['channelRate']" id="channelRate" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">下级单位可以查看：</span></td>
								<td><input class="sele" type="text" name="formMap['childDeptLook']" id="childDeptLook" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">渠道特征：</span></td>
								<td><input class="sele" name="formMap['channelFeature']" id="channelFeature"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">身份证件类型：</span></td>
								<td><input class="sele" name="formMap['certifyType']" id="certifyType" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">证件号码：</span></td>
								<td><input name="formMap['certifyNo']" id="certifyNo"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<!-- 按监管要求：资格证号、有效期自、有效期至、展业证号、有效期有效期自、有效期至。这六项可以删除（如暂时无法删除，请均修改为非必录项） 20150930 -->
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">资格证号：</span></td>
								<td><input name="formMap['licenseNo']" id="licenseNo" /><span id="spanLicenseNo" style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
								<td><input class="sele" name="formMap['licenseValidDate']" id="licenseValidDate" onblur="formatDate(this);"/><span id="spanLicenseValidDate" style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
								<td><input class="sele" name="formMap['licenseExpireDate']" id="licenseExpireDate" onblur="formatDate(this);"/><span id="spanLicenseExpireDate" style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">展业证号：</span></td>
								<td><input name="formMap['businessNo']" id="businessNo"  /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
								<td><input class="sele" name="formMap['businessValidDate']" id="businessValidDate" onblur="formatDate(this);"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
								<td><input class="sele" name="formMap['businessExpireDate']" id="businessExpireDate" onblur="formatDate(this);"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">执业证号：</span></td>
								<td><input name="formMap['qualificationNo']" id="qualificationNo" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
								<td><input class="sele" name="formMap['qualificationValidDate']" id="qualificationValidDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
								<td><input class="sele" name="formMap['qualificationExpireDate']" id="qualificationExpireDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">代理合同编码：</span></td>
								<td><input name="formMap['contractNo']" id="contractNo" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">手机：</span></td>
								<td><input type="text" name="formMap['mobile']" id="mobile" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<!-- <td style="padding-left:30px" align="right"><span class="label">机构部门编码：</span></td>
								<td><input name="formMap['deptCode']" id="deptCode" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td> -->
								<td style="padding-left:30px" align="right"><span class="label">电话号码：</span></td>
								<td><input type="text" name="formMap['tel']" id="tel" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">E-mail：</span></td>
								<td><input name="formMap['email']" id="email" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">传真：</span></td>
								<td><input type="text" name="formMap['fax']" id="fax" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">通讯地址：</span></td>
								<td><input name="formMap['adderss']" id="adderss" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">性别：</span></td>
								<td><input class="sele" name="formMap['sex']" id="sex" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">邮编：</span></td>
								<td><input type="text" name="formMap['postCode']" id="postCode" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">出生年月：</span></td>
								<td><input class="sele" name="formMap['birthday']" id="birthday" onblur="formatDate(this);"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">学历：</span></td>
								<td><input class="sele" name="formMap['educatioin']" id="educatioin" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">职业：</span></td>
								<td><input class="sele" type="text" name="formMap['title']" id="title" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">职务：</span></td>
								<td><input name="formMap['duty']" id="duty" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">是否有不良记录：</span></td>
								<td><input class="sele" name="formMap['mistakeFlag']" id="mistakeFlag" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">不良记录：</span></td>
								<td><input type="text" name="formMap['mistakeContent']" id="mistakeContent" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">备注：</span></td>
								<td colspan="4">
								   <textarea rows="2" style="width:97%;" name="formMap['remark']" id="remark"></textarea>
								   <input type="hidden" name="agentContectJsonStr" id="agentContectJsonStr" />
								</td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
						</table>
				</fieldSet>
				<fieldSet style="margin-top: 10px;">
					<legend style="margin-left: 40px;">账户信息</legend>
					<table>
					<tr>
						<td style="padding-left:70px" align="right"><span class="label">银行帐号：</span></td>
						<td><input type="text" name="formMap['bankAccount']" id="bankAccount" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:60px" align="right"><span class="label">账户名称：</span></td>
						<td><input name="formMap['bankName']" id="bankName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:60px" align="right"><span class="label">开户行所在省：</span></td>
						<td><input class="sele" name="formMap['bankProvince']" id="bankProvince" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">开户行所在市：</span></td>
						<td><input class="sele" type="text" name="formMap['bankCity']" id="bankCity" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">收款方银行：</span></td>
						<td><input class="sele" name="formMap['bankReceive']" id="bankReceive" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">开户行名称：</span></td>
						<td><input class="sele" name="formMap['bankNode']" id="bankNode" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					</table>
				</fieldSet>
			</form>
	</div>
	<div>
		<form id="agentContectFrm">
			<input type="hidden" name="formMap['historyId']" id="channelCode_fk" value="" />
		</form>
		<table style="width: 100%">
			<tr>
				<td style="padding-right:20px;padding-top:10px" align="center">
				<a class="fontClass" id="button-cancel" onclick="cancel()">返回</a></td>
			</tr>
		</table>
	</div>
</body>
</html>