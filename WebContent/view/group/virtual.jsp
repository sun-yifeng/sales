<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>销售助理维护</title>
<script type="text/javascript">
var trueOrFalse;
$(function(){
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//导航 
	$("#search-panel").omPanel({
    	title : "销售团队管理  > 销售助理维护",
    	collapsible:true,
    	collapsed:false
    });	
	//按钮
	$('#buttonbar').omButtonbar({
            	btns : [{label:"新增",
	            		     id:"addButton" ,
	            		     icons : {left : '<%=_path%>/images/add.png'},
	            	 		 onClick:function(){
            	 			 	window.location.href = "virtualAdd.jsp?trueOrFalse=" + trueOrFalse;
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
            		            	window.location.href = "virtualEdit.jsp?virtualId="+row[0].virtualId + "&employCode=" + row[0].employCode + "&deptCode=" + row[0].deptCode;
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
        		 				           content:'该人员可能已被设置为远程出单账号,请确认是否要删除非HR人员信息?',
        		 				           onClose:function(v){
        		 				               if(v){
        		 				            	   for(var i = 0; row && i < row.length; i++){
        		 				            		   Util.post("<%=_path%>/salesmanVirtual/deleteSalesmanVirtual.do",
        		            		        				"virtualId="+row[i].virtualId+"&employCode="+row[i].employCode,
        						            					function(data) {
		        		            		        		});
		        		 				            	  }
	 		 		 							 //删除成功弹出提示框
					            				 $.omMessageBox.alert({
					            						type : 'success',
								 		 	            content: "删除非HR人员信息成功！"
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
            	        {label:"历史轨迹",
            	    		width:85,
            			 	id:"historyButton",
            			 	icons : {left : '<%=_path%>/images/trace.png'},
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
            	 		 			window.location.href = "virtualHistorys.jsp?virtualId="+row[0].virtualId;
            	 		 		}
            	 		 	}
            	        }
            	]
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
	{header : "二级机构",name : "deptNameTwo",rowspan : 2,width : 100},
	{header : "三级机构",name : "deptNameThree",rowspan : 2,width : 100},
	{header : "四级单位",name : "deptNameFour",rowspan : 2,width : 140},
	{header : "非HR工号",name : "employCode",rowspan : 2,width : 150,align:'center'},
	{header : "非HR人员",name : "cname",rowspan : 2,width : 150,align:'center'},
	/* {header : "对应HR人员",name : "salesmanCname",width : 150,align:'center'}, */
	{header : "人员分类",name : "salesmanType",rowspan : 2,width : 120},
	{header : "身份证号",name : "certiryNo",rowspan : 2,width : 150},
	{header : "出生日期",name : "birthday",rowspan : 2,width : 80},
	{header : "入职时间",name : "enterDate",rowspan : 2,width : 80},
	{header : "结束时间",name : "endDate",rowspan : 2,width : 80}
];

//查询操作
function query() {
	$("#tables").omGrid("setData","<%=_path%>/salesmanVirtual/querySalesmanVirtual.do?"+$("#filterFrm").serialize());
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
					<td style="padding-left: 15px;"><span class="label">人员分类：</span></td>
					<td><input class="sele" type="text" name="formMap['salesmanType']" id="salesmanType"/>
					<input type="hidden" name="formMap['trueOrFalse']" id="trueOrFalse"/></td>
				</tr>	
				<tr>	
					<td style="padding-left:15px"><span class="label">非HR人员姓名：</span></td>
					<td><input type="text" name="formMap['cname']" id="cname"/></td>
					<td style="padding-left:15px"><span class="label">对应HR人员姓名：</span></td>
					<td><input type="text" name="formMap['salesmanCname']" id="salesmanCname"/></td>
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