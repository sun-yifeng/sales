<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<% String indexCode = request.getParameter("indexCode"); %>
<% String indexName = request.getParameter("indexName"); %>
<% String dataType = request.getParameter("dataType"); %>
<% String orderNo = request.getParameter("orderNo"); %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>指标因素关系指定</title>

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
var indexCode = <%=indexCode%>;
var indexName = <%=indexName%>;
var dataType = <%=dataType%>;
var orderNo = <%=orderNo%>;
var dataGrid;
var factorOrIndex;
var flag;
var btnArray = ["button-search","subBtn"];
var roleEname;
$(function(){
	$('#indexCode1').val(indexCode);
	$('#indexName1').val(indexName);
	$('#orderNo').val(orderNo);
	if(dataType == '1'){
		$('#dataType').val("小数");
	}else if(dataType == '2'){
		$('#dataType').val("整数");
	}else if(dataType == '3'){
		$('#dataType').val("字符串");
	}else{
		$('#dataType').val("--");
	}
	
	 //指标类型
	$('#dataType').omCombo({
        dataSource : <%=Constant.getCombo("dataType")%>,
        editable : false,
        emptyText : '请选择',
        readOnly : true,
        width: 135
    });
 	 //表现形式
	$('#exhibitType').omCombo({
        dataSource : <%=Constant.getCombo("exhibitType")%>,
        editable : false,
        emptyText : '请选择',
        width: 182
    }); 
	//列表高度
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
    	title : "销售人员管理办法  > 管理办法指标管理 > 指标因素关系指定",
    	collapsible:true,
    	collapsed:false
    });	
	$('#buttonbar').omButtonbar({
    	btns : [{label:"新增因素关系",
    		     id:"addFactor" ,
    		     icons : {left : '<%=_path%>/images/add.png'},
    	 		 onClick:function(){
    	 			 factorOrIndex = 1;
    	 			 openSave(factorOrIndex);
    	 			 }
    			},
    			{separtor:true},
    			{label:"新增指标关系",
    		     id:"addIndex" ,
    		     icons : {left : '<%=_path%>/images/add.png'},
    	 		 onClick:function(){
    	 			 factorOrIndex = 2;
    	 			 openSave(factorOrIndex);
    	 			 }
    			},
    			
    			{separtor:true},
    			 {label:"修改",
       			 id:"buttonEdit",
       		     disabled :  false,
       			 icons : {left : '<%=_path%>/images/op-edit.png'},
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
   	   	 		 			flag = row[0].factorCode.substring(0, 1);
   	   	 		 			if(flag == "F"){
   	   	 		 				factorOrIndex = 1;
   	   	 		 			}else{
   	   	 		 				factorOrIndex = 2;
   	   	 		 			}
   	    	 			 	openUpdate(row[0].serno,factorOrIndex);
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
		 				           content:'是否删除所选指标因素关系信息?',
		 				           onClose:function(v){
		 				               if(v){
		 				            	   for(var i = 0; row && i < row.length; i++){
		 				            		   Util.post("<%=_path%>/tIndexFactor/deleteTIndexFactor.do",
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
    	        {label:"返回",
       			 id:"button-back",
       		     disabled :  false,
       			 icons : {left : '<%=_path%>/images/remove.png'},
       	 		 onClick:function(){
       	 			window.location.href = "lawIndex.jsp";	 
       	 		 }
       	      }
    	]
    });
	
	//查询出版本信息
	$('#versionCname').omCombo({
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
	
	//查询出指标信息
	$('#itemName1').omCombo({
		dataSource  :  "<%=_path%>/lawTarget/queryCodeAndName.do?indexCode="+indexCode,
		onValueChange : function(target, newValue, oldValue, event) {
            $("#factorCode1").val(newValue);
            if(factorOrIndex == 2){
            	$("#factorCode").val($("#factorCode1").val());
            }
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		width:182
   });
	
	//查询出因素信息
	$('#itemName').omCombo({
		dataSource  :  "<%=_path%>/lawFactor/queryCodeAndName.do",
		onValueChange : function(target, newValue, oldValue, event) {
			$("#factorCode").val(newValue);
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		width:182
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
	query();
});
//表头
var tabHand = [
	{header:"指标代码",name:"indexCode",width:140},
	{header:"指标名称",name:"indexName",width:150},
	{header:"因素或指标代码",name:"factorCode",width:140},
	{header:"因素或指标名称",name:"itemName",width:240},
	{header:"版本代码",name:"versionId",width:140},
	{header:"版本名称",name:"versionCName",width:140},
	{header:"显示顺序",name:"orderNo",width:100},
	{header:"表现形式",name:"exhibitType",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "等于";
			else if(value == '2')
				return "区间";
			else if(value == '3')
				return "枚举";
			else
				return "--";
		}		
	}
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
		$("#addFactor").omButton("disable");
		$("#addIndex").omButton("disable");
		$("#buttonEdit").omButton("disable");
		$("#buttonRemove").omButton("disable");
	}else{
		$("#addFactor").omButton("enable");
		$("#addIndex").omButton("enable");
		$("#buttonEdit").omButton("enable");
		$("#buttonRemove").omButton("enable");
	}
}

 //查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/tIndexFactor/queryTIndexFactor.do?"+$("#filterFrm").serialize());
	//加载是否禁用按钮方法
	isSelected();
} 
//初始化
function initDialog(){
	$("#addIndexFactorDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:660,
		height:220,
		modal:true,
		title:"新增指标因素关系",
		closeOnEscape : true,
		onClose:function(){
			$('.errorImg').hide();
			$("#indexFactorFrm").validate().resetForm();
			//$("#addIndexFactorDiv").omDialog('close');
			query();
		},
		onOpen:function(){
			initValidate();
		}
	});
	
    $("#subBtn").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
    $("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
}
//打开新增
function openSave(factorOrIndex){
	initDialog();
	$("#addIndexFactorDiv").omDialog({title:"新增指标或因素关系"});
	$("#addIndexFactorDiv").omDialog('open');
	//判断是新增因素关系还是指标关系
	if(factorOrIndex == 1){
 		$("#indexTr").hide();
		$("#factorTr").show(); 
		 $('#itemName1').val('');
		 $('#factorCode1').val('');
		 $('#itemName').rules('add',{
			 required:true,
		      messages: {
		    	  required: jQuery.format("因素名称不能为空")
		      }
		  });
		 $("#itemName1").rules("remove"); 
	}else{
 		$("#indexTr").show();
		$("#factorTr").hide(); 
		 $('#itemName').val('');
		 $('#factorCode').val('');
		 $('#itemName1').rules('add',{
			 required:true,
		      messages: {
		    	  required: jQuery.format("指标名称不能为空"),
		      }
		  });
		 $("#itemName").rules("remove"); 
	}
	$("#indexFactorFrm").find(":input").each(function(){
		$(this).val("");
	});
	//给指标参数赋值
	 $('#indexCode').val(indexCode);
	$('#indexName').val(indexName);
}
//打开修改
function openUpdate(serno,factorOrIndex){
	initDialog();
	//给指标参数赋值
	$("#addIndexFactorDiv").omDialog({title:"修改指标因素关系"});
	$("#addIndexFactorDiv").omDialog('open');

	Util.post(
			"<%=_path%>/tIndexFactor/queryTIndexFactorToUpdate.do?serno="+serno,
			"",
		function(data) {
			$("#indexFactorFrm").find(":input").each(function(){
				if($(this).val() != null || $(this).val() != "")
					$(this).val(data[0][$(this).attr("id")]);
			});
			//判断是修改因素关系还是指标关系
			if(factorOrIndex == 1){
 				$("#indexTr").hide();
				$("#factorTr").show();   
				$('#itemName').omCombo({value : data[0].itemName});
			}else{
		  		$("#indexTr").show();
				$("#factorTr").hide();   
				$('#itemName1').omCombo({value : data[0].itemName});
				$("#factorCode1").val(data[0].factorCode);
				$("#factorCode").val(data[0].factorCode);
			}
				$('#exhibitType').omCombo({value : data[0].exhibitType});
				$('#versionCname').omCombo({value : data[0].versionCname});
			}
	);
}

var indexFactorRules;
var indexFactorMessages;
//校验
function initValidate(){
	indexFactorRules = {
			versionCname : {
				required : true
			},
			exhibitType:{
				required : true
			},
			orderNo : {
				required : true,
				min:100,
				max:10000
			}
		};
	indexFactorMessages = {
			versionCname : {
				required : '版本名称不能为空'
			},
			exhibitType : {
				required : '表现形式不能为空'
			},
			orderNo : {
				required : '显示顺序不能为空',
				min:'显示顺序最小为100',
				max:'显示顺序最大为10000'
			}
		};
	$("#indexFactorFrm").validate({
		rules: indexFactorRules,
		messages: indexFactorMessages,
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
        	Util.post("<%=_path%>/tIndexFactor/saveTIndexFactor.do", $("#indexFactorFrm").serialize(), 
       			function(data) {
	        		setTimeout("query()", 300);
	        		$("#addIndexFactorDiv").omDialog('close');
       			}
        	);
        }
    });
}
//提交
function submitForm(){
	$("#indexFactorFrm").submit();
}

function cancel(){
	$("#addIndexFactorDiv").omDialog('close');
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<fieldSet style="margin-top: 5px;">
			<legend style="margin-left: 40px;font-size:12px;">指标参数</legend>
			<table>
				<tr>
					<td style="padding-left:15px;"><span class="label">指标代码：</span></td>
					<td><input type="text" name="formMap['indexCode']"  id="indexCode1"  readonly="readonly"/></td>
					<td style="padding-left:15px;"><span class="label">指标名称：</span></td>
					<td><input type="text" name="formMap['indexName']"  id="indexName1"  readonly="readonly"/></td>
					<td style="padding-left:15px;"><span class="label">数据类型：</span></td>
					<td><input type="text" name="formMap['dataType']"  id="dataType"  readonly="readonly"/></td>
					<td style="padding-left:15px;"><span class="label">计算顺序：</span></td>
					<td><input type="text"  id="orderNo" readonly="readonly"/></td>
				</tr>
			</table>
			</fieldSet>
		</div>
	</form>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<!-- 新增销售人员管理办法指标因素关系 -->
	<div id="addIndexFactorDiv">
		<form id="indexFactorFrm">
			<input style="display: none;" name="serno" id="serno" alias="serno" />
			<div id="nav_cont">
				<table style="align:center" class="grid_layout">
					<tr>
						<td style="padding-left:15px; align:right">指标代码：</td>
						<td class="td"><input type="text" style="width: 180px;" name="indexCode" id="indexCode" alias="indexCode"  readonly="readonly"/></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px; align:right">指标名称：</td>
						<td class="td"><input type="text" style="width: 180px;" name="indexName" id="indexName" alias="indexName"  readonly="readonly"/></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr id="factorTr">
						<td style="padding-left:15px; align:right">因素名称：</td>
						<td class="td"><input type="text" style="width: 160px;" name="itemName" id="itemName" alias="itemName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px;align:right">因素代码：</td>
						<td class="td"><input type="text" style="width: 180px;" name="factorCode" id="factorCode" alias="factorCode"  readonly="readonly"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr id="indexTr">
						<td style="padding-left:15px; align:right">指标名称：</td>
						<td class="td"><input type="text" style="width: 160px;" name="itemName1" id="itemName1" alias="itemName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px;align:right">指标代码：</td>
						<td class="td"><input type="text" style="width: 180px;" name="factorCode1" id="factorCode1" alias="factorCode"  readonly="readonly"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px; align:right">版本名称：</td>
						<td class="td"><input type="text" style="width: 180px;" name="versionCname" id="versionCname" alias="versionCname" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px; align:right">版本代码：</td>
						<td class="td"><input type="text" style="width: 180px;" name="versionId" id="versionId" alias="versionId"  readonly="readonly"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px; align:right">表现形式：</td>
						<td class="td"><input type="text" style="width: 180px;" name="exhibitType" id="exhibitType" alias="exhibitType" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px; align:right">显示顺序：</td>
						<td class="td"><input type="text" style="width: 180px;" name="orderNo" id="orderNo" alias="orderNo" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr style="height: 20px;" />			
					<tr >
						<td colspan="6" align="center"><a class="om-button" id="subBtn" onclick="submitForm()">保存</a>
						<a id="button-cancel"  onclick="cancel()">取消</a></td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</body>
</html>