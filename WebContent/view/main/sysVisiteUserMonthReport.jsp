<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户访问记录数据报表</title>
<script type="text/javascript">
$(function(){
	//按钮样式
	$("#button-search").omButton({icons:{left:'<%=_path%>/images/search.png'},width:50});
	loadMonth();
	query();
});

function query(){
	var year = $("#year").val();
	var month = $("#month").val();
	var actionDate = year+month;
	$("#actionDate").val(actionDate);
	var windowHeight = $(window).height();
	//业务线调整系数
	$('#tables').omGrid({
  	    limit : 0,
		height : windowHeight-150,
        showIndex : true,
        method : 'GET',
   		colModel:getTableHead(),
	    dataSource:"<%=_path%>/userAccessRecord/queryUserVisitReport.do?"+$("#filterFrm").serialize()
	});
}

function getTableHead(){
	var colModel = [[]];
	colModel[0].push({header:"用户",name:"realName",width:125, align:'center'});
	colModel[0].push({header:"访问模块",name:"modelClass",width:125, align:'center'});
	colModel[0].push({header:"访问次数",name:"count",width:125, align:'center'});
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
</head>
<body>
	<form id="filterFrm">
	        <input type="hidden" name="formMap['actionDate']" id="actionDate" value="" >
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
					<td style="padding-left:15px" align="right"><span class="label">访问人名字：</span></td>
					<td><input type="text" name="formMap['realName']" id="realName" /></td>
					<td align="right" colspan="6"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
	 </form>
	<div>
		<table id="tables"></table>
	</div>
</body>
</html>