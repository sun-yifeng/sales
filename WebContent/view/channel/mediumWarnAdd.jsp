<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.sinosafe.xszc.constant.*, com.hf.framework.service.security.CurrentUser"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>中介合同资质预警添加</title>
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
<script type="text/javascript">
$(function(){
	   $("#addMediumWarning").find("input").css({"width":"151px"});
	   $(".sele").css({"width":"130px"});
	   $("#deptCname").css({"background-color":"#fff"});
	   /*设定时间
	   $('#settingDate').omCalendar({
	   		dateFormat : "yy-mm-dd"
	    });
		//设定时间给系统当前时间
		var date=new Date(); 
		var year=date.getFullYear(); 
		var month=date.getMonth()+1; 
		var day=date.getDate();
		if(month<10){
			month ="0" + month;
		}
		if(day<10){
			day = "0"+day;
		}
		var dateTime = year + "-" +month + "-" +day;
		$("#settingDate").val(dateTime);*/
	
		//初始化页面保存、取消按钮
		$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
		$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	
		//机构部门
	    $("#deptDropListTree").omTree({
	        dataSource : "<%=_path%>/department/queryDeptDropList.do",
		    simpleDataModel:true,
		    //
		    onBeforeExpand : function(node){
			  var nodeDom = $("#"+node.nid);
			  if(nodeDom.hasClass("hasChildren")){
				nodeDom.removeClass("hasChildren");
				$.ajax({
					url: '<%=_path%>/department/queryDeptDropList.do?parentCode='+node.id,
					method: 'POST',
					dataType: 'json',
					success: function(data){
						$("#deptDropListTree").omTree("insert", data, node);
					}
				});
			 }
			return true;
		   },
		   //触发选择事件时，回填数据到输入框
	       onSelect : function(nodedata) {
	         var ndata = nodedata, text = ndata.text, departCode = ndata.departCode;
	         ndata = $("#deptDropListTree").omTree("getParent", ndata);
	         while (ndata) {
		        //text = ndata.text + "-" + text;
		        ndata = $("#deptDropListTree").omTree("getParent", ndata);
	         }
	         
	         $("#deptCname").val(departCode+'-'+text);
	         $("#parentDept").val(departCode);
	         $("#deptCname").focus();
	         
	         if(departCode != ''){
		            //从后台取出三级机构的数据并赋值给第2个combo
		            $('#mediumCname').val('').omCombo('setData', "<%=_path%>/channelWarning/queryDeptMedium.do?deptCode="+departCode);
            }else{
            	//初始化合作机构名称
	        	$('#mediumCname').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
	        hideDropList();
	       },
	       onBeforeSelect : function(nodedata) {
	         if (nodedata.children) {
		        return true;
	         }
	       },
	       onSuccess: function(data){
	   	      $('#deptDropListTree').omTree('expandAll');
	   	   }
	   });
	    
	   //点击下拉按钮
	   $("#choose").click(function() {
	      showDropList();
	   });
	   
	   //点击输入框
	   $("#deptCname").click(function() {
	      showDropList();
	   });
	   
	   //定位下拉框
	   function showDropList() {
		  var cityInput = $("#deptCname");
	   	  var cityOffset = cityInput.offset();
	   	  var topnum = cityOffset.top+cityInput.outerHeight();
	   	  var leftnum = cityOffset.left-1;
	   	  if(!($.browser.msie)){
		  	  topnum = topnum - 10;
	      }
	      $("#deptDropListTree").css({"margin-left": leftnum + "px","margin-top": topnum +"px"}).show();
	      $("body").bind("mousedown", onBodyDown);
	   }
	   
	   //隐藏下来框
	   function hideDropList() {
	      $("#deptDropListTree").hide();
	      $("body").unbind("mousedown", onBodyDown);
	   }
	   
	   //
	   function onBodyDown(event) {
	      if(!(event.target.id == "choose" || event.target.id == "deptDropList" || $(event.target).parents("#deptDropList").length > 0)) {
		       hideDropList();
	        }
	   }
		
		//初始化中介名称
		$('#mediumCname').omCombo({
	        onValueChange : function(target, newValue, oldValue, event) {
				$("#channelCode").val(newValue);
				//$("#channelCodeNew").val(newValue);
				$("#channelCode").focus();
	        },
	        optionField : function(data, index) {
	            return data.text;
			},
			valueField : 'value',
			inputField : 'text',
			filterStrategy : 'anywhere',
            listAutoWidth : true
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
	    
		$("#addMediumWarning").validate({
        	rules : {
        		 email : {
        			required : true,
        			isEmail : true
        		},
				waringDay : {
					required : true
					//isWaringDay : true
				}, 
        		//parentDept : "required" ,
        		deptCname:{
					deptCnameRequired : true
				},
				mediumCname : "required" ,
				channelCode : "required"
				/*
				,settingDate : {
					required : true,
					isDate : true
				}*/
        	},
        	
        	messages : {
        		 email : {
        			required : "请输入邮箱"
        		},
        		waringDay : {
        			required : "预警天数不能为空"
        		}, 
        		/* parentDept : {
        			required : "机构名称必须选择",
        		}, */
        		mediumCname : {
					required : "代理机构名称必选",
				},
				channelCode : {
					required : "请确认已选择代理机构"
				}/*,
				settingDate : {
					required : '时间不能为空'
				}*/
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
                alert('提交成功！');
                $(this)[0].currentForm.reset();
                return false;
            }
        });
        
        $('.errorImg').bind('mouseover',function(){
            $(this).next().css('display','block');
        }).bind('mouseout',function(){
            $(this).next().css('display','none');
        });
        
        $.validator.addMethod("isEmail", function(value) {
        	 if(value == '') return true;
             var regu =/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
             var reg = new RegExp(regu);
             return reg.test(value);
        }, '请输入正确的邮箱格式');
        
        /*$.validator.addMethod("isWaringDay", function(value) {
       	 if(value == '') return true;
       	 if(value == '0')return false;
       	 var reg = new RegExp("^[0-9]*$");
          return reg.test(value);
        }, '请输入不为0的阿拉伯数字');*/

        $.validator.addMethod("deptCnameRequired", function(value) {
            return value != '请选择';
     	}, '机构部门必选');
});

//保存
function save(){
	if (!$("#addMediumWarning").validate().form()) 
		return false;  
	Util.post("<%=_path%>/channelWarning/saveMediumChannelWarning.do", $("#addMediumWarning").serialize(), function(data) {
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
	<div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
	<div>
		<table class="navi-no-tab">
			<tr><td>提示</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1、无论您是否添加过预警信息，在某个渠道的许可证到期前15天，系统都会向<a style="color:red" href="#">分公司业务线的渠道管理岗</a>发送一封预警邮件；</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2、您也可以在此页面选择某个渠道，自定义预警时间（天数），自定义预警邮件的接收人（预警邮件的接收人不一定是渠道管理岗）；</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3、如果您选择的预警时间为15天（同系统默认的预警天数），系统会在渠道的许可证到期前15天发送一封预警邮件；</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4、如果您选择的预警时间不是15天，系统会在渠道的许可证到期前15天发送一封预警邮件，在您选择的预警时间再发送一封邮件。</td></tr>
		</table>
	</div>
	<div>
		<fieldSet>
		    <legend>中介合同资质预警</legend>
			<form id="addMediumWarning">
				<input type="hidden" name="formMap['channelFlag']" id="channelFlag" value="0" />
				<table>
					<tr>
						<td style="padding-left: 30px" align="right"><span class="label">机构部门：</span></td>
						<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="deptCname" id="deptCname" readonly="readonly" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';"/><span id="choose" name="choose" class="om-combo-trigger"></span></span><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span>
						<input type="hidden" name="parentDept" id="parentDept" /></td>
						<td style="padding-left: 30px;" align="right">代理机构名称：</td>
						<td><input class="sele" name="mediumCname" id="mediumCname"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 30px;" align="right">代理机构编码：</td>
						<td><input type="text" id="channelCode" name="channelCode" readOnly="true"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left: 30px;" align="right" style="width:133px;">预警时间：</td>
						<td><input class="sele" type="text" name="waringDay" id="waringDay"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<!--  
						<td style="padding-left: 30px;" align="right">设定时间：</td>
						<td><input name="settingDate" id="settingDate" class="sele"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 30px;" align="right">设定人：</td>
						<td><input id="createdUser" readonly="readonly" value="<%=CurrentUser.getUser().getUserCName() %>" /></td>
						-->
						<td style="padding-left: 30px;" align="right">预警信息接收人邮箱：</td>
						<td><input name="email" id="email"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
				</table>
			</form>
		</fieldSet>
	</div>
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-left: 30px; padding-top: 10px" align="center">
					<a id="button-save" onclick="save()">保存</a> 
					<a id="button-cancel" onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
</body>
</html>