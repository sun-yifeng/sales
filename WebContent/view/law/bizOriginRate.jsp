<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>业务来源调整系数</title>

<style>
.errorImg {
	background: url("<%=_path%>/images/msg.png") no-repeat scroll 0 0 transparent;
	height: 16px;
	width: 16px;
	cursor: pointer;
}
input.error,textarea.error {
	border: 1px solid red;
}
.errorMsg {
	border: 1px solid gray;
	background-color: #FCEFE3;
	display: none;
	position: absolute;
	margin-top: -18px;
	margin-left: -2px;
}
</style>

<script type="text/javascript">
var dataGrid;
var roleEname;
var btnArray = ["button-search","subBtn"];
$(function(){
	
	 //业务来源
	$('#originType').omCombo({
        dataSource : <%=Constant.getCombo("originType")%>,
        editable : false,
        emptyText : '请选择',
        width: 182
    });
	 
	 //业务类型
	$('#bizType').omCombo({
        dataSource : <%=Constant.getCombo("bizType")%>,
        editable : false,
        emptyText : '请选择',
        width: 182
    });
	 
	 //是否车险
	$('#workFalg').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        editable : false,
        emptyText : '请选择',
        width: 182
    });
	
	//列表的高度
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
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel:tabHand,
		showIndex : false,
        singleSelect : false,
        height:topnum,
        method : 'POST'
	});
	initDialog();
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#search-panel").omPanel({
    	title : "销售人员管理办法  > 业务来源调整系数",
    	collapsible:true,
    	collapsed:false
    });	
	
	//初始化机构部门
	$('#deptName1').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptName1').omCombo({
    				onValueChange : function(target, newValue, oldValue, event) {
    					$("#deptCode").val(newValue);
    				},
    				value : data[1].value,
    				readOnly : true
    			});
        	}else{
    	   		$('#deptName1').omCombo({
    	   			onValueChange : function(target, newValue, oldValue, event) {
    	   	            $("#deptCode").val(newValue);
    	   			}
    	   		});
    		}
        }
    });
	
	//初始化机构部门
	$('#deptName').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		width:182,
		lazyLoad:true,
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptName').omCombo({
    				onValueChange : function(target, newValue, oldValue, event) {
    					$("#deptCode2").val(newValue);
    				},
    				value : data[1].value,
    				readOnly : true
    			});
        	}else{
    	   		$('#deptName').omCombo({
    	   			onValueChange : function(target, newValue, oldValue, event) {
    	   	            $("#deptCode2").val(newValue);
    	   			}
    	   		});
    		}
        }
    });
	
	$('#buttonbar').omButtonbar({
    	btns : [{label:"新增",
    		     id:"buttonNew" ,
    		     icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
    	 		 onClick:function(){openSave();}
    			},
    			{separtor:true},	
    			 {label:"修改",
       			 id:"buttonEdit",
       		     disabled :  false,
       			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
       	 		 onClick:function(){
   	    	 			var rows = $('#tables').omGrid("getSelections",true);
   		 		 		var row = eval(rows);
   		 		 		if(row.length != 1){
   		 		 			$.omMessageBox.alert({
   	    	 		 	        content:'请选择一条记录编辑',
   	    	 		 	        onClose:function(value){
   	    	 		 	        	return false;
   	    	 		 	        }
   		 		 	        });
   	   	 		 		}else{
   	    	 			 	openUpdate(row[0].originRateId);
   		 		 		}
       	 			 }
       	        },
    	        {separtor:true},
    	        {label:"删除",
    			 	id:"buttonRemove",
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
		 				           content:'是否删除所选业务来源调整系数信息?',
		 				           onClose:function(v){
		 				               if(v){
		 				            	   for(var i = 0; row && i < row.length; i++){
		 				            		   Util.post("<%=_path%>/tLawOriginRate/deleteTLawOriginRate.do",
		            		        				"originRateId="+row[i].originRateId,
						            					function(data) {
        		            		        		});
        		 				            	  }
		 		 							 //删除成功弹出提示框
			            				 $.omMessageBox.alert({
			            						type : 'success',
						 		 	            content: "删除业务来源调整系数信息成功！"
						 		 	        });
	 		 							 //删除后刷新页面数据
		            					 setTimeout("query()", 300);
		 				               }
		 				            }
		 				       });
    	 		 		}
    	 		 	}
    	        },    	      
	    	]
	    });
	//校验的提示
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
	//加载是否禁用按钮方法
	isSelected();
	//初始化数据
	setTimeout("query()", 500);
});
//表头
var tabHand = [
	{header:"分公司代码",name:"deptCode2",width:140},
	{header:"分公司名称",name:"deptName",width:140},
	{header:"业务来源",name:"originType",width:140,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "公司业务";
			else if(value == '2')
				return "其他业务";
			else
				return "--";
		}	
	},
	{header:"业务类型",name:"bizType",width:140,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "经代及其他";
			else if(value == '2')
				return "车商";
			else
				return "--";
		}	
	},
	{header:"是否车险",name:"workFalg",width:140,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "是";
			else if(value == '0')
				return "否";
			else
				return "--";
		}	
	},
	{header:"调整系数",name:"originRate",width:140}
];

