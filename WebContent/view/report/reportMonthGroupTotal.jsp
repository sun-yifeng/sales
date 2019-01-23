<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>销售团队业绩月报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;

$(window).scroll(function (){
	$("#tables").omGrid('resize');
});

$(function(){	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"132px"});
	$('#statMonth').omCalendar({
	    dateFormat : "yymm"
	});
	var date = new Date();
	date.setDate(date.getDate());
	if(date.getMonth() === 0){
		date.setFullYear(date.getFullYear()-1, 11, 1);
		$("#statMonth").val($.omCalendar.formatDate(date,'yymm'));
	}else{
		$("#statMonth").val($.omCalendar.formatDate(date,'yymm')-1);
	}
	
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
    	title : "报表管理  > 销售团队业绩月报",
    	collapsible:true,
    	collapsed:false
    });	
	
	//加载二级机构名称
	$('#deptCode2').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2){
        		$('#deptCode2').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            //从后台取出三级机构的数据并赋值给第2个combo
            $('#deptCode3').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+$("#deptCode2").val());
        },
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	//初始化三级机构名称
	$('#deptCode3').omCombo({
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		emptyText : "请选择",
		onSuccess:function(data, textStatus, event){
			if(data.length == 2){
        		$('#deptCode3').omCombo({
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
	[{header:"二级机构",name:"deptCode2", rowspan:2,width:120},
	{header:"三级机构",name:"deptCode3", rowspan:2,width:150},
	{header:"销售团队名称",name:"groupCname", rowspan:2,width:150},
	{header:"团队代码",name:"groupCode", rowspan:2,width:100},
	{header:"团队经理",name:"groupLeader", rowspan:2,width:80},
	{header:"团队定级年化<br/>标保计划(元)",name:"groupPlanFee", rowspan:2,width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"本年累计完成<br/>标准保费(元)",name:"groupTotalFee", rowspan:2,width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"年化标保时间<br/>进度达成率",name:"groupPlanPercetn", rowspan:2,width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"保费收入(元)", colspan:5},
	{header:"本年再保后承保年度制满期<br/>赔付率（不含间接理赔费用）	", colspan:2},
	{header:"去年再保后承保年度制满期<br/>赔付率（不含间接理赔费用）	", colspan:2},
	{header:"团队增员情况", colspan:3},
	{header:"人均产能(元)",name:"avgFee", rowspan:2,width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"车险续保率",name:"renewalRateCar", rowspan:2,width:70,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"非车险保费收入(元)",name:"gotFeeNotCar", rowspan:2,width:120,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"非车险业务占比",name:"percentNotCar", rowspan:2,width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	}],
	
	[{header:"上月" , name:"gotFeeLastMonth" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"本月" , name:"gotFeeThisMonth" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本年累计" , name:"gotFeeThisYeae" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"去年同期" , name:"gotFeeLastYeae" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"同比增长率" , name:"gotFeeInceaseRate" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"上月" , name:"claimRateLastMonth" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"本月" , name:"claimRateThisMonth" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"上月" , name:"claimRateLastMonthYear" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"本月" , name:"claimRateThisMonthYear" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"上年底团队人数" , name:"menberCountLastYear" , width:90,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本年人数" , name:"menberCountThisYear" , width:60,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"新增人数" , name:"inceaseCount" , width:60,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	}]
];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportGroupSale/queryReportMonthGroupSale.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reportGroupSale/queryReportMonthToExcel.do?"+$("#filterFrm").serialize());
}

function setProvince(data){
	$('#deptCode2').omCombo({
		value:data.value
	});
}

function setCity(){
	var cityData = $('#deptCode3').omCombo('getData');
	alert(cityData[0].value);
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table >
				<tr>
					<td style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td><input name="formMap['deptCode2']" id="deptCode2" class="sele"/>
					<td style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptCode3']" id="deptCode3" class="sele"/></td>
					<td style="padding-left:15px"><span class="label">销售团队名称：</span></td>
					<td><input type="text" name="formMap['groupCname']" id="formMap['groupCname']" /></td>
					<td style="padding-left:15px"><span class="label">团队代码：</span></td>
					<td><input type="text" name="formMap['groupCode']" id="formMap['groupCode']" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">团队经理：</span></td>
					<td><input type="text" name="formMap['groupLeader']" id="formMap['groupLeader']" /></td>
					<td style="padding-left:15px"><span class="label">报表日期：</span></td>
					<td><input type="text"  name="formMap['statMonth']"  id="statMonth"  value="" class="sele"/></td>
					<td colspan="4" style="padding-left:30px;" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>

