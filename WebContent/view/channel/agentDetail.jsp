<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<style type="text/css">
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<title>个人代理人详情</title>
<%
String channelCode = request.getParameter("channelCode");
String tabFlag = request.getParameter("flag");
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var tabFlag = '<%=tabFlag%>';

$(function(){
	$("#baseInfo").find("input[name^='formMap']").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	
	//给该隐藏域赋值，为查询个人代理人和相关附件信息提供数据（外键）
	$('#channelCode_fk').val(channelCode);
	//给联系人增加个人代理人编码
	$('#contactCode_fk').val(channelCode);
	
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
		dataSource : "<%=_path%>/agent/getAgentEditBusinessline.do?channelCode="+channelCode,
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	//加载个人代理人详细信息
	Util.post(
		"<%=_path%>/agent/queryAgents.do",
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
    

	//加载个人代理人附件信息
	Util.post(
		"<%=_path%>/upload/queryUploadByMainId.do?mainId="+channelCode+"&module=03",
		"",
		function(data) {
	 			var sysUrl = "http://ecmp.sinosafe.com.cn:8080/Interface_Cluster/FileShowAction?SystemCode=XSZC01&FunctionCode=XSZC0102&OrgCode=01010000&UserCode=100052692&BatchFlg=0&AuthorizCode=1111&BusinessCode=" + data[0].uploadId;
				 $('#imgSys').attr("href",sysUrl);
		}
	);
     
	//初始化页面取消按钮
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});

	//==============================联系人处理开始=============================================
	  //联系信息
		var tabHead = 0 || [ {header:"是否同步核心<br/>(只有一条可选'是')" , name:"getFlag",width:100, align:'center',renderer:getFlagRenderer},
		                 {header:"联系人",name:"contact",width:80, align:'center'},
		               	 {header:"职务",name:"title",width:80, align:'center'},
		              	 {header:"手机",name:"mobile",width:105, align:'center',},
		              	 {header:"电话号码",name:"tel",width:105, align:'center'},
		              	 {header:"E-mail",name:"email",width:155, align:'center'},
		              	 {header:"传真",name:"fax",width:105, align:'center'},
		              	 {header:"地址", name:"addresss",width:150, align:'center'},
		               	 {header:"邮政编码", name:"post",width:80, align:'center'},
		               	 {header:"短信通<br/>知代理人", name:"msgCar",width:80, align:'center',renderer:msgCarRenderer},
		               	 {header:"我司联系<br/>人手机",name:"companyPhone",width:105, align:'center',editable:true},
		             	 {header:"短信通知<br/>我司联系人",name:"isSendCmpnycontact",width:80, align:'center',renderer:isSendCmpnycontactRenderer},
		             	 {header:"短信通知<br/>协作人",name:"isSendTrueagt",width:80, align:'center',renderer:isSendTrueagtRenderer},
		             	 {header:"短信中代理<br/>人信息来源",name:"agtinfoSource",width:120, align:'center',renderer:agtinfoSourceRenderer},
		             	 {header:"备注", name:"remark",width:80}
		             	];	
				/*
				 * 功能：总公司_渠道管理岗_市场开发，总公司_室主任、系统管理员角色   只有这三个角色可见“是否同步到核心”的开关并且操作
				 * 作者：sunyf
				 * 日期：2015-04-20
				 */ 
				var contactRole = 'headDeptChannel,headDeptDirector,subDeptMangerNew,xszcAdmin'; 
				$.ajax({url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName="+contactRole, type:"post", async:false, dataType:"JSON", success:function(data){
				    if(!data){tabHead.splice(0, 1);} 
				}}); 
			
				 //联系信息
				$('#tables').omGrid({
			     limit:0,
			     height:200,
				   singleSelect:true,
				   showIndex:false,
			     autoFit:false,
			     colModel:tabHead,
			     width:'fit',
				   dataSource:"<%=_path%>/mediumContect/queryMediumContect.do?"+ $("#agentContectFrm").serialize(),
						});

		function getFlagRenderer(value) {
			if ("1" === value) {
				return "<span>是</span>";
			} else if ("0" === value) {
				return "<span>否</span>";
			} else {
				return "";
			}
		}
		function msgCarRenderer(value) {
			if ("1" === value) {
				return "<span>是</span>";
			} else if ("0" === value) {
				return "<span>否</span>";
			} else {
				return "";
			}
		}
		function msgCustomerRenderer(value) {
			if ("1" === value) {
				return "<span>是</span>";
			} else if ("0" === value) {
				return "<span>否</span>";
			} else {
				return "";
			}
		}
		function isSendTrueagtRenderer(value) {
			if ("Y" === value) {
				return "<span>发送</span>";
			} else if ("G" === value) {
				return "<span>发送并屏蔽代理人</span>";
			} else if ("N" === value) {
				return "<span>不发送</span>";
			} else {
				return "";
			}
		}
		function isSendCmpnycontactRenderer(value) {
			if ("Y" === value) {
				return "<span>发送</span>";
			} else if ("N" === value) {
				return "<span>不发送</span>";
			} else {
				return "";
			}
		}
		function agtinfoSourceRenderer(value) {
			if ("1" === value) {
				return "<span>从协作人提取</span>";
			} else if ("0" === value) {
				return "<span>从代理人提取</span>";
			} else {
				return "";
			}
		}
		//==============================联系人处理结束=============================================

	});

	/**
	 * 文件上传下载通用方法（异步获取数据）
	 */
	function getImg(domId, data) {
		if (data != '' && data != undefined) {
			$(domId).haImg({
				title : '个人代理人证件',
				modelCode : 'XSZC010103',
				mainBillNo : data.mainId,
				seriesNo : data.uploadId,
				srcUrl : '${sessionScope.imgUrl}',
				operateEmp : data.updatedUser,
				operateCode : 'none'
			});
		} else {
			$(domId).haImg({
				title : '个人代理人证件',
				modelCode : 'XSZC010103',
				mainBillNo : "",
				seriesNo : '未生成',
				srcUrl : '${sessionScope.imgUrl}',
				//operateEmp : operateEmp,
				operateCode : 'none'
			});
		}
	}

	//取消操作
	function cancel() {
		window.location.href = "agent.jsp";
	}
