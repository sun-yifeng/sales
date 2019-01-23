<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<% 
   String itemType = "0"; // 客户经理规则 
   String versionId = (String) request.getParameter("versionId"); 
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户经理规则</title>
<script type="text/javascript">
//使用状态
var itemStatusOptions = {
    dataSource : [{text:"正在使用", value:"1"},{text:"停止使用",value:"0"}],
    editable: false
};
//使用状态
function itemStatusRenderer(value){
	if("1" === value){
		return '<span style="color:green;"><b>正在使用</b></span>';
    }else if("0" === value){
        return '<span style="color:red;  "><b>停止使用</b></span>';
    }else{
        return "";
    }
 }
//系统因素
var factorSysOptions = {
	dataSource:"<%=_path%>/lawDefine/queryRules.do?itemType=0",
	onValueChange:function(target, newValue, oldValue, event) {
		$.ajax({
   		 url: "<%=_path%>/lawDefine/queryRules.do?itemType=0", 
   			type:"post",
   			async: false, 
   			dataType:"json",
   			success:function(data){
   				for(var i=0; i<data.length; i++){
   				  if(newValue == data[i].value) {
   				     $("#tablesFactor").next().find("#itemName").val(data[i].text.substr(5));
   				     return;
   				  }
   				}
   			}
   	 });
	},
	width:310,
	inputField:'value',
    editable: false
};
//导入因素
var factorImpOptions = {
	dataSource:"<%=_path%>/lawDefine/queryRules.do?itemType=1",
	onValueChange:function(target, newValue, oldValue, event) {
		$.ajax({
	   		 url: "<%=_path%>/lawDefine/queryRules.do?itemType=1", 
	   			type:"post",
	   			async: false, 
	   			dataType:"json",
	   			success:function(data){
	   				for(var i=0; i<data.length; i++){
	   				  if(newValue == data[i].value) {
	   				     $("#tablesImport").next().find("#itemName").val(data[i].text.substr(5));
	   				     return;
	   				  }
	   				}
	   			}
		});
	},
	width:310,
	inputField:'value',
    editable: false
};
//考核因素
var factorExaOptions = {
	dataSource:"<%=_path%>/lawDefine/queryRules.do?itemType=2",
	onValueChange:function(target, newValue, oldValue, event) {
		$.ajax({
	   		 url: "<%=_path%>/lawDefine/queryRules.do?itemType=2", 
	   			type:"post",
	   			async: false, 
	   			dataType:"json",
	   			success:function(data){
	   				for(var i=0; i<data.length; i++){
	   				  if(newValue == data[i].value) {
	   				     $("#tablesExamine").next().find("#itemName").val(data[i].text.substr(5));
	   				     return;
	   				  }
	   				}
	   			}
		});
	},
	width:310,
	inputField:'value',
    editable: false
};
//计算公式
var indexCodeOptions = {
	dataSource:"<%=_path%>/lawDefine/queryRules.do?itemType=3",
	onValueChange:function(target, newValue, oldValue, event) {
		$.ajax({
	   		 url: "<%=_path%>/lawDefine/queryRules.do?itemType=3", 
	   			type:"post",
	   			async: false, 
	   			dataType:"json",
	   			success:function(data){
	   				for(var i=0; i<data.length; i++){
	   				  if(newValue == data[i].value) {
	   				     $("#tablesIndex").next().find("#itemName").val(data[i].text.substr(5));
	   				     return;
	   				  }
	   				}
	   			}
		});
	},
	width:390,
	inputField:'value',
    editable: false
};
//考核代码
var checkCodeOptions = {
	dataSource:"<%=_path%>/lawDefine/queryRulesE.do?itemType=4",
    editable: false
};
//考核操作
function checkCodeRenderer(value){
	return value;
}
//考核操作
var checkOperateOptions = {
    editable: false,
    dataSource : "<%=_path%>/lawDefine/queryRulesE.do?itemType=A",
};
//考核操作
function checkOperateRenderer(value){
	var operaData = [];
	$.ajax({
  		 url: "<%=_path%>/lawDefine/queryRulesE.do?itemType=A", 
  			type:"post",
  			async: false, 
  			dataType:"json",
  			success:function(data){
  				operaData = data;
  			}
	});
	for(var i=0;i<operaData.length;i++){
		if(value == operaData[i].value){
			return operaData[i].text;
		}
	}
}
//渲染样式	
function indexCodeRenderer(value){
	return value;
}
//保存系统因素
function saveFactor(){
	var gridObj = $('#tablesFactor').omGrid('getChanges');
	var jsonArr = (gridObj.insert).concat(gridObj.update);
	var jsonStr = JSON.stringify(jsonArr,['pkId',"itemCode",'itemName','itemStatus']);
	if(jsonArr.length < 1) return;
	$("#jsonStr").val(jsonStr);
	Util.post(Util.appCxtPath + '/lawDefine/updateFactorSystem.do', $('#paraForm').serialize(), function(data) {
		$.omMessageBox.alert({
	        type:'success',
	        title:'提示',
	        content:'保存成功',
	        onClose:function(v){
			    $('#tablesFactor').omGrid('reload');
	         }
       });
	});
}
//保存导入因素
function saveImport(){
	var gridObj = $('#tablesImport').omGrid('getChanges');
	var jsonArr = (gridObj.insert).concat(gridObj.update);
	var jsonStr = JSON.stringify(jsonArr,['pkId',"itemCode",'itemName','itemStatus']);
	if(jsonArr.length < 1) return;
	$("#jsonStr").val(jsonStr);
	Util.post(Util.appCxtPath + '/lawDefine/updateFactorImport.do', $('#paraForm').serialize(), function(data) {
		$.omMessageBox.alert({
	        type:'success',
	        title:'提示',
	        content:'保存成功',
	        onClose:function(v){
			    $('#tablesImport').omGrid('reload');
	         }
       });
	});
}
//保存考核因素
function saveExamine(){
	var gridObj = $('#tablesExamine').omGrid('getChanges');
	var jsonArr = (gridObj.insert).concat(gridObj.update);
	var jsonStr = JSON.stringify(jsonArr,['pkId',"itemCode",'itemName','itemStatus']);
	if(jsonArr.length < 1) return;
	$("#jsonStr").val(jsonStr);
	Util.post(Util.appCxtPath + '/lawDefine/updateFactorExamine.do', $('#paraForm').serialize(), function(data) {
		$.omMessageBox.alert({
	        type:'success',
	        title:'提示',
	        content:'保存成功',
	        onClose:function(v){
			    $('#tablesExamine').omGrid('reload');
	         }
       });
	});
}
//保存计算公式
function saveIndex(){
	var gridObj = $('#tablesIndex').omGrid('getChanges');
	var jsonArr = (gridObj.insert).concat(gridObj.update);
	var jsonStr = JSON.stringify(jsonArr,['pkId',"itemCode",'itemName','calcFormula','calcCondtion','itemStatus',"orderNo"]);
	if(jsonArr.length < 1) return;
	$("#jsonStr").val(jsonStr);
	Util.post(Util.appCxtPath + '/lawDefine/updateLawIndex.do', $('#paraForm').serialize(), function(data) {
		$.omMessageBox.alert({
	        type:'success',
	        title:'提示',
	        content:'保存成功',
	        onClose:function(v){
			    $('#tablesIndex').omGrid('reload');
	         }
       });
	});
}
//保存考核公式
function saveReview(){
	var gridObj = $('#tablesReview').omGrid('getChanges');
	var jsonArr = (gridObj.insert).concat(gridObj.update);
	var jsonStr = JSON.stringify(jsonArr,['pkId',"itemCode",'itemName','calcFormula','calcCondtion','itemStatus']);
	if(jsonArr.length < 1) return;
	$("#jsonStr").val(jsonStr);
	Util.post(Util.appCxtPath + '/lawDefine/updateLawReview.do', $('#paraForm').serialize(), function(data) {
		$.omMessageBox.alert({
	        type:'success',
	        title:'提示',
	        content:'保存成功',
	        onClose:function(v){
			    $('#tablesReview').omGrid('reload');
	        }
       });
	});
}

