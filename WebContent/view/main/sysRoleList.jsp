<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>用户角色查询</title>
<script type="text/javascript">
$(function(){
	//$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	
	
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
			emptyText : "请选择",
			valueField : 'value',
			inputField : 'text',
			filterStrategy : 'anywhere',
			onSuccess  : function(data, textStatus, event){
	    		if(data.length == 2){
	    			$('#deptCodeThree').omCombo({
	    				value : data[1].value,
	    				readOnly : true
	    			});
	        	}
	      }
			});
  
  //角色名称
  $("#roleCname").omCombo({
	  dataSource : "<%=_path%>/userRole/getRoleNames",
	  inputField:'value',
	  listAutoWidth : true,
	  editable: false,
	  emptyText : "请选择"
  });
		
  $("#status").omCombo({
	  dataSource : [{"text":"请选择","value":""},{"text":"有效","value":"1"},{"text":"失效","value":"0"},{"text":"锁定","value":"2"}],
	  editable : false,
	  value : '1',
   emptyText : '请选择'
  });
  
  $("#valid").omCombo({
	  dataSource : [{"text":"请选择","value":""},{"text":"有效","value":"1"},{"text":"失效","value":"0"}],
	  editable : false,
	  value : '1',
   emptyText : '请选择'
  });
    
    
	$("#button-search").omButton({icons:{left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons:{left : '<%=_path%>/images/op-edit.png'},width:57});
	//
	$("#search-panel").omPanel({
    	title : "系统管理  > 用户权限",
    	collapsible:true,
    	collapsed:false
    });	
	//列表高度
	var bdnum = $("body").offset().top + $("body").outerHeight();
  	var btnum = $("#filterFrm").offset().top + $("#filterFrm").outerHeight();
	var topnum = bdnum - btnum;
  	//分页表格
	dataGrid = $("#tables").omGrid({
		colModel : tabHand,
		showIndex : true,
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
	{header : "部门代码",name : "deptCode",rowspan : 2,width : 50},
	{header : "部门名称",name : "deptName",rowspan : 2,width : 100},
	{header : "用户姓名",name : "userCname",rowspan : 2,width : 100},
	{header : "用户域名",name : "userCode",rowspan : 2,width : 200},
	{header : "用户状态",name : "status",rowspan : 2,width : 100},
	{header : "权限状态",name : "valid",rowspan : 2,width : 100},
	{header : "角色名称",name : "roleCname",rowspan : 2,width : 200},
	{header : "机构分配时间",name : "createdDate",rowspan : 2,width : 150},
	{header : "权限开通时间",name : "openDate",rowspan : 2,width : 150},
	{header : "权限关闭时间",name : "closeDate",rowspan : 2,width : 150},
	{header : "操作人",name : "operator",rowspan : 2,width : 150}
];

//查询操作
function query(){
	$("#actionDateNew").val($("#actionDate").val());
	$("#tables").omGrid("setData","<%=_path%>/userRole/queryUserRoles.do?"+$("#filterFrm").serialize());
}

//导出数据
function dataToExcel(){
	 window.open("<%=_path%>/userRole/exportUserRoles.do?"+$("#filterFrm").serialize());
}

</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">二级机构：</span></td>
					<td><input class="sele" id="deptCodeTwo" name="formMap['deptCodeTwo']" type="text"/></td>
					<td align="right"><span class="label">三级机构：</span></td>
					<td><input class="sele" name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">角色名称：</span></td>
					<td><input class="sele" name="formMap['roleCname']" id="roleCname" /></td>
					<td style="padding-left:15px"><span class="label" >用户姓名：</span></td>
					<td><input name="formMap['userCname']" id="userCname" style="width:150px"/></td>
					</tr>
					<tr>
					<td style="padding-left:15px"><span class="label">用户域名：</span></td>
					<td><input name="formMap['userCode']" id="userCode" style="width:150px"/></td>
					<td style="padding-left:15px"><span class="label">用户状态：</span></td>
					<td><input  class="sele" name="formMap['status']" id="status"/></td>
					<td style="padding-left:15px"><span class="label">权限状态：</span></td>
					<td><input  class="sele" name="formMap['valid']" id="valid"/></td>
					<td colspan="4" align="right"><span id="button-search" onclick="query()">查询</span>
					<span id="button-dataToExcel" onclick="dataToExcel()">导出</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>