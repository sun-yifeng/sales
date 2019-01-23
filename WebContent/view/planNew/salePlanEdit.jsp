<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser" %>    
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加一条销售计划</title>
<style type="text/css">
	html, body{ height:100%; margin:0px; padding:0px;}
	body {font-size:12px;}
	.om-button {font-size:12px;}
	#nav_cont{width:580px;margin-left:auto;margin-right:auto;}
	input {border: 1px solid #A1B9DF;width:150px;vertical-align: middle;}
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
	.fontClass{font-size:12px;font-family: 微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun;}  
	.deptDropListTree {position: absolute; height: 180px; width: 155px; margin: 0px auto; border: 1px solid #9AA3B9; overflow: auto; display: none; background: #FFF; z-index: 4;}     
</style>
<script type="text/javascript">
var planType = ""+${param.planType}+"";
var bzlineData = null;
//险种 
var deptRiskTypeArr = [{text:"车险" , value:"1"},{text:"财产险" , value:"2"},{text:"人身险" , value:"3"}]
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
	
	//得到销售计划ID
	var planMainId = $("#planMainId").val();
	if(planMainId=="undefined"){
		planMainId="";
	}
	
    //新增明细列表工具栏，当编辑状态不显示
    if(planMainId==""){
    	$("#planDetailListBar").omButtonbar({
    		btns : [{
    			label:"新增",
    			id:"addButton" ,
    			icons : {left : '<%=_path%>/images/add.png'},
    			onClick:function(){
    	 			$("#planDetailGrid").omGrid("insertRow");
    	 			$(".gird-edit-btn").width("190px");
    			}
    		},{
    			label:"删除",
            	id:"delButton",
            	icons : {left : '<%=_path%>/images/op-delete.png'},
            	onClick:function(){
            		var autoDels = $('#planDetailGrid').omGrid('getSelections');
           			if(autoDels == ""){
      	            	$.omMessageBox.alert({ content: '请选择删除的记录！'});
    	                return;
    	            }
           			$('#planDetailGrid').omGrid('deleteRow',autoDels);
            	}
    		}]
    	});
    }
    
	
    //明细列表格
	$('#planDetailGrid').omGrid({
		 dataSource : "<%=_path%>/salePlan/querySalePlanDetailListByPlanId.do?planMainId="+planMainId+"",
         colModel : [ 
                       {header:"险种",name:"deptRiskType",width:200, align : 'center',
                    	editor:{
                    		editable:false,
                    		type:"omCombo",
                    		name:"deptRiskType",
                    		options:{
                    			editable:false,
                    			dataSource:deptRiskTypeArr
                        		//emptyText: '请选择'
                    		}
                       },renderer:function(colValue, rowData, rowIndex) {
                    	    if(colValue.indexOf("-")>-1){
                       		   colValue = colValue.split("-")[0];
                         	}
                    	    return "<font color=green>"+getDeptRiskTypeText(colValue)+"</font>";
                       }},
                       {header:"业务线",name:"lineCode",width:200, align : 'center',
                        editor:{
                        	editable:false,
                    		type:"omCombo",
                    		name:"lineCode",
                    		options:{
                    			editable:false,
                    			lazyLoad : true,
                    			dataSource:bzlineData
                        		//emptyText: '请选择',
                    		}
                        },renderer : function(colValue, rowData, rowIndex) {
                        	if(colValue.indexOf("-")>-1){
                        		colValue = colValue.split("-")[0];
                        	}
                        	return "<font color=green>"+getBzlineText(colValue)+"</font>";
                        }},
                       {header:"保费",name:"planFee",width:150,align:'center',editor:{editable:true,rules:[["required",true,"请输入保费"],["isDecimal"]]}},
                       {header:"发展思路及举措",name:"content",width:250,align:'center',editor:{editable:true} },
                       {header:"备注",name:"remark",width:150, align : 'center',editor:{editable:true}}
                    ],
         onSuccess:function(data, textStatus, event){
        	 
         },
         //编辑之后触发
         onAfterEdit:function(rowIndex , rowData){
        	 //设回
        	 var rowList = $("#planDetailGrid").omGrid("getData")["rows"];
        	 var deptRiskType = rowData.deptRiskType.split("-")[0];
        	 var lineCode = rowData.lineCode.split("-")[0];
        	 rowData.deptRiskType = deptRiskType;
        	 rowData.lineCode = lineCode;
        	 $.each(rowList,function(i,row){
            	 if(row.planDeptId==rowData.planDeptId){
            		 rowList[i] = rowData;
            	 }
             });
        	 $(this).omGrid('setData',rowList);
        	 
             //编辑结束时间统计保费
             var countFee = 0;
             $.each(rowList,function(i,row){
            	 var planFee = new Number(row.planFee);
            	 countFee=countFee+planFee;
             })
             $("#deptPremium").val(countFee);
         },
         //编辑之前触发
         onBeforeEdit:function(rowIndex , rowData){
        	 //重新设置险种和业务线内容
        	 var rowList = $("#planDetailGrid").omGrid("getData")["rows"];
        	 var deptRiskType = rowData.deptRiskType+"-"+getDeptRiskTypeText(rowData.deptRiskType);
        	 var lineCode = rowData.lineCode+"-"+getBzlineText(rowData.lineCode);
        	 rowData.deptRiskType = deptRiskType;
        	 rowData.lineCode = lineCode;
        	 $.each(rowList,function(i,row){
            	 if(row.planDeptId==rowData.planDeptId){
            		 rowList[i] = rowData;
            	 }
             });
        	 $(this).omGrid('setData',rowList);
         },
         limit:0,
         height:350,
         width:"90%"
    });
	
	 $("#PlanMainFrom").validate({
     	rules : {
     		deptPremium : {
     			required : true,
     			isDecimal : true
     		},
     		deptCode : "required",
   			year : {
   				required : true,
   				isNum : true,
    			maxlength: 4
   			}
     	},
     	messages : {
     		deptPremium : {
    			required : "请输入保费"
    		},
     		deptCode : "请选择机构名称",
     		year : {
     			required : "请选择计划年度",
     			maxlength:"请输入4为位数"
     		}
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
     
     $.validator.addMethod("isDeptPremium", function(value) {
       	 if(value == '') return true;
         var reg = new RegExp("^[0-9]*$");
         return reg.test(value);
       }, '请输入阿拉伯数字');
     
     $("#planWriteDate").val($.omCalendar.formatDate(new Date(),"yy-mm-dd"));
     
	//初始化页面保存、重置、取消按钮
	$("#buttonSave").omButton({
		icons : {left : '<%=_path%>/images/add.png'},
		width:50,
		onClick : function(event){
			var planDetailGrid = $("#planDetailGrid").omGrid("getData");
			var rowList = planDetailGrid["rows"];
			
			if (!$("#PlanMainFrom").validate().form()){
				return false;   
			}
			//计算总保费
			var sumPremium = 0;
			var autoTargetPremium = $("#planDetailGrid").omGrid('getData');
			var autoTargetPremiumEval = eval(autoTargetPremium.rows);
			for(var index = 0; index < autoTargetPremiumEval.length; index++){
				var targetPremium = autoTargetPremiumEval[index]["targetPremium"];
				sumPremium += parseFloat(targetPremium);
			};
			
     		if(parseFloat($("#deptPremium").val())>sumPremium){
     			$.omMessageBox.alert({
     				type:'error',
                     title:'失败',
	 					content:"渠道保费的和要大于总保费的值,现在渠道保费的值是： "+sumPremium +"万 元"
	 				});
     			return;
     		}
     		
    		//alert($("#deptCode").val());
    		if($("#deptCode").val() == "00"){
    			$.omMessageBox.alert({
     				type:'error',
                     title:'新增失败',
	 					content:"总公司不能新增！"
	 				});
     			return;
    		}
    		
    		var status = $("#status").val();
    		var deptCode = $("#deptCode").val();
    		if(deptCode.indexOf("-")>-1){
    			deptCode = deptCode.substring(0,deptCode.indexOf("-"));
    		}
    		var deptPremium = $("#deptPremium").val();
    		var planWriter = $("#planWriter").val();
    		var planWriteDate = $("#planWriteDate").val();
    		//提交数据
    		//设回
        	$.each(rowList,function(i,row){
            	 if(row.deptRiskType.indexOf("-")>-1){
            		 rowList[i].deptRiskType = row.deptRiskType.split("-")[0];
            	 }
            	 if(row.lineCode.indexOf("-")>-1){
            		 rowList[i].lineCode = row.lineCode.split("-")[0];
            	 }
            });
    		//planDetailGrid:"\""+JSON.stringify(rowList)+"\"",
			$.post("<%=_path%>/salePlan/saveSalePlan",{
				planDetailGrid:JSON.stringify(rowList),
				planMainId:planMainId,
				status:status,
				planType:planType,
				deptCode:deptCode,
				deptPremium:deptPremium,
				planWriter:planWriter,
				writeDate:planWriteDate},
			    function(jsonData){
					if(jsonData.actionFlag){
						 $.omMessageBox.alert({
				                type:'success',
				                title:'成功',
				                content:jsonData.actionMsg
				         });
						 window.location.href = "salePlanList.jsp?planType="+planType;
					}else{
						$.omMessageBox.alert({
			                type:'error',
			                title:'失败',
			                content:jsonData.actionMsg
			           });
					}
		    },"json");
		}
	});

	$("#buttonReset").omButton({
		icons : {left : '<%=_path%>/images/clear.png'},
		width:50,
		onClick : function(event){
			window.location.href = "<%=_path%>/view/plan/addAgentPlan.jsp";
		}
	}); 
	
	$("#buttonCancel").omButton({
		icons : {left : '<%=_path%>/images/remove.png'},
		width:50
	});

	$("#year").omCombo({
		dataSource : <%=Constant.getCombo("year")%>,
		value : ((new Date().getFullYear())),
		editable : false
	 }); 
	
	//如果计划ID不空空则从数据库查出
 	if(planMainId != "" && planMainId != null){
 	 	$.ajax({
 			url:"<%=_path%>/salePlan/querySalePlanByVo.do?planMainId="+planMainId,
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
 				$("#quarter").omCombo({
    				value:jsonResult[0]["quarter"]
    			});
 				$("input[name='year']").omCombo({
    				value : jsonResult[0]["year"]
    			});
 				//转换计划填写日期为yyyy-MM-dd
 				var planWriteDate = new Number($("#planWriteDate").val());
 				var writeDate = new Date(planWriteDate);
 				var fullYear = writeDate.getFullYear();
 				var month = (writeDate.getMonth()+1);
 				if(month<10){
 					month = "0"+month; 
 				}
 				var day = writeDate.getDate();
 				if(day<10){
 					day = "0"+day; 
 				}
 				var date = fullYear+"-"+month+"-"+day;
 				$("#planWriteDate").val(date);
 			}
 		});
 	}else {
 		//点击下拉按钮
		$("#choose").click(function() {
		   showDropList();
		});

		//点击输入框
		$("#deptCode").click(function() {
		   showDropList();
		});
 	}
	

//初始化三级机构名称
$('#deptName').omCombo({
	optionField : function(data, index) {
		return data.text;
	},
	valueField : 'value',
	inputField : 'text',
	filterStrategy : 'anywhere',
});


//点击输入框
$("#deptCode").click(function() {
	dataSource : "<%=_path%>/department/queryCityCompany.do?province=01",
    showDropList();
});

//加载下拉框机构组件
$("#deptDropListTree").omTree({
    dataSource : "<%=_path%>/department/queryDeptDropList.do",
    simpleDataModel:true,
    onBeforeExpand : function(node){
    	
	  var nodeDom = $("#"+node.nid);
	  if(nodeDom.hasClass("hasChildren")){
		nodeDom.removeClass("hasChildren");
		$.ajax({
			url: '<%=_path%>/department/queryDeptDropList.do?parentCode='+node.id,
			method: 'POST',
			dataType: 'json',
			success: function(data){
				$("#deptDropListTree").omTree("insert", data, node);
			}
		});
	 }
	return true;
   },
   //触发选择事件时，回填数据到输入框
   onSelect : function(nodedata) {
     var ndata = nodedata, text = ndata.text;
     ndata = $("#deptDropListTree").omTree("getParent", ndata);
     while (ndata) {
        //text = ndata.text + "-" + text;
        ndata = $("#deptDropListTree").omTree("getParent", ndata);
     }

     //$("#deptCname").val(text); //填充部门名称
     $("#deptCode").val(nodedata.id+"-"+text); //填充部门代码

     //
     hideDropList();
   },
   //
   onBeforeSelect : function(nodedata) {
     if (nodedata.children) {
        return true;
     }
   }
});

//得到业务线文本
function getBzlineText(codeV){
	var lineText = "";
	$.each(bzlineData,function(i,bzline){
		if(bzline.value==codeV){
			lineText = bzline.text;
		}
	});
	return lineText;
}

//得到险种文本
function getDeptRiskTypeText(codeV){
	var ristText = "";
	$.each(deptRiskTypeArr,function(i,deptRiskType){
		if(deptRiskType.value==codeV){
			ristText = deptRiskType.text;
		}
	});
	return ristText;
}

//显示下来框
function showDropList() {  
   $("#deptDropListTree").show();     
   //body绑定mousedown事件
   $("body").bind("mousedown", onBodyDown);
}

//隐藏下来框
function hideDropList() {
   $("#deptDropListTree").hide();
   $("body").unbind("mousedown", onBodyDown);
}

//
function onBodyDown(event) {
   if(!(event.target.id == "choose" || event.target.id == "deptDropList" || $(event.target).parents("#deptDropList").length > 0)) {
	       hideDropList();
     }
    }
});

function close() {
   window.location.href = "salePlanList.jsp?planType="+planType;
}
</script>
</head>
<body>
		 <div>
			<table class="fontClass" style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;margin-top:10px">
				<tr>
				 <td>
				   <c:choose>
				       <c:when test="${param.planType==1}">
					        <c:choose>
						       <c:when test="${param.planMainId!=null}">
						                      销售保费计划修改           
						       </c:when>
						       <c:otherwise>
						                      销售保费计划新增
						       </c:otherwise>
						    </c:choose>
				       </c:when>
				       <c:otherwise>
					       <c:choose>
						       <c:when test="${param.planMainId!=null}">
						                       专属保费计划修改
						       </c:when>
						       <c:otherwise>
						                      专属保费计划新增
						       </c:otherwise>
						    </c:choose>
					   </c:otherwise>
				   </c:choose>
				 </td>
				 </tr>
			</table>
		 </div>
		<div>
		 <fieldSet style="margin-top: 10px;">
		 <legend class="fontClass" style="margin-left: 40px;">基本信息</legend>
		     <form id="PlanMainFrom">
			 <input type="hidden" name="planMainId" id="planMainId" value="${param.planMainId}">
		     <input type="hidden" name="status" id="status" value="0">
		     <input type="hidden" name="planType" id="planType" value="${param.planType }">
			 <table class="fontClass">
		        <tr>  
			        <td align="right">机构名称:</td>
		 		    <td align="left">
		  		       <c:choose>
				         <c:when test="${param.planMainId!=null}">
				            <span class="om-combo om-widget om-state-default">
				 		       <input type="text" name="deptCode" id="deptCode" class="sele" readonly="readonly"/>
				 		       <span id="choose" name="choose" class="om-combo-trigger"></span>
			 		       </span>
			 		       <span style="color:red">*</span>
				         </c:when>
				         <c:otherwise>
				           <span class="om-combo om-widget om-state-default">
				 		       <input type="text" name="deptCode" id="deptCode" class="sele"/>
				 		       <span id="choose" name="choose" class="om-combo-trigger"></span>
			 		       </span>
			 		       <span style="color:red">*</span>
			  		       <div id="deptDropList" >
			  		          <ul id="deptDropListTree" class="deptDropListTree"></ul>
			  		       </div>
				         </c:otherwise>
				      </c:choose>
		 		    </td>
		 		    <td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
		   		    <td style="padding-left: 30px;" align="right">总保费(万元):</td>
		   		    <td><input type="text" id="deptPremium" name="deptPremium" readonly="readonly"/><span style="color:red">*</span></td> 
		   		    <td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
		   		    <td style="padding-left: 30px;" align="right">计划制定人:</td>
		   		    <td><input type="text" id="planWriter" name="planWriter" readonly="readonly" value="<%=CurrentUser.getUser().getUserCName() %>" /></td>
		   		    <td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
		   		</tr>
		   		<tr>
				    <td style="padding-left: 30px;" align="right">计划年度:</td>
				    <td>
				      <c:choose>
				         <c:when test="${param.planMainId!=null}">
				            <input type="text" id="curYear" name="year" class="sele" readonly="readonly" />
				         </c:when>
				         <c:otherwise>
				            <input type="text" id="year" name="year" class="sele" />
				         </c:otherwise>
				      </c:choose>
				     <span style="color:red">*</span></td>
				    <td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td> 
			   		<td style="padding-left: 30px;" align="right">计划填写时间:</td>
					<td><input type="text" id="planWriteDate" name="planWriteDate" readonly="readonly" /></td>
					<td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td></td>
				</tr>
		     </table>
			 </form>
		</fieldSet>
		    <!-- 表格开始 -->
		        <div id="planDetailListBar" class="toolsDiv"></div>
				<table id="planDetailGrid" class="Grid" ></table>
		    <!-- 表格结束 -->
		 <div>
		   <table style="width: 100%">
			<tr>
				<td style="padding-left:30px;padding-top:10px" align="center">
				<a id="buttonSave">保存</a>
				<a href="javascript:history.go(-1);" id="buttonCancel" onclick="cancel()">取消</a></td>
			</tr>
		  </table>
		 </div>
		 </div>
	</body>
</html>