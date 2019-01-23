<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser" %>    

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>专属保费计划</title>
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
     .fontClass{
	font-size:12px;
	font-family: 微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun;
}  
 </style>
 <%
String planMainId = request.getParameter("planMainId")==null?"":request.getParameter("planMainId");
%>
<script type="text/javascript">

$(function(){

	$(".gird-edit-btn").width("190px");
	var planMainId = $("#planMainId").val();
	if(planMainId=="undefined"){
		planMainId="";
	}
	
	$('#parentDeptCode').omCombo({
		dataSource : "<%=_path%>/salePlanChannel/querySalePlanChannel.do",
		emptyText : '请选择',
        optionField : function(data, index) {
            return data.text;
		},
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
        width : 152,
    });
 
	 
	$('#autoInsuranceTable').omGrid({
		 dataSource : "<%=_path%>/salePlanChannel/querySalePlanChannelByVo.do?planMainId="+planMainId+"&ChannelRiskType="+$("#autoChannelRiskType").val(),
         colModel : [ {header:"渠道",name:"channelCode",width:150, align : 'center',editor:{editable:true,rules:["required",true,"请输入渠道"]} },
                 	  {header:"保费",name:"targetPremium",width:150, align : 'center',editor:{editable:true,rules:["required",true,"请输入保费"]} } ],
         onSuccess:function(data, textStatus, event){
        	 //alert(data.rows);
        	 var rows = data.rows;
        	 if(rows != ''){
            	 $("#autoContent").val(rows[0].content);
            	 $("#autoRemark").val(rows[0].remark);
        	 }
         },
         limit:10,
         height : 200,
         width:  600
    });
	
	$('#propertyInsuranceTable').omGrid({
		dataSource : "<%=_path%>/salePlanChannel/querySalePlanChannelByVo.do?planMainId="+planMainId+"&ChannelRiskType="+$("#propertyChannelRiskType").val(),
        colModel : [ {header:"渠道",name:"channelCode",width:150, align : 'center',editor:{editable:true,rules:["required",true,"请输入渠道"]} },
                 	  {header:"保费",name:"targetPremium",width:150, align : 'center',editor:{editable:true,rules:["required",true,"请输入保费"]} } ],
    	 onSuccess:function(data, textStatus, event){
	       	 //alert(data.rows);
	       	 var rows = data.rows;
	       	if(rows != ''){
		       	 $("#propertyContent").val(rows[0].content);
		       	 $("#propertyRemark").val(rows[0].remark);
     	 	}
        },
         limit:10,
         height : 200,
         width:  600
    });
	
	$('#lifeInsuranceTable').omGrid({
		dataSource : "<%=_path%>/salePlanChannel/querySalePlanChannelByVo.do?planMainId="+planMainId+"&ChannelRiskType="+$("#lifeChannelRiskType").val(),
        colModel : [ {header:"渠道",name:"channelCode",width:150, align : 'center',editor:{editable:true,rules:["required",true,"请输入渠道"]} },
                 	  {header:"保费",name:"targetPremium",width:150, align : 'center',editor:{editable:true,rules:["required",true,"请输入保费"]} } ],
       	 onSuccess:function(data, textStatus, event){
  	       	 //alert(data.rows);
  	       	 var rows = data.rows;
  	       	if(rows != ''){
	  	    	 $("#lifeContent").val(rows[0].content);
	  	       	 $("#lifeRemark").val(rows[0].remark);
      	 	}
  	       	
          },
         limit:10,
         height : 200,
         width:  600
    });

	 $("#PlanMainFrom").validate({
     	rules : {
     		deptPremium : "required",
     		deptCode : "required",
   			year : "required",
			quarter : "required"
     	},
     	messages : {
     		deptPremium : "请输入保费",
     		deptCode : "请选择机构名称",
     		year : "请选择计划年度",
     		quarter : "请选择计划季度"
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
     
     $("#planWriteDate").val($.omCalendar.formatDate(new Date(),"yy-mm-dd"));
     
	//初始化页面保存、重置、取消按钮
	$("#buttonSave").omButton({
		icons : {left : '<%=_path%>/images/add.png'},
		width:50,
		onClick : function(event){
			
			var autoInsuranceTable = $("#autoInsuranceTable").omGrid("getData");
			var auto = autoInsuranceTable["rows"];
			//alert(JSON.stringify(auto));
			
			var propertyInsuranceTable = $("#propertyInsuranceTable").omGrid("getData");
			var property = propertyInsuranceTable["rows"];
			
			var lifeInsuranceTable = $("#lifeInsuranceTable").omGrid("getData");
			var life = lifeInsuranceTable["rows"];
			var autoInsuranceFrom = $("#autoInsuranceFrom").serializeObject();
			var propertyInsuranceForm = $("#propertyInsuranceForm").serializeObject();
			var lifeInsuranceForm = $("#lifeInsuranceForm").serializeObject();

			var spicJsonStr = "["+ JSON.stringify(autoInsuranceFrom)
           							+ ',' + JSON.stringify(propertyInsuranceForm)
     		 						+ ',' + JSON.stringify(lifeInsuranceForm) + "]";
			
			   if (!$("#PlanMainFrom").validate().form()) 
					return false;    
			 
			var sumPremium = 0;
			
			var autoTargetPremium = $("#autoInsuranceTable").omGrid('getData');
			var autoTargetPremiumEval = eval(autoTargetPremium.rows);
			for(var index = 0; index < autoTargetPremiumEval.length; index++){
				alert(autoTargetPremiumEval[index]["targetPremium"]);
				var targetPremium = autoTargetPremiumEval[index]["targetPremium"];
				sumPremium += parseFloat(targetPremium);
			 };
			
			var propertyTargetPremium = $("#propertyInsuranceTable").omGrid('getData');
			var propertyTargetPremiumEval = eval(propertyTargetPremium.rows);
			for(var index = 0; index < propertyTargetPremiumEval.length; index++){
				 //alert(propertyTargetPremiumEval[index]["targetPremium"]);
				 var targetPremium = propertyTargetPremiumEval[index]["targetPremium"];
				 sumPremium += parseFloat(targetPremium);
			 };
			 
			var lifeTargetPremium = $("#lifeInsuranceTable").omGrid('getData');
			var lifeTargetPremiumEval = eval(lifeTargetPremium.rows);
			for(var index = 0; index < lifeTargetPremiumEval.length; index++){
				 //alert(lifeTargetPremiumEval[index]["targetPremium"]);
				 var targetPremium = lifeTargetPremiumEval[index]["targetPremium"];
				 sumPremium += parseFloat(targetPremium);
			 };
		    alert(sumPremium);
     		if(parseFloat($("#deptPremium").val())>sumPremium){
     			$.omMessageBox.alert({
     				type:'error',
                     title:'失败',
	 					content:"渠道保费的和要大于总保费的值,现在渠道保费的值是： "+sumPremium +" 元"
	 				});
     			return;
     		}
			Util.post(
					"<%=_path%>/salePlanChannel/saveSalePlanChannel.do",
					$("#PlanMainFrom").serialize()+
					"&autoGrid="+JSON.stringify(auto)+
					"&propertyGrid="+JSON.stringify(property)+
					"&lifeGrid="+JSON.stringify(life)+
					"&spicJsonStr="+spicJsonStr,
					function(data) {
					   	window.location.href = "agentPlan.jsp";
			    });
		}
	});
	
	//新增按钮输入内容重置
	$("#buttonReset").omButton({
		icons : {left : '<%=_path%>/images/op-edit.png'},
		width:50,
		onClick : function(event){
			document.getElementById("PlanMainFrom").reset();
			document.getElementById("autoInsuranceFrom").reset();
			document.getElementById("propertyInsuranceForm").reset();
			document.getElementById("lifeInsuranceForm").reset();
		}
	}); 
	
	$("#buttonCancel").omButton({
		icons : {left : '<%=_path%>/images/remove.png'},
		width:50
	});

	$("#quarter").omCombo({
		dataSource : <%=Constant.getCombo("quarter")%>,
		value : ((new Date().getMonth())/3  )+1,
		width : 152
	});
	
	$("#deptCode").omCombo({
    	dataSource : "<%=_path%>/department/queryCityCompany.do?province=01"
    });

	$("#year").omCombo({
		dataSource : <%=Constant.getCombo("year")%>,
		value : ((new Date().getFullYear())),
		width : 152,
	 }); 
	
	//加载二级机构名称
 	$('#Province').omCombo({
         dataSource : "<%=_path%>/department/queryProvinceCompany.do?"+$("#filterFrm").serialize(),
         emptyText : '请选择',
         onValueChange : function(target, newValue, oldValue, event) {
             //取出第1个combo的当前值
             var currentParentDept = $('#Province').omCombo('value');
             if(currentParentDept != ''){
 	            //从后台取出三级机构的数据并赋值给第2个combo
            	 $("#deptCode").omCombo({
                 	dataSource : "<%=_path%>/department/queryCityCompany.do?province=01"
                 });
				} else {
						//初始级机构名称
						$('#deptCode').omCombo({
							dataSource : [ {
								text : '请选择',
								value : ''
							} ]
						});
					}
				},
				optionField : function(data, index) {
					return data.text;
				},
				width:154,
				valueField : 'value',
				inputField : 'text',
				filterStrategy : 'anywhere'
			});
	
 	if(planMainId != "" && planMainId != null){
 		
 	 	$.ajax({
 			url:"<%=_path%>/salePlanChannel/queryPlanMainByVo.do?planMainId="+planMainId,
 			type:"post",
 			error: function(){
 				$.omMessageBox.alert({
 					content:"后台出错！！！"
 				}); 
 			}, 
 			success: function(result){
 				var jsonResult = eval("["+result+"]");
 				$("#PlanMainFrom").find(":input").each(function(){
 					$(this).val(jsonResult[0][$(this).attr("name")]);
 					$(this).attr("disabled",true);
 				});
 				
 				$("#deptCode").omCombo({
    				value : jsonResult[0]["deptCode"],
 					readOnly : true
    			});
 				
 				$("#quarter").omCombo({
    				value : jsonResult[0]["quarter"],
 					readOnly : true
    			});
 				$("#year").omCombo({
    				value : jsonResult[0]["year"],
 					readOnly : true
    			});
 				var planChannelDetail = jsonResult[0]["planChannelDetail"];
    			for(var i=0;i<planChannelDetail.length;i++){
    				if(planChannelDetail[i]["channelRiskType"]=='1'){
    					$("#autoInsuranceFrom").find(":input").each(function(){
            				$(this).val(planChannelDetail[i][$(this).attr("name")]);
            			});
    				}else if(planChannelDetail[i]["channelRiskType"]=='2'){
    					$("#propertyInsuranceForm").find(":input").each(function(){
            				$(this).val(planChannelDetail[i][$(this).attr("name")]);
            			});
    				}else if(planChannelDetail[i]["channelRiskType"]=='3'){
    					$("#lifeInsuranceForm").find(":input").each(function(){
            				$(this).val(planChannelDetail[i][$(this).attr("name")]);
            			});
    				}
    			}
 			}
 		});
 	}
	

//初始化三级机构名称
$('#deptName').omCombo({
	optionField : function(data, index) {
		return data.text;
	},
	valueField : 'value',
	inputField : 'text',
	filterStrategy : 'anywhere'
});

	
});

//点击输入框
$("#deptCode").click(function() {
   showDropList();
});

$("#onClose").omButton({
	onClick:function(event){
		close();
	}
});





	$.fn.serializeObject = function() {
	     var o = {};
	     var a = this.serializeArray();
	     $.each(a, function() {
	         if (o[this.name]) {
	             if (!o[this.name].push) {
	                 o[this.name] = [ o[this.name] ];
	             }
	             o[this.name].push(this.value || '');
	         } else {
	             o[this.name] = this.value || '';
	         }
	     });
	     return o;
	 } 
//style="line-height: 30px;" style="font-weight: bold;"
	function close(){
		window.location.href = "deptPlan.jsp";
	}
 
</script>
	</head>
		<body>
			<div>
				<table class="fontClass" style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
					<tr><td>专属保费计划详情</td></tr>
				</table>
			</div>
			<div>
			 <fieldSet style="margin-top: 10px;">
			   <legend class="fontClass" style="margin-left: 40px;">基本信息</legend>
				<form id="PlanMainFrom">
					<input type="hidden" name="planMainId" id="planMainId" value="<%=planMainId%>">
					<input type="hidden" name="status" id="status" value="0">
					<input type="hidden" name="planType" id="planType" value="2">
						 <table class="fontClass">
					        <tr> 
						        <td style="padding-left:30px" align="right"><span class="label">机构部门：</span></td>
								<td>
									<input type="text" name="deptCode" id="deptCode" readonly="true" style="width:133px;"/><span style="color:red">*</span></td>
									<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					   		    <td style="padding-left: 30px;" align="right">总保费(万元):</td>
					   		    <td><input type="text" id="deptPremium" name="deptPremium"/><span style="color:red">*</span></td> 
					   		    <td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
					   		     <td style="padding-left: 30px;" align="right">计划制定人:</td>
					   		    <td>  
					   		    	<input type="text" id="planWriter" name="planWriter" readonly="readonly" value="<%=CurrentUser.getUser().getUserCName()%>" />
					   		    </td>
					   		    <td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
					   		</tr>
					   		<tr>
					   		    <td style="padding-left: 30px;" align="right">计划填写时间:</td>
					   		    <td>
					   		    	<input type="text" id="planWriteDate" name="planWriteDate" readonly="readonly" /> 
					   		    </td>
					   		    <td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
					   		    <td style="padding-left: 30px;" align="right">计划年度:</td>
					   		    <td><input type="text" id="year" name="year" readonly="true" /><span style="color:red">*</span></td>
					   		    <td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
					   		    <!-- <td style="padding-left: 30px;" align="right">计划季度:</td>
					   		    <td>
					   		    <input type="text" id="quarter" name="quarter" readonly="true"/><span style="color:red">*</span></td> -->
					   		    <td><input type="hidden" name="salePlanInfoContectJsonStr" id="salePlanInfoContectJsonStr" /> </td>
					   		 </tr>
					  </table>
				   </form>
				 </fieldSet>
		 
			<fieldSet style="margin-top: 10px;" id="channelRiskType=1">
					<legend class="fontClass" style="margin-left: 40px;" >车险信息</legend>
							<div id="autoInsuranceDiv" class="toolsDiv"></div>
							<table id="autoInsuranceTable" class="Grid"></table>
							<form id="autoInsuranceFrom">
								<input type="hidden" name="planChannelId" id="autoPlanChannelId" >
								<input type="hidden" name="channelRiskType" id="autoChannelRiskType" value="1" >
								<input type="hidden" name="channelCode" id="autoChannelCode">
								<input type="hidden" name="targetPremium" id="autoTargetPremium">
								
									<table class="fontClass" style="line-height: 30px;">
					    				<tr>
						   					 <td style="padding-left: 30px; padding-top: 30px;">发展思路及举措:</td>
					   						 <td style="padding-left: 30px; padding-top: 30px;" width="720">
					   							 <textarea id="autoContent" name="content" cols="80" rows="50" readOnly="true" style="width: 720;height: 80px;"></textarea>
					   						 </td>
				   						</tr>
				   						<tr>
					   						<td style="padding-left: 30px; padding-top: 30px;">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注:</td>
					   						<td style="padding-left: 30px; padding-top: 30px; width:720 ">
					   							<textarea id="autoRemark" name="remark" cols="80" rows="50"  readOnly="true" style="width: 720;height: 80px;"></textarea>
					   						</td>
				   						</tr>
					 		 		</table>
					 		 </form>
				 </fieldSet>
			 
			    <fieldSet style="margin-top: 10px;" id="channelRiskType=2">
					<legend class="fontClass" style="margin-left: 40px;">财险信息</legend>
				    <div id="propertyInsuranceDiv" class="toolsDiv" ></div>	
					<table id="propertyInsuranceTable" class="Grid"></table>
					<form id="propertyInsuranceForm">
						<input type="hidden" name="planChannelId" id="propertyPlanChannelId" >
						<input type="hidden" name="channelRiskType" id="propertyChannelRiskType" value="2" >
						<input type="hidden" name="channelCode" id="propertyChannelCode">
						<input type="hidden" name="targetPremium" id="propertyTargetPremium">
						 <table class="fontClass" style="line-height: 30px;" >
						    <tr>
							    <td style="padding-left: 30px; padding-top: 30px;">发展思路及举措:</td>
						   		<td style="padding-left: 30px; padding-top: 30px;" width="720">
						   			<textarea id="propertyContent" name="content" cols="80" rows="50"  readOnly="true" style="width: 720;height: 80px;"></textarea>
						   		</td>
					   		</tr>
					   		<tr>
						   		<td style="padding-left: 30px; padding-top: 30px;">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注:</td>
						   		<td style="padding-left: 30px; padding-top: 30px;" width="720">
						   			<textarea id="propertyRemark" name="remark" cols="80" rows="50" readOnly="true" style="width: 720;height: 80px;"></textarea>
						   		</td>
					   		</tr>
						 </table>
					</form>
				</fieldSet>
				
		 		<fieldSet style="margin-top: 10px;" id="channelRiskType=3">
					<legend class="fontClass"style="margin-left: 40px;">人险信息</legend>
					<div id="lifeInsuranceDiv" class="toolsDiv" ></div>
					<table id="lifeInsuranceTable" class="Grid"></table>
					<form id="lifeInsuranceForm">
						<input type="hidden" name="planChannelId" id="lifePlanChannelId" >
						<input type="hidden" name="channelRiskType" id="lifeChannelRiskType" value='3' >
						<input type="hidden" name="channelCode" id="lifeChannelCode">
						<input type="hidden" name="targetPremium" id="lifeTargetPremium">
						 <table class="fontClass" style="line-height: 30px;">
						    <tr>
						     	<td style="padding-left: 30px; padding-top: 30px;">发展思路及举措:</td>
						   		<td style="padding-left: 30px; padding-top: 30px;" width="720">
						   			<textarea id="lifeContent" name="content" cols="80" rows="50"  readOnly="true" style="width: 720;height: 80px;"></textarea>
						   		</td>
					   		</tr>
					   		<tr>
						   		<td style="padding-left: 30px; padding-top: 30px;">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注:</td>
						   		<td style="padding-left: 30px; padding-top: 30px;" width="720">
						   			<textarea id="lifeRemark" name="remark" cols="80" rows="50"  readOnly="true" style="width: 720;height: 80px;"></textarea>
					   			</td>
					   		</tr>
						 </table>
					</form>
				</fieldSet>  
				 <div>
				   <table style="width: 100%">
					<tr>
						<td style="padding-left:30px;padding-top:10px" align="center">
						<a href="javascript:history.go(-1);" id="buttonCancel" onclick="cancel()">取消</a></td>
					</tr>
				  </table>
				 </div>
		 </div>
	</body>
</html>