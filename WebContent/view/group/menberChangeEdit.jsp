<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String salesmanCode = request.getParameter("salesmanCode"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>人员异动</title>
<style type="text/css">
html, body{ height:100%; margin:0px; padding:0px;}
body {font-size:12px;}
.om-button {font-size:12px;}
#nav_cont{width:580px;margin-left:auto;margin-right:auto;}
input {border:1px solid #A1B9DF; vertical-align:middle;width:151px;}
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
.navi-no-tab{border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<script type="text/javascript">
var salesmanCode = '<%=salesmanCode%>';
var menberChange;
$(function(){
	$(".sele").css({"width":"130px"});
	//获取CODE用于查询详细数据
	$('#salesmanCode_fk1').val(salesmanCode);
	$('#salesmanCode_fk2').val(salesmanCode);
	$('#salesmanCode').val(salesmanCode);
	
	//异动生效时间
	var date = new Date();
	date.setMonth(date.getMonth()+1);
	date.setDate(1);
	$('#validDate').omCalendar({
		dateFormat : "yy-mm-dd H:i:s",
		editable : false,
		disabledFn : disFn,
		date : new Date(date.getFullYear(), date.getMonth(), 1)
	}); 
	$("#validDate").val($.omCalendar.formatDate(date,'yy-mm-dd H:i:s'));
	
	/******初始化tab标签页*********/
	$('#make-tab').omTabs({
	    closable : false
    });
	//查询单条数据详情
	Util.post(
		"<%=_path%>/salesman/querySalesmansByLastDept.do",$("#salesmanCodeFrm").serialize(), function(data) {
			
			menberChange=data[0];
			$("#moveAfterFrm").find(":text").each(function(){
				$(this).val(data[0][$(this).attr("name")]);
			});
			$('#parentDept').val(data[0].parentDept);
			//初始化机构
			$('#firstDeptName').val(data[0].parentDept);
			$('#secondDeptName').val(data[0].deptName);
			$('#threeDeptName').val(data[0].deptMarket);
			$('#groupNames').val(data[0].groupName);
			
			//异动后
			//加载三级机构
			$('#deptName').omCombo({
				dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[0].parentDeptCode,
				onValueChange : function(target, newValue, oldValue, event) {
		            var currentParentDept = $('#deptName').omCombo('value');
		            if(currentParentDept != ''){
			            $('#deptMarket').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+newValue+"&deptCode="+data[0].deptCode);
		            }else{
			        	$('#deptMarket').omCombo({
			                 dataSource : [ {text : '请选择', value : ''} ]
			            });
		            }
		            $('#groupName').omCombo('setData',[]);
				},
				valueField : 'value',
				inputField : 'text',
				filterStrategy : 'anywhere'
			});
			//加载四级单位
			$('#deptMarket').omCombo({
				onSuccess  : function(data, textStatus, event){
		    		if(data.length == 2){
		    			$('#deptMarket').omCombo({
		    				value : data[1].value
		    				//readOnly : true
		    			});
		        	}
		        },
				onValueChange : function(target, newValue, oldValue, event) {
		            var currentParentDept = $('#deptMarket').omCombo('value');
		            $('#deptCode').val(newValue);
		            $('#deptCode1').val(newValue);
		            if(currentParentDept != ''){
			            $('#groupName').val('').omCombo('setData', "<%=_path%>/groupMain/queryDeptGroup.do?deptCode="+newValue);
		            }else{
			        	$('#groupName').omCombo({
			                 dataSource : [ {text : '请选择', value : ''} ]
			            });
		            }
				},
				valueField : 'value',
				inputField : 'text',
				filterStrategy : 'anywhere'
		   });
			//初始化团队名称
			$('#groupName').omCombo({
				onValueChange : function(target, newValue, oldValue, event) {
					$("#groupCode").val(newValue);
					$("#groupCode1").val(newValue);
				},
				valueField : 'value',
				inputField : 'text',
				filterStrategy : 'anywhere'
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

    /* $.validator.addMethod("requiredDate", function(value) {
    	var date = new Date();
    	var nowDate = $.omCalendar.formatDate(date,'yy-mm-dd');
        return value > nowDate;
 	}, '生效日期应大于当前日期'); */
});

//定义校验规则
var virtualConferRule = {
	/* changeDateformMap:{
			required : true
	}, */
	validDateformMap:{
		required : true
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
	groupNameformMap:{
		required : true
	}
};

//定义校验的显示信息
var virtualConferMessages = {
	/* changeDateformMap:{
		required : '异动时间不能为空'
	}, */
	validDateformMap:{
		required : '异动生效时间不能为空'
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
	groupNameformMap:{
		required : '所属团队不能为空'
	}
};

//校验
function initValidate(){
	
	//将name属性修改进行验证
	$("#moveBeforeFrms").find("input[name^='formMap']").each(function(){
		$(this).attr("name",$(this).attr("id")+"formMap");
	});
	
	$("#moveBeforeFrms").validate({
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
         	$("#moveBeforeFrms").find("input[name$='formMap']").each(function(){
         		$(this).attr("name","formMap['"+$(this).attr("id")+"']");
         	});
        	
        	//获取原来的人员详细，用于更新人员不能为空的约束
        	$("#salesmanCname").val($("#salesmanCnames").val());
        	$("#sex").val($("#sexs").val());
        	$("#age").val($("#ages").val());
        	$("#certifyNo").val($("#certifyNos").val());
        	$("#birthday").val($("#birthdays").val());
        	$("#nation").val($("#nations").val());
        	$("#contractDate").val($("#contractDates").val());
        	$("#entryDate").val($("#entryDates").val());
        	$("#regularDate").val($("#regularDates").val());
        	$("#deptExtend").val($("#deptExtends").val());
        	$("#position").val($("#positions").val());
        	$("#fromAddress").val($("#fromAddresss").val());
        	$("#party").val($("#partys").val());
        	$("#degree").val($("#degrees").val());
        	$("#education").val($("#educations").val());
        	$("#magor").val($("#magors").val());
        	$("#status").val($("#statuss").val());
        	$("#salesmanType").val($("#salesmanTypes").val());
        	$("#titleType").val($("#titleTypes").val());
        	$("#title").val($("#titles").val());
        	$("#marry").val($("#marrys").val());
        	$("#businessLine").val($("#businessLines").val());
        	$("#trytou").val($("#trytous").val());
        	$("#evaluate").val($("#evaluates").val());
        	$("#saleRank").val($("#saleRanks").val());
        	
        	//HR人员信息
         	var updateSalesmanFrm = "["+JSON.stringify($("#updateSalesmanFrms").serializeObject())+"]";
         	$('#updateSalesman').val(updateSalesmanFrm);
        	
        	//var moveBeforeFrm = "["+JSON.stringify($("#moveBeforeFrms").serializeObject())+"]";
        	
        	//修改人员异动信息，修改人员信息，新增异动信息，同一方法中实现
        	Util.post("<%=_path%>/groupChangeRecord/updateSalesmanHistoryidong.do",$("#moveBeforeFrms").serialize(),
        			function(data) {
        				//保存成功后跳转回异动管理页
        				window.location.href = "menberChange.jsp";
        		});
        }
    });
}


    
function _stopIt(e){  
        if(e.returnValue){  
            e.returnValue = false ;  
        }  
        if(e.preventDefault ){  
            e.preventDefault();  
        }                 
        return false;  
}  

//保存异动员工操作
function save(){
	//內容修改后才能保存否則無法提交。
   if (changeOrNot()){
		
		$("#moveBeforeFrms").submit();
	}
   else{
		  $.omMessageBox.alert({
	            content: '内容修改后才能提交！'
	        });
	}
}

$.fn.serializeObject = function() {
		     var o = {};
		     var a = this.serializeArray();
		     $.each(a, function() {
		         if (o[this.name]) {
		             if (!o[this.name].push) {
		                 o[this.name] = [ o[this.name] ];
		             }
		             o[this.name].push(this.value || '');
		         } else {
		             o[this.name] = this.value || '';
		         }
		     });
		     return o;
		 } ;

function cancel(){
	window.location.href = "menberChange.jsp";
}

function disFn(date){
	 var nowMiddle = new Date();
	 nowMiddle.setDate(nowMiddle.getDate() - 10);
    if (date < nowMiddle) {
        return false;
    }
}

//判断准备上传的信息是否有修改过
 function changeOrNot(){
	
	if (menberChange.deptCode!=$('#deptCode').val()){
		return true;
	}
	if(menberChange.deptNameCode!=$('#deptName').val()){
		return true;
	}
	if(menberChange.groupCode!=$('#groupCode').val()){
		return true;
	}
	return false;
} 
</script>
</head>
<body>
        <div id="saleGroup">
			<table class="navi-no-tab">
				<tr><td>人员异动</td></tr>
			</table>
			<div>
				<form id="updateSalesmanFrms">
					<!-- 人员异动标识字段，标识执行的SQL不同，需要对机构进行修改 -->
					<input name="flag" id="flag"  value="1" type="hidden" />
					<input  name="salesmanCode" id="salesmanCode_fk1"   type="hidden" />
					<input name="salesmanCname" id="salesmanCname"  type="hidden" />
					<input name="deptCode"  id="deptCode1"  type="hidden" />
					<input name="groupCode" id="groupCode1"  type="hidden" />
					<input name="sex" id="sex"  type="hidden" />
					<input name="age" id="age"  type="hidden" />
					<input name="certifyNo"  id="certifyNo"  type="hidden" />
					<input name="birthday"  id="birthday"  type="hidden" />
					<input name="nation"  id="nation"  type="hidden" />
					<input name="contractDate"  id="contractDate"  type="hidden" />
					<input name="entryDate"  id="entryDate"  type="hidden" />
					<input name="regularDate"  id="regularDate"  type="hidden" />
					<input  name="deptExtend"  id="deptExtend"  type="hidden" />
					<input  name="position"  id="position"  type="hidden" />
					<input  name="fromAddress"  id="fromAddress"  type="hidden" />
					<input  name="party"  id="party"  type="hidden" />
					<input  name="degree"  id="degree"  type="hidden" />
					<input  name="education"  id="education"  type="hidden" />
					<input  name="magor"  id="magor"  type="hidden" />
					<input  name="status"  id="status"  type="hidden" />
					<input  name="salesmanType"  id="salesmanType"  type="hidden" />
					<input  name="titleType"  id="titleType"  type="hidden" />
					<input  name="title"  id="title"  type="hidden" />
					<input  name="marry"  id="marry"  type="hidden" />
					<input  name="businessLine"  id="businessLine"  type="hidden" />
					<input  name="trytou"  id="trytou"  style="display: none;"/>
					<input  name="evaluate"  id="evaluate"  style="display: none;"/>
					<input  name="saleRank"  id="saleRank"  style="display: none;"/>
				</form>
				<form id="salesmanCodeFrm">
					<input type="hidden" name="formMap['salesmanCode']"  id="salesmanCode_fk2"  value=""/>
				</form>
				<fieldSet>
					<legend>异动前</legend>
					<form id="moveAfterFrm">
						<!-- 隐藏人员的详细信息，用于修改人员异动记录 -->
						<input  name="sex" id="sexs"  style="display: none;"/>
						<input  name="age" id="ages"  style="display: none;"/>
						<input  name="certifyNo"  id="certifyNos"  style="display: none;"/>
						<input  name="birthday"  id="birthdays"  style="display: none;"/>
						<input  name="nation"  id="nations"  style="display: none;"/>
						<input  name="contractDate"  id="contractDates"  style="display: none;"/>
						<input  name="entryDate"  id="entryDates"  style="display: none;"/>
						<input  name="regularDate"  id="regularDates"  style="display: none;"/>
						<input  name="deptExtend"  id="deptExtends"  style="display: none;"/>
						<input  name="position"  id="positions"  style="display: none;"/>
						<input  name="fromAddress"  id="fromAddresss"  style="display: none;"/>
						<input  name="party"  id="partys"  style="display: none;"/>
						<input  name="degree"  id="degrees"  style="display: none;"/>
						<input  name="education"  id="educations"  style="display: none;"/>
						<input  name="magor"  id="magors"  style="display: none;"/>
						<input  name="status"  id="statuss"  style="display: none;"/>
						<input  name="salesmanType"  id="salesmanTypes"  style="display: none;"/>
						<input  name="titleType"  id="titleTypes"  style="display: none;"/>
						<input  name="title"  id="titles"  style="display: none;"/>
						<input  name="marry"  id="marrys"  style="display: none;"/>
						<input  name="businessLine"  id="businessLines"  style="display: none;"/>
						<input  name="trytou"  id="trytous"  style="display: none;"/>
						<input  name="evaluate"  id="evaluates"  style="display: none;"/>
						<input  name="saleRank"  id="saleRanks"  style="display: none;"/>
						<table style="padding:0px 0px 5px 35px;">
							<tr>
								<td style="padding-left: 35px;" align="right"><span class="label">姓名：</span></td>
								<td><input type="text" name="salesmanCname" id="salesmanCnames"  readonly="readonly"/></td>
								<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 35px;" align="right"><span class="label">身份证号：</span></td>
								<td><input type="text" name="certifyNo"  id="certifyNo"  readonly="readonly"/></td>
								<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 35px" align="right"><span class="label">二级机构：</span></td>
								<td><input name="firstDeptName"  id="firstDeptName"  readonly="readonly"/>
										<input name="parentDeptCode"  id="parentDeptCode"  style="display: none;" />
								</td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>					
							<tr>
								<td style="padding-left:35px" align="right"><span class="label">三级机构：</span></td>
								<td><input name="secondDeptName"  id="secondDeptName" readonly="readonly"/></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:35px" align="right"><span class="label">四级单位：</span></td>
								<td><input name="threeDeptName"  id="threeDeptName" readonly="readonly"/></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:35px; " align="right"><span class="label">所属团队：</span></td>
								<td><input type="text" name="groupName" id="groupNames"  readonly="readonly"/></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
						</table>
					</form>
				</fieldSet>
			</div>
			<!-- 异动后信息 -->
			<div>
				<fieldSet>
					<legend>异动后</legend>
					<form  id="moveBeforeFrms">
						<input type="hidden" name="updateSalesman" id="updateSalesman" />
						<input type="hidden" name="updateSalesman" id="updateSalesman" />
						<input name="formMap['salesmanCode']" id="salesmanCode"  style="display: none;"/>
						<table style="padding:0px 0px 5px 35px;">
							<tr>
								<td style="padding-left:35px" align="right"><span class="label">二级机构：</span></td>
								<td><input name="formMap['parentDept']" id="parentDept" readonly="readonly"/><span style="color:red">*</span></td>
								<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:35px" align="right"><span class="label">三级机构：</span></td>
								<td><input class="sele" name="formMap['deptName']"  id="deptName" /><span style="color:red">*</span></td>
								<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:20px" align="right"><span class="label">四级单位：</span></td>
								<td>
									<input class="sele" name="formMap['deptMarket']"  id="deptMarket"/><span style="color:red">*</span>
									<input name="formMap['deptCode']"  id="deptCode"  style="display: none;"/>
								</td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:35px; " align="right"><span class="label">所属团队：</span></td>
								<td>
									<input class="sele" name="formMap['groupName']" id="groupName"/><span style="color:red">*</span>
									<input name="formMap['groupCode']" id="groupCode" style="display: none;"/>
								</td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:35px;" align="right">生效时间：</td>
								<td><input class="sele" type="text" name="formMap['validDate']" id="validDate"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:35px;" align="right"><span class="label">备注：</span></td>
								<td colspan="6"><textarea rows="4" cols="50"  name="formMap['remark']"  id="remark"></textarea></td>
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