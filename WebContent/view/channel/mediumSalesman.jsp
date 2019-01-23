<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>渠道销售人员数据导入</title>
<script type="text/javascript">
var lawImpTypeList = null;
$(function(){
	// 整体样式
	$(".sele").css({"width":"150px"});
	$("#mediumName").css({"width":"270px"});
	$(".sale").css({"width":"100%"});
	
	//初始化页面保存、重置、取消按钮
	$("#button-save").omButton({icons:{left:'<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons:{left:'<%=_path%>/images/remove.png'},width:50});
	
	//加载二级机构名称
	$('#twoDeptCode').omCombo({
        dataSource: "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#twoDeptCode').omCombo({
				value:eval(data)[1].value,
    			readOnly: true
			});
        },
        onValueChange: function(target, newValue, oldValue, event) {
            $('#threeDeptCode').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
        },
        optionField: function(data, index) {
            return data.text;
		},
		emptyText: "请选择",
		filterStrategy: 'anywhere'
    });
	
	//初始化三级机构名称
	$('#threeDeptCode').omCombo({
		onSuccess:function(data, textStatus, event){
			if(data.length === 2){
				$('#threeDeptCode').omCombo("value",data[1].value);
        		$('#threeDeptCode').omCombo({
        			readOnly: true
        		});
        	}
		},
		valueField: 'value',
		inputField: 'text',
		filterStrategy: 'anywhere',
		emptyText: '请选择'
	});
	//加载二级机构名称
	$('#twoDept').omCombo({
        dataSource: "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#twoDept').omCombo({
				value:eval(data)[1].value,
    			readOnly: true
			});
        },
        onValueChange: function(target, newValue, oldValue, event) {
            $('#threeDept').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
        },
        optionField: function(data, index) {
            return data.text;
		},
		emptyText: "请选择",
		filterStrategy: 'anywhere'
    });
	
	//初始化三级机构名称
	$('#threeDept').omCombo({
		onSuccess:function(data, textStatus, event){
			if(data.length === 2){
				$('#threeDept').omCombo("value",data[1].value);
        		$('#threeDept').omCombo({
        			readOnly: true
        		});
        	}
		},
		valueField: 'value',
		inputField: 'text',
		filterStrategy: 'anywhere',
		emptyText: '请选择'
	});
	
	//初始化导入窗口数据
  	$("#impXlsArea").omDialog({
		autoOpen:false,
		title:"渠道销售人员数据导入",
		width:500,
		height: 300,
		modal: true
	});
	
	//审核标识
	$('#approve').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		 dataSource : [ {text : '请选择', value : ''}, 
		                {text : '未审核', value : '0'}, 
                        {text : '已审核', value : '1'}]
    });
	
  	$("#button-imp").omButton({
		icons : {left:'<%=_path%>/images/page_white_excel.png'},
		width:80,
		height:30,
		onClick:submitDaoRuData
	});
  	
  	
  //选择合作机构
	$("#agent-dialog-model").omDialog({
	     autoOpen:false,
	     width:750,
	     height:465,
	     modal:true,
	     resizable:false,
	     onOpen:function(event) {
	    	$("#agentIframe").attr("src","<%=_path%>/view/demo/selectMediumIframe.jsp?twoDeptCode="+$('#twoDept').val()+"&&threeDeptCode="+$('#threeDept').val());
	     }
	});
	
	Util.post("<%=_path%>/department/getDeptCodeByUser.do",'',
 			function(data) {
				userDptCde = data;
				if(userDptCde != '00'){
					trueOrFalse = true;
				}else{
					trueOrFalse = false;
				}
 			}
 		);
	$('#buttonbar').omButtonbar({
		 btns : [
			 {label:"新增",
			     id:"addButton" ,
			     icons : {left : '<%=_path%>/images/add.png'},
			     onClick:function(){
 	 			 	window.location.href = "mediumSalesmanAdd.jsp";
 	 			 }
			 },
		     {
			    label:"下载模板",
				id:"addButton",
				icons : {left : '<%=_path%>/images/page_white_excel.png'},
				onClick:downloadXlsModel
			 },{
				label:"导入数据",
				id:"addButton" ,
				icons : {left : '<%=_path%>/images/page_white_excel.png'},
				onClick:importXlsData
			 },
			 {
			 label:"保存修改",
		     id:"updatePlan" ,
		     icons : {left : '<%=_path%>/images/op-edit.png'},
	 		 onClick:function(){
	 			saveRowsChange();
	 		 }
		 },{
			 label:"审核",
		     id:"updatePlan" ,
		     icons : {left : '<%=_path%>/images/user.png'},
	 		 onClick:function(){
	 			 saveRowsApprove();
	 		 }
		 }]
	 });
	
	//查询面板
	$("#search-panel").omPanel({
    	title : "传统渠道管理  > 渠道销售人员",
    	collapsible:true,
    	collapsed:false
    });
	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	//列表高度
	var btInput = $("#buttonbar");
	var btOffset = btInput.offset();
	var btnum = btOffset.top+btInput.outerHeight()+52;
	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+$(document).height();
	var topnum = bdnum - btnum;
	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
		topnum = topnum + 2;
	} 
	//分页表格
	$("#tables").omGrid({
		 limit: 20,
        height: topnum,
		colModel:getTableHead(),
		showIndex : true,
        singleSelect : false,
        method : 'POST',
	});
	//加载二级机构名称
	$('#deptCode').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#deptCode').omCombo({
				value:eval(data)[1].value,
				readOnly : true
			});
        },
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	
	//加载初始数据
	setTimeout("query()",800);
});

