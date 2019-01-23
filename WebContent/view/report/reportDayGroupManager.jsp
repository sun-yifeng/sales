<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>团队-客户经理业绩日报（常规业务）</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;

$(window).scroll(function (){
	$("#tables").omGrid('resize');
});

$(function(){	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"132px"});

	//页面列表高度调整
	var btInput = $("#search-panel");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight()+87;
  	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    } 

    //
	$('#reportDay').omCalendar({
	    dateFormat : "yy-mm-dd",
		 editable : false
	});
	var date = new Date();
	date.setDate(date.getDate()-1);
	$("#reportDay").val($.omCalendar.formatDate(date,'yy-mm-dd'));
	
	//document.writeln(topnum);
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
    	title : "报表管理  > 客户经理业绩日报",
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
            //从后台取出三级机构的数据并赋值给第2个combo
            $('#deptCode').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+$("#parentDept").val());
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
	{header:"组织单元",name:"deptUnit", rowspan:2,width:180},
	{header:"用工方式",name:"employMode", rowspan:2,width:110},
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
	{header:"年保费计划时<br/>间进度达成率", name:"premiumPlanRate", rowspan:2,width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	}],
	
	[{header:"昨日" , name:"daySign" , width:80,
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
	}]
];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportGroupManagerTrace/queryReportGroupManagerTrace.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reportGroupManagerTrace/queryDataToExcel.do?"+$("#filterFrm").serialize());
}

function setProvince(data){
	$('#parentDept').omCombo({
		value:data.value
	});
}

function setCity(){
	var cityData = $('#deptCode').omCombo('getData');
	//alert(cityData[0].value);
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table >
				<tr>
					<td style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td>
						<input name="formMap['parentDept']" id="parentDept" class="sele"/>
					</td>
					<td style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptCode']" id="deptCode" class="sele"/></td>
					<td style="padding-left:15px"><span class="label">组织单元：</span></td>
					<td><input type="text" name="formMap['deptUnit']" id="formMap['deptUnit']" /></td>
					<td style="padding-left:15px"><span class="label">用工方式：</span></td>
					<td><input type="text" name="formMap['employMode']" id="formMap['employMode']" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">员工类别：</span></td>
					<td><input type="text" name="formMap['employType']" id="formMap['employType']" /></td>
					<td style="padding-left:15px"><span class="label">员工代码：</span></td>
					<td><input type="text" name="formMap['employCode']" id="formMap['employCode']" /></td>
					<td style="padding-left:15px"><span class="label">报表日期：</span></td>
					<td><input type="text"  name="formMap['reportDay']"  id="reportDay"  value=" " class="sele"/></td>
					<!-- <td style="padding-left:15px"><span class="label">出单员：</span></td>
					<td><input type="text" name="formMap['signCode']" id="formMap['signCode']" /></td> -->
					<td colspan="2" style="padding-left:30px;" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>