//禁用操作数据的按钮
function isSelected(){
	$.ajax({ 
		url: "<%=_path%>/reviewRank/findRolesInSystemByUserCode.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			roleEname = data;
		}
	});
	if(roleEname == "subDeptSalesman"){
		$("#buttonRemove").omButton("disable");
		$("#buttonEdit").omButton("disable");
		$("#buttonNew").omButton("disable");
	}else{
		$("#buttonRemove").omButton("enable");
		$("#buttonNew").omButton("enable");
		$("#buttonEdit").omButton("enable");
	}
}

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/tLawOriginRate/findTLawOriginRateByWhere.do?"+$("#filterFrm").serialize());
}
//初始化
function initDialog(){
	$("#addLawTargetDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:660,
		height:200,
		modal:true,
		title:"新增业务来源调整系数",
		closeOnEscape : true,
		onClose:function(){
			window.location.href = "<%=_path%>/view/law/bizOriginRate.jsp";
		},
		onOpen:function(){
			initValidate();
		}
	});
	
    $("#subBtn").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
    $("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
    
}
//打开新增
function openSave(){
	editFlag = 0;
	initDialog();
	$("#addLawTargetDiv").omDialog({title:"新增业务来源调整系数"});
	$("#addLawTargetDiv").omDialog('open');
}
//打开修改
function openUpdate(originRateId){
	editFlag = 1;
	initDialog();
	$("#addLawTargetDiv").omDialog({title:"修改业务来源调整系数"});
	$("#addLawTargetDiv").omDialog('open');
	Util.post(
			"<%=_path%>/tLawOriginRate/queryTLawOriginRateToUpdate.do?originRateId="+originRateId,
			"",
			function(data) {
				$("#lawTargetFrm").find(":input").each(function(){
					if($(this).val() != null || $(this).val() != "")
						$(this).val(data[0][$(this).attr("id")]);
				});
				$('#deptName').omCombo({value : data[0].deptName});	
				$('#originType').omCombo({value : data[0].originType});	
				$('#bizType').omCombo({value : data[0].bizType});
				$('#workFalg').omCombo({value : data[0].workFalg});
			}
	);
}

