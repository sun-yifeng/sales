<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>个人代理人协议历史轨迹</title>
<%
String channelCode = request.getParameter("channelCode");
String conferCode = request.getParameter("conferCode");
String conferId = request.getParameter("conferId");
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var conferCode = '<%=conferCode%>';
var conferId = '<%=conferId%>';

$(function(){
	 $("#agentConferFilterFrm").find("input[name^='formMap']").css({"width":"151px"});
	 $(".sele").css({"width":"130px"});
	 
	 $("#conferCode").val(conferCode);
	 $("#conferId").val(conferId);
	 
	 $("#agent-confer-search-panel").omPanel({
			title : "个人代理人协议历史轨迹",
			collapsible:true,
			collapsed:false
		});
		
		//协议类型
		$('#conferType').omCombo({
			dataSource : "<%=_path%>/common/queryConferType.do",
	        optionField : function(data, index) {
	            return data.text;
			},
			emptyText : '请选择',
	        editable : false,
	        width : '153px'
	    });
		
		$('#conferSignDate').omCalendar();

		//初始化按钮菜单
		$('#agentConferButtonbar').omButtonbar({
		       	btns : [{label:"详情",
	           			 	id:"queryMediumConferButton",
	           			 	icons : {left : '<%=_path%>/images/detail.png'},
	           	 		 	onClick:function(){
		           	 		 	var rows = $('#agentConferTables').omGrid("getSelections",true);
		       	 		 		var row = eval(rows);
			       	 		 	if(row.length != 1){
		    	 		 			$.omMessageBox.alert({
		        	 		 	        content:'请选择一条记录查看',
		        	 		 	        onClose:function(value){
		        	 		 	        	return false;
		        	 		 	        }
		    	 		 	        });
		       	 		 		}else{
		       	 		 			window.location.href = "agentConferHistoryDetail.jsp?conferId="+conferId+"&historyId="+row[0].historyId+"&conferCode="+conferCode+"&channelCode="+channelCode;
		       	 		 		}
	           	 		 	}
	           	        }
		       	]
		});

		var btInput = $("#agentConferButtonbar");
		var btOffset = btInput.offset();
		var btnum = btOffset.top+btInput.outerHeight();
		var bdInput = $("body");
		var bdOffset = bdInput.offset();
		var bdnum = bdOffset.top+bdInput.outerHeight();
		var topnum = bdnum - btnum;
		if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
			topnum = topnum + 2;
		}
		
		//初始化列表
		$("#agentConferTables").omGrid({
			showIndex : true,
			singleSelect : false,
		    height: topnum,
		    limit : 10,
		    method : 'POST',
	        showIndex : false,
		    colModel : [{header:"协议号",name:"conferId",width:120},
		         		{header:"经办部门编码",name:"deptCode",width:80},
		        		{header:"经办部门",name:"deptCname",width:200},
		        		{header:"个人代理人编码",name:"channelCode",width:120},
		        		{header:"姓名",name:"channelName",width:100},
		        		{header:"审核状态",name:"approveFlag",width:80},
		        		{header:"审核人",name:"approveCode",width:80},
		        		{header:"签定日期", name:"signDate",width:100,
		        	 		renderer: function(value, rowData , rowIndex) {
		        	 			var date = new Date(value);
		        	 			return $.omCalendar.formatDate(date,'yy-mm-dd');
		        	 		}},
		        	 	{header:"生效日期", name:"validDate",width:100,
		        	 		renderer: function(value, rowData , rowIndex) {
		        	 			var date = new Date(value);
		        	 			return $.omCalendar.formatDate(date,'yy-mm-dd');
		        	 		}},
		        	 	{header:"截止日期", name:"expireDate",width:100,
		        	 		renderer: function(value, rowData , rowIndex) {
		        	 			var date = new Date(value);
		        	 			return $.omCalendar.formatDate(date,'yy-mm-dd');
		        	 		}},
		        	 	{header:"结费周期（天）",name:"calclatePeriod",width:90},
		        	 	{header:"是否理财渠道", name:"financeChannel",width:100},
		        	 	{header:"渠道特征", name:"feature",width:100},
		        	 	{header:"渠道系数", name:"rate",width:100},
		        	 	{header:"修改时间",name:"updatedDate",width:120,align:"center",
		        	 		renderer: function(value, rowData , rowIndex) {
		        	 			var date = new Date(value);
		        	 			return $.omCalendar.formatDate(date,'yy-mm-dd H:i:s');
		        	 		}
		        		}]
		});
		
		$("#agent-confer-button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
		$("#button-back").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
		
		//查询协议列表操作
		queryAgentConferHistorys();
});

//查询操作
function queryAgentConferHistorys(){
	$("#agentConferTables").omGrid("setData","<%=_path%>/mediumConfer/queryAgentConferHistorys.do?"+$("#agentConferFilterFrm").serialize());
}

//取消操作
function back(){
	window.location.href = "agentEdit.jsp?flag=1&channelCode="+channelCode;
}
</script>
</head>
<body>
	<form id="agentConferFilterFrm">
		<div id="agent-confer-search-panel">
			<table>
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">协议号：</span></td>
					<td><input type="text" name="formMap['conferId']" id="conferId" readonly="readonly"/><input type="hidden" name="formMap['conferCode']" id="conferCode" /></td>
					<td style="padding-left:15px" align="right"><span class="label">签订日期：</span></td>
					<td><input class="sele" type="text" name="formMap['signDate']" id="conferSignDate" /></td>
					<td colspan="4" style="padding-left:15px;padding-top:5px;" align="right"><span id="agent-confer-button-search" onclick="queryAgentConferHistorys()">查询</span><span id="button-back" onclick="back()">返回</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="agentConferButtonbar"></div>
	<div id="agentConferTables"></div>
</body>
</html>