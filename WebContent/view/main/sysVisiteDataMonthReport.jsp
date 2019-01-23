<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>访问记录数据报表</title>
<style type="text/css">
${demo.css}
</style>
		<script type="text/javascript">
		var dataList = null;
		$(function(){
			//按钮样式
			$("#button-search").omButton({icons : {left:'<%=_path%>/images/search.png'},width:50});
			//加载日期
			loadMonth();
			reloadData();
		});
		
		//重新加载数据
		function reloadData(){
			loadReport();
			queryTable();
		}
		
		//查询表格
		function queryTable(){
			var year = $("#year").val();
			var month = $("#month").val();
			var actionDate = year+month;
			$('#tables').omGrid({
				limit : 0,
				height : 70,
		        showIndex : true,
		        method : 'post',
				colModel:getTableHead(),
			    dataSource:"<%=_path%>/userAccessRecord/queryDataVisitReportList.do?actionDate="+actionDate
			});
		}
		
		//加载图片显示
		function loadReport(){
			var year = $("#year").val();
			var month = $("#month").val();
			var actionDate = year+month;
			var windowHeight = $(window).height();
			$("#chartArea").height(windowHeight-150);
			var categories = null;
			var countData  = null;
			$.ajax({ 
				url: "<%=_path%>/userAccessRecord/queryDataVisitReport.do",
				type:"post",
				data:{actionDate:actionDate},
				async: false, 
				dataType: "json",
				success: function(jsonData){
					categories = new Array(jsonData.length);
					countData  = new Array(jsonData.length);
					dataList   = jsonData;
					$.each(jsonData,function(i,item){
						categories[i] = item.modelClass;
						countData[i] = item.count;
					});
					
					$('#chartArea').highcharts({
			            chart: {
			                type: 'column'
			            },
			            title: {
			                text: '运行记录之数据访问报表'
			            },
			            xAxis: {
			                categories:categories
			            },
			            yAxis: {
		                    title: {
		                        text: '访问次数'
		                    }
		                },
			            credits: {
			                enabled: false
			            },
			            series: [{
			                name: '访问次数',
			                data: countData,
			                dataLabels: {
		                        enabled: true,
		                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || '#5c7a29'
		                    }
			            }]
			        });
				}
			});
		}
		
function getTableHead(){
	var colModel = [[]];
	$.each(dataList,function(i,item){
		colModel[0].push({header:item.modelClass,name:item.modelClass,width:125, align:'center'});
	});
	return colModel;
}

//加载月份
function loadMonth(){
	var curDate = new Date();
	var year = curDate.getFullYear();
	var month = curDate.getMonth();
	//=================================年份===============================================
	var yearHtml = "<option value=''>请选择</option>";
	for ( var i = 0; i < 11; i++) {
		if((year-10+i)==year){
			yearHtml+="<option value='"+(year-10+i)+"' selected>"+(year-10+i)+"</option>";
		}else{
			yearHtml+="<option value='"+(year-10+i)+"'>"+(year-10+i)+"</option>";
		}
	}
	$("#year").html(yearHtml);
	//=================================月份===============================================
	var monthHtml = "<option value=''>请选择</option>";
	for ( var i = 0; i<=month; i++) {
		var cMonth = i+1;
		if(cMonth<10){
			cMonth="0"+cMonth;
		}
		if(i==(month)){
			monthHtml+="<option value='"+cMonth+"' selected>"+cMonth+"</option>";
		}else{
			monthHtml+="<option value='"+cMonth+"'>"+cMonth+"</option>";
		}
	}
	$("#month").html(monthHtml);
}
</script>
<script src="<%=_path%>/core/js/ref/highchart/highcharts.js"></script>
<script src="<%=_path%>/core/js/ref/highchart/modules/exporting.js"></script>
</head>
<body>
	<form id="filterFrm">
	        <input type="hidden" name="formMap['impType']"  value="1" >
	        <input type="hidden" name="formMap['versionId']" id="versionId" value="${param.versionId }" >
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">月份：</span></td>
					<td>
					       年
					   <select  name="formMap['year']" id="year" style="width:70px">
					      <option value="">请选择</option>
					   </select>
					       月
					   <select name="formMap['month']" id="month" style="width:70px">
					      <option value="">请选择</option>
					   </select>
					</td>
					<td align="right" colspan="6"><span id="button-search" onclick="reloadData()">查询</span></td>
				</tr>
			</table>
	 </form>
	<div>
		<table id="tables"></table>
	</div>
	<!-- 图表 -->
	<div id="chartArea" style="width:99%;height:450px;border:1px solid gray">
	  
	</div>
</body>
</html>