//生成一个新的orderNo
function createOrderNo(store,index){
	var newOrderNo = (index+1)*10;
	for(var i=0;i<store.rows.length;i++){
		if(store.rows[i].orderNo==newOrderNo){
			newOrderNo = createOrderNo(store,index+1);
			break;
		}
	}
	return newOrderNo;
}

//检查公式
function validateFormula(){
	$.ajax({
 		 url: "<%=_path%>/lawDefine/validateFormula.do?versionId=<%=versionId%>", 
 			type:"post",
 			async: false, 
 			dataType:"json",
 			success:function(data){
 				if(data != null){
 					$.omMessageBox.alert({
				           content: '不能识别的因素,指标或字符：' + data,
					    });
 				}
 			}
	});
}

//数据加载
$(function() {
    //系统因素
	$('#buttonbarFactor').omButtonbar({
    	btns : [
    	        {label:"新增因素",
       	 		 onClick:function(){
       	 			var heightNum = $('#tablesFactor').height() + 100;
        			$('#tablesFactor').parent().height(heightNum).parent().height(heightNum);
          	 		$('#tablesFactor').omGrid('insertRow','begin',{itemStatus:"1"});
      	 		 }
       		    },
       		    {separtor:true},
    	        {label:"保存修改",
       		     id : "sysButton",
       	 		 onClick:function(){
       	 			saveFactor();
      	 		 }
       		    },
        	   {separtor:true},
      	       {label:"放弃修改",
       	 		 onClick:function(){
       	 			$("#tablesFactor").omGrid("cancelChanges");
      	 		 }
         		}
    	]
    });
    //系统因素
	$('#tablesFactor').omGrid({
		//width : 450,
  	    limit : 0,
        showIndex : true,
        method : 'GET',
   		colModel : [{header:'代码',name:'itemCode',width:70,align:'left',editor:{rules:["required",true,"不能为空"],type:"omCombo",name:"itemCode",options:factorSysOptions}}, 
   		            {header:'描述',name:'itemName',width:'180',align:'left'},
   		            {header:'使用状态',name:'itemStatus',width:'80',align:'center',editor:{type:"omCombo",name:"itemStatus",options:itemStatusOptions},renderer:itemStatusRenderer}
   		           ],
	    dataSource:Util.appCxtPath + '/lawDefine/queryPageFactor.do?versionId=<%=versionId%>&itemType='+<%=itemType%>,
	    onSuccess:function(data,testStatus,XMLHttpRequest,event){
	    	$(this).omGrid({height : 80 + data.rows.length * 24});
	    	$('#tablesImport').omGrid({height : 80 + data.rows.length * 24});
	    	$('#tablesExamine').omGrid({height : 80 + data.rows.length * 24});
	    }
	});
    //导入因素
	$('#buttonbarImport').omButtonbar({
    	btns : [
    	       {label:"新增因素",
       	 		 onClick:function(){
       	 			var heightNum = $('#tablesImport').height() + 100;
        			$('#tablesImport').parent().height(heightNum).parent().height(heightNum);
       	 			$('#tablesImport').omGrid('insertRow','begin',{itemStatus:"1"});
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"保存修改",
       			 id:"impButton",
       	 		 onClick:function(){
       	 			saveImport();
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"放弃修改",
       	 		 onClick:function(){
       	 			$("#tablesImport").omGrid("cancelChanges");
      	 		 }
       		   }
    	]
    });
	//导入因素
	$('#tablesImport').omGrid({
  	    limit : 0,
        showIndex : true,
        method : 'GET',
   		colModel : [{header:'代码',name:'itemCode',width:70,align:'left',editor:{rules:["required",true,"不能为空"],type:"omCombo",name:"itemCode",options:factorImpOptions}}, 
   		            {header:'描述',name:'itemName',width:'180',align:'left'},
   		            {header:'使用状态',name:'itemStatus',width:'80',align:'left',editor:{type:"omCombo",name:"itemStatus",options:itemStatusOptions},renderer:itemStatusRenderer}
   		           ],
	    dataSource : Util.appCxtPath + '/lawDefine/queryPageImport.do?versionId=<%=versionId%>&itemType='+<%=itemType%>,
	    onSuccess:function(data,testStatus,XMLHttpRequest,event){
	    	//$(this).omGrid({height : 80 + data.rows.length * 24});
	    }
	});
    //考核因素
	$('#buttonbarExamine').omButtonbar({
    	btns : [
    	       {label:"新增因素",
       	 		 onClick:function(){
       	 			var heightNum = $('#tablesExamine').height() + 100;
       				$('#tablesExamine').parent().height(heightNum).parent().height(heightNum);
       	 			$('#tablesExamine').omGrid('insertRow','begin',{itemStatus:"1"});
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"保存修改",
       			 id : "checkButton",  
       	 		 onClick:function(){
       	 			saveExamine();
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"放弃修改",
       	 		 onClick:function(){
       	 			$("#tablesExamine").omGrid("cancelChanges");
       	 		    var heightNum = $('#tablesExamine').height() + 100;
       	 		    $("#tablesExamine").omGrid("resize" , {height:heightNum});
      	 		 }
       		   }
    	]
    });
	//考核因素
	$('#tablesExamine').omGrid({
  	    limit : 0,
        showIndex : true,
        method : 'GET',
   		colModel : [{header:'代码', name:'itemCode', width:70, align:'left',editor:{rules:["required",true,"不能为空"],type:"omCombo",name:"itemCode",options:factorExaOptions}}, 
   		            {header:'描述', name:'itemName', width:'180', align:'left'},
   		            {header:'使用状态', name:'itemStatus', width:'80', align:'center',editor:{type:"omCombo",name:"itemStatus",options:itemStatusOptions},renderer:itemStatusRenderer}
   		           ],
	    dataSource : Util.appCxtPath + '/lawDefine/queryPageExamine.do?versionId=<%=versionId%>&itemType='+<%=itemType%>,
	    onSuccess:function(data,testStatus,XMLHttpRequest,event){
	    	//$(this).omGrid({height : 80 + data.rows.length * 24});
	    }
	});
    //计算公式
	$('#buttonbarIndex').omButtonbar({
    	btns : [
    	       {label:"新增公式",
       	 		onClick:function(){
       	 			var heightNum = $('#tablesIndex').height() + 100;
    				$('#tablesIndex').parent().height(heightNum).parent().height(heightNum);
    				var store = $("#tablesIndex").omGrid("getData");
    				var newOrderNo = createOrderNo(store,store.rows.length);
       	 			$('#tablesIndex').omGrid('insertRow','begin',{itemStatus:"1",orderNo:newOrderNo});
      	 		}
       		   },
       		   {separtor:true},
    	       {label:"保存修改",
       			 id : "expButton",
       	 		 onClick:function(){
       	 			saveIndex();
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"放弃修改",
       	 		 onClick:function(){
       	 			$("#tablesIndex").omGrid("cancelChanges");
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"检查公式",
       	 		 onClick:function(){
       	 			validateFormula();
      	 		 }
       		   }
    	]
    });
	//计算公式
	$('#tablesIndex').omGrid({
  	    limit : 0,
        showIndex : true,
        method : 'GET',
   		colModel: [{header:'代码', name:'itemCode', width:70, align:'left',editor:{rules:["required",true,"请选择"],type:"omCombo",name:"itemCode",options:indexCodeOptions},renderer:indexCodeRenderer}, 
   		           {header:'描述', name:'itemName', width:'320', align:'left'},
   		           {header:"计算顺序",name:"orderNo",width:"70",align:"left",editor:{rules:["required",true,"不能为空"],type:"text",editable:true,name:"orderNo"}},
   		           {header:'计算公式', name:'calcFormula', width:'240', align:'left',editor:{rules:[["required",true,"不能为空"],["maxlength",100,"长度不能超过100"]],type:"text",editable:true,name:"calcFormula"}},
   		           {header:'计算条件', name:'calcCondtion', width:'425', align:'left',editor:{rules:["maxlength",100,"长度不能超过100"],type:"text",editable:true,name:"calcCondtion"}},
   		           {header:'使用状态', name:'itemStatus', width:'80', align:'left',editor:{rules:["required",true,"不能为空"],type:"omCombo",name:"itemStatus",options:itemStatusOptions},renderer:itemStatusRenderer}
   		          ],
	    dataSource: Util.appCxtPath + '/lawDefine/queryPageIndex.do?versionId=<%=versionId%>&itemType='+<%=itemType%>,
	    onSuccess:function(data,testStatus,XMLHttpRequest,event){
	    	$(this).omGrid({height : 80 + data.rows.length * 24});
	    }
	});
    //考核规则
	$('#buttonbarReview').omButtonbar({
    	btns : [
    	       {label:"新增规则",
       	 		 onClick:function(){
         	 		//计算高度
       	 			var heightNum = $('#tablesReview').height() + 100;
					$('#tablesReview').parent().height(heightNum).parent().height(heightNum);
					//计算序号
					var len = (($('#tablesReview').omGrid('getData')).rows.length)+1;
					var code = (len>9)?("E0"+len):("E00"+len);
       	 			$('#tablesReview').omGrid('insertRow','begin',{itemCode:code,itemStatus:"1"});
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"保存修改",
       			 id: "regButton",  
       	 		 onClick:function(){
       	 			saveReview();
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"放弃修改",
       	 		 onClick:function(){
       	 			$("#tablesReview").omGrid("cancelChanges");
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"检查公式",
       	 		 onClick:function(){
       	 			validateFormula();
      	 		 }
       		   }
    	]
    });
	//考核规则
	$('#tablesReview').omGrid({
		height : 100,
  	    limit : 0,
        showIndex : true,
        method : 'GET',
   		colModel:[{header:'代码', name:'itemCode', width:70, align:'left',editor:{rules:["required",true,"请选择"],type:"omCombo",name:"itemCode",options:checkCodeOptions},renderer:checkCodeRenderer}, 
                  {header:'描述', name:'itemName', width:'320', align:'left',editor:{rules:[["required",true,"不能为空"],["maxlength",100,"长度不能超过100"]],type:"text",editable:true,name:"itemName"}},
                  {header:'考核操作', name:'calcFormula', width:'240', align:'left',editor:{rules:["required",true,"请选择"],type:"omCombo",name:"calcFormula",options:checkOperateOptions},editable:function(){return true;},renderer:checkOperateRenderer},
                  {header:'考核规则', name:'calcCondtion', width:'500', align:'left',editor:{rules:[["required",true,"不能为空"],["maxlength",100,"长度不能超过100"]],type:"text",editable:true,name:"calcCondtion"}},
                  {header:'使用状态', name:'itemStatus', width:'80', align:'left',editor:{rules:[["required",true,"不能为空"]],type:"omCombo",name:"itemStatus",options:itemStatusOptions},renderer:itemStatusRenderer}
                 ],
	    dataSource: Util.appCxtPath + '/lawDefine/queryPageReview.do?versionId=<%=versionId%>&itemType='+<%=itemType%>,
	    onSuccess:function(data,testStatus,XMLHttpRequest,event){
	    	$(this).omGrid({height : 80 + data.rows.length * 24});
	    }
	});
	
	buttonContr();
});

function buttonContr(){
	$.ajax({ 
		url: "<%=_path%>/lawRate/queryButtonStatus.do?versionId=<%=versionId%>",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			var statusStr = $.parseJSON(data);
			//系统因素
			if(statusStr.salesSysSwitch == '0'){
				$("#sysButton").omButton("disable");
			}
			//导入因素
			if(statusStr.salesImpSwitch == '0'){
				$("#impButton").omButton("disable");
			}
			//考核因素
			if(statusStr.salesCheckSwitch == '0'){
				$("#checkButton").omButton("disable");
			}
			//计算公式
			if(statusStr.salesExpSwitch == '0'){
				$("#expButton").omButton("disable");
			}
			//考核规则
			if(statusStr.salesRegSwitch == '0'){
				$("#regButton").omButton("disable");
			}
		}
	});
}

</script>
</head>
<body>
    <!-- 参数表单 -->
	<form id="paraForm">
		<input type="hidden" name="formMap['jsonStr']" id="jsonStr" value="" />
		<input type="hidden" name="formMap['versionId']" id="versionId" value="<%=versionId%>" />
		<input type="hidden" name="formMap['itemType']" id="itemType" value="<%=itemType%>" />
	</form>
	<div>提示：双击可以编辑数据</div>
	<!-- 计算因子 -->
	<div style="float:left;width:33%;">
			<fieldSet>
				<legend>系统因素</legend>
				<div id="buttonbarFactor" style="border-style: none none solid none;"></div>
				<table id="tablesFactor"></table>
			</fieldSet>
	</div>
	<!-- 导入数据 -->
	<div>
		<fieldSet style="float:left;width:33%;">
			<legend>导入因素</legend>
			<div id="buttonbarImport" style="border-style: none none solid none;"></div>
			<table id="tablesImport"></table>
		</fieldSet>
	</div>
	<!-- 考核因素 -->
	<div>
		<fieldSet>
			<legend>考核因素</legend>
			<div id="buttonbarExamine" style="border-style: none none solid none;"></div>
			<table id="tablesExamine"></table>
		</fieldSet>
	</div>
	<!-- 计算公式 -->
	<div style="clear: both;">
		<fieldSet>
			<legend>计算公式</legend>
			<div id="buttonbarIndex" style="border-style: none none solid none;"></div>
			<table id="tablesIndex"></table>
		</fieldSet>
	</div>
	<!-- 考核公式 -->
	<div style="clear: both;">
		<fieldSet>
			<legend>考核规则</legend>
			<div id="buttonbarReview" style="border-style: none none solid none;"></div>
			<table id="tablesReview"></table>
		</fieldSet>
	</div>
</body>
</html>