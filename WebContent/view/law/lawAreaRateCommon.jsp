<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%String versionId = (String) request.getParameter("versionId");%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<style type="text/css">
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
/*校验错误提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer;}
input.error, textarea.error {border:1px solid red}
.errorMsg{color:red;border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px;}
/*机构菜单*/
.deptDropListTree{height:250px;width:151px;border:1px solid #9aa3b9;overflow:auto;display:none;position:absolute;background:#FFF;z-index:4;}
</style>
<title>销售人员管理办法-配置项</title>
<script type="text/javascript">
var versionId = '<%=versionId %>';

$(function(){
	
	$('#versionId').val(versionId);
	
	$('#salaryCalPinDu').omCombo({
		dataSource : [{"text":"月","value":"1"},
                      {"text":"季度","value":"2"},
                      {"text":"半年度","value":"3"},
                      {"text":"年度","value":"4"}],
        editable : false,
        value : '2',
        emptyText : '请选择'
    });
	
	$('#levelCalPindu').omCombo({
		dataSource : [{"text":"月","value":"1"},
                      {"text":"季度","value":"2"},
                      {"text":"半年度","value":"3"},
                      {"text":"年度","value":"4"}],
        editable : false,
        value : '3',
        emptyText : '请选择'
    });
	
	$('#clientManagerKaoHe').omCombo({
		dataSource : [{"text":"是","value":"0"},
                      {"text":"否","value":"1"}],
        editable : false,
        value : '1',
        emptyText : '请选择'
    });
	
	Util.post("<%=_path%>/lawRate/queryLawRateConfigByVersionId.do?versionId="+versionId,"",function(data) {
		$('#salaryCalPinDu').omCombo({value : data.salaryCalPinDu});
		$('#clientManagerKaoHe').omCombo({value : data.clientManagerKaoHe});
		$('#levelCalPindu').omCombo({value : data.levelCalPindu});
		$('#salesDirectorBuTie').val(data.salesDirectorBuTie);
		$('#workingAgeCalBegin').val(data.workingAgeCalBegin);
		$('#tmpEmploySalaryRate').val(data.tmpEmploySalaryRate);
	});
	
	//起期
	$("#workingAgeCalBegin").omCalendar({
		dateFormat:"yy-mm-dd"		
	});
	
	$('#buttonbar').omButtonbar({
		 btns : [
		    {
				 label:"保存修改",
			     id:"updateModel",
		 		 onClick:function(){
		 			save();
		 		 }
			 },{
				 label:"取消修改",
			     id:"cancelUpdate" ,
		 		 onClick:function(){
		 			cancel();
		 	     }
	 		 }]
	 });
	
	// 区域系数
	$('#tablesAreaRate').omGrid({
	    limit : 0,
	    showIndex : true,
	    method : 'GET',
	    colModel : [{header : '机构代码', name : 'deptCode', width : 150, align : 'center'}, 
	                {header : '机构名称', name : 'deptCname', width : '450', align : 'left'},
	                {header : '区域系数', name : 'areaRate', width : '120', align : 'center',editor:{rules:[["required",true,"不能为空"],["isDecimal",true,"不是有效数字"]],type:"text",editable:true,name:"normPremium"}}
	                ],
	    dataSource : Util.appCxtPath + '/lawRate/queryAreaRate.do?versionId=<%=versionId%>',
	    onSuccess : function(data, testStatus, XMLHttpRequest, event) {
	            $(this).omGrid({height : 80 + data.rows.length * 24});
	        },
		onPageChange:function(type,newPage,event){
			
		}
	 });

	 // 按钮样式 
	 $("#button-save").omButton({width:70});
	 $("#button-cancel").omButton({width:70});
	 
	 buttonContr();
	 
	 initValidate();//初始化校验
	 
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
			if(statusStr.areaSwitch == '0'){
				$("#updateModel").omButton("disable");
			}
		}
	});
}

var areaRuleConfigRule = {
	salesDirectorBuTieformMap:{  
		number : true
	  },
	  tmpEmploySalaryRateformMap:{
		  number:true
	  }  
};

