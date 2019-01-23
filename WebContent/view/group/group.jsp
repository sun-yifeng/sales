<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>团队维护</title>
<script type="text/javascript">
var flag = false;
//
$(function(){
	//
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
	$("#tables_member").omGrid({
     			 limit: 20,
     	         height: 400,
     			 colModel:tabHand_member,
     			 showIndex : true,
     	         singleSelect : true,
     	         method : 'POST',
     		});
	
	$("#tables").omGrid({
		colModel:tabHand,
		showIndex : false,
        height:topnum,
        method : 'POST',
        singleSelect : false,
      	limit:20,
      	 onRowDblClick:function(rowIndex,rowData,event){
        	 $("#calcDetail-dialog-model").omDialog({
                 width : 900,
                 height : $(window).height()-200,
                 modal : true,
                 resizable : false,
                 onOpen : function(event) {
                	 $("#calcDetailIframe").attr("src","<%=_path%>/view/group/groMemberDetail.jsp?gCode='"+rowData.groupCode+"'");
              	    }
               }).omDialog('open').css({'overflow-y':'hidden'});
         }
	});
	//团队类型
	$('#groupType').omCombo({
        dataSource : <%=Constant.getCombo("groupType")%>,
        editable : false,
        emptyText : '请选择'
    });
	//显示虚拟团队
	$('#virtualFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        editable : false,
        emptyText : '请选择'
    });
	//显示已设团队长
	$('#identify').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        value : "",
        editable : false,
        emptyText : '请选择'
    });
	//初始化机构部门
	$('#parentDept').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
        		$('#parentDept').omCombo({value:data[1].value,readOnly : true});
        		$('#deptName').omCombo({
        			dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[1].value,
        			onSuccess  : function(data, textStatus, event){
        				if(data.length == 2){
        					$('#deptName').omCombo({value:data[1].value,readOnly : true});
        					$('#deptMarket').val('').omCombo({
        						dataSource : "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+$("#deptName").val(),
        						onSuccess  : function(data, textStatus, event){
        							if(data.length == 2){
        								$('#deptMarket').omCombo({value:data[1].value,readOnly : true});
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
		filterStrategy : 'anywhere'
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
		filterStrategy : 'anywhere'
	});
	$('#deptMarket').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
    });
	//初始化按钮菜单
	$('#buttonbar').omButtonbar({
	          	btns : [{label:"新增",
	           		     id:"addButton" ,
	           		     icons : {left : '<%=_path%>/images/add.png'},
	           	 		 onClick:function(){
	          	 			 	window.location.href = "groupAdd.jsp";
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
	          		            	window.location.href = "groupEdit.jsp?groupCode='"+row[0].groupCode+"'";
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
	      		 				           content:'是否要删除团队信息?',
	      		 				           onClose:function(v){
	      		 				               if(v){
	      		 				            	   for(var i = 0; row && i < row.length; i++){
	      		 				            		   if(row[i].numbers >= 1){
	      		 		 		 							 //删除成功弹出提示框
	      						            				 $.omMessageBox.alert({
	      						            						type : 'error',
	      									 		 	            content: "选中的团队中存在人员，请处理后再删除！"
	      									 		 	        });
	 													flag = false;
			 											 break;
	 													 return false;
	      		 				            		   }
	      		 				            		  flag = true;
	    		 				            	  	}
	     		 				            	   if(flag){
	     		 				            		for(var i = 0; row && i < row.length; i++){
	     		 				            		   Util.post("<%=_path%>/groupMain/deleteGroupMain.do",
	      		            		        				"groupCode="+row[i].groupCode,
	      						            					function(data) {
	        		            		        });
	     		 				            		}
	     		 		 							 //删除成功弹出提示框
	    				            				 $.omMessageBox.alert({
	    				            						type : 'success',
	    							 		 	            content: "删除团队信息成功！"
	    							 		 	        });
	     		 		 							 //删除后刷新页面数据
	    			            					 query();
	  		 				            	   }
	  		 				               }
	  		 				            }
	  		 				     });
	         	 		 		}
	         	 		 	}
	         	        },
	         	       {separtor:true},
	          	      {label:"历史轨迹",
	          			 	id:"updateButton",
	          			 	icons : {left : '<%=_path%>/images/trace.png'},
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
	          		            	window.location.href = "groupHistory.jsp?groupCode="+row[0].groupCode;
	          	 		 		}
	          	 		 	}
	          	        },
	          	      {separtor:true},
	          	      {label:"团队成员",
	          			 	id:"checkButton",
	          			 	icons : {left : '<%=_path%>/images/detail.png'},
	          	 		 	onClick:function(){
	          	 		 		var rows = $('#tables').omGrid("getSelections",true);
	          	 		 		var row = eval(rows);
	          	 		 		if(row.length == 0){
	          	 		 	        $.omMessageBox.alert({
	          	 		 	            content: '请选择一条记录查看！'
	          	 		 	        });
	          	 		 			return false;
	          	 		 		}else if(row.length > 1){
	          	 		 	        $.omMessageBox.alert({
	          	 		 	            content: '每次只能操作一条数据！'
	          	 		 	        });
	          	 		 			return false;
	          	 		 		}else{
	          		            	window.location.href = "groupMember.jsp?groupCode="+row[0].groupCode;
	          	 		 		}
	          	 		 	}
	          	        }
	         	]
	 });
    //
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	//
	$("#search-panel").omPanel({
    	title : "销售团队管理  > 团队维护",
    	collapsible:true,
    	collapsed:false
    });	
	//加载是否禁用按钮方法
	isSelected();
	//初始化加载数据
	setTimeout("query()", 500) ;
});

