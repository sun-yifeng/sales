<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>续保级别设置查询</title>
<style type="text/css">
    table.tabBase tr td{height: 35px}
</style>

<script type="text/javascript">
var dataGrid;
var assignDownDiv;
var level;
var bgDate;
var roleFlag;
$(function(){	
	$("#baseInfo").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"133px"});
	$(".seleCombo").css({"width":"143px"});
	
	//查询起期
	$('#beginDate').omCalendar({
		dateFormat : "yy-mm-dd",
		editable : false,
		onSelect : function(date,event) {
			bgDate = date;	//为后面查询止期初始化限制选择日期的有效范围提供参数
			var date1 = new Date(bgDate);
			date1.setDate(date1.getDate() + 3);		//默认查询最近3天即将到期的清单
			$('#endDate').omCalendar({
				editable : false,
				disabledFn : disFn
			});
			$("#endDate").val($.omCalendar.formatDate(date1,'yy-mm-dd'));
		}
	});
	
	//初始化页面时给查询起期赋值
	var date = new Date();
	date.setDate(date.getDate());
	$("#beginDate").val($.omCalendar.formatDate(date,'yy-mm-dd'));
	
	//为后面查询止期初始化限制选择日期的有效范围提供参数
	bgDate = $.omCalendar.formatDate(date,'yy-mm-dd');
	
	var date1 = new Date();
	date1.setDate(date1.getDate() + 3);		//默认查询最近3天即将到期的清单
	
	//查询止期
	$('#endDate').omCalendar({
		dateFormat : "yy-mm-dd",
		editable : false,
		date : new Date(date1.getFullYear(), date1.getMonth(), date1.getDate()),
		disabledFn : disFn
	});
	
	//初始化页面时给查询止期赋值
	$("#endDate").val($.omCalendar.formatDate(date1,'yy-mm-dd'));
	
	$("#assignLevel").omCombo({
		dataSource : "<%=_path%>/renewal/queryAssignLevelByRole.do",
    	emptyText : "请选择",
		inputField : function(data,index){
    		  return data.value+'-'+ data.text; 
    	},
		filterStrategy : 'anywhere'
	});

	/*  有三个权限中的一个即可以导出续保清单:
	 *	分公司市场部_续保管理岗	 subDeptMarketM
	 *	三级机构_中支总	     thirdDeptMiddle
	 *	三级机构_业管	     thirdDeptBusiMana
	 */
	var roleName = "headDeptSalesmanXubaoNew,subDeptSalesmanXubaoNew,xszcAdmin";
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName="+roleName,
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			//alert(data);
			roleFlag = eval(data);
		}
	});
	
    //初始化列表   
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel:tabHand,
		showIndex : false,
		singleSelect : false,
        height:400,
        method : 'POST',
        autoFit : true
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "续保管理  > 续保管理",
    	collapsible:true,
    	collapsed:false
    });
	
	//下发层级
	$("#assignLevelToSimple").omCombo({
		valueField : 'value',
		forceSelction : true,
    	onValueChange:function(target,newValue,oldValue,event){
    		//alert(newValue+","+level);
    		if( newValue < level ){
    			$.omMessageBox.alert({
    		        content:'您选择的层级比设置的下发层级高！'
    		    });
    			$("#simpleSubmit").omButton("disable");
    		}else {
    			$("#simpleSubmit").omButton("enable");
    		}
    	},
		filterStrategy : 'anywhere'
	});
	
	//默认下发-提交
	$("#simpleSubmit").omButton({
		icons : {left : '<%=_path%>/images/add.png'},
		onClick:function(event){
			Util.post("<%=_path%>/renewal/updateRenewalById.do",
       		  $("#assignFromToSimple").serialize(),
       		  function (data){
        	    //query();
        		$('#tables').omGrid('reload');
        		assignDownDivToSimple.omDialog("close");
       	     });	
		}
	});
	
	//默认下发-取消
	$("#simpleCannel").omButton({
		icons : {left : '<%=_path%>/images/remove.png'},
		onClick:function(event){
			assignDownDivToSimple.omDialog("close");
		}
	});
	
	assignDownDiv = $("#assignLevelDiv").omDialog({
		autoOpen : false,
        modal : true,
        resizable : false,
        height : 500,
        width : 750,
        resizable : true,
        onOpen : function(event) {
		    $("#checkUserRoleIfm").attr("src","<%=_path%>/view/demo/selectUserRole.jsp");
        },
        onClose : function(event) {
        }
	});
	
	var showDialog = function(title,rowData){
		rowData = rowData || {};
		//$("#renewalId").val(rowData[0].renewalId);
        		
		var id = "" ;
		for(var i=0;i<rowData.length;i++){
			id += "," + rowData[i].renewalId;
		}
		//alert(id.substr(1));
		$("#renewalId").val(id.substr(1));
		assignDownDiv.omDialog("option", "title", title);
		assignDownDiv.omDialog("open");//显示dialog
	};
	
	var assignDownDivToSimple = $("#assignLevelDivToSimple").omDialog({
		autoOpen : false,
        modal : true,
        resizable : false,
        height : 140,
        width : 300,
        resizable : true,
        onOpen : function(event) {
        },
        onClose : function(event) {
        	$("#assignLevelToSimple").omCombo("setData",[]);
        }
	});
	
	var showDialogToSimple = function(title,rowData){
		level = rowData[0].assignLevleCode;
		//alert(level);
		rowData = rowData || {};
		//$("#renewalId").val(rowData[0].renewalId);
        		
		var id = "" ;
		for(var i=0;i<rowData.length;i++){
			id += "," + rowData[i].renewalId;
		}
		
		$("#renewalIdToSimple").val(id.substr(1));
		assignDownDivToSimple.omDialog("option", "title", title);
		assignDownDivToSimple.omDialog("open");
		$("#assignLevelToSimple").omCombo("setData","<%=_path%>/renewal/queryAssignLevelByRole.do");
		//$("#assignLevelToSimple").omCombo("value",rowData[0].assignLevel);
	};

	//按钮
	$('#operationBar').omButtonbar({
    	btns : [
	    		{label:"续保机动下发",
			     id:"renewal-any-down" ,
			     icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
		 		 onClick:function(){
		 			 var selections = $("#tables").omGrid("getSelections",true);
		 			 if(selections.length == 0){
		 				$.omMessageBox.alert({
		 		           content:'请选择一条记录'
		 		       });
		 			 }else{
		 				showDialog("续保下发",selections);
		 			 }
		 			 
		 		 }
				},
				{separtor:true},
	    		{label:"续保默认下发",
			     id:"renewal-default-down" ,
			     icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
		 		 onClick:function(){
		 			 
		 			 var selections = $("#tables").omGrid("getSelections",true);
		 			 if(selections.length == 0){
		 				$.omMessageBox.alert({
		 		           content:'请选择一条记录'
		 		       });
		 			 }else{
		 				 showDialogToSimple("续保下发",selections);
		 			 }
		 			 
		 		 }
				},
		        {separtor:true},
		        {label:"详情",
				 id:"button-detail",
			     disabled :  false,
				 icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/search.png'},
		 		 onClick:function(){
		 			var rows = $('#tables').omGrid("getSelections",true);
			 		var row = eval(rows);
			 		if(row.length == 0 && row.length != 1){
			 			 $.omMessageBox.alert({
			 	            content: '请选择一条记录查看'
			 	        });
			 			return false;
			 		}else if(row.length > 1){
			 			$.omMessageBox.alert({
			 	            content: '一次只能查看一条数据'
			 	        });
			 			return false;
			 		}else{
			 			window.location.href = "renewalDetail.jsp?renewalId="+row[0].renewalId;
			 		}
		 		 }
		        }
			]
    });
	
	//加载二级机构名称
	$('#proDept').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#proDept').omCombo({
				value:eval(data)[1].value,
    			readOnly : true
			});
        },
        onValueChange : function(target, newValue, oldValue, event) {
            $('#deptCodeThree').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
        },
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	
	//初始化三级机构名称
	$('#deptCodeThree').omCombo({
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		emptyText : "请选择",
		onSuccess:function(data, textStatus, event){
			if(data.length == 2){
        		$('#deptCodeThree').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
		}
	});
	
	setTimeout("query()",500);
});

