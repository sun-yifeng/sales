<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser,com.hf.framework.util.UUIDGenerator"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<style type="text/css">
html,body{height:100%;margin:0;padding:0}
.om-grid .gird-edit-btn{width:190px}
.om-button{font-size:12px}
#nav_cont{width:580px;margin-left:auto;margin-right:auto}
input{height:18px;border:1px solid #a1b9df;vertical-align:middle}
input:focus{border:1px solid #3a76c2}
.input_slelct{width:81%}
table.grid_layout tr td{font-weight:normal;height:15px;padding:5px 0;vertical-align:middle}
.color_red{color:red}
.toolbar{padding:12px 0 5px;text-align:center}
.birthplace,.address{width:445px}
.om-span-field input:focus{border:0}
.errorImg{background:url("<%=_path%>/images/msg.png") no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error,textarea.error{border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px}
.tds{padding-left:30px}
.tdsDate{width:115px}
.fontClass{font-size:12px;font-family:微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun}
.navi-no-tab{border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<title>合作机构协议新增</title>
<%
String channelCode = request.getParameter("channelCode");
String mediumCname = request.getParameter("mediumCname");
String deptCode = request.getParameter("deptCode");
String deptName = request.getParameter("deptName");
String expireDate = request.getParameter("expireDate");
String maxExpireDate = request.getParameter("maxExpireDate");
String channelCategory = request.getParameter("channelCategory");
%>
<script type="text/javascript">
var uploadId = "<%=UUIDGenerator.getUUID()%>";
var operateEmp = "<%=CurrentUser.getUser().getUserCode()%>";
//
var channelCode = '<%=channelCode%>';
var mediumCname = '<%=mediumCname%>';
var deptCode = '<%=deptCode%>';
var deptName = '<%=deptName%>';
var expireDate = '<%=expireDate%>';
var maxExpireDate = '<%=maxExpireDate%>';
var channelCategory = '<%=channelCategory%>';
//
var prodTypeObj = ''; //产品分类
var pordNameObj = ''; //所有产品
var tempProdType = '';
var tempProdCode = '';
var tempRowIndex = -1;
var saveFlag = true;
var repeatFlag = false;
$(function(){
	//
	$("#baseInfo").find("input").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#conferId").css({"width":"120px"});
	$("#extendConferCode").css({"width":"24px"});
	
	/*******基本信息**********/
	$('#channelCode').val(channelCode);
	$('#mediumCname').val(mediumCname);
	$('#deptCode').val(deptCode);
	$('#deptCname').val(deptName);
	
	//授权下级机构
	$('#grantDept').omCombo({
		dataSource:<%=Constant.getCombo("isYesOrNo")%>,
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false
    });
	
	//协议类型
	$('#conferType').omCombo({
		dataSource:"<%=_path%>/common/queryConferType.do",
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false
    });
	
	 //协议约定结算方式
	$('#paymentTax').omCombo({
		dataSource:[{text:'按不含税保费结算',value:'1'},{text:'按含税保费结算',value:'2'}],
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        onValueChange:function(target,newValue,oldValue,event){ 
        	var num = $("#tables tr").size();
        	if(newValue==1){
	        	for (var i = 0; i < num; i++) {
	        		var productCode = $("#tables tr:eq("+i+") td[abbr=productCode] div").html();
	        		$.ajax({ url: "<%=_path%>/conferProduct/queryRateByProduct.do",
		 					type:"post",
		 					async: false,
		 					data:{productCode:productCode},
		 					dataType: "json",
		 					success: function(data){
		 						if(data.freeTax == 1){
		 							$("#tables tr:eq("+i+") td[abbr=commissionRate] div").html(Number($("#tables tr:eq("+i+") td[abbr=commRate] div").html()).toFixed(4));
		 						}else{
		 							if(data.rateLimit != undefined){
		 								var commRate = $("#tables tr:eq("+i+") td[abbr=commRate] div").html();
		 								if(commRate > data.rateLimit*100){
		 									$("#tables tr:eq("+i+") td[abbr=commissionRate] div").html(Number(data.rateLimit*100).toFixed(4));
		 								}else{
		 									$("#tables tr:eq("+i+") td[abbr=commissionRate] div").html(Number($("#tables tr:eq("+i+") td[abbr=commRate] div").html()).toFixed(4));
		 								}
		 							}else{
		 								$("#tables tr:eq("+i+") td[abbr=commissionRate] div").html(Number($("#tables tr:eq("+i+") td[abbr=commRate] div").html()).toFixed(4));
		 							}
		 						}
		 					}
		 			   });
				}
        	}else if(newValue==2){
        		for (var i = 0; i < num; i++) {
        			var productCode = $("#tables tr:eq("+i+") td[abbr=productCode] div").html();
        			$.ajax({ url: "<%=_path%>/conferProduct/queryRateByProduct.do",
	 					type:"post",
	 					async: false,
	 					data:{productCode:productCode},
	 					dataType: "json",
	 					success: function(data){
	 						if(data.freeTax == 1){
	 							$("#tables tr:eq("+i+") td[abbr=commissionRate] div").html(Number($("#tables tr:eq("+i+") td[abbr=commRate] div").html()).toFixed(4));
	 						}else{
	 							if(data.rateLimit != undefined){
	 								var commRate = $("#tables tr:eq("+i+") td[abbr=commRate] div").html();
	 								if(commRate*1.06 > data.rateLimit*100){
	 									$("#tables tr:eq("+i+") td[abbr=commissionRate] div").html(Number(data.rateLimit*100).toFixed(4));
	 								}else{
	 									$("#tables tr:eq("+i+") td[abbr=commissionRate] div").html(Number(($("#tables tr:eq("+i+") td[abbr=commRate] div").html())*1.06).toFixed(4));
	 								}
	 							}else{
	 								$("#tables tr:eq("+i+") td[abbr=commissionRate] div").html(Number(($("#tables tr:eq("+i+") td[abbr=commRate] div").html())*1.06).toFixed(4));
	 							}
	 						}
	 					}
	 			   });
        			
				}
        	}
        }
    });

	//通过渠道大类自动选择协议类型
	if(channelCategory == '19002') {
		$('#conferType').omCombo({
			value:'B',
			readOnly:true
		});
	} else if(channelCategory == '19003') {
		$('#conferType').omCombo({
			value:'Q',
			readOnly:true
		});
	}
	
	//加载日期控件
    $('#validDate').omCalendar();
    $('#expireDate').omCalendar();
    $('#signDate').omCalendar();

	//复制协议产品对话框
    $("#copyDialog").omDialog({
         buttons:[
             {text:"确定", 
		      click:function () {
                 var tmpURL = '<%=_path%>/conferProduct/queryConferProdCopy?'+$("#copyForm").serialize()+'&endpoint=99999';
			     $("#tables").omGrid('setData', tmpURL);
		    	 $("#copyDialog").omDialog('close');
		       }
		     }, 
		     {text:"取消", 
		       click:function () {$("#copyDialog").omDialog('close');}
		     }],
	     autoOpen:false,
	     modal: true
	 });
    
	//按钮菜单
	$('#buttonbar').omButtonbar({
       btns:[{label:"新增",
     		     id:"addButton" ,
     		     icons:{left:'<%=_path%>/images/add.png'},
     	 		 onClick:function(){
		     	 			var p_tax = $("#paymentTax").val();
		   	 			 if(p_tax==""){
		   	 				$.omMessageBox.alert({
		   	 		 	        content:'请先选择保费结算方式',
		   	 		 	        onClose:function(value){
		   	 		 	        	return false;
		   	 		 	        }
			 		 	        });
		   	 			 }else{
		       	 			$('#tables').omGrid("insertRow");
		   	 			 }
    	 			 }
    			},
    			{separtor:true},
    	        {label:"删除",
    	        	id:"delButton",
    	        	icons:{left:'<%=_path%>/images/remove.png'},
    	        	onClick:function(){
    	        		var dels = $('#tables').omGrid('getSelections');
   	            	if(dels.length != 1 ){
   	            		$.omMessageBox.alert({
     	 		 	        content:'请选择一条记录操作',
     	 		 	        onClose:function(value){
     	 		 	        	return false;
     	 		 	        }
 	 		 	        });
   	            	}else{
       	            	$.omMessageBox.confirm({
	                       title:'确认删除',
	                       content:'你确定要删除该记录吗？',
	                       onClose:function(v){
	                           if(v){
	                        	   $('#tables').omGrid('deleteRow',dels[0]);
	                           }
	                       }
    	                });
   	            	}
    	        	}
    	        },
    			{separtor:true},
    			{label:"复制",
    		     id:"copyButton" ,
    		     icons:{left:'<%=_path%>/images/add.png'},
    	 		 onClick:function(){$("#copyDialog").omDialog('open');}
   			}
       	]
    });
	
	/**********************************************************产品手续费*****************************************************************/
	//加载所有的产品类别
	Util.post("<%=_path%>/common/queryTPrdKind.do","",function(data) {	
		 prodTypeObj = eval(data);
	});
	
	//加载所有的产品手续费
	Util.post("<%=_path%>/common/queryPrdCode.do","",function(data) {	
		  pordNameObj = eval(data);
	});
	
	//产品分类下拉框
	var productTypeOptions = {
			dataSource:"<%=_path%>/common/queryTPrdKind.do",
			editable:false,
			onValueChange:function(target1, newValue1, oldValue1, event1) {
				tempProdType = newValue1;
				$("#productName").omCombo("setData",[]);
				$("input[name='productCode']").val("");
				//按产品分类加载产品
				$("#productName").omCombo({
					dataSource:"<%=_path%>/common/queryPrdCode.do?prdType="+newValue1,
					editable:false,
					onValueChange:function(target2, newValue2, oldValue2, event2) {
						tempProdCode = newValue2;
						$("input[name='productCode']").val(newValue2);
					},
	    			onSuccess:function(data, textStatus, event){}
				});
			},
			onSuccess:function(data, textStatus, event){}
	};

	//手续费比例校验
	var commRateOptions = {
			allowDecimals:true,
        	allowNegative:false
	};
	
	//特殊批改校验
	var endorseRateOptions = {
			allowDecimals:true,
        	allowNegative:false
	};
	
	//初始化产品手续费信息列表
	$('#tables').omGrid({
         limit:10,
         height:350,
 		 singleSelect:false,
         showIndex:true,
         colModel:[{header:"产品分类",name:"productType",width:150,align:'center',editor:{rules:["required",true,"此项必选"],type:"omCombo",name:"productType",options:productTypeOptions},renderer:productTypeRenderer},
                   {header:"产品名称",name:"productName",width:260,align:'center',editor:{type:"omCombo",name:"productName"},renderer:productNameRenderer},
                   {header:"产品代码",name:"productCode",width:80,align:'center'},
                   {header:"协议约定结算比例（%）",name:"commRate",width:150,align:'center',editor:{rules:[["required",true,"手续费比例必填"],["max",100,"数值无效"],["min",0,"数值无效"]],type:"omNumberField",options:commRateOptions,editable:true,name:"commRate"}},
                   {header:"按不含税保费结算比例（%）",name:"commissionRate",width:160,align :'center',renderer:function(v,r,i){
	            		   var pay_tax = $("#paymentTax").val();
	            		   var productCode = $("input[name=productCode]").val();
	            		   if(productCode != undefined){
	            			   if(pay_tax==1){
	   	               			$.ajax({ url: "<%=_path%>/conferProduct/queryRateByProduct.do",
	   	       	 					type:"post",
	   	       	 					async: false,
	   	       	 					data:{productCode:productCode},
	   	       	 					dataType: "json",
	   	       	 					success: function(data){
	   	       	 						if(data.freeTax == 1){
	   	       	 						    v = Number($("input[name=commRate]").val()).toFixed(4);
	   	       	 						}else{
	   	       	 							if(data.rateLimit != undefined){
	   	       	 								var commRate = $("input[name=commRate]").val();
	   	       	 								if(commRate > data.rateLimit*100){
		   	       	 								$.omMessageBox.alert({
		   	            	        					type:'error',
		   	                    	 		 	        content:'交强险协议手续费不能超过4%'
		   	                	 		 	        });
	   	       	 								    v = Number(data.rateLimit*100).toFixed(4); 
	   	       	 								}else{
	   	       	 								    v = Number($("input[name=commRate]").val()).toFixed(4);
	   	       	 								}
	   	       	 							}else{
	   	       	 							        v = Number($("input[name=commRate]").val()).toFixed(4);
	   	       	 							}
	   	       	 						}
	   	       	 					}
	   	       	 			   });
	               		   }else if(pay_tax==2){
	               			   
	   	               			$.ajax({ url: "<%=_path%>/conferProduct/queryRateByProduct.do",
	   	       	 					type:"post",
	   	       	 					async: false,
	   	       	 					data:{productCode:productCode},
	   	       	 					dataType: "json",
	   	       	 					success: function(data){
	   	       	 						if(data.freeTax == 1){
	   	       	 						    v = Number($("input[name=commRate]").val()).toFixed(4);
	   	       	 						}else{
	   	       	 							if(data.rateLimit != undefined){
	   	       	 								var commRate = $("input[name=commRate]").val();
	   	       	 								if(commRate*1.06 > data.rateLimit*100){
		   	       	 								$.omMessageBox.alert({
		   	            	        					type:'error',
		   	                    	 		 	        content:'交强险协议手续费不能超过4%'
		   	                	 		 	        });
		   	       	 							    v = Number(data.rateLimit*100).toFixed(4);
	   	       	 								}else{
	   	       	 								    v = Number(Number($("input[name=commRate]").val())*1.06).toFixed(4);
	   	       	 								}
	   	       	 							}else{
	   	       	 						            v = Number(Number($("input[name=commRate]").val())*1.06).toFixed(4);
	   	       	 							}
	   	       	 						}
	   	       	 					}
	   	       	 			   });
	               		   }
	            		   }
            		    return (Number(v).toFixed(4)).toString();
            		}}
                   ,{header:"特殊批改（%）",name:"endorseRate",width:100,align:'center',editor:{rules:[["required",true,"特殊批改必填"],["max",100,"数值无效"],["min",0,"数值无效"]],type:"omNumberField",options:endorseRateOptions,editable:true,name:"endorseRate"}}],
         dataSource:"<%=_path%>/conferProduct/queryConferProduct.do?"+$("#conferProductFrm").serialize(),
         onBeforeEdit:function(rowIndex, rowData){
      	     $("#productName").omCombo("setData",[]); 
			 $("input[name='productCode']").val("");
			 saveFlag = false;
      	     repeatFlag = false;
      	     tempRowIndex = rowIndex;
    	 },
         onAfterEdit:function(rowIndex, rowData){
       		 //产品代码不能为空
	         if(rowData.productCode == '' || rowData.productCode == 'undefined'){
	        	 $.omMessageBox.alert({
	        		 type:'warning',
 		 	         content:'产品代码不能为空,请选择产品名称带出产品代码！'
 		 	    });
	         	saveFlag = false;
	         	$('#tables').omGrid("editRow", rowIndex);
	         } else {
	        	saveFlag = true;
	        	//1.页面是否有重复的产品
 		        var jsonData = JSON.stringify($('#tables').omGrid('getData'));
				var jsonRows = eval("["+jsonData+"]")[0].rows;
				if (jsonRows.length > 0){
				   for(var i=0; i<jsonRows.length; i++){
				        var breakFlag = false;
					    var tempProdCode1 = jsonRows[i].productCode;
						for(var j=jsonRows.length-1; j>i; j--){
							var tempProdCode2 = jsonRows[j].productCode;
							if(tempProdCode1 == tempProdCode2){
								$.omMessageBox.alert({
									type:'warning',
						 	        content:'产品编码重复,请重新选择产品',
						 	        onClose:function(value){}
					 	        });
								$("#tables").omGrid("editRow", i);
								saveFlag = false;
								breakFlag = true;
								repeatFlag = true;
								break;
							}
						}
						if(breakFlag){
                             return;
					    }
					}
				}
				//2.后台是否有重复的产品
	  	 		Util.post("<%=_path%>/conferProduct/queryMediumConferProductCode.do?conferProductId="+rowData.conferProductId+"&productCode="+rowData.productCode+"&conferCode="+conferCode,'',function(data) {
					 if(data != "success"){
							$.omMessageBox.alert({
		 						type:'warning',
		 			 	        content:'产品编码重复,请重新选择产品',
		 			 	        onClose:function(value){}
			      		 	});
							$("#tables").omGrid("editRow", rowIndex);
							saveFlag = false;
							repeatFlag = true;
						    return;
						}
					    saveFlag = true;
				 	  }
			    );			  
		     } //end if else
   		  },
   	      onCancelEdit:function(){
     	    if(repeatFlag){
   	      	   $('#tables').omGrid("deleteRow", tempRowIndex);
       	    }
   		    saveFlag = true;
   		  }
    });

	//显示产品分类
	function productTypeRenderer(value, rowData, rowIndex){
		if(value == ''){
           value = tempProdType;
		}
		if(prodTypeObj != ''){
			for(var i=0; i<prodTypeObj.length; i++){
		        if(prodTypeObj[i].value === value){
		            return "<span>"+prodTypeObj[i].text+"</span>";
		        } 
			}
		}
    }

	//显示产品名称
	function productNameRenderer(value, rowData, rowIndex){
		if(value == ''){
           value = tempProdCode;
        }
		if(pordNameObj != ''){
			for(var i=0; i < pordNameObj.length; i++){
		        if(pordNameObj[i].value === value){
		            return "<span>"+pordNameObj[i].text+"</span>";
		        }  
			}
		}
    }

	/***********附件*************/
	initFilePage();
	
	//初始化页面保存、重置、取消按钮
	$("#button-save").omButton({icons:{left:'<%=_path%>/images/add.png'},width:50});
	$("#button-reset").omButton({icons:{left:'<%=_path%>/images/clear.png'},width:50});
	$("#button-cancel").omButton({icons:{left:'<%=_path%>/images/remove.png'},width:50});
	
	initValidate();
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });

    //生效日期校验
    $.validator.addMethod("gtMaxExpireDate", function(value) {
        return value > maxExpireDate;
 	}, '此日期应大于最近一份协议的截止日期'+maxExpireDate);

    //生效日期校验
    $.validator.addMethod("gtSignDate", function(value) {
    	var validDate = $("#signDate").val();
        return value > validDate;
 	}, '此日期应大于签订日期');

    //截止日期校验
    $.validator.addMethod("gtValidDate", function(value) {
    	var validDate = $("#validDate").val();
        return value > validDate;
 	}, '此日期应大于生效日期');

 	//截止日期校验
 	$.validator.addMethod("gtExpireDate", function(value) {
        return value <= expireDate;
 	}, '此日期应小于渠道许可证书截止日期'+expireDate);
 	
 	var sysUrl = "http://ecmp.sinosafe.com.cn:8080/Interface_Cluster/FileUpLoadAction?SystemCode=XSZC01&FunctionCode=XSZC0101&OrgCode=01010000&UserCode=100052692&BatchFlg=0&AuthorizCode=1111&BusinessCode="+uploadId;
 	$('#imgSys').attr("href",sysUrl);
});

function formatDate(obj){
	var value = $(obj).val();
	if(value != "" && value != "undefined"){
		var dateSplit = value.split('-');
		if(dateSplit[1].length == 1){
			dateSplit[1] = "0" + dateSplit[1];
		}
		if(dateSplit[2].length == 1){
			dateSplit[2] = "0" + dateSplit[2];
		}
		$(obj).val(dateSplit[0]+"-"+dateSplit[1]+"-"+dateSplit[2]);
	}
}

function initFilePage(){
	$("#program-upload-download").haImg({
		title:'合作机构协议证书',
		modelCode:'XSZC010102',
		mainBillNo:"",
		seriesNo:uploadId,
		srcUrl:'${sessionScope.imgUrl}',
		operateEmp:operateEmp
	});
}

//定义校验规则
var mediumConferRule = {
	signDate:{
		required:true,
		isDate:true
	},
	validDate:{
		required:true,
		gtSignDate:true,
		gtMaxExpireDate:true,
		isDate:true
	},
	expireDate:{
		required:true,
		gtValidDate:true,
		gtExpireDate:true,
		isDate:true
	},
	calclatePeriod:{
		required:true,
		number:true
	},
	grantDept:{
		required:true
	},
	conferType:{
		required:true
	},
	paymentTax:{
		required:true
	}
};

//定义校验的显示信息
var mediumConferMessages = {
	signDate:{
		required:'签订日期不能为空'
	},
	validDate:{
		required:'生效日期不能为空'
	},
	expireDate:{
		required:'截止日期不能为空'
	},
	calclatePeriod:{
		required:'截费周期不能为空',
		number:'必须是数字类型'
	},
	grantDept:{
		required:'授权下级机构必选'
	},
	conferType:{
		required:'协议类型必选'
	},
	paymentTax:{
		required:'是否按照含税保费计算必选'
	}
};

//校验
function initValidate(){
	$("#baseInfo").validate({
		rules:mediumConferRule,
		messages:mediumConferMessages,
		errorPlacement:function(error, element) {
	        if (error.html()) {
		        $(element).parents().map(function() {
			        if (this.tagName.toLowerCase() == 'td') {
				        var attentionElement = $(this).next().children().eq(0);
				        attentionElement.css('display', 'block');
				        attentionElement.next().html(error);
			        }
		        });
	        }
        },
        showErrors:function(errorMap, errorList) {
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
        submitHandler:function() {
        	var jsonData = JSON.stringify($('#tables').omGrid('getData'));
        	var jsonRows = eval("["+jsonData+"]")[0].rows;
        	var baseJsonStr;
        	if(jsonRows.length > 0){
        		baseJsonStr = "[";
        		for(var i = 0;i < jsonRows.length;i++){
        			var productCode = jsonRows[i].productCode;
        			var commRate = jsonRows[i].commRate;
        			var endorseRate = jsonRows[i].endorseRate;
        			var commissionRate = $("#tables tr:eq("+i+") td[abbr=commissionRate] div").html();
        			//新增产品手续费
        			baseJsonStr += "{\"productCode\":\""+productCode+"\",\"commRate\":\""+commRate+"\",\"endorseRate\":\""+endorseRate+"\",\"commissionRate\":\""+commissionRate+"\"},";
        		}
        		var index = baseJsonStr.lastIndexOf(",");
        		baseJsonStr = baseJsonStr.substring(0, index);
        		baseJsonStr += "]";
        	}else{
        		baseJsonStr = "[]";
        	}
        	$('#conferJsonStr').val(baseJsonStr);

        	//附件
        	$('#uploadId').val(uploadId);
        	
        	$.omMessageBox.waiting({
                title:'请等待',
                content:'服务器正在处理请求...'
            });
        	
        	Util.post("<%=_path%>/mediumConfer/saveMediumConfer.do?",$("#baseInfo").serialize(), function(data) {
        			$.omMessageBox.waiting('close');
       				$.omMessageBox.alert({
       					type:'success',
                        title:'成功',
   	 		 	        content:'合作机构协议保存成功',
   	 		 	        onClose:function(value){
		        			//保存成功后跳转回协议列表页面
		        			window.location.href = "mediumEdit.jsp?flag=1&channelCode="+channelCode;
   	 		 	        	return true;
   	 		 	        }
 		 	        });
            });
        }
    });
}

//保存合作机构协议
function save(){
	//产品手续费表处于编辑状态
	if(!saveFlag){
		$.omMessageBox.alert({
      		 type:'warning',
	 	     content:'产品手续费信息处于编辑状态，请先确定或取消之后再保存！'
	 	});
	 	return;
    }
	
	$("#baseInfo").submit();
}

//取消操作
function cancel(){
	window.location.href = "mediumEdit.jsp?flag=1&channelCode="+channelCode;
}

//重置
function reset(){
	window.location.href = "mediumConferAdd.jsp?channelCode="+channelCode+"&mediumCname="+mediumCname+"&deptCode="+deptCode+"&deptName="+deptName;
}

</script>
</head>
<body>
	<div>
		<table class="navi-no-tab">
			<tr><td>合作机构协议新增</td></tr>
		</table>
	</div>
	<!-- 协议基本信息 -->
	<div>
		<form id="baseInfo">
		    <input type="hidden" name="deptCode" id="deptCode" />
			<fieldSet>
				<legend>基本信息</legend>
					<table>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">协议号：</span></td>
							<td><input type="text" name="conferId" id="conferId" readonly="readonly" />-<input type="text" name="extendConferCode" id="extendConferCode" readonly="readonly" value="0" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">机构部门：</span></td>
							<td><input type="text" name="deptCname" id="deptCname" readonly="readonly" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span>
							<td style="padding-left:30px" align="right"><span class="label">代理机构编码：</span></td>
							<td><input type="text" name="channelCode" id="channelCode" readonly="readonly" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">代理机构名称：</span></td>
							<td><input type="text" name="mediumCname" id="mediumCname" readonly="readonly" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">签订日期：</span></td>
							<td><input class="sele" type="text" name="signDate" id="signDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">生效日期：</span></td>
							<td><input class="sele" type="text" name="validDate" id="validDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">截止日期：</span></td>
							<td><input class="sele" type="text" name="expireDate" id="expireDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">结费周期：</span></td>
							<td><input type="text" name="calclatePeriod" id="calclatePeriod" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">授权下级机构：</span></td>
							<td><input class="sele" type="text" name="grantDept" id="grantDept" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">协议类型：</span></td>
							<td><input class="sele" type="text" name="conferType" id="conferType" readonly="readonly" /><span style="color:red">*</span>
							<!--所有新增维护人信息封装json字符串 -->
							<input type="hidden" name="conferJsonStr" id="conferJsonStr" />
							<!--附件id字符串 --> 
							<input type="hidden" name="uploadId" id="uploadId" />
							<input type="hidden" name="noTax" id="noTax" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">协议约定结算方式：</span></td>
							<td><input class="sele" type="text" name="paymentTax" id="paymentTax" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
					</table>
			</fieldSet>
			<fieldSet>
				<legend>详细内容</legend>
				<textarea rows="5" cols="110" style="margin-left:70px;" name="remark" id="remark"></textarea>
			</fieldSet>
		</form>
	</div>
	<!-- 产品手续费 -->
	<div>
		<fieldSet>
			<legend>产品手续费</legend>
			<div id="buttonbar"></div>
			<!-- 复制协议对话框 -->
			<div id="copyDialog" title="请输入需复制协议号">
				<form id="copyForm">
					<input type="text" name="conferId" id="conferIdCopy" value=""/>-<input type="text" name="extendConferCode" style="width:18px;" id="extendConferCodeCopy" value="0" />
				</form>
			</div>
			<table id="tables"></table>
			<form id="conferProductFrm">
				<input type="hidden" name="formMap['conferNo']" value="" />
			</form>
		</fieldSet>
	</div>
	<!-- 附件上传框 -->
	<!-- <div class="fontClass" id="program-upload-download" style="height:240px;"></div> -->
	<div>
		<fieldSet>
			<legend>影像资料</legend>
			<div style="margin-left: 20px;margin-bottom: 10px;">
			  <a href='#' id="imgSys" target="_blank">合作机构协议证件</a>
			</div>
		</fieldSet>
	</div>
  <!-- 新影像系统end -->
	<div>
		<table style="width:100%">
			<tr>
				<td style="padding-left:30px;padding-top:20px" align="center">
					<a class="om-button" id="button-save" onclick="save()">保存</a>
					<a class="om-button" id="button-reset" onclick="reset()">清空</a>
					<a class="om-button" id="button-cancel" onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
</body>
</html>