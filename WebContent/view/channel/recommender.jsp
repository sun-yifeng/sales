<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>个代推荐人管理</title>
<script type="text/javascript">
var trueOrFalse;
$(function(){
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//导航 
	$("#search-panel").omPanel({
    	title : "销售渠道管理  > 全民营销推荐人",
    	collapsible:true,
    	collapsed:false
    });	
	//按钮
	$('#buttonbar').omButtonbar({
            	btns : [{label:"新增",
	            		     id:"addButton" ,
	            		     icons : {left : '<%=_path%>/images/add.png'},
	            	 		 onClick:function(){
            	 			 	window.location.href = "recommenderAdd.jsp?trueOrFalse=" + trueOrFalse;
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
            	 		 	        $.omMessageBox.alert({content: '请选择一条记录编辑！' });
            	 		 			return false;
            	 		 		}else if(row.length > 1){
            	 		 	        $.omMessageBox.alert({content: '每次只能操作一条数据！'});
            	 		 			return false;
            	 		 		}else if(row.length == 1){
                	 		 		//alert(row.length + "," + row[0].virtualId);
            		            	window.location.href = "recommenderEdit.jsp?recommenderId="+row[0].recommenderId;
            	 		 		}else{
            	 		 			alert(row.length);
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
        		 				           content:'请确认是否要删除个人推荐人信息?',
        		 				           onClose:function(v){
        		 				               if(v){
        		 				            	   for(var i = 0; row && i < row.length; i++){
        		 				            		   Util.post("<%=_path%>/recommender/deleteRecommender.do",
        		            		        				"recommenderId="+row[i].recommenderId + "&channelCode="+row[i].channelCode,
        						            					function(data) {
		        		            		        		});
		        		 				            	  }
	 		 		 							 //删除成功弹出提示框
					            				 $.omMessageBox.alert({
					            						type : 'success',
								 		 	            content: "删除个代推荐人信息成功！"
								 		 	        });
	 		 		 							 //删除后刷新页面数据
				            					 query();
        		 				               }
        		 				            }
        		 				       });
            	 		 		}
            	 		 	}
            	        },
            	        {separtor:true},
            	        {
            				 label:"审核",
            			     id:"updatePlan" ,
            			     icons : {left : '<%=_path%>/images/user.png'},
            		 		 onClick:function(){
            		 			 saveRowsApprove();
            		 		 }
            			 }
            	]
    });
	
	//审核标识
	$('#approvedStatus').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		 dataSource : [ {text : '请选择', value : ''}, 
		                {text : '未审核', value : '0'}, 
                        {text : '已审核', value : '1'}]
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
    //按钮
    $("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
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
    
  	controlSalesman();
	//查询列表
	window.setTimeout("query()",500);
	
});

/**
 * 审核
 */
function saveRowsApprove(){
	var selectedRows = $('#tables').omGrid('getSelections',true);
	if(selectedRows.length == 0 ){
  		$.omMessageBox.alert({
	 	        content:'请至少选择一条未审核的记录操作',
	 	        onClose:function(value){
	 	        	return false;
	 	        }
	        });
  	}else{
  		
  	$.omMessageBox.confirm({
              title:'确认审核通过',
              content:'你确定要审核该记录吗？',
              onClose:function(v){
                  if(v){
                	//先获取到选择行的数据
                	 var approve_flag="";
           			for (var i = 0; i < selectedRows.length; i++) {
           				approve_flag += selectedRows[i].approvedStatus;
           			}
           			if (approve_flag<=0){
           					$.ajax({ 
           						url: "<%=_path%>/recommender/saveRecommendersApprove",
           						data:{
           							selectedRows : JSON.stringify(selectedRows)
           						},
           						type:"post",
           						async: true, 
           						dataType: "json",
           						success: function(data){
           							//关闭提示
           							if(data.actionMsg=='ok'){
           								$.omMessageBox.alert({
           					                type:'success',
           					                title:'审核!',
           					                content:"审核成功!",
           					               onClose:function(value){
          	       	 		 					//刷新列表
          	       	 		 					$('#tables').omGrid({});
                 	    	 		 	        	return true;
                 	    	 		 	        }
           					            });
           							}else if(data.actionCount!=0){
           								$.omMessageBox.alert({
           					                type:'error',
           					                title:'审核!',
           					                content:"有"+data.actionCount+"条数据审核未通过,其余数据审核通过！",
           					               onClose:function(value){
          	       	 		 					//刷新列表
          	       	 		 					$('#tables').omGrid({});
                 	    	 		 	        	return true;
                 	    	 		 	        }
           					            });
           							}else{
           								$.omMessageBox.alert({
           					                type:'error',
           					                title:'审核',
           					                content:"审核失败,请重试！",
           					               onClose:function(value){
          	       	 		 					//刷新列表
          	       	 		 					$('#tables').omGrid({});
                 	    	 		 	        	return true;
                 	    	 		 	        }
           					            });
           							}
           						}
           				});
           			}else{
           				$.omMessageBox.alert({
           		            type:'error',
           		            title:'操作失败!',
           		            content:"你的选择中包含有已审核的数据!",
           		           onClose:function(value){
          	 		 	        	return true;
          	 		 	        }
           		        });
           				return false;
           			}
                  }
              }
  	});
	
	
  	}
}

