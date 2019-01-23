<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新年奖数据导入</title>
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
		title:"员工新年奖数据导入",
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
			 label:"保存修改",
		     id:"updatePlan" ,
		     icons : {left : '<%=_path%>/images/op-edit.png'},
	 		 onClick:function(){
	 			saveRowsChange();
	 		 }
		 }]
	 });
	
	//查询面板
	$("#search-panel").omPanel({
    	title : "薪酬管理  > 新年奖",
    	collapsible:true,
    	collapsed:false
    });
	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	//列表高度
	var bdnum1 = $("body").scrollHeight;
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
        },
	});
	//加载二级机构名称
	$('#deptCode').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#deptCode').omCombo({
				value:eval(data)[1].value,
				readOnly : true
			});
        },
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	
	//加载初始数据
	setTimeout("query()",800);
});

function getWindowWidth(){
	return $("#search-panel").width()+30;
}

function getTableHead(){
	//表头
	var tabHand = [
	    [
            {header:"年份",name:"rewardDate",width:60,align:'center'},
			{header:"所属机构",name:"simpleName",width:150,align:'center'},
			{header:"姓名",name:"rewardName",width:80,align:'center'},
			{header:"工号",name:"employNum",width:80,align:'center'},
			{header:"新年奖(元)",name:"reward",width:80,align:'center',editor:{editable:true,type:"omNumberField",option:{allowNegative:false}}},
			{header:"录入日期",name:"createdDate",width:140,align:'center'}
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


/**
 * 保存修改
 */
function saveRowsChange(){
	//先获取到更改过的行
	var rows = $("#tables").omGrid("getChanges" , "update");
	$.ajax({ 
			url: "<%=_path%>/newYearReward/saveRowsChange",
			data:{
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
	window.location.reload();
}

//加载月份
function loadMonth(){
	var curDate = new Date();
	var year = curDate.getFullYear();
	var month = curDate.getMonth();
	//=================================年份===============================================
	var yearHtml = "<option value=''>请选择</option>";
	for ( var i = 0; i < 11; i++) {
		if(i==0){
			yearHtml+="<option value='"+year+"' selected>"+year+"</option>";
		}else{
			yearHtml+="<option value='"+(year-i)+"'>"+(year-i)+"</option>";
		}
	}
	$("#rewardDate").html(yearHtml);
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

/**
 * 生成excel模板并下载
 */
 function downloadXlsModel(){
		//弹出提示
	    $.omMessageBox.waiting({
	        title:'请稍候',
	        content:'服务器正在生成模板，请稍候...',
	    });
		//生成模板
	    $.ajax({ 
			url: "<%=_path%>/newYearReward/getLawRateValueXls",
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
	$("#tables").omGrid("setData","<%=_path%>/newYearReward/queryNewYearReward.do?"+$("#filterFrm").serialize());
	$('#total').remove();
	 $.ajax({ 
			url: "<%=_path%>/newYearReward/queryAllEmployAndSalary.do?"+$("#filterFrm").serialize(),
			type:"post",
			async: true, 
			dataType: "json",
			success: function(data){
				if(data.reward==undefined){
					data.reward=0;
				}
				$('#buttonbar').append("<div style=\"line-height:25px\" id=\"total\">&nbsp;&nbsp;&nbsp;总人数 : "+data.count+"人"+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;总金额 : "+data.reward+"元</div>");
			}
		});
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
	        <div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">年份：</span></td>
					<td>
					   <select  name="formMap['rewardDate']" id="rewardDate" style="width:70px">
					      <option value="">请选择</option>
					   </select>
					    年   
					</td>
					<td></td>
					<td align="right"><span class="label">分公司：</span></td>
					<td><input class="sele" name="formMap['deptCode']"  id="deptCode" /></td>
					<td style="padding-left:15px" align="right"><span class="label">姓名：</span></td>
					<td><input class="sele" name="formMap['rewardName']" id="rewardName" /></td>
					<td align="right" colspan="6"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
			</div>
	 </form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
	<div id="impXlsArea" style="display:none">
	    <!-- 指向iframe实现无刷新 -->
	    <iframe style="width:0; height:0; margin-top:-10px;" name="submitFrame" src="about:blank"></iframe>
	    <form action="<%=_path %>/newYearReward/impNewYearRewardValueInXls" id="impXlsForm" method="post" class="easyWebForm" enctype="multipart/form-data" target="submitFrame">
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