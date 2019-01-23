<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>成本调整系数（已废除）</title>

<style>
.errorImg {
	background: url("<%=_path%>/images/msg.png") no-repeat scroll 0 0 transparent;
	height: 16px;
	width: 16px;
	cursor: pointer;
}
input.error,textarea.error {
	border: 1px solid red;
}
.errorMsg {
	border: 1px solid gray;
	background-color: #FCEFE3;
	display: none;
	position: absolute;
	margin-top: -18px;
	margin-left: -2px;
}
</style>

<script type="text/javascript">
var roleEname;
$(function(){
	//查询功能下拉框初始化
	//初始化机构部门
	$('#deptCode').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?"+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCode').omCombo({
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptCode').omCombo('value');
            $('#deptCode1').omCombo("setData",[]);
            if(currentParentDept != ''){
	            $('#deptCode1').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptCode1').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
        },
        emptyText : "请选择",
		filterStrategy : 'anywhere'
	});
	$('#deptCode1').omCombo({
		onSuccess  : function(data, textStatus, event){
			if(data.length == 2){
				$('#deptCode1').omCombo({value:data[1].value,readOnly : true});
			}
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
	});

	//业务来源
	$('#businessOrigin1').omCombo({
        dataSource : <%=Constant.getCombo("businessOrigin")%>,
        emptyText : '请选择',
        editable : false
    });

	//渠道类型
	$('#channelCategory1').omCombo({
        dataSource : <%=Constant.getCombo("channelCategory")%>,
        emptyText : '请选择',
        editable : false
    });

	//业务类别
	$('#businessType1').omCombo({
        dataSource : <%=Constant.getCombo("businessType")%>,
        emptyText : '请选择',
        editable : false
    });
	
	initDialog();
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#search-panel").omPanel({
    	title : "销售人员管理办法  > 成本调整系数",
    	collapsible:true,
    	collapsed:false
    });	
	$('#buttonbar').omButtonbar({
    	btns : [{label:"新增",
    		     id:"buttonNew" ,
    		     icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
    	 		 onClick:function(){openSave();}
    			},
    			{separtor:true},
    			 {label:"修改",
       			 id:"buttonEdit",
       		     disabled :  false,
       			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
       	 		 onClick:function(){
   	    	 			var rows = $('#tables').omGrid("getSelections",true);
   		 		 		var row = eval(rows);
   		 		 		if(row.length != 1){
   		 		 			$.omMessageBox.alert({
   	    	 		 	        content:'请选择一条记录编辑',
   	    	 		 	        onClose:function(value){
   	    	 		 	        	return false;
   	    	 		 	        }
   		 		 	        });
   	   	 		 		}else{
   	    	 			 	openUpdate(row[0].costRateId);
   		 		 		}
       	 			 }
       	        },
    	        {separtor:true},
    	        {label:"删除",
    			 	id:"buttonRemove",
    			 	icons : {left : '<%=_path%>/images/remove.png'},
    	 		 	onClick:function(){
    	 		 		var rows = $('#tables').omGrid("getSelections",true);
    	 		 		var row = eval(rows);
    	 		 		if(row.length != 1){
    	 		 	        $.omMessageBox.alert({
    	 		 	            content: '请选择一条需要删除的记录'
    	 		 	        });
    	 		 			return false;
    	 		 		}else{
	 		 				$.omMessageBox.confirm({
		 				           title:'确认信息',
		 				           content:'是否删除所选记录?',
		 				           onClose:function(v){
		 				               if(v){
	 				            		    Util.post("<%=_path%>/lawCostRate/deleteLawCostRate.do",
	            		        				"costRateId="+row[0].costRateId,
					            				function(data) {
	 				            		    		if(data == "success"){
					 		 							//删除成功弹出提示框
						            				 	$.omMessageBox.alert({
						            						type : 'success',
									 		 	            content: "删除成功！",
										 		 	        onClose:function(value){
											       			    $("#tables").omGrid({});
										 		 	        	return true;
										 		 	        }
									 		 	        });
	 				            		    		}
       		            		            	}
	 				            		    );
		 				               }
		 				           }
		 				    });
    	 		 		}
    	 		 	}
    	        }
	    	]
	});
	
	//列表的高度
	var btInput = $("#buttonbar");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight();
  	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }
  	
	$("#tables").omGrid({
		limit : 10,
		colModel : tabHand,
		showIndex : false,
        singleSelect : false,
        height : topnum,
        method : 'POST',
        autoFit : true
	});
	
	//校验的提示
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
	//加载是否禁用按钮方法
	isSelected();
	//初始化数据
	setTimeout("query()", 500);
});
//表头
var tabHand = [
	{header:"二级机构",name:"deptCode2",width:100},
	{header:"三级机构",name:"deptCode3",width:120},
	{header:"四级单位",name:"deptCode4",width:120},
	{header:"经办渠道名称",name:"chennelCode",width:300},
	{header:"业务来源",name:"businessOrigin",width:100},
	{header:"渠道类型",name:"channelCategory",width:100},
	{header:"业务类别",name:"businessType",width:180},
	{header:"成本调整系数",name:"costRate",width:100}];
	
