<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>团队新增</title>
<style type="text/css">
*{padding:0;marging:0}
body{font-family:微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun;font-size:12px;color:#1E1E1E;}
html, body{ height:100%; margin:0px; padding:0px;}
body {font-size:12px;}
.om-button {font-size:12px;}
#nav_cont{width:580px;margin-left:auto;margin-right:auto;}
input {border: 1px solid #A1B9DF; vertical-align: middle;}
input:focus{border: 1px solid #3A76C2;}
.input_slelct {width: 81%;}
.textarea_text {border: 1px solid #A1B9DF; height: 40px;width: 445px;}
table.grid_layout tr td {font-weight: normal; height: 15px; padding: 5px 0; vertical-align: middle;}
.color_red { color: red; }
.toolbar { padding: 12px 0 5px;text-align: center; }
.birthplace ,.address {width:445px;}
.om-span-field input:focus {border:none;}
.errorImg{background: url("../../images/msg.png") no-repeat scroll 0 0 transparent;height: 16px;width: 16px;cursor: pointer;}
input.error,textarea.error{border: 1px solid red;}
.errorMsg{border: 1px solid gray;background-color: #FCEFE3;display: none;position: absolute;margin-top: -18px;margin-left: 18px;}
</style>
<script type="text/javascript">
$(function(){
	$("#addGroupForm").find("input").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	
	//时间选择框
	$('#foundDate').omCalendar({
		  dateFormat : "yy-mm-dd"
    });
	
	//设定时间默认给系统当前时间
	var date=new Date(); 
	$("#foundDate").val($.omCalendar.formatDate(date,'yy-mm-dd'));

	//初始化页面保存、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	
	//团队类型	
	$('#groupType').omCombo({
        dataSource : <%=Constant.getCombo("groupType")%>,
        editable : false,
        emptyText : '请选择'
    });
	
	//是否虚拟团队	
	$('#virtualFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        value:'0',
//         onValueChange : function(target, newValue, oldValue, event) {
//         	if(newValue === '1'){
//         		$('#groupType').omCombo({
//         			value:'7',//常规团队
//         			readOnly : true
//         		});
//         	} else {
//         		$('#groupType').omCombo({
//         			emptyText : '请选择',
//         			editable : false,
//         			readOnly : false
//         		});
//         	}
//         },
        editable : false,
        emptyText : '请选择'
    });
	
	//初始化机构部门
	$('#parentDept').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 1){
        		$('#parentDept').omCombo({value:data[0].value});
        		$('#deptName').omCombo({
        			dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[0].value,
        			onSuccess  : function(data, textStatus, event){
        				if(data.length == 1){
        					$('#deptName').omCombo({value:data[0].value});
        					$('#deptMarket').val('').omCombo({
        						dataSource : "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+$("#deptName").val(),
        						onSuccess  : function(data, textStatus, event){
        							if(data.length == 1){
        								$('#deptMarket').omCombo({value:data[0].value});
        							}
        						}
        					});
        				}
        			}
        		});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#parentDept').omCombo('value');
            $('#deptName').omCombo('setData',[]);
            if(currentParentDept != ''){
	            $('#deptName').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptName').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
            $('#deptMarket').omCombo('setData',[]);
        },
        emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	$('#deptName').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptName').omCombo('value');
            if(currentParentDept != ''){
	            $('#deptMarket').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptMarket').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
	});
	
	$('#deptMarket').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
			//alert(newValue);
			$('#deptCode').val(newValue);
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
   });
	
	initValidate();
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
});

//定义校验规则
var groupConferRule = {
	parentDept:{
		required : true
	},
	deptName:{
		required : true
	},
	deptMarket:{
		required : true
	},
	groupName:{
		required : true
	},
	foundDate:{
		required : true
	},
	groupType:{
		required : true
	},
	virtualFlag:{
		required : true
	}
};

//定义校验的显示信息
var groupConferMessages = {
	parentDept:{
		required : '请选择二级机构'
	},
	deptName:{
		required : '请选择三级机构'
	},
	deptMarket:{
		required : '请选择四级单位'
	},
	groupName:{
		required : '团队名称不能为空'
	},  
	foundDate:{
		required : '团队设立时间不能为空'
	},
	groupType:{
		required : '团队类型不能为空'
	},
	virtualFlag:{
		required : '是否虚拟团队不能为空'
	}
};
 
//校验 
var remote;
//校验
function initValidate(){
	remote = $("#addGroupForm").validate({
		rules: groupConferRule,
		messages: groupConferMessages,
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
        	Util.post("<%=_path%>/groupMain/saveGroupMain.do",$("#addGroupForm").serialize(), function(data) {
   		 	   	//保存成功后跳转回团队管理页
   				window.location.href = "group.jsp";
        	});
         }
    });
}

//表单提交 
function save(){
	//页面校验
	if (!$("#addGroupForm").validate().form()) 
		return false;
	
	//校验团队是否存在
	Util.post(
		"<%=_path%>/groupMain/queryGroupNameCount.do?groupName="+$('#groupName').val()+'&deptCode='+$('#deptCode').val(), 
	    "", 
		function(data){
			if(data <= 0){
				$("#addGroupForm").submit();				
			}else {
				remote.showErrors({"groupName": "该团队名已经存在，请重新输入！"});
			}
	     }	
	);	
}

function cancel(){
	window.location.href = "group.jsp";
}
</script>
</head>
<body>
	<table style="border: solid #d0d0d0 1px;width: 99.9%; margin-top:5px; padding-top: 8px;padding-bottom: 8px;padding-left: 20px;">
		<tr><td>团队新增</td></tr>
	</table>
	<div>
		<fieldSet>
			<legend>基本信息</legend>
			<form id="addGroupForm">
				<input type="hidden" name="groupCode" id="groupCode_pk" />
				<table style="padding-left:30px;">
						<tr>
							<td style="padding-left:30px;" align="right"><span class="label">二级机构：</span></td>
							<td><input name="parentDept" id="parentDept" class="sele"/><span style="color:red">*</span></td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px;" align="right"><span class="label">三级机构：</span></td>
							<td><input name="deptName" id="deptName"  class="sele"/><span style="color:red">*</span></td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px;" align="right"><span class="label">四级单位：</span></td>
							<td><input name="deptMarket"  id="deptMarket" class="sele"/><span style="color:red">*</span>
							    <input type="hidden" name="deptCode"  id="deptCode" value="" />
							</td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left: 30px;" align="right">团队名称：</td>
							<td><input type="text" name="groupName" id="groupName"  /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left: 30px;" align="right">团队成立时间：</td>
							<td><input type="text" name="foundDate" id="foundDate" class="sele"/><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<!-- <td style="padding-left: 30px;" align="right">是否虚拟团队：</td>
							<td><input class="sele"  name="virtualFlag"  id="virtualFlag"  /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr> -->
							<td style="padding-left: 30px;" align="right">团队类型：</td>
							<td><input class="sele"  name="groupType"  id="groupType" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
				</table>
			</form>
		</fieldSet>
	</div>
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-left:30px;padding-top:10px" align="center">
				<a id="button-save" onclick="save()">保存</a>
				<a id="button-cancel"  onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
</body>
</html>