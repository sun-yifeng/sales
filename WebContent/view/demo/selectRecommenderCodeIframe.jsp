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
<title>选择推荐人iframe</title>
<script type="text/javascript">
$(document).ready(function(){
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
 	       	 		 		window.parent.fillRecommenderBackAndCloseDialog(rows[0]);
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
        colModel : [{header:"经办部门代码",name:"deptCode",width:80},
                    {header:"经办部门名称",name:"deptName",width:180},
                	{header:"推荐人代码",name:"employCode",width:100},
                	{header:"推荐人名称",name:"salesmanCname",width:80},
                	{header:"状态",name:"status",width:80}
                	],
        onRowDblClick : function(rowIndex,rowData,event){
              window.parent.fillRecommenderBackAndCloseDialog(rowData);
        }
    });
	
    $("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
    //加载初始数据
	query();
});

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/recommender/quertRecommenderByDeptCode.do?"+$("#filterFrm").serialize());
}
</script>
</head>
<body>
<form id="filterFrm">
		<div id="search-panel" class="search-panel">
			<table class="fontClass">
				<tr>
					<td style="padding-left:30px" align="right"><span class="label">推荐人代码：</span></td>
					<td><input name="formMap['employCode']" id="employCode" style="width:120px" /></td>
					<td style="padding-left:30px" align="right"><span class="label">推荐人名称：</span></td>
					<td><input type="text" name="formMap['salesmanCname']" id="salesmanCname" style="width:120px" />
					<input class="sele" type="hidden" name="formMap['certifyValid']" value="0" id="certifyValid" /></td>
					<td style="padding-left:30px;padding-top:5px" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" class="buttonbar"></div>
	<div id="tables" class="tables"></div>
</body>
</html>