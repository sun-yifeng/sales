<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>销售助理维护</title>
<%String virtualId=request.getParameter("virtualId"); %>
<script type="text/javascript">
var virtualId='<%=virtualId%>';

$(function(){
	$("#virtualId").val(virtualId);
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//导航 
	$("#search-panel").omPanel({
    	title : "销售助理维护  > 历史修改记录",
    	collapsible:true,
    	collapsed:false
    });	
	//按钮
	$('#buttonbar').omButtonbar({
            	btns : [{label:"详细",
	            		     id:"addButton" ,
	            		     icons : {left : '<%=_path%>/images/add.png'},
	            		     onClick:function(){
	            	 		 		var rows = $('#tables').omGrid("getSelections",true);
	            	 		 		var row = eval(rows);
	            	 		 		if(row.length != 1){
	            	 		 			$.omMessageBox.alert({
		            	 		 	        content:'请选择一条记录',
		            	 		 	        onClose:function(value){
		            	 		 	        	return false;
		            	 		 	        }
	            	 		 	        });
	    	       	 		 		}else{
	    	       	 		 			var aa=row[0];
	            	 		 			window.location.href = "virtualDetail.jsp?historyId="+row[0].HISTORYID+"&virtualId="+virtualId;
	            	 		 		}
	            	 		 	}
            			}]
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
	//人员类别
	$('#salesmanType').omCombo({
        dataSource : <%=getCombo("salesmanType")%>,
        editable : false,
        emptyText : '请选择'
    });
    //按钮
    $("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
    $("#button-back").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
  	//列表高度
  	var bdnum = $("body").offset().top + $("body").outerHeight();
    var btnum = $("#buttonbar").offset().top + $("#buttonbar").outerHeight();
  	var topnum = bdnum - btnum;
    //分页表格
  	dataGrid = $("#tables").omGrid({
  		colModel:tabHand,
  		showIndex : false,
        singleSelect : false,
        height:topnum,
        method : 'POST',
        limit:200
  	});
	//查询列表
	window.setTimeout("query()",500);
});

//表头
var tabHand = [ 
	{header : "二级机构",name : "deptNameTwo",rowspan : 2,width : 100},
	{header : "三级机构",name : "deptNameThree",rowspan : 2,width : 100},
	{header : "四级单位",name : "deptNameFour",rowspan : 2,width : 140},
	{header : "非HR人员",name : "cname",rowspan : 2,width : 150,align:'center'},
	{header : "对应HR人员",name : "salesmanCname",width : 150,align:'center'},
	{header : "人员分类",name : "salesmanType",rowspan : 2,width : 120},
	{header : "身份证号",name : "certiryNo",rowspan : 2,width : 150},
	{header : "出生日期",name : "birthday",rowspan : 2,width : 80},
	{header : "入职时间",name : "enterDate",rowspan : 2,width : 80},
	{header : "结束时间",name : "endDate",rowspan : 2,width : 80},
	{header : "修改者",name : "updatedUser",rowspan : 2,width : 170},
	{header : "修改时间",name : "updatedDate",rowspan : 2,width : 150}
];

//查询操作
function query() {
	$("#tables").omGrid("setData","<%=_path%>/salesmanVirtual/SalesmanVirtualHistory.do?"+$("#filterFrm").serialize());
}
//返回
function back(){
	window.location.href="virtual.jsp";
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">二级机构：</span></td>
					<td><input class="sele"  name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
					<td align="right"><span class="label">三级机构：</span></td>
					<td><input class="sele"  name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td><input class="sele" name="formMap['deptCodeFour']" id="deptCodeFour" /></td>
					<td style="padding-left: 15px;"><span class="label">人员分类：</span></td>
					<td><input class="sele" type="text" name="formMap['salesmanType']" id="salesmanType"/></td>
				</tr>	
				<tr>	
					<td style="padding-left:15px"><span class="label">非HR人员姓名：</span></td>
					<td><input type="text" name="formMap['cname']" id="cname"/></td>
					<td style="padding-left:15px"><span class="label">对应HR人员姓名：</span></td>
					<td><input type="text" name="formMap['salesmanCname']" id="salesmanCname"/>
					<input style="display:none" type="text" name="formMap['virtualId']" id="virtualId"/></td>
		            <!-- 			
		            <td style="padding-left:15px"><span class="label">人员工号：</span></td>
					<td><input type="text"   name="formMap['employCode']" id="employCode"  style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">人员代码：</span></td>
					<td><input type="text"   name="formMap['virtualId']" id="virtualId"  style="width:158px"/></td> 
					-->	
					<td colspan="6" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-back" onclick="back()">返回</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>