var areaRuleConfigRuleMessages = {
	salesDirectorBuTieformMap:{
		number : '<span style="color:red">只能为数字</span>'
	  },
	  tmpEmploySalaryRateformMap:{
		  number : '<span style="color:red">只能为数字</span>'
	  }
};
//校验全局调用
var remote;
//校验
function initValidate(){
	//将name属性修改进行验证
	$("#filterForm").find("input[name^='formMap']").each(function(){
		$(this).attr("name",$(this).attr("id")+"formMap");
	});
remote = $("#filterForm").validate({
		rules: areaRuleConfigRule,
	    messages: areaRuleConfigRuleMessages,
	    /* errorPlacement: function(error, element) {
	        if (error.html()) {
	            $(element).parents().map(function() {
	                if (this.tagName.toLowerCase() == 'td') {
	                    var attentionElement = $(this).next().children().eq(0);
	                    attentionElement.css({'display':'block'});
	                    attentionElement.next().html(error);
	                }
	            });
	        }
	    },
	    showErrors: function(errorMap, errorList) {
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
	    }, */
     submitHandler : function() {
    	 var insertData = $('#tablesAreaRate').omGrid("getChanges","insert");
     	var updateData = $('#tablesAreaRate').omGrid("getChanges","update");
     	var deleteData = $('#tablesAreaRate').omGrid("getChanges","delete");
     	if(insertData.length>0 || updateData.length>0 || deleteData.length>0){
     		$('#updateFlag').val(1);
     	}else{
     		$('#updateFlag').val(0);
     	}
     	
     	var jsonData = JSON.stringify($('#tablesAreaRate').omGrid('getData'));
     	var jsonRows = eval("["+jsonData+"]")[0].rows;
     	var baseJsonStr;
     	if(jsonRows.length > 0){
     		baseJsonStr = "[";
     		for(var i = 0;i < jsonRows.length;i++){
     			var deptCode = jsonRows[i].deptCode;
     			var deptCname = jsonRows[i].deptCname;
     			var areaRate = jsonRows[i].areaRate;
     			if(deptCode != undefined){//修改产品手续费
     				baseJsonStr += "{\"deptCode\":\""+deptCode+"\",\"deptCname\":\""+deptCname+"\",\"areaRate\":\""+areaRate+"\"},";
     			}else{//新增产品手续费
     				baseJsonStr += "{\"productCode\":\""+productCode+"\",\"commissionRate\":\""+commissionRate+"\",\"endorseRate\":\""+endorseRate+"\"},";
     			}
     		}
     		var index = baseJsonStr.lastIndexOf(",");
     		baseJsonStr = baseJsonStr.substring(0, index);
     		baseJsonStr += "]";
     	}else{
     		baseJsonStr = "[]";
     	}
     	$('#areaRateJsonStr').val(baseJsonStr);
     	
     	
     	//将name属性还原，提交保存
     	$("#filterForm").find("input[name$='formMap']").each(function(){
     		$(this).attr("name","formMap['"+$(this).attr("id")+"']");
     	});
    	 //提交保存入库
 		Util.post("<%=_path%>/lawRate/saveLawAreaRate.do",$("#filterForm").serialize(), 
				function(data) {
	 			   $.omMessageBox.alert({
	 				   type:'success',
                       title:'成功',
			           content:'修改配置型成功!',
			       }); 
	 			  window.location.reload(true);
				
    	});
     }
 });
}

function save(){
	 $("#filterForm").submit();
}

function cancel(){
	 window.location.reload(true);
}
</script>
</head>
<body>
    <!-- 查询表单 -->
    <form id="filterForm">
        <div id="search-panel">
        	<!-- 版本编码 -->
        	<input type="hidden" name="formMap['versionId']" id="versionId"/>
        	<!--所有区域系数信息封装json字符串 -->
        	<input type="hidden" name="formMap['areaRateJsonStr']" id="areaRateJsonStr" />
        	<!--明细是否修改过标记（1表示修改过，0表示没有修改） -->
			<input type="hidden" name="formMap['updateFlag']" id="updateFlag" />
        </div>
    </form>
    <div>提示："区域薪酬系数"计算标保时不使用,计算薪酬时使用。</div>
    <div>
        <form id="areaRate">
            <fieldSet>
                <legend>区域薪酬系数</legend>
                <div id="buttonbar"></div>
                <table id="tablesAreaRate"></table>
            </fieldSet>
        </form>
    </div>
</body>
</html>