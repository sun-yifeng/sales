<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String planMainId = request.getParameter("planMainId")==null?"":request.getParameter("planMainId");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>专属保费计划</title>
<script type="text/javascript">
$(function(){
	
	var planMainId = $("#planMainId").val();
	if(planMainId=="undefined"){
		planMainId="";
	}
	
	$('#parentDeptCode').omCombo({
		dataSource : "<%=_path%>/salePlanChannel/querySalePlanChannel.do",
        optionField : function(data, index) {
            return data.text;
		},
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
        width : '153px'
    });
 
	$('.toolsDiv').omButtonbar({
       	btns : [{label:"新增",
        		     id:"addButton" ,
        		     icons : {left : '<%=_path%>/images/add.png'},
        	 		 onClick:function(){
        	 			$("#autoInsuranceDiv").click(function(){
        	 				$("#autoInsuranceTable").omGrid("insertRow");
        	 			});
        	 			$("#propertyInsuranceDiv").click(function(){
        	 				$("#propertyInsuranceTable").omGrid("insertRow");
        	 			});
        	 			$("#lifeInsuranceDiv").click(function(){
        	 				$("#lifeInsuranceTable").omGrid("insertRow");
        	 			});
       	 			 }
       			},
       			
       			{separtor:true},
       	        {label:"删除",
       	        	id:"delButton",
       	        	icons : {left : '<%=_path%>/images/delete.png'},
       	        	onClick:function(){
       	        		var autoDels ;
       	        		$("#autoInsuranceDiv").click(function(){
       	        			autoDels = $('#autoInsuranceTable').omGrid('getSelections');
       	        			if(autoDels <= 0){
   	       	            	 $.omMessageBox.alert({
   	  	 		 	            content: '请选择删除的记录！'
   	  	 		 	         });
          	            		 return;
          	            	}
       	        			$('#autoInsuranceTable').omGrid('deleteRow',autoDels);
       	        		});
       	        		
       	        		
       	        		var propertyDels = $('.propertyInsuranceTable').omGrid('getSelections');
       	        		var lifeDels = $('.lifeInsuranceTable').omGrid('getSelections');
       	            	
       	        		
       	        		
       	        		
       	            	if(propertyDels <= 0){
	       	            	 $.omMessageBox.alert({
	  	 		 	            content: '请选择删除的记录！'
	  	 		 	         });
       	            		 return;
       	            	}
       	            	
       	            	$('#propertyInsuranceTable').omGrid('deleteRow',propertyDels[0]);
       	            	
       	            	if(lifeDels <= 0){
       	            	 $.omMessageBox.alert({
  	 		 	            content: '请选择删除的记录！'
  	 		 	        });
       	            		return;
       	            	}
       	            	
       	            	$('#lifeInsuranceTable').omGrid('deleteRow',lifeDels[0]);
       	        	
       	        	}
       	        } ]
			});
	 
	$('#autoInsuranceTable').omGrid({
		 dataSource : "<%=_path%>/salePlanChannel/querySalePlanChannelByVo.do?planMainId="+planMainId+"&ChannelRiskType="+$("#autoChannelRiskType").val(),
         colModel : [ {header:"渠道",name:"channelCode",width:150, align : 'center',editor:{editable:true} },
                 	  {header:"保费",name:"targetPremium",width:150, align : 'center',editor:{editable:true} } ],
         onSuccess:function(data, textStatus, event){
        	 var rows = data.rows;
        	 $("#autoContent").val(rows[0].content);
        	 $("#autoRemark").val(rows[0].remark);
         },
         limit:10,
         height : 200,
         width:  600,
 		 singleSelect : false
    });
	
	$('#propertyInsuranceTable').omGrid({
		dataSource : "<%=_path%>/salePlanChannel/querySalePlanChannelByVo.do?planMainId="+planMainId+"&ChannelRiskType="+$("#propertyChannelRiskType").val(),
        colModel : [ {header:"渠道",name:"channelCode",width:150, align : 'center',editor:{editable:true} },
                 	  {header:"保费",name:"targetPremium",width:150, align : 'center',editor:{editable:true} } ],
    	 onSuccess:function(data, textStatus, event){
	       	 var rows = data.rows;
	       	 $("#propertyContent").val(rows[0].content);
	       	 $("#propertyRemark").val(rows[0].remark);
        },
         limit:10,
         height : 200,
         width:  600,
 		 singleSelect : false
    });
	
	$('#lifeInsuranceTable').omGrid({
		dataSource : "<%=_path%>/salePlanChannel/querySalePlanChannelByVo.do?planMainId="+planMainId+"&ChannelRiskType="+$("#lifeChannelRiskType").val(),
        colModel : [ {header:"渠道",name:"channelCode",width:150, align : 'center',editor:{editable:true} },
                 	  {header:"保费",name:"targetPremium",width:150, align : 'center',editor:{editable:true} } ],
       	 onSuccess:function(data, textStatus, event){
  	       	 var rows = data.rows;
  	       	 $("#lifeContent").val(rows[0].content);
  	       	 $("#lifeRemark").val(rows[0].remark);
          },
         limit:10,
         height : 200,
         width:  600,
 		 singleSelect : false
    });

	 
	//初始化页面保存、重置、取消按钮
	$("#buttonSave").omButton({
		icons : {left : '<%=_path%>/images/add.png'},
		width:50,
		onClick : function(event){
			
			var autoInsuranceTable = $("#autoInsuranceTable").omGrid("getData");
			var auto = autoInsuranceTable["rows"];
			alert(JSON.stringify(auto));
			
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
	$("#buttonReset").omButton({
		icons : {left : '<%=_path%>/images/op-edit.png'},
		width:50
	});
	$("#buttonCancel").omButton({
		icons : {left : '<%=_path%>/images/remove.png'},
		width:50
	});
	
	//加载二级机构名称
 	$('#Province').omCombo({
         dataSource : "<%=_path%>/department/queryProvinceCompany.do?"+$("#filterFrm").serialize(),
         onValueChange : function(target, newValue, oldValue, event) {
             //取出第1个combo的当前值
             var currentParentDept = $('#Province').omCombo('value');
             if(currentParentDept != ''){
 	            //从后台取出三级机构的数据并赋值给第2个combo
 	            $('#deptName').val('').omCombo('setData',
 	            		"<%=_path%>/department/queryCityCompany.do?province="+$("#Province").val());
				} else {
						//初始级机构名称
						$('#deptName').omCombo({
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
 				});
 				
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

	function close(){
		window.location.href = "deptPlan.jsp";
	}
 
</script>
	</head>
		<body>
			<div style="font-weight: bold;">
				<table style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
					<tr><td>专属保费计划修改</td></tr>
				</table>
			</div>
			<div>
			 <fieldSet style="margin-top: 10px;">
			   <legend style="margin-left: 40px;">基本信息</legend>
				<form id="PlanMainFrom">
					<input type="hidden" name="planMainId" id="planMainId" value="<%=planMainId%>">
					<input type="hidden" name="status" id="status" value="0">
					<input type="hidden" name="planType" id="planType" value="2">
						 <table style="line-height: 30px;">
					        <tr>  
						        <td style="padding-left: 30px;"><span class="label">机构名称：</span></td>
								<td style="padding-left: 30px;"><input name="formMap['parentDeptCode']" id="Province" /><span style="color:red">*</span></td>
								<td style="padding-left: 30px;"><span class="label">机构代码：</span></td>
								<td style="padding-left: 30px;"><input type="text" id="deptCode" name="deptCode" /><span style="color:red">*</span></td> 
					   		    <td style="padding-left: 30px;">总保费(元):</td>
					   		    <td style="padding-left: 30px;"><input type="text" id="deptPremium" name="deptPremium"/><span style="color:red">*</span></td> </tr>
					   		    <tr><td style="padding-left: 30px;">计划制定人:</td>
					   		    <td style="padding-left: 30px;">
					   		    	<!-- <input type="text" id="createdUser" name="createdUser"/><span style="color:red">*</span> -->
					   		    </td>
					   		    <td style="padding-left: 30px;">计划填写时间:</td>
					   		    <td style="padding-left: 30px;  ">
					   		    	<!-- <input type="text" value="不可填写系统默认当前时间" disabled="disabled"/> -->
					   		    </td>
					   		    <td style="padding-left: 30px;">计划年度:</td>
					   		    <td style="padding-left: 30px;"><input type="text" id="year" name="year"/><span style="color:red">*</span></td></tr>
					   		    <tr><td style="padding-left: 30px;">计划季度:</td>
					   		    <td style="padding-left: 30px;">
					   		    <select id="quarter" name="quarter">
						   		    <option> 请选择</option>
						   		    <option id="quarter" value="1">一季度</option>
						   		    <option id="quarter" value="2">二季度</option>
						   		    <option id="quarter" value="3">三季度</option>
						   		    <option id="quarter" value="4">四季度</option>
					   		    </select>
					   		    <span style="color:red">*</span></td>
					   		    <td><input type="hidden" name="salePlanInfoContectJsonStr" id="salePlanInfoContectJsonStr" /> </td>
				   		    </tr> 
					  </table>
				   </form>
				 </fieldSet>
		 
			<fieldSet style="margin-top: 10px;" id="channelRiskType=1">
					<legend style="margin-left: 40px;" >车险信息</legend>
							<div id="autoInsuranceDiv" class="toolsDiv"></div>
							<table id="autoInsuranceTable" class="Grid"></table>
							<form id="autoInsuranceFrom">
								<input type="hidden" name="planChannelId" id="autoPlanChannelId" >
								<input type="hidden" name="channelRiskType" id="autoChannelRiskType" value="1" >
								<input type="hidden" name="channelCode" id="autoChannelCode">
								<input type="hidden" name="targetPremium" id="autoTargetPremium">
								
									<table style="line-height: 30px;">
					    				<tr>
						   					 <td style="padding-left: 30px; padding-top: 30px;">发展思路及举措:</td>
					   						 <td style="padding-left: 30px; padding-top: 30px;" width="720">
					   							 <textarea id="autoContent" name="content" cols="80" rows="50" style="width: 720;height: 80px;"></textarea>
					   						 </td>
				   						</tr>
				   						<tr>
					   						<td style="padding-left: 30px; padding-top: 30px;">备注:</td>
					   						<td style="padding-left: 30px; padding-top: 30px; width:720 ">
					   							<textarea id="autoRemark" name="remark" cols="80" rows="50" style="width: 720;height: 80px;"></textarea>
					   						</td>
				   						</tr>
					 		 		</table>
					 		 </form>
				 </fieldSet>
			 
			    <fieldSet style="margin-top: 10px;" id="channelRiskType=2">
					<legend style="margin-left: 40px;">财险信息</legend>
				    <div id="propertyInsuranceDiv" class="toolsDiv" ></div>	
					<table id="propertyInsuranceTable" class="Grid" ></table>
					<form id="propertyInsuranceForm">
						<input type="hidden" name="planChannelId" id="propertyPlanChannelId" >
						<input type="hidden" name="channelRiskType" id="propertyChannelRiskType" value="2" >
						<input type="hidden" name="channelCode" id="propertyChannelCode">
						<input type="hidden" name="targetPremium" id="propertyTargetPremium">
						 <table style="line-height: 30px;" >
						    <tr>
							    <td style="padding-left: 30px; padding-top: 30px;">发展思路及举措:</td>
						   		<td style="padding-left: 30px; padding-top: 30px;" width="720">
						   			<textarea id="propertyContent" name="content" cols="80" rows="50" style="width: 720;height: 80px;"></textarea>
						   		</td>
					   		</tr>
					   		<tr>
						   		<td style="padding-left: 30px; padding-top: 30px;">备注:</td>
						   		<td style="padding-left: 30px; padding-top: 30px;" width="720">
						   			<textarea id="propertyRemark" name="remark" cols="80" rows="50" style="width: 720;height: 80px;"></textarea>
						   		</td>
					   		</tr>
						 </table>
					</form>
				</fieldSet>
				
		 		<fieldSet style="margin-top: 10px;" id="channelRiskType=3">
					<legend style="margin-left: 40px;">人险信息</legend>
					<div id="lifeInsuranceDiv" class="toolsDiv" ></div>
					<table id="lifeInsuranceTable" class="Grid" ></table>
					<form id="lifeInsuranceForm">
						<input type="hidden" name="planChannelId" id="lifePlanChannelId" >
						<input type="hidden" name="channelRiskType" id="lifeChannelRiskType" value='3' >
						<input type="hidden" name="channelCode" id="lifeChannelCode">
						<input type="hidden" name="targetPremium" id="lifeTargetPremium">
						 <table style="line-height: 30px;">
						    <tr>
						     	<td style="padding-left: 30px; padding-top: 30px;">发展思路及举措:</td>
						   		<td style="padding-left: 30px; padding-top: 30px;" width="720">
						   			<textarea id="lifeContent" name="content" cols="80" rows="50" style="width: 720;height: 80px;"></textarea>
						   		</td>
					   		</tr>
					   		<tr>
						   		<td style="padding-left: 30px; padding-top: 30px;">备注:</td>
						   		<td style="padding-left: 30px; padding-top: 30px;" width="720">
						   			<textarea id="lifeRemark" name="remark" cols="80" rows="50" style="width: 720;height: 80px;"></textarea>
					   			</td>
					   		</tr>
						 </table>
					</form>
				</fieldSet>  
				 <div>
				   <table style="width: 100%">
					<tr>
						<td style="padding-left:30px;padding-top:10px" align="right">
						<a id="buttonSave" onclick="save()">保存</a>
						<a href="javascript:history.go(-1);" id="buttonCancel" onclick="cancel()">取消</a></td>
					</tr>
				  </table>
				 </div>
		 </div>
	</body>
</html>