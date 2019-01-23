<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
/*导航标题*/
.navi-tab{border: solid #d0d0d0 1px; width: 100%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px;}
.navi-no-tab{border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
/*校验错误提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error, textarea.error {border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px}
</style>
<title>个代推荐人新增</title>
<% String trueOrFalse = request.getParameter("trueOrFalse"); %>
<% String recommenderId = request.getParameter("recommenderId"); %>
<script type="text/javascript">
var trueOrFalse = <%=trueOrFalse %>
$(function(){
	//input框 整体样式
	$("#updateVirtualForm").find("input").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#recommenderCode").css({"background-color":"#fff"});
	
	$("#recommenderId").val('<%=recommenderId %>');
	Util.post("<%=_path%>/recommender/queryRecommenderDetail.do?recommenderId=<%=recommenderId %>", "", function(data) {
		$("#updateVirtualForm").find(":input").each(function(){
            if($(this).val() != null || $(this).val() != "")
            $(this).val(data[$(this).attr("id")]);
        });
		$("#updateVirtualForm").find("input[name^='formMap']").each(function(){
		    $(this).attr({disabled:"disabled"});
		});
	});
	
	//选择代理人代码和名称
	$("#agent-dialog-model").omDialog({
	     autoOpen:false,
	     width:750,
	     height:465,
	     modal:true,
	     resizable:false,
	     onOpen:function(event) {
	    	$("#agentIframe").attr("src","<%=_path%>/view/demo/selectAgentCodeIframe.jsp");
	     }
	});
	
	//选择推荐人代码和名称
	$("#recommender-dialog-model").omDialog({
	     autoOpen:false,
	     width:750,
	     height:465,
	     modal:true,
	     resizable:false,
	     onOpen:function(event) {
	    	$("#recommenderIframe").attr("src","<%=_path%>/view/demo/selectRecommenderCodeIframe.jsp");
	     }
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

};

 //定义校验的显示信息
 var virtualConferMessages = {
	
 };

//校验全局调用
 var remote;
 //校验
 function initValidate(){
		//将name属性修改进行验证
		$("#updateVirtualForm").find("input[name^='formMap']").each(function(){
			$(this).attr("name",$(this).attr("id")+"formMap");
		});
	 
	remote = $("#updateVirtualForm").validate({
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
         	$("#updateVirtualForm").find("input[name$='formMap']").each(function(){
         		$(this).attr("name","formMap['"+$(this).attr("id")+"']");
         	});
        	 //提交保存入库
     		Util.post("<%=_path%>/recommender/updateRecommender.do",$("#updateVirtualForm").serialize(), 
					function(data) {
     			  /*$.omMessageBox.alert({
			           content:'新增团队信息成功!',
			           onClose:function(v){
			        	   window.location.href = "virtual.jsp";
			           }
			       }); */
					//保存成功后跳转回员工管理页
					window.location.href = "recommender.jsp";
	    	});
         }
     });
 }
 
 //保存操作
function save() {
	$("#updateVirtualForm").submit();
}

//选择代理人编码和代理人名称
function selAgent(){
  $("#agent-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
}

//填充数据（选择代理人）
function fillAgentBackAndCloseDialog(rowData) {
	  if(rowData.channelCode == '--'){
		  $("#channelCode").val("无");
	  } else {
	  	  $("#channelCode").val(rowData.channelCode);
	  	  $("#channelName").val(rowData.channelName);
	  	  $("#deptCode").val(rowData.deptCode);
	  	  $("#deptCname").val(rowData.deptCname);
	  }
	  $("#agent-dialog-model").omDialog('close');
	  $("#channelCode").focus();
}

//填充数据（选择代理人）
function fillRecommenderBackAndCloseDialog(rowData) {
	  if(rowData.channelCode == '--'){
		  $("#channelCode").val("无");
	  } else {
	  	  $("#recommenderCode").val(rowData.employCode);
	  	  $("#recommenderName").val(rowData.salesmanCname);
	  }
	  $("#recommender-dialog-model").omDialog('close');
	  $("#channelCode").focus();
}

//选择代理人编码和代理人名称
function selRecommender(){
  $("#recommender-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
}
 
function cancel(){
	window.location.href = "recommender.jsp";
}
</script>
</head>
<body>
	<table class="navi-no-tab">
		<tr><td>个人推荐人新增</td></tr>
	</table>
	<div>
		<fieldSet>
		<legend>个人推荐人信息</legend>
			<form id="updateVirtualForm">
				<input type="hidden" name="formMap['recommenderId']" id="recommenderId">
				<table style="padding-left:30px;">
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">个人代理人编码：</span></td>
						<td><input name="formMap['channelCode']"  id="channelCode" readonly="readonly"/><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">个人代理人姓名：</span></td>
						<td><input name="formMap['channelName']"  id="channelName" readonly="readonly"/><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">推荐人工号：</span></td>
						<td><input name="formMap['recommenderCode']"  id="recommenderCode" readonly="readonly" onclick="selRecommender();" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">推荐人姓名：</span></td>
						<td><input name="formMap['recommenderName']"  id="recommenderName" readonly="readonly"/><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
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
	<div id="agent-dialog-model" title="选择代理人">
		<iframe id="agentIframe" frameborder="0" style="width: 100%; height: 99%; height: 100%; overflow-y:hidden; " src="about:blank"></iframe>
	</div>
	
	<div id="recommender-dialog-model" title="选择推荐人">
		<iframe id="recommenderIframe" frameborder="0" style="width: 100%; height: 99%; height: 100%; overflow-y:hidden; " src="about:blank"></iframe>
	</div>
</body>
</html>