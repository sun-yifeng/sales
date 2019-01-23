<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<% String virtualId = request.getParameter("virtualId"); %>
<% String employCode = request.getParameter("employCode");%>
<% String deptCode = request.getParameter("deptCode");%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>销售助理修改</title>
<style type="text/css">
html,body{height:100%;margin:0;padding:0;overflow:auto;}
body{font-size:12px}
.om-button{font-size:12px}
#nav_cont{width:580px;margin-left:auto;margin-right:auto}
input{border:1px solid #a1b9df;vertical-align:middle;width:151px}
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
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style> 
<script type="text/javascript">
var virtualId = '<%=virtualId%>';
var employCode = '<%=employCode%>';
var salemanVritual;
var dptCode = '<%=deptCode%>';

//
$(function(){
	$(".sele").css({"width":"130px"});
	/******初始化tab标签页*********/
	$('#make-tab').omTabs({
	    closable : false
    });
	
	//人员类别
	$('#salesmanType').omCombo({
        dataSource : <%=Constant.getCombo("salesmanType")%>,
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
	
	

	//查询详细信息
	Util.post("<%=_path%>/salesmanVirtual/querySalesmanVirtualDetial.do?virtualId="+virtualId, "", function(data) {
		salemanVritual=data;
		if(data.salesmanType != '销售助理'){
			$("#tableDiv").hide();
		}
	    //填充页面
		$("#updateVirtualForm").find("input").each(function(){
			$(this).val(data[$(this).attr("name")]);
		});
		//人员类型
		$('#salesmanType').omCombo({value:data.salesmanType,
			                        disabled : true});
		//对应的HR人员姓名,下拉框
		$('#salesmanCname').omCombo({
			dataSource : "<%=_path%>/salesman/queryNameAndCode.do?deptCode="+data.deptCode,
			 onValueChange : function(target, newValue, oldValue, event) {
					$("#salesmanCode").val(newValue);
			},
	        optionField : function(data, index) {
	            return data.text;
			},
			value : data.userCode,
	        editable : false,
	        width : '150px'
	    });
		//出生日期选择框
		$('#birthday').omCalendar({
			dateFormat : "yy-mm-dd",
			editable : false
		}); 
		//入职日期选择框
		$('#enterDate').omCalendar({
			dateFormat : "yy-mm-dd",
			editable : false
		}); 
		//结束日期选择框
		$('#endDate').omCalendar({
			dateFormat : "yy-mm-dd",
			editable : false
		});
		
    });
	
	var salesmanCnameOptions = {
   		    dataSource : "<%=_path%>/salesman/queryNameAndCode.do?deptCode="+dptCode,
   		    editable: true,
			filterStrategy : 'anywhere',
			onValueChange : function(target, newValue, oldValue, event) {
				//给维护人代码赋值
				$("input[name='salesCode']").val(newValue);
			},
    };
	
	var dateOptions = {
        	dateFormat:"yy-mm-dd"    
    };
	
	$('#tables').omGrid({
		limit:0,
        height : 200,
		singleSelect : true,
		showIndex : true,
		dataSource : "<%=_path%>/salesmanVirtual/querySalesmanVirtualRecord.do?employCode="+employCode,
        colModel : [ 
                     {header:"销售助理姓名",name:"employName",width:150},
                  	 {header:"销售助理工号" , name:"employCode",width:150},
                  	 {header:"客户经理姓名",name:"salesName",width:150,editor:{rules:["required",true,"此项必选"],type:"omCombo",editable:true,options:salesmanCnameOptions}},
                  	 {header:"客户经理域账户" , name:"salesCode",width:150},
                  	 {header:"挂靠开始时间",name:"bgnDate",width:150,editor:{rules:["required",true,"此项必选"],type:"omCalendar",name:"bgnDate",editable:true,options:dateOptions}},
                  	 {header:"挂靠结束时间",name:"endDate",width:150,editor:{rules:["required",true,"此项必选"],type:"omCalendar",name:"endDate",editable:true,options:dateOptions}}],
       	onAfterEdit:function(rowIndex, rowData){
       		var gridObj = $('#tables').omGrid('getChanges');
       		var jsonArr = (gridObj.insert).concat(gridObj.update);
       		var jsonStr = JSON.stringify(jsonArr,['pkId','deptCode','employName','employCode','salesName','salesCode','bgnDate','endDate']);
       		if(jsonArr.length < 1) return;
       		$("#jsonStr1").val(jsonStr);
       		Util.post(Util.appCxtPath + '/salesmanVirtual/validateDate.do?employCode=' + employCode, $('#updateVirtualForm').serialize(), function(data) {
       			if(data == '1'){
       				$.omMessageBox.alert({
						type:'error',
			 	        content:'挂靠开始时间大于挂靠结束时间，请核实！'
		 	        });
       				return;
       			}else if(data == '2'){
       				$.omMessageBox.alert({
						type:'error',
			 	        content:'挂靠时间有重叠，请核实！'
		 	        });
       				return;
       			}
       		});
		 
       		$.ajax({ url: "<%=_path%>/salesmanVirtual/querySalesmanName.do",
					type:"post",
					async: false,
					data:{salesCode:rowData.salesCode},
					dataType: "json",
					success: function(data){
						$("#tables tr:eq("+rowIndex+") td[abbr=salesName] div").html(data);
					}
			   });
       		
       	}
    });
	
	$('#buttonbar').omButtonbar({
       	btns : [{label:"新增",
        		     id:"addButton" ,
        	 		 onClick:function(){
        	 			$('#tables').omGrid("insertRow",0,{
        	 				deptCode : $("#deptCode").val(),
        	 				employName : $("#cname").val(),
        	 				employCode : $("#employCode").val()
        	 			});
       	 			 }
       			},
       			{separtor:true},
    	        {label:"保存",
       	 		 onClick:function(){
       	 			saveRecord();
      	 		 }
       		    },
       			{separtor:true},
       	        {label:"放弃修改",
       				onClick:function(){
           	 			$("#tables").omGrid("cancelChanges");
          	 		 }
       	        }
       	]
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
    
    $.validator.addMethod("bgnDate", function(value) {
    	alert($("#maxEndDate").val());
        return value > $("#maxEndDate").val();
 	}, '此日期应大于签订日期');
    
});


//定义校验规则
var virtualConferRule = {
	salesmanType:{
 		required : true,
	},
	enterDate:{
		required : true
	}/* ,
	salesmanCname:{
		required : true
	} */
};
//定义校验的显示信息
var virtualConferMessages = {
	salesmanType:{
 		required : '人员类别必选',
	},	
	enterDate:{
		required : '入职时间不能为空'
	}/* ,
	salesmanCname:{
		required : '对应HR人员姓名不能为空'
	} */
};
//校验全局调用
var remote;
//校验
function initValidate(){
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
        	Util.post(
        			"<%=_path%>/salesmanVirtual/updateSalesmanVirtual.do",$("#updateVirtualForm").serialize(), function(data) {
        				if(data=="OK"){
        					//保存成功后跳转回非HR员工管理页
        					$.omMessageBox.alert({
		       					type:'success',
		       	                title:'提示',
		   	 		 	        content:"修改记录成功!",
		   	 		 	        onClose:function(value){
				        			//保存成功后跳转回机构管理主页
				        			window.location.href = "virtual.jsp";
		   	 		 	        	return true;
		   	 		 	        }
 		 	        		});
        					
        				}else{
        					$.omMessageBox.alert({
        						type:'error',
		 		 	            content: '修改记录失败！'
		 		 	        });
        				}
        	    });
        }
    });
}

//判断信息是否更改,如果有变化正常提交。
function changeOrNot(){
	   if (salemanVritual.certiryNo != $("#certiryNo").val()) {
			if (salemanVritual.certiryNo != undefined
					|| $("#certiryNo").val() != '') {
				          return true;
			}
		}
		if (salemanVritual.birthday != $("#birthday").val()) {
			if (salemanVritual.birthday != undefined
					|| $("#birthday").val() != '') {
				
				          return true;
			}
		}
		if (salemanVritual.enterDate != $("#enterDate").val()) {
			if (salemanVritual.enterDate != undefined
					|| $("#enterDate").val() != '') {
				         return true;
			}
		}
		if (salemanVritual.endDate != $("#endDate").val()) {
			if (salemanVritual.endDate != undefined
					|| $("#endDate").val() != '') {
				          return true;
			}
		}
		if (salemanVritual.salesmanCname != $("#salesmanCname").val()) {
			if (salemanVritual.salesmanCname != undefined
					|| $("#salesmanCname").val() != '') {
				          return true;
			}
		}
		if (salemanVritual.salesmanCode != $("#salesmanCode").val()) {
			if (salemanVritual.salesmanCode != undefined
					|| $("#salesmanCode").val() != '') {
				          return true;
			}
		}
		return false;
    }
	//保存非HR员工修改操作
	function save() {
		
		//出生日期要小于入职时间
		if($('#enterDate').val()<$('#birthday').val()&&$('#birthday').val()!=''){
			$.omMessageBox.alert({
	 	            content: '出生日期要小于入职时间!'
	 	        });
			return;
		}
		//结束时间要大于入职时间
		if($('#endDate').val()<$('#enterDate').val()&&$('#endDate').val()!=''){
			$.omMessageBox.alert({
	 	            content: '结束时间要大于入职时间!'
	 	        });
			return;
		}
        var tmpType = $('#salesmanType').val();
		if (tmpType == '远程出单点出单人员') {
			//判断是否更改信息，有更改提交否则提示。
			if (changeOrNot()) {
				$('#salesmanType').val("1");
				$("#updateVirtualForm").submit();
			}
			else{
				  $.omMessageBox.alert({
 		 	            content: '内容修改后才能提交！'
 		 	        });
			}
		}else if(tmpType == '独立考核的非HR人员'){
			if (changeOrNot()) {
				$('#salesmanType').val("2");
				$("#updateVirtualForm").submit();
			}
			else{
				  $.omMessageBox.alert({
 		 	            content: '内容修改后才能提交！'
 		 	        });
			}
		}else if (tmpType == '销售助理') {
					
			//1、如果只修改结束时间不修改对应HR人员，则允许操作
			if (salemanVritual.endDate != $("#endDate").val()) {
				if (salemanVritual.endDate != undefined|| $("#endDate").val() != '') {
					//判断是否修改了HR人员
					if (salemanVritual.salesmanCname == $("#salesmanCname").val()) {
						$('#salesmanType').val("0");
						$("#updateVirtualForm").submit();
						return;
					}
				}
		   }
		   //2、如果原‘对应HR人员姓名’为空，即该销售助理从未配置过对应的客户经理，
		   //   尚无对应关系，此时‘对应HR人员姓名’、开始时间、结束时间的修改无限制，
		   //   可以任意修改，此时的修改，可以理解为第一次产生对应记录；	
		   if($("#endDate").val() == ''){
			   $('#salesmanType').val("0");	
			   $("#updateVirtualForm").submit();
				return;
		   }
			
			//有修改过才能提交
			if (changeOrNot()){
				$('#salesmanType').val("0");	
				$("#updateVirtualForm").submit();
	         }else{
				 $.omMessageBox.alert({
			 	     content: '内容修改后才能提交！'
			 	 });
			  }
			}   
}
	
//保存销售人员异动记录
function saveRecord(){
	var gridObj = $('#tables').omGrid('getChanges');
	var jsonArr = (gridObj.insert).concat(gridObj.update);
	var jsonStr = JSON.stringify(jsonArr,['pkId','deptCode','employName','employCode','salesCode','bgnDate','endDate']);
	if(jsonArr.length < 1) return;
	$("#jsonStr").val(jsonStr);
	
	Util.post(Util.appCxtPath + '/salesmanVirtual/validateDate.do', $('#updateVirtualForm').serialize(), function(data) {
			if(data == '1'){
				$.omMessageBox.alert({
					type:'error',
		 	        content:'挂靠开始时间大于挂靠结束时间，请核实！'
 	        	});
				return;
			}else if(data == '2'){
				$.omMessageBox.alert({
					type:'error',
		 	        content:'挂靠时间有重叠，请核实！'
 	        	});
				return;
			}else{
				Util.post(Util.appCxtPath + '/salesmanVirtual/updateSalesmanVirtualRecord.do', $('#updateVirtualForm').serialize(), function(data) {
					$.omMessageBox.alert({
				        type:'success',
				        title:'提示',
				        content:'保存成功',
				        onClose:function(v){
						    $('#tables').omGrid('reload');
				         }
			       });
				});
			}
	});
}

	
//
function cancel(){
	window.location.href = "virtual.jsp";
}
</script>
</head>
<body>
    <div id="saleUserVirtual">
	<table class="navi-no-tab">
	    <tr><td>销售助理修改</td></tr>
	</table>
	<div>
		<fieldSet>
		<legend>销售助理修改</legend>	
			<form id="updateVirtualForm">
				<input type="hidden" name="formMap['jsonStr']" id="jsonStr" value="" />
				<input type="hidden" name="formMap['jsonStr1']" id="jsonStr1" value="" />
			    <input type="hidden" name="virtualId"  id="virtualId"  value=""/>
				<table style="padding-left: 30px;">
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">人员类别：</span></td>
							<td><input class="sele" name="salesmanType" id="salesmanType"/><span style="color:red">*</span></td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left: 30px" align="right"><span class="label">人员姓名：</span></td>
							<td><input name="cname" id="cname"  readonly="readonly"/></td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">核心工号：</span></td>
							<td><input name="employCode"  id="employCode"   readonly="readonly"/></td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left: 30px" align="right"><span class="label">二级机构：</span></td>
							<td><input name="deptNameTwo" id="deptNameTwo" readonly="readonly"/></td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left: 30px" align="right"><span class="label">三级机构：</span></td>
							<td><input name="deptNameThree" id="deptNameThree" readonly="readonly"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left: 30px" align="right"><span class="label">四级单位：</span></td>
							<td><input name="deptNameFour"  id="deptNameFour" readonly="readonly"/>
							<input name="deptCode"  id="deptCode"  style="display: none;"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left: 30px" align="right"><span class="label">身份证号：</span></td>
							<td><input type="text"  name="certiryNo" id="certiryNo" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right">出生日期：</td>
							<td><input class="sele" type="text" name="birthday" id="birthday"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
				</table>
			</form>
		</fieldSet>
	</div>
	<div id="tableDiv">
		<fieldSet>
			<legend>销售助理挂靠记录</legend>
			<div id="buttonbar"></div>
			<table id="tables"></table>
			<form id="salesmanEmployFrm">
				<input type="hidden" name="formMap['salesmanCode']" id ="salesmanCode_fk2" value="" />
			</form>
		</fieldSet>
	</div>
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-top:10px" align="center">
				<a id="button-save" onclick="save()">保存</a>
				<a id="button-cancel"  onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
    </div>
</body>
</html>