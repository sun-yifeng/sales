<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="static com.sinosafe.xszc.report.constant.Constant.JSON" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>整体业绩进度追踪月报（分业务线）</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
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
    
  	//报表月份
    $('#reportMonth').omCalendar({dateFormat: "yy-mm",editable: false});
  	var preDate = new Date();
  	preDate.setDate(preDate.getDate()-1);
  	$('#reportMonth').val($.omCalendar.formatDate(preDate,"yy-mm"));

    //报表表格
	dataGrid = $("#tables").omGrid({
		limit:10,
		colModel:tableHead,
		showIndex:true,
        height:topnum,
        method:'POST'
	});
	
	//按钮
	$("#button-search").omButton({icons: {left: '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons: {left: '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title: "报表管理  > 整体业绩追踪月报（分业务线）",
    	collapsible:true,
    	collapsed:false
    });	
	
	//加载二级机构名称
	$('#parentDept').omCombo({
        dataSource: "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#parentDept').omCombo({
				value:eval(data)[1].value,
    			readOnly: true
			});
        },
        onValueChange: function(target, newValue, oldValue, event) {
            $('#deptName').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
        },
        optionField: function(data, index) {
            return data.text;
		},
		emptyText: "请选择",
		filterStrategy: 'anywhere'
    });
  
	//初始化三级机构名称
	$('#deptName').omCombo({
		onSuccess:function(data, textStatus, event){
			if(data.length === 2){
				$('#deptName').omCombo("value",data[1].value);
        		$('#deptName').omCombo({
        			readOnly: true
        		});
        	}
		},
		valueField: 'value',
		inputField: 'text',
		filterStrategy: 'anywhere',
		emptyText: '请选择'
	});

	//业务线
	$("#buisType").omCombo({
		dataSource: <%=JSON("bizLine")%>,
		valueField: 'value',
		inputField: 'text',
		filterStrategy: 'anywhere',
		emptyText: '请选择'
	});
	
	setTimeout("query(1)", 500);
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"分公司", name:"parentDept", equal:true, dept:true},
    {header:"三级机构", name:"deptName", equal:true, dept:true},
    {header:"业务线", name:"buisType", equal:true},
    {header:"保费计划(元)", name:"premiumPlan"},
    {header:"保费收入（元）"},
    {header:"签单净保费（元）"},
    {header:"本年保单再保后承保年度制满期赔付率</br>（不含间接理赔费用）"},
    {header:"去年保单再保后承保年度制满期赔付率</br>（不含间接理赔费用）"}, //7
    //第2行
    {header:"前第三月", name:"lastThreeMonthIncome"},
    {header:"前第二月", name:"lastTwoMonthIncome"},
    {header:"前一月", name:"lastMonthIncome"},
    {header:"本月", name:"monthIncome"},
    {header:"本年", name:"yearIncome"},
    {header:"保费计划达成率", name:"premiumPlanRate", percent:true},
    {header:"保费计划时间进度达成率", name:"schedulePlanRate", percent:true},
    {header:"上年同期累计保费收入", name:"lastYearIncome"},
    {header:"同期保费增减值", name:"termIncreaseAmt"},
    {header:"同比增长率", name:"yearIncreaseRate", percent:true},
    {header:"前第三月", name:"lastThreeMonthSign"},
    {header:"前第二月", name:"lastTwoMonthSign"},
    {header:"前一月", name:"lastMonthSign"},
    {header:"本月", name:"monthSign"},
    {header:"本年", name:"yearSign"},
    {header:"上年同期签单净保费", name:"lastYearSign"},
    {header:"同期增减值", name:"signIncreaseAmt"},
    {header:"同比增长率", name:"signIncreaseRate", percent:true},
    {header:"上月", name:"toYearPayPremium", percent:true},
    {header:"本月", name:"lastYearPayPremium", percent:true},
    {header:"上月", name:"toYearPayPremiumLm", percent:true},
    {header:"本月", name:"lastYearPayPremiumLm", percent:true}, //29
    //
    {header:"报表月份", name:"reportMonth", equal:true, hide:true}
]);

function alignCell(value){
	if('---' === value){
	  return '<div style="text-align:center;">'+value+'</div>';
	}else{
	  return '<div style="text-align:right;">'+value+'</div>';
	}
}

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:100},
	//{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:100},
	{header:tableCols[2].header,name:tableCols[2].name,rowspan:2,width:100},
	{header:tableCols[3].header,name:tableCols[3].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[4].header,colspan:10},
	{header:tableCols[5].header,colspan:8},
	{header:tableCols[6].header,colspan:2},
	{header:tableCols[7].header,colspan:2}
   ],
   //第2行
   [{header:tableCols[8].header,name:tableCols[8].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[9].header,name:tableCols[9].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[10].header,name:tableCols[10].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[11].header,name:tableCols[11].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[12].header,name:tableCols[12].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[13].header,name:tableCols[13].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[14].header,name:tableCols[14].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[15].header,name:tableCols[15].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[16].header,name:tableCols[16].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[17].header,name:tableCols[17].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[18].header,name:tableCols[18].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[19].header,name:tableCols[19].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[20].header,name:tableCols[20].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[21].header,name:tableCols[21].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[22].header,name:tableCols[22].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[23].header,name:tableCols[23].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[24].header,name:tableCols[24].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[25].header,name:tableCols[25].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[26].header,name:tableCols[26].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[27].header,name:tableCols[27].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[28].header,name:tableCols[28].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[29].header,name:tableCols[29].name,width:150,renderer:function(v,r,i){return alignCell(v);}}
   ]
];

//查询或导出
function query(operType){
	$('#operType').val(operType);
	$('#tableCols').val(JSON.stringify(tableCols));
	var url = "<%=_path%>/reportCommon/queryReportList.do?"+$("#filterFrm").serialize();
	if (operType === 1) {
	   $("#tables").omGrid("setData", url);
	} else if (operType === 2) {
	   //window.open(url);
		$("#filterFrm").attr("method","post").attr("action", Util.appCxtPath + "/reportCommon/queryReportList.do").submit();
	} else {
       alert("操作类型错误！");
	}
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
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_MONTH_SALE_TRACE_BUIS"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportMonthSaleTraceBizLine"/>
		<div id="search-panel">
			<table >
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">分公司：</span></td>
					<td><input name="formMap['parentDept']" id="parentDept" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">业务线：</span></td>
					<td><input type="text" name="formMap['buisType']" id="buisType" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">报表月份：</span></td>
					<td><input type="text" name="formMap['reportMonth']" id="reportMonth"  value="" class="sele"/></td>
					<td style="padding-left:15px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>