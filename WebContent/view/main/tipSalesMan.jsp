<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>未配置职级及业务线的销售人员</title>
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
	var searchPanelTitle = "系统提示信息  > 未配置职级及业务线的销售人员";
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
		colModel:[],
		showIndex : true,
        height:topnum,
        method : 'POST',
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
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
function setHand(dept){
	var result = [];
	result.push({header:"二级机构",name:"deptNameTwo",width:100});
	result.push({header:"三级机构",name:"deptNameThree", width:100});
	result.push({header:"四级单位",name:"deptNameFour", width:150});
	result.push({header:"团队名称",name:"GROUP_NAME", width:150});
	result.push({header:"姓名",name:"SALESMAN_CNAME", width:100});
	result.push({header:"当前工号",name:"EMPLOYCODE", width:100});
	result.push({header:"处理状态",name:"PROCESSSTATUS",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "未处理";
			else if(value == '2')
				return "已处理";
			else
				return "";
		}			
	});
 	result.push({header:"是否前台",name:"SALESMANFLAG",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "是";
			else if(value == '0')
				return "否";
			else
				return "";
		}			
	});
	result.push({header:"销售职级",name:"RANKNAME", width:100});
	result.push({header:"业务线",name:"BUSINESSLINE", width:100});
	result.push({header:"入职日期",name:"ENTRYDATE", width:100});
	result.push({header:"转正日期",name:"REGULARDATE", width:100});
	result.push({header:"入司日期",name:"CONTRACTDATE", width:100});
	result.push({header:"员工状态",name:"STATUS",width:100});
	result.push({header:"员工类别",name:"SALESMANTYPE",width:100});
	result.push({header:"职务类型",name:"TITLETYPE",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "前台";
			else if(value == '2')
				return "后勤";
			else if(value == '3')
				return "安管";
			else if(value == '4')
				return "经理";
			else
				return "";
		}			
	});
	result.push({header:"职务",name:"TITLE", width:100});
	result.push({header:"性别",name:"SEX",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '106001')
				return "男";
			else if(value == '106002')
				return "女";
			else if(value == '106003')
				return "不清楚";
			else if(value == '106009')
				return "未知";
			else
				return "";
		}		
	});
	result.push({header:"出生日期",name:"BIRTHDAY", width:100});
	result.push({header:"身份证号",name:"CERTIFYNO", width:140});
	result.push({header:"年龄",name:"AGE", width:100});
	result.push({header:"民族",name:"NATION", width:100});
	result.push({header:"籍贯",name:"FROMADDRESS", width:100});
	result.push({header:"党派",name:"PARTY",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "党员";
			else if(value == '2')
				return "预备党员";
			else if(value == '3')
				return "共青团员";
			else if(value == '4')
				return "群众";
			else
				return "";
		}			
	});
	result.push({header:"最高学历",name:"DEGREE",width:100});
	result.push({header:"毕业院校",name:"EDUCATION", width:100});
	result.push({header:"专业",name:"MAGOR", width:100});
	result.push({header:"婚姻状态",name:"MARRY",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "已婚";
			else if(value == '2')
				return "未婚";
			else if(value == '3')
				return "离婚";
			else
				return "";
		}		
	});
	return result;
}

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
	$("#tables").omGrid("setData","<%=_path%>/findSalesmanTipList.do?"+$("#filterFrm").serialize());
	$("#tables").omGrid({colModel:setHand()});
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
					<td align="right"><span class="label">二级机构：</span></td>
					<td align="left"><input name="formMap['deptCode']" id="deptCode"/></td>
					<td align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>