</script>
</head>
<body>
	<div>
		<table class="navi-no-tab">
			<tr><td>个人代理人详情</td></tr>
		</table>
	</div>
	<div>
	<form id="baseInfo">
		<fieldSet>
			<legend>基本信息</legend>
				<table class="fontClass">
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">个人代理人姓名：</span></td>
						<td><input name="formMap['channelName']" id="channelName" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">个人代理人编码：</span></td>
						<td><input type="text" name="formMap['channelCode']" id="channelCode" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
						<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['deptCname']" id="deptCname" readonly="readonly" /><span id="choose" name="choose" class="om-combo-trigger"></span></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">渠道大类：</span></td>
						<td><input class="sele" name="formMap['channelCategory']" id="channelCategory" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">渠道类型：</span></td>
						<td><input class="sele" name="formMap['channelType']" id="channelType" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">业务线：</span></td>
						<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">是否理财险渠道：</span></td>
						<td><input class="sele" type="text" name="formMap['financeFlag']" id="financeFlag" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">渠道系数：</span></td>
						<td><input name="formMap['channelRate']" id="channelRate" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">下级单位可以查看：</span></td>
						<td><input class="sele" type="text" name="formMap['childDeptLook']" id="childDeptLook" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">渠道特征：</span></td>
						<td><input class="sele" name="formMap['channelFeature']" id="channelFeature" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">身份证件类型：</span></td>
						<td><input class="sele" name="formMap['certifyType']" id="certifyType" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">证件号码：</span></td>
						<td><input name="formMap['certifyNo']" id="certifyNo" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">资格证号：</span></td>
						<td><input name="formMap['licenseNo']" id="licenseNo" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
						<td><input class="sele" name="formMap['licenseValidDate']" id="licenseValidDate" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
						<td><input class="sele" name="formMap['licenseExpireDate']" id="licenseExpireDate" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">展业证号：</span></td>
						<td><input name="formMap['businessNo']" id="businessNo" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
						<td><input class="sele" name="formMap['businessValidDate']" id="businessValidDate" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
						<td><input class="sele" name="formMap['businessExpireDate']" id="businessExpireDate" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">执业证号：</span></td>
						<td><input name="formMap['qualificationNo']" id="qualificationNo" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
						<td><input class="sele" name="formMap['qualificationValidDate']" id="qualificationValidDate" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
						<td><input class="sele" name="formMap['qualificationExpireDate']" id="qualificationExpireDate" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">代理合同编码：</span></td>
						<td><input name="formMap['contractNo']" id="contractNo" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">手机：</span></td>
						<td><input type="text" name="formMap['mobile']" id="mobile" readonly="readonly" /></td>
						<!-- <td style="padding-left:30px" align="right"><span class="label">机构部门编码：</span></td>
						<td><input name="formMap['deptCode']" id="deptCode" readonly="readonly" /></td> -->
						<td style="padding-left:30px" align="right"><span class="label">电话号码：</span></td>
						<td><input type="text" name="formMap['tel']" id="tel" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">E-mail：</span></td>
						<td><input name="formMap['email']" id="email" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">传真：</span></td>
						<td><input type="text" name="formMap['fax']" id="fax" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">通讯地址：</span></td>
						<td><input name="formMap['adderss']" id="adderss" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">性别：</span></td>
						<td><input class="sele" name="formMap['sex']" id="sex" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">邮编：</span></td>
						<td><input type="text" name="formMap['postCode']" id="postCode" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">出生年月：</span></td>
						<td><input class="sele" name="formMap['birthday']" id="birthday" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">学历：</span></td>
						<td><input class="sele" name="formMap['educatioin']" id="educatioin" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">职业：</span></td>
						<td><input class="sele" type="text" name="formMap['title']" id="title" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">职务：</span></td>
						<td><input name="formMap['duty']" id="duty" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">是否有不良记录：</span></td>
						<td><input class="sele" name="formMap['mistakeFlag']" id="mistakeFlag" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">不良记录：</span></td>
						<td><input type="text" name="formMap['mistakeContent']" id="mistakeContent" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">推荐人：</span></td>
						<td><input type="text" name="formMap['recommenderName']" id="recommenderName" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">备注：</span></td>
						<td colspan="3"><textarea class="fontClass" rows="2" style="width:99%;" name="formMap['remark']" id="remark" readonly="readonly"></textarea></td>
					</tr>
				</table>
				</fieldSet>
			<fieldSet>
			<legend>账户信息</legend>
			<table>
			        <tr>
						<td style="padding-left:70px" align="right"><span class="label">银行帐号：</span></td>
						<td><input type="text" name="formMap['bankAccount']" id="bankAccount" readonly="readonly" /></td>
						<td style="padding-left:60px" align="right"><span class="label">账户名称：</span></td>
						<td><input name="formMap['bankName']" id="bankName" readonly="readonly" /></td>
						<td style="padding-left:60px" align="right"><span class="label">开户行所在省：</span></td>
						<td><input class="sele" name="formMap['bankProvince']" id="bankProvince" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">开户行所在市：</span></td>
						<td><input class="sele" type="text" name="formMap['bankCity']" id="bankCity" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">收款方银行：</span></td>
						<td><input class="sele" name="formMap['bankReceive']" id="bankReceive" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">开户行名称：</span></td>
						<td><input class="sele" name="formMap['bankNode']" id="bankNode" readonly="readonly" /></td>
					</tr>
			</table>
			</fieldSet>
	</form>
	</div>
	<!-- 联系人列表 -->
			<div>
				<fieldSet>
					<legend>联系信息</legend>
					<table id="tables"></table>
					<form id="agentContectFrm">
						<input type="hidden" name="formMap['channelCode']" id="contactCode_fk" value="" />
					</form>
				</fieldSet>
			</div>
	<!-- 附件上传框 -->
<!-- 	<div id="program-upload-download" style="height:180px;"> -->
<!-- 		<form id="agentContectFrm"> -->
<!-- 			<input type="hidden" name="formMap['channelCode']" id="channelCode_fk" value="" /> -->
<!-- 		</form> -->
<!-- 	</div> -->
  <!-- 新影像系统bgn -->
  <div>
    <fieldSet>
      <legend>影像资料</legend>
      <div style="margin-left: 20px;margin-bottom: 10px;">
        <a href='#' id="imgSys" target="_blank">个代证件</a>
      </div>
    </fieldSet>
  </div>
  <!-- 新影像系统end -->
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-right:20px;padding-top:80px" align="center">
				<a class="fontClass" id="button-cancel" onclick="cancel()">返回</a></td>
			</tr>
		</table>
	</div>
</body>
</html>