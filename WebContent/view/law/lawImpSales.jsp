<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户经理数据导入</title>
<script type="text/javascript">
var lawImpTypeList = null;
var versionId = "${param.versionId}";
$(function(){
	//加载月份
	loadMonth();
	// 整体样式
	//$("#filterFrm").find("input").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	//二级机构
	$('#deptCode').omCombo({
        dataSource :  "<%=_path%>/department/queryDepartmentByUserCode.do?random="+Math.random(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2){
        		$('#deptCode').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
        },
        emptyText : '请选择'
    });
	
	//初始化导入窗口数据
  	$("#impXlsArea").omDialog({
		autoOpen:false,
		title:"批量导入客户经理数据",
		width:431,
		height: 261,
		modal: true
	});
	
  	$("#button-imp").omButton({
		icons : {left:'<%=_path%>/images/page_white_excel.png'},
		width:80,
		height:30,
		onClick:submitDaoRuData
	});
	
	$('#buttonbar').omButtonbar({
		 btns : [
		     {
			    label:"下载模板",
				id:"addButton",
				icons : {left : '<%=_path%>/images/page_white_excel.png'},
				onClick:downloadXlsModel
			 },{
				label:"导入数据",
				id:"addButton" ,
				icons : {left : '<%=_path%>/images/page_white_excel.png'},
				onClick:importXlsData
			 },
			 {
			 label:"保存",
		     id:"updatePlan" ,
		     icons : {left : '<%=_path%>/images/op-edit.png'},
	 		 onClick:function(){
	 			saveRowsChange();
	 		 }
		 }]
	 });
	
	$('#buttonbar').append("<span style=\"line-height:25px\">温馨提示：双击行进入数据编辑</span>");
	
	//查询面板
	$("#search-panel").omPanel({
    	title : "管理办法  > 客户经理数据导入",
    	collapsible:true,
    	collapsed:false
    });
	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	//列表高度
	var bdnum = $("body").offset().top + $("body").outerHeight();
	var bdnum1 = $("body").scrollHeight;
  	var btnum = $("#buttonbar").offset().top + $("#buttonbar").outerHeight();
	//分页表格
	$("#tables").omGrid({
      	limit : "0",
        height: bdnum1,
		colModel:getTableHead(),
		showIndex : true,
        singleSelect : true,
        method : 'POST',
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
        	setTimeout("setTdStyle()",250);
        }
	});
	//加载初始数据
	setTimeout("query()",800);
});

function getWindowWidth(){
	return $("#search-panel").width()+30;
}

function getTableHead(){
	//加载类型
	getLawImpTypeList();
	//表头
	var tabHand = [
	    [
            {header:"月份",name:"calcMonth",width:60,align:'left'},
			{header:"所属机构",name:"deptCode",width:100,align:'left',renderer:function(value,rowData,rowIndex){
				return value.substr(value.indexOf("-")+1);
			}},
			{header:"姓名",name:"salesmanCname",width:80,align:'left'}
		]
	];
    if(lawImpTypeList!=null){
    	$.each(lawImpTypeList,function(i,lawDefine){
    		//var width = lawDefine.itemName.length*14;
    		var width = 80;
    		tabHand[0].push({header:lawDefine.itemName,name:lawDefine.itemCode,width:width,align:'right',editor:{editable:true,rules:[["max",100,"最大值为100"],["min",0,"最小值为0"]],type:"omNumberField"}});
    	});
    }
	return tabHand;
}

//加载导入数值类型
function getLawImpTypeList(){
	$.ajax({ 
		url: "<%=_path%>/lawImpValue/getLawDefineList",
		data:{itemType:"0",versionId:versionId},
		type:"post",
		async: false,
		dataType: "json",
		success: function(data){
		    lawImpTypeList = data;
		}
     });
	return lawImpTypeList;
}


/**
 * 保存更改
 */
function saveRowsChange(){
	//先获取到更改过的行
	var rows = $("#tables").omGrid("getChanges" , "update");
	var versionId = $("#versionId").val();
	$.ajax({ 
			url: "<%=_path%>/lawImpValue/saveRowsChange",
			data:{
				impType:"1",
				versionId:versionId,
				changeRows:JSON.stringify(rows)
			},
			type:"post",
			async: true, 
			dataType: "json",
			success: function(data){
				//关闭提示
	            $.omMessageBox.waiting('close');
				if(data.actionFlag){
					$.omMessageBox.alert({
		                type:'success',
		                title:'操作成功!',
		                content:"恭喜你保存成功"
		            });
				}else{
					$.omMessageBox.alert({
		                type:'error',
		                title:'操作失败',
		                content:"处理失败,请重试！"
		            });
				}
			}
	});
}

//加载月份
function loadMonth(){
	var curDate = new Date();
	var year = curDate.getFullYear();
	var month = curDate.getMonth() + 1;
	//=================================年份===============================================
	var yearHtml = "<option value=''>请选择</option>";
	for ( var i = 0; i < 11; i++) {
		if((year-10+i)==year){
			yearHtml+="<option value='"+(year-10+i)+"' selected>"+(year-10+i)+"</option>";
		}else{
			yearHtml+="<option value='"+(year-10+i)+"'>"+(year-10+i)+"</option>";
		}
	}
	$("#year").html(yearHtml);
	//=================================月份===============================================
	var monthHtml = "<option value=''>请选择</option>";
	for ( var i = 1; i<=month; i++) {
		var cMonth = i;
		if(i<10){
			cMonth="0"+cMonth;
		}
		if(i==(month)){
			monthHtml+="<option value='"+cMonth+"' selected>"+cMonth+"</option>";
		}else{
			monthHtml+="<option value='"+cMonth+"'>"+cMonth+"</option>";
		}
	}
	$("#month").html(monthHtml);
}

