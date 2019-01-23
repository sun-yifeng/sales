<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser" %> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>业务线调整系数（废除）</title>
<style>
.errorImg{background:url("<%=_path%>/images/msg.png") no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error,textarea.error{border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px}
</style>
<script type="text/javascript">
var dataGrid;
var roleEname;
$(function(){	
	$("#tLawLineRateFrm").find("input").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//业务线
	$('#lineCode1').omCombo({
        dataSource : <%=Constant.getCombo("businessLine")%>,
        editable : false,
        emptyText : '请选择'
    });
	
	$('#deptCode2s').omCombo({
		dataSource : [ {text : '福建分公司', value : '04'} ],
		value : '04'
    });
	
	var btInput = $("#buttonbar");
	var btOffset = btInput.offset();
	var btnum = btOffset.top+btInput.outerHeight()+88;
	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
	if($.browser.msie&&($.browser.version == "8.0"||$.browser.version == "9.0")){
		topnum = topnum + 5;
	}
	
	$("#subBtn").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	
	dataGrid = $("#tables").omGrid({
		colModel:tabHand,
		showIndex : false,
		limit : 10,
        singleSelect : false,
        height:topnum,
        method : 'POST'
	});
	initDialog();
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#search-panel").omPanel({
    	title : "销售人员管理办法  > 业务线调整系数",
    	collapsible:true,
    	collapsed:false
    });	
	
	$('#deptCode2').omCombo({
		dataSource : [ {text : '福建分公司', value : '04'} ],
		value : '04'
    });
	//业务线
	$('#lineCode').omCombo({
			dataSource : <%=Constant.getCombo("businessLine")%>,
			emptyText : "请选择",
			filterStrategy : 'anywhere',
			lazyLoad : true
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
	   	 		 		openUpdate(row[0].lineRateId);
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
    	 				           content:'是否删除所选业务线调整系数信息?',
    	 				           onClose:function(v){
    	 				               if(v){
    	 				            	   for(var i = 0; row && i < row.length; i++){
    	 				            		   Util.post("<%=_path%>/tlawLineRate/deleteTLawLineRate.do?lineRateId="+row[i].lineRateId,"",
    					            					function(data) {
           		            		        		});
           		 				            	  }
    	 		 							 //删除成功弹出提示框
    		            				 $.omMessageBox.alert({
    		            						type : 'success',
    					 		 	            content: "删除业务线调整系数成功！"
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
	//加载是否禁用按钮方法
	isSelected();
			
			query();
		    $('.errorImg').bind('mouseover', function() {
			    $(this).next().css('display', 'block');
		    }).bind('mouseout', function() {
			    $(this).next().css('display', 'none');
		    });
		});

//表头
var tabHand = [
	{header:"机构名称",name:"deptCode2",width:200},
	{header:"业务线代码",name:"lineCode",width:250,
		renderer : function(value, rowData , rowIndex) {
			if (value == '0')
				return "金融保险";
			else if(value == '1')
				return "电话直销（商业车险）";
			else if(value == '2')
				return "其它";
			else
				return "--";
		}			
	},
	{header:"业务线调整系数",name:"lineRate",width:200}
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
	$("#tables").omGrid("setData","<%=_path%>/tlawLineRate/queryTLawLineRate.do?"+$("#filterFrm").serialize());
}
//初始化
function initDialog(){
	$("#addTLawLineRateDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:400,
		height:200,
		modal:true,
		title:"业务线调整系数信息",
		closeOnEscape : true,
		onClose:function(){
			window.location.href = "<%=_path%>/view/law/bizLineRate.jsp";
		},
		onOpen:function(){
			initValidate();
		}
	});
}
	
var editFlag;
//打开新增
function openSave(){
	initDialog();
	$("#tLawLineRateFrm").find(":input").each(function(){
		$(this).val("");
	}); 
	$("#addTLawLineRateDiv").omDialog({title:"新增业务线调整系数"});
	$("#addTLawLineRateDiv").omDialog('open');
	$('#deptCode2').omCombo({value : data[0].deptCode2});
}
//打开修改
function openUpdate(lineRateId){
	initDialog();
	$("#addTLawLineRateDiv").omDialog({title:"修改业务线调整系数"});
	$("#addTLawLineRateDiv").omDialog('open');
	$("#lineRateId").attr("readOnly","true");
	Util.post(
			"<%=_path%>/tlawLineRate/queryTLawLineRateToUpdate.do?lineRateId="+lineRateId,
			"",
			function(data) {
				$("#tLawLineRateFrm").find(":input").each(function(){
					if($(this).val() != null || $(this).val() != "")
						$(this).val(data[0][$(this).attr("name")]);
				});
				$('#lineCode').omCombo({value : data[0].lineCode});
				$('#deptCode2').omCombo({value : data[0].deptCode2});
			}
	);
}
var indexFactorRules;
var indexFactorMessages;
function initValidate(){
	indexFactorRules = {
			lineCode : {
				required : true
			},
			lineRate : {
				required : true,
				isDecimal : true
			}
		};
	indexFactorMessages = {
			lineCode : {
				required : '业务线代码不能为空'
			},
			lineRate : {
				required : '业务线调整系数不能为空'
			}
		};
	$("#tLawLineRateFrm").validate({
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
        	Util.post("<%=_path%>/tlawLineRate/saveTLawLineRate.do", $("#tLawLineRateFrm").serialize(), 
       			function(data) {
	        		setTimeout("query()", 300);
	        		$("#addTLawLineRateDiv").omDialog('close');
       			}
        	);
        }
    });
}
//提交value="福建分公司"
function submitForm(){
	$("#tLawLineRateFrm").submit();
} 

function cancel(){
	$("#addTLawLineRateDiv").omDialog('close');
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:30px" align="right">机构名称：</td>
					<td><input type="text" name="formMap['deptCode2']" id="deptCode2s" class="sele" /></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:30px" align="right">业务线代码：</td>
					<td><input type="text" name="formMap['lineCode']" id="lineCode1" class="sele"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td align="right">业务线调整系数：</td>
					<td><input type="text"  name="formMap['lineRate']" id="lineRate" /></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
			    	<td colspan="4" style="padding-left:30px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<!-- 新增销售人员管理办法 -->
	<div id="addTLawLineRateDiv"><!-- addLawDefineDiv -->
		<form id="tLawLineRateFrm"><!-- lawDefineFrm -->
			<input type="hidden" name="lineRateId" id="lineRateId" />
			<div id="nav_cont">
				<table class="grid_layout">
					<tr>
						<td style="padding-left:30px;" align="right">二级机构：</td>
						<td class="td"><input type="text" name="deptCode2" id="deptCode2" class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right">业务线代码：</td>
						<td><input type="text"  name="lineCode" id="lineCode" alias="lineCode" isPK="true" class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td align="right">业务线调整系数：</td>
						<td><input type="text" name="lineRate" id="lineRate" alias="lineRate" isPK="true" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
				</table>
			</div>
			<div>
				<table style="width: 100%">
					<tr>
						<td style="padding-left:30px;padding-top:10px" align="center">
						<a class="om-button" id="subBtn" onclick="submitForm()">保存</a><a id="button-cancel"  onclick="cancel()">取消</a></td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</body>
</html>