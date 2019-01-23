<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*, com.hf.framework.service.security.CurrentUser"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>文档上传</title>
<style type="text/css">
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
	
	$("#addSurveyDocument").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	
	//设定时间
	   $('#createdDate').omCalendar({
		  	editable : false,
	   		dateFormat : "yy-mm-dd",
	   		width : 150
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
		$("#createdDate").val(dateTime);
	
		//初始化页面保存、取消按钮
		$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
		$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
		
		//加载二级机构名称
		$('#parentDept').omCombo({
	        dataSource : "<%=_path%>/department/queryProvinceCompany.do",
	        optionField : function(data, index) {
	            return data.text;
			},
			valueField : 'value',
			inputField : 'text',
			filterStrategy : 'anywhere',
			emptyText : '请选择',
	        width : '170px',
	        onSuccess:function(data, textStatus, event){
	        	if(data.length == 1)
	        	$('#parentDept').omCombo({
					value:eval(data)[0].value
				});
	        },
	        onValueChange : function(target, newValue, oldValue, event) {
	            //取出第1个combo的当前值
	            var currentParentDept = $('#parentDept').omCombo('value');
	            if(currentParentDept != ''){
		            //从后台取出三级机构的数据并赋值给第2个combo
		            $('#deptCode').val('').omCombo({
		            	dataSource : "<%=_path%>/department/queryCityCompany.do?province="+$("#parentDept").val(),
		            	onSuccess:function(data, textStatus, event){
		            		if(data.length == 1)
		                	$('#deptCode').omCombo({
		        				value:eval(data)[1].value
		        			});
		                }		
		            });
	            }else{
		        	//初始级机构名称
		        	$('#deptCode').omCombo({
		                 dataSource : [ {text : '请选择', value : ''} ]
		            });
	            }
	        },
	        optionField : function(data, index) {
	            return data.text;
			},
			filterStrategy : 'anywhere'
	    });
		
		//初始化三级机构名称
		$('#deptCode').omCombo({
			valueField : 'value',
			inputField : 'text',
			filterStrategy : 'anywhere',
			emptyText : '请选择',
	        width : '170px',
		});
		
		$('#docType').omCombo({
	        dataSource : <%=Constant.getCombo("docType")%>,
	        editable : false,
	        emptyText : '请选择',
			width : '170px',
	    });
		
		initValidate();
	    
	    $('.errorImg').bind('mouseover', function() {
		    $(this).next().css('display', 'block');
	    }).bind('mouseout', function() {
		    $(this).next().css('display', 'none');
	    });
	});
		//定义校验规则
		var surveyConferRule = {
			parentDeptformMap:{
				required : true
			},deptCodeformMap:{
				required : true
			},docTypeformMap:{
				required : true,
			}
       	};
        	
		//定义校验的显示信息
		var surveyConferMessages = {
			parentDeptformMap : {
				required : '二级机构必选'
			},deptCodeformMap : {
				required : '三级机构必选'
			},docTypeformMap : {
				required : '文档类型不能为空',
			}
       	};
        	
		 //校验
        function initValidate(){
        	//将name属性修改进行验证
        	$("#addSurveyDocument").find("input[name^='formMap']").each(function(){
        		$(this).attr("name",$(this).attr("id")+"formMap");
        	});
        	
        	$("#addSurveyDocument").validate({
        		rules: surveyConferRule,
        		messages: surveyConferMessages,
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
                	$("#addSurveyDocument").find("input[name$='formMap']").each(function(){
                		$(this).attr("name","formMap['"+$(this).attr("id")+"']");
                	});
                	
                	Util.post(
               			"<%=_path%>/survey/saveSurvey.do",$("#addSurveyDocument").serialize(),function(data) {
               				//保存成功后跳转回市场管理主页
               				window.location.href = "survey.jsp";
               	    	}
                	);
                }
            });
        }
	//表单提交
	function save(){
		$("#addSurveyDocument").submit();
	}
	
	function cannel(){
		window.location.href='survey.jsp';
	}
	//formMap['deptCode']
</script>
</head>
<body>
	<div style="font-weight: bold;">
		<table
			style="border: solid #d0d0d0 1px; width: 100%; padding-top: 8px; padding-bottom: 3px; padding-left: 20px;">
			<tr><td>文档上传</td></tr>
		</table>
	</div>
	<div>
		<fieldSet style="margin-top: 10px;">
			<form id="addSurveyDocument">
				<table>
					<tr>
						<td style="padding-left:30px"><span class="label">二级机构：</span></td>
						<td><input class="sele" name="formMap['parentDept']" id="parentDept" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px"><span class="label">三级机构：</span></td>
						<td><input class="sele"  name="formMap['deptCode']" id="deptCode" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px"><span class="label">文档类型：</span></td>
						<td><input type="text"  class="sele"  name="formMap['docType']" id="docType" readonly="readonly"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 30px;" align="right">上传日期：</td>
						<td><input name="formMap['createdDate']" id="createdDate" style="width:110px;"/><span style="color:red">*</span></td>
						<td></td>
					</tr>
				</table>
			</form>
		</fieldSet>
	</div>
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-left: 30px; padding-top: 10px" align="right">
					<a id="button-save" onclick="save()">保存</a> 
					<a id="button-cancel" onclick="cannel();">取消</a>
				</td>
			</tr>
		</table>
	</div>
	<div>
		<div>
			<jsp:include page="/view/demo/fileUpload.jsp"></jsp:include>
			<!-- <input id="file_upload" name="file_upload" type="file" />
    		<button value="上传" onclick="$('#file_upload').omFileUpload('upload')">上传</button>
   			<div id="response" style="font-weight: bold;color: red;"></div> -->
		</div>
	</div>
</body>
</html>