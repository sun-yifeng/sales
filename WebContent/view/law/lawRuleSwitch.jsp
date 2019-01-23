<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%String versionId = (String) request.getParameter("versionId");%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<style type="text/css">
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<title>销售人员管理办法-配置项</title>
<script type="text/javascript">
var versionId = '<%=versionId %>';

$(function(){
	
	$('#versionId').val(versionId);
	
	$('#salesSysSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#salesImpSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#salesCheckSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#salesExpSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#salesRegSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#groupSysSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#groupImpSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#groupCheckSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#groupExpSwitch').omCombo({
		dataSource : [{"text":"开","value":"1"},
                      {"text":"关","value":"0"}],
        editable : false,
        value : '1',
    });
	
	$('#groupRegSwitch').omCombo({
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
	
	Util.post("<%=_path%>/lawRate/queryButtonStatus.do?versionId="+versionId,"",function(data) {
		$('#salesSysSwitch').omCombo({value : data.salesSysSwitch});
		$('#salesImpSwitch').omCombo({value : data.salesImpSwitch});
		$('#salesCheckSwitch').omCombo({value : data.salesCheckSwitch});
		$('#salesExpSwitch').omCombo({value : data.salesExpSwitch});
		$('#salesRegSwitch').omCombo({value : data.salesRegSwitch});
		$('#groupSysSwitch').omCombo({value : data.groupSysSwitch});
		$('#groupImpSwitch').omCombo({value : data.groupImpSwitch});
		$('#groupCheckSwitch').omCombo({value : data.groupCheckSwitch});
		$('#groupExpSwitch').omCombo({value : data.groupExpSwitch});
		$('#groupRegSwitch').omCombo({value : data.groupRegSwitch});
		$('#insuranceSwitch').omCombo({value : data.insuranceSwitch});
		$('#motorSwitch').omCombo({value : data.motorSwitch});
		$('#channelSwitch').omCombo({value : data.channelSwitch});
		$('#businessSwitch').omCombo({value : data.businessSwitch});
		$('#areaSwitch').omCombo({value : data.areaSwitch});
	});

	 // 按钮样式 
	 $("#button-save").omButton({width:70});
	 $("#button-cancel").omButton({width:70});
	 
	 initValidate();//初始化校验
	 
});

//校验全局调用
var remote;
//校验
function initValidate(){
remote = $("#filterForm").validate({
     submitHandler : function() {
     	//将name属性还原，提交保存
     	$("#filterForm").find("input[name$='formMap']").each(function(){
     		$(this).attr("name","formMap['"+$(this).attr("id")+"']");
     	});
    	 //提交保存入库
 		Util.post("<%=_path%>/lawRate/saveLawRulePermission.do",$("#filterForm").serialize(), 
				function(data) {
	 			   $.omMessageBox.alert({
	 				   					type:'success',
              title:'成功',
			           content:'修改配置型成功!',
			       }); 
	 			  top.document.location.reload();
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
	    <fieldSet>
	       <legend>基本法编辑权限开关</legend>
	       <div id="search-panel">
	       	<!-- 版本编码 -->
	       	<input type="hidden" name="formMap['versionId']" id="versionId"/>
			<fieldSet>
			   <legend>客户经理规则</legend>
			   <table>
	                 <tr>
	                   <td style="padding-left: 35px;"  align="right"><span class="label">系统因素：</span></td>
	                   <td><input class="sele" type="text" name="formMap['salesSysSwitch']" id="salesSysSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 35px;"  align="right"><span class="label">导入因素：</span></td>
	                   <td><input class="sele" type="text" name="formMap['salesImpSwitch']" id="salesImpSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 35px;"  align="right"><span class="label">考核因素：</span></td>
	                   <td><input class="sele" type="text" name="formMap['salesCheckSwitch']" id="salesCheckSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                 </tr>
	                 <tr>
	                   <td style="padding-left: 35px;"  align="right"><span class="label">计算公式：</span></td>
	                   <td><input class="sele" type="text" name="formMap['salesExpSwitch']" id="salesExpSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 35px;"  align="right"><span class="label">考核规则：</span></td>
	                   <td><input class="sele" type="text" name="formMap['salesRegSwitch']" id="salesRegSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                 </tr>
			   </table>
			</fieldSet>
			<fieldSet>
			   <legend>团队经理规则</legend>
			   <table>
	                 <tr>
	                   <td style="padding-left: 36px;"  align="right"><span class="label">系统因素：</span></td>
	                   <td><input class="sele" type="text" name="formMap['groupSysSwitch']" id="groupSysSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 35px;"  align="right"><span class="label">导入因素：</span></td>
	                   <td><input class="sele" type="text" name="formMap['groupImpSwitch']" id="groupImpSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 35px;"  align="right"><span class="label">考核因素：</span></td>
	                   <td><input class="sele" type="text" name="formMap['groupCheckSwitch']" id="groupCheckSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                 </tr>
	                 <tr>
	                   <td style="padding-left: 35px;"  align="right"><span class="label">计算公式：</span></td>
	                   <td><input class="sele" type="text" name="formMap['groupExpSwitch']" id="groupExpSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                   <td style="padding-left: 35px;"  align="right"><span class="label">考核规则：</span></td>
	                   <td><input class="sele" type="text" name="formMap['groupRegSwitch']" id="groupRegSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
	                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
	                 </tr>
			   </table>
			</fieldSet>
			<fieldSet>
				   <legend>其他规则</legend>
		           <table >
		                 <tr>
		                   <td style="padding-left: 15px;"  align="right"><span class="label">险种调整系数：</span></td>
		                   <td><input class="sele" type="text" name="formMap['insuranceSwitch']" id="insuranceSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
		                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
		                   <td style="padding-left: 15px;"  align="right"><span class="label">车型调整系数：</span></td>
		                   <td><input class="sele" type="text" name="formMap['motorSwitch']" id="motorSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
		                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
		                   <td style="padding-left: 15px;"  align="right"><span class="label">渠道调整系数：</span></td>
		                   <td><input class="sele" type="text" name="formMap['channelSwitch']" id="channelSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
		                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
		                 </tr>
		                 <tr>
		                   <td style="padding-left: 15px;"  align="right"><span class="label">业务来源系数：</span></td>
		                   <td><input class="sele" type="text" name="formMap['businessSwitch']" id="businessSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
		                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>  
		                   <td style="padding-left: 15px;"  align="right"><span class="label">区域薪酬系数：</span></td>
		                   <td><input class="sele" type="text" name="formMap['areaSwitch']" id="areaSwitch" style="width: 150px;" /><span style="color:red">*</span></td>
		                   <td style="display:none"><span class="errorImg"></span><span class="errorMsg"></span></td>
		                 </tr>
		           </table>
	          </fieldSet>
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