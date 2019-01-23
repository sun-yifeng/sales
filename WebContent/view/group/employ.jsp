<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>销售人员维护</title>
<script type="text/javascript">
var dataGrid;
var roleEname;
$(function(){
	//input框 整体样式
	$("#filterFrm").find("input").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	$("#validInd").css({"width":"20px"});
	$("#noEmployCode").css({"width":"20px"});
  	//
	$("#search-panel").omPanel({
    	title : "销售团队管理  > 销售人员维护",
    	collapsible:true,
    	collapsed:false
    });	
 	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-set").omButton({width:60});
	 
	//初始化列表
	dataGrid = $("#tables").omGrid({
		colModel:[],
		showIndex : false,
        height:calcHeight('buttonbar'),
        method : 'POST',
        singleSelect : false,
      	limit:20,
      	onRowDblClick:function(rowIndex,rowData,event){
          $("#hr-dialog-model").omDialog({
            width : 900,
            height : $(window).height()-150,
            modal : true,
            resizable : false,
            onOpen : function(event) {
              $("#iframeHisHr").attr("src","<%=_path%>/view/group/employHistoryHr.jsp?salesmanCode="+rowData.salesmanCode);
            }
          }).omDialog('open').css({'overflow-y':'hidden'});
       }
	});
	
	//初始化按钮菜单
	$('#buttonbar').omButtonbar({
      	btns : [{label:"处理",
		 	id:"updateButton",
		 	icons : {left : '<%=_path%>/images/add.png'},
 		 	onClick:function(){
 		 		var rows = $('#tables').omGrid("getSelections",true);
 		 		var row = eval(rows);
 		 		//alert(row[0].deptCode+','+row[0].deptCode);
 		 		if(row.length == 0){
 		 	        $.omMessageBox.alert({
 		 	            content: '请选择一条记录进行操作！'
 		 	        });
 		 			return false;
 		 		}else if(row.length > 1){
 		 	        $.omMessageBox.alert({
 		 	            content: '每次只能操作一条数据！'
 		 	        });
 		 			return false;
 		 		}else if(row[0].processStatus == 2){
 		 	        $.omMessageBox.alert({
 		 	            content: '该人员信息已经处理过！'
 		 	        });
 		 			return false;
 		 		}else{
	            	window.location.href = "employProcess.jsp?salesmanCode="+row[0].salesmanCode+"&deptCode="+row[0].deptCode+"&deptCodeTwo="+row[0].deptCodeTwo;
 		 		}
 		 	}
        },
        {separtor:true},
        {label:"详情",
        	id:"queryButton",
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
 		 			window.location.href = "employDetail.jsp?salesmanCode="+row[0].salesmanCode+"&deptCode="+row[0].deptCode+"&deptCodeTwo="+row[0].deptCodeTwo+"&option=queryDetail"
 		 					+"&deptNameCode="+row[0].deptCodeTwo+"&threeDeptName="+row[0].threeDeptName+"&deptNameFour="+row[0].deptNameFour;
 		 		}
        	}
        },
        {separtor:true},
        {label:"修改",
        	id:"editButton",
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
 		 			window.location.href = "employEdit.jsp?salesmanCode="+row[0].salesmanCode+"&deptCode="+row[0].deptCode+"&deptCodeTwo="+row[0].deptCodeTwo+"&option=queryDetail"
 		 					+"&deptNameCode="+row[0].deptCodeTwo+"&threeDeptName="+row[0].threeDeptName+"&deptNameFour="+row[0].deptNameFour;
 		 		}
        	}
        },
        {separtor:true,id:"resetSepartor"},
        {label:"重置",
        	id:"resetButton",
        	icons : {left : '<%=_path%>/images/detail.png'},
        	onClick:function(){
        		var rows = $('#tables').omGrid("getSelections",true);
 		 		var row = eval(rows);
 		 		if(row.length == 0){
 		 	        $.omMessageBox.alert({
 		 	            content: '请选择记录，支持批量操作！'
 		 	        });
 		 			return false;
 		 		}else{
 		 			$.omMessageBox.confirm({
 				         title: '确认信息',
 				         content: '您确定要重置(支持批量操作)？',
 				         onClose: function(v){
 				             if(v){
 			 	 		 		var str = '';
 			 	 		 		for(var i=0; i < row.length; i++){
 			 	 		 			str += row[i].salesmanCode + ',';
 			 	 	 	 		}
 			 	 		 		Util.post("<%=_path%>/salesman/resetSalesman.do?salesmanCode="+str, "", function(data){
	 			 	 		 		$.omMessageBox.alert({
	 				                    type:'success',
	 				                    title:'提示信息',
	 				                    content: '重置成功',
	 				                    onClose:function(v){
		 				                    //
	 				                    	window.setTimeout("query()",500);
	 				                    }
	 				                });  
 			 	 	 	 		});
 						     } else {
 						    	 //;
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
		            	window.location.href = "employHistory.jsp?salesmanCode="+row[0].salesmanCode;
	 		 		}
	 		 	}
	        }
       ]
    });
	 
 	//处理状态
	$('#processStatus').omCombo({
        dataSource : <%=Constant.getCombo("processStatus")%>,
        editable : false,
        emptyText : '请选择'
    });
 	
 	//员工状态
 	$('#status').omCombo({
 		dataSource : <%=Constant.getCombo("status")%>,
        editable : false,
        emptyText : '请选择'
 	});
    
 	//是否前台
	$('#salesmanFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        /*value:'1',*/
        editable : false,
        emptyText : '请选择'
    });
	
	//二级机构
	$('#deptCodeTwo').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
			//alert(data);
			//如果是分公司登录
    		if(data.length == 2){
        		$('#deptCodeTwo').omCombo({value:eval(data)[1].value, readOnly : true});
        		//取三级机构下拉框的数据
        		$('#deptCodeThree').omCombo({
        			dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[1].value,
        			onSuccess  : function(data, textStatus, event){
        				if(data.length == 2){
        					$('#deptCodeThree').omCombo({value:eval(data)[1].value,readOnly : true});
        					//取四级单位下拉框
        					$('#deptCodeFour').val('').omCombo({
        						dataSource : "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+$("#deptCodeThree").val(),
        						onSuccess  : function(data, textStatus, event){
        							if(data.length == 2){
        								$('#deptCodeFour').omCombo({value:eval(data)[1].value,readOnly : true});
        							}
        						}
        					});
        				}
        			}
        		});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptCodeTwo').omCombo('value');
            if(currentParentDept != ''){
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
            var currentParentDept = $('#deptCodeThree').omCombo('value');
            if(currentParentDept != ''){
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
	
	//总公司人员管理岗才可以重置
	hideButton();
	
	hideRecoverDelStatusButton();
	
	//初始化加载数据
	window.setTimeout("query()",500);
	
});

//表头
function setHand(dept){
	var result = [];
	result.push({header:"二级机构",name:"deptNameTwo",width:80,align:"center"});
	result.push({header:"三级机构",name:"deptNameThree", width:80,align:"center"});
	result.push({header:"四级单位",name:"deptNameFour", width:80,align:"center"});
	result.push({header:"团队名称",name:"groupName", width:150,align:"center"});
	result.push({header:"员工姓名",name:"salesmanCname", width:60,align:"center"});
	result.push({header:"当前工号",name:"employCode", width:80,align:"center"});
	result.push({header:"用户域名",name:"salesmanCode", width:80,align:"left"});
	result.push({header:"处理状态",name:"processStatus",width:60,align:"center",
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "未处理";
			else if(value == '2')
				return "已处理";
			else
				return "";
		}			
	});
	result.push({header:"是否前台",name:"salesmanFlag",width:60,align:"center",
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "是";
			else if(value == '0')
				return "否";
			else
				return "";
		}			
	});
	result.push({header:"是否已删除",name:"validInd",width:60,align:"center",
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "否";
			else if(value == '0')
				return "是";
			else
				return "";
		}			
	});
	result.push({header:"在职状态",name:"status",width:60,align:"center"});
	result.push({header:"销售职级",name:"rankName", width:100,align:"center"});
	result.push({header:"业务线",name:"businessLine", width:60,align:"center"});
	result.push({header:"考核日期",name:"frontDate", width:80,align:"center"});
	result.push({header:"入司日期",name:"contractDate", width:80,align:"center"});
	result.push({header:"入职日期",name:"entryDate", width:80,align:"center"});
	result.push({header:"转正日期",name:"regularDate", width:80,align:"center"});
	result.push({header:"离职日期",name:"quitDate", width:80,align:"center"});
	/* result.push({header:"员工状态",name:"status",width:60,align:"center"}); */
	result.push({header:"员工类别",name:"salesmanType",width:70,align:"center"});
	/*result.push({header:"职务类型",name:"titleType",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "前台";
			else if(value == '2')
				return "后勤";
			else if(value == '3')
				return "安管";
			else if(value == '4')
				return "经理";
			else
				return "";
		}			
	});
	result.push({header:"职务",name:"title", width:100});*/
	result.push({header:"性别",name:"sex",width:40,align:"center",
		renderer : function(value, rowData , rowIndex) {
			if (value == '106001')
				return "男";
			else if(value == '106002')
				return "女";
			else if(value == '106003')
				return "不清楚";
			else if(value == '106009')
				return "未知";
			else
				return "";
		}		
	});
	result.push({header:"出生日期",name:"birthday", width:80,align:"center"});
	result.push({header:"身份证号",name:"certifyNo", width:140,align:"center"});
	result.push({header:"年龄",name:"age", width:40,align:"center"});
	/*
	result.push({header:"民族",name:"nation", width:100});
	result.push({header:"籍贯",name:"fromAddress", width:100});
	result.push({header:"党派",name:"party",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "党员";
			else if(value == '2')
				return "预备党员";
			else if(value == '3')
				return "共青团员";
			else if(value == '4')
				return "群众";
			else
				return "";
		}			
	});
	result.push({header:"最高学历",name:"degree",width:100});
	result.push({header:"毕业院校",name:"education", width:100});
	result.push({header:"专业",name:"magor", width:100});
	result.push({header:"婚姻状态",name:"marry",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "已婚";
			else if(value == '2')
				return "未婚";
			else if(value == '3')
				return "离婚";
			else
				return "";
		}		
	});
	*/
	return result;
}

