<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<% String versionId = (String) request.getParameter("versionId"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>销售人员职级</title>
<script type="text/javascript">
var userCode = '';

//使用状态
var itemStatusOptions = {
    dataSource : [{text:"请选择",value:""},{text:"正在使用", value:"1"},{text:"停止使用",value:"0"}],
    disable : !isEdit,
    editable: false
};
//状态渲染
function itemStatusRenderer(value){
	if("1" === value){
		return '<span style="color:green;"><b>正在使用</b></span>';
    }else if("0" === value){
        return '<span style="color:red;  "><b>停止使用</b></span>';
    }else{
        return "";
    }
}
//是否参与统计
var statFlagOptions = {
    dataSource : [{text:"请选择",value:""},{text:"是", value:"1"},{text:"否",value:"0"}],
    editable: false
};
//是否参与统计
function statFlagRenderer(value){
	if("1" === value){
		return '<span style="color:green;"><b>是</b></span>';
    }else if("0" === value){
        return '<span style="color:red;  "><b>否</b></span>';
    }else{
        return "";
    }
}
//保存客户经理职级
function saveRank(tableId){
	var jsonArr = $(tableId).omGrid('getChanges').update;
	var jsonStr = JSON.stringify(jsonArr,['pkId',"normPremium",'baseSalary','caclSalary','baseRate','itemStatus',"personalRequirements","monthlySalaryStandard","monthlyPerformanceStandard"]);
	if(jsonArr.length < 1) return;
	$("#jsonStr").val(jsonStr);
	Util.post(Util.appCxtPath + '/lawDefine/updateRankSales.do', $('#paraForm').serialize(), function(data) {
		$.omMessageBox.alert({
	        type:'success',
	        title:'提示',
	        content:'保存成功',
	        onClose:function(v){
			    $(tableId).omGrid('reload');
	        }
       });
	});
}

$.ajax({ 
	url: "<%=_path%>/common/queryCurrUserRoleEname.do",
	type:"post",
	async: false, 
	dataType: "html",
	success: function(data){
		userCode = data;
	}
});

function isEdit(){
	if(userCode.indexOf("subDept") != -1){
		return false;
	}
}
//数据加载
$(function(){
    //客户经理按钮
	$('#buttonbarSales').omButtonbar({
    	btns : [
    	        {label:"保存修改",
       	 		 onClick:function(){
       	 			saveRank("#tablesSales");
      	 		 }
       		    },
        	   {separtor:true},
      	       {label:"放弃修改",
       	 		 onClick:function(){
       	 			$("#tablesSales").omGrid("cancelChanges");
      	 		 }
         	   }
    	]
    });
    //客户经理职级
	$('#tablesSales').omGrid({
  	    limit : 0,
        showIndex : true,
        method : 'GET',
        editMode:"all", 
   		colModel : [{header : '销售职级代码', name : 'itemCode', width : 120, align : 'center'}, 
   		            {header : '销售职级名称', name : 'itemName', width : '180', align : 'center'},
   		            {header : '年化标保计划(万元)', name : 'normPremium', width : '120', align : 'center',editor:{rules:[["required",true,"不能为空"],["isDecimal",true,"不是有效数字"]],type:"text",editable:isEdit,name:"normPremium"}},
   		            /* {header : '对应总公司职级', name : 'mapRank', width : '120', align : 'center'}, */
   		            /* {header : '是否上报审批', name : 'auditFlag', width : '120', align : 'center'}, */
   		            {header : '月度固定工资(元)', name : 'baseSalary', width : '120', align : 'center',editor:{rules:[["required",true,"不能为空"],["isDecimal",true,"不是有效的数字"]],type:"text",editable:isEdit,name:"baseSalary"}},
   		            {header : '月度绩效工资(元)', name : 'caclSalary', width : '120', align : 'center',editor:{rules:[["required",true,"不能为空"],["isDecimal",true,"不是有效的数字"]],type:"text",editable:isEdit,name:"caclSalary"}},
   		            {header : '使用状态', name : 'itemStatus', width : '100', align : 'left',editor:{type:"omCombo",name:"itemStatus",options:itemStatusOptions},renderer:itemStatusRenderer}
   		           ],
	    dataSource : Util.appCxtPath + '/lawDefine/queryPageRank.do?versionId=<%=versionId%>&itemType=0',
			onSuccess : function(data, testStatus, XMLHttpRequest, event) {
				$(this).omGrid({height : 80 + data.rows.length * 24});
			}
		});
    //团队经理按钮
	$('#buttonbarGroup').omButtonbar({
    	btns : [
    	        {label:"保存修改",
       	 		 onClick:function(){
       	 			saveRank("#tablesGroup");
      	 		 }
       		    },
        	   {separtor:true},
      	       {label:"放弃修改",
       	 		 onClick:function(){
       	 			$("#tablesGroup").omGrid("cancelChanges");
      	 		 }
         	   }
    	]
    });
    //团队经理职级
	$('#tablesGroup').omGrid({
  	    limit : 0,
        showIndex : true,
        method : 'GET',
   		colModel : [{header : '销售职级代码', name : 'itemCode', width : 120, align : 'center'}, 
   		            {header : '销售职级名称', name : 'itemName', width : '180', align : 'center'},
   		            {header : '年化标保计划</br>(万元)', name : 'normPremium', width : '80', align : 'center',editor:{rules:[["required",true,"不能为空"],["isDecimal",true,"不是有效数字"]],type:"text",editable:isEdit,name:"normPremium"}},
   		            /* {header : '对应总公司职级', name : 'mapRank', width : '100', align : 'center'}, */
   		            /* {header : '是否上报审批', name : 'auditFlag', width : '80', align : 'center'}, */
   		            {header : '月度固定工资</br>(元)', name : 'baseSalary', width : '80', align : 'center',editor:{rules:[["required",true,"不能为空"],["isDecimal",true,"不是有效数字"]],type:"text",editable:isEdit,name:"baseSalary"}},
   		            {header : '月度绩效工资</br>(元)', name : 'caclSalary', width : '80', align : 'center',editor:{rules:[["required",true,"不能为空"],["isDecimal",true,"不是有效数字"]],type:"text",editable:isEdit,name:"caclSalary"}},
   		            {header : '团队津贴', name : 'baseRate', width : '80', align : 'center',editor:{rules:[["required",true,"不能为空"],["isDecimal",true,"不是有效数字"]],type:"text",editable:isEdit,name:"baseRate"}},
   		         	{header : '个人标保要求</br>(元)', name : 'personalRequirements', width : '100', align : 'center',editor:{type:"text",editable:isEdit,name:"personalRequirements"}},
   		         	/* {header : '月度固定工资标准(元)</br>团队长按客户经理拿工资', name : 'monthlySalaryStandard', width : '130', align : 'center',editor:{type:"text",editable:true,name:"monthlySalaryStandard"}},
   		      		{header : '月度绩效工资标准(元)</br>团队长按客户经理拿工资', name : 'monthlyPerformanceStandard', width : '130', align : 'center',editor:{type:"text",editable:true,name:"monthlyPerformanceStandard"}}, */
   		         	{header : '使用状态', name : 'itemStatus', width : '90', align : 'left',editor:{type:"omCombo",name:"itemStatus",options:itemStatusOptions},renderer:itemStatusRenderer}
   		           ],
	    dataSource : Util.appCxtPath + '/lawDefine/queryPageRank.do?versionId=<%=versionId%>&itemType=1',
		onSuccess : function(data, testStatus, XMLHttpRequest, event) {
			$(this).omGrid({height : 104 + data.rows.length * 24});
		}
	});
    //其他职级按钮
	$('#buttonbarOthers').omButtonbar({
    	btns : [
    	        {label:"保存修改",
       	 		 onClick:function(){
       	 			saveRank("#tablesOthers");
      	 		 }
       		    },
        	   {separtor:true},
      	       {label:"放弃修改",
       	 		 onClick:function(){
       	 			$("#tablesOthers").omGrid("cancelChanges");
      	 		 }
         	   }
    	]
    });
    //其他经理职级
	$('#tablesOthers').omGrid({
  	    limit : 0,
        showIndex : true,
        method : 'GET',
   		colModel : [{header : '其他职级代码', name : 'itemCode', width : 120, align : 'center'}, 
   		            {header : '其他职级名称', name : 'itemName', width : '180', align : 'center'},
   		            {header : '年化标保计划(万元)', name : 'normPremium', width : '120', align : 'center',editor:{rules:[["required",true,"不能为空"],["isNum",true,"不是有效的整数"]],type:"text",editable:isEdit,name:"normPremium"}},
   		            /* {header : '对应总公司职级', name : 'mapRank', width : '120', align : 'center'}, */
   		            /* {header : '是否上报审批', name : 'auditFlag', width : '120', align : 'center'}, */
   		            {header : '月度固定工资(元)', name : 'baseSalary', width : '100', align : 'center',editor:{rules:[["required",true,"不能为空"],["isNum",true,"不是有效的整数"]],type:"text",editable:isEdit,name:"baseSalary"}},
   		            {header : '月度绩效工资(元)', name : 'caclSalary', width : '100', align : 'center',editor:{rules:[["required",true,"不能为空"],["isNum",true,"不是有效的整数"]],type:"text",editable:isEdit,name:"caclSalary"}},
   		            {header : '使用状态', name : 'itemStatus', width : '100', align : 'left',editor:{type:"omCombo",name:"itemStatus",options:itemStatusOptions},renderer:itemStatusRenderer},
   		            {header : '该职级是否参与</br>组织架构人数统计', name : 'statFlag', width : '100', align : 'center',editor:{type:"omCombo",name:"statFlag",options:statFlagOptions},renderer:statFlagRenderer}
   		           ],
	    dataSource : Util.appCxtPath + '/lawDefine/queryPageRank.do?versionId=<%=versionId%>&itemType=2',
		onSuccess : function(data, testStatus, XMLHttpRequest, event) {
			$(this).omGrid({height : 104 + data.rows.length * 24});
		}
	});
});
</script>
</head>
<body>
    <!-- 参数表单 -->
	<form id="paraForm">
		<input type="hidden" name="formMap['jsonStr']" id="jsonStr" value="" />
	</form>
	<div id="doubleClickEdit">提示：双击可以编辑数据</div>
	<!-- 客户经理职级 -->
	<div>
		<form id="formSales">
			<input type="hidden" name="formMap['jsonStr']" id="jsonStrFactor" value="" />
			<fieldSet>
				<legend>客户经理职级</legend>
				<div id="buttonbarSales" style="border-style: none none solid none;"></div>
				<table id="tablesSales"></table>
			</fieldSet>
		</form>
	</div>
	<!-- 团队经理职级 -->
	<div>
		<fieldSet>
			<legend>团队经理职级</legend>
			<div id="buttonbarGroup" style="border-style: none none solid none;"></div>
			<table id="tablesGroup"></table>
		</fieldSet>
	</div>
	<!-- 其他职级 -->
	<div>
		<form id="formOthers">
			<input type="hidden" name="formMap['jsonStr']" id="jsonStrIndex" value="" />
			<fieldSet>
				<legend>其他职级</legend>
				<div id="buttonbarOthers" style="border-style: none none solid none;"></div>
				<table id="tablesOthers"></table>
			</fieldSet>
		</form>
	</div>
</body>
<script type="text/javascript">
	$.ajax({ 
		url: "<%=_path%>/common/queryCurrUserRoleEname.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			if(data.indexOf("subDept") != -1){
				$('#buttonbarSales').hide();
				$('#buttonbarGroup').hide();
				$('#buttonbarOthers').hide();
				$('#doubleClickEdit').hide();
			}
		}
	});
</script>
</html>