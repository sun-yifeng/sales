<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>管理办法职级</title>
<style>
.errorImg{background:url("<%=_path%>/images/msg.png") no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error,textarea.error{border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px}
</style>
<script type="text/javascript">
var currentDept;
$(function(){
	//分公司
	$.ajax({ 
		url: "<%=_path%>/common/findDeptByUserCode.do",
		type:"post",
		async: false, 
		dataType: "HTML",
		success: function(data){
			currentDept = data;
			$("#filterForm").find("#deptCode").omCombo({
				dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
				onSuccess : function(){
					if(currentDept != '00'){
						$("#filterForm").find("#deptCode").omCombo({value:currentDept,readOnly : true});
					}
				},
				width:150,
				emptyText : "请选择"
		    });
		}
	});
	//业务线
	$("#filterForm").find("#lineCode").omCombo({
		dataSource: <%=getCombo("bizLine")%>,
		width:150,
		emptyText: '请选择'
	});
    //职级类别
	$('#managerFlag').omCombo({
        dataSource : <%=getCombo("managerFlag")%>,
        emptyText : '请选择',
        editable : false
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
   	    	 			var rows = eval($('#tables').omGrid("getSelections",true));
   		 		 		var row = eval(rows);
   		 		 		if(row.length != 1){
   		 		 			$.omMessageBox.alert({
   	    	 		 	        content:'请选择一条记录编辑',
   	    	 		 	        onClose:function(value){
   	    	 		 	        	return false;
   	    	 		 	        }
   		 		 	        });
   	   	 		 		}else{
   	    	 			 	//openUpdate(row[0].pkId);
   	    	 			 	openSave(false);
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
		 				           content:'是否删除所选职级信息?',
		 				           onClose:function(v){
		 				               if(v){
		 				            	   for(var i = 0; row && i < row.length; i++){
		 				            		   Util.post("<%=_path%>/lawRank/deleteLawRank.do",
		            		        				"pkId="+row[i].pkId,
						            					function(data) {
        		            		        		});
        		 				            	  }
		 		 						 //删除成功弹出提示框
			            				 $.omMessageBox.alert({
			            						type : 'success',
						 		 	            content: "删除职级信息成功！"
						 		 	        });
	 		 							 //删除后刷新页面数据
		            					 setTimeout("query()", 500);
		 				               }
		 				            }
		 				       });
    	 		 		}
    	 		 	}
    	        }
	    	]
	});
	//按钮样式
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	//导航菜单
	$("#search-panel").omPanel({
		title : "销售人员管理办法  > 管理办法职级",
		collapsible:true,collapsed:false
    });
	//校验提示
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
	//按钮控制
	buttonDisable();
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
	//查询操作
	setTimeout("query()", 500);
});

