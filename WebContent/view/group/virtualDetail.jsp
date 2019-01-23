<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<% String historyId = request.getParameter("historyId");
String virtualId=request.getParameter("virtualId"); 
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>销售助理详细</title>
<style type="text/css">
html,body{height:100%;margin:0;padding:0;overflow:auto;}
body{font-size:12px}
.om-button{font-size:12px}
#nav_cont{width:580px;margin-left:auto;margin-right:auto}
input{border:1px solid #a1b9df;vertical-align:middle;width:151px}
input:focus{border:1px solid #3a76c2}
.input_slelct{width:81%}
.textarea_text{border:1px solid #a1b9df;height:40px;width:445px}
table.grid_layout tr td{font-weight:normal;height:15px;padding:5px 0;vertical-align:middle}
.color_red{color:red}
.toolbar{padding:12px 0 5px;text-align:center}
.birthplace,.address{width:445px}
.om-span-field input:focus{border:0}
.errorImg{background:url("../../images/msg.png") no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error,textarea.error{border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:18px}
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style> 
<script type="text/javascript">
var historyId = '<%=historyId%>';
var virtualId='<%=virtualId%>';
var salemanVritual;
//
$(function(){
	$(".sele").css({"width":"130px"});
	/******初始化tab标签页*********/
	$('#make-tab').omTabs({
	    closable : false
    });

	
	//查询详细信息
	Util.post("<%=_path%>/salesmanVirtual/querySalesmanVirtualDetial2.do?historyId="+historyId, "", function(data) {
		salemanVritual=data;
	    //填充页面
		$("#updateVirtualForm").find("input").each(function(){
			$(this).val(data[$(this).attr("name")]);
		});
		//人员类型
		$('#salesmanType').omCombo({value:data.salesmanType,
			                        disabled : true});
		//对应的HR人员姓名,下拉框
		$('#salesmanCname').omCombo({
			dataSource : "<%=_path%>/salesman/queryNameAndCode.do?deptCode="+data.deptCode,
			 onValueChange : function(target, newValue, oldValue, event) {
					$("#salesmanCode").val(newValue);
			},
	        optionField : function(data, index) {
	            return data.text;
			},
			value : data.userCode,
	        editable : false,
	        width : '150px'
	    });
		//出生日期选择框
		$('#birthday').omCalendar({
			dateFormat : "yy-mm-dd",
			editable : false,
			disabled : true
		}); 
		//入职日期选择框
		$('#enterDate').omCalendar({
			dateFormat : "yy-mm-dd",
			editable : false,
			 disabled : true
		}); 
		//结束日期选择框
		$('#endDate').omCalendar({
			dateFormat : "yy-mm-dd",
			editable : false,
			 disabled : true
		});
    });
	
	//初始化页面保存、取消按钮
	
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	 
	


})



//
function back(){
	window.location.href = "virtualHistorys.jsp?virtualId="+virtualId;
}
</script>
</head>
<body>
    <div id="saleUserVirtual">
	<table class="navi-no-tab">
		<tr><td>销售助理详细</td></tr>
	</table>
	<div>
		<fieldSet>
		<legend>销售助理详细</legend>	
			<form id="updateVirtualForm">
			    <input type="hidden" name="virtualId"  id="virtualId"  value=""/>
				<table style="padding-left: 30px;">
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">人员类别：</span></td>
							<td><input class="sele" name="salesmanType" id="salesmanType" readonly="readonly"/><span style="color:red">*</span></td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left: 30px" align="right"><span class="label">人员姓名：</span></td>
							<td><input name="cname" id="cname"  readonly="readonly"/></td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">核心工号：</span></td>
							<td><input name="employCode"  id="employCode"   readonly="readonly"/></td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left: 30px" align="right"><span class="label">二级机构：</span></td>
							<td><input name="deptNameTwo" id="deptNameTwo" readonly="readonly"/></td>
							<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left: 30px" align="right"><span class="label">三级机构：</span></td>
							<td><input name="deptNameThree" id="deptNameThree" readonly="readonly"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left: 30px" align="right"><span class="label">四级单位：</span></td>
							<td><input name="deptNameFour"  id="deptNameFour" readonly="readonly"/>
							<input name="deptCode"  id="deptCode"  style="display: none;"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left: 30px" align="right"><span class="label">身份证号：</span></td>
							<td><input type="text"  name="certiryNo" id="certiryNo" readonly="readonly"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right">出生日期：</td>
							<td><input class="sele" type="text" name="birthday" id="birthday" readonly="readonly"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right">入职时间：</td>
							<td><input class="sele" type="text" name="enterDate" id="enterDate" readonly="readonly"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right">结束时间：</td>
							<td><input  class="sele" type="text" name="endDate"  id="endDate" readonly="readonly"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right">对应HR人员姓名：</td>
							<td><input class="sele" name="salesmanCname" id="salesmanCname" readonly="readonly"/></td>
							<td><span class="errorImg" id="salesmanCnameImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right">对应HR人员代码：</td>
							<td><input name="salesmanCode"  id="salesmanCode"  readonly="readonly" readonly="readonly"/></td>
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
				
				<a id="button-cancel"  onclick="back()">返回</a></td>
			</tr>
		</table>
	</div>
    </div>
</body>
</html>