//根据查询权限:分别查询出1.销售助理,独立考核的非HR人员;2.远程出单点人员  
function controlSalesman(){
	$.ajax({
		url: "<%=_path%>/common/queryCurrUserRoleEname.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			var roleEnameStrs = data.split(",");
			var flag = false;
			var flag1 = false;
			var flag2 = false;
			for (var i = 0; i < roleEnameStrs.length; i++) {
				var roleEname = roleEnameStrs[i];
				//销售支持系统开发角色:系统开发角色可以操作所有的功能
				if(roleEname == "xszcAdmin"){
					$('#salesmanType').omCombo({
				        dataSource : <%=getCombo("salesmanType2")%>,
				        editable : false,
				        emptyText : '请选择'
				    });
					trueOrFalse = "2";
					$("#trueOrFalse").val("2");
					flag = true;
				}
				
			}
			for(var i = 0; i < roleEnameStrs.length; i++){
				var roleEname = roleEnameStrs[i];
				
				if(roleEname == "headDeptSalesmanCreditNew" 
					|| roleEname == "headDeptSalesmanManageNew"
					|| roleEname == "subDeptMangerNew" 
					|| roleEname == "subDeptSalesmanManageNew"){
					flag1 = true;
				}else if(roleEname == "headDeptCreditChannelNew"
					  	  || roleEname == "headDeptAdminChannelNew"
						  || roleEname == "headDeptMediumNodeNew"
						  || roleEname == "subDeptManagerChannelNew"
						  || roleEname == "subDeptMediumNodeChannelNew"){
					flag2 = true;
				}
				
				if(flag1 && flag2){
					$('#salesmanType').omCombo({
				        dataSource : <%=getCombo("salesmanType2")%>,
				        editable : false,
				        emptyText : '请选择'
				    });
					trueOrFalse = "2";
					$("#trueOrFalse").val("2");
					flag = true;
				}
			}
			
			if(!flag){
				for (var i = 0; i < roleEnameStrs.length; i++) {
					var roleEname = roleEnameStrs[i];
					if(roleEname == "headDeptSalesmanCreditNew" 
						|| roleEname == "headDeptSalesmanManageNew"
						|| roleEname == "subDeptMangerNew" 
						|| roleEname == "subDeptSalesmanManageNew"){
						//人员类别:销售助理和独立考核的非HR人员下拉框
						$('#salesmanType').omCombo({
					        dataSource : <%=getCombo("salesmanType1")%>,
					        editable : false,
					        emptyText : '请选择'
					    });
						//查询的是销售助理和独立考核的非HR人员
						trueOrFalse = "0";
						$("#trueOrFalse").val("0");
						break;
					}else if(roleEname == "headDeptCreditChannelNew"
							  || roleEname == "headDeptAdminChannelNew"
							  || roleEname == "headDeptMediumNodeNew"
							  || roleEname == "subDeptManagerChannelNew"
							  || roleEname == "subDeptMediumNodeChannelNew"){
						//人员类别:远程出单点人员
						$('#salesmanType').omCombo({
					        dataSource : [ {"text":"远程出单点出单员","value":"1"} ],
					        valueField : 'value',
							inputField : 'text',
					        value : '1'
					    });
						//查询的数据为远程出单点人员
						trueOrFalse = "1";
						$("#trueOrFalse").val("1");
						break;
					}else{
						$('#salesmanType').omCombo({
					        dataSource : <%=getCombo("salesmanType2")%>,
					        editable : false,
					        emptyText : '请选择'
					    });
						trueOrFalse = "3";
						$("#trueOrFalse").val("3");
					}	
				}
			}
			
			
		}
	});
}

//表头
var tabHand = [ 
	{header : "代理人机构编码",name : "deptCode",rowspan : 2,width : 100},
	{header : "代理人部门",name : "deptName",rowspan : 2,width : 140},
	{header : "代理人编码",name : "channelCode",rowspan : 2,width : 150,align:'center'},
	{header : "代理人姓名",name : "channelName",width : 150,align:'center'},
	{header : "推荐人工号",name : "recommenderCode",rowspan : 2,width : 120},
	{header : "推荐人姓名",name : "recommenderName",rowspan : 2,width : 150},
	{header : "审核标识",name : "approvedStatus",rowspan : 2,width : 150,renderer : function(value, rowData , rowIndex) {
		if(value == '0')
			return "未审核";
		else if(value=='1')
			return "已审核";
	}}
];

//查询操作
function query() {
	$("#tables").omGrid("setData","<%=_path%>/recommender/queryRecommenders.do?"+$("#filterFrm").serialize());
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
					<td style="padding-left: 15px;"><span class="label">推荐人姓名：</span></td>
					<td><input type="text" name="formMap['recommenderName']" id="recommenderName"/>
					<input type="hidden" name="formMap['trueOrFalse']" id="trueOrFalse"/></td>
				</tr>	
				<tr>
					<td style="padding-left:15px"><span class="label">推荐人工号：</span></td>
					<td><input type="text" name="formMap['recommenderCode']" id="recommenderCode"/></td>	
					<td style="padding-left:15px"><span class="label">代理人代码：</span></td>
					<td><input type="text" name="formMap['channelCode']" id="channelCode"/></td>
					<td style="padding-left:15px"><span class="label">代理人姓名：</span></td>
					<td><input type="text" name="formMap['channelName']" id="channelName"/></td>
					<td style="padding-left:15px" align="right"><span class="label">审核标识：</span></td>
					<td><input class="sele" name="formMap['approvedStatus']" id="approvedStatus" /></td>
		            <!-- 			
		            <td style="padding-left:15px"><span class="label">人员工号：</span></td>
					<td><input type="text"   name="formMap['employCode']" id="employCode"  style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">人员代码：</span></td>
					<td><input type="text"   name="formMap['virtualId']" id="virtualId"  style="width:158px"/></td> 
					-->	
					<td colspan="6" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr> 
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>