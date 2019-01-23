<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>渠道发展情况月报（旧）</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
$(function(){	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"132px"});
	/* $('#reportMoth').omCalendar({
	    dateFormat : "yymm",
		editable : false
	}); */

	//报表月份
	/* var date = new Date();
	date.setDate(date.getDate());
	if(date.getMonth() === 0){
		date.setFullYear(date.getFullYear()-1, 11, 1);
		$("#reportMoth").val($.omCalendar.formatDate(date,'yymm'));
	}else{
		$("#reportMoth").val($.omCalendar.formatDate(date,'yymm')-1);
	} */
	
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
    	title : "报表管理  > 渠道发展情况月报",
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

var renderer=function(value, rowData , rowIndex) {
	return '<div style="text-align:right;">'+value+'</div>';
}

var tabHand = [
           	[{header:"分公司",name:"a", rowspan:2,width:150},
           	{header:"中支机构",name:"b", rowspan:2,width:150},
           	{header:"合作机构渠道数量", colspan:3},
           	{header:"个人代理人数量",colspan:3},
           	{header:"渠道数量（按照渠道性质分类统计）", colspan:9},
           	{header:"合作机构渠道本年度产能（年化）（年化产能=当年度实际产能/当年合作天数*本年度天数，当年度合作天数=当前日期-协议生效日期", colspan:10}],
           	
           	// 第二行；
           	[{header:"有效",name:"c", width:100,renderer : renderer},
           	{header:"失效",name:"d", width:100,renderer : renderer},
        	{header:"本年新增有效渠道",name:"e", width:100,renderer :renderer},
        	{header:"现有",name:"f", width:100,renderer : renderer},
        	{header:"新增",name:"g", width:100,renderer : renderer},
        	{header:"失效",name:"h", width:100,renderer : renderer},
        	{header:"银保",name:"i", width:100,renderer : renderer},
        	{header:"非银保金融渠道",name:"j", width:100,renderer :renderer},
        	{header:"邮政",name:"k", width:100,renderer : renderer},
        	{header:"车行",name:"l", width:100,renderer : renderer},
        	{header:"网代",name:"m", width:100,renderer : renderer},
        	{header:"其他兼业",name:"n", width:100,renderer : renderer},
        	{header:"专代",name:"o", width:100,renderer : renderer},
        	{header:"经纪",name:"p", width:100,renderer : renderer},
        	{header:"个代",name:"q", width:100,renderer : renderer},
        	{header:"0≤A＜10",name:"r", width:100,renderer : renderer},
        	{header:"10≤A＜50",name:"s", width:100,renderer : renderer},
        	{header:"50≤A＜100",name:"t", width:100,renderer : renderer},
        	{header:"100≤A＜300",name:"u7", width:100,renderer : renderer},
        	{header:"300≤A＜500",name:"v", width:100,renderer : renderer},
        	{header:"500≤A＜1000",name:"w", width:100,renderer : renderer},
        	{header:"1000≤A＜2000",name:"x", width:100,renderer : renderer},
        	{header:"2000≤A＜3000",name:"y", width:100,renderer : renderer},
        	{header:"3000≤A＜5000",name:"z", width:100,renderer : renderer},
        	{header:"5000≤A",name:"z1", width:100,renderer : renderer}]
           	];
           
          

//查询操作
function query(){
	//$("#tables").omGrid("setData","<%=_path%>/reportMonthAgentInfo/queryReportMonthAgentInfo.do?"+$("#filterFrm").serialize());
	// var month = $("#reportMoth").val();
	//var realMonth = parseInt(month.substr(4,2)); 
	
	$("#tables").omGrid({
		colModel :tabHand
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
				
		       <td align="right" >
					<span id="button-search" onclick="">查询</span><span id="button-dataToExcel" onclick="">导出Excel</span>
				</td>
			</tr>
			
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>