//表头
var tabHand = [ 
	{header : "二级机构",name : "parentDept",rowspan : 2,width : 150},
	{header : "三级机构",name : "deptName",rowspan : 2,width : 150},
	{header : "四级单位",name : "deptMarket",rowspan : 2,width : 200},
// 	{header : "团队代码",name : "groupCode",rowspan : 2,width : 190},
	{header : "团队名称",name : "groupName",rowspan : 2,width : 200},
	{header : "团队成立日期",name : "foundDate",rowspan : 2,width : 100},
	{header : "团队类型",name : "groupType",rowspan : 2,width : 100,
		/* renderer : function(value, rowData , rowIndex) {
			if(value == '1'){
				return '普通团队';
			}else if(value == '2'){
				return '渠道维护团队';
			}else{
				return '';
			}
		} */	
		renderer : function(value, rowData , rowIndex) {
			if(value == '1'){
				return '真实团队';
			}else if(value == '2'){
				return '虚拟团队';
			}else if(value == '3'){
				return '四级机构（团队考核）';
			}else{
				return '';
			}
		}	
	},
	/* {header : "虚拟团队",name : "virtualFlag",rowspan : 2,width : 100,
		renderer : function(value, rowData , rowIndex) {
			if(value == '1'){
				return '是';
			}else if(value == '0'){
				return '否';
			}else{
				return '';
			}
		}		
	}, */
	{header : "已设团队长",name : "existLeader",rowspan : 2,width : 100,
		renderer : function(value, rowData , rowIndex) {
			if(value == '1'){
				return '是';
			}else if(value == '0'){
				return '否';
			}else{
				return '';
			}
		}
	},
	{header : "团队长",name : "leaderCname",rowspan : 2,width : 100},
];

var tabHand_member = [ 
           	{header : "姓名",name : "name",rowspan : 2,width : 150},
           	{header : "工号",name : "employ",rowspan : 2,width : 150},
           	{header : "域账号",name : "account",rowspan : 2,width : 200},
            	{header : "入司时间",name : "entryDate",rowspan : 2,width : 190},
           	{header : "加入团队日期",name : "entryGroupDate",rowspan : 2,width : 200},
           	{header : "离开团队日期",name : "leaveDate",rowspan : 2,width : 100}
           ];

//
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
	if(roleEname == "subDeptAdmin" || roleEname == "subDeptSalesman"){
			  $("#buttonDelete").parent().parent().hide();
	}else{
		$("#buttonDelete").omButton("enable");
	}
}
//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/groupMain/queryGroupMain.do?"+$("#filterForm").serialize());
}
</script>
</head>
<body>
        <div id="calcDetail-dialog-model" style="display:none;" title="团队成员">
			<iframe id="calcDetailIframe" frameborder="0" style="width:100%; height:90%; height:100%;" src="about:blank">
			</iframe>
		</div>
	<form id="filterForm">
	<input name="formMap['readPage']"id="readPage" style="display:none" value="groupPage"/>
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td><input class="sele"  name="formMap['parentDept']" id="parentDept" /></td>
					<td style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input class="sele"  name="formMap['deptName']" id="deptName" /></td>
					<td style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td><input class="sele"  name="formMap['deptCode']" id="deptMarket" /></td>
					<td style="padding-left:15px"><span class="label">团队类型：</span></td>
					<td><input class="sele"  name="formMap['groupType']" id="groupType" /></td>
				</tr>
				<tr>
                    <!-- 					
                    <td style="padding-left:15px"><span class="label">团队代码：</span></td>
					<td><input type="text"   name="formMap['groupCode']"  id="groupCode"  style="width:158px"/></td>
					-->
					<td style="padding-left:15px"><span class="label">团队名称：</span></td>
					<td><input type="text"  name="formMap['groupName']"   id="groupName"  style="width:158px"/></td>
					<!-- 
					<td align="right"><span class="label">虚拟团队：</span></td>
					<td><input class="sele"  name="formMap['virtualFlag']"   id="virtualFlag" /></td>
					-->
					<td align="right"><span class="label">已设团队长：</span></td>
					<td><input class="sele"   name="formMap['identify']"   id="identify"  /></td>
					<td colspan="2" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>