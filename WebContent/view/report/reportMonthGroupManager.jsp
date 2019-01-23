<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户经理发展月报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
$(function(){
	$("#filterFrm").find("input[name^='formMap']").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#reportMonth").omCalendar({
		dateFormat : 'yymm',
		editable : false
	});
	
	var date = new Date();
	date.setDate(date.getDate());
	if(date.getMonth() === 0){
		date.setFullYear(date.getFullYear()-1, 11, 1);
		$("#reportMonth").val($.omCalendar.formatDate(date,'yymm'));
	}else{
		$("#reportMonth").val($.omCalendar.formatDate(date,'yymm')-1);
	}
	
	var btnum = $("#search-panel").offset().top+$("#search-panel").outerHeight()+82;
	var bdnum = $("body").offset().top+$("body").outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }
	
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel : [],
		showIndex : true,
        height : topnum,
        method : 'POST'
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "报表管理  > 客户经理发展月报",
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
	setTimeout("query()", "500");
});


function setHand(months){
	var monthsValue = ["countMonthlyOne","countMonthlyTwo","countMonthlyThree","countMonthlyFour"
	                   ,"countMonthlyFive","countMonthlySix","countMonthlySeven","countMonthlyEight"
	                   ,"countMonthlyNine","countMonthlyTen","countMonthlyEleven","countMonthlyTwelve"];
	var result = [];
	var arr = new Array();
	result.push({header:"二级机构",name:"parentDept", rowspan:2,width:120});
	result.push({header:"三级机构",name:"deptName", rowspan:2,width:150}); 
	result.push({header:"团队名称",name:"groupCode", rowspan:2,width:180});
	result.push({header:"客户经理名称",name:"manageCode", rowspan:2,width:150});
	/* result.push({header:"渠道类型",name:"agentType", rowspan:2,width:100});  */
	result.push({header:"签单净保费(元)", colspan:3+months });
	result.push({header:"保单质量", colspan:4});
	result.push({header:"本年保单承保边际贡献率",name:"toyearContriRate", rowspan:2,width:140,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	result.push({header:"保单获取成本率",name:"acquisiCostPolicy", rowspan:2,width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	arr[0] = result;
	//JSON.stringify(
	result = [];
	result.push({header:"本年累计" ,name:"toYearCumulative", width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	//{header:"1月" ,name:"countMonthlyOne", width:80}
	if(months==0){
		for(var i=1;i<=12;i++){
			result.push({header: i+"月" ,name:monthsValue[i - 1], width:80,
				renderer : function(value, rowData , rowIndex) {
					return '<div style="text-align:right;">'+value+'</div>';
				}
			});
		}
	}else{
		for(var i=1;i<=months;i++){
			result.push({header: i+"月" ,name:monthsValue[i - 1], width:80,
				renderer : function(value, rowData , rowIndex) {
					return '<div style="text-align:right;">'+value+'</div>';
				}
			});
		}
	}
		
	
	result.push({header:"同比增长率" ,name:"roses", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	result.push({header:"环比增长率" ,name:"growths", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	result.push({header:"去年保单满期赔付" ,name:"lastYaerPayment", width:120,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	result.push({header:"去年保单满期出险频度" ,name:"lastYearAcciFreq", width:140,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	result.push({header:"本年保单满期赔付" ,name:"toyaerPayment", width:120,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	result.push({header:"本年保单满期出险频度" ,name:"toyearAcciFreq", width:140,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	
	arr[1] = result;
	
	return arr;
}
/* function getRealMonth(realMonth){
	var date = new Date();
	var DMonth = date.getMonth();
	var perMonth;
	if(DMonth == realMonth){
		perMonth = DMonth;
	}else{
		perMonth = realMonth;
	}
	$("#tables").omGrid({
		colModel : setHand(perMonth)
		//colModel : getRealMonth(realMonth)
	});
} */
//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportMothGroupManager/queryReportMothGroupManager.do?"+$("#filterFrm").serialize());
	var month = $("#reportMonth").val();
	var realMonth = parseInt(month.substr(4,2));
	$("#tables").omGrid({
		colModel : setHand(realMonth)
	});
	
}

//导出Excel
function dataToExcel(){
    window.open("<%=_path%>/reportMothGroupManager/queryDataToExcel.do?"+$("#filterFrm").serialize());
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
				<td style="padding-left:15px"><span class="label">二级机构：</span></td>
				<td><input name="formMap['parentDept']" id="parentDept" class="sele"/></td>
				<td style="padding-left:15px"><span class="label">三级机构：</span></td>
				<td><input name="formMap['deptCode']" id="deptCode" class="sele"/></td>
				<td style="padding-left:15px"><span class="label">查询时间：</span></td>
				<td><input name="formMap['reportMonth']" id="reportMonth" class="sele"/></td>
				<td  style="padding-left:30px;" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
			</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>