<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>选择经办人iframe</title>
<%String deptCode = (String) request.getParameter("deptCode");%>
<script type="text/javascript">
$(document).ready(function(){
    //树形机构
	$("#selectUserTree").omTree({
		dataSource : '<%=_path%>/department/queryDeptDropList.do?deptCode='+'<%=deptCode%>',
		simpleDataModel:true,
		onBeforeExpand : function(node){
			var nodeDom = $("#"+node.nid);
			if(nodeDom.hasClass("hasChildren")){
				nodeDom.removeClass("hasChildren");
				$.ajax({
					url: '<%=_path%>/department/queryDeptDropList.do?parentCode='+node.id,
					method: 'POST',
					dataType: 'JSON',
					success: function(data){
						$("#selectUserTree").omTree("insert", data, node);
					}
				});
			}
			return true;
		},onSelect: function(node,event) {
            var url = encodeURI("<%=_path%>/department/queryUserByDeptCode.do?deptCode="+node.id);
            $("#userGrid").omGrid("setData", url);
            $("#deptCode").val(node.id);
		},onSuccess: function(data){
			$('#selectUserTree').omTree('expandAll');
			var url = encodeURI("<%=_path%>/department/queryUserByDeptCode.do?deptCode="+eval(data)[0].id);
            $("#userGrid").omGrid("setData", url);
            $("#deptCode").val(eval(data)[0].id);
		}
	});
	
	//初始化按钮菜单
	$('#buttonbar').omButtonbar({
          	btns : [{label:"选择",
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
  	       	 		 			window.parent.fillBackAndCloseDialog(rows[0]);
          	 		 		}
          	 		 	}
          	        }
          	]
    });
	
	//用户列表
    $('#userGrid').omGrid({
        limit: 10,
        height: 330,
        width: 485,
        colModel : [ {header : '姓名（工号）', name : 'salesmanCname', width : 150, align : 'left'}, 
                     {header : '员工状态', name : 'statusName', width : 100, align : 'left', renderer : function(colValue, rowData, rowIndex) {
                       if(colValue != '在职') {
	                       return '<span style="color:red;"><b>' + colValue + '</b></span>';
	                   } 
	                   return colValue;
                       }
                     },
                     {header : '机构名称（机构代码）', name : 'deptName', width : 150, align : 'left'},
                   ],
        onRowDblClick : function(rowIndex,rowData,event){
                        window.parent.fillBackAndCloseDialog(rowData);
                     }
    });
	
	//查询按钮
    $("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
});

//查询经办人
function query(){
	$("#userGrid").omGrid("setData", "<%=_path%>/department/queryUserByDeptCode.do?"+$("#selectSalesManFrm").serialize());
}
</script>
</head>
<body>
<div id="content" class="content">
<form id="selectSalesManFrm">
<input type="hidden" name="deptCode" id="deptCode" value="" />
<table id="body-table">
  <tr>
    <td class="left-panel" valign="top">
       <ul id="selectUserTree" style="overflow-y:auto; height:380px; width:180px;"></ul>
    </td>   
    <td class="center-panel" style="padding-left:5px;" valign="top">
       <div style="float:left; vertical-align:middle; font-size:12px;">
	       <div>查询条件（姓名或工号）：<input type="text" id="salesmanCname" name="salesmanCname"/><a class="om-button" id="button-search" onclick="query()">查询</a></div>
	       <div id="buttonbar" class="buttonbar"></div>
	       <table id="userGrid"></table>
	       <div>提示信息：在核心系统新增经办人，10分钟之后自动刷新到此页面。</div>
       </div>         
    </td>
  </tr>
</table>
</form>	
</div>
</body>
</html>