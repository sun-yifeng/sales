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
.textarea_text{border:1px solid #a1b9df;height:40px;width:445px}
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
/*导航标题*/
.navi-tab{border: solid #d0d0d0 1px; width: 100%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px;}
.navi-no-tab{border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<title>个人代理人协议编辑</title>
<%
String channelCode = request.getParameter("channelCode");
String conferCode = request.getParameter("conferCode");
String expireDate = request.getParameter("expireDate");
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var conferCode = '<%=conferCode%>';
//执业证号有效期止
var expireDate = '<%=expireDate%>'; 

var uploadId = "<%=UUIDGenerator.getUUID()%>";
var operateEmp = "<%=CurrentUser.getUser().getUserCode()%>";

var currentUploadId;
//
var prodTypeObj = ''; //产品分类
var pordNameObj = ''; //所有产品
var tempProdType = '';
var tempProdCode = '';
var tempRowIndex = -1;
var saveFlag = true;
var repeatFlag = false;
var editFlag = false;
$(function(){
	$("#baseInfo").find("input").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#conferId").css({"width":"120px"});
	$("#extendConferCode").css({"width":"24px"});
	
	//协议主键，按协议主键加载相关产品
	$('#conferNoFK').val(conferCode);
	
	//是否理财险渠道
	$('#financeChannel').omCombo({
        dataSource:<%=Constant.getCombo("isYesOrNo")%>,
        emptyText:'请选择',
        editable:false
    });
	
	//渠道特征
	$('#feature').omCombo({
		dataSource:"<%=_path%>/common/queryChannelFeature.do",
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
  
    //加载日期控件
    $('#expireDate').omCalendar();
  	/*
  	 * 功能：协议的签订日期、生效日期只有系统管理员可以修改（机构不能修改）
  	 * 作者：sunyf
  	 * 日期：2014-05-15
  	 */
    $.ajax({ 
  		url:"<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=xszcAdmin,headDeptSalesmanAgentNew",
  		type:"post",
  		async:true, 
  		dataType:"JSON",
  		success:function(data){
  		  if (data) {
  		     $('#validDate').omCalendar().css({"background":"#FFFFFF"});
  		     $('#signDate').omCalendar().css({"background":"#FFFFFF"});
  		  } else {
  		     $('#validDate').omCalendar({editable:false,disabled:true});
  		     $('#signDate').omCalendar({editable:false,disabled:true});
      	  }
  		}
  	});

    /*******协议基本信息**********/
    Util.post("<%=_path%>/mediumConfer/queryAgentConfers.do",$("#conferProductFrm").serialize(),function(data) {
		$("#baseInfo").find(":input").each(function(){
			$(this).val(data[0][$(this).attr("name")]);
		});
		$('#expireDate').omCalendar({
               date:new Date(2010, 7, 15)
        });
		//是否理财险渠道
		$('#financeChannel').omCombo({value:data[0].financeChannel});
		//渠道特征
		$('#feature').omCombo({value:data[0].feature});
		$('#paymentTax').omCombo({value : data[0].paymentTax});
    });
	
	//按钮菜单
	$('#buttonbar').omButtonbar({
           	btns:[{label:"新增",
            		     id:"addButton",
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
	            	 			editFlag = false; 
	            	 			$('#tables').omGrid("insertRow");
            	 			 }
           	 			 }
           			},
           			{separtor:true},
           	        {label:"删除",
           	        	id:"delButton",
           	        	icons:{left:'<%=_path%>/images/remove.png'},
           	        	onClick:function(){
           	        		var dels = $('#tables').omGrid('getSelections',true);
           	        		var delsf = $('#tables').omGrid('getSelections');
           	        		var del = eval(dels);
           	        		var delf = eval(delsf);
           	        		editFlag = false; 
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
          	                        	    if(del[0].conferProductId != "" && del[0].conferProductId != "undefined" && del[0].conferProductId != undefined){
	           	                        		Util.post("<%=_path%>/conferProduct/deleteMediumConferProduct.do?conferProductId="+del[0].conferProductId,'',function(data) {
	           	                        			//刷新列表
					       	 		 				$('#tables').omGrid({});
	 					       	 		 		}
	 					       	 		 		);
          	                        	    }else{
          	                        	    	$('#tables').omGrid('deleteRow',delf[0]);
          	                        	    }
          	                           }
          	                       }
            	                 });
          	            	}
           	        	}
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
		$("#tables").omGrid("setData","<%=_path%>/conferProduct/queryConferProduct.do?"+$("#conferProductFrm").serialize());
	});

	//产品分类下拉框
	var productTypeOptions = {
			dataSource:"<%=_path%>/common/queryTPrdKind.do",
			onValueChange:function(target1, newValue1, oldValue1, event1) {
				tempProdType = newValue1;
				$("#productName").omCombo("setData",[]);
				$("input[name='productCode']").val("");
				$("#productName").omCombo({
					dataSource:"<%=_path%>/common/queryPrdCode.do?prdType="+newValue1,
					listAutoWidth : true,
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
         limit:0,
         height:345,
 		 singleSelect:false,
         showIndex:true,
         colModel:[{header:"产品分类",name:"productType",width:150,align:'center',editor:{type:"omCombo", name:"productType",options:productTypeOptions},editable:function(){return true;},renderer:productTypeRenderer},
                   {header:"产品名称",name:"productName",width:260,align:'center',editor:{type:"omCombo",name:"productName"},editable:function(){return true;},renderer:productNameRenderer},
                   {header:"产品编码",name:"productCode",width:80,align:'center'},
                   {header:"协议约定结算比例（%）",name:"commRate",width:150,align:'center',editor:{rules:[["required",true,"手续费比例必填"],["max",100,"数值无效"],["min",0,"数值无效"]],type:"omNumberField",options:commRateOptions,editable:true,name:"commRate"}},
                   {header:"按不含税保费结算比例（%）",name:"commissionRate",width:160,align :'center'},
                   {header:"特殊批改（%）",name:"endorseRate",width:100,align:'center',editor:{rules:[["required",true,"特殊批改必填"],["max",100,"数值无效"],["min",0,"数值无效"]],type:"omNumberField",options:endorseRateOptions,editable:true,name:"endorseRate"}}],
     	 onPageChange:function(type, newPage, event){
      		var jsonData = JSON.stringify($('#tables').omGrid('getData'));
      		var jsonRows = eval("["+jsonData+"]")[0].rows;
      		editFlag = false; 
      		if(jsonRows.length > 0){
      			for(var i=0; i<jsonRows.length; i++){
      				var breakFlag = false;
      				var productCode = jsonRows[i].productCode;
      				var commRate = jsonRows[i].commRate;
      				var endorseRate = jsonRows[i].endorseRate;
      				if(productCode == '' || productCode == undefined){
      					$.omMessageBox.alert({
  							type:'warning',
  				 	        content:'产品代码不能为空,请选择产品名称带出产品代码！',
  				 	        onClose:function(value){}
      			 	    });
      					$("#tables").omGrid("editRow", i);
						saveFlag = false;
						break;
      				} else {
      					for(var j = jsonRows.length-1;j > i;j--){
      						var prepareCode = jsonRows[j].productCode;
      						if(productCode == prepareCode){
      							$.omMessageBox.alert({
      								type:'warning',
      					 	        content:'产品编码不能重复',
      					 	        onClose:function(value){}
      				 	        });
      							$("#tables").omGrid("editRow", i);
      							saveFlag = false;
      							breakFlag = true;
      							repeatFlag = true;
      						}
      					}
      				}
      				if(commRate == undefined){
      					$.omMessageBox.alert({
      						type:'warning',
      			 	        content:'协议约定结算比例不能为空',
      			 	        onClose:function(value){}
      		 	        });
      					$("#tables").omGrid("editRow", i);
      					return false;
      				}
      				if(endorseRate == undefined){
      					$.omMessageBox.alert({
      						type:'warning',
      			 	        content:'产品特殊批改不能为空',
      			 	        onClose:function(value){}
      		 	        });
      					$("#tables").omGrid("editRow", i);
      					return false;
      				}
					if(breakFlag){
	                   break;
	  				}
      			}
      		 }
      		  
	         var insertData = $('#tables').omGrid("getChanges","insert");
	       	 var updateData = $('#tables').omGrid("getChanges","update");
	       	 //var deleteData = $('#tables').omGrid("getChanges","delete");
	       	 if(insertData.length>0 || updateData.length>0){
	       		var jsonData = JSON.stringify($('#tables').omGrid('getData'));
	           	var jsonRows = eval("["+jsonData+"]")[0].rows;
	           	var baseJsonStr;
	           	if(jsonRows.length > 0){
	           		baseJsonStr = "[";
	           		for(var i = 0;i < jsonRows.length;i++){
	           			var conferProductId = jsonRows[i].conferProductId;
	           			var productCode = jsonRows[i].productCode;
	           			var commRate = jsonRows[i].commRate;
	           			var endorseRate = jsonRows[i].endorseRate;
	           			var commissionRate = $("#tables tr:eq("+i+") td[abbr=commissionRate] div").html();
	           			if(conferProductId != undefined){//修改产品手续费
	           				baseJsonStr += "{\"conferProductId\":\""+conferProductId+"\",\"productCode\":\""+productCode+"\",\"commRate\":\""+commRate+"\",\"endorseRate\":\""+endorseRate+"\",\"commissionRate\":\""+commissionRate+"\"},";
	           			}else{//新增产品手续费
	           				baseJsonStr += "{\"productCode\":\""+productCode+"\",\"commRate\":\""+commRate+"\",\"endorseRate\":\""+endorseRate+"\",\"commissionRate\":\""+commissionRate+"\"},";
	           			}
	           		}
	           		var index = baseJsonStr.lastIndexOf(",");
	           		baseJsonStr = baseJsonStr.substring(0, index);
	           		baseJsonStr += "]";
	           	}else{
	           		baseJsonStr = "[]";
	           	}
	           	$('#conferJsonStr').val(baseJsonStr);
	
	           	//附件
	           	$('#uploadId').val(currentUploadId);
	
	           	$.omMessageBox.waiting({
	                title:'请等待',
	                content:'服务器正在处理请求...'
	            });
	           	
	           	Util.post("<%=_path%>/mediumConfer/updateMediumConfer.do",$("#baseInfo").serialize(), function(data) {
	           	    $.omMessageBox.waiting('close');
	            });
       	 	}
         }, //end onPageChange
		 onBeforeEdit:function(rowIndex, rowData){
		   saveFlag = false;
		   repeatFlag = false;
		   editFlag = true;
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
		      	editFlag = false;
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
				
      	 		var p_name = $("#tables tr:eq("+rowIndex+") td[abbr=productName] div").html();
      	    	 if(p_name == "undefined"){
      	    		 $.ajax({ url: "<%=_path%>/conferProduct/queryProductName.do",
      	 					type:"post",
      	 					async: false,
      	 					data:{productCode:rowData.productCode},
      	 					dataType: "json",
      	 					success: function(data){
      	 						$("#tables tr:eq("+rowIndex+") td[abbr=productName] div").html(rowData.productCode+" "+data.productName);
      	 					}
      	 			   });
      	    	 }
				
      	 		var pay_tax = $("#paymentTax").val();
	      	 	var productCode = $("input[name=productCode]").val();
	   			$.ajax({ url: "<%=_path%>/conferProduct/queryRateByProduct.do",
						type:"post",
						async: false,
						data:{productCode:productCode},
						dataType: "json",
						success: function(data){
							if(data.freeTax == 1){
								$("#tables tr:eq("+rowIndex+") td[abbr=commissionRate] div").html(Number($("#tables tr:eq("+rowIndex+") td[abbr=commRate] div").html()).toFixed(4));
							}else{
								if(pay_tax==1){
									if(data.rateLimit != undefined){
										var commRate = $("#tables tr:eq("+rowIndex+") td[abbr=commRate] div").html();
										if(commRate > data.rateLimit*100){
											$.omMessageBox.alert({
   	            	        					type:'error',
   	                    	 		 	        content:'交强险协议手续费不能超过4%'
   	                	 		 	        });
											$("#tables tr:eq("+rowIndex+") td[abbr=commissionRate] div").html(Number(data.rateLimit*100).toFixed(4)); 
										}else{
											$("#tables tr:eq("+rowIndex+") td[abbr=commissionRate] div").html(Number($("#tables tr:eq("+rowIndex+") td[abbr=commRate] div").html()).toFixed(4));
										}
									}else{
										    $("#tables tr:eq("+rowIndex+") td[abbr=commissionRate] div").html(Number($("#tables tr:eq("+rowIndex+") td[abbr=commRate] div").html()).toFixed(4));
									}
					    		   }else if(pay_tax==2){
					    			   if(data.rateLimit != undefined){
											var commRate = $("#tables tr:eq("+rowIndex+") td[abbr=commRate] div").html();
											if(commRate*1.06 > data.rateLimit*100){
												$.omMessageBox.alert({
	   	            	        					type:'error',
	   	                    	 		 	        content:'交强险协议手续费不能超过4%'
	   	                	 		 	        });
												$("#tables tr:eq("+rowIndex+") td[abbr=commissionRate] div").html(Number(data.rateLimit*100).toFixed(4));
											}else{
												$("#tables tr:eq("+rowIndex+") td[abbr=commissionRate] div").html(Number($("#tables tr:eq("+rowIndex+") td[abbr=commRate] div").html()*1.06).toFixed(4));
											}
										}else{
											  $("#tables tr:eq("+rowIndex+") td[abbr=commissionRate] div").html(Number($("#tables tr:eq("+rowIndex+") td[abbr=commRate] div").html()*1.06).toFixed(4));
										}
					    		   }
								
							}
						}
				   });
		     } //end if else
		 },
         onCancelEdit:function(){
      	   if(repeatFlag){
  	      	  $('#tables').omGrid("deleteRow", tempRowIndex);
      	   }
      	   saveFlag = true;
      	   editFlag = false;
		},
		/* onRefresh:function(nowPage,pageRecords,event){
			channgeRate();
	     } */
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
		if(value == '' || editFlag == true){
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

	//加载个人代理人协议附件信息
	Util.post("<%=_path%>/upload/queryUploadByMainId.do?mainId="+conferCode+"&module=04","",function(data) {
			if(data == '' || data == null){
			  var sysUrl = "http://ecmp.sinosafe.com.cn:8080/Interface_Cluster/FileUpLoadAction?SystemCode=XSZC01&FunctionCode=XSZC0101&OrgCode=01010000&UserCode=100052692&BatchFlg=0&AuthorizCode=1111&BusinessCode=" + uploadId;
			  $('#imgSys').attr("href",sysUrl);
		  }else{
				  var sysUrl = "http://ecmp.sinosafe.com.cn:8080/Interface_Cluster/FileUpLoadAction?SystemCode=XSZC01&FunctionCode=XSZC0101&OrgCode=01010000&UserCode=100052692&BatchFlg=0&AuthorizCode=1111&BusinessCode=" + data[0].uploadId;
				  $('#imgSys').attr("href",sysUrl);
		  }
	    }
	);
	
	//初始化页面保存、重置、取消按钮
	$("#button-save").omButton({icons:{left:'<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons:{left:'<%=_path%>/images/remove.png'},width:50});
	
	initValidate();
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function(){
	    $(this).next().css('display', 'none');
    });

    $.validator.addMethod("gtSignDate", function(value) {
    	var validDate = $("#signDate").val();
        return value >= validDate;
 	}, '此日期应大于等于签订日期');
    
    $.validator.addMethod("gtValidDate", function(value) {
    	var validDate = $("#validDate").val();
        return value > validDate;
 	}, '此日期应大于生效日期');

 	$.validator.addMethod("gtExpireDate", function(value) {
        return value <= expireDate;
 	}, '此日期应小于执业证号的截止日期');
});

function formatDate(obj){
	var value = $(obj).val();
	if(value != "" && value != "undefined" && value != undefined){
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

/**
 * 文件上传下载通用方法（异步获取数据）
 */
function getImg (domId,data){
	if(data != '' && data != undefined && data != "undefined"){
		currentUploadId = data.uploadId;
		$(domId).haImg({
			title:data.name,
			modelCode:'XSZC010104',
			mainBillNo:data.mainId,
			seriesNo:data.uploadId,
			srcUrl:'${sessionScope.imgUrl}',
			operateEmp:data.updatedUser
	    });
	}else{
		currentUploadId = uploadId;
		$(domId).haImg({
			title:'个人代理人协议证书',
			modelCode:'XSZC010104',
			mainBillNo:"",
			seriesNo:uploadId,
			srcUrl:'${sessionScope.imgUrl}',
			operateEmp:operateEmp
		});
	}
}

//定义校验规则
var mediumConferRule = {
	conferCode:{
		required:true,
		isLetterAndInteger:true,
		maxlength:50
	},
	signDate:{
		required:true,
		isDate:true
	},
	validDate:{
		required:true,
		gtSignDate:true,
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
	/* financeChannel:{
		required:true
	}, */
	rate:{
		//required:true,
		number:true
	},
	feature:{
		required:true
	},
	paymentTax:{
		required:true
	}
};

//定义校验的显示信息
var mediumConferMessages = {
	conferCode:{
		required:'协议号不能为空',
		isLetterAndInteger:'协议号必须是数字和字母',
		maxlength:'协议号最长50位'
	},
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
	/* financeChannel:{
		required:'是否理财渠道必选'
	}, */
	rate:{
		//required:'渠道系数不能为空',
		number:'必须是数字类型'
	},
	feature:{
		required:'渠道特征必选'
	},
	paymentTax:{
		required:'是否按照含税保费计算必选'
	}
};

//校验
function initValidate(){
	$("#baseInfo").validate({
		rules: mediumConferRule,
		messages: mediumConferMessages,
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
        	var insertData = $('#tables').omGrid("getChanges","insert");
        	var updateData = $('#tables').omGrid("getChanges","update");
        	var deleteData = $('#tables').omGrid("getChanges","delete");
        	if(insertData.length>0 || updateData.length>0 || deleteData.length>0){
        		$('#updateFlag').val(1);
        	}else{
        		$('#updateFlag').val(0);
        	}
        	
        	var jsonData = JSON.stringify($('#tables').omGrid('getData'));
        	var jsonRows = eval("["+jsonData+"]")[0].rows;
        	var baseJsonStr;
        	if(jsonRows.length > 0){
        		baseJsonStr = "[";
        		for(var i = 0;i < jsonRows.length;i++){
        			var conferProductId = jsonRows[i].conferProductId;
        			var productCode = jsonRows[i].productCode;
        			var commRate = jsonRows[i].commRate;
        			var endorseRate = jsonRows[i].endorseRate;
        			var commissionRate = $("#tables tr:eq("+i+") td[abbr=commissionRate] div").html();
        			if(conferProductId != undefined){//修改产品手续费
        				baseJsonStr += "{\"conferProductId\":\""+conferProductId+"\",\"productCode\":\""+productCode+"\",\"commRate\":\""+commRate+"\",\"endorseRate\":\""+endorseRate+"\",\"commissionRate\":\""+commissionRate+"\"},";
        			}else{//新增产品手续费
        				baseJsonStr += "{\"productCode\":\""+productCode+"\",\"commRate\":\""+commRate+"\",\"endorseRate\":\""+endorseRate+"\",\"commissionRate\":\""+commissionRate+"\"},";
        			}
        		}
        		var index = baseJsonStr.lastIndexOf(",");
        		baseJsonStr = baseJsonStr.substring(0, index);
        		baseJsonStr += "]";
        	}else{
        		baseJsonStr = "[]";
        	}
        	$('#conferJsonStr').val(baseJsonStr);

        	//附件
        	$('#uploadId').val(currentUploadId);

        	$.omMessageBox.waiting({
                title:'请等待',
                content:'服务器正在处理请求...'
            });

        	//保存
        	Util.post("<%=_path%>/mediumConfer/updateMediumConfer.do",$("#baseInfo").serialize(), function(data) {
       			 $.omMessageBox.waiting('close');
      				$.omMessageBox.alert({
      					type:'success',
                       title:'成功',
  	 		 	        content:'个人代理人协议保存成功',
  	 		 	        onClose:function(value){
	        			//保存成功后跳转回个人代理人协议列表页面
	        			window.location.href = "agentEdit.jsp?flag=1&channelCode="+channelCode;
  	 		 	        	return true;
  	 		 	        }
		 	        });
            });
        }
    });
}

function channgeRate(){
	var num = $("#tables tr").size();
	var conferId = $("#conferId").val();
    	for (var i = 0; i < num; i++) {
    		var productCode = $("#tables tr:eq("+i+") td[abbr=productCode] div").html();
    		$.ajax({ url: "<%=_path%>/conferProduct/queryProductByConferId.do",
					type:"post",
					async: false,
					data:{productCode:productCode,conferId:conferId},
					dataType: "json",
					success: function(data){
							$("#tables tr:eq("+i+") td[abbr=commissionRate] div").html(Number(data).toFixed(4));
					}
			   });
		}
}

//保存个人代理人协议操作
function save(){
	var jsonData = JSON.stringify($('#tables').omGrid('getData'));
	var jsonRows = eval("["+jsonData+"]")[0].rows;
	if(jsonRows.length > 0){
		for(var i = 0;i < jsonRows.length;i++){
			var productCode = jsonRows[i].productCode;
			var commRate = jsonRows[i].commRate;
			var endorseRate = jsonRows[i].endorseRate;
			if(productCode == '' || productCode == 'undefined' || productCode == undefined){
				$.omMessageBox.alert({
						type:'warning',
			 	        content:'产品编码不能为空',
			 	        onClose:function(value){
			 	        	return false;
			 	        }
		 	        });
				$("#tables").omGrid("editRow", i);
				return false;
			}else{
				for(var j = jsonRows.length-1;j > i;j--){
					var prepareCode = jsonRows[j].productCode;
					if(productCode == prepareCode){
						$.omMessageBox.alert({
							type:'warning',
				 	        content:'产品编码不能重复',
				 	        onClose:function(value){
				 	        	return false;
				 	        }
			 	        });
						$("#tables").omGrid("editRow", i);
						return false;
					}
				}
			}
			if(commRate == undefined){
				$.omMessageBox.alert({
					type:'warning',
		 	        content:'产品表-手续费比例不能为空',
		 	        onClose:function(value){
		 	        	return false;
		 	        }
	 	        });
				$("#tables").omGrid("editRow", i);
				return false;
			}
			if(endorseRate == undefined){
				$.omMessageBox.alert({
					type:'warning',
		 	        content:'产品表-特殊批改不能为空',
		 	        onClose:function(value){
		 	        	return false;
		 	        }
	 	        });
				$("#tables").omGrid("editRow", i);
				return false;
			}
		}
	}
	
	$("#baseInfo").submit();
}

//取消操作
function cancel(){
	window.location.href = "agentEdit.jsp?flag=1&channelCode="+channelCode;
}
</script>
</head>
<body>
	<div>
		<table class="navi-no-tab">
			<tr><td>个人代理人协议维护</td></tr>
		</table>
	</div>
	<div>
		<form id="baseInfo">
			<fieldSet>
				<legend>基本信息</legend>
					<table>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">协议号：</span></td>
							<td><input type="text" name="conferId" id="conferId" readonly="readonly" />-<input type="text" name="extendConferCode" id="extendConferCode" readonly="readonly" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span><input type="hidden" name="conferCode" id="conferCode" /></td>
							<!-- <td style="padding-left:30px" align="right"><span class="label">机构编码：</span></td>
							<td><input type="text" name="deptCode" id="deptCode" readonly="readonly" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td> -->
							<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
							<td><input type="text" name="deptCname" id="deptCname" readonly="readonly" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span>
							<input type="hidden" name="deptCode" id="deptCode" /></td>
							<td style="padding-left:30px" align="right"><span class="label">个人代理人编码：</span></td>
							<td><input type="text" name="channelCode" id="channelCode" readonly="readonly" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">姓名：</span></td>
							<td><input type="text" name="channelName" id="channelName" readonly="readonly" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">签订日期：</span></td>
							<td><input class="sele" type="text" name="signDate" id="signDate" readonly="readonly" onblur="formatDate(this);" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">生效日期：</span></td>
							<td><input class="sele" type="text" name="validDate" id="validDate" readonly="readonly" onblur="formatDate(this);" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">截止日期：</span></td>
							<td><input class="sele" type="text" name="expireDate" id="expireDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">结费周期：</span></td>
							<td><input type="text" name="calclatePeriod" id="calclatePeriod" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">是否理财渠道：</span></td>
							<td><input class="sele" type="text" name="financeChannel" id="financeChannel" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">渠道系数：</span></td>
							<td><input type="text" name="rate" id="rate" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">渠道特征：</span></td>
							<td><input class="sele" type="text" name="feature" id="feature" /><span style="color:red">*</span>
							<!--所有产品信息封装json字符串 -->
							<input type="hidden" name="conferJsonStr" id="conferJsonStr" />
							<!--明细是否修改过标记（1表示修改过，0表示没有修改） -->
							<input type="hidden" name="updateFlag" id="updateFlag" />
							<!--附件id字符串 --> 
							<input type="hidden" name="uploadId" id="uploadId" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">协议约定结算方式：</span></td>
							<td><input class="sele" type="text" name="paymentTax" id="paymentTax" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
					</table>
			</fieldSet>
			<fieldSet>
				<legend>详细内容</legend>
				<textarea rows="5" cols="110" class="fontClass" style="margin-left:70px;" name="remark" id="remark"></textarea>
			</fieldSet>
		</form>
	</div>
	<div>
		<fieldSet>
			<legend>产品手续费</legend>
			<div id="buttonbar" style="border-style:none none solid none;"></div>
			<table id="tables"></table>
			<form id="conferProductFrm">
				<input type="hidden" name="formMap['conferCode']" id="conferNoFK" value="" />
			</form>
		</fieldSet>
	</div>
	<!-- 附件上传框 -->
	<!-- <div id="program-upload-download" style="height:240px;"></div> -->
	<!-- 新影像系统bgn -->
      <div>
        <fieldSet>
          <legend>影像资料</legend>
          <div style="margin-left: 20px;margin-bottom: 10px;">
            <a href='#' id="imgSys" target="_blank">个人代理人协议证件</a>
          </div>
        </fieldSet>
      </div>
      <!-- 新影像系统end -->
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-left:30px;padding-top:20px" align="center">
				<a class="om-button" id="button-save" onclick="save()">保存</a>
				<a class="om-button" id="button-cancel" onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
</body>
</html>