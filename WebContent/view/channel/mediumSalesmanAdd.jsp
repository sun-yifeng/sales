<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script  src='<%=_path%>/core/js/validateForm.jsp'></script> 
<style type="text/css">
/*导航标题*/
.navi-tab{border: solid #d0d0d0 1px; width: 100%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px;}
.navi-no-tab{border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
/*校验错误提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error, textarea.error {border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px}
</style>
<title>渠道销售人员新增</title>
<% String trueOrFalse = request.getParameter("trueOrFalse"); %>
<script type="text/javascript">
var trueOrFalse = <%=trueOrFalse %>
$(function(){
	//input框 整体样式
	$("#addVirtualForm").find("input").css({"width":"151px"});
	$(".sele").css({"width":"151px"});
	$("#addStatus").css({"width":"131px"});
	$("#twoDeptCode").css({"width":"131px"});
	$("#threeDeptCode").css({"width":"131px"});
	$("#addMedium").css({"width":"350px"});
	//入职时间
    $('#enterDate').omCalendar({
	  dateFormat : "yy-mm-dd"
     });
    $('#endDate').omCalendar({
  	  dateFormat : "yy-mm-dd"
       });
    
    $("#addIdCard").blur(function(){
    	var idCardValue = $("#addIdCard").val();
    	  if(idCardValue!=""){
    		  var birthdayValue = idCardValue.substring(6, 14);
    		  $("#addBirthday").val(birthdayValue);
    		  var sexValue = maleOrFemalByIdCard(idCardValue);
    		  $("#addSex").val(sexValue);
    	  }
    	});
    
  	//设定时间给系统当前时间
	var date=new Date(); 
	$("#enterDate").val($.omCalendar.formatDate(date,'yy-mm-dd'));
	var lastdate=new Date(new Date().getFullYear(),new Date().getMonth()+1,0);
	$("#endDate").val($.omCalendar.formatDate(lastdate,'yy-mm-dd'));
	$('#birthday').omCalendar({editable : false});
	$('#enterDate').omCalendar({editable : false});
	//人员类别
	if(trueOrFalse == '0'){
		$('#salesmanType').omCombo({
	        dataSource : <%=Constant.getCombo("salesmanType1")%>,
	        editable : false,
	        emptyText : '请选择',
	        lazyLoad : true,
	        onValueChange:function(target,newValue,oldValue,event){
	            if(newValue == 0){
	            	$('#salesmanCname').rules('add',{
	            		required : true,
	           	      	messages: {
	           	      		required : jQuery.format("对应HR人员姓名不能为空")
	           	      	}
	            	});
	            }else{
	            	$("#salesmanCname").rules("remove", "required"); //remove可以配置多个rule，空格隔开
	        		$("#salesmanCnameImg").hide();
	            }
	        }
	    });
	}else if(trueOrFalse == '1'){
		$('#salesmanType').omCombo({
			dataSource : [ {"text":"远程出单点出单员","value":"1"} ],
			valueField : 'value',
			inputField : 'text',
			editable : false,
	        lazyLoad : true,
	        value : '1',
	    });
	}else{
		$('#salesmanType').omCombo({
	        dataSource : <%=Constant.getCombo("salesmanType2")%>,
	        editable : false,
	        emptyText : '请选择',
	        lazyLoad : true,
	        onValueChange:function(target,newValue,oldValue,event){
	            if(newValue == 0){
	            	$('#salesmanCname').rules('add',{
	            		required : true,
	           	      	messages: {
	           	      		required : jQuery.format("对应HR人员姓名不能为空")
	           	      	}
	            	});
	            }else{
	            	$("#salesmanCname").rules("remove", "required"); //remove可以配置多个rule，空格隔开
	        		$("#salesmanCnameImg").hide();
	            }
	        }
	    });
	}
	
	//加载二级机构名称
	$('#twoDeptCode').omCombo({
        dataSource: "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#twoDeptCode').omCombo({
				value:eval(data)[1].value,
    			readOnly: true
			});
        },
        onValueChange: function(target, newValue, oldValue, event) {
            $('#threeDeptCode').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
        },
        optionField: function(data, index) {
            return data.text;
		},
		emptyText: "请选择",
		filterStrategy: 'anywhere'
    });
	
	//初始化三级机构名称
	$('#threeDeptCode').omCombo({
		onSuccess:function(data, textStatus, event){
			if(data.length === 2){
				$('#threeDeptCode').omCombo("value",data[1].value);
        		$('#threeDeptCode').omCombo({
        			readOnly: true
        		});
        	}
		},
		valueField: 'value',
		inputField: 'text',
		filterStrategy: 'anywhere',
		emptyText: '请选择'
	});
	
	//初始化导入窗口数据
  	$("#impXlsArea").omDialog({
		autoOpen:false,
		title:"渠道销售人员数据导入",
		width:500,
		height: 261,
		modal: true
	});
	  //选择合作机构
	$("#agent-dialog-model").omDialog({
	     autoOpen:false,
	     width:750,
	     height:465,
	     modal:true,
	     resizable:false,
	     onOpen:function(event) {
	    	$("#agentIframe").attr("src","<%=_path%>/view/demo/selectMediumIframe.jsp?twoDeptCode="+$('#twoDeptCode').val()+"&&threeDeptCode="+$('#threeDeptCode').val());
	     }
	});
	
	//员工状态
	$('#addStatus').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		 dataSource : [ {text : '在职', value : '1'}, 
                        {text : '离职', value : '2'}]
    });
	//初始化页面保存、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
		
	initValidate();//初始化校验
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
	
	}); 
 
//定义校验规则
 var virtualConferRule = {
	addNameformMap:{
 		required : true,
 		minlength:2
	},	
	addIdCardformMap:{
		required : true,
		isIdCard : true
	},
	addMobileformMap:{
		required : true,
		isTel : true
	},
 	addStatusformMap:{
 		required : true
 	},
 	addMediumformMap:{
 		required : true
 	}
 };

 //定义校验的显示信息
 var virtualConferMessages = {
	addNameformMap:{
		required : '姓名不能为空',
 		minlength:'姓名长度不能小于2'
	},	
 	addIdCardformMap:{
 		required : '身份证号码不能为空'
 	},
 	addMobileformMap:{
 		required : '手机号码不能为空',
 	},
 	addStatusformMap:{
 		required : '员工状态不能为空'
 	},
 	addMediumformMap:{
 		required : '合作机构不能为空'
 	}
 };

//校验全局调用
 var remote;
 //校验
 function initValidate(){
		//将name属性修改进行验证
		$("#addVirtualForm").find("input[name^='formMap']").each(function(){
			$(this).attr("name",$(this).attr("id")+"formMap");
		});
	 
	remote = $("#addVirtualForm").validate({
 		rules: virtualConferRule,
 		messages: virtualConferMessages,
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
         	//将name属性还原，提交保存
         	$("#addVirtualForm").find("input[name$='formMap']").each(function(){
         		$(this).attr("name","formMap['"+$(this).attr("id")+"']");
         	});
         	Util.post(
           			"<%=_path%>/mediumSalesman/saveSalesmanAdd.do",
           			$("#addVirtualForm").serialize(),
           			function(data) {
           				if(data.idFlag=="idError"){
	           				$.omMessageBox.waiting('close');
	           				$.omMessageBox.alert({
	           				   type:'error',
	           				   content:'您输入的身份证号已存在!',
	     		 	        });
           				}else if(data.idFlag=="error"){
           					$.omMessageBox.waiting('close');
	           				$.omMessageBox.alert({
	           				   type:'error',
	           				   content:'操作失败,请重试!',
	     		 	        });
           				}else{
           					$.omMessageBox.waiting('close');
	           				$.omMessageBox.alert({
	           				   type:'success',
	           				   content:'保存成功!',
	           		           onClose:function(v){
	           		        	window.location.href = "mediumSalesman.jsp";
	           		        	 return true;
	           		           }
	     		 	        });
           				}
           	    	}
            	);
         }
     });
 }
 
 //保存操作
function save() {
	//页面校验
	if (!$("#addVirtualForm").validate().form()) 
		return false;
	$("#addVirtualForm").submit();
}
function cancel(){
	window.location.href = "mediumSalesman.jsp";
}

//选择合作机构
function selAgent(){
	var twoDeptValue = $("#twoDeptCode").val();
	if(twoDeptValue!=""){
        $("#agent-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
	}else{
		$.omMessageBox.alert({
            type:'error',
            content:"请先选择二级机构",
            onClose:function(value){
		 	        	return false;
		 	        }
        });
	}
}

//填充数据（选择合作机构/个人代理人）
function fillMediumBackAndCloseDialog(rowData) {
	  if(rowData.channelCode == ''){
		  $("#addMedium").val("无");
	  } else {
		  $("#channelCode").val(rowData.channelCode);
		  if(rowData.mediumCname==undefined){
			  $("#addMedium").val(rowData.channelCode+"-"+rowData.agentCname);
		  }else{
			  $("#addMedium").val(rowData.channelCode+"-"+rowData.mediumCname);
		  }
	  }
	  $("#agent-dialog-model").omDialog('close');
	  $("#addMedium").focus();
}

/**  
 * 通过身份证判断是男是女
 * @param idCard 15/18位身份证号码
 * @return 'female'-女、'male'-男
 */
function maleOrFemalByIdCard(idCard){
    idCard = trim(idCard.replace(/ /g, ""));// 对身份证号码做处理。包括字符间有空格。   
    if (idCard.length == 15) {
        if (idCard.substring(14, 15) % 2 == 0) {
            return "女";//'female';
        }
        else {
            return  "男";//'male';
        }
    }
    else 
        if (idCard.length == 18) {
            if (idCard.substring(14, 17) % 2 == 0) {
            	return "女";//'female';
            }
            else {
            	return  "男";//'male';
            }
        }
        else {
            return "未知";
        }
}

</script>
</head>
<body>
	<table class="navi-no-tab">
		<tr><td>渠道销售人员新增</td></tr>
	</table>
	<div>
		<fieldSet>
		<legend>销售人员信息</legend>
			<form id="addVirtualForm">
				<table style="padding-left:30px;">
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">姓名：</span></td>
						<td><input class="sele" name="formMap['addName']" id="addName" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">身份证号：</span></td>
						<td><input name="formMap['addIdCard']"  id="addIdCard" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">手机：</span></td>
						<td><input class="sele" name="formMap['addMobile']" id="addMobile"  /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
					    <td style="padding-left:30px" align="right"><span class="label">性别：</span></td>
						<td><input name="formMap['addSex']"  id="addSex"  readonly="readonly"/></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">出生日期：</span></td>
						<td><input class="sele" name="formMap['addBirthday']"  id="addBirthday"  readonly="readonly"/></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">邮箱：</span></td>
						<td><input class="sele" name="formMap['addEmail]"  id="addEmail" /></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right">员工状态：</td>
						<td><input class="sele" type="text" name="formMap['addStatus']" id="addStatus" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">二级机构：</span></td>
						<td><input name="formMap['twoDeptCode']"  id="twoDeptCode"  /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right">三级机构：</td>
						<td><input class="sele" name="formMap['threeDeptCode']" id="threeDeptCode"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td><input type="hidden" name="formMap['channelCode']" id="channelCode"/></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right">渠道选择：</td>
						<td colspan="4"><input class="sele" type="text" name="formMap['addMedium']" id="addMedium"  onclick="selAgent();"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					
				</table>
			</form>
		</fieldSet>
	</div>
	<div>
		<table style="width: 100%;">
			<tr>
				<td style="padding-left:30px;padding-top:10px" align="center">
				<a id="button-save" onclick="save()" id="sub">保存</a>
				<a id="button-cancel"  onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
	<div id="agent-dialog-model" title="选择渠道">
		<iframe id="agentIframe" frameborder="0" style="width: 100%; height: 99%; height: 100%; overflow-y:hidden; " src="about:blank"></iframe>
	</div>
</body>
</html>