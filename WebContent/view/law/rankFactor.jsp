<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<% String rankCode = request.getParameter("rankCode"); %>
<% String rankName = request.getParameter("rankName"); %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>职级因素关系指定</title>

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
var rankCode = <%=rankCode%>;
var rankName = <%=rankName%>;
var dataGrid;
var roleEname;
var factorOrIndex;
var flag;
var btnArray = ["button-search","subBtn"];

$(function(){
	$('#rankCode1').val(rankCode);
	$('#rankName1').val(rankName);
	
	//列表的高度
	var btInput = $("#buttonbar");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight()+77;
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
    	title : "销售人员管理办法  > 管理办法职级 > 职级因素关系指定",
    	collapsible:true,
    	collapsed:false
    });	
	$('#buttonbar').omButtonbar({
    	btns : [{label:"新增因素关系",
    		     id:"buttonFactor" ,
    		     icons : {left : '<%=_path%>/images/add.png'},
    	 		 onClick:function(){
    	 			factorOrIndex = 1;
    	 			 openSave(factorOrIndex);
    	 			 }
    			},
    			{separtor:true},
    			{label:"新增指标关系",
    		     id:"buttonTarget" ,
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
    			 	id:"deleteButton",
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
		 				           content:'是否删除所选职级因素关系信息?',
		 				           onClose:function(v){
		 				               if(v){
		 				            	   for(var i = 0; row && i < row.length; i++){
		 				            		   Util.post("<%=_path%>/tRankFactor/deleteTRankFactor.do",
		            		        				"serno="+row[i].serno,
						            					function(data) {
        		            		        		});
        		 				            	  }
		 		 							 //删除成功弹出提示框
			            				 $.omMessageBox.alert({
			            						type : 'success',
						 		 	            content: "删除职级信息成功！"
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
       			 id:"buttonBack",
       		     disabled :  false,
       			 icons : {left : '<%=_path%>/images/remove.png'},
       	 		 onClick:function(){
       	 			window.location.href = "lawRank.jsp";	 
       	 		 }
       	        }
    	]
    });
	
	//查询出指标信息
	$('#itemName1').omCombo({
		dataSource  :  "<%=_path%>/lawTarget/queryCodeAndName.do",
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
	
	 //表现形式
	$('#exhibitType').omCombo({
        dataSource : <%=Constant.getCombo("exhibitType")%>,
        editable : false,
        emptyText : '请选择',
        width: 182
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
	{header:"职级代码",name:"rankCode",width:130},
	{header:"职级名称",name:"rankName",width:130},
	{header:"因素代码",name:"factorCode",width:130},
	{header:"因素名称",name:"itemName",width:270},
	{header:"显示顺序",name:"orderNo",width:160},
	{header:"表现形式",name:"exhibitType",width:160,
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
		$("#buttonTarget").omButton("disable");
		$("#buttonFactor").omButton("disable");
		$("#deleteButton").omButton("disable");
		$("#buttonEdit").omButton("disable"); 
	}else{
		$("#buttonTarget").omButton("enable");
		$("#buttonFactor").omButton("enable");
		$("#deleteButton").omButton("enable");
		$("#buttonEdit").omButton("enable"); 
	}
}

 //查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/tRankFactor/queryTRankFactor.do?"+$("#filterFrm").serialize());
} 
//初始化
function initDialog(){
	$("#addRankFactorDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:660,
		height:220,
		modal:true,
		title:"新增职级因素关系",
		closeOnEscape : true,
		onClose:function(){
        	$('.errorImg').hide();
			$("#rankFactorFrm").validate().resetForm();
			//$("#addRankFactorDiv").omDialog('close');
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
	$("#addRankFactorDiv").omDialog({title:"新增因素或指标关系"});
	$("#addRankFactorDiv").omDialog('open');
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
	$("#rankFactorFrm").find(":input").each(function(){
		$(this).val("");
	}); 
	//给职级参数赋值
	 $('#rankCode').val(rankCode);
	$('#rankName').val(rankName);
	$("#rankCode").attr("readOnly","true");
	$("#rankName").attr("readOnly","true");
}
//打开修改
function openUpdate(serno,factorOrIndex){
	initDialog();
	//给职级参数赋值
	$("#addRankFactorDiv").omDialog({title:"修改职级因素关系"});
	$("#addRankFactorDiv").omDialog('open');

	Util.post(
			"<%=_path%>/tRankFactor/queryTRankFactorToUpdate.do?serno="+serno,
			"",
			function(data) {
				$("#rankFactorFrm").find(":input").each(function(){
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

var rankFactorRules;
var rankFactorMessages;
//校验
function initValidate(){
	rankFactorRules = {
			itemName : {
				required : true
			},
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
	rankFactorMessages = {
			itemName : {
				required : '因素名称不能为空'
			},
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
	$("#rankFactorFrm").validate({
		rules: rankFactorRules,
		messages: rankFactorMessages,
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
        	Util.post("<%=_path%>/tRankFactor/savetTRankFactor.do", $("#rankFactorFrm").serialize(), 
       			function(data) {
	        		setTimeout("query()", 300);
	        		$("#addRankFactorDiv").omDialog('close');
       			}
        	);
        }
    });
}
//提交
function submitForm(){
	$("#rankFactorFrm").submit();
}

function cancel(){
	$("#addRankFactorDiv").omDialog('close');
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<fieldSet style="margin-top: 5px;">
			<legend style="margin-left: 40px;font-size:12px;">职级参数</legend>
			<table>
				<tr>
					<td style="padding-left:15px;"><span class="label">职级代码：</span></td>
					<td><input type="text" name="formMap['rankCode']"  id="rankCode1"  readonly="readonly"/></td>
					<td style="padding-left:15px;"><span class="label">职级名称：</span></td>
					<td><input type="text" name="formMap['rankName']"  id="rankName1"  readonly="readonly"/></td>
				</tr>
			</table>
			</fieldSet>
		</div>
	</form>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<!-- 新增管理办法职级因素关系 -->
	<div id="addRankFactorDiv">
		<form id="rankFactorFrm">
			<input style="display: none;" name="serno" id="serno" alias="serno" />
			<div id="nav_cont">
				<table style="align:center" class="grid_layout">
					<tr>
						<td style="padding-left:15px; align:right">职级代码：</td>
						<td class="td"><input type="text" style="width: 180px;" name="rankCode" id="rankCode" alias="rankCode"  readonly="readonly"/></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:15px; align:right">职级名称：</td>
						<td class="td"><input type="text" style="width: 180px;" name="rankName" id="rankName" alias="rankName"  readonly="readonly"/></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr id="factorTr">
						<td style="padding-left:15px; align:right">因素名称：</td>
						<td class="td"><input type="text" style="width: 180px;" name="itemName" id="itemName" alias="itemName" /><span style="color:red">*</span></td>
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