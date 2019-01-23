

 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>远程出单点统计点业绩月报</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;

$(window).scroll(function (){
	$("#tables").omGrid('resize');
});

$(function(){	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"132px"});
	
	$('#reportMonth').omCalendar({
	    dateFormat : "yy-mm",
		editable : false
	});
	
	var date = new Date();
	date.setDate(date.getDate());
	if(date.getMonth() === 0){
		date.setFullYear(date.getFullYear()-1, 11, 1);
		$("#reportMonth").val($.omCalendar.formatDate(date,'yy-mm'));
	}else{
		date.setMonth(date.getMonth()-1, date.getDate());
		$("#reportMonth").val($.omCalendar.formatDate(date,'yy-mm'));
	}
	
	var btnum = $("#search-panel").offset().top+$("#search-panel").outerHeight()+80;
	var bdnum = $("body").offset().top+$("body").outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }
	
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel:tabHand,
		showIndex : true,
        height : topnum,
        method : 'POST'
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "渠道管理>远程出单点统计月报",
    	collapsible:true,
    	collapsed:false
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
            var currentDeptCodeTwo = $('#deptCodeTwo').omCombo('value');
            $('#deptCodeThree').omCombo('setData',[]);
            if(currentDeptCodeTwo != ''){
	            $('#deptCodeThree').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
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
	//初始化三级机构
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

	//初始化四级单位
	$('#deptCodeFour').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
    });
	
	//加载初始数据
	setTimeout("query()", "500");
});


//表头
var tabHand = [
	[{header:"二级机构",name:"deptNameTwo", rowspan:2,width:120},
	 {header:"三级机构",name:"deptNameThree", rowspan:2,width:150},
	 {header:"四级机构",name:"deptNameFour", rowspan:2,width:150},
	 {header:"合作机构渠道名称",name:"chennelName", rowspan:2,width:180},
	 {header:"远程出单点名称",name:"remoteNodeName", rowspan:2,width:250},
	 /* {header:"远程出单点</br>销售团队代码",name:"gourCode", rowspan:2,width:160}, */
	 {header:"设立时间",name:"foundDate", rowspan:2,width:100},
	 {header:"设立时预计保费(元)",name:"planFee", rowspan:2,width:120,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"保费收入(元)",name:"", colspan:8,width:160},
	 {header:"签单净保费(元)",name:"", colspan:3,width:160},
	 {header:"本年再保后承保年度制满期赔付率",name:"", colspan:2,width:160}],
	 [{header:"上月",name:"incomeLastMonth",width:100,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"本月",name:"incomeThisMonth",width:100,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"环比",name:"incomePeriodMonth",width:100,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"本年",name:"incomeThisYear",width:120,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"保费时间进度达成率",name:"incomePlanPercent",width:150,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"去年同期",name:"incomeLastYear",width:120,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"同比增长率",name:"incomeIncreateRate",width:100,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"年化保费",name:"incomeYear",width:120,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 
	 {header:"上月",name:"signLastMonth",width:100,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"本月",name:"signThisMonth",width:100,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"本年",name:"signThisYear",width:120,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 
	 {header:"上月",name:"claimLastMonth",width:100,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		},
	 {header:"本月",name:"claimThisMonth",width:100,
			renderer : function(value, rowData , rowIndex) {
				return '<div style="text-align:right;">'+value+'</div>';
			}
		}
	 ]
];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reportMonthRemotePolicy/queryReportMonthRemotePolicy.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reportMonthRemotePolicy/queryDataToExcel.do?"+$("#filterFrm").serialize());
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
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td><input name="formMap['deptCodeTwo']" id="deptCodeTwo" class="sele"/></td>
					<td style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptCodeThree']" id="deptCodeThree" class="sele"/></td>
					<td style="padding-left:15px"><span class="label">四级机构：</span></td>
					<td><input name="formMap['deptCodeFour']" id="deptCodeFour" class="sele"/></td>
					<td style="padding-left:15px"><span class="label">合作机构渠道名称：</span></td>
					<td><input type="text" name="formMap['chennelName']" id="chennelName" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">出单员：</span></td>
					<td><input type="text" name="formMap['employName']" id="employName" /></td>
					<td style="padding-left:15px"><span class="label">报表日期：</span></td>
					<td><input type="text"  name="formMap['reportMonth']"  id="reportMonth"  value=" " class="sele"/></td>
					<!-- <td style="padding-left:15px"><span class="label">出单员：</span></td>
					<td><input type="text" name="formMap['signCode']" id="formMap['signCode']" /></td> -->
					<td colspan="6" style="padding-left:30px;" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>