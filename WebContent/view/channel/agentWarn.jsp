<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>代理人合同资质预警</title>
<style>
.deptDropListTree {
	height: 250px;
    width: 152px;
	border: 1px solid #9AA3B9;
	overflow: auto;
	display: none;
	position: absolute;
	background: #FFF;
	z-index: 4;
}
</style>
<script type="text/javascript">
$(function(){
	 $("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	 $(".sele").css({"width":"131px"});
	 $("#deptCode").css({"background-color":"#fff"});
	
		var btInput = $("#buttonbar");
	  	var btOffset = btInput.offset();
	  	var btnum = btOffset.top+btInput.outerHeight()+87;
	  	var bdInput = $("body");
		var bdOffset = bdInput.offset();
		var bdnum = bdOffset.top+bdInput.outerHeight();
		var topnum = bdnum - btnum;
	  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
		  	topnum = topnum + 2;
	    } 
	 
	//初始化列表
	$("#tables").omGrid({
		colModel: tabHand,
		showIndex: true,
        height: topnum,
        method: 'POST',
        singleSelect: true,
      	limit:20
	});
	
	 //初始化按钮菜单
	 $('#buttonbar').omButtonbar({
            	btns : [{label:"新增",
	            		     id:"addButton" ,
	            		     icons : {left : '<%=_path%>/images/add.png'},
	            	 		 onClick:function(){
            	 			 	window.location.href = "agentWarnAdd.jsp";
            	 			 }
            			},
            			{separtor:true},
            	        {label:"修改",
            			 	id:"updateButton",
            			 	icons : {left : '<%=_path%>/images/op-edit.png'},
            	 		 	onClick:function(){
            	 		 		var rows = $('#tables').omGrid("getSelections",true);
            	 		 		var row = eval(rows);
            	 		 		if(row.length == 0){
            	 		 	        $.omMessageBox.alert({
            	 		 	            content: '请选择一条记录编辑！'
            	 		 	        });
            	 		 			return false;
            	 		 		}else if(row.length > 1){
            	 		 	        $.omMessageBox.alert({
            	 		 	            content: '每次只能操作一条数据！'
            	 		 	        });
            	 		 			return false;
            	 		 		}else{
            		            	window.location.href = "agentWarnEdit.jsp?warningId='"+row[0].warningId+"'";
            	 		 		}
            	 		 	}
            	        },
            			{separtor:true},
            	        {label:"删除",
            			 	id:"buttonDelete",
            			 	icons : {left : '<%=_path%>/images/remove.png'},
            	 		 	onClick:function(){
            	 		 		var rows = $('#tables').omGrid("getSelections",true);
            	 		 		var row = eval(rows);
            	 		 		if(row.length == 0){
            	 		 	        $.omMessageBox.alert({
            	 		 	            content: '请选择要删除的记录！'
            	 		 	        });
            	 		 			return false;
            	 		 		}else{
        	 		 				$.omMessageBox.confirm({
        		 				           title:'确认信息',
        		 				           content:'是否要删除代理人合同资质预警信息?',
        		 				           onClose:function(v){
        		 				               if(v){
        		 				            	   for(var i = 0; row && i < row.length; i++){
        		 				            		   Util.post("<%=_path%>/channelWarning/deleteChannelWarning.do",
        		            		        				"warningId="+row[i].warningId,
        						            					function(data) {
		        		            		        		});
		        		 				            	  }
	 		 		 							 //删除成功弹出提示框
					            				 $.omMessageBox.alert({
					            						type : 'success',
								 		 	            content: "删除代理人合同资质预警信息成功！"
								 		 	        });
	 		 		 							 //删除后刷新页面数据
				            					 query();
        		 				               }
        		 				            }
        		 				       });
            	 		 		}
            	 		 	}
            	        }
            	]
    });
	
	//树形机构，异步加载
    $("#deptDropListTree").omTree({
        dataSource : "<%=_path%>/department/queryDeptDropList.do",
	    simpleDataModel:true,
	    //
	    onBeforeExpand : function(node){
		  var nodeDom = $("#"+node.nid);
		  if(nodeDom.hasClass("hasChildren")){
			nodeDom.removeClass("hasChildren");
			$.ajax({
				url: '<%=_path%>/department/queryDeptDropList.do?parentCode='+node.id,
				method: 'POST',
				dataType: 'json',
				success: function(data){
					$("#deptDropListTree").omTree("insert", data, node);
				}
			});
		 }
		return true;
	   },
	   //触发选择事件时，回填数据到输入框
       onSelect : function(nodedata) {
         var ndata = nodedata, text = ndata.text, departCode = ndata.departCode;
         ndata = $("#deptDropListTree").omTree("getParent", ndata);
         while (ndata) {
	        //text = ndata.text + "-" + text;
	        ndata = $("#deptDropListTree").omTree("getParent", ndata);
         }
         
         $("#deptCode").val(departCode+"-"+text);
         
         //
         hideDropList();
       },
       onBeforeSelect : function(nodedata) {
         if (nodedata.children) {
	        return true;
         }
       },
       onSuccess: function(data){
   	     $('#deptDropListTree').omTree('expandAll');
   	   }
   });
    
   //点击下拉按钮
   $("#choose").click(function() {
      showDropList();
   });
   
   //点击输入框
   $("#deptCode").click(function() {
      showDropList();
   });
   
   //显示下来框
   function showDropList() {      
	  var cityInput = $("#deptCode");
   	  var cityOffset = cityInput.offset();
   	  var topnum = cityOffset.top+cityInput.outerHeight();
   	  var leftnum = cityOffset.left-1;
   	  if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	  topnum = topnum + 2;
      }
      $("#deptDropListTree").css({"margin-left": leftnum + "px","margin-top": topnum +"px"})
      						.show();
      //body绑定mousedown事件
      $("body").bind("mousedown", onBodyDown);
   }
   
   //隐藏下来框
   function hideDropList() {
      $("#deptDropListTree").hide();
      $("body").unbind("mousedown", onBodyDown);
   }
   
   //
   function onBodyDown(event) {
      if(!(event.target.id == "choose" || event.target.id == "deptDropList" || $(event.target).parents("#deptDropList").length > 0)) {
	       hideDropList();
        }
   }
 
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "销售渠道管理  > 代理人合同资质预警",
    	collapsible:true,
    	collapsed:false
    });	
	//加载是否禁用按钮方法
	isSelected();
	//初始化加载数据
	setTimeout("query()", 300) ;
});

