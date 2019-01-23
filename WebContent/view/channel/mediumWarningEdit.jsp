<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>中介合同资质预警修改</title>
<style type="text/css">
/*浏览器兼容*/
*{padding:0;margin:0}
/*页面边距*/
html,body{height:100%;margin:0;padding:0}
/*机构菜单*/
.deptDropListTree{height:250px;width:151px;border:1px solid #9aa3b9;overflow:auto;display:none;position:absolute;background:#FFF;z-index:4;}
.om-grid{border:none;}
/*提示信息*/
.msg-info{/*list-style-type:none;*/margin:0 30px 0 0;padding-left:20px;background:#FCEFE3;min-width:200px;}
/*导航标题*/
.navi-tab{border: solid #d0d0d0 1px; width: 100%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px;}
.navi-no-tab{border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
/*校验提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer;margin-left:-2px;}
input.error,textarea.error{border:1px solid red;}
.errorMsg{border:1px solid gray;background-color:#FCEFE3;display:none;position:absolute;margin-top:-18px;margin-left:-2px;}
/*校验星号*/
span.asterisk{color:red;position:relative;top:4px;}
/*提示按钮*/
.msg-btn{cursor:pointer;font-size:14px;font-weight:bold;margin-right:4px;color:red}
</style>
<% String warningId = request.getParameter("warningId"); %>
<script type="text/javascript">
var warningId = <%=warningId%>;

$(function(){
	$("#updateMediumWarning").find("input").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#divPanel").omPanel({
	    collapsible:true,_helpMsg:true
	  });
	  
	/*设定时间
	$('#settingDate').omCalendar({
	     dateFormat : "yy-mm-dd"
	});*/
	
	//获取CODE用于查询详细数据
	$('#warningId_fk').val(warningId);
	$('#warningId_fk1').val(warningId);
	    
	//初始化页面保存、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	    
	//初始化根据CODE查出来的详细数据
	Util.post("<%=_path%>/channelWarning/queryAgentWarningByWhere.do",$("#warningForm").serialize(), function(data) {
	      $("#updateMediumWarning").find(":text").each(function(){
	        $(this).val(data[0][$(this).attr("name")]);
	      });
	      $('#deptName').omCombo({
	        value:data[0].deptName,
	         optionField : function(data, index) {
	                  return data.text;
	          },
	          valueField : 'value',
	          inputField : 'text',
	          emptyText : '请选择',
	          filterStrategy : 'anywhere'
	      });
	      $('#mediumCname').omCombo({value:data[0].mediumCname});
	      $("#oldChannelCode").val(data[0].channelCode);
	      $("#lodCreatedUser").val(data[0].createdUser);
	      //预警时间
	      $('#waringDay').omCombo({value : data[0].waringDay});
	    });
	
	  //预警时间
	  $("#waringDay").omCombo({
	      dataSource:[{"text":"请选择","value":""},{"text":"7 天","value":"7"},{"text":"15 天","value":"15"}, 
	                  {"text":"30 天","value":"30"},{"text":"60 天","value":"60"}],
	      value:'15',            
	      inputField:"text",
	      valueField:"value",
	      emptyText:"请选择"
	      //listAutoWidth : true
	  });
		    
	  $("#updateMediumWarning").validate({
	      rules : {
	        email : {
	          required : true,
	          isEmail : true
	        },
	    waringDay : {
	      required : true
	    },
	        parentDept : "required" ,
	    mediumCname : "required" ,
	      },
	          
	      messages : {
	        email : {
	          required : "请输入邮箱"
	        },
	        waringDay : {
	          required : "预警时间不能为空"
	        },
	        parentDept : {
	          required : "机构名称不能修改",
	        },
	        mediumCname : {
	      required : "代理机构名称不能修改",
	    }
	      },
	          
	        errorPlacement : function(error, element) { 
	          if(error.html()){
	                $(element).parents().map(function(){
	                    if(this.tagName.toLowerCase()=='td'){
	                        var attentionElement = $(this).next().children().eq(0);
	                        attentionElement.css('display','block');
	                      attentionElement.next().html(error);
	                    }
	                });
	            }
	      },
	      showErrors: function(errorMap, errorList) {
	        if(errorList && errorList.length > 0){
	                $.each(errorList,function(index,obj){
	                    var msg = this.message;
	                    $(obj.element).parents().map(function(){
	                      if(this.tagName.toLowerCase()=='td'){
	                          var attentionElement = $(this).next().children().eq(0);
	                          attentionElement.show();
	                        attentionElement.next().html(msg);
	                      }
	                  });
	                 });
	            }else{
	                $(this.currentElements).parents().map(function(){
	                    if(this.tagName.toLowerCase()=='td'){
	                        $(this).next().children().eq(0).hide();
	                    }
	                });
	            }
	            this.defaultShowErrors();
	        },
	      submitHandler : function(){
	            //alert('提交成功！');
	            $(this)[0].currentForm.reset();
	            return false;
	        }
	    });
	        
	    $('.errorImg').bind('mouseover',function(){
	        $(this).next().css('display','block');
	    }).bind('mouseout',function(){
	        $(this).next().css('display','none');
	    });
	        
	    //$('#settingDate').omCalendar('disable');
	$('#mediumCname').omCombo('disable');
	    
	 $.validator.addMethod("isEmail", function(value) {
	       if(value == '') return true;
	         var regu =/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
	         var reg = new RegExp(regu);
	         return reg.test(value);
	    }, '请输入正确的邮箱格式');
	        
	/*$.validator.addMethod("isWaringDay", function(value) {
	        if(value == '') return true;
	        if(value == '0') return false;
	       var reg = new RegExp("^[0-9]*$");
	      return reg.test(value);
	     }, '请输入不为0的阿拉伯数字');*/
});

//保存
function save(){

	if (!$("#updateMediumWarning").validate().form()) 
		return false;
	
	$("#newSettingDate").val($("#settingDate").val());
	$("#newMediumCname").val($("#mediumCname").val());
	$("#newChannelCode").val($("#channelCode").val());

	Util.post("<%=_path%>/channelWarning/updateMediumChannelWarning.do",$("#updateMediumWarning").serialize(),function(data) {
		window.location.href = "mediumWarn.jsp";
    });
}

//取消	
function cancel(){
		window.location.href = "mediumWarn.jsp";
}
</script>
</head>
<body>
    <div>
        <table class="navi-no-tab">
            <tr><td>提示</td></tr>
            <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1、无论您是否添加过预警信息，在某个渠道的许可证到期前15天，系统都会向<a style="color:red" href="#">分公司业务线的渠道管理岗</a>发送一封预警邮件；</td></tr>
            <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2、您也可以在此页面选择某个渠道，自定义预警时间（天数），自定义预警邮件的接收人（预警邮件的接收人不一定是渠道管理岗）；</td></tr>
            <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3、如果您选择的预警时间为15天（同系统默认的预警天数），系统会在渠道的许可证到期前15天发送一封预警邮件；</td></tr>
            <tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4、如果您选择的预警时间不是15天，系统会在渠道的许可证到期前15天发送一封预警邮件，在您选择的预警时间再发送一封邮件。</td></tr>
        </table>
    </div>
	<div >
		<form id="warningForm">
			<input type="hidden" name="formMap['warningId']"  id="warningId_fk1"  value=""/>
			<input type="hidden" name="formMap['channelFlag']"  id="channelFlag"  value="0"/>
		</form>
		<fieldSet style="margin-top: 10px;">
		    <legend>中介合同资质预警</legend>
			<form id="updateMediumWarning">
				<input type="hidden" name="warningId"  id="warningId_fk" />
				<input type="hidden" name="formMap['channelFlag']" id="channelFlag" value="0"/>
				<table class="fontClass">
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">机构部门：</span></td>
							<td><input name="deptName" id="deptName" class="sele" readOnly="true"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left: 30px;" align="right">代理机构名称：</td>
							<td><input name="mediumCname"  id="mediumCname" class="sele" readOnly="true"/>
								<input type="hidden" name="mediumCname" id="newMediumCname" >
							</td>
							<td style="padding-left: 30px;" align="right">代理机构编码：</td>
							<td><input name="channelCode"  id="channelCode"  disabled="disabled" />
								<input type="hidden" name="channelCode"  id="newChannelCode"  />
							</td>
						</tr>
						<tr>
							<td style="padding-left: 30px;" align="right">预警时间：</td>
							<td><input class="sele" type="text" name="waringDay" id="waringDay" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<!--  	
							<td style="padding-left: 30px;" align="right">设定时间：</td>
							<td><input  name="settingDate"  id="settingDate" type="text" class="sele" readOnly="true"/>
									<input type="hidden"  name="settingDate"  id="newSettingDate" />
							</td>
							<td style="padding-left: 30px;" align="right">设定人：</td>
							<td><input id="lodCreatedUser"  disabled="disabled"/>
								<input type="hidden" name="createdUser"  id="createdUser" />
							</td>
						</tr>
						<tr>
						-->
							<td style="padding-left: 30px;" align="right">预警信息接收人邮箱：</td>
							<td><input  name="email"  id="email" /><span style="color:red">*</span></td>
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
				<a id="button-cancel" onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
</body>
</html>