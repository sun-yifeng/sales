<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>管理办法</title>
<style>
input{height:18px;width:181px;border:1px solid #a1b9df;vertical-align:middle;border:1px solid #a1b9df}
input:focus{border:1px solid #3a76c2}
input[readonly='readonly']:not(.sele),textarea[readonly='readonly'],input[readonly='true'],textarea[readonly='true']{background-color:#f0f0f0;color:gray}
.errorImg{background:url("<%=_path%>/images/msg.png") no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error,textarea.error{border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px}
</style>
<script type="text/javascript">
//使用状态
var versionStatusOptions = {
    dataSource : [{text:"正在使用", value:"1"},{text:"停止使用",value:"0"}],
    editable: false
};

//使用状态渲染
function versionStatusRenderer(value){
	if("1" === value){
		return '<span style="color:green;"><b>正在使用</b></span>';
    }else if("0" === value){
        return '<span style="color:red;"><b>停止使用</b></span>';
    }else{
        return "";
    }
 }
var deptTwoData=null;
//分公司
var deptCodeOptions = null;
   
//分公司渲染
function deptCodeRenderer(value, rowData) {
	if (value == ''){
		 return '';
	}
	var deptText = "";
	$.each(deptTwoData,function(i,dept){
		if(dept.value==value){
			deptText = dept.text;
		}
	});
	return deptText;
}

var LineCodeData = null;
//业务线
var lineCodeOptions = null;

//业务线渲染
function lineCodeRenderer(value, rowData) {
	var arr = lineCodeOptions.dataSource;
	for (var i=0; i<arr.length; i++){
      if(arr[i].value == value) {
	       return arr[i].text;
        }
	}
}

//保存管理办法
function saveLaw(){
	var gridObj = $('#tables').omGrid('getChanges');
	var jsonArr = (gridObj.insert).concat(gridObj.update);
	var jsonStr = JSON.stringify(jsonArr,['versionId',"deptCode",'lineCode','lawBgnDate','lawEndDate','versionStatus','versionCname','defineMemo','defineMemo','versionId']);
	if(jsonArr.length < 1) return;
	$("#jsonStr").val(jsonStr);
	Util.post(Util.appCxtPath + '/lawDefine/saveLawDefine.do', $('#paraForm').serialize(), function(data) {
		$.omMessageBox.alert({
	        type:'success',
	        title:'提示',
	        content:'保存成功',
	        onClose:function(v){
			    $('#tables').omGrid('reload');
	        	//window.location.href = "lawDefine.jsp";
	        }
       });
	});
}

function isShowManualCalculation(){
	$.ajax({
		url:"<%=_path%>/lawDefine/isShowManualCalculation.do",
		data:{},
		dataType:"json",
		async:false,
		cache:false,
		success:function(msg){
			if(msg.status){
				$("#buttonManualCalculation").omButton("enable");
				$("#buttonManualCalculation").parent().parent().prev().show();
				$("#buttonCopy").omButton("enable");
				$("#buttonCopy").parent().parent().prev().show();
				$("#buttonAutoCalculation").omButton("enable");
				$("#buttonAutoCalculation").parent().parent().prev().show();
			}else{
				$("#buttonManualCalculation").parent().parent().prev().hide();
				$("#buttonManualCalculation").parent().parent().hide();
				$("#buttonCopy").parent().parent().prev().hide();
				$("#buttonCopy").parent().parent().hide();
				$("#buttonAutoCalculation").parent().parent().prev().hide();
				$("#buttonAutoCalculation").parent().parent().hide();
			}
		}		
	});
}

// 显示计算完成提示
function showResult(obj){
	Util.post({
		url: "<%=_path%>/lawDefine/validateTaskStatus.do",		
		type:"post",
		async: true, 
		dataType:"json",
		success:function(data){
			if(data){
				$("#buttonAutoCalculation").omButton("enable");
				$.omMessageBox.waiting("close");
				$.omMessageBox.alert({
			           content:'服务器正忙，请稍候再试...',
				});
			}else{
				$.ajax({
					url:"<%=_path%>/lawDefine/manualCalc.do", //执行计算的方法
					data:obj,
					dataType:"json",
					success:function(msg){
						$("#buttonAutoCalculation").omButton("enable");
						$.omMessageBox.waiting("close");
						$.omMessageBox.alert({
				           content:'执行完成',
					    });
					},
					error:function(){
						$("#buttonAutoCalculation").omButton("enable");
						$.omMessageBox.waiting("close");
						$.omMessageBox.alert({
				           content:'服务器正忙，请稍候再试...',
					    });
					}
				});
			}
		}
	
	});
}

//数据加载
$(function(){
	var firstDeptCode = "";
	var firstLineCode = "";
	//加载分公司
	$.ajax({ 
		url: "<%=_path%>/lawDefine/getCurDeptTwo",
		type:"post",
		async: false, 
		dataType: "json",
		success: function(jsonData){
			deptTwoData = jsonData;
			firstDeptCode = deptTwoData[0].value;
			deptCodeOptions = {
				dataSource : deptTwoData,
				editable: false
			};
		}
	});
	
	//加载业务线
	$.ajax({ 
		url: "<%=_path%>/lawDefine/getCurLineCode",
		type:"post",
		async: false, 
		dataType: "json",
		success: function(jsonData){
			LineCodeData = jsonData;
			firstLineCode = LineCodeData[0].value;
			lineCodeOptions = {
				dataSource : LineCodeData,
				editable: false
			};
		}
	});
	
	//分公司
	$.ajax({ 
		url: "<%=_path%>/common/findDeptByUserCode.do",
		type: "post",
		async: false, 
		cache: false,
		dataType: "HTML",
		success: function(currentDept){
			$("#filterForm").find("#deptCode").omCombo({
				dataSource : deptTwoData,
				onSuccess : function(){
					if(currentDept != '00'){
						$("#filterForm").find("#deptCode").omCombo({value:currentDept,readOnly : true});
					}
				},
				emptyText : "请选择"
		    });
		}
	});
	
	//业务线
	$("#bizLine").omCombo({
		dataSource: LineCodeData,
		emptyText: '请选择'
	});
	
	//导航菜单
	$("#search-panel").omPanel({
    	title : "管理办法版本定义",
    	collapsible:true,
    	collapsed:false
    });
	
	//按钮菜单
	$('#buttonbar').omButtonbar({
    	btns : [{label:"新增管理办法",
    		     id:"buttonNew" ,
    		     icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
       	 		 onClick:function(){
         	 		var bgn = (new Date()).getFullYear() + '-01-01';
         	 		var end = (new Date()).getFullYear() + '-12-31';
        	 		$('#tables').omGrid('insertRow','begin',{deptCode:firstDeptCode,lineCode:firstLineCode,lawBgnDate:bgn,lawEndDate:end,versionStatus:"1",versionCname:"自动生成",createdDate:"自动生成",updatedDate:"自动生成",lastStartTm:"自动生成"});
      	 		 }
    			},
    			{separtor:true},
    	        {label:"编辑管理办法",
    			 id:"buttonEdit",
    		     disabled :  false,
    			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
    	 		 onClick:function(){
    	 			var arr = $('#tables').omGrid('getSelections',true);
    	 			if (arr.length == 0) {
    	 				$.omMessageBox.alert({
			                content:'请先选中一行再点击【编辑管理办法】'
			            });
		                return;
      	 			};
    	 			//$("#tables").omGrid("editRow" , arr[0]);
      	 			window.location.href = "lawRule.jsp?versionId="+arr[0].versionId;
    	 	     }
  	 	        },
    			{separtor:true},
    	        {label:"保存管理办法",
    			 id:"buttonSave",
    		     disabled :  false,
    			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
    	 		 onClick:function(){
    	 			saveLaw();
    	 	       }
  	 	        },
    			{separtor:true},
    	        {label:"手动执行计算",
    			 id:"buttonManualCalculation",
    		     disabled :  true,
    			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
    	 		 onClick:function(){
     	 			var arr = $('#tables').omGrid('getSelections',true);
    	 			if (arr.length == 0) {
    	 				$.omMessageBox.alert({
			                content:'请先选中一行再点击【手动执行计算】'
			            });
		                return;
      	 			} else {
      	 				window.location.href = "lawDefineManual.jsp?versionId="+arr[0].versionId + "&versionCname="+arr[0].versionCname + "&deptCode="+arr[0].deptCode;
      	 			}
      	 			
      	 			/*$.omMessageBox.confirm({
      	 	            title:'确认信息',
      	 	            content:'是否执行计算?',
      	 	            onClose:function(v){
      	 	                if(v){
      	 	                	$("#buttonManualCalculation").omButton("disable");
      	 	                	$.omMessageBox.waiting({
      	 	                    	title:'请等待',
      	 	                    	content:'服务器正在处理中...'
      	 	                 	});
      	 	                	showResult(arr[0]);
      	 	                }
      	 	            }
      	 	        });*/
    			    //window.location.href = "lawRuleCopy.jsp?versionId="+arr[0].versionId+"&versionCname="+arr[0].versionCname;
    	          }
	            },
	            {separtor:true},
	            {label:"自动执行计算",
	    			 id:"buttonAutoCalculation",
	    		     disabled :  false,
	    			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
	    	 		 onClick:function(){
	    	 			var arr = $('#tables').omGrid('getSelections',true);
	    	 			if (arr.length == 0) {
	    	 				$.omMessageBox.alert({
				                content:'请先选中一行再点击【自动执行计算】'
				            });
			                return;
	      	 			} else {
	      	 				$.omMessageBox.confirm({
	          	 	            title:'确认信息',
	          	 	            content:'是否自动执行计算?',
	          	 	            onClose:function(v){
	          	 	                if(v){
	          	 	                	$("#buttonAutoCalculation").omButton("disable");
	          	 	                	$.omMessageBox.waiting({
	          	 	                    	title:'请等待',
	          	 	                    	content:'服务器正在处理中...'
	          	 	                 	});
	          	 	                	showResult(arr[0]);
	          	 	                }
	          	 	            }
	          	 	        });
	      	 			}
	    	          }
		            },
	            {separtor:true},
	            {label:"年终通算",
	    			 id:"yearEndCalcButton",
	    		     disabled :  false,
	    			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
	    	 		 onClick:function(){
	    	 			var arr = $('#tables').omGrid('getSelections',true);
	    	 			if (arr.length == 0) {
	    	 				$.omMessageBox.alert({
				                content:'请先选中一行再点击【年终通算】'
				            });
			                return;
	      	 			} else {
	      	 				
	      	 			}
	    	          }
		            },
    			{separtor:true},
    	        {label:"复制管理办法",
    			 id:"buttonCopy",
    		     disabled :  false,
    			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
    	 		 onClick:function(){
     	 			var arr = $('#tables').omGrid('getSelections',true);
    	 			if (arr.length == 0) {
    	 				$.omMessageBox.alert({
			                content:'请先选中一个管理办法作为复制的数据源'
			            });
		                return;
      	 			};
    			    window.location.href = "lawDefineRuleCopy.jsp?versionId="+arr[0].versionId+"&versionCname="+arr[0].versionCname;
    	          }
	            }    
    	]
    });
	
	//是否显示手动执行计算按钮
	isShowManualCalculation();
	
	//$('#buttonbar').append("<span style=\"line-height:25px\">&nbsp;提示：双击行编辑基本信息</span>");
	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	//列表高度
	var bdnum = $("body").offset().top + $("body").outerHeight();
  	var btnum = $("#buttonbar").offset().top + $("#buttonbar").outerHeight();
  	//分页表格
	dataGrid = $("#tables").omGrid({
		limit:100,
		autoFit : true,
		showIndex : true,
        singleSelect : true,
        height : bdnum - btnum,
        method : 'POST',
		colModel : [
          {header:"分公司",name:"deptCode",width:100,align:'left',editor:{rules:["required",true,"请选择"],type:"omCombo",name:"deptCode",options:deptCodeOptions},renderer:deptCodeRenderer},
       	  {header:"业务线",name:"lineCode",width:100,align:'center',editor:{rules:["required",true,"请选择"],type:"omCombo",name:"lineCode",options:lineCodeOptions},renderer:lineCodeRenderer},
       	  {header:"生效日期",name:"lawBgnDate",width:100,align:'center',editor:{rules:["required",true,"请选择"],type:"omCalendar",name:"lawBgnDate"}},
       	  {header:"失效日期",name:"lawEndDate",width:100,align:'center',editor:{rules:["required",true,"请选择"],type:"omCalendar",name:"lawEndDate"}},
       	  {header:"启用状态",name:"versionStatus",width:100,align:'center',editor:{rules:["required",true,"请选择"],type:"omCombo",name:"versionStatus",options:versionStatusOptions},renderer:versionStatusRenderer},
       	  {header:"版本名称",name:"versionCname",width:300,align:'left'},
       	  {header:"创建时间",name:"createdDate",width:200,align:'center'},
       	  {header:"修改时间",name:"updatedDate",width:200,align:'center'},
       	  {header:"最后一次计算时间",name:"lastStartTm",width:200,align:'center'},
       	  {header:"最后一次更新时间",name:"lastUpdateTm",width:200,align:'center'},
		],
		onBeforeEdit:function(rowIndex , rowData){
			$.ajax({ 
				url: "<%=_path%>/lawDefine/getCurDeptTwo",
				type:"post",
				async: false, 
				dataType: "json",
				success: function(jsonData){
					deptTwoData = jsonData;
					firstDeptCode = deptTwoData[0].value;
				}
			});
		}
		/*,
      	onRowDblClick : function(rowIndex,rowData,event){
      		window.location.href = "lawRule.jsp?versionId="+rowData.versionId;
        }*/
	});
	//页面查询
	setTimeout("query()", 500);
});
//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/lawDefine/queryLawDefine.do?"+$("#filterForm").serialize());
}

</script>
</head>
<body>
    <!-- 参数表单 -->
	<form id="paraForm">
		<input type="hidden" name="formMap['jsonStr']" id="jsonStr" value="" />
		<input type="hidden" name="deptCode1" id="deptCode1" value="" />
	</form>
	<!-- 查询表单 -->
	<form id="filterForm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left: 15px" align="right">分公司：</td>
					<td><input type="text" name="formMap['deptCode']" id="deptCode" /></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left: 15px;"><span class="label">业务线：</span></td>
					<td><input type="text" name="formMap['lineCode']" id="bizLine" style="width: 150px;" /></td>
					<td style="padding-left: 15px;"><span class="label">启用状态：</span></td>
					<td><input type="text" name="formMap['versionStatus']" id="versionStatus" style="width: 150px;" /></td>
					<td style="padding-left: 15px;"><span class="label">管理办法名称：</span></td>
					<td><input type="text" name="formMap['versionCname']" id="versionCname" style="width: 150px;" /></td>
					<td colspan="4" style="padding-left: 30px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
</body>
</html>