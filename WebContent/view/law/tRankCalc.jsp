<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>管理办法职级</title>
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

<% String rankCode = request.getParameter("rankCode"); %>
<% String rankName = request.getParameter("rankName"); %>
<% String condType = request.getParameter("condType"); %>
<% String exhibitType = request.getParameter("exhibitType"); %>
<script type="text/javascript">
var rankCode = "<%=rankCode%>";
var rankName = "<%=rankName%>";
var condType = "<%=condType%>";
var exhibitType = "<%=exhibitType%>";
var roleEname;
var dataGrid;
//alert(11111);
$(function(){	
	
	$("#addTRankCalFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});	
	$('#rankCode').val(rankCode);
	$('#rankName').val(rankName);
	$('#condType').val(condType);
	$('#exhibitType').val(exhibitType);
	//列表的高度
	var btInput = $("#buttonbar");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight()+68;
  	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    } 
  	
  	var btInputs = $("#buttonbars");
  	var btOffsets = btInputs.offset();
  	var btnums = btOffsets.top+btInputs.outerHeight()+72;
  	var bdInputs = $("body");
	var bdOffsets = bdInputs.offset();
	var bdnums = bdOffsets.top+bdInputs.outerHeight();
	var topnums = bdnums - btnums;
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
  	
	//
	$("#tabless").omGrid({
		colModel:tabHands,
		showIndex : false,
        /* singleSelect : false, */
        //height:topnums,
        height:350,
        method : 'POST',
      	limit : 0
	});
	
	initDialog();
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#search-panel").omPanel({
    	title : "管理办法  > 管理办法职级 > 职级计算公式配置",
    	collapsible:true,
    	collapsed:false
    });	
	
	 $('#exhibitType').omCombo({
        dataSource : <%=Constant.getCombo("exhibitType")%>,
        editable : false,
        emptyText : '请选择',
    }); 
	 
	$('#condType').omCombo({
        dataSource : <%=Constant.getCombo("condType")%>,
        editable : false,
        emptyText : '请选择',
        value:"1",
    });
	
	$('#changeType').omCombo({
        dataSource : <%=Constant.getCombo("changeType")%>,
        editable : false,
        emptyText : '请选择',
        width : 133
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
		width : 133
   });

	$('#buttonbar').omButtonbar({
    	btns : [{label:"新增",
    		     id:"buttonNew" ,
    		     icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
    	 		 onClick:function(){
    	 			//给指标参数赋值
    	 			queryTRankFactor();
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
	 		 		queryTRankFactor();
	 		 		
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
	 				           content:'是否删除所选职级公式配置信息?',
	 				           onClose:function(v){
	 				               if(v){
	 				            	   for(var i = 0; row && i < row.length; i++){
	 				            		   Util.post("<%=_path%>/tRankCalc/deleteTRankCalc.do",
	            		        				"serno="+row[i].serno,
					            					function(data) {
       		            		        		});
       		 				            	  }
	 		 							 //删除成功弹出提示框
		            				 $.omMessageBox.alert({
		            						type : 'success',
					 		 	            content: "删除职级公式配置信息成功！"
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
       	 			window.location.href = "lawRank.jsp";	 
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

var tabHand = [
        {header:"版本号",name:"versionId",width:120}, 
        {header:"版本名称",name:"versionCname",width:130}, 
       	{header:"职级代码",name:"rankCode",width:128},
       	{header:"职级名称",name:"rankName",width:120},
       	{header:"公式类型",name:"condType",width:130,
    		renderer : function(value, rowData , rowIndex) {
    			if (value == '0')
    				return "不可编辑";
    			else if(value == '1')
    				return "可编辑";
    			else 
    				return "--";
    		}
       	},
       	
       	{header:"计算条件",name:"cond",width:160},
       	{header:"目标职级代码",name:"targetRankCode",width:140},
       	{header:"职级计算结果",name:"changeType",width:120,
       		renderer : function(value, rowData , rowIndex) {
       			if(value == '1R')
       				return "升级";
       			else if(value == '2S')
       				return "维持";
       			else if(value == '3D')
       				return "降级";
       			else if(value =="4T")
       				return "离职";
       			else 
       				return "--" + value;
       		}
       	},
       	{header:"计算顺序",name:"orderNo",width:120},
     ];

var tabHands = [
		{header:"职级代码",name:"rankCode",width:100},
		{header:"职级名称",name:"rankName",width:180},
		{header:"指标或因素的代码",name:"factorCode",width:100},
		{header:"指标或因素的名称",name:"itemName",width:150},
		{header:"表现形式",name:"exhibitType",width:180,
			renderer : function(value, rowData , rowIndex) {
				if (value == '1')
					return "等于";
				else if(value == '2')
					return "区间";
				else if(value == '3')
					return "枚举";
				else
					return "";
			}		
		},
		{header:"计算条件的顺序",name:"orderNo",width:100}
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
	$("#tables").omGrid("setData","<%=_path%>/tRankCalc/queryTRankCalc.do?"+$("#tRankCalcFrm").serialize());
} 
//初始化
function initDialog(){
	$("#addTRankCalcDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:900,
		height:550,
		modal:true,
		title:"新增管理办法职级公式配置",
		closeOnEscape : true,
		onClose:function(){
			$('.errorImg').hide();
			$("#addTRankCalFrm").validate().resetForm();
			query();
		},
		onOpen:function(){
			initValidate();
		}
	});
}

function queryTRankFactor(){
	$("#tabless").omGrid("setData","<%=_path%>/tRankFactor/queryTRankFactor.do?"+$("#tRankCalcFrm").serialize());
}

//打开新增
function openSave(){
	initDialog();
	$("#addTRankCalFrm").find(":input").each(function(){
		$(this).val("");
	}); 
	$('#condType').omCombo({
        dataSource : <%=Constant.getCombo("condType")%>,
        editable : false,
        emptyText : '请选择',
        value:"1",
        width : 112
    });
	var newRankCode =$('#rankCode').val();
	$('#newRankCode').val(newRankCode);
	$("#addTRankCalcDiv").omDialog({title:"新增管理办法职级公式配置"});
	$("#addTRankCalcDiv").omDialog('open');
}
function openUpdate(serno){
	initDialog();
	$("#addTRankCalcDiv").omDialog({title:"修改管理办法职级公式配置"});
	$("#addTRankCalcDiv").omDialog('open');
	Util.post(
			"<%=_path%>/tRankCalc/queryTRankCalcToUpdate.do?serno="+serno,"",
			function(data) {
				$("#addTRankCalFrm").find(":input").each(function(){
					if($(this).val() != null || $(this).val() != "")
						$(this).val(data[0][$(this).attr("name")]);
				});
				$('#changeType').omCombo({value : data[0].changeType}); 
				$('#condType').omCombo({value : data[0].condType});
				$('#versionCname').omCombo({value : data[0].versionCname});
			}
	);
}


var indexFactorRules;
var indexFactorMessages;
function initValidate(){
	indexFactorRules = {
			rankCode : {
				required : true
			},
			changeType : {
				required : true
			}, 
			targetRankCode : {
				required : true
			}, 
			orderNo : {
				required : true,
				min:100,
				max:10000
			},
			cond : {
				required : true
			},
			condType : {
				required : true
			},
			versionCname : {
				required : true
			},
			versionId : {
				required : true
			}
		};
	indexFactorMessages = {
			rankCode : {
				required : '职级代码不能为空'
			},
			targetRankCode : {
				required : '职级变化类型不能为空'
			}, 
			changeType : {
				required : '目标职级代码不能为空'
			}, 
			orderNo : {
				required : '计算顺序不能为空',
				min:'计算顺序最小为100',
				max:'计算顺序最大为10000'
			},
			cond : {
				required : '计算条件不能为空'
			},
			condType : {
				required : '公式类型不能为空'
			},
			versionCname : {
				required : '版本名称不能为空'
			},
			versionId : {
				required : '版本号不能为空'
			}
		};
	$("#addTRankCalFrm").validate({
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
        	Util.post("<%=_path%>/tRankCalc/saveTRankCalc.do", $("#addTRankCalFrm").serialize(), 
       			function(data) {
	        		setTimeout("query()", 300);
	        		$("#addTRankCalcDiv").omDialog('close');
       			}
        	);
        }
    });
}
//提交
function submitForm(){
	$("#addTRankCalFrm").submit();
}

function cancel(){
	$("#addTRankCalcDiv").omDialog('close');
}

</script>
</head>
<body>
<div>
		<!-- <fieldSet style="margin-top: 10px;"> -->
		<!-- <legend class="fontClass" style="margin-left: 40px;">指标参数 </legend> -->
			<form id="tRankCalcFrm">
				<div id="search-panel">
				<table class="fontClass">
					<tr>
						<td style="padding-left: 30px" align="right"><span class="label">职级代码：</span></td>
						<td><input name="formMap['rankCode']" id="rankCode" class="sele" readonly="readonly"/></td>
						<!-- <td><span class="errorImg"></span><span class="errorMsg"></span></td> -->
						<td style="padding-left: 30px;" align="right">职级名称：</td>
						<td><input name="rankName" id="rankName" class="sele" readonly="readonly" /></td>
						<!-- <td style="padding-left: 30px;" align="right">表现形式：</td>
						<td><input name="exhibitType" id="exhibitType" class="sele"/></td> -->
						<td></td>
					</tr>
				</table>
				</div>
			</form>
		<!-- </fieldSet> -->
	</div>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<!-- 新增管理办法 class="td" alias="rankCode" -->
	<div id="addTRankCalcDiv">
	 	<fieldSet style="margin-top: 10px;"> 
		<!-- <legend class="fontClass" style="margin-left: 40px;">带（*）号未必填 </legend> -->
		<form id="addTRankCalFrm">
			<input style="display: none;" name="serno" id="serno" alias="serno" />
			<div id="nav_cont">
				<table class="fontClass">
					 <tr>
						<td align="right">职级代码：</td>
						<td class="td"><input type="text" name="rankCode" id="newRankCode" alias="rankCode" readonly="readonly"  class="sele"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						
						<td align="right">计算结果：</td>
						<td ><input type="text" name="changeType" id="changeType" alias="changeType" readonly="readonly"  class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>

						<td align="right">目标职级代码：</td>
						<td class="td"><input type="text" name="targetRankCode" id="targetRankCode" alias="targetRankCode"  class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td align="right">计算顺序：</td>
						<td class="td"><input type="text" name="orderNo" id="orderNo" alias="orderNo"  class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						
						<td align="right">计算条件：</td>
						<td class="td"><input type="text" name="cond" id="cond" alias="cond"  class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						
						<td align="right">公式类型：</td>
						<td class="td"><input type="text" name="condType" id="condType" alias="condType"  class="sele1" style="width:112px;"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px; align:right">版本名称：</td>
						<td class="td"><input type="text"  name="versionCname" id="versionCname" alias="versionCname"  class="sele1"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
												
						<td style="padding-left:30px; align:right">版本代码：</td>
						<td class="td"><input type="text"  name="versionId" id="versionId" alias="versionId"  readonly="readonly"  class="sele" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						
						<td colspan="2" align="right"><a class="om-button" id="subBtn" onclick="submitForm()">保存</a>
						<a id="button-cancel"  onclick="cancel()">返回</a></td>
					</tr>
				</table>
			</div>
		</form>
	</fieldSet> 
	<div id="buttonbars" style="margin-bottom: 0px;"></div>
	<table id="tabless"></table>
	</div>
</body>
</html>