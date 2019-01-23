<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>中介渠道业务数据周报</title>
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
	//alert(btnum + "," + bdnum + "," + topnum);
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel:tabHand,
		showIndex : true,
        height : topnum,
        method : 'POST'
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "报表管理  > 中介渠道业务数据周报",
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
            //取出第1个combo的当前值
            if(newValue != ''){
	            //从后台取出三级机构的数据并赋值给第2个combo
	            $('#deptCode').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
            }
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
	{header:"险种",name:"insureCode", rowspan:2,width:60},
	{header:"渠道名称",name:"agentCode", rowspan:2,width:160},
	{header:"业务员",name:"bizCode", rowspan:2,width:130},
	{header:"协作人",name:"supportCode", rowspan:2,width:160},
	{header:"出单员",name:"signCode", rowspan:2,width:150},
	{header:"签单净保费(元)", colspan:3},
	{header:"再保后承保年度制满期赔付率", colspan:4},
	{header:"再保后历年制赔付率",name:"pastYears", rowspan:2,width:120,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	}
	],
	[
	{header:"本周" ,name:"weekDaySign", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本月" ,name:"monthSign", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本年" ,name:"yearSign", width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	//再保后承保年度制满期赔付率
	{header:"去年" ,name:"lastYearCompansation", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"本年" ,name:"toYearCompansation", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"环比增长" ,name:"linkRelativeRatio", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	}]
];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportWeekAgentChannel/queryReportWeekAgentChannel.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reportWeekAgentChannel/queryDataToExcel.do?"+$("#filterFrm").serialize());
}

function setProvince(data){
	$('#Province').omCombo({
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
					<td align="right" style="padding-left:15px" ><span class="label">二级机构：</span></td>
					<td><input name="formMap['parentDept']" id="parentDept" class="sele"/></td>
					<td align="right" style="padding-left:15px" ><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptCode']" id="deptCode" class="sele"/></td>
					<td align="right" style="padding-left:15px" ><span class="label">险种：</span></td>
					<td><input type="text" name="formMap['insureCode']" id="formMap['insureCode']" /></td>
					<td align="right" style="padding-left:15px" ><span class="label">渠道编码：</span></td>
					<td><input type="text" name="formMap['agentCode']" id="formMap['agentCode']" /></td>
				</tr>
				<tr>
					<td align="right"><span class="label">业务员：</span></td>
					<td><input type="text" name="formMap['bizCode']" id="formMap['bizCode']" /></td>
					<td align="right"><span class="label">协作人编码：</span></td>
					<td><input type="text" name="formMap['supportCode']" id="formMap['supportCode']" /></td>
					<td align="right"><span class="label">开始时间：</span></td>
					<td><input type="text" name="formMap['reportStartWeek']" id="reportStartWeek"  value="" class="sele"/></td>
					<td align="right"><span class="label">结束时间：</span></td>
					<td><input type="text" name="formMap['reportEndWeek']" id="reportEndWeek"  value="" class="sele"/></td>
				</tr>
				<tr>
					<td align="right"><span class="label">出单员：</span></td>
					<td><input type="text" name="formMap['signCode']" id="formMap['signCode']" /></td>
					<td colspan="6" style="padding-left:30px;" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>