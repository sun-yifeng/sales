<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>销售人员管理办法版本指定（已经废除）</title>
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
	$.ajax({ 
		url: "<%=_path%>/common/findDeptByUserCode.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			currentDept = data;
			$('#deptCode1').omCombo({
				dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
				onSuccess : function(){
					if(currentDept != '00'){
						$('#deptCode1').omCombo({value:currentDept,readOnly : true});
					}
				},
				emptyText : "请选择",
				valueField : 'value',
				inputField : 'text',
				filterStrategy : 'anywhere',
				width:182
		    });
		}
	});

	
	var btInput = $("#buttonbar1");
	var btOffset = btInput.offset();
	var btnum = btOffset.top+btInput.outerHeight()+88;
	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
	if($.browser.msie&&($.browser.version == "8.0"||$.browser.version == "9.0")){
		topnum = topnum + 5;
	}
	
	$("#subBtn").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#table1").omGrid({
		colModel:tabHand1,
		showIndex : false,
        singleSelect : false,
		limit : 10,
        height : topnum,
        method : 'POST'
	});
	initDialog();
	
	//初始化机构部门
	$('#deptCode').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?"+ new Date().toTimeString(),
        emptyText : "请选择",
		filterStrategy : 'anywhere',
		listMaxHeight  : 200,
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCode').omCombo({
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        },
        lazyLoad : true
    });
	
    $('#versionCode').omCombo({
		dataSource : "<%=_path%>/lawDefine/queryLawDefineOmcombo.do",
        emptyText : "请选择",
		filterStrategy : 'anywhere',
		listMaxHeight  : 200
    });
    $("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#search-panel").omPanel({
    	title : "销售人员管理办法  > 管理办法版本指定",
    	collapsible:true,
    	collapsed:false
    });	
	$('#buttonbar1').omButtonbar({
    	btns : [{label:"指定",
    		     id:"buttonNew" ,
    		     icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
    	 		 onClick:function(){
    	 			var rows = $('#table1').omGrid("getSelections",true);
	 		 		var row = eval(rows);
	 		 		if(row.length != 1){
	 		 			$.omMessageBox.alert({
    	 		 	        content:'请选择一条记录',
    	 		 	        onClose:function(value){
    	 		 	        	return false;
    	 		 	        }
	 		 	        });
   	 		 		}else{
   	 		 			var inValidDate = row[0]["inValidDate"];
   	 		 			var date = new Date();
   	 		 			if(date<inValidDate){
	   	 		 			$.omMessageBox.alert({
	    	 		 	        content:'此版本的管理办法已经过了有效期，不能指定',
	    	 		 	        onClose:function(value){
	    	 		 	        	return false;
	    	 		 	        }
		 		 	        });
   	 		 			}else if(row[0]['isValid'] === "1"){
           					$.omMessageBox.alert({
    	    	 		 	        content:'该条管理办法已经生效,不需要指定',
    	    	 		 	        onClose:function(value){
    	    	 		 	        	return false;
    	    	 		 	        }
		 		 	       	 	});
           				}else{
	   	 		 			$.omMessageBox.confirm({
	   			 		 		title:'确认指定',
	   			                content:'销售人员管理办法版本指定后，管理办法会及时生效，你确定要这样做吗？',
	   			                onClose:function(value){
	   			                	value ? (function(){
	   			                		Util.post( 
	   			                			"<%=_path%>/lawSpecify/updateLawSpecify.do?pkUuid="+row[0]['pkUuid']+'&deptCode='+row[0]['deptCode']+'&isValid='+row[0]['isValid'],
	   			                			"",
	   			                			function(data){
	   			                			 	window.location.href = "<%=_path%>/view/law/lawSpecify.jsp";
	   			                			}
	   			                		);
	   			                		})() : (function(){return value;})();
	   			                }
	   	   	 		 	 	});
   	 		 			}
   	 		 		
	 		 		}
    	 		 }
    			}
    	]
    });
	
	//加载是否禁用按钮方法
	isSelected();
	//加载初始数据
	setTimeout("query()","500");
	
	initValidate();
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
});
//表头1
var tabHand1 = [
	{header:"机构名称",name:"deptCname",width:150},
	{header:"是否生效",name:"isValid",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '0')
				return "否";
			else if(value == '1')
				return "是";
			else
				return "";
		}		
	},
	{header:"管理办法代码",name:"versionCode",width:200},
	{header:"管理办法名称",name:"versionName",width:200},
	{header:"管理办法生效日期",name:"validDate",width:150},
	{header:"管理办法失效日期",name:"inValidDate",width:150},
	{header:"备注",name:"defineMemo",width:250}
	//{header:"管理办法父版本代码",name:"parentVersionCode",width:150}
];

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
		$("#updateButton").omButton("enable");
		$("#buttonNew").omButton("enable");
		$("#buttonEdit").omButton("enable");
	}
}