var statusOptions = {
		dataSource:[
			{value:"1",text:"在职"},
			{value:"2",text:"离职"}
		],
	    editable: false
	};

function getWindowWidth(){
	return $("#search-panel").width()+30;
}

function getTableHead(){
	//表头
	var tabHand = [
	    [
            {header:"二级机构名称",name:"parentDeptName",width:100,align:'center'},
			{header:"三级机构名称",name:"deptName",width:100,align:'center'},
			{header:"渠道名称",name:"cname",width:200,align:'center'},
			{header:"渠道编码",name:"channelCode",width:120,align:'center'},
			{header:"姓名",name:"name",width:60,align:'center'},
			{header:"员工状态",name:"status",width:80,align:'center',editor:{rules:["required",true,"请选择"],type:"omCombo",name:"itemCode",options:statusOptions},renderer:function(v,r,i){
				if(v == '1') {return "在职";}else if(v == '2'){return "离职";}else{return v;}
			}},
			{header:"审核标识",name:"approve",width:80,align:'center'},
			{header:"性别",name:"sex",width:50,align:'center'},
			{header:"身份证号",name:"idNumber",width:150,align:'center'},
			{header:"出生日期",name:"birthday",width:80,align:'center',renderer:function(v,r,i){
				if(v.length==8){
				    var n_birthday = v.substr(0,4)+"-"+v.substr(4,2)+"-"+v.substr(6,2);
				    return n_birthday;
				}else{
					return v;
				}
			}},
			{header:"手机",name:"mobile",width:100,align:'center',editor:{editable:true,type:"omNumberField",option:{allowNegative:false}}},
			{header:"邮箱",name:"email",width:120,align:'center'},
			{header:"录入日期",name:"createdDate",width:130,align:'center'}
			
		]
	];
    if(lawImpTypeList!=null){
    	$.each(lawImpTypeList,function(i,lawDefine){
    		var width = 80;
    		tabHand[0].push({header:lawDefine.itemName,name:lawDefine.itemCode,width:width,align:'right',editor:{editable:true,rules:[["max",100,"最大值为100"],["min",0,"最小值为0"]],type:"omNumberField"}});
    	});
    }
	return tabHand;
}


/**
 * 保存修改
 */
