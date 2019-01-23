<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>管理办法因素管理</title>
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
.fontClass{
	font-size:12px;
	font-family: 微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun;
}  
</style>

<% String indexCode = request.getParameter("indexCode"); %>
<% String indexName = request.getParameter("indexName"); %>
<% String dataType = request.getParameter("dataType"); %>
<% String orderNo = request.getParameter("orderNo"); %>
<script type="text/javascript">
var indexCode = <%=indexCode%>;
var indexName = <%=indexName%>;
var dataGrid;
var dialog;
var roleEname;
$(function(){	
	$("#addTIndexCalFrm").find("input[name^='formMap']").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	//
	$('#indexCode').val(indexCode);
	$('#indexName').val(indexName);
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
		width : 133
   });
	
	$('#condType').omCombo({
        dataSource : <%=Constant.getCombo("condType")%>,
        editable : false,
        emptyText : '请选择',
        width : 133
    });
	
	//列表的高度
	var btInput = $("#buttonbar");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight()+80;
  	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    } 
  	
	//列表的高度
	var btInput = $("#buttonbars");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight()+20;
  	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnums = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnums = topnums + 2;
    } 
  	
  	$("#subBtn").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
 	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
  	
	dataGrid = $("#tables").omGrid({
		colModel:tabHand,
		showIndex : false,
        singleSelect : false,
        height:topnum,
        method : 'POST',
      	limit:10
	});
	
	//指标计算公式配置-弹出页面
  	$("#tabless").omGrid({
		colModel:tabHands,
		showIndex : false,
        singleSelect : true,
        height:350,
        method : 'POST',
      	limit:0
	});
	
	initDialog();
    //导航页面
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
    //导航菜单
	$("#search-panel").omPanel({
    	title : "销售人员管理办法  > 管理办法指标管理 > 指标计算公式配置",
    	collapsible:true,
    	collapsed:false
    });	
    //按钮菜单
	$('#buttonbar').omButtonbar({
    	btns : [{label:"新增",
    		     id:"buttonNew" ,
    		     icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
    	 		 onClick:function(){
    	 			//给指标参数赋值
    	 			queryTIndexFactor();
    	 			openSave();
   	 			 }
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
	 		 		queryTIndexFactor();
	 		 		
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
	 				           content:'是否删除所选指标公式配置信息?',
	 				           onClose:function(v){
	 				               if(v){
	 				            	   for(var i = 0; row && i < row.length; i++){
	 				            		   Util.post("<%=_path%>/tIndexCalc/deleteTIndexCalc.do",
	            		        				"serno="+row[i].serno,
					            					function(data) {
       		            		        		});
       		 				            	  }
	 		 							 //删除成功弹出提示框
		            				 $.omMessageBox.alert({
		            						type : 'success',
					 		 	            content: "删除指标公式配置信息成功！"
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
	
	//校验的提示
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    }); 
	//加载是否禁用按钮方法
	isSelected();
	//初始数据
	query();
});

//指标计算公式配置表头
var tabHand = [
       	{header:"指标代码",name:"indexCode",width:140},
       	{header:"指标代码",name:"indexName",width:140},
    	{header:"版本代码",name:"versionId",width:140},
    	{header:"版本名称",name:"versionCname",width:140},
       	{header:"公式类型",name:"condType",width:140,
    		renderer : function(value, rowData , rowIndex) {
    			if (value == '0')
    				return "不可编辑";
    			else if(value == '1')
    				return "可编辑";
    			else
    				return "--";
    		}		
       	},
       	{header:"计算公式",name:"ret",width:180},
       	{header:"计算条件",name:"cond",width:140},
       	{header:"计算顺序",name:"orderNo",width:140},
     ];

var tabHands = [
		{header:"指标或因素代码",name:"factorCode",width:100},
		{header:"指标或因素名称",name:"itemName",width:200},
		{header:"表现形式",name:"exhibitType",width:200,
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
		},
		{header:"计算条件的顺序",name:"orderNo",width:200},
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
	$("#tables").omGrid("setData","<%=_path%>/tIndexCalc/queryTIndexCalc.do?"+$("#tIndexCalcFrm").serialize());
} 
//初始化
function initDialog(){
	dialog = $("#addTIndexCalcDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:800,
		height:550,
		modal:true,
		title:"新增管理办法公式配置",
		closeOnEscape : true,
		onClose:function(){
        	$('.errorImg').hide();
			$("#addTIndexCalFrm").validate().resetForm();
			//$("#addTIndexCalcDiv").omDialog('close');
			query();
		},
		onOpen:function(){
			initValidate();
		}
	});
}

function queryTIndexFactor(){
	$("#tabless").omGrid("setData","<%=_path%>/tIndexFactor/queryTIndexFactor.do?"+$("#tIndexCalcFrm").serialize());
}

//打开新增
function openSave(){
	initDialog();
	$("#addTIndexCalFrm").find(":input").each(function(){
		$(this).val("");
		//$(this).css("border","1px solid #000000");
	});
	$('#condType').omCombo({
        dataSource : <%=Constant.getCombo("condType")%>,
        editable : false,
        emptyText : '请选择',
        value:"1",
        width : 133
    });
	var newIndexCode =$('#indexCode').val();
	$('#indexCode1').val(newIndexCode);
	$('#newIndexCode').val(newIndexCode);
	$("#addTIndexCalcDiv").omDialog({title:"新增管理办法公式配置"});
	$("#addTIndexCalcDiv").omDialog('open');
}
//打开修改
function openUpdate(serno){
	initDialog();
	$("#addTIndexCalcDiv").omDialog({title:"修改管理办法公式配置"});
	$("#addTIndexCalcDiv").omDialog('open');
	Util.post(
			"<%=_path%>/tIndexCalc/queryTIndexCalcToUpdate.do?serno="+serno,"",
			function(data) {
				$("#addTIndexCalFrm").find(":input").each(function(){
					if($(this).val() != null || $(this).val() != "")
						$(this).val(data[0][$(this).attr("name")]);
				});
				$('#condType').omCombo({value : data[0].condType});
				$('#versionCname').omCombo({value : data[0].versionCname});
			}
	);
}


var indexFactorRules;
var indexFactorMessages;
//校验
function initValidate(){
	indexFactorRules = {
			indexCode : {
				required : true
			},
			ret : {
				required : true,
				isChineses : true
			},
			condType : {
				required : true
			},
			cond : {
				required : true,
				//isLetterAndInteger : true,
				isChineses : true
			},
			orderNo : {
				required : true,
				min:100,
				max:10000
			},
			versionCname : {
				required : true
			}
		};
	indexFactorMessages = {
			indexCode : {
				required : '指标代码不能为空'
			},
			ret : {
				required : '值或公式不能为空'
			},
			condType : {
				required : '公式类型不能为空'
			},
			cond : {
				required : '计算条件不能为空'
			},
			orderNo : {
				required : '计算顺序不能为空',
				min:'计算顺序最小为100',
				max:'计算顺序最大为10000'
			},
			versionCname : {
				required : '版本名称不能为空'
			}
		};
	$("#addTIndexCalFrm").validate({
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
        	Util.post("<%=_path%>/tIndexCalc/saveTIndexCalc.do", $("#addTIndexCalFrm").serialize(), 
       			function(data) {
	        		setTimeout("query()", 300);
	        		$("#addTIndexCalcDiv").omDialog('close');
       			}
        	);
        }
    });
}
//提交
function submitForm(){
	$("#addTIndexCalFrm").submit();
}

function cancel(){
	$("#addTIndexCalcDiv").omDialog('close');
}

</script>
</head>
<body>
    <div>
	   <form id="tIndexCalcFrm">
			<div id="search-panel">
				<table class="fontClass">      
					<tr>
						<td style="padding-left: 30px" align="right"><span class="label">指标代码：</span></td>
						<td><input name="formMap['indexCode']" id="indexCode" class="sele" readonly="readonly"/></td>
						<td style="padding-left: 30px;" align="right">指标名称：</td>
						<td><input name="indexName" id="indexName" class="sele" readonly="readonly"/></td>
						<td></td>
					</tr>
				</table>
			</div>
		</form>
	</div>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<!-- grid 组件 -->
	<div id="tables"></div>
	<!-- 新增管理办法（弹出页面）  -->
	<div id="addTIndexCalcDiv">
	<fieldSet style="margin-top: 10px;">
		<!-- <legend class="fontClass" style="margin-left: 40px;">带（*）号未必填 </legend> -->
		<form id="addTIndexCalFrm">
			<input style="display: none;" name="serno" id="serno" alias="serno" />
			<div id="nav_cont">
				<table class="fontClass">
					 <tr>
						<td style="padding-left:15px; align:right">指标代码：</td>
						<td class="td"><input  type="text" name="indexCode" id="newIndexCode" alias="indexCode" class="sele" readonly="readonly"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px; align:right">值或公式：</td>
						<td ><input  type="text" name="ret" id="ret" alias="ret" class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px; align:right">计算条件：</td>
						<td ><input  type="text" name="cond" id="cond" alias="cond" class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px; align:right">公式类型：</td>
						<td ><input   type="text" name="condType" id="condType" alias="condType" class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td> 
						
						<td style="padding-left:15px; align:right">计算顺序：</td>
						<td class="td"><input  type="text" name="orderNo" id="orderNo" alias="orderNo" class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						
						<td style="padding-left:15px; align:right">版本名称：</td>
						<td class="td"><input  type="text"  name="versionCname" id="versionCname" alias="versionCname" class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px; align:right">版本代码：</td>
						<td class="td"><input  type="text"  name="versionId" id="versionId" alias="versionId"  readonly="readonly" class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						
						<td colspan="6" align="right"><a class="om-button" id="subBtn" onclick="submitForm()">保存</a>
						<a id="button-cancel"  onclick="cancel()">返回</a></td>
					</tr>
				</table>
			</div>
		</form>
	</fieldSet>
	<div id="buttonbars" style="margin-bottom: 0px;"></div>
	<table id="tabless"></table>
<!-- 		<div>
		<table>
			<tr align="right">
				<td colspan="2" align="center"><a class="om-button" id="subBtn" onclick="submitForm()">保存</a>
				<a id="button-cancel"  onclick="cancel()">取消</a></td>
			</tr>
		</table>
		</div>  -->
	</div>
</body>
</html>