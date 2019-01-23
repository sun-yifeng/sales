<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户经理业绩周报</title>
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
	$('#reportEndWeek').val($.omCalendar.formatDate(time,"yy-mm-dd"));
	
	$('#reportEndWeek').omCalendar({
		disabledDays : [1,2,3,4,5,6,7],
	    dateFormat : "yy-mm-dd",
		editable : false
	});
	
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
    	title : "报表管理  > 客户经理业绩周报",
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
        optionField : function(data, index) {
            return data.text;
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
	
	//加载初始数据
	setTimeout("query()", "500");
});

//表头
var tabHand = [
	[{header:"二级机构",name:"parentDept", rowspan:2,width:120},
	{header:"三级机构",name:"deptName", rowspan:2,width:150},
	{header:"组织单元",name:"deptUnit", rowspan:2,width:150},
	{header:"用工方式",name:"employMode", rowspan:2,width:90},
	{header:"员工类别",name:"employType", rowspan:2,width:80},
	{header:"员工代码",name:"employCode", rowspan:2,width:120},
	{header:"年标保计划(元)",name:"yearStandartPlan", rowspan:2,width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"年保费计划(元)",name:"yearPremiumPlan", rowspan:2,width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"签单净保费(元)", colspan:3},
// 	{header:"标准保费(元)",name:"standardPremium", rowspan:2,width:100,
// 		renderer : function(value, rowData , rowIndex) {
// 			return '<div style="text-align:right;">'+value+'</div>';
// 		}
// 	},	
// 	{header:"年保费计划时<br/>间进度达成率", name:"premiumPlanRate", rowspan:2,width:80,
// 		renderer : function(value, rowData , rowIndex) {
// 			return '<div style="text-align:right;">'+value+'</div>';
// 		}
// 	},
	{header:"再保后历年制赔付率", colspan:3}
	],
	
	[{header:"本周" , name:"daySign" , width:80,
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
	} ,
	{header:"去年" , name:"lastYearCompansation" , width:70,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"本年" , name:"toYearCompansation" , width:70,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"环比增长" , name:"linkRelativeRatio" , width:70,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	}]
];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportWeekGroupManager/queryReportWeekGroupManager.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reportWeekGroupManager/queryDataToExcel.do?"+$("#filterFrm").serialize());
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
			<table>
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td><input name="formMap['parentDept']" id="parentDept" class="sele"/></td>
					<td align="right" style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptCode']" id="deptCode" class="sele"/></td>
					<td align="right" style="padding-left:15px"><span class="label">组织单元：</span></td>
					<td><input type="text" name="formMap['deptUnit']" id="formMap['deptUnit']" /></td>
					<td align="right" style="padding-left:15px"><span class="label">用工方式：</span></td>
					<td><input type="text" name="formMap['employMode']" id="formMap['employMode']" /></td>
				</tr>
				<tr>
					<td align="right"><span class="label">员工类别：</span></td>
					<td><input type="text" name="formMap['employType']" id="formMap['employType']" /></td>
					<td align="right"><span class="label">员工代码：</span></td>
					<td><input type="text" name="formMap['employCode']" id="formMap['employCode']" /></td>
					<td align="right"><span class="label">开始时间：</span></td>
					<td><input type="text" name="formMap['reportStartWeek']" id="reportStartWeek" value="" class="sele"/></td>
					<td align="right"><span class="label">结束时间：</span></td>
					<td><input type="text" name="formMap['reportEndWeek']" id="reportEndWeek" value="" class="sele"/></td>
				</tr>
				<tr>
					<td align="right" colspan="10"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>