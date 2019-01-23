<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>团队人员组织发展总表</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
$(function(){	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"132px"});
	$("#reportMoth").omCalendar({
		dateFormat : 'yymm',
		editable : false
	});
	var date = new Date();
	date.setDate(date.getDate());
	if(date.getMonth() === 0){
		date.setFullYear(date.getFullYear()-1, 11, 1);
		$("#reportMoth").val($.omCalendar.formatDate(date,'yymm'));
	}else{
		$("#reportMoth").val($.omCalendar.formatDate(date,'yymm')-1);
	}
	
	var btnum = $("#search-panel").offset().top+$("#search-panel").outerHeight()+80;
	var bdnum = $("body").offset().top+$("body").outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }
	
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
    	title : "报表管理  > 团队人员组织发展总表",
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
	//加载初始数据
	setTimeout("query()", "1000");
});

/* {header:"二级机构",name:"parentDept", rowspan:2,width:150,
	renderer : function(value, rowData , rowIndex) {
		return value.substr(3);
	}
}, */
//表头
var tabHand = [
	[
	{header:"三级机构",name:"deptCode", rowspan:2,width:120},
	{header:"总体情况",colspan:3,width:180},
	{header:"人员职称",colspan:6,width:180},
	{header:"产能分布",colspan:5,width:180},],
	
	[{header:"客户经理总数" , name:"managerCount" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"其中:本年新增" , name:"increaseCount" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"其中：当年入司当年<br/>离职+过往年度离职" , name:"dimissionCount" , width:120,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"客户经理产能(元)" , name:"managerCapacity" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"资深客户经理" , name:"seniorCapacity" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"高级客户经理" , name:"highCapacity" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"中级客户经理" , name:"middleCapacity" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"初级客户经理" , name:"juniorCapacity" , width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"试用" , name:"probationCapacity" , width:60,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"零产能" , name:"capacityClassA" , width:60,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"0-15万" , name:"capacityClassB" , width:60,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"15-30万" , name:"capacityClassC" , width:60,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"30-50万" , name:"capacityClassD" , width:60,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
  	{header:"50万以上" , name:"capacityClassE" , width:60,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	}
  	]
];
//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportTotalGroupMenber/queryReportTotalGroupMenber.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){
    window.open("<%=_path%>/reportTotalGroupMenber/queryDataToExcel.do?"+$("#filterFrm").serialize());
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
				<td align="right" style="padding-left:15px;" ><span class="label">二级机构：</span></td>
				<td align="left" ><input name="formMap['parentDept']" id="parentDept" class="sele" /></td>
				<td align="right" style="padding-left:15px;" ><span class="label">三级机构：</span></td>
				<td align="left" ><input name="formMap['deptCode']" id="deptCode" class="sele" /></td>
				<td align="right" style="padding-left:15px;" ><span class="label">查询时间：</span></td>
				<td align="left" ><input name="formMap['reportMoth']" id="reportMoth" class="sele" /></td>
				<td align="right" style="padding-left:15px;" ><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
			</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>