//禁用操作数据的按钮
function isSelected(){
	$.ajax({ 
		url: "<%=_path%>/reviewRank/findRolesInSystemByUserCode.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			roleEname = data;
		}
	});
	if(roleEname == "subDeptSalesman"){
		$("#buttonRemove").omButton("disable");
		$("#buttonEdit").omButton("disable");
		$("#buttonNew").omButton("disable");
	}else{
		$("#buttonRemove").omButton("enable");
		$("#buttonNew").omButton("enable");
		$("#buttonEdit").omButton("enable");
	}
}
	
//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/lawCostRate/queryLawCostRate.do?"+$("#filterFrm").serialize());
}
//初始化
function initDialog(){
	$("#addCostRateDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:720,
		height:250,
		modal:true,
		title:"成本调整系数",
		closeOnEscape : true,
		onClose:function(){
			window.location.href = "<%=_path%>/view/law/costRate.jsp";
		},
		onOpen:function(){
			initValidate();
		}
	});
	
    $("#subBtn").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
    $("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
    
}
//打开新增
function openSave(){
	//编辑框内下拉框初始化
	//初始化机构部门
	$('#deptCode2').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?"+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCode2').omCombo({
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptCode2').omCombo('value');
            $('#deptCode3').omCombo("setData",[]);
            if(currentParentDept != ''){
	            $('#deptCode3').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptCode3').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
            $('#deptCode4').omCombo("setData",[]);
            $('#chennelCode').omCombo("setData",[]);
        },
        emptyText : "请选择",
		filterStrategy : 'anywhere',
		lazyLoad : true
    });
	$('#deptCode3').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
			if(newValue != ''){
		        $('#deptCode4').omCombo('setData', "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+newValue);
		        $('#chennelCode').omCombo('setData', "<%=_path%>/medium/queryParentMedium.do?deptCode="+newValue);
			}else{
				$('#deptCode4').omCombo("setData",[]);
	            $('#chennelCode').omCombo("setData",[]);
			}
		},
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCode3').omCombo({
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        },
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
	});
	$('#deptCode4').omCombo({
		emptyText : "请选择",	
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		onValueChange : function(target, newValue, oldValue, event) {
			if(newValue != ''){
	        	$('#chennelCode').omCombo('setData', "<%=_path%>/medium/queryParentMedium.do?deptCode="+newValue);
			}else{
				var currentDeptCode2 = $('#deptCode3').omCombo("value");
				$('#chennelCode').omCombo('setData', "<%=_path%>/medium/queryParentMedium.do?deptCode="+currentDeptCode2);
			}
		}
    });
	
	//经办渠道名称
	$('#chennelCode').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
        listMaxHeight : '270',
		listAutoWidth : true
    });

	//业务来源
	$('#businessOrigin').omCombo({
        dataSource : <%=Constant.getCombo("businessOrigin")%>,
        emptyText : '请选择',
        editable : false
    });

	//渠道类型
	$('#channelCategory').omCombo({
        dataSource : <%=Constant.getCombo("channelCategory")%>,
        emptyText : '请选择',
        editable : false
    });

	//业务类别
	$('#businessType').omCombo({
        dataSource : <%=Constant.getCombo("businessType")%>,
        emptyText : '请选择',
        editable : false,
        listMaxHeight : '220'
    });
	initDialog();
	$("#addCostRateDiv").omDialog({title:"新增成本调整系数"});
	$("#addCostRateDiv").omDialog('open');
}
//打开修改
function openUpdate(costRateId){
	initDialog();
	$("#addCostRateDiv").omDialog({title:"修改成本调整系数"});
	$("#addCostRateDiv").omDialog('open');
	Util.post(
		"<%=_path%>/lawCostRate/queryLawCostRateToUpdate.do?costRateId="+costRateId,
		"",
		function(data) {
			$("#costRateFrm").find(":input").each(function(){
				if($(this).val() != null || $(this).val() != "")
					$(this).val(data[0][$(this).attr("id")]);
					$(this).css({"width":"180px"});
					if($(this).attr("name") != "costRate"){
						$(this).css({"background-color":"#F0F0F0"});
						$(this).attr({"readonly":"readonly"});
					}
			});
		}
	);
}