/*
 * 功能：总公司人员管理岗，可以重置,其他角色如系统管理员无重置权限
 * 日期：2015-05-20
 */
function hideButton(){
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=headDeptSalesmanManageNew,xszcAdmin",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			//alert(typeof(data));
			if(data === "false"){
				$("#resetButton").remove();
				$(".om-buttonbar-sep:last").remove();
				$("#editButton").remove();
				$(".om-buttonbar-sep:last").remove();
			}
		}
	});
}

/**
 * 功能：只有admin用户才能看到这个按钮
 * 日期：2016年4月23日 liuym
 */

function hideRecoverDelStatusButton(){
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=xszcAdmin,headDeptSalesmanManageNew",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			//alert(typeof(data));
			if(data === "false"){
				$("#button-set").remove();
			}
		}
	});
}

function recoverDelStatus(){
	var selectedRows = $('#tables').omGrid('getSelections',true);
	var salesmanCode = '';
	if(selectedRows.length == 0){
		$.omMessageBox.alert({
	 	        content:'请选择一条记录操作',
	 	        onClose:function(value){
	 	        	return false;
	 	        }
	        });
	}else if(selectedRows.length > 1){
		$.omMessageBox.alert({
			   type:'error',
	           content:'只能选择一条记录进行操作！'
	        });
		    return;
	}else if(selectedRows[0].validInd == '1'){
		$.omMessageBox.alert({
				type:'error',
	 	        content:'此人员是未删除状态！'
 	        });
	 	    return false;
	}else{
		salesmanCode = selectedRows[0].salesmanCode;
		$.omMessageBox.confirm({
			title:'确认恢复删除状态',
            content:'你确定要恢复此员工删除状态吗？',
            onClose:function(v){
            	if(v){
            		Util.post(
   	 		 			"<%=_path%>/salesman/recoverDelStatus.do?salesmanCode="+salesmanCode,
   	 		 			'',
   	 		 			function(data) {
   	 		 				if(data == 'OK'){
	   	 		 				$.omMessageBox.alert({
		        					type:'success',
		        	                title:'成功',
		    	 		 	        content:'恢复员工删除状态成功！',
		    	 		 	        onClose:function(value){
	    	 		 					//刷新列表
	    	 		 					$('#tables').omGrid({});
		    	 		 	        	return true;
		    	 		 	        }
			 		 	        });
   	 		 				}else{
   	 		 					$.omMessageBox.alert({
    	        					type:'error',
    	        	                title:'失败',
    	    	 		 	        content:'恢复员工删除状态失败！',
    	    	 		 	        onClose:function(value){
	       	 		 					//刷新列表
	       	 		 					$('#tables').omGrid({});
    	    	 		 	        	return true;
    	    	 		 	        }
    		 		 	        });
   	 		 				}
   	 		 			}
   	 		 				
     	 		 	);
            	}
            }
		});
	}
}

