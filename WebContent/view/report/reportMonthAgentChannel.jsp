<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>渠道发展情况月报（中介渠道业绩月报）（旧）</title>
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
    	title : "报表管理  > 中介渠道业绩月报",
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

function setHand(months){
	var monthsValue = ["countMonthlyOne","countMonthlyTwo","countMonthlyThree","countMonthlyFour"
	                   ,"countMonthlyFive","countMonthlySix","countMonthlySeven","countMonthlyEight"
	                   ,"countMonthlyNine","countMonthlyTen","countMonthlyEleven","countMonthlyTwelve"];
	var result = [];
	var arr = new Array();
	result.push({header:"二级机构",name:"parentDept", rowspan:2,width:120});
	result.push({header:"三级机构",name:"deptName", rowspan:2,width:150});
	result.push({header:"代理人名称",name:"channelName", rowspan:2,width:100});
	result.push({header:"协作人名称",name:"supportName", rowspan:2,width:100});
	result.push({header:"渠道类型",name:"agentType", rowspan:2,width:100});
	result.push({header:"签单净保费(元)", colspan:3+months});
	result.push({header:"保单质量", colspan:4});
	result.push({header:"本年保单承保边际贡献率",name:"toyearContriRate", rowspan:2,width:140,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	result.push({header:"保单获取成本率",name:"acquisiCostPolicy", rowspan:2,width:120,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	arr[0] = result;
	result = [];
	result.push({header:"本年累计" ,name:"toYearCumulative", width:80,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
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
	result.push({header:"去年保单满期赔付" ,name:"lastYaerPayment", width:140,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	result.push({header:"去年保单满期出险频度" ,name:"lastYearAcciFreq", width:140,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	});
	result.push({header:"本年保单满期赔付" ,name:"toyaerPayment", width:140,
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

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportMonthAgentInfo/queryReportMonthAgentInfo.do?"+$("#filterFrm").serialize());
	var month = $("#reportMoth").val();
	var realMonth = parseInt(month.substr(4,2));
	//alert('month:' + month + ',realMonth:' + realMonth);
	$("#tables").omGrid({
		colModel : setHand(realMonth)
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
				<td align="right"style="padding-left:15px"><span class="label">二级机构：</span></td>
				<td align="left">
					<input name="formMap['parentDept']" id="parentDept" class="sele"/>
				</td>
				<td  align="right" style="padding-left:15px"><span class="label">三级机构：</span></td>
				<td align="left"><input name="formMap['deptCode']" id="deptCode" class="sele"/></td>
				<td align="right" style="padding-left:15px"><span class="label">代理人名称：</span></td>
			   <td align="left"><input name="formMap['agentCode']" id="agentCode" /></td>
		       <td  align="right" style="padding-left:15px"><span class="label">渠道类型：</span></td>
			   <td align="left"><input name="formMap['agentType']" id="agentType" /></td>
			</tr>
			<tr>
			   <td align="right" style="padding-left:15px"><span class="label">协作人：</span></td>
			   <td align="left"><input name="formMap['supportCode']" id="supportCode" /></td>
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