<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>代理人的业绩保费情况</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
$(function(){	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"132px"});
	$('#reportMoth').omCalendar({
	    dateFormat : "yy-mm",
		editable : false
	});
	
	var date = new Date();
	date.setDate(date.getDate());
	if(date.getMonth() === 0){
		date.setFullYear(date.getFullYear()-1, 11, 1);
		$("#reportMoth").val($.omCalendar.formatDate(date,'yy-mm'));
	}else{
		date.setMonth(date.getMonth()-1, date.getDate());
		$("#reportMoth").val($.omCalendar.formatDate(date,'yy-mm'));
	}
	
	var btnum = $("#search-panel").offset().top+$("#search-panel").outerHeight()+80;
	var bdnum = $("body").offset().top+$("body").outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }
	
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel:[],
		showIndex : true,
        height : topnum,
        method : 'POST'
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "报表管理  > 代理人的业绩保费情况",
    	collapsible:true,
    	collapsed:false
    });	
	
	
	
	//加载二级机构名称
	$('#parentDept').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2){
        		$('#parentDept').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            $('#deptCode').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
        },
        emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	//初始化三级机构名称
	$('#deptCode').omCombo({
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		emptyText : "请选择",
		onSuccess:function(data, textStatus, event){
			if(data.length == 2){
        		$('#deptCode').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
		}
	});
	
	 //var tabHand = setHand(6);
	
	//加载初始数据
	setTimeout("query()", "500");
});

//“中支名称（经办部门）”、“代理人姓名”、“电话号码”、“性别”、“出生年月”、“学历” 、 “推荐人”、 
//“代理协议签订日期”、“代理协议生效日期”、“代理协议截止日期”、代理人录入日期

function setHand(){
	var result = [];
	result.push({header:"保单号",name:"deptCode", rowspan:2,width:100});
	result.push({header:"批单号",name:"agentName", rowspan:2,width:100});
	result.push({header:"中支公司名称",name:"number", rowspan:2,width:100});
	result.push({header:"业务员",name:"partnerName", rowspan:2,width:100});
	result.push({header:"销售团队",name:"gender", rowspan:2,width:100});
	result.push({header:"代理人",name:"birthday", rowspan:2,width:100});
	result.push({header:"推荐人",name:"introducer", rowspan:2,width:100});
	result.push({header:"核保日期",name:"signDate", rowspan:2,width:100});
	result.push({header:"保险起期",name:"effectiveDate", rowspan:2,width:100});
	result.push({header:"保险止期",name:"endDate", rowspan:2,width:100});
	result.push({header:"被保险人",name:"entryDate", rowspan:2,width:100});
	result.push({header:"险种大类",name:"entryDate", rowspan:2,width:100});
	result.push({header:"险种",name:"entryDate", rowspan:2,width:100});
	result.push({header:"车险/人身险/财产险",name:"entryDate", rowspan:2,width:100});
	result.push({header:"签单保费/批改保费(RMB)",name:"entryDate", rowspan:2,width:100});
	result.push({header:"是否续保",name:"entryDate", rowspan:2,width:50});
	result.push({header:"业务等级",name:"entryDate", rowspan:2,width:50});
	return result;
}

//查询操作
function query(){
	<%-- $("#tables").omGrid("setData","<%=_path%>/reportMonthAgentInfo/queryReportMonthAgentInfo.do?"+$("#filterFrm").serialize()); --%>
	$("#tables").omGrid({
		colModel : setHand()
	});
}

//导出Excel
function dataToExcel(){
    window.open("<%=_path%>/reportMonthAgentInfo/queryDataToExcel.do?"+$("#filterFrm").serialize());
}
function setProvince(data){
	$('#parentDept').omCombo({
		value:data.value
	});
}

function setCity(){
	var cityData = $('#deptCode').omCombo('getData');
	alert(cityData[0].value);
	
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table >
			 <tr>
				<td align="right"style="padding-left:15px"><span class="label">保单号：</span></td>
				<td align="left">
					<input name="formMap['deptCode']" id="deptCode" class="sele"/>
				</td>
				<td  align="right" style="padding-left:15px"><span class="label">经办部门：</span></td>
				<td align="left"><input name="formMap['agentName']" id="agentName" class="sele"/></td>
		       <td  align="right" style="padding-left:15px"><span class="label">业务员：</span></td>
			   <td align="left"><input name="formMap['partnerName']" id="partnerName" /></td>
		       
			</tr>
			<tr>
			   <td  align="right" style="padding-left:15px"><span class="label">代理人：</span></td>
			   <td align="left"><input name="formMap['partnerName']" id="partnerName" /></td>
			   <td align="right" style="padding-left:15px"><span class="label">推荐人：</span></td>
			   <td align="left"><input name="formMap['introducer']" id="introducer" /></td>
			   <td align="right" style="padding-left:15px">查询时间：</td>
			   <td align="left"><input name="formMap['reportMoth']" id="reportMoth" class="sele"></td>
				<td align="right" colspan="4">
					<span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span>
				</td>
			</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>