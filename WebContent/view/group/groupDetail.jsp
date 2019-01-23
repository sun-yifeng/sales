<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*" %>
<% String  historyId = request.getParameter("historyId");%>
<% String  groupCode = request.getParameter("groupCode");%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>团队历史轨迹详细</title>

<style type="text/css">
html, body{ height:100%; margin:0px; padding:0px;}
body {font-size:12px;}
.om-button {font-size:12px;}
#nav_cont{width:580px;margin-left:auto;margin-right:auto;}
input {border: 1px solid #A1B9DF; vertical-align: middle;}
input:focus{border: 1px solid #3A76C2;}
.input_slelct {width: 81%;}
.textarea_text {border: 1px solid #A1B9DF; height: 40px;width: 445px;}
table.grid_layout tr td {font-weight: normal; height: 15px; padding: 5px 0; vertical-align: middle;}
.color_red { color: red; }
.toolbar { padding: 12px 0 5px;text-align: center; }
.birthplace ,.address {width:445px;}
.om-span-field input:focus {border:none;}
.errorImg{background: url("../../images/msg.png") no-repeat scroll 0 0 transparent;height: 16px;width: 16px;cursor: pointer;}
input.error,textarea.error{border: 1px solid red;}
.errorMsg{border: 1px solid gray;background-color: #FCEFE3;display: none;position: absolute;margin-top: -18px;margin-left: 18px;}

</style>
<script type="text/javascript">
var historyId ='<%=historyId%>';
var groupCode ='<%=groupCode%>';
$(function(){
	$("#updateSaleGroup").find("input").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$(".sele2").css({"width":"150px"});
	$('#foundDate').omCalendar({dateFormat : "yy-mm-dd",disabled:true});
	
	//获取CODE用于查询详细数据
	$('#groupCode_fk').val(groupCode);
	$('#groupCode_fk1').val(historyId);
	
	/******初始化tab标签页*********/
	$('#make-tab').omTabs({
	    closable : false
    });
	
	//团队类型	
	$('#groupType').omCombo({
        dataSource : <%=Constant.getCombo("groupType")%>,
        emptyText : '请选择',
	    editable : false,
	    disabled:true
    });
	
	//初始化根据CODE查出来的数据
	Util.post("<%=_path%>/groupMain/queryGroupMainDetail.do",$("#groupMainFrm").serialize(), function(data) {
		$("#updateSaleGroup").find(":text").each(function(){
			$(this).val(data[0][$(this).attr("name")]);
		});		
		//团队类型
		$('#groupType').omCombo({
			value:data[0].groupType
			//readOnly : true
		});
		//是否虚拟团队
		$('#virtualFlag').omCombo({
			value:data[0].virtualFlag,
			editable : false,
			disabled:true,
			readOnly : true
		});
		isVirtualFlag(data[0].virtualFlag);
   });
	
	//是否虚拟团队	
	$('#virtualFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        //editable : false,
//         onValueChange : function(target, newValue, oldValue, event) {
//         	if(newValue === '1'){
//         		$('#groupType').omCombo({
//         			value:'7',//常规团队
//         			readOnly : true
//         		});
//         	}else {
//         		$('#groupType').omCombo({
//         			emptyText : '请选择',
//         			editable : false,
//         			readOnly : false
//         		});
//         	}
//         },
        emptyText : '请选择'
    });
	
	
 	//时间只读
	//$('#foundDate').omCalendar('disable');
	
	//返回按钮
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});

	
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
});

function isVirtualFlag(value){
	if(value === '1'){
		$('#groupType').omCombo({
			readOnly : true
		});
	}else {
		$('#groupType').omCombo({
			emptyText : '请选择',
			editable : false,
			readOnly : false
		});
	}
}

//定义校验规则
var groupConferRule = {
	groupName:{
		required : true
	}
};

//定义校验的显示信息
var groupConferMessages = {
	groupName:{
		required : '团队名称不能为空'
	}
};


//禁用删除键的返回作用
document.onkeydown = function() {
	 // 如果按下的是退格键
     if(event.keyCode == 8) {
     // 如果是在textarea内不执行任何操作
	        if(event.srcElement.tagName.toLowerCase() != "input"  && event.srcElement.tagName.toLowerCase() != "textarea" && event.srcElement.tagName.toLowerCase() != "password"){
	            event.returnValue = false;
	        }
	        // 如果是readOnly或者disable不执行任何操作
	        if(event.srcElement.readOnly == true || event.srcElement.disabled == true){
	            event.returnValue = false;
	        }
     }
};




function cancel(){
	window.location.href = "groupHistory.jsp?groupCode="+groupCode;
}
</script>
</head>
<body>
        <div id="saleGroup">
			<table style="border: solid #d0d0d0 1px;width: 99.9%; margin-top:5px; padding-top: 8px;padding-bottom: 8px;padding-left: 20px;">
				<tr><td>团队历史轨迹详细</td></tr>
			</table>
			<div>
				<form id="groupMainFrm">
					<input type="hidden" name="formMap['historyId']" id="groupCode_fk1" value=""/>
				</form>
				<fieldSet>
				    <legend>基本信息</legend>
					<form id="updateSaleGroup">
					    <input style="display:none;" type="text" name="groupCode" id="groupCode" value=""/>
						<table style="padding-left: 30px;">
							<tr>
								<td style="padding-left: 30px;" align="right"><span class="label">二级机构：</span></td>
								<td><input type="text" name="parentDept" id="parentDept" readonly="readonly" /><span style="color:red">*</span></td>
								<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 30px" align="right"><span class="label">三级机构：</span></td>
								<td><input type="text" name="deptName" id="deptName" readonly="readonly" /><span style="color:red">*</span></td>
								<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 30px" align="right"><span class="label">四级单位：</span></td>
								<td><input type="text" name="deptMarket" id="deptMarket" readonly="readonly" /><span style="color:red">*</span>
									<input type="text" name="deptCode" id="deptCode" value="" style="display: none;"/>
								</td>
								<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left: 30px; " align="right">团队名称：</td>
                                <td><input type="text" name="groupName" id="groupName" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 30px;" align="right">团队成立日期：</td>
								<td><input type="text" name="foundDate"  class="sele" id="foundDate" readonly="readonly"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 30px;" align="right">是否虚拟团队：</td>
								<td><input  name="virtualFlag" id="virtualFlag" class="sele" readonly="readonly"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left: 30px;" align="right"><span class="label">团队类型：</span></td>
								<td><input name="groupType"  id="groupType"  class="sele" readonly="readonly"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 30px;" align="right"><span class="label">修改者：</span></td>
								<td><input type="text" name="updatedUser"  id="updateUser"  class="sele2"  readonly="readonly"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left: 30px;" align="right"><span class="label">修改时间：</span></td>
								<td><input  type="text" name="updatedDate2"  id="updateDate2"  class="sele2" readonly="readonly"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
						</table>
					</form>
				</fieldSet>
			</div>
			<div>
				<table style="width: 100%">
					<tr>
						<td style="padding-top:10px" align="center">
						
						<a id="button-cancel"  onclick="cancel()">返回</a></td>
					</tr>
				</table>
			</div>
		</div>
</body>
</html>