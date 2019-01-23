<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<% String groupCode = request.getParameter("groupCode"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>团队长设定</title>
<style type="text/css">
html,body{height:100%;margin:0;padding:0}
body{font-size:12px}
.om-button{font-size:12px}
#nav_cont{width:580px;margin-left:auto;margin-right:auto}
input{border:1px solid #a1b9df;vertical-align:middle;width:150px}
input:focus{border:1px solid #3a76c2}
.input_slelct{width:81%}
.textarea_text{border:1px solid #a1b9df;height:40px;width:445px}
table.grid_layout tr td{font-weight:normal;height:15px;padding:5px 0;vertical-align:middle}
.color_red{color:red}
.toolbar{padding:12px 0 5px;text-align:center}
.birthplace,.address{width:445px}
.om-span-field input:focus{border:0}
.errorImg{background:url("../../images/msg.png") no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error,textarea.error{border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:18px}
 </style>
<script type="text/javascript">
var groupCode = <%=groupCode%>;
$(function(){
	$('#groupCode_fk').val(groupCode);
	$('#groupCode_fk1').val(groupCode);
	
	/******初始化tab标签页*********/
	$('#make-tab').omTabs({
	    closable : false
    });

	//获取单条数据详细
	Util.post(
		"<%=_path%>/groupMain/queryGroupMains.do",$("#groupCodeFrm").serialize(), 
		function(data){
			$("#addGroupLeaderRecordForm").find(":text").each(function(){
				$(this).val(data[0][$(this).attr("name")]);
			});
						
 			$('#parentDept').omCombo({
				readOnly : true
 			});
			$('#deptName').omCombo({
				readOnly : true
			});
			$('#deptMarket').omCombo({
				readOnly : true
			}); 
			//团队长职级
			$('#groupRank').omCombo({
				dataSource :"<%=_path%>/lawRank/queryRankCodeAndName.do?deptCode="+data[0].parentDeptCode+"&managerFlag=1",
				emptyText : '请选择',
	   		    editable : false,
	   		 	width : '150px'
		    });
			
			//业绩统计
			$('#statistic').omCombo({
				dataSource :<%=Constant.getCombo("statistic")%>,
				emptyText : '请选择',
       		    editable : false,
       		 	width : '150px'
	    	});
			
			//团队长名称与账户
			$('#salesmanCname').omCombo({
				dataSource : "<%=_path%>/groupMain/queryGroupSalesman.do?groupCode="+$('#groupCode_fk1').val(),
				 onValueChange : function(target, newValue, oldValue, event) {
						$("#salesmanCode").val(newValue);
				},
		        optionField : function(data, index) {
		            return data.text;
				},
				value : data[0].userCode,
		        editable : false,
		        emptyText : "请选择",
		        width : '150px'
		    });
    });
	
	//初始化页面保存、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	
	initValidate();
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
    
});

//定义校验规则
var groupLeaderConferRule = {
	salesmanCname:{
		required : true
	},
	groupRank:{
		required : true
	},
	salesmanCode:{
		required : true
	}
};

//定义校验的显示信息
var groupLeaderMessages = {
		salesmanCname:{
		required : '团队长名称不能为空'
	},
	groupRank:{
		required : '团队长职级不能为空'
	},
	salesmanCode:{
		required : '团队长代码不能为空'
	}
};

//校验
function initValidate(){
	
	$("#addGroupLeaderRecordForm").validate({
		rules: groupLeaderConferRule,
		messages: groupLeaderMessages,
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
    		Util.post("<%=_path%>/groupLeaderRecord/saveGroupLeaderRecord.do", $("#addGroupLeaderRecordForm").serialize(), function(data) {
				//保存成功后跳转回团队管理页
				window.location.href = "leader.jsp";
    		});
        }
    });
}

//禁用删除键的返回作用
document.onkeydown = function() {
	 // 如果按下的是退格键
     if(event.keyCode == 8) {
     // 如果是在textarea内不执行任何操作
	        if(event.srcElement.tagName.toLowerCase() != "input"  && event.srcElement.tagName.toLowerCase() != "textarea" && event.srcElement.tagName.toLowerCase() != "password"){
	            event.returnValue = false;
	        }
	        // 如果是readOnly或者disable不执行任何操作
	        if(event.srcElement.readOnly == true || event.srcElement.disabled == true){
	            event.returnValue = false;
	        }
     }
};

//保存团队长指定的操作
function save(){
	$("#addGroupLeaderRecordForm").submit();
}
function cancel(){
	window.location.href = "leader.jsp";
}
</script>
</head>
<body>
        <div id="saleGroup">
			<table style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
				<tr><td>团队长设定</td></tr>
			</table>
			<div>
				<form id="groupCodeFrm">
					<input type="hidden" name="formMap['groupCode']"  id="groupCode_fk1"  value=""/>
				</form>
				<fieldSet style="margin-top: 10px;">
					<form id="addGroupLeaderRecordForm">
						<table align="center"   style="font-size:12px;">
							<tr>
								<td style="padding-left: 30px;" align="right"><span class="label">二级机构：</span></td>
								<td><input name="parentDept" id="parentDept"  style="width: 130px;" readonly="readonly" /><span style="color:red">*</span></td>
								<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 30px;" align="right"><span class="label">三级机构：</span></td>
								<td><input name="deptName" id="deptName"  style="width: 130px;" readonly="readonly" /><span style="color:red">*</span></td>
								<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 30px;" align="right"><span class="label">四级单位：</span></td>
								<td><input name="deptMarket"  id="deptMarket" style="width: 128px;"  readonly="readonly" /><span style="color:red">*</span></td>
								<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left: 30px;" align="right">团队名称：</td>
								<td><input type="text" name="groupName"  id="groupName"  readonly="readonly"  /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 30px;" align="right">团队长名称：</td>
								<td><input name="salesmanCname"  id="salesmanCname" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>	
								<td style="padding-left: 30px;" align="right">团队长代码：</td>
								<td><input type="text" name="groupLeader" id="salesmanCode"  readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left: 30px;;" align="right">业绩统计：</td>
								<td><input type="text" name="statistic" id="statistic" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 30px;display:none;" align="right">团队代码：</td> 
								<td style="display:none"><input type="text" name="groupCode"/><span style="color:red">*</span></td> 
								<td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td> 
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
		</div>
</body>
</html>