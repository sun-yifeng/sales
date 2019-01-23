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
<title>查看计算过程日志iframe</title>
<% String twoDeptCode = request.getParameter("twoDeptCode"); %>
<% String threeDeptCode = request.getParameter("threeDeptCode"); %>
<% String taskId = request.getParameter("taskId"); %>
<script type="text/javascript">
var twoDept = '<%=twoDeptCode %>';
var threeDept = '<%=threeDeptCode %>';
var taskId = '<%=taskId %>';
$(document).ready(function(){
	$("#twoDeptCode").val(twoDept);
	$("#threeDeptCode").val(threeDept);
	
	//计算过程界面
	$("#rowDetail-dialog-model").omDialog({
		autoOpen:false,
		width : 400,
        height : 350,
        modal : true,
        resizable : false,
	});
	
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
    	title : '日志列表',
      	limit : 100,
      	width : 825,
      	height : 580,
		showIndex : true,
        method : 'GET',
        colModel : [
					{header:"日志级别",name:"logLevel",width:55,align:'center',renderer : function(value, rowData , rowIndex) {
						if(value == '-1')
							return "调试";
						else if(value == '0')
							return "信息";
						else if(value == '1')
							return "警告";
						else if(value == '2')
							return "异常";
						
					}},
                    {header:"程序名称",name:"funcName",width:190,align:'center'},
                    {header:"日志主题",name:"logSub",width:500,align:'left'}
                	],
    	 onRowClick:function(rowIndex,rowData,event){
    		 $("#logSub").val(rowData.logSub);
    		 $("#logMsg").val(rowData.logMsg);
    		 rowDetail();
         }

    });
	
	$("#logLevel").omCombo({
		dataSource:[{"text":"请选择","value":""},
		            {"text":"调试","value":"-1"},
		            {"text":"信息","value":"0"},
		            {"text":"警告","value":"1"},
		            {"text":"异常","value":"2"}],
        valueField : 'value',
   		inputField : 'text',
   		value : '1'		          
		
	});
	
    $("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
    //加载初始数据
	query();
});

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/lawManual/queryCalcLogs.do?taskId="+taskId+"&logLevel="+$("#logLevel").val());
}

function rowDetail(){
	$("#rowDetail-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
}
</script>
</head>
<body scroll="no">
<form id="filterFrm">
	<div id="rowDetail-dialog-model" overflow-y="hidden">
		<table>
			<tr>
				<td>日志主题：</td>
			</tr>
			<tr>
				<td>
					<textarea style="width:350px;height:90px" rows="2" id="logSub" readonly="readonly"></textarea>
				</td>
			</tr>
			<tr>
				<td>日志内容：</td>
			</tr>
			<tr>
				<td>
					<textarea style="width:350px;height:160px" rows="2" id="logMsg" readonly="readonly"></textarea>
				</td>
			</tr>
		</table>
	</div>
	<div id="search-panel" class="search-panel">
		<table>
			<tr>
				<td  align="right"><span class="label">日志级别：</span></td>
				<td><input name="formMap['logLevel']" id="logLevel" style="width:100px" /></td>
				<td style="padding-left:30px;padding-top:5px" align="right"><span id="button-search" onclick="query()">查询</span></td>
			</tr>
		</table>
	</div>	
</form>
<div style="overflow-y:auto; height:600px; width:875px;">
	<div id="tables" ></div>
</div>
</body>
</html>