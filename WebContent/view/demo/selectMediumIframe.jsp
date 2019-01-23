<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<style>
.fontClass{
	font-size:12px;
	font-family: 微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun;
}
</style>
<title>选择合作机构iframe</title>
<% String twoDeptCode = request.getParameter("twoDeptCode"); %>
<% String threeDeptCode = request.getParameter("threeDeptCode"); %>
<script type="text/javascript">
var twoDept = '<%=twoDeptCode %>';
var threeDept = '<%=threeDeptCode %>';
$(document).ready(function(){
	$("#twoDeptCode").val(twoDept);
	$("#threeDeptCode").val(threeDept);
	//初始化按钮菜单
	 $('#buttonbar').omButtonbar({
         	btns : [{label:"选择",
         			 	id:"updateButton",
         			 	icons : {left : '<%=_path%>/images/op-edit.png'},
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
 	       	 		 		window.parent.fillMediumBackAndCloseDialog(rows[0]);
         	 		 		}
         	 		 	}
         	        }
         	]
    });
	
	//用户列表
    $('#tables').omGrid({
        method : 'POST',
        limit: 10,
        height: 335,
        width: 700,
        showIndex : true,
        colModel : [{header:"渠道代码",name:"channelCode",width:120,align:'center'},
                    {header:"个人代理人名称",name:"agentCname",width:100,align:'center',renderer: function(value, rowData , rowIndex) {
        	 			if(value==''){
        	 				return "----";
        	 			}else{
        	 				return value;
        	 			}
        	 		}},
                    {header:"合作机构名称",name:"mediumCname",width:260,align:'center',renderer: function(value, rowData , rowIndex) {
        	 			if(value==''){
        	 				return "----";
        	 			}else{
        	 				return value;
        	 			}
        	 		}},
                 	{header:"审核状态",name:"approve",width:80,align:'center',renderer: function(value, rowData , rowIndex) {
        	 			if(value=='1'){
        	 				return "已审核";
        	 			}else{
        	 				return "未审核";
        	 			}
        	 		}}
                	],
        onRowDblClick : function(rowIndex,rowData,event){
              window.parent.fillMediumBackAndCloseDialog(rowData);
        }
    });
	
    $("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
    //加载初始数据
	query();
});

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/medium/queryMediumGetSalesman.do?"+$("#filterFrm").serialize());
}

</script>
</head>
<body>
<form id="filterFrm">
		<div id="search-panel" class="search-panel">
			<table class="fontClass">
				<tr>
				    <td><input name="formMap['twoDeptCode']"  id="twoDeptCode"  type="hidden"/></td>
				    <td><input name="formMap['threeDeptCode']"  id="threeDeptCode"  type="hidden"/></td>
					<td  align="right"><span class="label">渠道代码：</span></td>
					<td><input name="formMap['channelCode']" id="channelCode" style="width:100px" /></td>
					<td  align="right"><span class="label">个人代理人名称：</span></td>
					<td><input type="text" name="formMap['agentCname']" id="agentCname" style="width:100px" />
					<td  align="right"><span class="label">合作机构名称：</span></td>
					<td><input type="text" name="formMap['mediumCname']" id="mediumCname" style="width:100px" />
					<td style="padding-left:30px;padding-top:5px" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" class="buttonbar"></div>
	<div id="tables" class="tables"></div>
</body>
</html>