function change(){
	var curDate = new Date();
	var year = curDate.getFullYear();
	var formerYear = $("#year").val();
	if(formerYear < year){
		var monthHtml = "<option value=''>请选择</option>";
		for ( var i = 1; i<=12; i++) {
			var cMonth = i;
			if(i<10){
				cMonth="0"+cMonth;
			}
			if(i==(month)){
				monthHtml+="<option value='"+cMonth+"' selected>"+cMonth+"</option>";
			}else{
				monthHtml+="<option value='"+cMonth+"'>"+cMonth+"</option>";
			}
		}
		$("#month").html(monthHtml);
	}else{
		loadMonth();
	}
}

/**
 * 生成excel模板并下载
 */
function downloadXlsModel(){
	var versionId = $("#versionId").val();
	if(versionId==""){
		$.omMessageBox.alert({
            type:'warning',
            title:'提示',
            content:"模板的生成需要根据管理办法来生成,请先选择管理办法！"
        });
		return;
	}
	var calcMonth = $("#year").val()+$("#month").val();
	if(calcMonth==""){
		$.omMessageBox.alert({
            type:'warning',
            title:'提示',
            content:"请选择数据月份！"
        });
		return;
	}
	
	//弹出提示
    $.omMessageBox.waiting({
        title:'请稍候',
        content:'服务器正在生成模板，请稍候...',
    });
	//生成模板
    $.ajax({ 
		url: "<%=_path%>/lawImpValue/getLawImpValueXls",
		data:{
			versionId:versionId,
			calcMonth:calcMonth,
			impType:"1"
		},
		type:"post",
		async: true, 
		dataType: "json",
		success: function(data){
			//关闭提示
            $.omMessageBox.waiting('close');
			if(data.actionFlag){
				window.location.href="<%=_path %>/"+data.fileUrl;
			}else{
				$.omMessageBox.alert({
	                type:'error',
	                title:'失败',
	                content:data.actionMsg
	            });
			}
		}
	});
}

/**
 * 提交导入表单
 */
function submitDaoRuData(){
	var impFile = $("#impFile").val();
	if(impFile==""){
		$("#confirmMsg").html("<font color=red>请选择文件后再提交！</font>");
		return;
	}else{
		var extStr = impFile.substring(impFile.length-4,impFile.length);
		if(extStr.indexOf("xls")==-1){
			$("#confirmMsg").html("<font color=red>请选择拓展名为.xls文件后再提交！</font>");
			return;
		};
	}
	
	$.omMessageBox.waiting({
        title:'请稍候',
        content:'服务器正在导入数据...',
    });
	
	$("#impXlsForm").submit();
}

/**
 * 导入excel数据
 */
function importXlsData(){
	$("#impXlsArea").omDialog("open");
}

//查询操作
function query() {
	$("#tables").omGrid("setData","<%=_path%>/lawImpValue/queryLawImpValue.do?"+$("#filterFrm").serialize());
	setTimeout("setTdStyle()",500); 
}

//设置表格样式
function setTdStyle(){
	$("td").css("padding-right","5px");
	$("th").css("padding-right","5px");
}

function closeWait(){
	$.omMessageBox.waiting('close');
}
</script>
</head>
<body>
	<form id="filterFrm">
	        <input type="hidden" name="formMap['impType']"  value="1" >
	        <input type="hidden" name="formMap['versionId']" id="versionId" value="${param.versionId }" >
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">月份：</span></td>
					<td>
					   <select  name="formMap['year']" id="year" style="width:70px" onchange="change()">
					      <option value="">请选择</option>
					   </select>
					    年   
					   <select name="formMap['month']" id="month" style="width:70px">
					      <option value="">请选择</option>
					   </select>
					   月
					</td>
					<td style="padding-left:15px" align="right"><span class="label">姓名：</span></td>
					<td><input class="sele" name="formMap['salesmanCname']" id="salesmanCname" /></td>
					<td align="right" colspan="6"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
	 </form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
	<div id="impXlsArea" style="display:none">
	    <!-- 指向iframe实现无刷新 -->
	    <iframe style="width:0; height:0; margin-top:-10px;" name="submitFrame" src="about:blank"></iframe>
	    <form action="<%=_path %>/lawImpValue/impLawImpValueInXls" id="impXlsForm" method="post" class="easyWebForm" enctype="multipart/form-data" target="submitFrame">
			<input type="hidden" name="impType" value="1" >
			<input type="hidden" name="versionId" value="${param.versionId }" >
			<table>
				<tr height="25">
					<td style="text-align:right" width="130" height="30"><span class="label">选择要导入的文件:</span></td>
					<td><input type="file" name="impFile" id="impFile" /></td>
				</tr>
				<tr>
				  <td style="text-align:center" colspan="2" height="30">
				     <button id="button-imp" type="button">导入</button>
				  </td>
				</tr>
				<tr>
				  <td style="text-align:center" colspan="2" height="30">
				          导入说明：导入文件必需有数据，否则将被过滤掉<br/>
				     <span id="confirmMsg" ></span>     
				  </td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>