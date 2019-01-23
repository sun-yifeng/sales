<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务来源统计报表</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
$(function(){	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"132px"});
	
	$("#reportMonth").omCalendar({
		dateFormat : 'yymm',
		editable : true
	});
	
	var date = new Date();
	date.setDate(date.getDate());
	if(date.getMonth() === 0){
		date.setFullYear(date.getFullYear()-1, 11, 1);
		$("#reportMonth").val($.omCalendar.formatDate(date,'yymm'));
	}else{
		$("#reportMonth").val($.omCalendar.formatDate(date,'yymm')-1);
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
        limit : 0,
        method : 'POST'
	}); 
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "报表管理  > 业务来源统计报表",
    	collapsible:true,
    	collapsed:false
    });	
	
	//加载初始数据
	setTimeout("query()", "500");
	
	//加载二级机构名称
	$('#parentDept').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#parentDept').omCombo({
				value:eval(data)[1].value,
    			readOnly : true
			});
        },
        onValueChange : function(target, newValue, oldValue, event) {
            $('#deptName').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
        },
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	//初始化三级机构名称
	$('#deptName').omCombo({
		onSuccess:function(data, textStatus, event){
			if(data.length === 2){
				$('#deptName').omCombo("value",data[1].value);
        		$('#deptName').omCombo({
        			readOnly : true
        		});
        	}
		},
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		emptyText : '请选择'
	});
});

