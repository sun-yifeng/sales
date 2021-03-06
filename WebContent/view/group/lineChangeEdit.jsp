<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.sinosafe.xszc.constant.*" %>
<% String salesmanCode = request.getParameter("salesmanCode"); %>
<% String deptCode = request.getParameter("deptCode"); %>
<% String parentDeptCode = request.getParameter("parentDeptCode"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工业务线变更</title>
<style type="text/css">
*{padding:0;margin:0}
html,body{height:100%;margin:0;padding:0}
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
.navi-no-tab{border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<script type="text/javascript">
var salesmanCode = '<%=salesmanCode%>';
var deptCode = '<%=deptCode%>';
var parentDeptCode = '<%=parentDeptCode%>';

$(function(){
	//获取CODE用于查询详细数据
	$('#salesmanCode_fk').val(salesmanCode);
	$('#salesmanCode_fk1').val(salesmanCode);
	$('#deptCode').val(deptCode);
	if(deptCode.length == 2){
		$("#deptCodeTr").hide();
		$("#deptCodesTr").show();
	}
	
	/******初始化tab标签页*********/
	$('#make-tab').omTabs({
	    closable : false
    });
	
	//出生日期
	  $('#birthday').omCalendar({
		  dateFormat : "yy-mm-dd",
		  disabled : true
  		});
	//入司日期
	  $('#contractDate').omCalendar({
		  dateFormat : "yy-mm-dd",
		  disabled : true
 		 });
		//入职日期
	  $('#entryDate').omCalendar({
		  dateFormat : "yy-mm-dd",
		  disabled : true
  		});
	//转正日期
	  $('#regularDate').omCalendar({
		  dateFormat : "yy-mm-dd",
		  disabled : true
  		});
		//是否参加考核
		$('#evaluate').omCombo({
				dataSource :<%=Constant.getCombo("isYesOrNo")%>,
				emptyText : '请选择',
	 		    editable : false,
	 		    readOnly : true,
	 		 	width : '150px'
	  	});
		//是否试用期
		$('#trytou').omCombo({
			dataSource :<%=Constant.getCombo("isYesOrNo")%>,
				 emptyText : '请选择',
			     editable : false,
			     readOnly : true,
		    	 width : '150px'
	    });
		//业务线
		$('#bizLineNew').omCombo({
				dataSource :"<%=_path%>/common/queryBusinessLineNew.do",
				onValueChange:function(target,newValue,oldValue,event){ 
					$("#bizLineNew").omCombo(newValue);
				},
				emptyText : '请选择',
	   		    editable : false
	    });
		//处理状态
		$('#processStatus').omCombo({
	        dataSource : <%=Constant.getCombo("processStatus")%>,
		        editable : false,
		        emptyText : '请选择',
		        readOnly : true
	    });
		//婚姻状况
		$('#marry').omCombo({
			dataSource : <%=Constant.getCombo("marry")%>,
				emptyText : '请选择',
				readOnly : true,
			    editable : false
	    });
		//政治面貌
		$('#party').omCombo({
	        dataSource : <%=Constant.getCombo("party")%>,
		        emptyText : '请选择',
		        readOnly : true,
			    editable : false
	    });
		//性别
		$('#sex').omCombo({
	        dataSource : <%=Constant.getCombo("sex")%>,
		        emptyText : '请选择',
		        readOnly : true,
			    editable : false
	    });
		/*
		//判断是分司人员还是 分司以下人员
		if(parentDeptCode =='00'){
			//如果是分司人员  
			//销售职级
			$('#saleRank').omCombo({
		        dataSource :"<%=_path%>/lawRank/queryRankCodeAndName.do?deptCode="+deptCode,
		        emptyText : '请选择',
			    editable : false
		    });
		}else{
			//否则分司以下人员  
			//销售职级
			$('#saleRank').omCombo({
		        dataSource :"<%=_path%>/lawRank/queryRankCodeAndName.do?deptCode="+parentDeptCode,
		        emptyText : '请选择',
			    editable : false
		    });
		} */
		
		//员工类型
		$('#salesmanType').omCombo({
	        dataSource :"<%=_path%>/common/querySalesmanType.do",
	        	emptyText : '请选择',
			    editable : false,
			    readOnly : true
	    });
		//员工状态
		$('#status').omCombo({
			dataSource :"<%=_path%>/common/querySalesmanStatus.do",
			 emptyText : '请选择',
			 readOnly : true,
		     editable : false
	    });
		//民族
		$('#nation').omCombo({
			dataSource :"<%=_path%>/common/queryNational.do",
			emptyText : '请选择',
			readOnly : true,
		    editable : false
	    });
		//学历
		$('#degree').omCombo({
			dataSource :"<%=_path%>/common/queryEducatioin.do",
		        emptyText : '请选择',
		        readOnly : true,
			    editable : false
	    });
		//籍贯
		$('#fromAddress').omCombo({
	        dataSource :"<%=_path%>/common/queryProvince.do",
		        emptyText : '请选择',
		        readOnly : true,
			    editable : false
	    });
		//职务类型
		$('#titleType').omCombo({
	        dataSource : [{text : '前台', value : '1'},
	                       {text : '后勤', value : '2'},
	                       {text : '安管', value : '3'},
	                       {text : '经理', value : '4'}],
  		    editable : false,
  		  	readOnly : true
	    });
		//原业务线
		$('#oldBusinessLine').omCombo({
				dataSource :"<%=_path%>/common/queryBusinessLine.do",
				emptyText : '请选择',
				readOnly : true,
       		    editable : false
	    });
		//原业务线
		$('#oldBusinessLine1').omCombo({
				dataSource :"<%=_path%>/common/queryBusinessLine.do",
				emptyText : '请选择',
				readOnly : true,	
       		    editable : false
	    });
	
	Util.post("<%=_path%>/salesman/salesmanDetail.do", $("#saleUserFrm").serialize(), function(data) {
	    	    $("#leaderCancelFrm").find(":text").each(function(){
				$(this).val(data[0][$(this).attr("name")]);
				
			});
			//原业务线
			$('#oldBusinessLine').omCombo({value:data[0].businessLine});
			//原业务线
			$('#oldBusinessLine1').omCombo({value:data[0].businessLine});
			//业务线
			//$('#bizLineNew').omCombo({value:data[0].businessLine});
			//销售职级
			//$('#saleRank').omCombo({value:data[0].saleRank,readOnly : true});
			//员工类型
			$('#salesmanType').omCombo({value:data[0].salesmanType});
			//员工状态
			$('#status').omCombo({value:data[0].status});
			//民族
			$('#nation').omCombo({value:data[0].nation});
			//学历
			$('#degree').omCombo({value:data[0].degree});
			//籍贯
			$('#fromAddress').omCombo({value:data[0].fromAddress});
			//是否参加考核
			$('#evaluate').omCombo({value:data[0].evaluate});
			//是否试用期
			$('#trytou').omCombo({value:data[0].trytou});
			//处理状态
			$('#processStatus').omCombo({value:data[0].processStatus});
			//婚姻状况
			$('#marry').omCombo({value:data[0].marry});
			//政治面貌
			$('#party').omCombo({value:data[0].party});
			//性别
			$('#sex').omCombo({value:data[0].sex});
			//职务类型
			$('#titleType').omCombo({value:data[0].titleType});
			//初始化机构
			$('#parentDept').omCombo({
				readOnly : true
			});
			$('#deptName').omCombo({
				readOnly : true
			});
			$('#deptMarket').omCombo({
				readOnly : true
			});
			$('#threeDeptNames').omCombo({
				value:data[0].deptCode,
				readOnly : true
			});
		
    });
	//初始化页面保存、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	//页面校验
	$("#bizLineNewFrm").validate({
	   	rules : {
	   		businessLineNew:"required"
	   	},
	   	messages : {
	   		businessLineNew : "请选择要变更的业务线",
	   	},      	
	       errorPlacement : function(error, element) { 
	       	if(error.html()){
	               $(element).parents().map(function(){
	                   if(this.tagName.toLowerCase()=='td'){
	                       var attentionElement = $(this).next().children().eq(0);
	                       attentionElement.css('display','block');
	                    attentionElement.next().html(error);
	                   }
	               });
	           }
	        },
	        showErrors: function(errorMap, errorList) {
	        	if(errorList && errorList.length > 0){
	               $.each(errorList,function(index,obj){
	                   var msg = this.message;
	                   $(obj.element).parents().map(function(){
	                        if(this.tagName.toLowerCase()=='td'){
	                            var attentionElement = $(this).next().children().eq(0);
	                            attentionElement.show();
	    	                    attentionElement.next().html(msg);
	                        }
	                    });
	               });
	           }else{
	               $(this.currentElements).parents().map(function(){
	                   if(this.tagName.toLowerCase()=='td'){
	                       $(this).next().children().eq(0).hide();
	                   }
	               });
	           }
	           this.defaultShowErrors();
	       },
	   	submitHandler : function(){
	           //alert('提交成功！');
	           $(this)[0].currentForm.reset();
	           return false;
	       }
    });
	  
	$('.errorImg').bind('mouseover',function(){
        $(this).next().css('display','block');
    }).bind('mouseout',function(){
        $(this).next().css('display','none');
    });

});
//保存员工操作
function save(){
	if (!$("#bizLineNewFrm").validate().form()) 
		return false;
	//将原来的时间传回后台
	$("#birthdayNew").val($("#birthday").val());
	$("#contractDateNew").val($("#contractDate").val());
	$("#entryDateNew").val($("#entryDate").val());
	$("#regularDateNew").val($("#regularDate").val());
 	//将变更选中的业务线赋值到隐藏文本框传到后台
	$("#bizLineNew1").val($("#bizLineNew").val()); 
 	
 	
 	if (changeOrNot()){
 		//提交变更
 		Util.post("<%=_path%>/salesman/updateSalesman.do",$("#leaderCancelFrm").serialize(), function(data) {
 			//保存成功后跳转回员工变更页
 			window.location.href = "lineChange.jsp";
 	    });
 	}
 	else{
 		$.omMessageBox.alert({
 			content:'内容修改后才能提交！'
 		});
 	}
	
}
//取消
function cancel(){
	window.location.href = "lineChange.jsp";
}
//判断内容是否有修改过。
function changeOrNot(){
	if($("#oldBusinessLine1").val()!=$("#bizLineNew").val()){
		return true;	
	}
	
}
</script>
</head>
<body>
    <div id="saleGroup">
		<table class="navi-no-tab">
			<tr><td>员工业务线变更</td></tr>
		</table>
		<div>
			<form id="saleUserFrm">
				<input type="hidden" name="formMap['salesmanCode']"  id="salesmanCode_fk1"  value=""/>
				<input type="hidden" name="formMap['deptCode']"  id="deptCode"  value=""/>
			</form>
			<fieldSet>
				<legend>人员基本信息</legend>
				<form id="leaderCancelFrm">
					<input type="hidden" name="businessLine" id="bizLineNew1"/>
					<input type="text" style="display:none;"name="groupCode" id="groupCode"/>
					<table style="padding-left: 30px;">
						<tr id="deptCodeTr">
								<td style="padding-left: 15px" align="right"><span class="label">二级机构：</span></td>
								<td><input name="parentDept" id="parentDept"   style="width: 130px;" readonly="readonly"/></td>
								<td style="padding-left: 30px" align="right"><span class="label">三级机构：</span></td>
								<td><input name="deptName" id="deptName" style="width: 130px;"  readonly="readonly"/></td>
								<td style="padding-left: 30px" align="right"><span class="label">四级单位：</span></td>
								<td><input name="deptMarket"  id="deptMarket"  style="width: 130px;" readonly="readonly"/></td>
						</tr>
						<tr id="deptCodesTr"  style="display:none;">
								<td style="padding-left: 150px" align="right"><span class="label">机构：</span></td>
								<td><input name="deptMarket" id="threeDeptNames"   style="width: 130px;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="padding-left: 15px;" align="right">姓名：</td>
							<td><input type="text" name="salesmanCname" id="salesmanCname" readonly="readonly"/></td>
							<td style="padding-left: 30px;" align="right">职位：</td>
							<td><input type="text" name="position" id="position" readonly="readonly"/></td>
							<td style="padding-left: 30px;" align="right">性别：</td>
							<td><input type="text" name="sex"  id="sex"  style="width: 130px;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="padding-left: 15px;" align="right">出生年月：</td>
							<td><input type="text" name="birthday"  id="birthday" style="width: 130px;" readonly="readonly"/>
									<input name="birthday"  id="birthdayNew"  type="hidden"/>
							</td>
							<td style="padding-left: 30px;" align="right">身份证号：</td>
							<td><input type="text" name="certifyNo"  id="certifyNo"  readonly="readonly"/></td>
							<td style="padding-left: 30px; " align="right">年龄：</td>
							<td><input type="text" name="age"  id="age"  readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="padding-left: 15px;" align="right">民族：</td>
							<td><input type="text" name="nation"  id="nation" style="width: 130px;"  readonly="readonly"/></td>
							<td style="padding-left: 30px; " align="right">籍贯：</td>
							<td><input type="text" name="fromAddress"  id="fromAddress" style="width: 130px;"  readonly="readonly"/></td>
							<td style="padding-left: 30px; " align="right">党派：</td>
							<td><input type="text" name="party"  id="party"  style="width: 130px;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="padding-left: 15px; " align="right">最高学历：</td>
							<td><input type="text" name="degree"  id="degree"  style="width: 130px;" readonly="readonly"/></td>
							<td style="padding-left: 30px; " align="right">毕业学校：</td>
							<td><input type="text" name="education"  id="education"  readonly="readonly"/></td>
							<td style="padding-left: 30px;" align="right">专业：</td>
							<td><input type="text" name="magor"  id="magor"  readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="padding-left: 15px;" align="right">员工状态：</td>
							<td><input type="text" name="status"  id="status" style="width: 130px;" readonly="readonly"/></td>
							<td style="padding-left: 30px;" align="right">员工类型：</td>
							<td><input type="text" name="salesmanType"  id="salesmanType"  style="width: 130px;" readonly="readonly"/></td>
							<td style="padding-left: 30px; " align="right">入司时间：</td>
							<td><input type="text" name="contractDate"  id="contractDate"  style="width: 130px;" readonly="readonly"/>
									<input name="contractDate"  id="contractDateNew"  type="hidden"/>
							</td>	
						</tr>
						<tr>
							<td style="padding-left: 15px; " align="right">入职日期：</td>
							<td><input type="text" name="entryDate"  id="entryDate" style="width: 130px;" readonly="readonly"/>
									<input name="entryDate"  id="entryDateNew"  type="hidden"/>
							</td>	
							<td style="padding-left: 30px; " align="right">转正日期：</td>
							<td><input type="text" name="regularDate"  id="regularDate" style="width: 130px;" readonly="readonly"/>
									<input name="regularDate"  id="regularDateNew"  type="hidden"/>
							</td>
							<td style="padding-left: 30px;" align="right">职务类型：</td>
							<td><input type="text" name="titleType"  id="titleType" style="width: 130px;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="padding-left: 15px;" align="right">职务：</td>
							<td><input type="text" name="title"  id="title" readonly="readonly"/></td>
							<td style="padding-left: 30px;" align="right">婚姻状态：</td>
							<td><input type="text" name="marry"  id="marry"  style="width: 130px;" readonly="readonly"/></td>
							<td style="padding-left: 30px;" align="right">部门：</td>
							<td><input type="text" name="deptExtend"  id="deptExtend"  readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="padding-left: 15px;" align="right">团队名称：</td>
							<td><input type="text" name="groupName"  id="groupName"  readonly="readonly"/></td>
							<td style="padding-left: 30px;" align="right">业务线：</td>
							<td><input type="text"  id="oldBusinessLine"  style="width: 130px;" readonly="readonly"/></td>
							<td style="padding-left: 30px; " align="right">员工编码：</td>
							<td><input type="text" name="salesmanCode"  id="salesmanCode"  readonly="readonly"/></td>								
						</tr>
						<tr>
							<td style="padding-left: 15px; " align="right">是否参加考核：</td>
							<td><input type="text" name="evaluate"  id="evaluate"  style="width: 130px;" readonly="readonly"/></td>
							<td style="padding-left: 30px; " align="right">销售职级：</td>
							<td><input type="text" name="rankName" id="rankName" readonly="readonly"/></td>
							<td style="padding-left: 30px; " align="right">是否试用期：</td>
							<td><input type="text" name="trytou"  id="trytou"   readonly="readonly"/></td>
						</tr>
						<tr>
						</tr>
					</table>
				</form>
			</fieldSet>
		</div>
		
		<!-- 业务线变更 -->
		<div>
			<fieldSet>
				<legend>业务线变更</legend>
				<form id="bizLineNewFrm">
					<table style="padding-left: 30px;">
						<tr>
							<td style="padding-left: 150px; " align="right">原业务线：</td>
							<td><input type="text" id="oldBusinessLine1" readonly="readonly"/></td>
							<td style="padding-left:53px; " align="right">新业务线：</td>
							<td><input style="width:151px;background-color:#FFF" type="text" name="businessLineNew" id="bizLineNew"/><span style="color:red">*</span></td>
							<td style="width:20px"><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
					</table>
				</form>
			</fieldSet>
		</div>
		
		<div>
			<table style="width: 100%">
				<tr>
					<td style="padding-left:30px;padding-top:10px" align="center">
					<a id="button-save" onclick="save()">保存</a>
					<a id="button-cancel"  onclick="cancel()">取消</a></td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>