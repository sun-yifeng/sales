<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>合作机构的许可证到期机构</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<link rel="stylesheet" type="text/css" href="<%=_path%>/css/form.css" />
<script type="text/javascript">
//定义表格对象
var dataGrid;
var bzlineData = null;
$(function(){
	//加载业务线
	$.ajax({ 
		url: "<%=_path%>/common/loadBline",
		type:"post",
		async: false, 
		dataType: "json",
		success: function(data){
			bzlineData = data;
		}
	});
	$("#filterFrm").find("input").css({"width":"150px"});
	$(".sele").css({"width":"130px"});
	var btInput = $("#buttonbar");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight()+72;
  	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }

	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});

	//查询面板
	var searchPanelTitle = "系统提示信息  > 合作机构许可证到期列表";
	$("#search-panel").omPanel({
    	title : searchPanelTitle,
    	collapsible:true,
    	collapsed:false
    });
	//----------查询表单初始化开始-------------
	//加载二级机构名称
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
	$('#startDate').omCalendar();
	$('#endDate').omCalendar();
	//----------查询表单初始化结束-------------
	//初始化数据列表
	dataGrid = $("#tables").omGrid({
		limit : 100,
		colModel : tabHand,
		showIndex : true,
        height : topnum,
        method : 'POST',
        onSuccess : function(data,testStatus,XMLHttpRequest,event){
           setTimeout("setTdStyle()",200); 
        }
	});
	
	 $('#lineCode').omCombo({
         dataSource:bzlineData,
         editable:false
     });
	
	//加载初始数据
	setTimeout("query()",500);
	setTimeout("setTdStyle()",800); 
});

//设置表格样式
function setTdStyle(){
	$("td").css("padding-right","5px");
	$("th").css("padding-right","5px");
}

//表头
var tabHand = [
    [
		{header:"经办机构",name:"DEPTCODE",width:200,align:'center',
		    renderer : function(value, rowData , rowIndex){
		    	return value.substr(value.indexOf("-")+1);
			}},
		{header:"业务线",name:"LINECODE",width:100,align:'center',
			renderer : function(value, rowData,rowIndex) {
				return getBzlineText(value);
			}},
	    {header:"渠道",name:"CHANNELNAME",width:200,align:'center'},
	    {header:"许可证号",name:"LICENCE",width:200,align:'center'},
		{header:"许可证颁发日期",name:"VALIDDATE",width:200,align:'center',
			renderer : function(value, rowData , rowIndex){
				return formatDate(value,"yyyy-MM-dd");
			}
		},
		{header:"许可证期满日期",name:"EXPIREDATE",width:200,align:'center',
			renderer : function(value, rowData , rowIndex){
				return formatDate(value,"yyyy-MM-dd");
			}
		}
	]
];

//权限管控
function isSelected(){
	$.ajax({ 
		url: "<%=_path%>/reviewRank/findRolesInSystemByUserCode.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			roleEname = data;
		}
	});
	
	if(roleEname == "headDeptDirector"){
		$("#deptPlanAdd").omButton("disable");
		$("#updatePlan").omButton("disable");
	}else if(roleEname == "subDeptAdmin"){
	    $("#deptPlanAdd").omButton("disable");
		$("#updatePlan").omButton("disable");
	}else if(roleEname == "thirdDeptMiddle"){
		$("#deptPlanAdd").omButton("disable");
		$("#updatePlan").omButton("disable");
	}else{
		$("#deptPlanAdd").omButton("enable");
		$("#updatePlan").omButton("enable");
	}
}

//得到业务线文本
function getBzlineText(codeV){
	var lineText = "";
	$.each(bzlineData,function(i,bzline){
		if(bzline.value==codeV){
			lineText = bzline.text;
		}
	});
	return lineText;
}

//格式化日期
function formatDate(value,pattern){
		if(value==""||value==null){
	    	return "";
	    }
	    var actionDate = new Date(value);
		var fullYear = actionDate.getFullYear();
		var month = (actionDate.getMonth() + 1);
		if (month < 10) {
			month = "0" + month;
		}
		var day = actionDate.getDate();
		if (day < 10) {
			day = "0" + day;
		}
		var hours = actionDate.getHours();
		if (hours < 10) {
			hours = "0" + hours;
		}
		var minutes = actionDate.getMinutes();
		if (minutes < 10) {
			minutes = "0" + minutes;
		}
		var seconds = actionDate.getSeconds();
		if (seconds < 10) {
			seconds = "0" + seconds;
		}
		var timeV = fullYear + "-" + month + "-" + day + " " + hours + ":"+ minutes + ":" + seconds;
		if(pattern=="yyyy-MM-dd"){
			timeV = fullYear + "-" + month + "-" + day;
		}
		return timeV;
}

//查询操作
function query() {
	$("#tables").omGrid("setData","<%=_path%>/getMediumValidList.do?"+$("#filterFrm").serialize());
	//setTimeout("isSelected()",300) ; 
	setTimeout("setTdStyle()",200); 
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">经办机构：</span></td>
					<td align="left"><input name="formMap['deptCode']" id="deptCode"/></td>
					<td align="right"><span class="label">业务线：</span></td>
					<td align="left"><input class="sele" name="formMap['lineCode']" id="lineCode"/></td>
					<td align="right"><span class="label">渠道名称：</span></td>
					<td align="left"><input name="formMap['channelName']" id="channelName"/></td>
					<td align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>