//查询操作
function query(){
	$("#table1").omGrid("setData","<%=_path%>/lawSpecify/queryLawSpecify.do?"+$("#filterFrm").serialize());
}
//初始化
function initDialog(){
	$("#addLawSpecifyDiv").omDialog({
		autoOpen:false,
		resizable:false,
		width:350,
		height:150,
		modal:true,
		title:"管理办法版本指定",
		onClose:function(){
			//query();
			//$("#lawDefineFrm").validate().resetForm();
			window.location.href = "<%=_path%>/view/law/lawSpecify.jsp";
		},
		onOpen:function(){
			initValidate();
		}
	});
	$("#subBtn").omButton({width:50});
}
//打开新增
function openSave(){
	initDialog();
	$("#addLawSpecifyDiv").omDialog({title:"新增管理办法版本指定"});
	$("#addLawSpecifyDiv").omDialog('open');
}
//打开编辑
function openUpdate(pkUuid){
	initDialog();
	$("#addLawSpecifyDiv").omDialog({title:"修改管理办法版本指定"});
	$("#addLawSpecifyDiv").omDialog('open');
	Util.post(
		"<%=_path%>/lawSpecify/queryLawSpecifyToUpdate.do?pkUuid="+pkUuid,
		"",
		function(data) {
			$("#lawSpecifyFrm").find(":input").each(function(){
				if($(this).val() != null || $(this).val() != "")
					$(this).val(data[0][$(this).attr("id")]);
			});
			$('#deptCode').omCombo({value : data[0].deptCode});
			$('#versionCode').omCombo({value : data[0].versionCode});
		}
	);
}
//校验
function initValidate(){
	$("#lawSpecifyFrm").validate({
		rules: {
			versionCode : {
				required : true
			},
			deptCode : {
				required : true
			}
		},
		messages: {
			versionCode : {
				required : '管理办法必选'
			},
			deptCode : {
				required : '机构必选'
			}
		},
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
        	Util.post("<%=_path%>/lawSpecify/saveLawSpecify.do", 
       			$("#lawSpecifyFrm").serialize(), 
       			function(data) {
       			    $("#addLawSpecifyDiv").omDialog('close');
       			}
        	);
        }
    });
}
//提交
function submitForm(){
	$("#lawSpecifyFrm").submit();
}
function cancel(){
	$("#addLawSpecifyDiv").omDialog('close');
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:30px;"><span class="label">机构名称：</span></td>
					<td><input type="text" name="formMap['deptCode']" id="deptCode1" style="width:130px;" /></td>
				    <td colspan="2" style="padding-left:30px;padding-top:5px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar1" style="margin-bottom: 0px;"></div>
	<div id="table1"></div>
	<!-- 新增版本指定 -->
	<div id="addLawSpecifyDiv">
		<form id="lawSpecifyFrm">
			<div id="nav_cont">
				<table class="grid_layout">
					<tr>
						<td style="padding-left:30px" align="right">分公司：</td>
						<td><input type="text" name="deptCode" id="deptCode" alias="deptCode" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td align="right">管理办法：</td>
						<td><input type="text" name="versionCode" id="versionCode" alias="versionCode" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr align="center">
						<td colspan="2"><input type="hidden" name="pkUuid" id="pkUuid" alias="pkUuid" isPK="true" /><span id="subBtn" onclick="submitForm();">保存</span><a id="button-cancel"  onclick="cancel()">取消</a></td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</body>
</html>