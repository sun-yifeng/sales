<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
/*页面边距*/
*{padding:0;marging:0}
html, body{ height:100%; margin:0px; padding:0px;}
/*导航标题*/
.navi-tab {border: solid #d0d0d0 1px; width: 100%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px;}
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
/*校验错误提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error, textarea.error {border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px}
.om-grid-btn-border{border-style:none none solid none;}
</style>
<title>远程出单点编辑</title>
<%
String channelCode = request.getParameter("channelCode");
String nodeCode = request.getParameter("nodeCode");
String deptCode = request.getParameter("deptCode");
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var nodeCode = '<%=nodeCode%>';
var deptCode = '<%=deptCode%>';
var userDptCde = '';//用户所属机构
var returnFlag = '1';//浙江IC卡退出标示
var saveFlagAccount = true;
var saveFlagMaintain = true;
/* *************************************初始化function()开始***************************************** */
$(function(){
	$("#baseInfo").find("input").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	$("#targetPremium").css({"width":"118px"});
	
	//给该隐藏域赋值，为查询远程出单账号信息和相关维护人提供数据（外键）
	$('#nodeCode_fk').val(nodeCode);
	
	/*******出单点信息**********/
	Util.post("<%=_path%>/mediumNode/queryMediumNodes.do",$("#channelMaintainFrm").serialize(),function(data) {
		$("#baseInfo").find("input").each(function(){
			$(this).val(data[0][$(this).attr("name")]);
		});
		//按钮权限
		getRemote(data[0].remote);
		//表单校验
		initValidate();
	});
	
	//初始化出单点列表按钮菜单
	$('#accountButtonbar').omButtonbar({
           	btns : [{label:"新增",
            		     id:"accountAddButton" ,
            		     icons : {left : '<%=_path%>/images/add.png'},
            		     //disabled : true,
            	 		 onClick:function(){
            	 			$('#accountTables').omGrid("insertRow",0);
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
            	 		 	        content:'只能选择一条记录！',
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

	//初始化维护人信息列表
	var baseData = '';
	var salesmanData = '';
	var salesmanType = '';
	//销售人员和非HR人员
	Util.post("<%=_path%>/mediumNode/queryAllSalesmans.do?deptCode="+deptCode,"",function(data) {
		salesmanData = eval(data); 
		$('#accountTables').omGrid("setData","<%=_path%>/mediumNode/queryChannelMediumNodeAccount.do?"+$("#channelMaintainFrm").serialize());
	});

	//销售人员
	Util.post("<%=_path%>/mediumNode/queryDeptSalesman.do?deptCode="+deptCode,"",function(data) {
		baseData = eval(data);
		//出单点维护人
		$('#tables').omGrid("setData","<%=_path%>/channelMaintain/queryChannelMaintain.do?"+$("#channelMaintainFrm").serialize());
	});

	//是否我司员工下拉框
	var isOwnStaffOptions = {
   		    dataSource:[{text:"请选择",value:"9"},{text:"是",value:"1"},{text:"否",value:"0"}],
   		    editable:false,
	   	    onValueChange:function(target,newValue,oldValue,event) {
	   	    //清除出单员下拉框
		    $("#issuingerCode").omCombo("setData",[]);
		    //清除工号下拉框
		    $("input[name='employCode']").val("");
	   	    //员工类型
		    $("#issuingerCode").omCombo({
				dataSource:"<%=_path%>/mediumNode/querySalesmanEmpCode.do?deptCode="+deptCode+"&salesmanType="+newValue+"&roadom="+Math.random(),
	   		    editable:false,
				//filterStrategy:'anywhere',
				onValueChange : function(target, newValue, oldValue, event) {
					$("input[name='employCode']").val(newValue);
				},
				onSuccess:function(data, textStatus, event){
					salesmanData = eval(data);
	            }
			});
		}
    };
	
	var index;
	var currentRowData;
	//初始化出单账号信息列表
	$('#accountTables').omGrid({
         limit:0,
         height : 160,
 		 singleSelect : false,
 		 showIndex : false,
         colModel:[{header:"是否我司员工",name:"isOwnStaff",width:100,align:'center',editor:{rules:["required",true,"此项必选"],type:"omCombo",name:"isOwnStaff",options:isOwnStaffOptions},renderer:isOwnStaffRenderer},
                   {header:"出单员",name:"issuingerCode",width:100,align:'center',editor:{type:"omCombo",name:"issuingerCode"},renderer:issuingerCodeRenderer},
                   {header:"工号",name:"employCode",width:100,align:'center'},
                   {header:"出单账号",name:"account",width:150,align:'center',editor:{type:"text",name:"account",rules:["required",true,"出单账号不能为空"],editable:true}},
                   {header:"vpn账号",name:"vpnNo",width:150,align:'center',editor:{type:"text",name:"vpnNo",rules:["required",true,"vpn账号不能为空"],editable:true}},
                   {header:"设立日期",name:"setDate",width:120,align:'center',editor:{type:"omCalendar",name:"setDate",rules:[["required",true,"设立日期必选"],["isDate",true]],editable:true}},
                   {header:"备注1",name:"remark1",width:150,editor:{type:"text", name:"remark1"}},
                   {header:"备注2",name:"remark2",width:150,editor:{type:"text", name:"remark2"}}],
		   		    onBeforeEdit:function(rowIndex , rowData){
		   		         index = rowIndex;
		   		         saveFlagAccount = false;
		   		    },
                   	onAfterEdit:function(rowIndex , rowData){
                   		 currentRowData = rowData;
	       		         if(rowData.employCode == '' || rowData.employCode == 'undefined'){
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
	function issuingerCodeRenderer(value,rowData){
		if(salesmanData != ''){
			if(rowData.accountId != undefined && rowData.accountId != "undefined" && rowData.accountId != ""){
				for(var i = 0;i < salesmanData.length;i++){
			        if(salesmanData[i].value === rowData.employCode){
			            return "<span>"+salesmanData[i].text+"</span>";
			        }
				}
			}else{
				for(var i = 0;i < salesmanData.length;i++){
			        if(salesmanData[i].value === $("input[name='employCode']").val()){
			            return "<span>"+salesmanData[i].text+"</span>";
			        }
				}
			}
		}
	}
	
	//初始化维护人列表按钮菜单
	$('#buttonbar').omButtonbar({
           	btns : [{label:"新增",
            		     id:"addButton" ,
            		     icons : {left : '<%=_path%>/images/add.png'},
            	 		 onClick:function(){
            	 			$('#tables').omGrid("insertRow",0,{businessScale : 100});
           	 			 }
           			},
           			{separtor:true},
           	        {label:"删除",
           	        	id:"delButton",
           	        	icons : {left : '<%=_path%>/images/remove.png'},
           	        	onClick:function(){
           	        		var dels = $('#tables').omGrid('getSelections');
          	            	if(dels.length != 1 ){
          	            		$.omMessageBox.alert({
            	 		 	        content:'只能选择一条记录！',
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
           	            	            	$('#tables').omGrid('deleteRow',dels[0]);
           	                           }
           	                       }
           	                    });
          	            	}
           	        	}
           	        }
           	]
    });
	
	/********出单点信息**********/
	var salesmanCnameOptions = {
   		    dataSource : "<%=_path%>/mediumNode/queryDeptSalesman.do?deptCode="+deptCode,
   		    editable: true,
			filterStrategy : 'anywhere',
			onValueChange : function(target, newValue, oldValue, event) {
				//给维护人代码赋值
				$("input[name='maintenCode']").val(newValue);
				//根据维护人代码查询用户电话和邮箱
				Util.post("<%=_path%>/salesman/querySalesmanInfoByCode.do?salesmanCode="+newValue,"",function(data) {
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
	
	//初始化维护人信息列表
	$('#tables').omGrid({
         limit:0,
         height : 160,
 		 singleSelect : false,
         showIndex : false,
         colModel:[{header:"维护人姓名",name:"salesmanCname",width:150, align : 'center',editor:{rules:["required",true,"维护人必选"],type:"omCombo", name:"salesmanCname" ,options:salesmanCnameOptions},renderer:salesmanCnameRenderer},
                   {header:"维护人代码" , name:"maintenCode",width:200, align : 'center'},
              	   {header:"电话",name:"tel",width:150, align : 'center'},
               	   {header:"邮箱",name:"salesmanCode",width:200, align : 'center'},
              	   {header:"业务占比(%)",name:"businessScale",width:100, align : 'center',editor:{rules:[["required",true,"业务占比必填"],["max",100,"您确定没填错？"],["min",0,"您确定没填错？"]],editable:true,type:"omNumberField",options:businessScaleOptions}}],
		   		    onBeforeEdit:function(rowIndex , rowData){
		   		         index = rowIndex;
		   		         saveFlagMaintain = false;
		   		    },
          			onAfterEdit:function(rowIndex , rowData){
          				 currentRowData = rowData;
	       		         if(rowData.maintenCode == '' || rowData.maintenCode == 'undefined'){
	       		        	 $.omMessageBox.alert({
	       		        		 type:'warning',
	       	 		 	        content:'维护人错误,请重新选择'
	       	 		 	    });
	       		         	$('#tables').omGrid("editRow" , rowIndex);
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
		//延迟加载此方法
		/* setInterval("", 100); */
		if(baseData != '')
		for(var i = 0;i < baseData.length;i++){
	        if(baseData[i].value === value){
	            return "<span>"+baseData[i].text+"</span>";
	        }
		}
	}
	
	//初始化页面保存、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
    
    //浙江IC卡刷卡失败提示
    $("#dialog-error").omDialog({
        autoOpen : false, 
        resizable: false,
        width: 500,
        modal : true,
        buttons: [
                  {text : "重新读卡", 
		           click : function(){
		        	   processIC();
		           }},
		          {text : "取消读卡", 
		           click : function(){
		        	   $("#dialog-error").omDialog("close");
		           }}
       			]
    });
	
	//浙江IC卡特殊处理
	Util.post("<%=_path%>/department/getDeptCodeByUser.do",'',
 			function(data) {
				userDptCde = data;
				if(userDptCde.substring(0,2) == '09'){
					//setTimeout('processIC();',500);//浙江IC卡读取及处理,机构已经废除此功能
				}
 			}
 		);
    
});
/* *************************************初始化function()结束***************************************** */



//浙江IC卡读取及处理
function processIC(){
	try{
		var iccard = new ActiveXObject("icsAccessCtrl.icsAccess");
		ret = iccard.ReadAccess();
		if(0!=ret){
			$("#dialog-error").omDialog("open");
			returnFlag = '1';
			return;
		}
		$('#mediumNodeName').val(iccard.ChuDanDianName).attr('readonly','readonly');
		$('#address').val(iccard.ChuDanDianAddr).attr('readonly','readonly');
		returnFlag = '0';
		$("#dialog-error").omDialog("close");
	} catch(e){
		returnFlag = '1';
		$("#dialog-error").omDialog("open");
	}
}

//按钮权限控制
function getRemote(value){
	if(value == '0'){
    	//禁用操作按钮
    	$("#accountAddButton").omButton("disable");
    	$("#accountDelButton").omButton("disable");
    }else if(value == '1'){
    	//启用操作按钮
    	$("#accountAddButton").omButton("enable");
    	$("#accountDelButton").omButton("enable");
    }
}

//定义校验规则
var mediumNodeRule = {
	nodeCode:{
		required : true,
		isLetterAndInteger : true
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
	nodeCode:{
		required:'远程出单点代码不能为空',
		isLetterAndInteger:'远程出单点代码必须是数字和字母'
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
	$("#tableName").attr("name","tableName");
	
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
			$("#tableName").attr("name","name");
			
			//出单账号信息
        	var jsonDataAccount = JSON.stringify($('#accountTables').omGrid('getData'));
        	$('#jsonDataStrAccount').val(jsonDataAccount);
			
			//维护人信息
			var jsonData = JSON.stringify($('#tables').omGrid('getData'));
			var jsonRows = eval("["+jsonData+"]")[0].rows;
			var baseJsonStr;
			if(jsonRows.length > 0){
				baseJsonStr = "[";
				for(var i = 0;i < jsonRows.length;i++){
					var maintainId = jsonRows[i].maintainId;
					var maintenCode = jsonRows[i].maintenCode;
					var businessScale = jsonRows[i].businessScale;
					if(maintainId != undefined){//修改维护人
						baseJsonStr += "{\"maintainId\":\""+maintainId+"\",\"maintenCode\":\""+maintenCode+"\",\"businessScale\":\""+businessScale+"\"},";
					}else{//新增维护人
						baseJsonStr += "{\"maintenCode\":\""+maintenCode+"\",\"businessScale\":\""+businessScale+"\"},";
					}
				}
				var index = baseJsonStr.lastIndexOf(",");
				baseJsonStr = baseJsonStr.substring(0, index);
				baseJsonStr += "]";
			}else{
				baseJsonStr = "[]";
			}
			//
			$('#jsonDataStrMaintain').val(baseJsonStr);

        	$.omMessageBox.waiting({
                title:'请等待',
                content:'服务器正在处理请求...'
            });

        	//提交
			Util.post("<%=_path%>/mediumNode/updateMediumNode.do",$("#baseInfo").serialize(), function(data) {
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
	var jsonData = JSON.stringify($('#tables').omGrid('getData'));
	var jsonRows = eval("["+jsonData+"]")[0].rows;
	var sumValue = 0; //业务占比总和
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

//取消操作
function cancel(){
	window.location.href = "mediumNode.jsp?flag=1&channelCode="+channelCode;
}
</script>
</head>
<body>
	<div>
		<table class="navi-no-tab">
			<tr><td>出单点维护</td></tr>
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
				<table class="fontClass" style="line-height: 25px;">
					<tr>
						<!-- <td style="padding-left:30px" align="right"><span class="label">机构代码：</span></td>
						<td><input type="text" name="deptCode" id="deptCode" readonly="readonly" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td> -->
						<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
						<td><input type="text" name="deptCname" id="deptCname" readonly="readonly" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span>
						<input type="hidden" name="deptCode" id="deptCode" /></td>
						<td style="padding-left:30px" align="right"><span class="label">代理机构代码：</span></td>
						<td><input type="text" name="channelCode" id="channelCode" readonly="readonly" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">代理机构名称：</span></td>
						<td><input type="text" name="mediumCname" id="mediumCname" readonly="readonly" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">远程出单点名称：</span></td>
						<td><input type="hidden" name="nodeCode" id="nodeCode" /><input type="text" name="nodeName" id="mediumNodeName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<!-- <td style="padding-left:30px" align="right"><span class="label">远程出单点代码：</span></td>
						<td><input type="text" name="nodeCode" id="nodeCode" readonly="readonly" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td> -->
						<td style="padding-left:30px" align="right"><span class="label">保费目标：</span></td>
						<td><input type="text" name="targetPremium" id="targetPremium" />(万元)<span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">出单点地址：</span></td>
						<td><input type="text" name="address" id="address" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<!-- 
						<td style="padding-left:30px" align="right"><span class="label">是否远程出单点：</span></td>
						<td><input class="sele" type="text" name="remote" id="remote" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td> 
						-->
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
						<!-- 
						<td style="padding-left:30px" align="right"><span class="label">出单点名称：</span></td>
						<td><input type="text" name="name" id="tableName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">出单账号：</span></td>
						<td><input type="text" name="account" id="account" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td> 
						-->
						<td style="padding-left:30px" align="right"><span class="label">邮箱：</span></td>
						<td><input type="text" name="email" id="email" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<!-- 
						<td style="padding-left:30px" align="right"><span class="label">vpn账号：</span></td>
						<td><input type="text" name="vpnNo" id="vpnNo" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">合作渠道类型：</span></td>
						<td><input class="sele" type="text" name="channelPartnerType" id="channelPartnerType" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td> 
						-->
					</tr>
				</table>
			</form>
		</fieldSet>
	</div>
	<!-- 出单账号信息 -->
	<div>
		<fieldSet>
			<legend>出单点账号</legend>
			<div id="accountButtonbar" class="om-grid-btn-border"></div>
			<table id="accountTables"></table>
		</fieldSet>
	</div>
	<!-- 维护人列表 -->
	<div>
		<fieldSet>
			<legend>维护人</legend>
			<div id="buttonbar" class="om-grid-btn-border"></div>
			<table id="tables"></table>
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
				<a class="fontClass" id="button-cancel" onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
	<div id="dialog-error" title="读卡失败" style="padding:30px; display: none;">
        <div style="padding-left:70px;height:auto!important; height:50px; min-height:50px;">
            <h4 style="font-size:14px; padding-top: 12px; margin: 0px;">读卡失败,请检查是否正确连接IC卡读卡器！</h4>
        </div>
    </div>
    
</body>
</html>