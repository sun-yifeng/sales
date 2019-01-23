<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">html, body {width:100%;height:100%;padding:0;margin:0;overflow:hidden;}</style>
<title>客户经理考核评分查询</title>
<script type="text/javascript">
$(function(){
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//导航
	$("#search-panel").omPanel({
    	title : "考核评分管理  > 客户经理考核评分查询",
    	collapsible:true,
    	collapsed:false
    });
	//按钮
    $("#button-search").omButton({icons:{left:'<%=_path%>/images/search.png'},width:50});
    $("#button-excel").omButton({icons:{left:'<%=_path%>/images/excel.png'},width:50});
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
  	//分页表格
	$("#tables").omGrid({
		colModel : tabHand,
		showIndex : true,
        singleSelect : true,
        height : calcHeight1('button-search',30),
        method : 'POST',
      	limit : 100,
      	onRowDblClick : function(rowIndex,rowData,event){
          $("#calcDetail-dialog-model").omDialog({
            width : 900,
            height : $(window).height()-50,
            modal : true,
            resizable : false,
            onOpen : function(event) {
       	      $("#calcDetailIframe").attr("src","<%=_path%>/view/review/calcDetail.jsp?calcMonth="+rowData.calcMonth+"&deptCode="+rowData.deptCode+"&salesCode="+rowData.salesCode);
       	    }
          }).omDialog('open').css({'overflow-y':'hidden'});
      }
	});
  	//显示年月
	dateInitai();
	//加载数据
	setTimeout("query()","500");
});

//表头
var tabHand = [
	{header:"评分年月",name:"calcMonth",width:60,align:'center'},
	{header:"二级机构",name:"deptNameTwo",width:80},
	{header:"三级机构",name:"deptNameThree",width:100},
	{header:"四级单位",name:"deptNameFour",width:120},
	{header:"团队名称",name:"groupName",width:120},
	{header:"姓名",name:"salesName",width:60},
	{header:"工号",name:"employNo",width:70},
	{header:"当前职级",name:"rankName",width:100},
	{header:"在岗时间<br/>（月）",name:"frontMonth",width:60,align:'right'},
	{header:"当年标保计划<br/>(万元)", name:"normPremium",width:80,align:'right'},
	{header:"当年累计标保<br/>(元)", name:"yearSta",width:80,align:'right'},
 	{header:"标准保费时间<br/>进度达成率", name:"scheduleRate",width:80,renderer:function(v,r,i){
 		if(v=='%'||v==''){return '---'}else{return v+"%";}
	   },align:'right'},
	{header:"本年度已决未决<br/>赔款(元)",name:"thisYearClm",width:100,align:'right'},
	{header:"本年度再保后<br/>满期净保费(元)",name:"thisYearPro",width:100,align:'right'},
 	{header:"考核得分",name:"score",width:70,renderer:function(v,r,i){
        if(v=='%'||v==''){return '---'}else{return v;}
    },align:'right'}
];
//查询
function query(){
	yearMonth("0");
	$("#tables").omGrid("setData","<%=_path%>/reviewScore/queryReviewScore.do?"+$("#filterFrm").serialize());
}
//导出
function dataToExcel(){
	yearMonth("");
	$("#managerFlag").val("");
	window.open("<%=_path%>/reviewScore/excelPlyList.do?"+$("#filterFrm").serialize());
}
//初始化年月下拉框
function dateInitai(){
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth();
    //=================================年份===============================================
    var year1 = year - 10;
    var yearHtml = "";
        yearHtml += "<option value='' >请选择</option>";
    for (var i = 0; i < 11; i++){
        if((year1+i)==year){
            yearHtml+="<option value='"+(year1+i)+"' selected>"+(year1+i)+"</option>";
        }else{
            yearHtml+="<option value='"+(year1+i)+"'>"+(year1+i)+"</option>";
        }
    }
    $("#year").html(yearHtml);
    //=================================月份===============================================
    var monthHtml = "";
        monthHtml += "<option value='' >请选择</option>";
    for (var i = 1; i<=12; i++){
        var cMonth = i;
        if(i<10)
          cMonth="0"+cMonth;
        if(i==(month)){
            monthHtml+="<option value='"+cMonth+"' selected>"+cMonth+"</option>";
        }else{
            monthHtml+="<option value='"+cMonth+"'>"+cMonth+"</option>";
        }
    }
    $("#month").html(monthHtml);
    //=================================统计类型=============================================
    var calcHtml = "";
        calcHtml+="<option value='' >请选择</option>";
        calcHtml+="<option value='0' selected>当年累计</option>";
        calcHtml+="<option value='1'>当季累计</option>";
        calcHtml+="<option value='2'>当月累计</option>";
    $("#calcPeriod").html(calcHtml);
}
//日期变化
function yearMonth(flag){
  var year = $("#year").val();
  var month = $("#month").val();
  var calcMonth = year + month;
  $("#managerFlag").val(flag);
  $("#calcMonth").val(calcMonth);
}
</script>
</head>
<body>
	<div id="calcDetail-dialog-model" style="display:none;" title="计算过程">
		<iframe id="calcDetailIframe" frameborder="0" style="width:100%; height:90%; height:100%;" src="about:blank"></iframe>
	</div>
	<form id="filterFrm">
	    <input type="hidden" name="formMap['calcMonth']" id="calcMonth" value="" />
	    <input type="hidden" name="formMap['managerFlag']" id="managerFlag" value="" />
        <input type="hidden" name="formMap['confirmStatus']" id="confirmStatus" value="" />
		<div id="search-panel" class="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">二级机构：</span></td>
					<td><input class="sele" id="deptCodeTwo" name="formMap['deptCodeTwo']" type="text"/></td>
					<td align="right"><span class="label">三级机构：</span></td>
					<td><input class="sele" name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px" align="right"><span class="label">四级单位：</span></td>
					<td><input class="sele" type="text" name="formMap['deptCodeFour']" id="deptCodeFour"/></td>
				</tr>
				<tr>
				    <td align="right" style="padding-left:0px"><span class="label">评分年月：</span></td>
                    <td>
                       <select name="formMap['year']" id="year" style="width:70px" onChange=""></select>年
                       <select name="formMap['month']" id="month" style="width:70px" onChange=""></select>月
                    </td>
					<td style="padding-left:15px" align="right"><span class="label">姓名：</span></td>
					<td><input type="text" name="formMap['salsmanName']" id="salsmanName" /></td>
					<td style="padding-left:15px" align="right"><span class="label">工号：</span></td>
					<td><input type="text" name="formMap['salesmanCode']" id="salesmanCode" /></td>
					<td align="right" colspan="4"><span id="button-search" onclick="query()">查询</span><span id="button-excel" onclick="dataToExcel()">导出</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables" class="tables"></div>
</body>
</html>