var lawFactorRules;
var lawFactorMessages;
//校验
function initValidate(){
		lawFactorRules = {
			deptName : {
				required : true
			},
			deptCode2 : {
				required : true
			},
			originType : {
				required : true
			},
			bizType:{
				required : true
			},
			workFalg:{
				required : true
			},
			originRate:{
				required : true,
				number:true
			}
		};
		lawFactorMessages = {
			deptName : {
				required : '机构名称不能为空'
			},
			deptCode2 : {
				required : '机构代码不能为空'
			},
			originType : {
				required : '业务来源不能为空'
			},
			bizType : {
				required : '业务类型不能为空'
			},
			workFalg : {
				required : '是否车险不能为空'
			},
			originRate:{
				required : '调整系数不能为空',
				number:'请输入数字'
			}
		};
	$("#lawTargetFrm").validate({
		rules: lawFactorRules,
		messages: lawFactorMessages,
		errorPlacement : function(error, element) {
	        if (error.html()) {
		        $(element).parents().map(function() {
			        if (this.tagName.toLowerCase() == 'td') {
				        var attentionElement = $(this).next().children().eq(0);
				        attentionElement.css('display', 'block');
				        attentionElement.next().html(error);
			        }
		        });
	        }
        },
        showErrors : function(errorMap, errorList) {
	        if (errorList && errorList.length > 0) {
		        $.each(errorList, function(index, obj) {
			        var msg = this.message;
			        $(obj.element).parents().map(function() {
				        if (this.tagName.toLowerCase() == 'td') {
					        var attentionElement = $(this).next().children().eq(0);
					        attentionElement.show();
					        attentionElement.next().html(msg);
				        }
			        });
		        });
	        } else {
		        $(this.currentElements).parents().map(function() {
			        if (this.tagName.toLowerCase() == 'td') {
				        $(this).next().children().eq(0).hide();
			        }
		        });
	        }
	        this.defaultShowErrors();
        },
        submitHandler : function() {
        	Util.post("<%=_path%>/tLawOriginRate/saveTLawOriginRate.do", $("#lawTargetFrm").serialize(), 
       			function(data) {
       			    $("#addLawTargetDiv").omDialog('close');
       			}
        	);
        	$("#lawTargetFrm").validate().resetForm();
        }
    });
}
//提交
function submitForm(){
	$("#lawTargetFrm").submit();
}
function cancel(){
	$("#addLawTargetDiv").omDialog('close');
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px;"><span class="label">分司名称：</span></td>
					<td><input type="text" name="formMap['deptName']" id="deptName1" /></td>
					<td style="padding-left:15px;"><span class="label">分司代码：</span></td>
					<td><input type="text" name="formMap['deptCode2']" id="deptCode"  readonly="readonly"/></td>
				    <td colspan="2" style="padding-left:15px;padding-top:5px" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<!-- 销售人员管理办法指标 -->
	<div id="addLawTargetDiv">
		<form id="lawTargetFrm">
			<input style="display:none;" name="originRateId" id="originRateId" alias="originRateId" />
			<div id="nav_cont">
				<table align="center"  class="grid_layout">
					<tr>
						<td style="padding-left:15px; align:right">分司名称：</td>
						<td class="td"><input type="text" style="width: 180px;" name="deptName" id="deptName" alias="deptName" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px; align:right">分司代码：</td>
						<td class="td"><input type="text" style="width: 180px;" name="deptCode2" id="deptCode2" alias="deptCode2"  readonly="readonly"/><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px; align:right">业务来源：</td>
						<td class="td"><input type="text" style="width: 180px;" name="originType" id="originType" alias="originType" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px; align:right">业务类型：</td>
						<td class="td"><input type="text" style="width: 180px;" name="bizType"  id="bizType" alias="bizType"  /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px; align:right">是否车险：</td>
						<td class="td"><input type="text" style="width: 180px;" name="workFalg" id="workFalg" alias="workFalg" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px; align:right">调整系数：</td>
						<td class="td"><input type="text" style="width: 180px;" name="originRate" id="originRate" alias="originRate" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr style="height: 20px;" />			
					<tr align="right">
						<td colspan="6" align="center"><a class="om-button" id="subBtn" onclick="submitForm()">保存</a>
						<a id="button-cancel"  onclick="cancel()">取消</a></td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</body>
</html>