var lawRankRules;
var lawRankMessages;
//校验
function initValidate(){
	lawRankRules = {
		deptCode2 : {
			required : true
		},
		deptCode3 : {
			required : true
		},
		chennelCode : {
			required : true
		},
		businessOrigin : {
			required : true
		},
		channelCategory : {
			required : true
		},
		businessType : {
			required : true
		},
		costRate : {
			required : true,
			number : true
		}
	};
	lawRankMessages = {
		deptCode2 : {
			required : '二级机构必选'
		},
		deptCode3 : {
			required : '三级机构必选'
		},
		chennelCode : {
			required : '经办渠道必选'
		},
		businessOrigin : {
			required : '业务来源必选'
		},
		channelCategory : {
			required : '渠道类型必选'
		},
		businessType : {
			required : '业务类别必选'
		},
		costRate : {
			required : '成本调整系数不能为空'
		}
	};
	$("#costRateFrm").validate({
		rules: lawRankRules,
		messages: lawRankMessages,
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
        	Util.post("<%=_path%>/lawCostRate/saveLawCostRate.do", $("#costRateFrm").serialize(), 
       			function(data) {
	        		if(data == "success"){
	    				$.omMessageBox.alert({
	    					type:'success',
	    	                title:'成功',
		 		 	        content:'成本调整系数保存成功',
		 		 	        onClose:function(value){
			       			    $("#addCostRateDiv").omDialog('close');
		 		 	        	return true;
		 		 	        }
	 		 	        });
	    			}
       			}
        	);
        	$("#costRateFrm").validate().resetForm();
        }
    });
}
//提交
function submitForm(){
	$("#costRateFrm").submit();
}
function cancel(){
	$("#addCostRateDiv").omDialog('close');
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px;"><span class="label">二级机构名称：</span></td>
					<td><input type="text" name="formMap['deptCode2']" id="deptCode" /></td>
					<td style="padding-left:15px;"><span class="label">三级机构名称：</span></td>
					<td><input type="text" name="formMap['deptCode3']" id="deptCode1" /></td>
					<td style="padding-left:15px;"><span class="label">业务来源：</span></td>
					<td><input type="text" name="formMap['businessOrigin']" id="businessOrigin1" /></td>
					<td style="padding-left:15px;"><span class="label">渠道类型：</span></td>
					<td><input type="text" name="formMap['channelCategory']" id="channelCategory1" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px;"><span class="label">业务类别：</span></td>
					<td><input type="text" name="formMap['businessType']" id="businessType1" /></td>
				    <td colspan="6" style="padding-left:15px;padding-top:5px" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<!-- 新增成本调整系数编辑框 -->
	<div id="addCostRateDiv">
		<form id="costRateFrm">
			<input style="display: none;" name="costRateId" id="costRateId" />
			<div id="nav_cont">
				<table style="align:center"  class="grid_layout">
					<tr>
						<td style="padding-left:30px;" align="right">二级机构：</td>
						<td class="td"><input type="text" style="width: 161px;" name="deptCode2" id="deptCode2" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px;" align="right">三级机构：</td>
						<td class="td"><input type="text" style="width: 161px;" name="deptCode3" id="deptCode3" /><span style="color:red">*</span></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px;" align="right">四级单位：</td>
						<td class="td"><input type="text" style="width: 161px;" name="deptCode4" id="deptCode4" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px;" align="right">经办渠道名称：</td>
						<td class="td"><input type="text" style="width: 161px;" name="chennelCode" id="chennelCode" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px;" align="right">业务来源：</td>
						<td class="td"><input type="text" style="width: 161px;" name="businessOrigin" id="businessOrigin" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px;" align="right">渠道类型：</td>
						<td class="td"><input type="text" style="width: 161px;" name="channelCategory" id="channelCategory" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px;" align="right">业务类别：</td>
						<td class="td"><input type="text" style="width: 161px;" name="businessType" id="businessType" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px;" align="right">成本调整系数：</td>
						<td class="td"><input type="text" style="width: 180px;" name="costRate" id="costRate" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr style="height:20px;"></tr>
					<tr>
						<td colspan="6" align="center"><a class="om-button" id="subBtn" onclick="submitForm()">保存</a><a id="button-cancel"  onclick="cancel()">取消</a></td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</body>
</html>