function disFn(date) {
	var bg = new Date(bgDate);
    if (date < bg) {
        return false;
    }
    
	bg.setDate(bg.getDate() + 30);
    if(date > bg){
    	return false;
    }
}

//表头
var tabHand = [
	{header:"保单号",name:"policyNo",width:100},
    {header:"二级机构",name:"deptNameTwo"},
    {header:"三级机构",name:"deptNameThree"},
	{header:"四级单位",name:"deptNameFour"},
	{header:"出单业务员",name:"salesmanNo",width:100},
	{header:"险种",name:"insuraName",width:150},
	{header:"保险起期",name:"safeBeginDate"},
	{header:"保险止期",name:"safeEndDate"},
	{header:"投保人姓名",name:"policyHolderName"},
	{header:"下发进度",name:"assignLevel"}
   ];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/renewal/queryRenewal.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){
	if(roleFlag){
		window.open("<%=_path%>/renewal/queryDataToExcel.do?"+$("#filterFrm").serialize());
	}else{
		$.omMessageBox.alert({
	 	        content:'没有操作权限！',
	 	        onClose:function(value){
	 	        	return false;
	 	        }
	        });
	}
}

function getIframeData(data){
	Util.post("<%=_path%>/renewal/updateRenewalById.do",
			$("#assignFrom").serialize(),
			function (data){
		//query();
		$('#tables').omGrid('reload');
		assignDownDiv.omDialog("close");
	});
}

