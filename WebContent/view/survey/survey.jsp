<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ page import="com.hf.framework.service.security.CurrentUser" %>  
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>市场调研</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
$(function(){	
     $('#insertMonth').omCalendar({
         dateFormat : "yy-mm"
     });
     
     $(".sele").css({"width":"130px"});
 	
 	var btInput = $("#buttonbar");
   	var btOffset = btInput.offset();
   	var btnum = btOffset.top+btInput.outerHeight()+72;
   	var bdInput = $("body");
 	var bdOffset = bdInput.offset();
 	var bdnum = bdOffset.top+bdInput.outerHeight();
 	var topnum = bdnum - btnum;
   	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
 	  	topnum = topnum + 2;
     }
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel:tabHand,
		showIndex : false ,
		singleSelect : false,
        height:topnum,
        method : 'POST',
        onRefresh: function(nowPage, pageRecords, event){
        	$(".op-btn").omButton({
        		onClick : function(event){
        			window.location.href = "<%=_path%>/view/survey/surveyQuery.jsp?pkId="+this.attr("id");
        		}
        	});
        }
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%><%=_path%>/images/detail.png'},width:50});
	$("#button-add").omButton({icons : {left : '<%=_path%>/images/add.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "市场调研管理  > 市场调研",
    	collapsible:true,
    	collapsed:false
    });	
	
	//加载二级机构名称
	$('#deptCode').omCombo({
        dataSource :  "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2){
        		$('#deptCode').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
        },
        emptyText : '请选择'
    });
	//初始化按钮菜单
	$('#buttonbar').omButtonbar({
       	btns : [{label:"新增",
         		     id:"addButton" ,
         		     icons : {left : '<%=_path%>/images/add.png'},
         	 		 onClick:function(){
       	 			 	window.location.href = "surveyAdd.jsp";
       	 			 }
       		     },
		 {separtor:true},
		 {label:"详情",
		 	id:"queryButton",
		 	icons : {left : '<%=_path%>/images/detail.png'},
		 	onClick:function(){
		 			var rows = $('#tables').omGrid("getSelections",true);
			 		var row = eval(rows);
			 		if(row.length == 0 && row.length != 1){
			 			 $.omMessageBox.alert({
			 	            content: '请选择一条记录查看'
			 	        });
			 			return false;
			 		}else if(row.length > 1){
			 			$.omMessageBox.alert({
			 	            content: '一次只能查看一条数据'
			 	        });
			 			return false;
			 		}else{
			 			window.location.href = "surveyQuery.jsp?pkId="+row[0].pkId;
			 		}
		 		}
		 	},
			{separtor:true},
		 	{label:"删除",
    		     id:"deleteButton" ,
    		     icons : {left : '<%=_path%>/images/remove.png'},
    	 		 onClick:function(){
	  	 			var rows = $('#tables').omGrid("getSelections",true);
	  	 			var row = eval(rows);
	  	 			//alert(JSON.stirngify(row));
			 		if(row.length == 0 && row.length != 1){
			 			 $.omMessageBox.alert({
			 	            content: '请选择一条记录'
			 	        });
			 			return false;
			 		}else{
			 			
			 			var pkId="";
			 			for(var i=0;i<row.length;i++){
			 				pkId += ","+row[i].pkId;
			 			}
			 			$.ajax({ 
			 				url: "<%=_path%>/marketResInforMain/deleteMarketResInfor.do?pkId="+pkId.substring(1),
			 				type:"post",
			 				async: false, 
			 				dataType: "html",
			 				beforeSend : function(jqXHR, settings) {
			 					// 显示请求处理等待动画
			 					$.omMessageBox.waiting( {
			 						title: "请稍候",
			 		                content: "服务器正在处理您的请求，请稍候..."
			 				    } );
			 				},
			 				success: function(data){
			 					if(data){
			 						$.omMessageBox.alert({
			 			                type:'success',
			 			                title:'成功',
			 			                content:'删除成功'
			 			            });
			 					}else{
			 						$.omMessageBox.alert({
			 							type:'error',
			 			                title:'失败',
			 			                content:'删除失败'
			 			            });
			 					}
			 				}
			 			});
			 			$.omMessageBox.waiting('close');
	 					query();
			 		}
  	 			 }
  		     }
		]
	});
	
	 $.ajax({ 
			url: "<%=_path%>/common/findRolesInSystemByUserCode.do",
			type:"post",
			async: false, 
			dataType: "html",
			success: function(roleEname){
				//分司经理，分司人员管理，三级机构业管
				if(roleEname == "subDeptAdmin" || roleEname == "subDeptSalesman" || roleEname == "thirdDeptBusiMana" ){
					$("#deleteButton").parent().parent().hide();
				}else if(roleEname == "thirdDeptMiddle"){ //中支总
					$("#deleteButton").parent().parent().hide();
					$("#addButton").parent().parent().hide();
				}else{
					$("#deleteButton").omButton("enable");
				}
			}
		});
	
		setTimeout("query()",500);
});


//表头
 var tabHand = [
	{header:"机构",name:"deptCode", rowspan:2,width:593,
		renderer : function(value, rowData , rowIndex) {
			return value.substr(value.indexOf("-")+1);
		}},
	{header:"统计月份",name:"insertMonth", rowspan:2,width:593},
	/* {header:"操作", name:"checkSurvey",colspan:2,width:240,
			renderer : function(colValue, rowData , rowIndex) {
				return "<a href='javascript:void(0);' id='"+rowData.pkId+"' class='op-btn'>查看</a>";
		} }, */
]; 

function surveyAdd(){
	window.location.href = "<%=_path%>/view/survey/surveyAdd.jsp";
}

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/marketResInforMain/queryMarketResInforMain.do?"+$("#filterFrm").serialize());
}

</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table >
				<tr>
					<td style="padding-left:30px"align="right"><span class="label">机构名称：</span></td>
					<td><input name="formMap['deptCode']" id="deptCode" /></td>
					<td style="padding-left:30px"align="right"><span class="label">统计月份：</span></td>
					<td><input type="text" name="formMap['insertMonth']" id="insertMonth" /></td>
					<td colspan="2" style="padding-left:30px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
				<!-- <tr><td style="padding-left:30px;padding-top:10px;"><span id="button-add" onclick="surveyAdd()">新增</span></td></tr> -->
			</table> 
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>