<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
*{padding:0;marging:0}
html, body{ height:100%; margin:0px; padding:0px;}
.om-grid .gird-edit-btn{width:190px;}
.om-grid{border:none;}
input[readonly='readonly']:not(.sele),textarea[readonly='readonly'],input[readonly='true'],textarea[readonly='true']{background-color:#F0F0F0;color:gray;}
input {height:18px;border: 1px solid #A1B9DF;vertical-align: middle;}
input:focus {border: 1px solid #3A76C2;}
.fontClass{font-size:12px;font-family: 微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun;}
.deptDropListTree {height:250px;width:151px;border: 1px solid #9AA3B9;overflow: auto;display: none;position: absolute;background: #FFF;z-index: 4;}
/*校验错误提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error, textarea.error {border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px}
.navi-tab{border: solid #d0d0d0 1px; width: 100%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px;}
.navi-no-tab{border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<title>远程出单点新增</title>
<%
String channelCode = request.getParameter("channelCode");
String mediumCname = request.getParameter("mediumCname");
String deptName = request.getParameter("deptName");
String nodeCode = request.getParameter("nodeCode");
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var mediumCname = '<%=mediumCname%>';
var deptName = '<%=deptName%>';
var nodeCode = '<%=nodeCode%>';

var currentRowData;
var salesmanData = '';
var index;
var baseData = '';
var userDptCde = '';
var saveFlagAccount = true;
var saveFlagMaintain = true;

var deptCode = ''; //经办部门
/* ************************************function()初始化 start********************************************** */
$(function(){
	
	$("#baseInfo").find("input").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	$("#channelCode").css({"background-color":"#fff"});
	
	//给该隐藏域赋值，为查询远程出单账号信息和相关维护人提供数据（外键）
	$('#nodeCode_fk').val(nodeCode);
	
	//初始化出单点列表按钮菜单
	$('#accountButtonbar').omButtonbar({
           	btns : [{label:"新增",
            		     id:"accountAddButton" ,
            		     icons : {left : '<%=_path%>/images/add.png'},
            	 		 onClick:function(){
            	 			deptCode = $("#deptCode").val();
            	 			if(deptCode == null || deptCode == ""){
            	 				$.omMessageBox.alert({
            	 		 	        content:'请先选择出单点所属的代理机构',
            	 		 	        onClose:function(value){
            	 		 	        	return false;
            	 		 	        }
        	 		 	        });
            	 			}else{
            	 				$('#accountTables').omGrid("insertRow",0);
            	 			}
           	 			 }
           			},
           			{separtor:true},
           	        {label:"删除",
           	        	id:"accountDelButton",
           	        	icons : {left : '<%=_path%>/images/remove.png'},
           		     	//disabled : true,
           	        	onClick:function(){
           	        		var dels = $('#accountTables').omGrid('getSelections');
          	            	if(dels.length != 1 ){
          	            		$.omMessageBox.alert({
            	 		 	        content:'请选择一条记录操作',
            	 		 	        onClose:function(value){
            	 		 	        	return false;
            	 		 	        }
        	 		 	        });
          	            	}else{
               	            	$.omMessageBox.confirm({
         	                       title:'确认删除',
         	                       content:'你确定要删除该记录吗？',
         	                       onClose:function(v){
         	                           if(v){
         	                        	  $('#accountTables').omGrid('deleteRow',dels[0]);
         	                           }
         	                       }
         	               		});
          	            	}
           	        	}
           	        }
           	]
    });

	//是否我司员工下拉框
	var isOwnStaffOptions = {
   		    dataSource: [{text:"请选择", value:"9"}, {text:"是" , value:"1"}, {text:"否", value:"0"}],
   		    editable: false,
	   		onValueChange: function(target, newValue, oldValue, event) {
	   			//初始化出单员选择框
				$("#issuingerCode").omCombo("setData",[]);
				//初始化出单员工号文本框
				$("input[name='employCode']").val("");
				//员工类型
			    $("#issuingerCode").omCombo({
					dataSource:"<%=_path%>/mediumNode/querySalesmanEmpCode.do?deptCode="+deptCode+"&salesmanType="+newValue+"&roadom="+Math.random(),
		   		    editable:false,
					//filterStrategy:'anywhere',
					onValueChange : function(target, newValue, oldValue, event) {
						$("input[name='employCode']").val(newValue);
						$("input[name='account']").val(newValue);
					},
					onSuccess:function(data, textStatus, event){
						salesmanData = eval(data);
		            }
				});
			}
    };
	
	//初始化出单账号信息列表
	$('#accountTables').omGrid({
         limit: 0,
         height: 160,
 		 singleSelect: true,
 		 showIndex: true,
         colModel:[{header:"是否我司员工",name:"isOwnStaff",width:100,align:'center',editor:{rules:["required",true,"此项必选"],type:"omCombo",name:"isOwnStaff",options:isOwnStaffOptions},renderer:isOwnStaffRenderer},
                   {header:"出单员",name:"issuingerCode",width:100,align:'center',editor:{type:"omCombo", name:"issuingerCode"},renderer:issuingerCodeRenderer},
                   {header:"工号",name:"employCode",width:100,align:'center'},
                   {header:"出单账号",name:"account",width:150,align:'center',editor:{type:"text",name:"account",editable:true}},
                   {header:"vpn账号",name:"vpnNo",width:150, align:'center',editor:{type:"text",name:"vpnNo",rules:["required",true,"vpn账号不能为空"],editable:true}},
                   {header:"设立日期",name:"setDate",width:120, align:'center',editor:{type:"omCalendar",name:"setDate",rules:[["required",true,"设立日期必选"],["isDate",true]],editable:true}},
                   {header:"备注1",name:"remark1",width:150,editor:{type:"text",name:"remark1"}},
                   {header:"备注2",name:"remark2",width:150,editor:{type:"text",name:"remark2"}}],
			dataSource : "<%=_path%>/mediumNode/queryChannelMediumNodeAccount.do?"+$("#channelMaintainFrm").serialize(),
		    onBeforeEdit:function(rowIndex , rowData){
		         index = rowIndex;
		         saveFlagAccount = false;
		    },
			onAfterEdit:function(rowIndex , rowData){
				 currentRowData = rowData;
		         if(rowData.employCode == '' || rowData.employCode == 'undefined' || rowData.employCode == undefined){
		        	 $.omMessageBox.alert({
		        		 type:'warning',
 	 		 	         content:'出单员,工号不能为空,请选择出单员带出工号！'
	 		 	    });
		         	$('#accountTables').omGrid("editRow" , rowIndex);
		         	saveFlagAccount = false;
		         } else {
    		        saveFlagAccount = true;
	       		 }
		    },
		    onCancelEdit:function(){
		    	 saveFlagAccount = true;  
		    }
    });

	//显示是否我司员工
	function isOwnStaffRenderer(value){
        if("1" === value){
            return "<span>是</span>";
        }else if("0" === value){
            return "<span>否</span>";
        }else{
            return "";
        }
    }

	//显示出单员姓名
	function issuingerCodeRenderer(value){
		if(salesmanData != '')
		for(var i=0; i<salesmanData.length; i++){
	        if(salesmanData[i].value === $("input[name='employCode']").val()){
	            return "<span>"+salesmanData[i].text+"</span>";
	        }
		}
	}

	//初始化维护人列表按钮菜单
	$('#buttonbar').omButtonbar({
           	btns : [{label:"新增",
            		     id:"addButton" ,
            		     icons : {left : '<%=_path%>/images/add.png'},
            	 		 onClick:function(){
	                       deptCode = $("#deptCode").val();
	                       if(deptCode == null || deptCode == ""){
	                           $.omMessageBox.alert({
	                               content:'请先选择出单点所属的代理机构',
	                               onClose:function(value){
	                                   return false;
	                               }
	                           });
	                       }else{
	            	 			$('#maintainTables').omGrid("insertRow",0,{businessScale : 100});
	                       }
	                    }
           			},
           			{separtor:true},
           	        {label:"删除",
           	        	id:"delButton",
           	        	icons : {left : '<%=_path%>/images/remove.png'},
           	        	onClick:function(){
           	        		var dels = $('#maintainTables').omGrid('getSelections');
          	            	if(dels.length != 1 ){
          	            		$.omMessageBox.alert({
            	 		 	        content:'请选择一条记录操作',
            	 		 	        onClose:function(value){
            	 		 	        	return false;
            	 		 	        }
        	 		 	        });
          	            	}else{
               	            	$.omMessageBox.confirm({
          	                       title:'确认删除',
          	                       content:'你确定要删除该记录吗？',
          	                       onClose:function(v){
          	                           if(v){
          	                        	 	$('#maintainTables').omGrid('deleteRow',dels[0]);
          	                           }
          	                       }
          	               		});
          	            	}
           	        	}
           	        }
           	]
    });
	
	//初始化维护人信息列表
	var salesmanCnameOptions = {
   		    dataSource : "<%=_path%>/mediumNode/queryDeptSalesman.do?deptCode="+deptCode,
   		    editable: true,
			filterStrategy : 'anywhere',
			onValueChange : function(target, newValue, oldValue, event) {
				//给维护人代码赋值
				$("input[name='maintenCode']").val(newValue);
				//根据维护人代码查询用户电话和邮箱
				Util.post("<%=_path%>/salesman/querySalesmanInfoByCode.do?salesmanCode="+newValue, "", function(data) {
					$("input[name='tel']").val(data[0].tel);
					$("input[name='salesmanCode']").val(data[0].salesmanCode);
				});
			},
			onSuccess:function(data, textStatus, event){
				baseData = eval(data);
            }
    };
	
	var businessScaleOptions = {
			allowDecimals:true,
        	allowNegative:false
	};
	
	//选择代理机构代码和名称
	$("#medium-dialog-model").omDialog({
	     autoOpen:false,
	     width:750,
	     height:465,
	     modal:true,
	     resizable:false,
	     onOpen:function(event) {
	    	$("#mediumIframe").attr("src","<%=_path%>/view/demo/selectChannelCodeIframe.jsp");
	     }
	});
	
	//初始化维护人信息列表
	$('#maintainTables').omGrid({
         limit:0,
         height : 160,
 		 singleSelect : true,
 		 showIndex : true,
         colModel : [ {header:"维护人姓名",name:"salesmanCname",width:150, align:'center',editor:{rules:["required",true,"维护人必选"],type:"omCombo",name:"salesmanCname",options:salesmanCnameOptions},renderer:salesmanCnameRenderer},
                      {header:"维护人代码",name:"maintenCode",width:200,align:'center'},
                  	  {header:"电话",name:"tel",width:150,align:'center'},
                   	  {header:"邮箱",name:"salesmanCode",width:200,align:'center'},
                  	  {header:"业务占比(%)",name:"businessScale",width:100,align:'center',editor:{rules:[["required",true,"业务占比必填"],["max",100,"您确定没填错？"],["min",0,"您确定没填错？"]],editable:true,type:"omNumberField",options:businessScaleOptions}}],
			dataSource : "<%=_path%>/channelMaintain/queryChannelMaintain.do?"+$("#channelMaintainFrm").serialize(),
  		    onBeforeEdit:function(rowIndex , rowData){
  		         index = rowIndex;
  		         saveFlagMaintain = false;
  		    },
			onAfterEdit:function(rowIndex , rowData){
		         if(rowData.maintenCode == '' || rowData.maintenCode == 'undefined' || rowData.maintenCode == undefined){
		        	 $.omMessageBox.alert({
		        		 type:'warning',
	 		 	        content:'维护人错误,请重新选择'
	 		 	    });
		         	$('#maintainTables').omGrid("editRow" , rowIndex);
		         	saveFlagMaintain = false;
		         } else {
    		        saveFlagMaintain = true;
	       		 }
		    },
		    onCancelEdit:function(){
		    	saveFlagMaintain = true;
  		    }
    });
	
	function salesmanCnameRenderer(value){
		if(baseData != '')
		for(var i = 0;i < baseData.length;i++){
	        if(baseData[i].value === value){
	            return "<span>"+baseData[i].text+"</span>";
	        }
		}
	}
	
	//初始化页面保存、重置、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-reset").omButton({icons : {left : '<%=_path%>/images/clear.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});

	initValidate();
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
    
    $.validator.addMethod("nodeCodeLength", function(value) {
    	var nodeCodeLength = value.length;
        return nodeCodeLength == 10;
 	}, '远程出单点代码长度为10');
	
});
/* ************************************function()初始化 end********************************************** */

//定义校验规则
var mediumNodeRule = {
	channelCode:{
		required : true
	},
	mediumNodeName:{
		required : true,
		maxlength : 32
	},
	targetPremium:{
		required:true,
		number:true
	},
	address:{
		required:true,
		maxlength : 32
	},
	remote:{
		required:true
	},
	tableName:{
		required:true,
		maxlength : 50
	},
	account:{
		required:true,
		maxlength : 50
	},
	contact:{
		required:true,
		maxlength : 25
	},
	mobile:{
		isMobilePhone : true,
        required : true
	},
	phone:{
		isTelephone : true,
        required : true
	},
	email:{
		required : true,
		email : true
	}
};

//定义校验的显示信息
var mediumNodeMessages = {
	channelCode:{
		required:'请选择出单点的代理机构'
	},
	mediumNodeName:{
		required:'远程出单点名称不能为空',
		maxlength:'远程出单点名称最长32位'
	},
	targetPremium:{
		required:'保费目标不能为空',
		number:'必须是数字类型'
	},
	address:{
		required:'地址不能为空',
		maxlength:'地址最长32位'
	},
	remote:{
		required:'是否远程出单点必选'
	},
	tableName:{
		required:'出单点名称不能为空',
		maxlength:'出单点名称最长50位'
	},
	account:{
		required:'出单账号不能为空',
		maxlength:'出单账号最长50位'
	},
	contact:{
		required:'联系人不能为空',
		maxlength:'联系人最长25位'
	},
	mobile:{
        required:'手机号不能为空'
	},
	phone:{
        required:'电话号码不能为空'
	},
	email:{
		required:'邮箱不能为空',
		email:'邮箱格式不正确'
	}
};

//校验
function initValidate(){
	//验证前修改name为关键字的字段
	$("#mediumNodeName").attr("name","mediumNodeName");
	//$("#tableName").attr("name","tableName");
	
	$("#baseInfo").validate({
		rules: mediumNodeRule,
		messages: mediumNodeMessages,
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
        	//验证完之后将修改过的name属性还原
        	$("#mediumNodeName").attr("name","nodeName");        	
			//出单账号信息
        	var accountJsonData = JSON.stringify($('#accountTables').omGrid('getData'));
        	$('#jsonDataStrAccount').val(accountJsonData);
			//维护人信息
        	var jsonData = JSON.stringify($('#maintainTables').omGrid('getData'));
        	var jsonRows = eval("["+jsonData+"]")[0].rows;
        	var baseJsonStr;
        	if(jsonRows.length > 0){
        		baseJsonStr = "[";
        		for(var i = 0;i < jsonRows.length;i++){
        			var maintenCode = jsonRows[i].maintenCode;
        			var businessScale = jsonRows[i].businessScale;
        			//新增维护人
        			baseJsonStr += "{\"maintenCode\":\""+maintenCode+"\",\"businessScale\":\""+businessScale+"\"},";
        		}
        		var index = baseJsonStr.lastIndexOf(",");
        		baseJsonStr = baseJsonStr.substring(0, index);
        		baseJsonStr += "]";
        	}else{
        		baseJsonStr = "[]";
        	}
        	$('#jsonDataStrMaintain').val(baseJsonStr);

        	$.omMessageBox.waiting({
                title:'请等待',
                content:'服务器正在处理请求...'
            });
        	
        	Util.post("<%=_path%>/mediumNode/saveMediumNode.do", $("#baseInfo").serialize(), function(data) {
       			$.omMessageBox.waiting('close');
       			if (data.flag == '1'){
       				$.omMessageBox.alert({
          					type:'success',
                            title:'成功',
      	 		 	        content:'合作机构远程出单点保存成功',
      	 		 	        onClose:function(value){
   		        			//保存成功后跳转回远程出单点维护列表页面
   		        			window.location.href = "mediumNode.jsp?flag=1&channelCode="+channelCode;
      	 		 	        	return true;
      	 		 	        }
    		 	        });
       			} else {
       				$.omMessageBox.alert({
          				   type:'error',
                           title:'失败',
      	 		 	        content:'合作机构远程出单点保存失败:<br/>'+data.msg
    		 	        });
       			}
       				
            });
        }
    });
}

//填充数据（选择代理机构）
function fillMediumBackAndCloseDialog(rowData) {
	  if(rowData.channelCode == '--'){
		  $("#channelCode").val("无");
	  } else {
	  	  $("#channelCode").val(rowData.channelCode);
	  	  $("#mediumCname").val(rowData.mediumCname);
	  	  $("#deptCode").val(rowData.deptCode);
	  	  $("#deptCname").val(rowData.deptCode+"-"+rowData.deptCname);
	  }
	  $("#medium-dialog-model").omDialog('close');
	  $("#channelCode").focus();
}

//保存远程出单点操作
function save(){
	//if出单账号信息处于编辑状态
	if(!saveFlagAccount){
		$.omMessageBox.alert({
      		 type:'warning',
	 	     content:'出单账号信息处于编辑状态，请先确定或取消之后再保存！'
	 	});
	 	return;
    }
    
    //维护人信息处于编辑状态
	if(!saveFlagMaintain){
		$.omMessageBox.alert({
     		 type:'warning',
	 	     content:'维护人信息处于编辑状态，请先确定或取消之后再保存！'
	 	});
		return;
    }

    //
	var jsonData = JSON.stringify($('#maintainTables').omGrid('getData'));
	var jsonRows = eval("["+jsonData+"]")[0].rows;
	var sumValue = 0;
	if(jsonRows.length > 0){
		for(var i = 0;i < jsonRows.length;i++){
			var businessScale = jsonRows[i].businessScale;
			sumValue += businessScale;
		}
		if(sumValue != 100){
			$.omMessageBox.alert({
		 	        content:'业务占比总和不等于100,请重新编辑各维护人员的业务占比!',
		 	        onClose:function(value){
		 	        	return false;
		 	        }
	 	        });
			return false;
		}
	}
	
	$("#baseInfo").submit();
}

//选择代理机构编码和代理机构名称
function selParentMedium(){
  $("#medium-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
}

//取消操作
function cancel(){
	window.location.href = "mediumNode.jsp?flag=1&channelCode="+channelCode;
}

//重置
function reset(){
	window.location.href = "mediumNodeAddNew.jsp";
}
</script>
</head>
<body>
	<div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
	<div>
		<table class="navi-no-tab">
			<tr><td>出单点新增</td></tr>
		</table>
	</div>
	<div>
		<fieldSet>
			<legend>出单点信息</legend>
			<form id="baseInfo">
			    <!--所有新增出单账号信息封装json字符串 --> 
				<input type="hidden" name="jsonDataStrAccount" id="jsonDataStrAccount" />
				<!--所有新增维护人信息封装json字符串 --> 
				<input type="hidden" name="jsonDataStrMaintain" id="jsonDataStrMaintain" />
				<!--隐藏经办部门代码 -->
				<input type="hidden" name="deptCode" id="deptCode"/>
				<table class="fontClass" style="line-height: 25px;">
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">代理机构代码：</span></td>
						<td><input type="text" name="channelCode" id="channelCode" readonly="readonly" onclick="selParentMedium();" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">代理机构名称：</span></td>
						<td><input type="text" name="mediumCname" id="mediumCname" readonly="readonly" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
						<td><input type="text" name="deptCname" id="deptCname" readonly="readonly" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">远程出单点名称：</span></td>
						<td><input type="text" name="nodeName" id="mediumNodeName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">保费目标(万元)：</span></td>
						<td><input type="text" name="targetPremium" id="targetPremium" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">出单点地址：</span></td>
						<td><input type="text" name="address" id="address" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">联系人：</span></td>
						<td><input type="text" name="contact" id="contact" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">手机：</span></td>
						<td><input type="text" name="mobile" id="mobile" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">电话号码：</span></td>
						<td><input type="text" name="phone" id="phone" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">邮箱：</span></td>
						<td><input type="text" name="email" id="email" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
				</table>
			</form>
		</fieldSet>
	</div>
	<!-- 出单账号信息 -->
	<div>
		<fieldSet>
			<legend>出单点账号</legend>
			<div id="accountButtonbar" style="border-style:none none solid none;"></div>
			<table id="accountTables"></table>
		</fieldSet>
	</div>
	<!-- 维护人列表 -->
	<div>
		<fieldSet>
			<legend>维护人</legend>
			<div id="buttonbar" style="border-style:none none solid none;"></div>
			<table id="maintainTables"></table>
			<form id="channelMaintainFrm">
				<input type="hidden" name="formMap['nodeCode']" id="nodeCode_fk" value="" />
				<input type="hidden" name="formMap['queryFlag']" value="no" />
			</form>
		</fieldSet>
	</div>
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-left:30px;padding-top:10px" align="center">
				<a class="fontClass" id="button-save" onclick="save()">保存</a>
				<a class="fontClass" id="button-reset" onclick="reset()">清空</a>
				<a class="fontClass" id="button-cancel" onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
	
	<div id="medium-dialog-model" title="选择代理机构">
		<iframe id="mediumIframe" frameborder="0" style="width: 100%; height: 99%; height: 100%; overflow-y:hidden; " src="about:blank"></iframe>
	</div>
	
</body>
</html>