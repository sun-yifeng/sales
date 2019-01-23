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
		dataSource : [{"text":"是","value":"1"},
                      {"text":"否","value":"0"}],
        editable : false,
        value : '0',
        emptyText : '请选择'
    });
	
	$('#isWorkingAge').omCombo({
		dataSource : [{"text":"是","value":"1"},
                      {"text":"否","value":"0"}],
        editable : false,
        value : '0',
        emptyText : '请选择',
        onValueChange : function(target, newValue, oldValue, event) {
        	if(newValue == '0'){
        		$("#workingAgeCalBegin1").hide();
        		$("#workingAgeCalBegin2").hide();
        	}else{
        		$("#workingAgeCalBegin1").show();
				$("#workingAgeCalBegin2").show();
        	}
        }
    });
	
	$('#isArea').omCombo({
		dataSource : [{"text":"是","value":"1"},
                      {"text":"否","value":"0"}],
        editable : false,
        value : '0',
        emptyText : '请选择'
    });
	
	//通算结果应用月份
    var date = new Date();
	date.setMonth(date.getMonth(), date.getDate());
    $('#passCountMonth').omCalendar(
    		{dateFormat:'yymm',
    			disabledFn : disFn });
	$('#passCountMonth').val($.omCalendar.formatDate(date,"yymm"));
	
	Util.post("<%=_path%>/lawRate/queryLawRateConfigByVersionId.do?versionId="+versionId,"",function(data) {
		$('#salaryCalPinDu').omCombo({value : data.salaryCalPinDu});
		$('#clientManagerKaoHe').omCombo({value : data.clientManagerKaoHe});
		$('#levelCalPindu').omCombo({value : data.levelCalPindu});
		$('#salesDirectorBuTie').val(data.salesDirectorBuTie);
		$('#workingAgeCalBegin').val(data.workingAgeCalBegin);
		$('#isWorkingAge').omCombo({value : data.isWorkingAge});
		$('#isArea').omCombo({value : data.isArea});
		$('#tmpEmploySalaryRate').val(data.tmpEmploySalaryRate);
		$('#passCountMonth').val(data.passCountMonth);
	});
	
	$('#salesSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#groupSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#insuranceSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#motorSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#channelSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#businessSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#areaSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#salesLevelSwtich').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	
	
	//起期
	$("#workingAgeCalBegin").omCalendar({
		dateFormat:"yy-mm-dd"		
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
	 
	 initValidate();//初始化校验
	 
	 $('.errorImg').bind('mouseover', function() {
		    $(this).next().css('display', 'block');
	    }).bind('mouseout', function() {
		    $(this).next().css('display', 'none');
	    });
	 
	 $.validator.addMethod("tmpEmploySalaryRateCheck",function(value){
		 if(value>=0 && value<=1){
			 return true;
		 }
	    	
	    },"工资系数为0-1的小数");
	 
	 $.validator.addMethod("salesDirectorBuTieCheck",function(value){
		 if(value>=0 && value<=50000){
			 return true;
		 }
	    	
	    },"补贴金额为0-50000元");
	 
});

var areaRuleConfigRule = {
	salesDirectorBuTieformMap:{  
		number : true,
		salesDirectorBuTieCheck : true
	  },
	  tmpEmploySalaryRateformMap:{
		  required : true,
		  number:true,
		  tmpEmploySalaryRateCheck: true
	  }  
};

var areaRuleConfigRuleMessages = {
	salesDirectorBuTieformMap:{
		number : '只能为数字'
	  },
	  tmpEmploySalaryRateformMap:{
		  required : '不能为空',
		  number : '只能为数字'
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
	    errorPlacement: function(error, element) {
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
	    }, 
     submitHandler : function() {
     	//将name属性还原，提交保存
     	$("#filterForm").find("input[name$='formMap']").each(function(){
     		$(this).attr("name","formMap['"+$(this).attr("id")+"']");
     	});
    	 //提交保存入库
 		Util.post("<%=_path%>/lawRate/saveLawRuleConfig.do",$("#filterForm").serialize(), 
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

function disFn(date) {
    var nowMiddle = new Date();
    if (date <= nowMiddle) {
        return false;
    }
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
	    <fieldSet>
	    	<legend>配置项参数</legend>
	       <div id="search-panel">
	       	<!-- 版本编码 -->
	       	<input type="hidden" name="formMap['versionId']" id="versionId"/>
	       	<!--所有区域系数信息封装json字符串 -->
	       	<input type="hidden" name="formMap['areaRateJsonStr']" id="areaRateJsonStr" />
	       	<!--明细是否修改过标记（1表示修改过，0表示没有修改） -->
			<input type="hidden" name="formMap['updateFlag']" id="updateFlag" />
	           <table >
	               <tr>
	                   <td style="padding-left: 0px" align="right">定薪计算频度：</td>
	                   <td><input class="sele" type="text" name="formMap['salaryCalPinDu']" id="salaryCalPinDu" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 15px;"  align="right"><span class="label">团队长按照客户经理考核：</span></td>
	                   <td><input class="sele" type="text" name="formMap['clientManagerKaoHe']" id="clientManagerKaoHe" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 15px;" align="right"><span class="label">试用期员工工资系数 ：</span></td>
	                   <td><input type="text" name="formMap['tmpEmploySalaryRate']" id="tmpEmploySalaryRate" value="0.8" style="width: 150px;"/><span style="color:red">*</span></td>
	                   <td><span class="errorImg"></span><span class="errorMsg"></span></td>
	                 </tr>
	                 <tr>
	                   <td style="padding-left: 0px;" align="right"><span class="label">定级计算频度：</span></td>
	                   <td><input class="sele" type="text" name="formMap['levelCalPindu']" id="levelCalPindu" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 15px;"  align="right"><span class="label">销售人员是否有地域区分：</span></td>
	                   <td><input class="sele" type="text" name="formMap['isArea']" id="isArea" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 15px;" align="right"><span class="label">销售总监补贴金额（元）：</span></td>
	                   <td><input type="text" name="formMap['salesDirectorBuTie']" id="salesDirectorBuTie" value="0" style="width: 150px;"/></td>
	                   <td><span class="errorImg"></span><span class="errorMsg"></span></td>
	                  
	                 </tr>
	                 <tr>
	                   <td style="padding-left: 15px;" align="right"><span class="label">通算结果应用月份：</span></td>
	                   <td><input class="sele" type="text" name="formMap['passCountMonth']" id="passCountMonth" style="width: 150px;" /></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 0px;"  align="right"><span class="label">是否配置司龄工资：</span></td>
	                   <td><input class="sele" type="text" name="formMap['isWorkingAge']" id="isWorkingAge" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 15px;" align="right" id="workingAgeCalBegin1"><span class="label">司龄工资计算起期：</span></td>
	                   <td id="workingAgeCalBegin2"><input class="sele" type="text" name="formMap['workingAgeCalBegin']" id="workingAgeCalBegin" style="width: 150px;" /><span style="color:red">*</span></td>
	                 </tr>
	                 
	           </table>
	       </div>
	    </fieldSet>
    </form>
    <div>
        <table style="width: 100%">
            <tr>
                <td style="padding-top:20px" align="center">
                <a class="om-button" id="button-save" onclick="save()">保存修改</a>
                <a class="om-button" id="button-cancel" onclick="cancel()">取消修改</a></td>
            </tr>
        </table>
    </div>
</body>
</html>