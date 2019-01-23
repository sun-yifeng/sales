<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<%@include file="" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>销售人员管理办法-规则</title>
<style>
html, body{height:100%; overflow: auto;}
</style>
<script type="text/javascript">
/*----------------------------------------------- 共用方法 开始 -----------------------------------------------*/
//使用状态
var itemStatusOptions = {
    dataSource : [{text:"请选择",value:""},{text:"正在使用", value:"1"},{text:"停止使用",value:"0"}],
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
/*----------------------------------------------- 共用方法 结束 -----------------------------------------------*/
/*----------------------------------------------- 客户经理 开始 -----------------------------------------------*/
//因子
var colModel11 =
    [{header : '代码', name : 'itemCode', width : 70, align : 'left'}, 
     {header : '描述', name : 'itemName', width : '300', align : 'left',editor:{rules:[["required",true,"不能为空"],["maxlength",50,"长度不能超过50"]],type:"text",editable:true,name:"itemName"}},
     {header : '计算公式', name : 'calcFormula', width : '300', align : 'left'},
     {header : '计算条件', name : 'calcCondtion', width : '300', align : 'left'},
     {header : '使用状态', name : 'itemStatus', width : '100', align : 'left',editor:{type:"omCombo",name:"itemStatus",options:itemStatusOptions},renderer:itemStatusRenderer}
    ];
//指标代码
var indexCodeOptions = {
  		    dataSource : <%=getCombo("indexCode")%>,
  		    editable: false
   	};
//指标代码	
function indexCodeRenderer(value){
	return value;
}
//指标表头	
var colModel13 = 
	[{header : '代码', name : 'itemCode', width : 70, align : 'left',editor:{rules:["required",true,"请选择"],type:"omCombo",name:"itemCode",options:indexCodeOptions},renderer:indexCodeRenderer}, 
     {header : '描述', name : 'itemName', width : '300', align : 'left',editor:{rules:[["required",true,"不能为空"],["maxlength",100,"长度不能超过100"]],type:"text",editable:true,name:"itemName"}},
     {header : '计算公式', name : 'calcFormula', width : '300', align : 'left',editor:{rules:[["required",true,"不能为空"],["maxlength",100,"长度不能超过100"]],type:"text",editable:true,name:"calcFormula"}},
     {header : '计算条件', name : 'calcCondtion', width : '300', align : 'left',editor:{rules:["maxlength",100,"长度不能超过100"],type:"text",editable:true,name:"calcCondtion"}},
     {header : '使用状态', name : 'itemStatus', width : '100', align : 'left',editor:{type:"omCombo",name:"itemStatus",options:itemStatusOptions},renderer:itemStatusRenderer}
    ];
//保存因子
function saveTables11(){
	var jsonArr = $('#tables11').omGrid('getChanges').update;
	var jsonStr = JSON.stringify(jsonArr,['pkId','itemName','itemStatus']);
	if(jsonArr.length < 1) return;
	$("#jsonStr11").val(jsonStr);
	Util.post(Util.appCxtPath + '/lawDefine/updateLawFactor.do', $('#form11').serialize(), function(data) {
		$.omMessageBox.alert({
	        type:'success',
	        title:'提示',
	        content:'保存成功',
	        onClose:function(v){
			    $('#tables11').omGrid('reload');
	         }
       });
	});
}
//保存指标
function saveTables13(){
	var jsonArr = $('#tables13').omGrid('getChanges').update;
	var jsonStr = JSON.stringify(jsonArr,['pkId',"itemCode",'itemName','calcFormula','calcCondtion','itemStatus']);
	if(jsonArr.length < 1) return;
	$("#jsonStr13").val(jsonStr);
	Util.post(Util.appCxtPath + '/lawDefine/updateLawIndex.do', $('#form13').serialize(), function(data) {
		$.omMessageBox.alert({
	        type:'success',
	        title:'提示',
	        content:'保存成功',
	        onClose:function(v){
			    $('#tables13').omGrid('reload');
	         }
       });
	});
}
/*----------------------------------------------- 客户经理 结束 -----------------------------------------------*/ 
//
$(function() {
	//切换页签
	$('#make-tab').omTabs({
	    switchMode : 'mouseover',
	    closable : false
	});
    /* ------------------------- tab1 开始 -------------------------- */
    //按钮11
	$('#buttonbar11').omButtonbar({
    	btns : [
    	        {label:"保存修改",
       		     id:"buttonSave11" ,
       	 		 onClick:function(){
       	 			saveTables11();
      	 		 }
       		    },
        	   {separtor:true},
      	       {label:"放弃修改",
       		     id:"buttonCancel11",
       	 		 onClick:function(){
       	 			$("#tables11").omGrid("cancelChanges");
      	 		 }
         		   }
    	]
    });
    //因子11
	$('#tables11').omGrid({
  	    limit : 0,
        showIndex : true,
        method : 'GET',
   		colModel : colModel11,
	    dataSource : Util.appCxtPath + '/lawDefine/queryPageFactor.do?versionId=1&itemType=0',
	    onSuccess:function(data,testStatus,XMLHttpRequest,event){
	    	$(this).omGrid({height : 80 + data.rows.length * 24});
	    }
	});
    //导入12
    
    //指标按钮13
	$('#buttonbar13').omButtonbar({
    	btns : [
    	       {label:"新增公式",
       		     id:"buttonNew13",
       	 		 onClick:function(){
       	 			$('#tables13').omGrid('insertRow','end',{id:100});;
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"保存修改",
       		     id:"buttonSave13",
       	 		 onClick:function(){
       	 			saveTables13();
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"放弃修改",
       		     id:"buttonCancel13",
       	 		 onClick:function(){
       	 			$("#tables13").omGrid("cancelChanges");
      	 		 }
       		   }
    	]
    });
	//指标13
	$('#tables13').omGrid({
  	    limit : 0,
        showIndex : true,
        method : 'GET',
   		colModel: colModel13,
	    dataSource: Util.appCxtPath + '/lawDefine/queryPageIndex.do?versionId=1&itemType=0',
	    onSuccess:function(data,testStatus,XMLHttpRequest,event){
	    	$(this).omGrid({height : 80 + data.rows.length * 24});
	    }
	});
	/*考核
	$('#tables14').omGrid({
  	    limit : 0,
        showIndex : true,
        method : 'GET',
	    dataSource: Util.appCxtPath + '/lawDefine/queryPageIndex.do?versionId=11&itemType=2',
	    onSuccess:function(data,testStatus,XMLHttpRequest,event){
	       this.omGrid({height : 60 + data.rows.length * 24});
	    },
   		colModel:[{header : '代码', name : 'itemCode', width : 70, align : 'left'}, 
                  {header : '描述', name : 'itemName', width : '300', align : 'left'},
                  {header : '计算公式', name : 'calcFormula', width : '300', align : 'left'},
                  {header : '计算条件', name : 'calcCondtion', width : '300', align : 'left'},
                  {header : '使用状态', name : 'itemStatus', width : '100', align : 'left'}
                 ]
	});*/
	//保存/取消
	$("#button-save-1").omButton({});
	$("#button-canc-1").omButton({});
	/* ------------------------- tab1  结束--------------------------- */
	
    /* ------------------------- tab2 开始 -------------------------- */
	/* ------------------------- tab2 结束--------------------------- */
	
    /* ------------------------- tab3 开始 -------------------------- */
	/* ------------------------- tab3  结束--------------------------- */
});
</script>
</head>
<body>
<div id="make-tab" >
        <ul>
            <li><a href="#tab1">客户经理规则</a></li>
            <li><a href="#tab2">团队经理规则</a></li>
            <li><a href="#tab3">险种调整系数</a></li>
            <li><a href="#tab4">业务线调整系数</a></li>
            <li><a href="#tab5">车型调整系数</a></li>
            <li><a href="#tab6">渠道调整系数</a></li>
            <li><a href="#tab7">成本调整系数</a></li>
        </ul>
        <!----------------------------------------------- 1.客户经理规则 ----------------------------------------------->
        <div id="tab1"  >
            <div>提示：双击可以编辑数据</div>
        	<!-- 1.1 计算因子 -->
			<div>
				<form id="form11">
				<input type="hidden" name="formMap['jsonStr']" id="jsonStr11" value=""/>
				<fieldSet>
					<legend>因子</legend>
					<div id="buttonbar11" style="border-style:none none solid none;"></div>
					<table id="tables11"></table>
				</fieldSet>
				</form>
			</div>
        	<!-- 1.2 导入数据
			<div>
				<fieldSet>
					<legend>指标</legend>
					<div id="buttonbar12" style="border-style:none none solid none;"></div>
					<table id="tables12"></table>
				</fieldSet>
			</div>  -->
        	<!-- 1.2 计算公式 -->
			<div>
			    <form id="form13">
				<input type="hidden" name="formMap['jsonStr']" id="jsonStr13" value=""/>
				<fieldSet>
					<legend>公式</legend>
					<div id="buttonbar13" style="border-style:none none solid none;"></div>
					<table id="tables13"></table>
				</fieldSet>
				</form>
			</div>
        	<!-- 1.3考核公式-->
			<div>
				<fieldSet>
					<legend>考核</legend>
<!-- 					<div id="buttonbar14" style="border-style:none none solid none;"></div> -->
					<table id="tables14"></table>
				</fieldSet>
			</div>
			<!-- 保存/取消 
			<div>
				<table style="width:100%; margin-top:20px;">
					<tr>
						<td align="center">
						<a id="button-save-1" onclick="saveTab1()">保存修改</a>
						<a id="button-canc-1" onclick="cancTab1()">放弃修改</a>
						</td>
					</tr>
				</table>
			</div> -->
        </div>
        <!----------------------------------------------- 2.团队经理规则 ----------------------------------------------->
        <div id="tab2"  >
        </div>
        <!----------------------------------------------- 3.标准保费系数 ----------------------------------------------->
        <div id="tab3"  >
        </div>
</div>
</body>
</html>