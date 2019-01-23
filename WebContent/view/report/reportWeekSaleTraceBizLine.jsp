<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="static com.sinosafe.xszc.report.constant.Constant.JSON" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>整体业绩进度追踪周报（分业务线）</title>
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
    
  	//报表日期（周报）
  	var time = new Date();
  	time.setDate(time.getDate() - time.getDay()-7);
  	$('#reportWeekBng').omCalendar({
  		disabledDays : [1,2,3,4,5,6],
  	    dateFormat : "yy-mm-dd",
  		editable : false,
  	    onSelect : function(date,event){
  	    	time.setTime(date.getTime()+(24*6*3600*1000));
  	    	$('#reportWeekEnd').val($.omCalendar.formatDate(time,"yy-mm-dd"));
  	    }
  	});
  	$('#reportWeekBng').omCalendar('setDate',time);
  	$('#reportWeekBng').val($.omCalendar.formatDate(time,"yy-mm-dd"));
  	time.setDate(time.getDate() - time.getDay()+6);
  	$('#reportWeekEnd').val($.omCalendar.formatDate(time,"yy-mm-dd"));
  	$('#reportWeekEnd').omCalendar({
  		disabledDays : [1,2,3,4,5,6,7],
  	    dateFormat : "yy-mm-dd",
  		editable : false,
  		disabled : false
  	});

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
    	title: "报表管理  > 整体业绩追踪周报（分业务线）",
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
	$("#bizLine").omCombo({
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
    {header:"业务线", name:"bizLine", equal:true},
    {header:"保费计划(元)", name:"premiumPlan"},
    {header:"本年累计保费收入（元）", name:"yearIncome"},
    {header:"保费计划达成率", name:"premiumPlanRate",percent:true},
    {header:"时间进度达成率", name:"schedulePlanRate",percent:true},//6
    {header:"保费收入（元）"},
    {header:"签单净保费（元）"},
    {header:"本年保单再保后承保年度制满期赔付率</br>（不含间接理赔费用）"},
    {header:"上年保单再保后承保年度制满期赔付率</br>（不含间接理赔费用）"}, //10
    //第2行
    {header:"前第三周", name:"lastThreeWeekIncome"},
    {header:"前第二周", name:"lastTwoWeekIncome"},
    {header:"前一周", name:"lastWeekIncome"},
    {header:"本周", name:"weekIncome"},
    //
    {header:"前第三周", name:"lastThreeWeekSign"},
    {header:"前第二周", name:"lastTwoWeekSign"},
    {header:"前一周", name:"lastWeekSign"},
    {header:"本周", name:"weekSign"},
    //
    {header:"上周", name:"toyearPayPremium",percent:true},
    {header:"本周", name:"lastYearPayPremium",percent:true},
    {header:"上周", name:"toYearPayPremiumLw",percent:true},
    {header:"本周", name:"lastYearPayPremiumLw",percent:true}, //22 
    //
    {header:"报表日期", name:"reportWeek",equal:true,hide:true}
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
	{header:tableCols[4].header,name:tableCols[3].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[5].header,name:tableCols[3].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[6].header,name:tableCols[3].name,rowspan:2,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[7].header,colspan:4},
	{header:tableCols[8].header,colspan:4},
	{header:tableCols[9].header,colspan:2},
	{header:tableCols[10].header,colspan:2}
   ],
   //第2行
   [
	{header:tableCols[11].header,name:tableCols[11].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[12].header,name:tableCols[12].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[13].header,name:tableCols[13].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[14].header,name:tableCols[14].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[15].header,name:tableCols[15].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[16].header,name:tableCols[16].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[17].header,name:tableCols[17].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[18].header,name:tableCols[18].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[19].header,name:tableCols[19].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[20].header,name:tableCols[20].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[21].header,name:tableCols[21].name,width:150,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[22].header,name:tableCols[22].name,width:150,renderer:function(v,r,i){return alignCell(v);}}
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

</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_WEEK_SALE_TRACE_BUIS"/>
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportWeekSaleTraceBizLine"/>
		<div id="search-panel">
			<table >
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">分公司：</span></td>
					<td><input name="formMap['parentDept']" id="parentDept" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">业务线：</span></td>
					<td><input type="text" name="formMap['bizLine']" id="bizLine" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">开始时间：</span></td>
					<td><input type="text" name="formMap['reportWeekBng']" id="reportWeekBng" value="" class="sele"/></td>
					<td style="padding-left:15px" align="right"><span class="label">结束时间：</span></td>
					<td><input type="text" name="formMap['reportWeek']" id="reportWeekEnd" value="" class="sele"/></td>		
					
				</tr>
				<tr>
				<td  colspan="8" style="padding-left:15px;" align="right"><span id="button-search" onclick="query(1)">查询</span><span id="button-dataToExcel" onclick="query(2)">导出Excel</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>