//表头
var tabHand = [
	{header:"分公司",name:"deptName",width:100},
	{header:"业务线",name:"lineCode",width:100},
	{header:"职级代码",name:"rankCode",width:150},
	{header:"职级名称",name:"rankName",width:150},
	{header:"职级类别",name:"managerFlag",width:100},
	{header:"是否上报审批",name:"auditFlag",width:100},
	{header:"对应总司职级",name:"mapRank",width:100},
	{header:"月度固定工资(元)",name:"baseSalary",width:100},
	{header:"月度绩效工资(元)",name:"caclSalary",width:100},
	{header:"月度固定工资<br/>总额(元)",name:"baseTotal",width:100},
	{header:"月度绩效工资<br/>总额计提标准",name:"baseRate",width:100,align : 'center',
		renderer : function(value, rowData , rowIndex) {
			if (value <= 100 && value != '')
				return value+"%";
			else if (value > 100 && value != '')
				return value+" 元";
			else
				return '';
		}		
	},
	{header:"年化标准保费(万元)",name:"normPremium",width:120},
	{header:"描述",name:"rankNote",width:160}
];
//按钮控制
function buttonDisable(){
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=xszcAdmin",
		type:"post",
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
	$("#tables").omGrid("setData","<%=_path%>/lawRank/queryLawRank.do?"+$("#filterForm").serialize());
}
//新增或修改
function openSave(addFlag){
    //新增或修改
	$("#addLawRankDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:450,
		height:420,
		modal:true,
		title: addFlag ? "职级新增" : "职级修改",
		closeOnEscape : true,
		onClose:function(){
			window.location.href = "<%=_path%>/view/law/lawRank.jsp";
		},
		onOpen:function(){
			//分公司
			$("#lawRankForm").find("#deptCode").omCombo({
				dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
				emptyText : "请选择",
				valueField : 'value',
				inputField : 'text',
				filterStrategy : 'anywhere',
				width:152,
				onSuccess : function(data, textStatus, event){
	    			$("#lawRankForm").find("#deptCode").omCombo({
	    				onValueChange : function(target, newValue, oldValue, event) {
	    					fillRankCode();
	    				},
	    				emptyText : '请选择',
	    				editable : false
	    			});
	    	   		if(data.length == 2){
		    			$("#lawRankForm").find("#deptCode").omCombo({
		    				value : data[1].value,
		    				readOnly : true
		    			});
		    	   	}
		    	}
		    });
			//业务线
			$("#lawRankForm").find("#lineCode").omCombo({
				dataSource: <%=getCombo("bizLine")%>,
				onValueChange : function(target, newValue, oldValue, event) {
					fillRankCode();
				},
				valueField: 'value',
				inputField: 'text',
				filterStrategy: 'anywhere',
				width:152,
				emptyText: '请选择'
			});
			//职级分类
			$("#lawRankForm").find('#managerFlag').omCombo({
		        dataSource : <%=getCombo("managerFlag")%>,
				onValueChange : function(target, newValue, oldValue, event) {
					onManagerChange(newValue);
					fillRankCode();
				},
		        emptyText : '请选择',
		        editable : false,
				width:152
		    });
	        //页面校验
			initValidate(addFlag);
		}
	}).omDialog('open');
	//修改操作
	if(!addFlag){
		$("#lawRankForm").find("#rankCode").attr("readOnly","true");
		//$("#lawRankForm").find("#rankName").attr("readOnly","true");
   	    var row = eval($('#tables').omGrid("getSelections",true));
		//填充表单
		Util.post("<%=_path%>/lawRank/queryLawRankToUpdate.do?pkId="+row[0].pkId,"",function(data) {
			$("#lawRankForm").find('#deptCode').omCombo({readOnly:true}); //分公司
			$("#lawRankForm").find('#lineCode').omCombo({readOnly:true}); //业务线
			$("#lawRankForm").find('#managerFlag').omCombo({readOnly:true}); //职级分类
			$("#lawRankForm").find('#mapRank').omCombo({readOnly:true}); //对应职级
			onManagerChange(data[0].managerFlag);
			FillForm.fill('lawRankForm',data[0]);
		});
	}
}
//职级分类
function onManagerChange(managerFlag){
	//对应总司职级
	$("#lawRankForm").find('#mapRank').omCombo('setData',[]).omCombo({
		dataSource : "<%=_path%>/common/querySaleRank.do?managerFlag="+managerFlag,
        emptyText : '请选择',
	    editable : false,
		disabled : false,
	    readOnly : false,
	 	width : 152,
		onValueChange : function(target, newValue, oldValue, event) {
 			//是否上报审批
   			if (newValue == '01' || newValue == '02') {
   				$("#lawRankForm").find("#auditFlag").val('1');
   	   		} else {
   	   			$("#lawRankForm").find("#auditFlag").val('0');
   	   	   	}
 	   	   	//职级代码
   			fillRankCode();
		},
		onSuccess:function(data, textStatus, event){
		    //客户经理
			if(managerFlag == 0){
				$('#trSalesman').show().next().show();
				//固定工资
				$('#baseSalary').rules('add',{
					 required:true,
					 number:true,
				     messages: {
				    	  required: jQuery.format("固定工资不能为空"),
				    	  number:   jQuery.format("固定工资必须是数字")
				      }
				 });
			     //绩效工资
				 $('#caclSalary').rules('add',{
					 required:true,
					 number:true,
				      messages: {
				    	  required: jQuery.format("绩效工资不能为空"),
				    	  number:   jQuery.format("绩效工资必须是数字")
				      }
				  });
				 //隐藏 
				 $('#trGroupLeader').hide().next().hide();
				 $('#baseTotal').val('').rules("remove");
				 $('#baseRate').val('').rules("remove");
			} else if (managerFlag == 1) {
			     //团队经理显示
				 $('#trGroupLeader').show().next().show();
		         //月度固定工资总额
				 $('#baseTotal').rules('add',{
					 required:true,
					 number:true,
				     messages: {
				    	  required: jQuery.format("月度固定工资总额不能为空"),
				    	  number:   jQuery.format("月度固定工资总额必须是数字")
				      }
				 });
				 //月度工资计提标准 
				 $('#baseRate').rules('add',{
					 required:true,
					 number:true,
				     messages: {
				    	  required: jQuery.format("月度固定工资总额计提标准不能为空"),
				    	  number:   jQuery.format("月度固定工资总额计提标准必须是数字")
				      }
				  });
				 //隐藏 
				 $('#trSalesman').hide().next().hide();
				 $('#baseSalary').val('').rules("remove");
				 $('#caclSalary').val('').rules("remove");
			} else if (managerFlag == 2) { //其他
				$('#trSalesman').hide().next().hide();
				$('#trGroupLeader').hide().next().hide();
				$('#baseSalary').val('').rules("remove");
				$('#caclSalary').val('').rules("remove");
				$('#baseTotal').val('').rules("remove");
				$('#baseRate').val('').rules("remove");
				//对应总公司职级
				//$("#mapRank").omCombo('setData',[]).omCombo({dataSource:[{"text":"其他","value":"06"}]});
			}
	    } //end onSuccess
    });

	//
}
//生成职级代码
function fillRankCode(){
	var tmp1 = $("#lawRankForm").find("#deptCode").val();
	var tmp2 = $("#lawRankForm").find("#lineCode").val();
	var tmp3 = $("#lawRankForm").find("#managerFlag").val();
	var tmp4 = $("#lawRankForm").find("#mapRank").val();
	if(tmp1!=''&&tmp2!=''&&tmp3!=''&&tmp4!=''){
	    Util.post("<%=_path%>/lawRank/generateRankCode.do", $("#lawRankForm").serialize(), function(data) {
		   $("#lawRankForm").find("#rankCode").val(data.rankCode);
	    });
	}else{
		$("#lawRankForm").find("#rankCode").val('');
	}
}
//
var lawRankRules;
var lawRankMessages;
//校验
function initValidate(addFlag){
	if(addFlag){
		lawRankRules = {
			rankName : {
				required : true,
				maxlength : 128
			},
			deptName : {
				required : true
			},
			managerFlag:{
				required : true
			},
			normPremium:{
				required : true,
				number:true
			},
			mapRank:{
				required : true
			}
		};
		lawRankMessages = {
			rankName : {
				required : '职级名称不能为空',
				maxlength : '职级名称最长128位'
			},
			deptName : {
				required : '机构部门不能为空'
			},
			managerFlag:{
				required : '职级类别必选'
			},
			normPremium:{
				required : '标准保费不能为空',
				number : '标准保费必须是数字'
			},
			mapRank:{
				required : '对应职级不能为空'
			}
		};
	} else {
		lawRankRules = {
			rankCode : {
				required : true,
				maxlength : 16
			},
			rankName : {
				required : true,
				maxlength : 128
			},
			deptName : {
				required : true
			},
			managerFlag:{
				required : true
			},
			normPremium:{
				required : true,
				number:true
			},
			mapRank:{
				required : true
			}
		};
		lawRankMessages = {
			rankCode : {
				required : '职级代码不能为空',
				maxlength : '职级代码最长16位'
			},
			rankName : {
				required : '职级名称不能为空',
				maxlength : '职级名称最长128位'
			},
			deptName : {
				required : '机构部门不能为空'
			},
			managerFlag:{
				required : '职级类别必选'
			},
			normPremium:{
				required : '标准保费不能为空',
				number   : '标准保费必须是数字'
			},
			mapRank:{
				required : '对应职级不能为空'
			}
		};
	}
	$("#lawRankForm").validate({
		rules: lawRankRules,
		messages: lawRankMessages,
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
        	Util.post("<%=_path%>/lawRank/saveLawRank.do", $("#lawRankForm").serialize(), 
       			function(data) {
       			    $("#addLawRankDiv").omDialog('close');
       			}
        	);
        	$("#lawRankForm").validate().resetForm();
        }
    });
}
//提交
function submitForm(){
	$("#lawRankForm").submit();
}
//取消
function cancel(){
	$("#addLawRankDiv").omDialog('close');
}
</script>
</head>
<body>
	<form id="filterForm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px;"><span class="label">分公司：</span></td>
					<td><input type="text" name="formMap['deptCode']" id="deptCode" /></td>
					<td style="padding-left:15px;"><span class="label">业务线：</span></td>
					<td><input type="text" name="formMap['lineCode']" id="lineCode" /></td>
					<td style="padding-left:15px;"><span class="label">职级代码：</span></td>
					<td><input type="text" name="formMap['rankCode']" id="rankCode" /></td>
					<td style="padding-left:15px;"><span class="label">职级名称：</span></td>
					<td><input type="text" name="formMap['rankName']" id="rankName" /></td>
					<td style="padding-left:15px;" align="right"><span class="label">职级类别：</span></td>
					<td><input type="text" name="formMap['managerFlag']" id="managerFlag" class="sele"/></td>
				    <td colspan="10" style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<!-- 新增DIV -->
	<div id="addLawRankDiv" style="display: none;">
		<form id="lawRankForm">
			<input type="hidden" name="pkId" id="pkId" alias="pkId" />
			<input type="hidden" name="auditFlag" id="auditFlag" alias="auditFlag" />
			<div id="nav_cont">
				<table  class="grid_layout" align="center">
					<tr>
						<td style="padding-left:15px;" align="right">分公司：</td>
						<td class="td"><input type="text" style="width: 150px;" name="deptCode" id="deptCode" alias="deptCode" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px;" align="right">业务线：</td>
						<td class="td"><input type="text" style="width: 150px;" name="lineCode" id="lineCode" alias="lineCode" class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px;" align="right">职级分类：</td>
						<td class="td"><input type="text" style="width: 150px;" name="managerFlag" id="managerFlag" alias="managerFlag" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>						
						<td style="padding-left:15px;" align="right">对应总公司职级：</td>
						<td class="td"><input type="text"  name="mapRank" id="mapRank" alias="mapRank"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px;" align="right">职级名称：</td>
						<td class="td"><input type="text" style="width: 150px;" name="rankName" id="rankName" alias="rankName" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>						
						<td style="padding-left:15px;" align="right">年度标准保费计划(万元)：</td>
						<td class="td"><input type="text" style="width: 150px;" name="normPremium" id="normPremium" alias="normPremium"/><span style="color:red">*</span></td>
						<td ><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<!-- 客户经理显示 -->
					<tr id="trSalesman" style="display: none;">
						<td style="padding-left:15px;" align="right">客户经理月度固定工资(元)：</td>
						<td class="td"><input type="text" style="width: 150px;" name="baseSalary" id="baseSalary" alias="baseSalary" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>						
						<td style="padding-left:15px;" align="right">客户经理月度绩效工资(元)：</td>
						<td class="td"><input type="text" style="width: 150px;" name="caclSalary" id="caclSalary" alias="caclSalary"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<!-- 团队经理显示 -->
					<tr id="trGroupLeader" style="display: none;">
						<td style="padding-left:15px;" align="right">团队经理月度固定工资(元)：</td>
						<td class="td"><input type="text" style="width: 150px;" name="baseTotal" id="baseTotal" alias="baseTotal" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>						
						<td style="padding-left:15px;" align="right">团队经理绩效工资计提标准：</td>
						<td class="td"><input type="text" style="width: 150px;" name="baseRate" id="baseRate" alias="baseRate"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:15px;" align="right">职级代码：</td>
						<td class="td"><input type="text" style="width: 150px;" name="rankCode" id="rankCode" alias="rankCode" readonly="readonly"/><span style="color:red"></span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>						
						<td style="padding-left:15px;" align="right">描述：</td>
						<td class="td"><input type="text" style="width: 150px;" name="rankNote" id="rankNote" alias="rankNote" /></td>
						<td ><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
				</table>
			</div>
			<div style="padding-top:30px;text-align:center;" ><a class="om-button" id="button-save" onclick="submitForm()">保存</a><a id="button-cancel" onclick="cancel()">取消</a></div>
		</form>
	</div>
</body>
</html>