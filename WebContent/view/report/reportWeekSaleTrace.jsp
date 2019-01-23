<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>整体业绩进度追踪周报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
$(function(){	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"132px"});
	var time = new Date();
	time.setDate(time.getDate() - time.getDay()-7);
	$('#reportStartWeek').omCalendar({
		disabledDays : [1,2,3,4,5,6],
	    dateFormat : "yy-mm-dd",
		editable : false,
	    onSelect : function(date,event){
	    	time.setTime(date.getTime()+(24*6*3600*1000));
	    	$('#reportEndWeek').val($.omCalendar.formatDate(time,"yy-mm-dd"));
	    }
	});
	$('#reportStartWeek').omCalendar('setDate',time);
	$('#reportStartWeek').val($.omCalendar.formatDate(time,"yy-mm-dd"));
	time.setDate(time.getDate() - time.getDay()+6);
	$('#reportEndWeek').omCalendar({
		disabledDays : [1,2,3,4,5,6,7],
	    dateFormat : "yy-mm-dd",
		editable : false
	});
	$('#reportEndWeek').omCalendar('setDate',time);
	$('#reportEndWeek').val($.omCalendar.formatDate(time,"yy-mm-dd"));
	
	var btnum = $("#search-panel").offset().top+$("#search-panel").outerHeight()+80;
	var bdnum = $("body").offset().top+$("body").outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }
  	
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel : tabHand,
		showIndex : true,
        height : topnum,
        method : 'POST'
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "报表管理  > 整体业绩跟踪周报",
    	collapsible:true,
    	collapsed:false
    });	
	
	
	$.ajax({ 
		url: "<%=_path%>/common/findDeptByUserCode.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			currentDept = data;
			$('#parentDept').omCombo({
				dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
				onSuccess : function(){
					if(currentDept != '00'){
						$('#parentDept').omCombo({
							value:currentDept,
							readOnly : true,
							onValueChange : function(target, newValue, oldValue, event) {
					            $('#dept_code').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
					        }
						});
					}else{
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
					            $('#dept_code').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
					        },
					        emptyText : "请选择",
							valueField : 'value',
							inputField : 'text',
							filterStrategy : 'anywhere'
					    });
					}
				}
		    });
		}
	});
	
	//初始化三级机构名称
	$('#dept_code').omCombo({
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		emptyText : "请选择",
		onSuccess:function(data, textStatus, event){
			if(data.length == 2){
        		$('#dept_code').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
		}
	});
	
	$("#bizLine").omCombo({
		dataSource : "<%=_path%>/common/queryBusinessLine.do",
		valueField : 'value',
		inputField : 'text',
		emptyText : "请选择",
		filterStrategy : 'anywhere'
	});
	
	//加载初始数据
	setTimeout("query()", "500");
});

//表头
var tabHand = [
	[{header:"二级机构",name:"parentDept", rowspan:2,width:120},
	{header:"三级机构",name:"deptName", rowspan:2,width:150,
		renderer : function(colValue, rowData, rowIndex) {
			if(colValue == "")
				return "";
 			return colValue; 
 		}},
	{header:"业务线",name:"bizLine", rowspan:2,width:100},
	{header:"险种",name:"insureCode", rowspan:2,width:60},
	{header:"保费计划(元)",name:"premiumPlan", rowspan:2,width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"保费收入(元)", colspan:7,align : 'center'},
	{header:"签单净保费(元)", colspan:4,align : 'center'},
	{header:"再保后承保年度制满期赔付率", colspan:4,align : 'center'}],
	
	[{header:"本周" , name:"weekIncome" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本月" , name:"monthIncome" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本年" , name:"yearIncome" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"年保费计划达成率" , name:"premiumPlanRate" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"年保费计划时间进度达成率" , name:"schedulePlanRate" , width:150,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"同期保费增减值" , name:"termIncreaseRate" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本年保费同期增长率" , name:"yearIncreaseRate" , width:120,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	
 	{header:"本周" , name:"weekSign" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"本月" , name:"monthSign" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"本年" , name:"yearSign" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"本年签单净保费同期增长率" , name:"policyIncreaseTate" , width:150,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	
  	{header:"去年" , name:"lastYearCompansation" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"本年" , name:"toYearCompansation" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"环比增长" , name:"linkRelativeRatio" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	}]
];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportWeekSaleTrace/queryReportWeekSaleTrace.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reportWeekSaleTrace/queryDataToExcel.do?"+$("#filterFrm").serialize());
}

function setProvince(data){
	$('#parentDept').omCombo({
		value:data.value
	});
}

function setCity(){
	var cityData = $('#dept_code').omCombo('getData');
	alert(cityData[0].value);
	
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px"align="right"><span class="label">二级机构：</span></td>
					<td>
						<input name="formMap['parentDept']"  id="parentDept" class="sele"/>
					</td>
					<td style="padding-left:15px"align="right"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptCode']" id="dept_code" class="sele"/></td>
					<td style="padding-left:15px"align="right"><span class="label">业务线：</span></td>
					<td><input type="text" name="formMap['bizLine']" id="bizLine" class="sele"/></td>
					<td style="padding-left:15px"align="right"><span class="label">险种：</span></td>
					<td><input type="text" name="formMap['insureCode']" id="formMap['insureCode']" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px"align="right"><span class="label">开始时间：</span></td>
					<td><input type="text" name="formMap['reportStartWeek']" id="reportStartWeek" value="" class="sele"/></td>
					<td style="padding-left:15px"align="right"><span class="label">结束时间：</span></td>
					<td><input type="text" name="formMap['reportEndWeek']" id="reportEndWeek" value="" class="sele"/></td>
				  	<td colspan="4" style="padding-left:30px;" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>