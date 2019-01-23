<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>选择用户iframe</title>
<style type="text/css">
	body {font-size: 12px;}
</style>
<script type="text/javascript">
$(document).ready(function(){
	//初始化按钮菜单
	 $('#buttonbar').omButtonbar({
           	btns : [{label:"确认",
           			 	id:"updateButton",
           			 	icons : {left : '<%=_path%>/images/op-edit.png'},
           	 		 	onClick:function(){
           	 		 		var rows = $('#userGrid').omGrid("getSelections",true);
           	 		 		var row = eval(rows);
           	 		 		if(row.length != 1){
           	 		 			$.omMessageBox.alert({
	            	 		 	        content:'请选择一条记录',
	            	 		 	        onClose:function(value){
	            	 		 	        	return false;
	            	 		 	        }
           	 		 	        });
   	       	 		 		}else{
   	       	 		 			execFun(rows[0]);
           	 		 		}
           	 		 	}
           	        }
           	]
   });
	
	var bWidth =  $("body").width();
	//用户列表
    $('#userGrid').omGrid({
        dataSource : [],
        limit: 10,
        height: 330,
        width: bWidth - 10,
        colModel : [],
        autoFit : true,
        onRowDblClick : function(rowIndex,rowData,event){
        	execFun(rowData);
        }
    });
	
	//查询按钮
    $("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
    //初始化机构部门
	$('#parentDept').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
        		$('#parentDept').omCombo({value:eval(data)[1].value,readOnly : true});
        		$('#deptName').omCombo({
        			dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[1].value,
        			onSuccess  : function(data, textStatus, event){
        				if(data.length == 1){
        					$('#deptName').omCombo({value:eval(data)[0].value});
        					$('#deptMarket').val('').omCombo({
        						dataSource : "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+$("#deptName").val(),
        						onSuccess  : function(data, textStatus, event){
        							if(data.length == 1){
        								$('#deptMarket').omCombo({value:eval(data)[1].value});
        							}
        						}
        					});
        				}
        			}
        		});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#parentDept').omCombo('value');
            $('#deptName').omCombo('setData',[]);
            if(currentParentDept != ''){
	            $('#deptName').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptName').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
            $('#deptMarket').omCombo('setData',[]);
        },
        emptyText : "请选择",
		filterStrategy : 'anywhere',
		width : 110
    });
	$('#deptName').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptName').omCombo('value');
            if(currentParentDept != ''){
	            $('#deptMarket').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptMarket').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		width : 110
	});
	$('#deptMarket').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		width : 110
   });

   //下发层级
   $("#assignLevel").omCombo({
    	dataSource : "<%=_path%>/renewal/queryAssignLevelByRole.do",
    	onSuccess : function(data, textStatus, event){
    		$("#assignLevel").omCombo("value",data[1].value);
    	},
    	width : 110
    });
    
    setTimeout("searchSalesMan()", 300);
});

//确认下发
function execFun(rowData){
	var level = $("#assignLevel").omCombo("value");
	$("#assignLevel",window.parent.document).val(level);
	if( level == "1" ){
		$("#renewalBusiDept",window.parent.document).val(rowData.deptCode);
	}else if( level == "2" ){
		$("#renewalBusiDept",window.parent.document).val(rowData.deptCode);
	}else if( level == "3" ){
		$("#renewalBusiDept",window.parent.document).val(rowData.parentDeptCode);
		$("#renewalGroupCode",window.parent.document).val(rowData.groupCode);
	}else if( level == "4" ){
		$("#renewalBusiDept",window.parent.document).val(rowData.parentDeptCode);
		$("#renewalGroupCode",window.parent.document).val(rowData.groupCode);
		$("#employCode",window.parent.document).val(rowData.employCode);
	}
	//alert(JSON.stringify(rowData));
    window.parent.getIframeData(rowData);
}

//查询用户
function searchSalesMan(){
	var level = $("#assignLevel").omCombo("value");
	if(level == '1'){
		$('#userGrid').omGrid("setData","<%=_path%>/department/queryAllPrince.do?"+$("#userRoleForm").serialize());
			$('#userGrid').omGrid({
				colModel : [
							{header : '机构编码', name : 'deptCode' },
							{header : '机构名称', name : 'deptSimpleName' }
				            ]
			});
	}else if(level == '2'){
		
		if($("#parentDept").omCombo("value") != ""){
			$('#userGrid').omGrid("setData","<%=_path%>/department/queryAllPrince.do?"+$("#userRoleForm").serialize());
			$('#userGrid').omGrid({
				colModel : [
							{header : '机构编码', name : 'deptCode' },
							{header : '分公司机构编码', name : 'parentDeptCode' },
							{header : '机构名称', name : 'deptSimpleName' }
				            ]
			});
		}else{
			$.omMessageBox.alert({
		           content:'请选择分公司！'
		       });
		}
	}else if(level == '3'){
		
		if($("#deptName").omCombo("value") != ""){
			$('#userGrid').omGrid("setData","<%=_path%>/department/queryAllPrince.do?"+$("#userRoleForm").serialize());
			$('#userGrid').omGrid({
				colModel : [
							{header : '机构名称', name : 'deptCname' },
							{header : '团队Id', name : 'groupCode' },
							{header : '团队名称', name : 'groupName' }
				            ]
			});
		}else{
			$.omMessageBox.alert({
		           content:'请选择中支公司！'
		       });
		}
	}else if(level == '4'){
		
		if($("#deptName").omCombo("value") != ""){
			$('#userGrid').omGrid("setData","<%=_path%>/department/queryAllPrince.do?"+$("#userRoleForm").serialize());
			$('#userGrid').omGrid({
				colModel : [
							{header : '机构名称', name : 'deptCname' },
							{header : '团队编码', name : 'groupCode' },
							{header : '团队名称', name : 'groupName' },
							{header : '客户经理', name : 'salesmanCname' }
				            ]
			});
		}else{
			$.omMessageBox.alert({
		           content:'请选择中支公司！'
		       });
		}
	}else{
		$.omMessageBox.alert({
	           content:'请选择下发层级！'
	       });
	}
}

</script>
</head>
<body>
<div id="content" class="content">
	<form id="userRoleForm">
	<input type="hidden" name="deptCode" id="deptCode" value="" />
		<div  id="search-panel" >
			<table id="body-table">
			     <tr> 
			         <td align="right">下发层级：</td>
			         <td align="left"><input type="text" id="assignLevel" name="formMap['assignLevel']" /></td>
			         <td align="right">分公司：</td>
			         <td align="left"><input type="text" id="parentDept" name="formMap['parentDept']" /></td>
			         <td align="right">支公司：</td>
			         <td align="left"><input type="text" id="deptName" name="formMap['deptName']" /></td>
			         <td align="right">四级单位：</td>
			         <td align="left"><input type="text" id="deptMarket" name="formMap['deptMarket']" /></td>
			     </tr>
			     <tr>
			         <td colspan="8" align="right"><a class="om-button" id="button-search" onclick="searchSalesMan()">查询</a></td>
			     </tr>
			</table>
		</div>
		<div>
			 <div id="buttonbar" class="buttonbar"></div>
		     <table id="userGrid" ></table>
		</div> 
	</form>	
</div>
</body>
</html>