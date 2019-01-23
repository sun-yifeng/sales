<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>考核职级查询</title>
<script type="text/javascript">
$(function(){
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//考核职级年月
	$('#calcMonth').omCalendar({
		  dateFormat : "yymm"
	});
	//二级机构
	$('#deptCodeTwo').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
        		$('#deptCodeTwo').omCombo({value:data[1].value,readOnly : true});
        		$('#deptCodeThree').omCombo({
        			dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[1].value,
        			onSuccess  : function(data, textStatus, event){
        				if(data.length == 2){
        					$('#deptCodeThree').omCombo({value:data[1].value,readOnly : true});
        					$('#deptCodeFour').val('').omCombo({
        						dataSource : "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+$("#deptCodeThree").val(),
        						onSuccess  : function(data, textStatus, event){
        							if(data.length == 2){
        								$('#deptCodeFour').omCombo({value:data[1].value,readOnly : true});
        							}
        						}
        					});
        				}
        			}
        		});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentDeptCodeTwo = $('#parentDept').omCombo('value');
            $('#deptCodeThree').omCombo('setData',[]);
            if(currentDeptCodeTwo != ''){
	            $('#deptCodeThree').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
	            $.ajax({
	        		url:"<%=_path%>/department/isThirdDepartment.do",
	        		type:"post",
	        		data:{},
	        		dataType:"json",
	        		async:false,
	        		success:function(data){
	        			if(data.length == 1){
	                		$("#deptCodeThree").omCombo({
	                			value : data[0].value,
	                			readOnly : true
	                		});
	                	}
	        		}
	        	});
            }else{
	        	$('#deptCodeThree').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
            $('#deptCodeFour').omCombo('setData',[]);
        },
        emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
    //三级机构
	$('#deptCodeThree').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
            var currentDeptCodeTwo = $('#deptCodeThree').omCombo('value');
            if(currentDeptCodeTwo != ''){
	            $('#deptCodeFour').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptCodeFour').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
	});
	//四级单位
	$('#deptCodeFour').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
    });
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:57});
	//
	$("#search-panel").omPanel({
    	title : "考核职级管理  > 历史考核职级查询",
    	collapsible:true,
    	collapsed:false
    });	
	//评分月份
	var date = new Date();
	date.setMonth(date.getMonth()-1, date.getDate());
	$('#calcMonth').omCalendar({dateFormat:'yymm'});
	$('#calcMonth').val($.omCalendar.formatDate(date,"yymm"));
	//列表高度
	var bdnum = $("body").offset().top + $("body").outerHeight();
  	var btnum = $("#filterFrm").offset().top + $("#filterFrm").outerHeight();
	var topnum = bdnum - btnum;
  	//分页表格
	dataGrid = $("#tables").omGrid({
		colModel : tabHand,
		showIndex : false,
        singleSelect : false,
        height : topnum,
        method : 'POST',
      	limit : 50
	});
	//初始化加载数据
	setTimeout("query()", 500) ; 
});

//表头
var tabHand = [ 
	{header : "考核年月",name : "calcMonth",rowspan : 2,width : 110},
	{header : "分公司",name : "deptNameTwo",rowspan : 2,width : 110},
	{header : "支公司",name : "deptNameThree",rowspan : 2,width : 110},
	{header : "四级单位",name : "deptNameFour",rowspan : 2,width : 110},
	//{header : "团队代码",name : "groupCode",rowspan : 2,width : 110},
	{header : "团队",name : "groupName",rowspan : 2,width : 200},
	{header : "销售人员",name : "salesmanName",rowspan : 2,width : 110},
	{header : "变更前",name : "beforeRankName",rowspan : 2,width : 110},
	{header : "变更后",name : "afterRankName",rowspan : 2,width : 110,align : 'center'},
	{header : "变更人",name : "changeUser",rowspan : 2,width : 120,align : 'center'},
	{header : "变更日期",name : "changeUser",rowspan : 2,width : 120,align : 'center'}
];

//查询操作
function query(){
	$("#calcMonthNew").val($("#calcMonth").val());
	$("#tables").omGrid("setData","<%=_path%>/reviewRank/queryReviewRankHistory.do?"+$("#filterFrm").serialize());
}
</script>
</head>
<body>
	<form id="filterFrm">
		<input type="hidden"  name="formMap['confirmStatus']" id="confirmStatus"  value="9"/>
		<div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">分公司：</span></td>
					<td><input class="sele" name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
					<td align="right"><span class="label">支公司：</span></td>
					<td><input class="sele" name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td><input class="sele" name="formMap['deptCodeFour']" id="deptCodeFour" /></td>
					<td style="padding-left:15px"><span class="label">考核年月：</span></td>
					<td><input class="sele" name="formMap['calcMonth']" id="calcMonth" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">销售团队：</span></td>
					<td><input type="text" name="formMap['groupName']" id="groupName"  style="width:158px"/></td>
					<td style="padding-left:27px"><span class="label">销售人员：</span></td>
					<td><input type="text" name="formMap['salesmanName']" id="salesmanName" style="width:158px"/></td>
					<td colspan="4" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>