//表头
var tabHand = [
               {header:"机构编码",name:"deptCode",width:120},
               {header:"机构名称",name:"deptName",width:120},
               {header:"个人代理人编码",name:"channelCode",width:120},
               {header:"个人代理人名称",name:"channelName",width:250},
               {header:"预警时间（天数）",name:"waringDay",width:100,align:'center'},
               {header:"预警信息接收人邮箱",name:"email",width:200},
               {header:"预警信息设定人",name:"createdUser",width:100,align:'center'}
           ];
           
//禁用操作数据的按钮
function isSelected(){
	$.ajax({ 
		url: "<%=_path%>/common/findRolesInSystemByUserCode.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			roleEname = data;
		}
	});
	if(roleEname == "subDeptAdmin"){
		$("#buttonDelete").parent().parent().hide();
	}else{
		$("#buttonDelete").omButton("enable");
	}
}

function setProvince(data){
	$('#deptCode').omCombo({
		value:data.value
	});
}

//查询操作
function query(){
	var deptCode = $("#deptCode").val();
	if(deptCode == '请选择'){
		$("#deptCode").val('');
	}else{
		$("#deptCode").val(deptCode.split('-')[0]);
	}
	$("#tables").omGrid("setData","<%=_path%>/channelWarning/queryChannelWarning.do?"+$("#filterFrm").serialize());
	$("#deptCode").val(deptCode);
}
</script>
</head>
<body>
	<div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
	<form id="filterFrm">
		<div id="search-panel">
			<input type="hidden" name="formMap['channelFlag']"  id="channelFlag"  value="1"/>
			<table>
					<tr>
						<td style="padding-left:15px" align="right"><span class="label">机构部门：</span></td>
						<td><span class="om-combo om-widget om-state-default"><input class="sele" id="deptCode" name="formMap['deptCode']" type="text" value="请选择" readonly="readonly" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" style="width:136px;" /><span id="choose" name="choose" class="om-combo-trigger"></span></span></td>
						<td style="padding-left: 15px;" align="right">代理人姓名：</td>
						<td><input name="formMap['channelName']"  id="channelName" /></td>
						<td style="padding-left: 15px;" align="right">代理人编码：</td>
						<td><input name="formMap['channelCode']"  id="channelCode"  style="width: 158px;"/></td>
						<td colspan="2" style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>