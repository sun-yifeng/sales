<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>河北业绩追踪日报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
$(function(){	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"132px"});
	//加载如期控件
    $('#began').omCalendar();
    $('#end').omCalendar();
	
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
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel : tabHand,
		showIndex : false,
        height : topnum,
        method : 'POST',
        autoFit : true
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "报表管理  > 河北业绩追踪日报",
    	collapsible:true,
    	collapsed:false
    });	
	
	//加载初始数据
	query();
});
	 


//表头
var tabHand = 
[   {header:"核保日期",name:"updateDate", rowspan:2,width:180},
	{header:"客户类别",name:"vhlType", rowspan:2,width:300},
	{header:"险种大类",name:"primaryCProdName",rowspan:2,width:200},
	{header:"签单保费(元)",name:"nPrm", rowspan:2,width:120,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"三级机构",name:"cInterCde", rowspan:2,width:250},
	 
];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportDuty/queryReportDuty.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){									 
	window.open("<%=_path%>/reportDuty/queryDataToExcel.do?"+$("#filterFrm").serialize());
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">核保日期：</span></td>
					<td align="left" ><input type="text" name="formMap['began']" id="began" class="sele"/></td>
					<td align="right" ><span class="label">至</span></td>
					<td align="left" ><input type="text" name="formMap['end']" id="end" class="sele"/></td>
					<td align="right" style="padding-left:15px"><span class="label">客户类别：</span></td>
					<td align="left" ><input type="text" name="formMap['vhlType']" id="formMap['vhlType']" /></td>
					<td align="right" style="padding-left:15px"><span class="label">险种大类：</span></td>
					<td align="left" ><input type="text" name="formMap['primaryCProdName']" id="formMap['primaryCProdName']" /></td>
			   </tr>
			   <tr>
					<td align="right" ><span class="label">签单保费：</span></td>
					<td colspan="3" align="left" ><input type="text" name="formMap['nPrm']" id="formMap['nPrm']" /></td>
					<td colspan="4" align="right">
						<span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span>
					</td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>