<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>管理办法因素管理</title>
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
						$("#filterForm").find("#deptCode").omCombo({value:currentDept,readOnly : true});
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
	//导航菜单
	$("#search-panel").omPanel({
	  	title : "销售人员管理办法  > 管理办法因素管理",
	  	collapsible:true,
	  	collapsed:false
	});	
	//按钮菜单
	$('#buttonbar').omButtonbar({
    	btns : [{label:"新增",
    		     id:"buttonNew" ,
    		     icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
    	 		 onClick:function(){openSave(true);}
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
	   	 		 		   openSave(false);;
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
		 				           content:'是否删除所选因素信息?',
		 				           onClose:function(v){
		 				               if(v){
		 				            	   for(var i = 0; row && i < row.length; i++){
		 				            		   Util.post("<%=_path%>/lawFactor/deleteLawFactor.do",
		            		        				"serno="+row[i].serno,
						            					function(data) {
        		            		        		});
        		 				            	  }
		 		 							 //删除成功弹出提示框
			            				 $.omMessageBox.alert({
			            						type : 'success',
						 		 	            content: "删除因素信息成功！"
						 		 	        });
		 		 							 //删除后刷新页面数据
		            					 query();
		 				               }
		 				            }
		 				       });
    	 		 		}
    	 		 	}
    	        }
    	]
    });
	//按钮控制
	buttonCtr();
	//按钮样式
	$("#button-search").omButton({icons:{left : '<%=_path%>/images/search.png'},width:50});
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	//校验的提示
    $('.errorImg').bind('mouseover', function() {
      $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
      $(this).next().css('display', 'none');
    });
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
   	{header:"分公司",name:"deptCode",width:100},
  	{header:"业务线",name:"lineCode",width:100},
	{header:"因素代码",name:"itemCode",width:100},
	{header:"因素名称",name:"itemName",width:300},
	{header:"函数名称",name:"funcName",width:100},
	{header:"因素类型",name:"dataType",width:100,
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
	{header:"备注",name:"itemNote",width:300}
];
//按钮控制
function buttonCtr(){
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=xszcAdmin",
		type: "post",
		async: true, 
		dataType: "JSON",
		success: function(admin){
			if(!admin) {
				$("#buttonNew").omButton("disable");
				$("#buttonEdit").omButton("disable"); 
		 		$("#buttonRemove").omButton("disable");
			}
		}
	});
}
//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/lawFactor/queryLawFactor.do?"+$("#filterFrm").serialize());
}
//新增修改
function openSave(addFlag){
	$("#lawFactorFrm").find("#dataType").omCombo({
		dataSource: <%=getCombo("factorType")%>,
		width : 181,
		emptyText: '请选择'
	});
	$("#addLawFactorDiv").omDialog({
		title : addFlag ? "新增" : "修改",
		width : 500,
		height : 320,
		modal : true,
		onOpen : function(){
			//initValidate();
			if(!addFlag) {//修改
	 			var row = eval($('#tables').omGrid("getSelections",true));
	 			$("#lawFactorFrm").find("#itemCode").attr("readOnly","true");
				Util.post("<%=_path%>/lawFactor/queryLawFactorToUpdate.do?serno="+row[0].serno,"",function(data) {
					$("#lawFactorFrm").find(":input").each(function(){
						if($(this).val() != null || $(this).val() != "")
							$(this).val(data[0][$(this).attr("id")]);
					});
					$("#lawFactorFrm").find('#dataType').omCombo({value:data[0].dataType});
				  }
				);
			}
		},
		onClose:function(){
			window.location.href = "<%=_path%>/view/law/lawFactor.jsp";
		}
	}).omDialog('open');

}
//
var lawFactorRules;
var lawFactorMessages;
//校验
function initValidate(){
	lawFactorRules = {
			itemCode : {
			required : true,
			remote : "<%=_path%>/lawFactor/queryItemCode.do",
			isNotChinese : true,
			maxlength : 16
		},
			itemName : {
			required : true,
			maxlength : 128
		},
			dataType : {
			required : true
		},
		dataUnit:{
			maxlength : 16
		},
			orderNo : {
			required : true,
			min:100,
			max:10000
		},
			itemNote:{
			maxlength : 256
		},	
			funcName : {
			required : true,
			maxlength : 64
		}
	};
	lawFactorMessages = {
			itemCode : {
			required : '因素代码不能为空',
			isNotChinese : '因素代码不能包含中文',
			remote : "此编码已经被注册",
			maxlength : '因素代码最长16位'
		},
			itemName : {
			required : '因素名称不能为空',
			maxlength : '因素名称最长128位'
		},
			dataType : {
			required : '数据类型不能为空'
		},
			dataUnit : {
			maxlength : '数据单位最长16位'
		},
			orderNo : {
			required : '计算顺序不能为空',
			min:'计算顺序最小为100',
			max:'计算顺序最大为10000'
		},
			itemNote : {
			maxlength : '数据单位最长256位'
		},
			funcName : {
			required : '函数名称不能为空',
			maxlength : '数据单位最长64位'
		}
	};
	$("#lawFactorFrm").validate({
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
        	Util.post("<%=_path%>/lawFactor/saveLawFactor.do", $("#lawFactorFrm").serialize(), 
       			function(data) {
       			    $("#addLawFactorDiv").omDialog('close');
       			}
        	);
        }
    });
}
//提交
function submitForm(){
	$("#lawFactorFrm").submit();
}
//取消
function cancel(){
	$("#addLawFactorDiv").omDialog('close');
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
					<td style="padding-left:15px;"><span class="label">因素代码：</span></td>
					<td><input type="text" name="formMap['itemCode']" id="itemCode1" /></td>
					<td style="padding-left:15px;"><span class="label">因素名称：</span></td>
					<td><input type="text" name="formMap['itemName']" id="itemName" /></td>
					<td style="padding-left:15px;padding-top:5px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
	<!-- 新增销售人员管理办法 
	<div id="addLawFactorDiv" align="center" style="display: none;">
		<form id="lawFactorFrm">
			<input type="hidden" name="serno" id="serno" alias="serno" />
			<div>
				<table>
					<tr>
						<td align="right">因素代码：</td>
						<td class="td" ><input type="text" style="width: 180px;" name="itemCode" id="itemCode" alias="itemCode" /><span style="color:red">*</span></td>
						<td style="width:20px"><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td align="right">因素名称：</td>
						<td class="td" ><input type="text" style="width: 180px;" name="itemName" id="itemName" alias="itemName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td align="right">因素类型：</td>
						<td class="td" ><input  type="text" style="width: 180px;" name="dataType" id="dataType" alias="dataType" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td align="right">数据单位：</td>
						<td class="td" ><input type="text" style="width: 180px;" name="dataUnit" id="dataUnit" alias="dataUnit" /></td>
					</tr>
					<tr>
						<td  align="right">计算顺序：</td>
						<td class="td" ><input type="text" style="width: 180px;" name="orderNo" id="orderNo" alias="orderNo" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td  align="right">因素描述：</td>
						<td class="td" ><input type="text" style="width: 180px;" name="itemNote" id="itemNote" alias="itemNote" /></td>
					</tr>
					<tr>
						<td  align="right">函数名称：</td>
						<td class="td" ><input type="text" style="width: 180px;" name="funcName" id="funcName" alias="funcName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr align="right">
						<td colspan="2"  style="padding-top:15px;"align="center"><a class="om-button" id="button-save" onclick="submitForm()">保存</a><a id="button-cancel"  onclick="cancel()">取消</a></td>
					</tr>
				</table>
			</div>
		</form>
	</div>-->
</body>
</html>