</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">二级机构：</span></td>
					<td>
						<input name="formMap['proDept']" id="proDept"  class="sele" />
					</td>
					<td style="padding-left:15px" align="right"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptCodeThree']" id="deptCodeThree"  class="sele" /></td>
					<td style="padding-left:15px" align="right"><span class="label">下发进度：</span></td>
					<td><input name="formMap['assignLevel']" id="assignLevel"  class="sele" /></td>
					<td style="padding-left:15px" nowrap="nowrap"><span class="label">查询起期：</span></td>
					<td><input name="formMap['beginDate']" id="beginDate" class="sele" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px" nowrap="nowrap"><span class="label">查询止期：</span></td>
					<td><input name="formMap['endDate']" id="endDate" class="sele" /></td>
					<td colspan="6" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="operationBar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<div id="assignLevelDiv"  >
		<form id='assignFrom' name="assignFrom" >
			<input type="hidden" name="renewalId" id="renewalId" />
			<input type="hidden" name="assignLevel" id="assignLevel" />
			<input type="hidden" name="deptCodeThree" id="deptCodeThree" />
			<input type="hidden" name="renewalGroupCode" id="renewalGroupCode" />
			<input type="hidden" name="renewalSalesmanCode" id="renewalSalesmanCode" />
			<iframe id="checkUserRoleIfm" frameborder="0" width="100%" height="440" src="about:blank" frameborder=no ></iframe>
		</form>
	</div>
	<div id="assignLevelDivToSimple" >
		<form id='assignFromToSimple' name="assignFromToSimple" >
		<center>
			<input type="hidden" name="renewalId" id="renewalIdToSimple" />
			选择默认下发层级： <input type="text" name="assignLevel" id="assignLevelToSimple" />
			<p/><p/>
			<a id="simpleSubmit" >提交</a>
			<a id="simpleCannel" >取消</a>
		</center>
		</form>
	</div>
</body>
</html>