//查询操作
function query(){
	var param = $("#filterFrm").serialize();
	$("#tables").omGrid("setData","<%=_path%>/salesman/querySalesman.do?"+param);
	$("#tables").omGrid({colModel : setHand()});
}
</script>
</head>
<body>
    <div id="hr-dialog-model" style="display:none;" title="HR入职离职记录">
        <iframe id="iframeHisHr" frameborder="0" style="width:100%; height:90%; height:100%;" src="about:blank"></iframe>
    </div>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td><input class="sele" name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
					<td style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input class="sele" name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td><input class="sele" name="formMap['deptCodeFour']" id="deptCodeFour" /></td>
					<td style="padding-left:15px"><span class="label">处理状态：</span></td>
					<td><input class="sele" name="formMap['processStatus']" id="processStatus"  /></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">在职状态：</span></td>
					<td><input class="sele" name="formMap['status']" id="status"  /></td>
					<td style="padding-left:15px"><span class="label">用户域名：</span></td>
					<td><input type="text" name="formMap['salesmanCode']" id="salesmanCode"  style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">员工姓名：</span></td>
					<td><input type="text" name="formMap['salesmanCname']" id="salesmanCname" style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">团队名称：</span></td>
					<td><input type="text" name="formMap['groupName']" id="groupName" style="width:158px"/></td>
				</tr>
				<tr>
				    <td style="padding-left:15px"><span class="label">是否前台：</span></td>
					<td><input class="sele" name="formMap['salesmanFlag']" id="salesmanFlag"  /></td>
				    <td style="padding-left:15px"><span class="label">当前工号：</span></td>
					<td><input type="text" name="formMap['employCode']" id="employCode" /></td>
					
					<td style="padding-left:15px" align="right"><span class="label">含已删除：</span></td>
					<td><input type="checkbox" id="validInd" name="formMap['validInd']" value="1"/>
						<span class="label">含无工号：</span>
						<input type="checkbox" id="noEmployCode" name="formMap['noEmployCode']" value="1"/>
					</td>
					
					<td colspan="2" align="right"><span id="button-search" onclick="query()">查询</span>
					<span id="button-set" onclick="recoverDelStatus()">恢复删除</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>