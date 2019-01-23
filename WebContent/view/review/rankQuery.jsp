<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.sinosafe.xszc.constant.*" %>
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
	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:57});
	//折叠面板
	$("#search-panel").omPanel({
		title : "考核职级管理  > 考核职级查询",
		collapsible:true,
		collapsed:false
	});	
	//二级机构
	$('#deptCodeTwo').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?"+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCodeTwo').omCombo({
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptCodeTwo').omCombo('value');
            $('#deptCodeThree').omCombo("setData",[]);
            if(currentParentDept != ''){
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
            $('#deptCodeFour').omCombo("setData",[]);
        },
        emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
    //三级机构
	$('#deptCodeThree').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
	        $('#deptCodeFour').omCombo('setData', "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+newValue);
		},
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCodeThree').omCombo({
    				value : data[1].value,
    				readOnly : true
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
		filterStrategy : 'anywhere',
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCodeFour').omCombo({
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        }
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
            height: $(window).height()-50,
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
	{header : "考核年月",name : "calcMonth",rowspan : 2, width : 70, align : 'center'},
	{header : "分公司",name : "deptNameTwo",rowspan : 2, width : 100},
	{header : "支公司",name : "deptNameThree",rowspan : 2, width : 120},
	{header : "四级单位",name : "deptNameFour",rowspan : 2, width : 150},
	{header : "团队",name : "groupName",rowspan : 2, width : 150},
	{header : "销售人员",name : "salesmanName",rowspan : 2, width : 140},
	{header : "当前职级",name : "rankName",rowspan : 2, width : 110},
	{header : "考核得分",name : "rankScore",rowspan : 2, width : 70, align : 'center',renderer:function(v,r,i){
	   if(v == '') {
         v = '---';
	   }
	   return '<div style="text-align:center;">' + v + '</div>';}
    },
	{header : "年化标准保费达成率",name : "premRate",rowspan : 2, width : 120, align : 'center',renderer:function(v,r,i){
	   if(v == '' || v=='%') {
       v = '---';
	   }
	   return '<div style="text-align:center;">' + v + '</div>';}
	},
	{header : "评定结果",name : "reviewResult",rowspan : 2,width : 70,align : 'center'},
	{header : "推荐职级",name : "recommendRankName",rowspan : 2,width : 120, renderer:function(v,r,i)
		{
		   return '<div style="text-align:center;">' + v + '</div>';
		}},
	{header : "评定结果(按客户经理考核)",name : "cusReviewResult",rowspan : 2,width : 150,align : 'center',renderer:function(v,r,i){
		if(v == '' || v=='%') {
		       v = '---';
			   }
			   return '<div style="text-align:center;">' + v + '</div>';
	}},
	{header : "推荐职级(按客户经理考核)",name : "cusRecommendRankName",rowspan : 2,width : 150},
	{header : "确认状态",name : "confirmStatus",rowspan : 2,width : 100,renderer:function(v,r,i){
		   if(v == '' || v=='%') {
		       v = '---';
			   }
			   return '<div style="text-align:center;">' + v + '</div>';
	}},
	{header : "确认职级",name : "confirmRankName",rowspan : 2,width : 150,renderer:function(v,r,i){
		   if(v == '' || v=='%') {
		       v = '---';
			   }
			   return '<div style="text-align:center;">' + v + '</div>';
	}},
	{header : "确认职级(按客户经理考核)",name : "cusConfirmRankName",rowspan : 2,width : 150,renderer:function(v,r,i){
		if(v == '' || v=='%') {
		       v = '---';
		}
			   return '<div style="text-align:center;">' + v + '</div>';
	}}
];
//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reviewRank/queryDataToExcel.do?"+$("#filterFrm").serialize()+"&identify=0");
}
//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reviewRank/queryReviewRank.do?"+$("#filterFrm").serialize());
}
</script>
</head>
<body>
	<div id="calcDetail-dialog-model" style="display:none;" title="计算过程">
		<iframe id="calcDetailIframe" frameborder="0" style="width:100%; height:90%; height:100%;" src="about:blank"></iframe>
	</div>
	<form id="filterFrm">
		<input type="hidden"  name="formMap['flag']" id="flag"  value="1"/>
		<div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">分公司：</span></td>
					<td><input class="sele"  name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
					<td align="right"><span class="label">支公司：</span></td>
					<td><input class="sele"  name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td><input class="sele"  name="formMap['deptCodeFour']" id="deptCodeFour" /></td>
					<td style="padding-left:15px"><span class="label">考核年月：</span></td>
					<td><input class="sele" name="formMap['calcMonth']" id="calcMonth"/></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">销售团队：</span></td>
					<td><input type="text"  name="formMap['groupName']"   id="groupName"  style="width:158px"/></td>
					<td style="padding-left:27px"><span class="label">人员代码：</span></td>
					<td><input type="text"   name="formMap['salesmanCode']"  id="salesmanCode"  style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">人员名称：</span></td>
					<td><input type="text"  name="formMap['salesmanName']"   id="salesmanName"  style="width:158px"/></td>
					<td colspan="2" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>