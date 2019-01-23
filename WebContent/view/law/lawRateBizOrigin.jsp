<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务线调整系数</title>
<script type="text/javascript">
var bzlineData = null;
var rateType = "${param.rateType}";
var versionId = "${param.versionId}";
$(function(){
	//加载业务线
	$.ajax({ 
		url: "<%=_path%>/common/loadBline",
		type:"post",
		async: false, 
		dataType: "json",
		success: function(data){
			bzlineData = data;
		}
	});
	
    //业务线调整系数
	$('#buttonbar').omButtonbar({
    	btns : [
    	       {label:"保存修改",
    	    	  id :"businessButton", 
       	 		 onClick:function(){
       	 			saveRateData();
      	 		 }
       		   },
       		   {separtor:true},
    	       {label:"放弃修改",
       	 		 onClick:function(){
       	 			$("#tables").omGrid("cancelChanges");
      	 		 }
       		   }
    	]
    });
    
	//业务线调整系数
	$('#tables').omGrid({
  	    limit : 0,
		height : 450,
        showIndex : true,
        method : 'GET',
   		colModel:[
   		           {header:"业务来源编码",name:"rateCode",width:200, align:'center'},
                   {header:"业务来源编码",name:"rateName",width:200,align:'left'},
   				   {header:"系数值",name:"rate",width:200,align:'left',editor:{editable:true,type:"omNumberField"}}
                ],
	    dataSource:Util.appCxtPath + '/lawRate/queryLawRate.do?'+$("#filterFrm").serialize()+''
	});
	
	buttonContr();
});

function buttonContr(){
	$.ajax({ 
		url: "<%=_path%>/lawRate/queryButtonStatus.do?versionId="+versionId,
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			var statusStr = $.parseJSON(data);
			//系统因素
			if(statusStr.businessSwitch == '0'){
				$("#businessButton").omButton("disable");
			}
		}
	});
}

//保存数据
function saveRateData(){
	var rateGridData = $("#tables").omGrid("getData");
	var rowList = rateGridData["rows"];
	$.ajax({ 
		url: "<%=_path%>/lawRate/saveRowsChange",
		data:{
		   rateType:rateType,
		   versionId:versionId,
		   changeRows:JSON.stringify(rowList)
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
	                content:"保存成功"
	            });
				$('#tables').omGrid('refresh');
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

</script>
</head>
<body>
	<form id="filterFrm" style="display: none">
	    <input type="hidden" name="formMap['rateType']" value="${param.rateType }" >
		<input type="hidden" name="formMap['versionId']" value="${param.versionId }" >
	</form>
	<div>
		<div id="buttonbar" style="border-style: none none solid none;"></div>
		<table id="tables"></table>
	</div>
</body>
</html>