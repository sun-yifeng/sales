<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>管理办法指标管理</title>
<style>
/*校验提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer;margin-left:-2px;}
input.error,textarea.error{border:1px solid red;}
.errorMsg{border:1px solid gray;background-color:#FCEFE3;display:none;position:absolute;margin-top:-18px;margin-left:-2px;}
</style>
<script type="text/javascript">
var dataGrid;
var roleEname;
$(function(){
	//分公司
	$.ajax({ 
		url: "<%=_path%>/common/findDeptByUserCode.do",
		type:"post",
		async: false, 
		dataType: "HTML",
		success: function(data){
			currentDept = data;
			$("#filterFrm").find("#deptCode").omCombo({
				dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
				onSuccess : function(){
					if(currentDept != '00'){
						$("#filterFrm").find("#deptCode").omCombo({value:currentDept,readOnly : true});
					}
				},
				emptyText : "请选择",
				width:150
		    });
		}
	});
	//业务线
	$("#filterFrm").find("#lineCode").omCombo({
		dataSource: <%=getCombo("bizLine")%>,
		emptyText: '请选择',
		width:150
	});
	//指标类型
	$('#dataType').omCombo({
        dataSource : <%=getCombo("dataType")%>,
        editable : false,
        emptyText : '请选择',
        width: 182
    });
	//指标所在组
	$('#indexGroup').omCombo({
        dataSource : <%=getCombo("indexGroup")%>,
        editable : false,
        emptyText : '请选择',
        width: 182
    });
	initDialog();
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#search-panel").omPanel({
    	title : "销售人员管理办法  > 管理办法指标管理",
    	collapsible:true,
    	collapsed:false
    });	
	//查询出版本信息
	$('#versionCName').omCombo({
		dataSource  :  "<%=_path%>/lawDefine/queryDefineCode.do",
		onValueChange : function(target, newValue, oldValue, event) {
            $("#versionId").val(newValue);
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		width:182
   });
   //按钮菜单	
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
   	    	 			 	openUpdate(row[0].serno);
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
		 				           content:'是否删除所选指标信息?',
		 				           onClose:function(v){
		 				               if(v){
		 				            	   for(var i = 0; row && i < row.length; i++){
		 				            		   Util.post("<%=_path%>/lawTarget/deleteLawTarget.do",
		            		        				"serno="+row[i].serno,
						            					function(data) {
        		            		        		});
        		 				            	  }
		 		 							 //删除成功弹出提示框
			            				 $.omMessageBox.alert({
			            						type : 'success',
						 		 	            content: "删除指标信息成功！"
						 		 	        });
	 		 							 //删除后刷新页面数据
		            					 setTimeout("query()", 300);
		 				               }
		 				            }
		 				       });
    	 		 		}
    	 		 	}
    	        },    	      
    	        {separtor:true},
		        {label:"指标因素关系指定",
				 	id:"factorButton",
				 	icons : {left : '<%=_path%>/images/add.png'},
		 		 	onClick:function(){
		 		 		var rows = $('#tables').omGrid("getSelections",true);
		 		 		var row = eval(rows);
		 		 		if(row.length == 0){
		 		 	        $.omMessageBox.alert({
		 		 	            content: '请选择一条记录进行关系指定操作！'
		 		 	        });
		 		 			return false;
		 		 		}else if(row.length > 1){
		 		 	        $.omMessageBox.alert({
		 		 	            content: '每次只能操作一条数据！'
		 		 	        });
		 		 			return false;
		 		 		}else{
			            	window.location.href = "indexFactor.jsp?indexCode='"+row[0].indexCode+"'"+"&indexName='"+row[0].indexName+"'"+"&dataType='"+row[0].dataType+"'"+"&orderNo='"+row[0].orderNo+"'";
		 		 		}
		 		 	}
		        },
	   	        {separtor:true},
	   	        {label:"指标计算公式配置",
	      			 id:"calButton",
	      		     //disabled :  false,
	      			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
	      			onClick:function(){
		 		 		var rows = $('#tables').omGrid("getSelections",true);
		 		 		var row = eval(rows);
		 		 		if(row.length == 0){
		 		 	        $.omMessageBox.alert({
		 		 	            content: '请选择一条记录进行计算公式配置！'
		 		 	        });
		 		 			return false;
		 		 		}else if(row.length > 1){
		 		 	        $.omMessageBox.alert({
		 		 	            content: '每次只能操作一条数据！'
		 		 	        });
		 		 			return false;
		 		 		}else{
			            	window.location.href = "tIndexCalc.jsp?indexCode='"+row[0].indexCode+"'"+"&indexName='"+row[0].indexName+"'"+"&dataType='"+row[0].dataType+"'"+"&orderNo='"+row[0].orderNo+"'";
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
      	limit:20
	});
	//初始数据
    setTimeout("query()", 500);
});
//表头
var tabHand = [
  	{header:"分公司",name:"deptName",width:100},
  	{header:"业务线",name:"lineCode",width:100},               
	{header:"指标代码",name:"indexCode",width:140},
	{header:"指标名称",name:"indexName",width:300},
 	//{header:"版本代码",name:"versionId",width:140},
	//{header:"版本名称",name:"versionCName",width:140},
	//{header:"数据单位",name:"dataUnit",width:120},
	/*{header:"指标所在组",name:"indexGroup",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '0')
				return "得分";
			else if(value == '1')
				return "薪酬";
			else
				return "--";
		}		
	},*/
	{header:"数据类型",name:"dataType",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "整数";
			else if(value == '2')
				return "小数";
			else if(value == '3')
				return "字符串";
			else
				return "--";
		}		
	},
	
	{header:"计算顺序",name:"orderNo",width:100},
	{header:"描述",name:"indexNote",width:300}
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
	$("#tables").omGrid("setData","<%=_path%>/lawTarget/queryLawTarget.do?"+$("#filterFrm").serialize());
}
//初始化
function initDialog(){
	$("#addLawTargetDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:660,
		height:280,
		modal:true,
		title:"新增管理办法指标",
		closeOnEscape : true,
		onClose:function(){
			window.location.href = "<%=_path%>/view/law/lawIndex.jsp";
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
	$("#addLawTargetDiv").omDialog({title:"新增管理办法指标"});
	$("#addLawTargetDiv").omDialog('open');
}
//打开修改
function openUpdate(serno){
	editFlag = 1;
	initDialog();
	$("#addLawTargetDiv").omDialog({title:"修改管理办法指标"});
	$("#addLawTargetDiv").omDialog('open');
	$("#indexCode").attr("readOnly","true");
	Util.post(
			"<%=_path%>/lawTarget/queryLawTargetToUpdate.do?serno="+serno,
			"",
			function(data) {
				$("#lawTargetFrm").find(":input").each(function(){
					if($(this).val() != null || $(this).val() != "")
						$(this).val(data[0][$(this).attr("id")]);
				});
				$('#versionCName').omCombo({value : data[0].versionCName});	
				$('#dataType').omCombo({value : data[0].dataType});
				$('#indexGroup').omCombo({value : data[0].indexGroup});
			}
	);
}
//
var lawFactorRules;
var lawFactorMessages;
//校验
function initValidate(){
	if(editFlag == 0){
		lawFactorRules = {
				indexCode : {
				required : true,
				remote : "<%=_path%>/lawTarget/queryIndexCode.do",
				isNotChinese : true,
				maxlength : 16
			},
				indexName : {
				required : true,
				maxlength : 128
			},
				dataType : {
				required : true
			},
			dataUnit:{
				maxlength : 16
			},
			indexGroup:{
				required : true
			},
			versionCName:{
				required : true
			},
			orderNo : {
				required : true,
				 min:100,
				 max:10000
			},
			indexNote:{
				maxlength : 256
			}
		};
		lawFactorMessages = {
				indexCode : {
				required : '指标代码不能为空',
				remote : "此代码已经被注册",
				isNotChinese : '指标代码不能包含中文',
				maxlength : '指标代码最长16位'
			},
				indexName : {
				required : '指标名称不能为空',
				maxlength : '指标名称最长128位'
			},
				dataType : {
				required : '数据类型不能为空'
			},
				dataUnit : {
				maxlength : '数据单位最长16位'
			},
			indexGroup:{
				required : '指标所在组不能为空'
			},
			versionCName:{
				required : '版本名称不能为空'
			},
				orderNo : {
				required : '计算顺序不能为空',
						 min:'计算顺序最小为100',
						 max:'计算顺序最大为10000'
			},
				indexNote : {
				maxlength : '数据单位最长256位'
			}
		};
	} else{
		lawFactorRules = {
				indexCode : {
				required : true,
				maxlength : 16
			},
				indexName : {
				required : true,
				maxlength : 128
			},
				dataType : {
				required : true
			},
			dataUnit:{
				maxlength : 16
			},
			indexGroup:{
				required : true
			},
			versionCName:{
				required : true
			},
				orderNo : {
				required : true,
						 min:100,
						 max:10000
			},
				indexNote:{
				maxlength : 256
			}
		};
		lawFactorMessages = {
				indexCode : {
				required : '指标代码不能为空',
				maxlength : '指标代码最长16位'
			},
				indexName : {
				required : '指标名称不能为空',
				maxlength : '指标名称最长128位'
			},
				dataType : {
				required : '数据类型不能为空'
			},
				dataUnit : {
				maxlength : '数据单位最长16位'
			},
			indexGroup:{
				required : '指标所在组不能为空'
			},
			versionCName:{
				required : '版本名称不能为空'
			},
			orderNo : {
				required : '计算顺序不能为空',
						 min:'计算顺序最小为100',
						 max:'计算顺序最大为10000'
			},
				indexNote : {
				maxlength : '数据单位最长256位'
			}
		};
	} 
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
        	Util.post("<%=_path%>/lawTarget/saveLawTarget.do", $("#lawTargetFrm").serialize(), 
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
					<td style="padding-left:15px;"><span class="label">分公司：</span></td>
					<td><input type="text" name="formMap['deptCode']" id="deptCode" /></td>
					<td style="padding-left:15px;"><span class="label">业务线：</span></td>
					<td><input type="text" name="formMap['lineCode']" id="lineCode" /></td>
					<td style="padding-left:15px;"><span class="label">指标代码：</span></td>
					<td><input type="text" name="formMap['indexCode']" id="indexCode1" /></td>
					<td style="padding-left:15px;"><span class="label">指标名称：</span></td>
					<td><input type="text" name="formMap['indexName']" id="indexName" /></td>
				    <td colspan="2" style="padding-left:15px;padding-top:5px" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<!-- 新增管理办法指标 -->
	<div id="addLawTargetDiv" align="center">
		<form id="lawTargetFrm">
			<input style="display: none;" name="serno" id="serno" alias="serno" />
			<div>
				<table>
					<tr>
						<td style="padding-left:15px; align:right">版本名称：</td>
						<td class="td"><input type="text" style="width: 180px;" name="versionCName" id="versionCName" alias="versionCName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px; align:right">版本代码：</td>
						<td class="td"><input type="text" style="width: 180px;" name="versionId"  id="versionId" alias="versionId"  readonly="readonly"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px; align:right">指标代码：</td>
						<td class="td"><input type="text" style="width: 180px;" name="indexCode" id="indexCode" alias="indexCode" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px; align:right">指标名称：</td>
						<td class="td"><input type="text" style="width: 180px;" name="indexName" id="indexName" alias="indexName" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px; align:right">数据类型：</td>
						<td class="td"><input type="text" style="width: 180px;" name="dataType" id="dataType" alias="dataType" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:3px; align:right">指标所在组：</td>
						<td class="td"><input type="text" style="width: 180px;" name="indexGroup" id="indexGroup" alias="indexGroup" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px; align:right">数据单位：</td>
						<td class="td"><input type="text" style="width: 180px;" name="dataUnit" id="dataUnit" alias="dataUnit" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px; align:right">计算顺序：</td>
						<td class="td"><input type="text" style="width: 180px;" name="orderNo" id="orderNo" alias="orderNo" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px; align:right">指标描述：</td>
						<td class="td"><input type="text" style="width: 180px;" name="indexNote" id="indexNote" alias="indexNote" /></td>
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