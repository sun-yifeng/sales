<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser" %> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>产品调整系数</title>
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
$(function(){	
	$("#tLawProductRateFrm").find("input").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//业务线
	$('#carFlag1').omCombo({
        dataSource : <%=Constant.getCombo("carFlag")%>,
        editable : false,
        emptyText : '请选择'
    });
	
	$('#workflag1').omCombo({
        dataSource : <%=Constant.getCombo("workflag")%>,
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
    	title : "销售人员管理办法  > 产品调整系数",
    	collapsible:true,
    	collapsed:false
    });	
	
	//业务线
	$('#carFlag').omCombo({
			dataSource : <%=Constant.getCombo("carFlag")%>,
			editable : false,
			emptyText : "请选择",
			filterStrategy : 'anywhere',
			lazyLoad : true
    });
	
	$('#workflag').omCombo({
        dataSource : <%=Constant.getCombo("workflag")%>,
        editable : false,
        filterStrategy : 'anywhere',
		lazyLoad : true,
        emptyText : '请选择'
    }); 
	
	$('#deptCode2').omCombo({
		dataSource : [ {text : '福建分公司', value : '04'} ],
		value : '04'
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
	   	 		 		openUpdate(row[0].productRateId);
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
    	 				           content:'是否删除所选产品调整系数信息?',
    	 				           onClose:function(v){
    	 				               if(v){
    	 				            	   for(var i = 0; row && i < row.length; i++){
    	 				            		   Util.post("<%=_path%>/tLawProductRate/deleteTLawProductRate.do?productRateId="+row[i].productRateId,"",
    					            					function(data) {
           		            		        		});
           		 				            	  }
    	 		 							 //删除成功弹出提示框
    		            				 $.omMessageBox.alert({
    		            						type : 'success',
    					 		 	            content: "删除产品调整系数成功！"
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
	{header:"是否车险",name:"carFlag",width:250,
		renderer : function(value, rowData , rowIndex) {
			if (value == '0')
				return "非车险";
			else if(value == '1')
				return "车险";
			else
				return "--";
		} 			
	},
	{header:"是否运营车",name:"workflag",width:200,
		renderer : function(value, rowData , rowIndex) {
			if (value == '0')
				return "非营运车";
			else if(value == '1')
				return "营运车";
			else
				return "--";
		} 			
	},
	{header:"调整系数",name:"productRate",width:200}
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
	$("#tables").omGrid("setData","<%=_path%>/tLawProductRate/queryTLawProductRate.do?"+$("#filterFrm").serialize());
}
//初始化
function initDialog(){
	$("#addTLawProductRateDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:400,
		height:200,
		modal:true,
		title:"产品调整系数信息",
		closeOnEscape : true,
		onClose:function(){
			window.location.href = "<%=_path%>/view/law/productRate.jsp";
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
	$("#tLawProductRateFrm").find(":input").each(function(){
		$(this).val("");
	}); 
	$("#addTLawProductRateDiv").omDialog({title:"新增产品调整系数"});
	$("#addTLawProductRateDiv").omDialog('open');
}

//打开修改
function openUpdate(productRateId){
	initDialog();
	$("#addTLawProductRateDiv").omDialog({title:"修改产品调整系数"});
	$("#addTLawProductRateDiv").omDialog('open');
	$("#productRateId").attr("readOnly","true");
	Util.post(
			"<%=_path%>/tLawProductRate/queryTLawProductRateToUpdate.do?productRateId="+productRateId,
			"",
			function(data) {
				$("#tLawProductRateFrm").find(":input").each(function(){
					if($(this).val() != null || $(this).val() != "")
						$(this).val(data[0][$(this).attr("name")]);
				});
				$('#workflag').omCombo({value : data[0].workflag});
				$('#carFlag').omCombo({value : data[0].carFlag});
				$('#deptCode2').omCombo({value : data[0].deptCode2});
			}
	);
}
//carFlag workflag productRate-
var indexFactorRules;
var indexFactorMessages;
function initValidate(){
	indexFactorRules = {
			carFlag : {
				required : true
			},
			/* workflag : {
				required : true
			}, */
			productRate : {
				required : true,
				isDecimal : true
			}
		};
	indexFactorMessages = {
			carFlag : {
				required : '是否车险不能为空'
			},
			/* workflag : {
				required : '业务线调整系数不能为空'
			}, */
			productRate : {
				required : '调整系数不能为空'
			}
		};
	$("#tLawProductRateFrm").validate({
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
        	Util.post("<%=_path%>/tLawProductRate/saveTLawProductRate.do", $("#tLawProductRateFrm").serialize(), 
       			function(data) {
	        		setTimeout("query()", 300);
	        		$("#addTLawProductRateDiv").omDialog('close');
       			}
        	);
        }
    });
}
//提交
function submitForm(){
	$("#tLawProductRateFrm").submit();
} 

function cancel(){
	$("#addTLawProductRateDiv").omDialog('close');
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<tr>
					<td style="padding-left:15px" align="right">机构名称：</td>
					<td><input type="text" name="formMap['deptCode2']" id="deptCode2s" class="sele" /></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:15px" align="right">是否车险：</td>
					<td><input type="text" name="formMap['carFlag']" id="carFlag1" class="sele"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:15px" align="right">是否运营车：</td>
					<td><input type="text" name="formMap['workflag']" id="workflag1" class="sele"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td align="right">调整系数：</td>
					<td><input type="text"  name="formMap['productRate']" id="productRate" /></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</>
				<tr>	
			    	<td colspan="15" style="padding-left:15px;padding-top:5px" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	
	<div id="addTLawProductRateDiv">
		<form id="tLawProductRateFrm">
			<input type="hidden" name="productRateId" id="productRateId" />
			<div id="nav_cont">
				<table class="grid_layout">
					<tr>
						<td style="padding-left:30px" align="right">机构名称：</td>
						<td><input type="text" name="deptCode2" id="deptCode2" class="sele" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right">是否车险：</td>
						<td><input type="text"  name="carFlag" id="carFlag" alias="carFlag" isPK="true" class="sele"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right">是否营运车：</td>
						<td><input type="text"  name="workflag" id="workflag" alias="workflag" isPK="true" class="sele" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td align="right">调整系数：</td>
						<td><input type="text" name="productRate" id="productRate" alias="productRate" isPK="true" /></td>
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