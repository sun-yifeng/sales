<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
*{padding:0;marging:0}
html, body{ height:100%; margin:0px; padding:0px;}
.navi-tab {border: solid #d0d0d0 1px; width: 100%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px;}
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<title>远程出单点详情</title>
<%
String channelCode = request.getParameter("channelCode");
String nodeCode = request.getParameter("nodeCode");
String deptCode = request.getParameter("deptCode");
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var nodeCode = '<%=nodeCode%>';
var deptCode = '<%=deptCode%>';

$(function(){
	$("#baseInfo").find("input").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	$("#targetPremium").css({"width":"118px"});
	
	//给该隐藏域赋值，为查询远程出单账号信息和相关维护人提供数据（外键）
	$('#nodeCode_fk').val(nodeCode);
	
	//是否远程出单点
	$('#remote').omCombo({
        dataSource : [ {text : '请选择', value : ''}, 
                       {text : '是', value : '1'}, 
                       {text : '否', value : '0'}],
        emptyText : '请选择',
        editable : false,
        readOnly : true
    });

	//合作渠道类型
	$('#channelPartnerType').omCombo({
		dataSource : "<%=_path%>/common/queryChannelPartnerType.do",
		optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	/*******出单点信息**********/
	Util.post(
		"<%=_path%>/mediumNode/queryMediumNodes.do",$("#channelMaintainFrm").serialize(),
		function(data) {
			$("#baseInfo").find("input").each(function(){
				$(this).val(data[0][$(this).attr("name")]);
			});
			//是否远程出单点
			$('#remote').omCombo({value : data[0].remote});
			//合作渠道类型
			$('#channelPartnerType').omCombo({value : data[0].channelPartnerType});
	});

	//初始化出单账号信息列表
	$('#accountTables').omGrid({
         limit:0,
         height : 160,
 		 singleSelect : true,
 		 showIndex : false,
         colModel : [ {header:"是否我司员工" , name:"isOwnStaff",width:100, align : 'center',renderer:isOwnStaffRenderer},
                      {header:"出单员",name:"issuingerCode",width:100, align : 'center'},
                      {header:"工号",name:"employCode",width:100, align : 'center'},
                      {header:"出单账号",name:"account",width:150, align : 'center'},
                      {header:"vpn账号" , name:"vpnNo",width:150, align : 'center'},
                      {header:"设立日期" , name:"setDate",width:120, align : 'center'},
                  	  {header:"备注1",name:"remark1",width:150},
                   	  {header:"备注2",name:"remark2",width:150}],
			dataSource : "<%=_path%>/mediumNode/queryChannelMediumNodeAccount.do?"+$("#channelMaintainFrm").serialize()
    });
	function isOwnStaffRenderer(value){
        if("1" === value){
            return "<span>是</span>";
        }else if("0" === value){
            return "<span>否</span>";
        }else{
            return "";
        }
    }
	
	//初始化维护人信息列表
	$('#tables').omGrid({
         limit:0,
         height : 190,
 		 singleSelect : true,
         showIndex : false,
         colModel : [ {header:"维护人姓名",name:"salesmanCname",width:150, align : 'center'},
                      {header:"维护人代码" , name:"maintenCode",width:200, align : 'center'},
                  	  {header:"电话",name:"tel",width:150, align : 'center'},
                   	  {header:"邮箱",name:"salesmanCode",width:200, align : 'center'},
                  	  {header:"业务占比(%)",name:"businessScale",width:100, align : 'center'}],
			dataSource : "<%=_path%>/channelMaintain/queryChannelMaintain.do?"+$("#channelMaintainFrm").serialize()
    });
	
	//初始化页面保存、取消按钮
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
});

//取消操作
function cancel(){
	window.location.href = "mediumNode.jsp?flag=1&channelCode="+channelCode;
}
</script>
</head>
<body>
	<div>
		<table class="navi-no-tab">
			<tr><td>远程出单点详情</td></tr>
		</table>
	</div>
	<div>
		<fieldSet>
			<legend>出单点信息</legend>
			<form id="baseInfo">
				<table>
					<tr>
						<!-- <td style="padding-left:30px" align="right"><span class="label">机构代码：</span></td>
						<td><input type="text" name="deptCode" id="deptCode" readonly="readonly" /></td> -->
						<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
						<td><input type="text" name="deptCname" id="deptCname" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">代理机构代码：</span></td>
						<td><input type="text" name="channelCode" id="channelCode" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">代理机构名称：</span></td>
						<td><input type="text" name="mediumCname" id="mediumCname" readonly="readonly" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">远程出单点名称：</span></td>
						<td><input type="text" name="nodeName" id="mediumNodeName" readonly="readonly" /></td>
						<!-- <td style="padding-left:30px" align="right"><span class="label">远程出单点代码：</span></td>
						<td><input type="text" name="nodeCode" id="nodeCode" readonly="readonly" /></td> -->
						<td style="padding-left:30px" align="right"><span class="label">保费目标：</span></td>
						<td><input type="text" name="targetPremium" id="targetPremium" readonly="readonly" />(万元)</td>
						<td style="padding-left:30px" align="right"><span class="label">出单点地址：</span></td>
						<td><input type="text" name="address" id="address" readonly="readonly" /></td>
					</tr>
					<tr>
						<!-- <td style="padding-left:30px" align="right"><span class="label">是否远程出单点：</span></td>
						<td><input class="sele" type="text" name="remote" id="remote" readonly="readonly" /></td> -->
						<td style="padding-left:30px" align="right"><span class="label">联系人：</span></td>
						<td><input type="text" name="contact" id="contact" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">手机：</span></td>
						<td><input type="text" name="mobile" id="mobile" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">电话号码：</span></td>
						<td><input type="text" name="phone" id="phone" readonly="readonly" /></td>
					</tr>
					<tr>
						<!-- <td style="padding-left:30px" align="right"><span class="label">出单点名称：</span></td>
						<td><input type="text" name="name" id="tableName" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">出单账号：</span></td>
						<td><input type="text" name="account" id="account" readonly="readonly" /></td> -->
						<td style="padding-left:30px" align="right"><span class="label">邮箱：</span></td>
						<td><input type="text" name="email" id="email" readonly="readonly" /></td>
						<!-- <td style="padding-left:30px" align="right"><span class="label">vpn账号：</span></td>
						<td><input type="text" name="vpnNo" id="vpnNo" readonly="readonly" /></td>
						<td style="padding-left:30px" align="right"><span class="label">合作渠道类型：</span></td>
						<td><input class="sele" type="text" name="channelPartnerType" id="channelPartnerType" readonly="readonly" /></td> -->
					</tr>
				</table>
			</form>
		</fieldSet>
	</div>
	<!-- 出单账号信息 -->
	<div>
		<fieldSet>
			<legend>出单账号信息</legend>
			<table id="accountTables"></table>
		</fieldSet>
	</div>
	<!-- 维护人列表 -->
	<div>
		<fieldSet>
			<legend>维护人</legend>
			<table id="tables"></table>
			<form id="channelMaintainFrm">
				<input type="hidden" name="formMap['nodeCode']" id="nodeCode_fk" value="" />
				<input type="hidden" name="formMap['queryFlag']" value="yes" />
			</form>
		</fieldSet>
	</div>
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-right:30px;padding-top:10px" align="center">
				   <a class="fontClass" id="button-cancel" onclick="cancel()">返回</a>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>