function saveRowsChange(){
	//先获取到更改过的行
	var rows = $("#tables").omGrid("getChanges" , "update");
	$.ajax({ 
			url: "<%=_path%>/mediumSalesman/saveRowsChange",
			data:{
				changeRows:JSON.stringify(rows)
			},
			type:"post",
			async: true, 
			dataType: "json",
			success: function(data){
				//关闭提示
	            $.omMessageBox.waiting('close');
				if(data.actionFlag){
					$.omMessageBox.alert({
		                type:'success',
		                title:'操作成功!',
		                content:"保存成功!",
		                onClose:function(value){
	 		 					//刷新列表
	 		 					$('#tables').omGrid({});
    	 		 	        	return true;
    	 		 	        }
		            });
				}else{
					$.omMessageBox.alert({
		                type:'error',
		                title:'操作失败',
		                content:"保存失败,请重试！",
		                onClose:function(value){
	 		 					//刷新列表
	 		 					$('#tables').omGrid({});
    	 		 	        	return true;
    	 		 	        }
		            });
				}
			}
	});
}

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
	//先获取到选择行的数据
	var approve_flag="";
 			for (var i = 0; i < selectedRows.length; i++) {
 				approve_flag += selectedRows[i].approve;
 			}
 			if (approve_flag.indexOf('已审核')<0){
 					$.ajax({ 
 						url: "<%=_path%>/mediumSalesman/saveRowsApprove",
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


/**
 * 生成excel模板并下载
 */
 function downloadXlsModel(){
		//弹出提示
	    $.omMessageBox.waiting({
	        title:'请稍候',
	        content:'服务器正在生成模板，请稍候...',
	    });
		//生成模板
	    $.ajax({ 
			url: "<%=_path%>/mediumSalesman/downloadSalesmanModel",
			type:"post",
			async: true, 
			dataType: "json",
			success: function(data){
				//关闭提示
	            $.omMessageBox.waiting('close');
				if(data.actionFlag){
					window.location.href="<%=_path %>/"+data.fileUrl;
				}else{
					$.omMessageBox.alert({
		                type:'error',
		                title:'失败',
		                content:data.actionMsg
		            });
				}
			}
		});
}
/**
 * 提交导入表单
 */
function submitDaoRuData(){
	var mediumName = $("#mediumName").val();
	if(mediumName==""){
		$.omMessageBox.alert({
            type:'error',
            title:'渠道为空',
            content:"请先选择渠道！"
        });
		return false;
	}else{
		var impFile = $("#impFile").val();
		if(impFile==""){
			$("#confirmMsg").html("<font color=red>请选择文件后再提交！</font>");
			return;
		}else{
			var extStr = impFile.substring(impFile.length-4,impFile.length);
			if(extStr.indexOf("xls")==-1){
				$("#confirmMsg").html("<font color=red>请选择拓展名为.xls文件后再提交！</font>");
				return;
			};
		}
		
		$.omMessageBox.waiting({
	        title:'请稍候',
	        content:'服务器正在导入数据...',
	    });
		    var f = $("form")[1];
	        f.action=f.action+"?channelCode="+$("#channelCodeTwo").val();
		    $("#impXlsForm").submit();
	}
}

/**
 * 导入excel数据
 */
function importXlsData(){
	$("#impXlsArea").omDialog("open");
}

//选择合作机构
function selAgent(){
  $("#agent-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
}

//填充数据（选择合作机构）
function fillMediumBackAndCloseDialog(rowData) {
	  if(rowData.channelCode == ''){
		  $("#mediumName").val("无");
	  } else {
		  if(rowData.mediumCname==undefined){
			  $("#mediumName").val(rowData.channelCode+"-"+rowData.agentCname);
		  }else{
			  $("#mediumName").val(rowData.channelCode+"-"+rowData.mediumCname);
		  }
	  	  $("#channelCodeTwo").val(rowData.channelCode);
	  }
	  $("#agent-dialog-model").omDialog('close');
	  $("#mediumName").focus();
}

//查询操作
function query() {
	$("#tables").omGrid("setData","<%=_path%>/mediumSalesman/queryMediumSalesman.do?"+$("#filterFrm").serialize());
}

function closeWait(){
	$.omMessageBox.waiting('close');
}
function cancel(){
	$("#impXlsArea").omDialog('close');
}
</script>
</head>
<body>
	<form id="filterFrm">
	        <div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">二级机构：</span></td>
					<td><input class="sele" name="formMap['twoDeptCode']"  id="twoDeptCode" /></td>
					<td align="right"><span class="label">三级机构：</span></td>
					<td><input class="sele" name="formMap['threeDeptCode']"  id="threeDeptCode" /></td>
					<td align="right"><span class="label">渠道编码：</span></td>
					<td><input class="sele" name="formMap['channelCode']"  id="channelCode" /></td>
					<td style="padding-left:15px" align="right"><span class="label">姓名：</span></td>
					<td><input class="sele" name="formMap['name']" id="name" /></td>
					<td style="padding-left:15px" align="right"><span class="label">审核标识：</span></td>
					<td><input class="sele" name="formMap['approve']" id="approve" /></td>
					<td align="right" colspan="6"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
			</div>
	 </form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
	<div id="impXlsArea" style="display:none">
	    <!-- 指向iframe实现无刷新 -->
	    <iframe style="width:0; height:0; margin-top:-10px;" name="submitFrame" src="about:blank"></iframe>
	    <form action="<%=_path %>/mediumSalesman/impSalesmanValueInXls"  id="impXlsForm" method="post" class="easyWebForm" enctype="multipart/form-data" target="submitFrame">
	                 <input type="hidden" name="formMap['channelCodeTwo']"  id="channelCodeTwo"  />
			<table>
			    <tr>
			        <td align="right"><span class="label">二级机构：</span></td>
					<td><input class="sele" name="formMap['twoDept]"  id="twoDept" /></td>
					
			    </tr>
			    <tr>
			         <td align="right"><span class="label">三级机构：</span></td>
					<td><input class="sele" name="formMap['threeDept']"  id="threeDept" /></td>
			    </tr>
			    <tr>
			        <td style="text-align:right" width="130" height="30"><span class="label">选择渠道:</span></td>
					<td><input class="sele" name="formMap['mediumName']"  id="mediumName"  onclick="selAgent();"/></td>
			    </tr>
				<tr height="25">
					<td style="text-align:right" width="130" height="30"><span class="label">选择要导入的文件:</span></td>
					<td><input type="file" name="impFile" id="impFile" /></td>
				</tr>
				<tr>
				  <td style="text-align:center" colspan="2" height="30">
				     <button id="button-imp" type="button">导入</button>
				  </td>
				</tr>
				<tr>
				  <td style="text-align:center" colspan="2" height="30">
				          导入说明：导入文件必需有数据，否则将被过滤掉<br/>
				     <span id="confirmMsg" ></span>     
				  </td>
				</tr>
			</table>
		</form>
	</div>
	<div id="agent-dialog-model" title="选择渠道">
		<iframe id="agentIframe" frameborder="0" style="width: 100%; height: 99%; height: 100%; overflow-y:hidden; " src="about:blank"></iframe>
	</div>
</body>
</html>