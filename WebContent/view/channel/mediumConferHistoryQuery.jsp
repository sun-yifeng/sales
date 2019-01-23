<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<title>合作机构协议历史轨迹详情</title>
<%
String channelCode = request.getParameter("channelCode");
String historyId = request.getParameter("historyId");
String conferCode = request.getParameter("conferCode");
String conferId = request.getParameter("conferId");
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var historyId = '<%=historyId%>';
var conferCode = '<%=conferCode%>';
var conferId = '<%=conferId%>';

$(function(){
	$("#baseInfo").find("input").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#conferId").css({"width":"120px"});
	$("#extendConferCode").css({"width":"24px"});
	
	//给该隐藏域赋值，为查询协议信息和相关产品提供数据（外键）
	$('#conferNo_fk').val(conferCode);
	$('#historyId_fk').val(historyId);
	
	//加载日期控件
    $('#validDate').omCalendar({editable : false,disabled : true});
    $('#expireDate').omCalendar({editable : false,disabled : true});
    $('#signDate').omCalendar({editable : false,disabled : true});
    
    //授权下级机构
	$('#grantDept').omCombo({
		dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
    
    //协议类型
	$('#conferType').omCombo({
		dataSource : "<%=_path%>/common/queryConferType.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	/*******联系信息**********/
	Util.post(
		"<%=_path%>/mediumConfer/queryMediumConferHistory.do",$("#conferProductFrm").serialize(),
		function(data) {
			$("#baseInfo").find(":input").each(function(){
				$(this).val(data[0][$(this).attr("name")]);
			});
			var vDate = new Date(data[0].validDate);
			var eDate = new Date(data[0].expireDate);
			var sDate = new Date(data[0].signDate);
			//授权下级机构
			$('#grantDept').omCombo({value : data[0].grantDept});
			//协议类型
			$('#conferType').omCombo({value : data[0].conferType});
			$('#validDate').val($.omCalendar.formatDate(vDate, "yy-mm-dd"));
		    $('#expireDate').val($.omCalendar.formatDate(eDate, "yy-mm-dd"));
		    $('#signDate').val($.omCalendar.formatDate(sDate, "yy-mm-dd"));
	});
	
	/********产品信息**********/
	//初始化联系信息列表
	$('#tables').omGrid({
         limit:10,
         height : 250,
 		 singleSelect : true,
         showIndex : false,
         colModel : [ {header:"产品分类" , name:"productType",width:150, align : 'center'},
                   	  {header:"产品名称" , name:"productName",width:150, align : 'center'},
                      {header:"产品编码" , name:"productCode",width:150, align : 'center'},
                  	  {header:"手续费比例（%）",name:"commissionRate",width:100, align : 'center'},
                   	  {header:"特殊批改（%）",name:"endorseRate",width:100, align : 'center'}],
			dataSource : "<%=_path%>/conferProduct/queryConferProductsHistory.do?"+$("#conferProductFrm").serialize()
    });
	
	//初始化页面取消按钮
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
});

//取消操作
function cancel(){
	window.location.href = "mediumConferHistorys.jsp?conferId="+conferId+"&channelCode="+channelCode+"&conferCode="+conferCode;
}
</script>
</head>
<body>
	<div>
		<table class="navi-no-tab">
			<tr><td>合作机构协议历史轨迹详情</td></tr>
		</table>
	</div>
	<div>
		<form id="baseInfo">
			<fieldSet>
				<legend>基本信息</legend>
					<table>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">协议号：</span></td>
							<td><input type="text" name="conferId" id="conferId" readonly="readonly" />-<input type="text" name="extendConferCode" id="extendConferCode" readonly="readonly" /><input type="hidden" name="conferCode" id="conferCode" /></td>
							<!-- <td style="padding-left:30px" align="right"><span class="label">机构编码：</span></td>
							<td><input type="text" name="deptCode" id="deptCode" readonly="readonly" /></td> -->
							<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
							<td><input type="text" name="deptCname" id="deptCname" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">代理机构编码：</span></td>
							<td><input type="text" name="channelCode" id="channelCode" readonly="readonly" /></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">代理机构名称：</span></td>
							<td><input type="text" name="mediumCname" id="mediumCname" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">签订日期：</span></td>
							<td><input class="sele" type="text" name="signDate" id="signDate" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">生效日期：</span></td>
							<td><input class="sele" type="text" name="validDate" id="validDate" readonly="readonly" /></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">截止日期：</span></td>
							<td><input class="sele" type="text" name="expireDate" id="expireDate" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">结费周期：</span></td>
							<td><input type="text" name="calclatePeriod" id="calclatePeriod" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">授权下级机构：</span></td>
							<td><input class="sele" type="text" name="grantDept" id="grantDept" readonly="readonly" /></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">协议类型：</span></td>
							<td><input class="sele" type="text" name="conferType" id="conferType" readonly="readonly" /></td>
						</tr>
					</table>
			</fieldSet>
			<fieldSet>
				<legend>详细内容</legend>
				<textarea rows="5" cols="88" style="margin-left:80px;" name="remark" id="remark" readonly="readonly"></textarea>
			</fieldSet>
		</form>
	</div>
	<div>
		<fieldSet>
			<legend>产品手续费</legend>
			<table id="tables"></table>
			<form id="conferProductFrm">
				<input type="hidden" name="formMap['conferCode']" id="conferNo_fk" value="" />
				<input type="hidden" name="formMap['historyId']" id="historyId_fk" value="" />
			</form>
		</fieldSet>
	</div>
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-right:10px;padding-top:10px" align="center">
				<a class="om-button" id="button-cancel" onclick="cancel()">返回</a></td>
			</tr>
		</table>
	</div>
</body>
</html>