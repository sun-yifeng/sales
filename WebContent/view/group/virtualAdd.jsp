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
<title>销售助理新增</title>
<% String trueOrFalse = request.getParameter("trueOrFalse"); %>
<script type="text/javascript">
var trueOrFalse = <%=trueOrFalse %>
$(function(){
	//input框 整体样式
	$("#addVirtualForm").find("input").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	//入职时间
    $('#enterDate').omCalendar({
	  dateFormat : "yy-mm-dd"
     });
    $('#endDate').omCalendar({
  	  dateFormat : "yy-mm-dd"
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
	
	//初始化机构部门
	$('#parentDept').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
        		$('#parentDept').omCombo({value:data[1].value});
        		$('#deptName').omCombo({
        			dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[1].value,
        			onSuccess  : function(data, textStatus, event){
        				if(data.length == 2){
        					$('#deptName').omCombo({value:data[1].value});
        					$('#deptMarket').val('').omCombo({
        						dataSource : "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+$("#deptName").val(),
        						onSuccess  : function(data, textStatus, event){
        							if(data.length == 2){
        								$('#deptMarket').omCombo({value:data[1].value});
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
	//根据三级机构查询出四级单位
	$('#deptMarket').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptMarket').omCombo('value');
            $("#deptCode").val(newValue);
            if(currentParentDept != ''){
	            $('#salesmanCname').val('').omCombo('setData', "<%=_path%>/salesman/queryNameAndCode.do?deptCode="+newValue);
	            $('#salesmanCode').val('');
            }else{
	        	$('#salesmanCname').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
	            $('#salesmanCode').val('');
            }
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
    });
	//初始化HR人员名称
	$('#salesmanCname').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
			$("#salesmanCode").val(newValue);
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
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
   /*     
   //身份证验证
    $.validator.addMethod("isIdCard", function(value) {
    	if (value.length == 15) {
   		 tmpStr = value.substring(6, 12);
   		 tmpStr = "19" + tmpStr;
   		 tmpStrs = tmpStr.substring(0, 4) + "-" + tmpStr.substring(4, 6) + "-" + tmpStr.substring(6);
   		 $("#birthday").val(tmpStrs);
   	 } else if(value.length == 18) {
   		 tmpStr = value.substring(6, 14);
   		 tmpStrs = tmpStr.substring(0, 4) + "-" + tmpStr.substring(4, 6) + "-" + tmpStr.substring(6);
   		 $("#birthday").val(tmpStrs);
   	 }
   	return IdCardValidate(value);
    }, $.omRules.lang.notIdCard);
    */
}); 
 
//定义校验规则
 var virtualConferRule = {
	salesmanTypeformMap:{
 		required : true,
	},	
 	cnameformMap:{
 		required : true,
 		minlength:2
 	},
	parentDeptformMap:{
		required : true
	},
	deptNameformMap:{
		required : true
	},
	deptMarketformMap:{
		required : true
	},
/*  	certiryNoformMap:{
 		required : true,
 		isIdCard:true,
 		maxlength:18
 	}, */
 	enterDateformMap:{
 		required : true
 	},
 	/* salesmanCnameformMap:{
 		required : true
 	}, */
 	employCodeformMap:{
 		required : true
 	},
 	endDateformMap:{
 		required : true
 	}
 };

 //定义校验的显示信息
 var virtualConferMessages = {
	salesmanTypeformMap:{
 		required : '人员类别必选',
	},	
	cnameformMap:{
 		required : '人员姓名不能为空',
 		minlength:'姓名长度不能小于2'
 	},
 	parentDeptformMap:{
 		required : '二级机构不能为空'
 	},
 	deptNameformMap:{
 		required : '三级机构不能为空'
 	},
 	deptMarketformMap:{
 		required : '四级单位不能为空'
 	},
 	certiryNoformMap:{
 		required : '身份证号码不能为空',
 		maxlength:'身份证长度不能大于18位'
 	},
 	enterDateformMap:{
 		required : '入职时间不能为空'
 	},
 	/* salesmanCnameformMap:{
 		required : '对应HR人员姓名不能为空'
 	}, */
 	employCodeformMap:{
 		required : '人员工号不能为空'
 	},
 	endDateformMap:{
 		required : '结束时间不能为空'
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
        	 //提交保存入库
     		Util.post("<%=_path%>/salesmanVirtual/saveSalesmanVirtual.do",$("#addVirtualForm").serialize(), 
					function(data) {
     			  /*$.omMessageBox.alert({
			           content:'新增团队信息成功!',
			           onClose:function(v){
			        	   window.location.href = "virtual.jsp";
			           }
			       }); */
					//保存成功后跳转回员工管理页
					window.location.href = "virtual.jsp";
	    	});
         }
     });
 }
 
 //保存操作
function save() {
	//结束时间要大于入职时间
	if($('#endDate').val()<$('#enterDate').val()&&$('#endDate').val()!=''){
		remote.showErrors({"endDateformMap": "结束时间要大于入职时间!"});
		return;
	}
	//页面校验
	if (!$("#addVirtualForm").validate().form()) 
		return false;
	//校验人员工号是否存在
	var salesmanType = $("#salesmanType").val();
	if(salesmanType == '1'){
		$.ajax({ 
			url: "<%=_path%>/salesmanVirtual/queryEmployCodeHR.do?employCode="+$('#employCode').val(),
			type:"post",
			async: false, 
			dataType: "html",
			success: function(data){
				if(data == "true"){
					$("#addVirtualForm").submit();
				}
				else{
					$.omMessageBox.confirm({
		                title:'确认操作',
		                content:'您输入的工号在HR中已存在，【确定】后将删除HR中该人员的信息，是否确定删除?',
		                onClose:function(flag){
		                    if(flag){
		                    	$("#addVirtualForm").submit();
		                    }
		                }
		            });
				}
				}
		}); 
	}else{
		$.ajax({ 
			url: "<%=_path%>/salesmanVirtual/queryEmployCode.do?employCode="+$('#employCode').val(),
			type:"post",
			async: false, 
			dataType: "html",
			success: function(dataValue){
				eval("var result = "+dataValue); 
				if(result.RESULT == "true"){
					
					$.ajax({ 
						url: "<%=_path%>/salesmanVirtual/queryEmployCodeHR.do?employCode="+$('#employCode').val(),
						type:"post",
						async: false, 
						dataType: "html",
						success: function(data){
							if(data == "true"){
								$("#addVirtualForm").submit();
							}
							else{
								$.omMessageBox.confirm({
					                title:'确认操作',
					                content:'您输入的工号在HR中已存在，【确定】后将删除HR中该人员的信息，是否确定删除?',
					                onClose:function(flag){
					                    if(flag){
					                    	$("#addVirtualForm").submit();
					                    }
					                }
					            });
							}
							}
					}); 
					
				}else{
					if(result.TYPE == 0){
						$.omMessageBox.alert({
			 	            content: '该工号在非HR【销售助理】人员中已经存在，请重新输入！'
			 	        });
			 			return false;
					}else{
						$.omMessageBox.alert({
			 	            content: '该工号在非HR【独立考核的非HR人员】人员中已经存在，请重新输入！'
			 	        });
			 			return false;
					}
				}
				}
		}); 
	}
	
   /* 	$("#addVirtualForm").submit(); */
   <%-- 	
   //校验身份证号码是否存在
	$.ajax({ 
		url: "<%=_path%>/salesmanVirtual/queryCertiryNoByCount.do?certiryNo="+$('#certiryNo').val(),
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			if(data == "true")
				$("#addVirtualForm").submit();
			else
				remote.showErrors({"certiryNoformMap": "该身份证对应的人员已经存在，请确认！"});
			}
	}); 
	--%>
}
function cancel(){
	window.location.href = "virtual.jsp";
}

function testFunc(){
	var employCode = $("#employCode").val();
	$.ajax({
		url: "<%=_path%>/salesmanVirtual/queryVirtualName.do?employCode="+employCode,
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			var jsonStr = $.parseJSON(data);
			var employName = jsonStr.employName;
			if(typeof(employName)=="undefined"){
				$.omMessageBox.alert({
					   type : 'error',
			           content:'未找到对应姓名，请核对工号！！',
				    });
			}
			$("#cname").val(jsonStr.employName);
		}
	});
}
</script>
</head>
<body>
	<table class="navi-no-tab">
		<tr><td>销售助理新增</td></tr>
	</table>
	<div>
		<fieldSet>
		<legend>销售助理信息</legend>
			<form id="addVirtualForm">
				<table style="padding-left:30px;">
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">人员分类：</span></td>
						<td><input class="sele" name="formMap['salesmanType']" id="salesmanType" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">核心工号：</span></td>
						<td><input name="formMap['employCode']"  id="employCode" onblur="testFunc()"/><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">人员姓名：</span></td>
						<td><input name="formMap['cname']"  id="cname"  readonly= "true"/><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">二级机构：</span></td>
						<td><input class="sele" name="formMap['parentDept']"  id="parentDept" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">三级机构：</span></td>
						<td><input class="sele" name="formMap['deptName']" id="deptName"  /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">四级单位：</span></td>
						<td><input class="sele" name="formMap['deptMarket']"  id="deptMarket" /><span style="color:red">*</span>
								<input name="formMap['deptCode']"  id="deptCode"  type="hidden" />
						</td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">身份证号：</span></td>
						<td><input name="formMap['certiryNo']"  id="certiryNo"   value="111111111111111111"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right">出生日期：</td>
						<td><input class="sele" name="formMap['birthday']" id="birthday"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<!-- <td style="padding-left:30px" align="right">入职时间：</td>
						<td><input class="sele" name="formMap['enterDate']" id="enterDate"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td> -->
					</tr>
					<!-- <tr>
						<td style="padding-left:30px" align="right">结束时间：</td>
						<td><input class="sele" type="text" name="formMap['endDate']" id="endDate" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right">对应HR人员姓名：</td>
						<td><input class="sele" name="formMap['salesmanCname']" id="salesmanCname"/></td>
						<td><span class="errorImg" id="salesmanCnameImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right">对应HR人员代码：</td>
						<td><input name="formMap['salesmanCode']"  id="salesmanCode" readonly="readonly" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr> -->
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
</body>
</html>