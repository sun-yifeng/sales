<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>薪酬查询</title>
<script type="text/javascript">
$(function(){
	//业务线
	$('#bizLineCode').omCombo({
			dataSource :"<%=_path%>/lawDefine/getCurLineCode",
			emptyText  : '请选择',
   		    editable   : false
    });
	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});	
	
	//加载二级机构名称
	$('#deptCodeTwo').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#deptCodeTwo').omCombo({
				value:eval(data)[1].value,
				readOnly : true
			});
        	//query();
        },
        onValueChange : function(target, newValue, oldValue, event) {
            //取出第1个combo的当前值
            var currentParentDept = $('#deptCodeTwo').omCombo('value');
            $('#deptCodeThree').omCombo('setData',[]);
            if(currentParentDept != ''){
	            //从后台取出三级机构的数据并赋值给第2个combo
	            $('#deptCodeThree').val('').omCombo({
	            	dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+$("#deptCodeTwo").val(),
	            	onSuccess:function(data, textStatus, event){
	            		if(data.length == 2)
	                	$('#deptCodeThree').omCombo({
	        				value:eval(data)[1].value,
	        				readOnly : true
	        			});
	            		
	                }		
	            });
            }else{
	        	//初始级机构名称
	        	$('#deptCodeThree').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
        },
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	//初始化三级机构名称
	$('#deptCodeThree').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "薪酬管理  > 薪酬查询",
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
		showIndex : true,
        singleSelect : true,
        height : topnum,
        method : 'POST',
      	limit : 100,
      	onRowDblClick : function(rowIndex,rowData,event){
          $("#calcDetail-dialog-model").omDialog({
            width : 900,
            height : $(window).height()-50,
            modal : true,
            resizable : false,
            onOpen : function(event) {
       	      $("#calcDetailIframe").attr("src","<%=_path%>/view/review/calcDetail.jsp?calcMonth="+rowData.calcMonth+"&deptCode="+rowData.deptCodeTwo+"&salesCode="+rowData.salesmanCode);
       	    }
          }).omDialog('open').css({'overflow-y':'hidden'});
      }
	});
	//初始化加载数据
	 setTimeout("query()", 500) ; 
});

//表头
var tabHand = [ 
	{header : "计算年月",name : "calcMonth",width:60,align:'center'},
	{header : "分公司",name : "deptNameTwo",rowspan : 2,width : 100},
	{header : "支公司",name : "deptNameThree",rowspan : 2,width : 120},
	{header : "四级单位",name : "deptNameFour",rowspan : 2,width : 130},
	{header : "团队",name : "groupName",rowspan : 2,width : 150},
	{header : "销售人员",name : "salesmanName",rowspan : 2,width : 120},
	{header : "当前职级",name : "rankName",rowspan : 2,width : 100},
	{header : "入司时间",name : "companyDate",rowspan : 2,width : 80},
	{header : "入职时间",name : "positionDate",rowspan : 2,width : 80},
	{header : "固定工资(元)",name : "salaryFixed",rowspan : 2,width : 80,renderer:function(v,r,i){
	   if(v == '') {
	         v = '---';
	       }
	      return '<div style="text-align:center;">' + v + '</div>';}
	   },
	{header : "绩效工资(元)",name : "salaryPerform",rowspan : 2,width : 80,renderer:function(v,r,i){
	   if(v == '') {
	       v = '---';
	     }
	    return '<div style="text-align:center;">' + v + '</div>';}
	   },
	
	{header : "基本工资(元)",name : "salaryBase",rowspan : 2,width : 80,renderer:function(v,r,i){
	   if(v == '') {
	       v = '---';
	     }
	    return '<div style="text-align:center;">' + v + '</div>';}
	   },
 	{header : "津贴(元)",name : "salaryBenefit",rowspan : 2,width : 80,renderer:function(v,r,i){
	   if(v == '') {
	       v = '---';
	     }
	    return '<div style="text-align:center;">' + v + '</div>';}
	   },
	{header : "合计(元)",name : "salaryTotal",rowspan : 2,width : 80,renderer:function(v,r,i){
	   if(v == '') {
	       v = '---';
	     }
	    return '<div style="text-align:center;">' + v + '</div>';}
	 }
];
//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reviewSalary/queryDataToExcel.do?"+$("#filterFrm").serialize());
}
//查询操作
function query(){
	$("#calcMonthNew").val($("#calcMonth").val());
	$("#tables").omGrid("setData","<%=_path%>/reviewSalary/queryReviewSalary.do?"+$("#filterFrm").serialize());
}
</script>
</head>
<body>
	<div id="calcDetail-dialog-model" style="display:none;" title="计算过程">
		<iframe id="calcDetailIframe" frameborder="0" style="width:100%; height:90%; height:100%;" src="about:blank"></iframe>
	</div>
	<form id="filterFrm">
		<input type="hidden"  name="formMap['confirmStatus']" id="confirmStatus"  value="0"/>
		<div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">分公司：</span></td>
					<td><input class="sele" name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
					<td align="right"><span class="label">支公司：</span></td>
					<td><input class="sele" name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">员工代码：</span></td>
					<td><input type="text" name="formMap['salesmanCode']" id="salesmanCode"/></td>
					<td style="padding-left:15px"><span class="label">员工姓名：</span></td>
					<td><input type="text" name="formMap['salesmanName']" id="salesmanName"/></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">计算年月：</span></td>
					<td><input class="sele" type="text" name="formMap['calcMonth']" id="calcMonth"/></td>
					<td colspan="4" style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>