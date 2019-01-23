<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser" %>    
<% String planMainId= request.getParameter("planMainId") == null? "" : request.getParameter("planMainId");%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增部门销售计划</title>
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
     .errorImg{background: url("../../images/msg.png") left no-repeat scroll 0 0 transparent;height: 16px;width: 16px;cursor: pointer;}
     .errorMsg{border: 1px solid gray;background-color: #FCEFE3;display: none;position: absolute;margin-top: -18px;margin-left: 5px;}
     input.error,textarea.error{border: 1px solid red;}
 
 	.deptDropListTree {
 		position: absolute;
		height: 180px;
	    width: 155px;
		margin: 0px auto;
		border: 1px solid #9AA3B9;
		overflow: auto;
		display: none;
		background: #FFF;
		z-index: 4;
	}
	
    .fontClass{
	    font-size:12px;
	    font-family: 微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun;
}
 </style>
<script type="text/javascript">
$(document).ready(function() {
   $(".setWidth").css("width","130px");        
   $("#deptCode").css({"background-color":"transparent"});
   //计划机构
   $.validator.addMethod("validateDeptCode", function(value) {
	   	var tmpDeptCode = $('#deptCode').val().split("-")[0];
	   	//alert(tmpDeptCode);
	   	if(tmpDeptCode == '00' || tmpDeptCode.length > 4){
	   		return false;
		}
		return true;  	
	}, '只能选择分公司或支公司');
	
   //计划年度
   $.validator.addMethod("validateYear", function(value) {
	   var planMainId = $("#planMainId").val();
	   //如果是修改
	   if(planMainId != null && planMainId != ''){
          return true;
	   }
	   //
	   var planFlag = false;
	   $.ajax({
		   url:"<%=_path%>/salePlanDept/checkExistPlan.do",
		   type:'post',
		   data:{"deptCode":$('#deptCode').val().split("-")[0],"year":$('#year').val()},
		   dataType:'json',
		   cache:false,
		   async:false,
		   success:function(data){
			   planFlag = data;
			   //alert(planFlag);
		   },
		   error:function(error){
			   //alert(error);		
		   }
	   	});
	   	return planFlag;
	}, '该年度已经存在保费计划');

   //校验基本信息
   $("#planInfo").validate({
   	rules : {
   		deptCode : {
   			required: true,
   			validateDeptCode: true
   		},
   	    year : {
   		    required: true,
   		    validateYear: true,
  			isNum : true,
  			maxlength: 4
   	    },
   	},
   	messages : {
   		deptCode : {
   			required: "请选择机构"  			
   		},
   		year : {
    		required: "请输入计划年份",   		
    		maxlength:"请输入4为位数"
    	    },
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
   
   $("#autoInsuranceFrom").validate({
   	rules : {
   		financePreminum : {
   			required: true,
   			isDecimal : true
   		},
   		iportantPremium : {
    		required: true,
    		isDecimal : true
    	},
    	normalPremium : {
   			required: true,
   			isDecimal : true
   		}
   	},
   	messages : {
   		financePreminum : {
   			required: "请输入金融保费金额值"
   		},
   		iportantPremium : {
    		required: "请输入渠道重客保费金额值"
    	},
    	normalPremium : {
   			required: "请输入其他业务保费值"
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
   
   $("#propertyInsuranceFrom").validate({
   	rules : {
   		financePreminum : {
   			required: true,
   			isDecimal : true
   		},
   		iportantPremium : {
    		required: true,
    		isDecimal : true
    	},
    	normalPremium : {
   			required: true,
   			isDecimal : true
   		}
   	},
   	messages : {
   		financePreminum : {
   			required: "请输入金融保费金额值"
   		},
   		iportantPremium : {
    		required: "请输入渠道重客保费金额值"
    	},
    	normalPremium : {
   			required: "请输入其他业务保费值"
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
      
  $("#lifeInsuranceFrom").validate({
      	rules : {
      		financePreminum : {
      			required: true,
      			isDecimal : true
      		},
      		iportantPremium : {
       		required: true,
       		isDecimal : true
       	},
       	normalPremium : {
      			required: true,
      			isDecimal : true
      		}
      	},
      	messages : {
      		financePreminum : {
      			required: "请输入金融保费金额值"
      		},
      		iportantPremium : {
       		required: "请输入渠道重客保费金额值"
       	},
       	normalPremium : {
      			required: "请输入其他业务保费值"
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

      //提交
      $("#onsubmit").omButton({
      	icons : {left : '<%=_path%>/images/add.png'},
      	onClick:function(event){
      		if (!$("#planInfo").validate().form()) 
      			return false;
      		if (!$("#autoInsuranceFrom").validate().form()) 
      			return false;
   			if (!$("#propertyInsuranceFrom").validate().form()) 
       			return false;	
   			if (!$("#lifeInsuranceFrom").validate().form()) 
       			return false;	
      		var sumPremium = 0;
      		var financePreminum = $("input[name='financePreminum']");
      		financePreminum.each(function(){
      			sumPremium += parseFloat($(this).val());
      		});
      		
      		var iportantPremium = $("input[name='iportantPremium']");
      		iportantPremium.each(function(){
      			sumPremium += parseFloat($(this).val());
      		});
      		
      		var normalPremium = $("input[name='normalPremium']");
      		normalPremium.each(function(){
      			sumPremium += parseFloat($(this).val());
      		});
      		//alert(sumPremium);
      		if(parseFloat($("#deptPremium").val())>sumPremium){
      			$.omMessageBox.alert({
      				type:'error',
                    title:'失败',
					content:"渠道保费的和要大于总保费的值,现在渠道保费的值是： "+sumPremium +" 万元"
				});
      			return;
      		}
      			
      		var autoInsuranceFrom = $("#autoInsuranceFrom").serializeObject();
      		var propertyInsuranceFrom = $("#propertyInsuranceFrom").serializeObject();
      		var lifeInsuranceFrom = $("#lifeInsuranceFrom").serializeObject();
      		//alert(JSON.stringify(autoInsuranceFrom));
      		$("#salePlanDeptSet").val("[" + JSON.stringify(autoInsuranceFrom)
      		                            + ',' + JSON.stringify(propertyInsuranceFrom)
      		                            + ',' + JSON.stringify(lifeInsuranceFrom) + "]");
      		//alert($("#salePlanDeptSet").val());
      		var deptCodeT = $("#deptCode").val();
      		$("#deptCode").val($("#deptCode").val().split("-")[0]);
      		if($("#deptCode").val() == "00"){
      			$.omMessageBox.alert({
       				type:'error',
                       title:'新增失败',
  	 					content:"总公司不能新增！"
  	 				});
       			return;
      		}
      		Util.post('<%=_path%>/salePlanDept/saveSalePlanDept.do',$("#planInfo").serialize(),function(data){
	   			if(data=="success"){
	   				close();
	   			}else if(data=="error"){
	   				$.omMessageBox.alert({
	    				type:'error',
	                    title:'失败',
	 					content:"该机构已经有保费计划，不能重复新增！"
	 				});
	   			}
			  }
            );
      		
      		$("#deptCode").val(deptCodeT);
      	}
      });
      
      $("#onClose").omButton({
      	icons : {left : '<%=_path%>/images/remove.png'},
      	onClick:function(event){
      		close();
      	}
      });
      
      $("#planWriteDate").omCalendar({
      	dateFormat  : "yy-mm-dd",
      	editable : false
      });
      
      $("#planWriteDate").val($.omCalendar.formatDate($("#planWriteDate").omCalendar("getDate"),"yy-mm-dd"));
      
      $("#year").val(new Date().getFullYear());
      
      var planMainId = $("#planMainId").val();
      if(planMainId != ""){
        //年度计划
        $("#year").attr({readonly:"readonly"});
        $("#year").css({"background-color":"#F0F0F0"});
        //
      	$.ajax({
      		url:"<%=_path%>/salePlanDept/querySalePlanDeptByVo.do?planMainId="+planMainId,
      		type:"post",
      		error: function(){
      			$.omMessageBox.alert({
      				content:"后台出错！！！"
      			});
      		},
      		success: function(result){
      			//alert(eval("["+result+"]")[0]["planDeptDetail"]);
      			var jsonResult = eval("["+result+"]");
      			$("#planInfo").find(":input").each(function(){
      				$(this).val(jsonResult[0][$(this).attr("name")]);
      			});
      			//回填
      			var planDeptDetail = jsonResult[0]["planDeptDetail"];
      			for(var i=0;i<planDeptDetail.length;i++){
      				if(planDeptDetail[i]["deptRiskType"]=='1'){
      					$("#autoInsuranceFrom").find(":input").each(function(){
              				$(this).val(planDeptDetail[i][$(this).attr("name")]);
              			});
      				}else if(planDeptDetail[i]["deptRiskType"]=='2'){
      					$("#propertyInsuranceFrom").find(":input").each(function(){
              				$(this).val(planDeptDetail[i][$(this).attr("name")]);
              			});
      				}else if(planDeptDetail[i]["deptRiskType"]=='3'){
      					$("#lifeInsuranceFrom").find(":input").each(function(){
              				$(this).val(planDeptDetail[i][$(this).attr("name")]);
              			});
      				}
      			}
      		}
      	});
      }
      
      //加载下拉框机构组件
      $("#deptDropListTree").omTree({
         dataSource : "<%=_path%>/department/queryDeptDropList.do",
  	     simpleDataModel:true,
  	     //
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
      if(planMainId == ""){
      	//点击下拉按钮
          $("#choose").click(function() {
             showDropList();
          });
          
          //点击输入框
          $("#deptCode").click(function() {
             showDropList();
          });
          
          $("#year").omCombo({
      		dataSource : <%=Constant.getCombo("year")%>,
      		value : ((new Date().getFullYear())),
      		editable : false,
      		width : 155
      	 }); 
      }
      
      //显示下来框
      function showDropList() {  
         $("#deptDropListTree").show();     
         //body绑定mousedown事件
         $("body").bind("mousedown", onBodyDown);
      };
      
      //隐藏下来框
      function hideDropList() {
         $("#deptDropListTree").hide();
         $("body").unbind("mousedown", onBodyDown);
      };
      
      //
      function onBodyDown(event) {
         if(!(event.target.id == "choose" || event.target.id == "deptDropList" || $(event.target).parents("#deptDropList").length > 0)) {
     	       hideDropList();
           }
      };
      
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
};
 
 //
 function close(){
	 window.location.href = "deptPlan.jsp";
 };

var premArray = ['autoNormalPremium','autoIportantPremium','autoFinancePreminum',
                 'propertyNormalPremium','propertyIportantPremium','propertyFinancePreminum',
                 'lifeNormalPremium','lifeIportantPremium','lifeFinancePreminum'];
//onkeyupClick
function calcPremium(){
	var totalPrem = 0 ;
	for(i = 0; i < premArray.length; i++){
		var tmp = parseFloat($('#'+premArray[i]).val());
		if(tmp > 0){
			totalPrem += tmp;
		}
	}
	$('#deptPremium').val(totalPrem);
}
</script>

</head>
<body>
	<div class="fontClass"  style="border: solid #d0d0d0 1px; padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
		<table >
		    <% if(planMainId.equals("")){ %>
				<tr><td>销售保费计划新增</td></tr>
			<% }else { %>
				<tr><td>销售保费计划修改</td></tr>
			<% } %>
		</table>
	</div>
	<fieldSet style="margin-top: 10px;">
	<legend class="fontClass" style="margin-left: 40px;">基本信息</legend> 		 
	 <form id="planInfo" >
	 	<input type="hidden" name="planMainId" id="planMainId" value="<%=planMainId %>">
		<input type="hidden" name="planType" id="planType" value="1">
		<input type="hidden" name="status" id="status" value="0">
		<input type="hidden" name="salePlanDeptSet" id="salePlanDeptSet" value="1"/>
		<input type="hidden" name="operateType" id="operateType" value=""/>
		<table>
		    <tr>
		      <td align="right" style="padding-left: 15px;">机构名称:</td>
		      <td align="left">
		      	<span class="om-combo om-widget om-state-default">
 		      	<input type="text" name="deptCode" id="deptCode" class="setWidth" readonly="readonly"/>
 		      	<span id="choose" name="choose" class="om-combo-trigger"></span></span><span style="color:red">*</span>
		      	<div id="deptDropList" ><ul id="deptDropListTree" class="deptDropListTree"></ul></div>
		      </td>
		      <td><span class="errorImg"></span><span class="errorMsg"></td>
		      <td align="right" style="padding-left: 25px;">总保费(万元):</td>
		      <td><input type="text" name="deptPremium" id="deptPremium" width="100%" readOnly="readonly" /></td>
		      <td align="right" style="padding-left: 25px;">计划制定人:</td>
		      <td align="left"><input type="text" name="planWriter" id="planWriter" readOnly="readonly" value="<%=CurrentUser.getUser().getUserCName()%>"/></td>
		    </tr>
		    <tr>
		      <td align="right">计划年度:</td> 
		      <td align="left"><input type="text" name="year" id="year" /><span style="color:red">*</span></td>
		      <td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
		      <td align="right">计划填写时间:</td>
		      <td align="left"><input type="text" id="planWriteDate" name="planWriteDate" readonly="readonly" class="setWidth" /></td>
		    </tr>
		  </table> 
	  </form>
     </fieldSet>
	
	<fieldSet style="margin-top: 10px;" id="deptRiskType=1">
	    <legend class="fontClass" style="margin-left: 40px;">车险销售计划</legend>
		<form id="autoInsuranceFrom" >
		<input type="hidden" name="deptRiskType" id="autoDeptRiskType"  value="1" >
		<input type="hidden" name="planDeptId" id="autoPlanDeptId" >
		<table>
	    <tr>
	      <td align="right" style="padding-left: 15px;">其他业务保费值:</td>
	      <td><input type="text" name="normalPremium" id="autoNormalPremium" onkeyup="calcPremium()" /><span style="color:red">*</span></td>
	      <td><span class="errorImg"></span><span class="errorMsg"></span></td>
	      <td align="right">渠道重客保费值:</td>
	      <td><input type="text" name="iportantPremium" id="autoIportantPremium" onkeyup="calcPremium()"/><span style="color:red">*</span></td>
	      <td><span class="errorImg"></span><span class="errorMsg"></span></td>
	      <td align="right">金融保险保费值:</td>
	      <td><input type="text" name="financePreminum" id="autoFinancePreminum" onkeyup="calcPremium()"/><span style="color:red">*</span></td>
	      <td><span class="errorImg"></span><span class="errorMsg"></span></td>
	    </tr>		     
	    <tr>
	     <td colspan="1" align="right">发展思路及举措:</td>
	     <td colspan="8" align="left"><textarea cols="5" rows="3" style="width: 650px;height: 60px;" name="content" id="autoContent" ></textarea></td>
	    </tr>
	     <tr>
	     <td colspan="1" align="right">备注:</td>
	     <td colspan="8" align="left"><textarea cols="5" rows="3" style="width: 650px;height: 60px;" name="remark" id="autoRemark" ></textarea></td>
	    </tr>
	  </table> 
	  </form>
	</fieldSet>
	
	<fieldSet style="margin-top: 10px;" id="deptRiskType=2">
        <legend class="fontClass" style="margin-left: 40px;">财险销售计划</legend>
		<form id="propertyInsuranceFrom" >
		<input type="hidden" name="deptRiskType" id="propertyDeptRiskType"  value="2" >
		<input type="hidden" name="planDeptId" id="propertyPlanDeptId" >
		<table>
	    <tr>
	      <td align="right" style="padding-left: 15px;">其他业务保费值:</td>
	      <td><input type="text" name="normalPremium" id="propertyNormalPremium" onkeyup="calcPremium()" /><span style="color:red">*</span></td>
	      <td><span class="errorImg"></span><span class="errorMsg"></span></td>
	      <td align="right">渠道重客保费值:</td>
	      <td><input type="text" name="iportantPremium" id="propertyIportantPremium" onkeyup="calcPremium()" /><span style="color:red">*</span></td>
             <td><span class="errorImg"></span><span class="errorMsg"></span></td>
	      <td align="right">金融保险保费值:</td>
	      <td><input type="text" name="financePreminum" id="propertyFinancePreminum" onkeyup="calcPremium()" /><span style="color:red">*</span></td>
	      <td align="right"><span class="errorImg"></span><span class="errorMsg"></span></td>
	    </tr>
	    <tr>
	     <td colspan="1" align="right">发展思路及举措:</td>
	     <td colspan="8" align="left"><textarea cols="5" rows="3" style="width: 650px;height: 60px;" name="content" id="propertyContent" ></textarea></td>
	    </tr>
	    <tr>
	     <td colspan="1" align="right">备注:</td>
	     <td colspan="8" align="left"><textarea cols="5" rows="3" style="width: 650px;height: 60px;" name="remark" id="propertyRemark" ></textarea>
	     </td>
	    </tr>
	  </table> 
	  </form>
	</fieldSet>
	
	<fieldSet style="margin-top: 10px;" id="deptRiskType=3">
        <legend class="fontClass" style="margin-left: 40px;">人险销售计划</legend>
		<form id="lifeInsuranceFrom" >
		<input type="hidden" name="deptRiskType" id="lifeDeptRiskType" value="3" >
		<input type="hidden" name="planDeptId" id="lifePlanDeptId3" >
		<table>
	    <tr>
	      <td align="right" style="padding-left: 15px;">其他业务保费值:</td>
	      <td><input type="text" name="normalPremium" id="lifeNormalPremium" onkeyup="calcPremium()" /><span style="color:red">*</span></td>
	      <td><span class="errorImg"></span><span class="errorMsg"></td>
	      <td align="right">渠道重客保费值:</td>
	      <td><input type="text" name="iportantPremium" id="lifeIportantPremium" onkeyup="calcPremium()" /><span style="color:red">*</span></td>
	      <td><span class="errorImg"></span><span class="errorMsg"></td>
	      <td align="right">金融保险保费值:</td>
	      <td><input type="text" name="financePreminum" id="lifeFinancePreminum" onkeyup="calcPremium()" /><span style="color:red">*</span></td>
	      <td><span class="errorImg"></span><span class="errorMsg"></td>
	    </tr>
	    <tr>
	     <td colspan="1" align="right">发展思路及举措:</td>
	     <td colspan="8" align="left"><textarea cols="5" rows="3" style="width: 650px;height: 60px;" name="content" id="lifeContent" ></textarea></td>
	    </tr>
	     <tr>
	     <td colspan="1" align="right">备注:</td>
	     <td colspan="8" align="left"><textarea cols="5" rows="3" style="width: 650px;height: 60px;" name="remark" id="lifeRemark" ></textarea>
	     </td>
	    </tr>
	  </table> 
	  </form>
	</fieldSet>
	
    <div id="south-panel" align="center">
    	<a id="onsubmit" >提交</a>
    	<a id="onClose"  >取消</a>
    </div>
</body>
</html>