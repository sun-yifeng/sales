<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>渠道预警记录</title>
<style>html, body{width: 100%; height:100%; padding: 0; margin: 0; overflow: hidden;}</style>
<script type="text/javascript">
$(function(){
	// 整体样式
	$("#filterFrm").find("input").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//二级机构
	$('#deptCode').omCombo({
        dataSource :  "<%=_path%>/department/queryDepartmentByUserCode.do?random="+Math.random(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2){
        		$('#deptCode').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
        },
        emptyText : '请选择'
    });
	//业务线
	$("#bizLine").omCombo({
		dataSource: <%=getCombo("bizLine")%>,
		emptyText: '请选择'
	});
	//邮件类型
	$("#channelMailType").omCombo({
		dataSource: <%=getCombo("channelMailType")%>,
		emptyText: '请选择',
		listAutoWidth:true
	});
	//查询面板
	$("#search-panel").omPanel({
    	title : "销售渠道管理  > 渠道邮件预警记录",
    	collapsible:true,
    	collapsed:false
    });
	$('#startDate').omCalendar();
	$('#endDate').omCalendar();
	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	//列表高度
	var bdnum = $("body").offset().top + $("body").outerHeight();
  	var btnum = $("#search-panel").offset().top + $("#search-panel").outerHeight();
	//分页表格
	$("#tables").omGrid({
      	 limit : 100,
        height : bdnum - btnum,
								colModel:tabHand,
								showIndex : true,
        singleSelect : true,
        method : 'POST',
        onRowDblClick:function(rowIndex,rowData,event){
        	showModelDialog();
        	var content = rowData.mailContent.split("||");
        	var expire_date=content[0];
        	var expire_day=content[1];
        	if(rowData.copyMail==""||rowData.copyMail==undefined){
        		rowData.copyMail="(没有抄送人员)";
        	}
        	$("#dialog_modal").html(rowData.taskType+" - ["+rowData.channelCode+rowData.channelName+"]"+"</br>"
        	 +	"收件人:"+	rowData.recipients+"</br>"
        	 +"抄送:"+rowData.copyMail+"</br>"
        	 +"渠道编码:"+rowData.channelCode+"</br>"
        	 +"渠道名称:"+rowData.channelName+"</br>"
        	 +"预警信息:该渠道的合作协议即将于"+expire_date+"("+expire_day+"天后)到期，请尽快通知相关人员与合作渠道联系，取得新的资质证明并在系统中重新录入期限。"+"</br>"
        	 +"预警报告:阳光总在风雨后，让我们携手为美好的明天加油！！！</br>"
        	 +"报告日期:"+rowData.sendDate+"</br>"
        	 +"本邮件为销售支持平台自动发送，请勿回复！"
        	);
        }
	});
	//加载初始数据
	setTimeout("query()",800);
	//加载模态窗口
	$( "#dialog_modal").omDialog({
		autoOpen: false,
		width:700,
		height: 250,
		modal: true
	});
});
//表头
var tabHand = [
    [
		{header:"经办部门代码",name:"deptCode",width:80},
		{header:"经办部门名称",name:"deptName",width:100},
		{header:"业务线",name:"lineCode",width:100,align:'center'},
		{header:"渠道编码",name:"channelCode",width:120},
		{header:"渠道名称",name:"channelName",width:200},
		{header:"预警邮件类型",name:"taskType",width:200},
	 {header:"邮件发送日期",name:"sendDate",width:150,align:'center'},
		{header:"邮件接收人",name:"recipients",width:200},
		{header:"邮件抄送人",name:"copyMail",width:200},
		{header:"发送状态",name:"sendStatus",width:100,align:'center',renderer : function(value, rowData , rowIndex) {
			if(value==1){
				return "<font color=green>发送成功</font>";
			}else if(value==2){
				return "<font color=red>发送失败,存在无效邮箱</font>";
			}
		}},
		{header:"邮件发送IP",name:"sendIp",width:100,align:'center'},
	]
];
//查询操作
function query() {
	$("#tables").omGrid("setData","<%=_path%>/mailRecord/queryMailRecords.do?"+$("#filterFrm").serialize());
}
//模态窗口
function showModelDialog(){
	   $("#dialog_modal").omDialog("open");
	}

</script>
</head>
<body>
	<div id="search-panel">
	   <form id="filterFrm">
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">经办部门：</span></td>
					<td><input class="sele" name="formMap['deptCode']" id="deptCode" /></td>
					<td style="padding-left:15px" align="right"><span class="label">业务线：</span></td>
					<td><input class="sele" name="formMap['lineCode']" id="bizLine" /></td>
					<td style="padding-left:15px"><span class="label">渠道名称：</span></td>
					<td><input name="formMap['channelName']" id="channelName"/></td>
					<td style="padding-left:15px"><span class="label">发送日期：</span></td>
					<td><input class="sele" name="formMap['startDate']" id="startDate" />-<input class="sele" name="formMap['endDate']" id="endDate"/></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">邮件类型：</span></td>
					<td><input class="sele" name="formMap['taskType']" id="channelMailType" /></td>
					<td style="padding-left:15px"><span class="label">接收人：</span></td>
					<td ><input name="formMap['recipients']" id="recipients" /></td>
					<td align="right" colspan="6"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
	    </form>
	</div>
	<div id="tables"></div>
	<div id="dialog_modal" title="邮件内容详情"></div>
</body>
</html>