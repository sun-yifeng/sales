<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>销售人员管理办法调整系数(已废除)</title>
<script type="text/javascript">
$(function(){
	//二级公司
	$.ajax({ 
		url : "<%=_path%>/common/findDeptByUserCode.do",
		type : "post",
		async : false, 
		dataType : "HTML",
		success : function(data){
			currentDept = data;
			$("#filterForm").find("#deptCode").omCombo({
				dataSource : <%=getCombo("deptTwo")%>,
				onSuccess : function(){
					if(currentDept != '00'){
						$("#filterForm").find("#deptCode").omCombo({value:currentDept,readOnly:true});
					}
				},
				emptyText : "请选择",
				width : 150
		    });
		}
	});
	//导航面板
	$("#search-panel").omPanel({
    	title : "销售人员管理办法  > 管理办法调整系数",
    	collapsible : true,
    	collapsed : false
    });	
    //按钮面板
	$('#buttonbar').omButtonbar({
    	btns : [{label :"新增",
			     id : "buttonNew" ,
			     icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
		 		 onClick:function(){;}
				},
				{separtor : true},
    	        {label : "修改",
    			 id : "buttonEdit",
    		     disabled :  false,
    			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
    	 		 onClick:function(){;}
    	       },
    	       {separtor:true},
    	       {label :"删除",
			    id:"buttonDel" ,
			    icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/remove.png'},
		 		onClick :function(){;}
    		   },
    	       {separtor:true},
    	       {label :"导入",
			    id:"buttonImp" ,
			    icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
		 		onClick:function(){;}
    		   },
    	       {separtor:true},
    	       {label :"导出",
			    id :"buttonExp" ,
			    icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
		 		onClick :function(){;}
    		   }
    	]
    });
	//各业务线
	$("#filterForm").find("#lineCode").omCombo({
		dataSource: <%=getCombo("bizLine")%>,
		onValueChange : function(target, newValue, oldValue) {
			$("#filterForm").find("#lineCode").val(newValue);
	    },
		emptyText: '请选择',
		width:150
	});
	//系数类型
	$("#filterForm").find("#rateType").omCombo({
		dataSource : <%=getCombo("rateType")%>,
		onValueChange : function(target, newValue, oldValue) {
			$("#filterForm").find("#rateType").val(newValue);
	    },
		emptyText : "请选择",
		width:150
    });
	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	//查询操作
	setTimeout("query()", 500);
});
//查询操作
function query(){
 	//查询列名
	$.ajax({
		url : "<%=_path%>/lawRate/queryRateCol.do?rateType="+$("#rateType").val(),
		type : "POST",
		async : false,
		dataType : "JSON",
		success : function(data){
			//表格高度
			var bdnum = $("body").offset().top + $("body").outerHeight();
		  	var btnum = $("#buttonbar").offset().top + $("#buttonbar").outerHeight();
			var topnum = bdnum - btnum;
			//填充表格
			dataGrid = $("#tables").omGrid({
				dataSource : "<%=_path%>/lawRate/queryLawRate.do?"+$("#filterForm").serialize(),
				colModel : data,
				showIndex : false,
		        singleSelect : false,
		        height : topnum,
		        method : 'POST',
		      	limit: 20
			});
		}	
	});
}
</script>
</head>
<body>
	<form id="filterForm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px;"><span class="label">分公司：</span></td>
					<td><input type="text" name="formMap['deptCode']" id="deptCode" style="width:150px;" /></td>
					<td style="padding-left:15px;"><span class="label">业务线：</span></td>
					<td><input type="text" name="formMap['lineCode']" id="lineCode" style="width:150px;"/></td>
					<td style="padding-left:15px;"><span class="label">系数类型：</span></td>
					<td><input type="text" name="formMap['rateType']" id="rateType" style="width:150px;"/></td>
				    <td colspan="4" style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<div id="lawRateDiv" style="display: none">
		<form id="lawRateForm" name="lawRateForm">
		    <input type="hidden" name="pkId" id="pkId" value="" />
			<div>
				<table class="grid_layout" style="margin: 0 auto">
					<tr>
						<td style="padding-left:15px" align="right">机构名称：</td>
						<td><input type="text" style="width: 180px;" name="deptCodeName" id="deptCodeName" readonly="readonly"/></td>
					</tr>
					<tr>
						<td style="padding-left:15px" align="right">系数类型：</td>
						<td><input type="text" style="width: 180px;" name="rateTypeName" id="rateTypeName" readonly="readonly"/></td>
					</tr>
					<tr>
						<td style="padding-left:15px" align="right">系数代码：</td>
						<td><input type="text" style="width: 180px;" name="rateCode" id="rateCode"  readonly="readonly"/></td>
					</tr>
					<tr>
						<td align="right">系数名称：</td>
						<td><input type="text" style="width: 180px;" name="rateName" id="rateName" readonly="readonly"/></td>
					</tr>
					<tr>
						<td align="right">系数值：</td>
						<td class="td"><input type="text" style="width: 180px;" name="rate1" id="rate1"  /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
				</table>
			</div>
			<div>
				<table style="width: 100%">
					<tr>
						<td style="padding-left:15px;padding-top:10px" align="center">
						<a id="button-save"    onclick="saveClick()">保存</a>
						<a id="button-cancel"  onclick="cancelClick()">取消</a></td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</body>
</html>