//表头
var tabHand = [
	[{header:"业务来源",name:"2222", rowspan:2,width:80,
		renderer : function(colValue, rowData, rowIndex){
			return rowData.type;
		}
	},
	{header:"业务来源",name:"cBsnsTyp", rowspan:2,width:100,
		renderer : function(colValue, rowData, rowIndex) {
			if(rowData.cChaType==null && rowData.cBsnsTyp==null){
				return "合计";
			}else{
				if(rowData.cBsnsTyp == "请选择"){
					return "其他业务";
				}else{
					return rowData.cBsnsTyp;
				}
			}
            return colValue;
        }
	},
	//{header:"业务线 ",name:"cBsnsTyp", rowspan:2,width:180},
	{header:"代理业务",name:"cChaType", rowspan:2,width:110,
		renderer : function(colValue, rowData, rowIndex) {
			if( rowData.cChaType==null && rowData.cBsnsTyp!=null ){
				if(rowData.cBsnsTyp=="19001直销业务"){
					return "直销业务";
				}else if(rowData.cBsnsTyp=="19003经纪业务"){
					return "经纪业务";
				}else if(rowData.cBsnsTyp=="请选择"){
					return "其他业务";
				}else if(rowData.cBsnsTyp=="19007电销业务"){
					return "电销业务";
				}else if(rowData.cBsnsTyp=="19008店面直销"){
					return "店面直销";
				}else{
					return "小计";
				}
			}else if( rowData.cChaType==null && rowData.cBsnsTyp==null  ){
				return "合计";
			}else{
				return colValue;
			}
            return colValue;
        }
	},
	{header:"企业财产保险(元)", colspan:3},
	{header:"家庭财产保险(元)",colspan:3},
	{header:"商业性机动车辆保险(元)",colspan:3},
	{header:"交强险(元)",colspan:3},
	{header:"工程保险(元)",colspan:3},
	{header:"责任保险(元)",colspan:3},
	{header:"信用险(元)",colspan:3},
	{header:"保证险(元)",colspan:3},
	{header:"船舶保险(元)",colspan:3},
	{header:"货物运输保险(元)",colspan:3},
	{header:"特殊风险保险(元)",colspan:3},
	{header:"农业保险(元)",colspan:3},
	{header:"健康险(元)",colspan:3},
	{header:"意外伤害保险(元)",colspan:3},
	{header:"其他险种(元)",colspan:3},
	{header:"合计(元)",colspan:3}],
	
	[{header:"保费收入" , name:"compTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"compCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"compRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"farmTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"farmCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"farmRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"busiTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"busiCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"busiRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"transTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"transCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"transRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"projectTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"projectCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"projectRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"dutyTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"dutyCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"dutyRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"creditTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"creditCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"creditRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"guaranteeTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"guaranteeCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"guaranteeRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"shipTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"shipCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"shipRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"cargoTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"cargoCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"cargoRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"specialTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"specialCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"specialRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"farmingTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"farmingCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"farmingRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"healthTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"healthCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"healthRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"hurtTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"hurtCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"hurtRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"otherTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"otherCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"otherRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"保费收入" , name:"totalTakeIn" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"手续费及佣金支出" , name:"totalCommision" , width:110,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
 	{header:"实付佣金" , name:"totalRealCommision" , width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	}]
];

//查询操作
function query(){
	$("#tables").omGrid({
		dataSource:"<%=_path%>/reportFoundationMedium/queryReportDayAgentChannel.do?"+$("#filterFrm").serialize(),
	    onSuccess:function(XMLHttpRequest,textStatus,errorThrown,event){
	    	setTimeout('$("#tables").MergeColumns()',1);
	    	setTimeout('$("#tables").MergeRows()',2);	
        }
	});
	//setTimeout('$("#tables").MergeColumns()',400);
	//setTimeout('$("#tables").MergeRows()',600);		
}

//导出Excel
function dataToExcel(){
	//$("#tables").omGrid("setData","<%=_path%>/reportFoundationMedium/queryDataToExcel.do?"+$("#filterFrm").serialize());
	window.open("<%=_path%>/reportFoundationMedium/queryDataToExcel.do?"+$("#filterFrm").serialize());
}

//
$.fn.MergeColumns = function() {
    return this.each(function() {
        for (var i = 2 ; i >= 0; i--) {  //获取表格td的数量进行循环  $(this).find('tr:first td').size() - 1
            var s = null;
            var prevTd = null;
            //alert(11);
            $(this).find('tr').each(function() {
                var td = $(this).find('td').eq(i);
                var s1 = td.text();
                if (s1 == s) { //相同即执行合并操作
                    td.hide(); //hide() 隐藏相同的td ,remove()会让表格错位 此处用hide
                    prevTd.attr('rowspan', prevTd.attr('rowspan') ? parseInt(prevTd.attr('rowspan')) + 1 : 2); //赋值rowspan属性
                }
                else {
                    s = s1;
                    prevTd = td;
                }
            });
        }
    });
};

//
$.fn.MergeRows = function() {
    return this.each(function() {
        $(this).find('tr').each(function() {
            var s = null;
            var prevTd = null;
            //alert($(this).find('td').size());
            for (var i = 0; i < 3; i++) {// 
                var td = $(this).find('td').eq(i);
                var s1 = td.text();
                if (s1 == s) { //相同即执行合并操作
                    td.hide(); //hide() 隐藏相同的td ,remove()会让表格错位 此处用hide
                    prevTd.attr('colspan', prevTd.attr('colspan') ? parseInt(prevTd.attr('colspan')) + 1 : 2); //赋值colspan属性
                }
                else {
                    s = s1;
                    prevTd = td;
                }
            }
        });
    });
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table >
				 <tr>
					<td style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td><input name="formMap['parentDept']" id="parentDept" class="sele"/></td>
					<td style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptName']" id="deptName" class="sele"/></td>
					<!-- <td style="padding-left:15px"><span class="label">组织单元：</span></td>
					<td><input type="text" name="formMap['deptUnit']" id="formMap['deptUnit']" /></td> -->
				<!--<tr>
					<td style="padding-left:15px"><span class="label">用工方式：</span></td>
					<td><input type="text" name="formMap['employMode']" id="formMap['employMode']" /></td>
					<td style="padding-left:15px"><span class="label">员工类别：</span></td>
					<td><input type="text" name="formMap['employType']" id="formMap['employType']" /></td>
					<td style="padding-left:15px"><span class="label">员工代码：</span></td>
					<td><input type="text" name="formMap['employCode']" id="formMap['employCode']" /></td>
				</tr> -->
					<!-- <td style="padding-left:15px"><span class="label">出单员：</span></td>
					<td><input type="text" name="formMap['signCode']" id="formMap['signCode']" /></td> -->
					<td style="padding-left:15px"><span class="label">查询时间：</span></td>
				<td><input name="formMap['reportMonth']" id="reportMonth" class="sele"/></td>
					<td style="padding-left:30px;" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="tables"></div>
	<table id="divTable" border=1px ></table>
</body>
</html>