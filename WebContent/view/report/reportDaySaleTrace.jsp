<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>整体业绩进度追踪日报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
$(function(){
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"132px"});
    $('#reportDay').omCalendar({
        dateFormat : "yy-mm-dd",
 		editable : false
    });
    
	var preDate = new Date();
	preDate.setDate(preDate.getDate()-1);
	$('#reportDay').val($.omCalendar.formatDate(preDate,"yy-mm-dd"));
    
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
    	title : "报表管理  > 整体业绩追踪日报",
    	collapsible:true,
    	collapsed:false
    });	
	
	//加载二级机构名称
	$('#parentDept').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#parentDept').omCombo({
				value:eval(data)[1].value,
    			readOnly : true
			});
        },
        onValueChange : function(target, newValue, oldValue, event) {
            $('#deptName').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
        },
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	//初始化三级机构名称
	$('#deptName').omCombo({
		onSuccess:function(data, textStatus, event){
			if(data.length === 2){
				$('#deptName').omCombo("value",data[1].value);
        		$('#deptName').omCombo({
        			readOnly : true
        		});
        	}
		},
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		emptyText : '请选择'
	});
	
	$("#bizLine").omCombo({
		dataSource : "<%=_path%>/common/queryBusinessLine.do",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		emptyText : '请选择'
	});
	
	setTimeout("query()", 500);
});

//表头
var tabHand = [
	[{header:"二级机构", name:"deptNameTwo", rowspan:2,width:120},
	{header:"三级机构", name:"deptNameThree", rowspan:2,width:150},
	{header:"业务线", name:"bizLine", rowspan:2,width:100},
	{header:"险种", name:"insureType", rowspan:2,width:60},
	{header:"保费计划(元)", name:"premiumPlan", rowspan:2,width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"保费收入(元)", colspan:8},
	{header:"签单净保费(元)", colspan:5}],
	[{header:"本日", name:"incomeThisDay", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本月", name:"incomeThisMonth", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本年", name:"incomeThisYear", width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"年保费计划达成率", name:"premiumPlanRate", width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"去年同期累计保费收入", name:"incomeLastYear", width:130,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"年保费计划时间进度达成率", name:"schedulePlanRate" , width:160,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"同期保费增减值", name:"termIncreaseRate" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本年保费同期增长率", name:"yearIncreaseRate" , width:150,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本日", name:"signThisDay", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"本月", name:"signThisMonth", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"本年", name:"signThisYear", width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"去年同期签单净保费", name:"signLastYear", width:120,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"本年签单净保费同期增长率", name:"policyIncreaseRate" , width:160,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	}]
];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportDaySaleTrace/queryReportDaySaleTrace.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reportDaySaleTrace/queryDataToExcel.do?"+$("#filterFrm").serialize());
}

function setProvince(data){
	$('#parentDept').omCombo({
		value:data.value
	});
}

function setCity(){
	var cityData = $('#deptName').omCombo('getData');
	alert(cityData[0].value);
	
}

</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table >
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">二级机构：</span></td>
					<td><input name="formMap['parentDept']" id="parentDept" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptName']" id="deptName" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">业务线：</span></td>
					<td><input type="text" name="formMap['bizLine']" id="bizLine" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">险种：</span></td>
					<td><input type="text" name="formMap['insureType']" id="formMap['insureType']" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">报表时间：</span></td>
					<td><input type="text" name="formMap['reportDay']" id="reportDay"  value="" class="sele"/></td>
					<td colspan="6" style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>