<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser,com.hf.framework.util.UUIDGenerator"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<style type="text/css">
/*浏览器兼容*/
*{padding:0;margin:0}
/*页面边距*/
html,body{height:100%;margin:0;padding:0}
/*机构菜单*/
.deptDropListTree{height:250px;width:151px;border:1px solid #9aa3b9;overflow:auto;display:none;position:absolute;background:#FFF;z-index:4;}
.om-grid{border:none;}
/*提示信息*/
.msg-info{/*list-style-type:none;*/margin:0 30px 0 0;padding-left:20px;background:#FCEFE3;min-width:200px;}
/*导航标题*/
.navi-tab{border: solid #d0d0d0 1px; width: 100%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px;}
.navi-no-tab{border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
/*校验提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer;margin-left:-2px;}
input.error,textarea.error{border:1px solid red;}
.errorMsg{border:1px solid gray;background-color:#FCEFE3;display:none;position:absolute;margin-top:-18px;margin-left:-2px;}
/*校验星号*/
span.asterisk{color:red;position:relative;top:4px;}
/*提示按钮*/
.msg-btn{cursor:pointer;font-size:14px;font-weight:bold;margin-right:4px;color:red}
</style>
<title>合作机构新增</title>
<% boolean trueOrFalse = Boolean.parseBoolean(request.getParameter("trueOrFalse")); %>
<script type="text/javascript">
var uploadId = "<%=UUIDGenerator.getUUID()%>";
var operateEmp = "<%=CurrentUser.getUser().getUserCode()%>";
var trueOrFalse = <%=trueOrFalse%>;
var userDptCde = '';
var returnFlag = '1';
//
$(function(){
	$("#baseInfo").find("input[name^='formMap']").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#deptCname").css({"background-color":"#fff"});
	$("#processDeptCode").css({"background-color":"#fff"});
	$("#parentChannelCode").css({"background-color":"#fff"});
	$("#processUserCode").css({"background-color":"#fff"});
	$("#taxRate").width("150");
	
    //浙江IC卡刷卡失败提示
    $("#dialog-error").omDialog({
        autoOpen:false, 
        resizable: false,
        width: 500,
        modal:true,
        buttons: [
                  {text:"重新读卡", 
		           click:function(){
		        	   processIC();
		           }},
		          {text:"取消读卡", 
		           click:function(){
		        	   $("#dialog-error").omDialog("close");
		           }}
       			]
    });
	
	//浙江IC卡特殊处理
	Util.post("<%=_path%>/department/getDeptCodeByUser.do",'',
 			function(data) {
				userDptCde = data;
				if(userDptCde.substring(0,2) == '09'){
					//processIC();//浙江IC卡读取及处理,机构已经废除此功能
				}
 			}
 		);
	
	
	/*******基本信息**********/
	//是否协作人
	$('#supportFlag').omCombo({
        dataSource:<%=Constant.getCombo("isYesOrNo")%>,
        editable:false,
        emptyText:'请选择',
        lazyLoad:true,
        onValueChange:function(target,newValue,oldValue,event){
            if(newValue == 1){
            	$('#agentCode').rules('add',{
            		required:true,
           	      	messages: {
           	      		required:jQuery.format("代理人不能为空")
           	      	}
            	});
            }else{
            	$("#agentCode").rules("remove", "required"); //remove可以配置多个rule，空格隔开
            }
        	$("#agentCode").focus();
        }
    });
	
	//合作层级
	$('#parterLevel').omCombo({
        dataSource:<%=Constant.getCombo("isParterLevel")%>,
        emptyText:'请选择',
        editable:false
    });
	
	//是否理财险渠道
	$('#financeFlag').omCombo({
        dataSource:<%=Constant.getCombo("isYesOrNo")%>,
        emptyText:'请选择',
        editable:false,
        lazyLoad:true,
        onValueChange:function(target,newValue,oldValue,event){
            if(newValue == 1){
            	$('#financePolicyFlag').rules('add',{
            		required:true,
           	      	messages: {
           	      		required:jQuery.format("理财险保单标识必选")
           	      	}
            	});
            }else{
            	$("#financePolicyFlag").rules("remove", "required"); //remove可以配置多个rule，空格隔开
            	$("#financePolicyFlagImg").hide();
            }
        }
    });
	/**
	 * 四级（渠道大类/渠道类型/渠道性质/渠道属类）联动
	 * 当“渠道大类”选择“代理”时，“渠道类型”为必选项； 当在“渠道类型”选择“兼业代理”时，“渠道性质”为必选项； 当在“渠道性质”选择“银行代理”、“邮政代理”、“车行代理”、“非银行代理”时，“渠道属类”为必选项。
	 */
	$('#channelCategory').omCombo({
		dataSource:"<%=_path%>/common/queryCategory.do",
		onValueChange:function(target, newValue, oldValue, event) {
          $('#channelType').omCombo("setData",[]);
        	$('#channelProperty').omCombo("setData",[]);
        	$('#channelOwnType').omCombo("setData",[]);
            if(newValue != ''){
	        	//渠道类型
            	$('#channelType').omCombo({
	               dataSource:"<%=_path%>/common/queryProperty.do?parentCode="+newValue,
	               emptyText:'请选择'
	            });
	        	//渠道大类选择代理业务时，渠道类型比选
                if(newValue == '19002'){
                	$('#channelType').rules("add","required");
                	$('#channelTypeStart').show();
                }else{
                	$('#channelType').rules("remove","required");                	
                	$('#channelTypeStart').hide();                	
                }
            }
        },optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        lazyLoad:true
    });
	//渠道类型
	$('#channelType').omCombo({
		onValueChange:function(target, newValue, oldValue, event) {
        	$('#channelProperty').omCombo("setData",[]);
        	$('#channelOwnType').omCombo("setData",[]);
            if(newValue != ''){
              //渠道性质
              $('#channelProperty').omCombo({
	             dataSource:"<%=_path%>/common/queryPropertyMV.do?parentCode="+newValue,
	             emptyText:'请选择'
	          });
  	          //渠道类型选择兼业代理时,渠道性质必选
              if(newValue == '1900202'){
              	$('#channelProperty').rules("add","required");
              	$('#channelPropertyStart').show();
              }else{
              	$('#channelProperty').rules("remove","required");                	
              	$('#channelPropertyStart').hide();                	
              }
            }
        },optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false
    });
	//渠道性质
	$('#channelProperty').omCombo({
		onValueChange:function(target, newValue, oldValue, event) {
        	$('#channelOwnType').omCombo("setData",[]);
            if(newValue != ''){
              //渠道属类
              $('#channelOwnType').omCombo({
	             dataSource:"<%=_path%>/common/queryPropertyMV.do?parentCode="+newValue,
	             emptyText:'请选择'
	          });
  	          //当在“渠道性质”选择“银行代理”、“邮政代理”、“车行代理”、“非银行代理”时，“渠道属类”为必选项。
              if(newValue == '190020201' || newValue == '190020202' || newValue == '190020203' || newValue == '190020206'){
              	$('#channelOwnType').rules("add","required");
              	$('#channelOwnTypeStart').show();
              }else{
              	$('#channelOwnType').rules("remove","required");                	
              	$('#channelOwnTypeStart').hide();                	
              }
            }
        },optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false
    });
	//渠道属类
	$('#channelOwnType').omCombo({
		optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false
    });
	//渠道特征
	$('#channelFeature').omCombo({
		dataSource:"<%=_path%>/common/queryChannelFeature.do",
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        lazyLoad:true
    });
	
	//开户行所在省
	$('#bankProvince').omCombo({
        dataSource:"<%=_path%>/common/queryProvince.do",
        onValueChange:function(target, newValue, oldValue, event) {
        	//清空市的所有选项
            $('#bankCity').omCombo("setData",[]);
            //清空银行网点中的所有选项
        	$('#bankNode').omCombo("setData",[]);
            if(newValue != ''){
            	$('#bankCity').omCombo({
	                 dataSource:"<%=_path%>/common/queryCity.do?province="+newValue,
	                 emptyText:'请选择'
	                 /* onSuccess:function(data, textStatus, event){
	                	 alert(data[0].value);
	                	 $('#bankCity').omCombo({value:data[0].value});
	                 } */
	            });
            }
        },optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
		filterStrategy:'anywhere',
        lazyLoad:true
    });
	
	//开户行所在市
	$('#bankCity').omCombo({
		optionField:function(data, index) {
	        return data.text;
		},
		filterStrategy:'anywhere',
		onValueChange:function(target, newValue, oldValue, event) {
            if(newValue != ''){
            	//清空银行网点中的所有选项
            	$('#bankNode').omCombo("setData",[]);
            	
            	var bankReceiveVal = $('#bankReceive').val();
            	if(bankReceiveVal != ''){
	            	$('#bankNode').omCombo({
		                 dataSource:"<%=_path%>/common/queryBankNode.do?city="+newValue+"&bank="+bankReceiveVal,
		                 emptyText:'请选择',
		                 editable:false,
		                 listAutoWidth:true
		            });
            	}
            }else{
            	$('#bankNode').omCombo("setData",[]);
            }
        }
	});
	
	//收款方银行
	$('#bankReceive').omCombo({
		dataSource:"<%=_path%>/common/queryBank.do",
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
		onValueChange:function(target, newValue, oldValue, event) {
            if(newValue != ''){
            	//清空开户行网点中的所有选项
            	$('#bankNode').omCombo("setData",[]);
            	var bankCityVal = $('#bankCity').val();
            	if(bankCityVal != ''){
                	//开户行网点
	            	$('#bankNode').omCombo({
		                 dataSource:"<%=_path%>/common/queryBankNode.do?bank="+newValue+"&city="+bankCityVal+"&random="+Math.random(),
		                 emptyText:'请选择',
		                 editable:false,
		                 listAutoWidth:true
		            });
            	}
            }else{
            	$('#bankNode').omCombo("setData",[]);
            }
        },
        lazyLoad:true
    });
	
	//开户行网点
	$("#bankNode").omCombo({
		optionField:function(data, index) {
	        return data.text;
		},
		emptyText:'请选择',
	    editable:false,
		filterStrategy:'anywhere'
	});
	
	//业务线
	$('#businessLine').omCombo({
		dataSource:"<%=_path%>/medium/getMediumEditBusinessline.do",
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        lazyLoad:true
    });
	
	//国家地区
	$('#country').omCombo({
		dataSource:"<%=_path%>/common/queryCountry.do",
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
		filterStrategy:'anywhere',
        lazyLoad:true
    });
	
	//渠道层级
	$('#channelLevel').omCombo({
        dataSource:"<%=_path%>/common/queryChannelLevel.do",
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        lazyLoad:true
    });
	
	//所属行业
	$('#profession').omCombo({
		dataSource:"<%=_path%>/common/queryProfession.do",
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        lazyLoad:true
    });
	
	//是否有不良记录
	$('#mistakeFlag').omCombo({
        dataSource:<%=Constant.getCombo("isYesOrNo")%>,
        emptyText:'请选择',
        editable:false,
        lazyLoad:true,
        onValueChange:function(target,newValue,oldValue,event){
            if(newValue == 1){
            	$('#mistakeContent').rules('add',{
            		required:true,
           	      	messages: {
           	      		required:jQuery.format("不良记录不能为空")
           	      	}
            	});
            }else{
            	$("#mistakeContent").rules("remove", "required"); //remove可以配置多个rule，空格隔开
            }
        	$("#mistakeContent").focus();
        }
    });
	
	//纳税人资质
	$('#taxpayerQualify').omCombo({
        dataSource:[{"value":"0","text":"一般纳税人"},{"value":"1","text":"小规模纳税人"}],
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        lazyLoad:true,
        onValueChange:function(target,newValue,oldValue,event){ 
        	   $('#invoiceType').omCombo('enable');
        	   $('#invoiceType').omCombo('value','请选择');
        	   $("#taxRate").val("");
        	if(newValue==0){
        		$('#invoiceType').omCombo('value','专票'); 
        		$('#invoiceType').omCombo('disable');
        		$("#taxRate").val("6%");
        	}
        }
    });
	//开具发票类型
	$('#invoiceType').omCombo({
        dataSource:[{"value":"0","text":"普票"},{"value":"1","text":"专票"}],
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        lazyLoad:true,
        onValueChange:function(target,newValue,oldValue,event){ 
        	if($('#taxpayerQualify').val()==1){
        		if(newValue==0){
        			$("#taxRate").val("0%");
        		}else if(newValue==1){
        			$("#taxRate").val("3%");
        		}
        	}
        }
    });
	
	//下级单位可以查看
	$('#childDeptLook').omCombo({
        dataSource:<%=Constant.getCombo("isYesOrNo")%>,
        emptyText:'请选择',
        editable:false,
        lazyLoad:true
    });

	//理财险保单标示
	$('#financePolicyFlag').omCombo({
		dataSource:"<%=_path%>/common/queryFinancePolicyFlag.do",
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        lazyLoad:true
    });
	
	//加载日期控件
    $('#validDate').omCalendar();
    $('#expireDate').omCalendar();
    $('#signDate').omCalendar();

	//初始化联系列表按钮菜单
	$('#buttonbar').omButtonbar({
           	btns:[{label:"新增",
            		     id:"addButton" ,
            		     icons:{left:'<%=_path%>/images/add.png'},
            	 		 onClick:function(){
            	 			$('#tables').omGrid("insertRow",0,{getFlag:0});
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
           	        }
           	]
    });
	
	//经办部门
    $("#deptDropListTree").omTree({
        dataSource:"<%=_path%>/department/queryDeptDropList.do",
	    simpleDataModel:true,
	    //
	    onBeforeExpand:function(node){
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
       onSelect:function(nodedata) {
         var ndata = nodedata, text = ndata.text, departCode = ndata.departCode;
         ndata = $("#deptDropListTree").omTree("getParent", ndata);
         while (ndata) {
	        //text = ndata.text + "-" + text;
	        ndata = $("#deptDropListTree").omTree("getParent", ndata);
         }
         $("#deptCname").val(departCode+'-'+text);
         $("#deptCode").val(departCode);
         $("#parentChannelCode").val('请选择');
         $("#deptCname").focus();
         //08江苏分公司,组织机构代码不能为空
         var deptCde = departCode.substr(0,2);
         if(deptCde == '08'){
         	$('#cAgentorgCde').rules('add',{
         		required:true,
       	      	messages: {
       	      		required:jQuery.format("组织机构代码不能为空")
       	      	}
         	});
         }else{
         	$("#cAgentorgCde").rules("remove", "required"); //remove可以配置多个rule，空格隔开
         }
         //$("#registerAddress").focus();
         //
         hideDropList();
       },
       onBeforeSelect:function(nodedata) {
         if (nodedata.children) {
	        return true;
         }
       },
       onSuccess: function(data){
  	     $('#deptDropListTree').omTree('expandAll');
  	   }
   });
   //绑定事件
   $("#choose").click(function() {
      showDropList();
   });
   //点击输入框
   $("#deptCname").click(function() {
      showDropList();
   });
   //失去焦点事件
   $("#mediumCname").blur(function(){
	   $("#taxpayerName").val($("#mediumCname").val());
   });
   var q_taxpayer = $("#taxpayerQualify").val();
   if(q_taxpayer==""){
	   $('#invoiceType').omCombo('disable');
   }
   
   //定位下拉框
   function showDropList() {
	  var cityInput = $("#deptCname");
   	  var cityOffset = cityInput.offset();
   	  var topnum = cityOffset.top+cityInput.outerHeight() - 11;
   	  var leftnum = cityOffset.left - 1;
   	  if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0"||$.browser.version == "8.0")){
	  	  topnum = topnum + 10;
      }
      $("#deptDropListTree").css({"margin-left": leftnum + "px","margin-top": topnum +"px"}).show();
      //body绑定mousedown事件
      $("body").bind("mousedown", onBodyDown);
   }
   //隐藏
   function hideDropList() {
      $("#deptDropListTree").hide();
      $("body").unbind("mousedown", onBodyDown);
   }
   //隐藏
   function onBodyDown(event) {
      if(!(event.target.id == "choose" || event.target.id == "deptDropList" || $(event.target).parents("#deptDropList").length > 0)) {
	       hideDropList();
        }
   }
	
  //选择经办人
  $("#user-dialog-model").omDialog({
     autoOpen:false,
     width:750,
     height:465,
     modal:true,
     resizable:false,
     onOpen:function(event) {
	    $("#personIframe").attr("src","<%=_path%>/view/demo/selectUserIframe.jsp?deptCode="+$("#deptCode").val());
	 }
  });

  //选择上级合作机构
  $("#medium-dialog-model").omDialog({
     autoOpen:false,
     width:750,
     height:465,
     modal:true,
     resizable:false,
     onOpen:function(event) {
    	$("#mediumIframe").attr("src","<%=_path%>/view/demo/selectParentMediumIframe.jsp");
     }
  });

  /********联系信息**********/
  //初始化联系信息列表
  var postOptions = {
		allowDecimals:false,
       	allowNegative:false
	};
  var getFlagOptions = {
 		dataSource:[{text:"请选择",value:""},{text:"是" , value:"1"},{text:"否",value:"0"}],
 		disabled: trueOrFalse
  	};
  var msgCarOptions = {
   		 dataSource:[{text:"请选择",value:""},{text:"是" , value:"1"},{text:"否",value:"0"}],
	 	 editable: true
     };
  var msgCustomerOptions = {
	    dataSource:[{text:"请选择",value:""},{text:"是" , value:"1"},{text:"否",value:"0"}],
	    editable: false
  	};
  var isSendTrueagtOptions = {
	    dataSource:[{text:"请选择",value:""},{text:"发送" , value:"Y"},{text:"发送并屏蔽代理人",value:"G"},{text:"不发送",value:"N"}],
	    listAutoWidth : true,
	    editable: false,
  	};
  var isSendCmpnycontactOptions = {
	    dataSource:[{text:"请选择",value:""},{text:"发送" , value:"Y"},{text:"不发送",value:"N"}],
	    editable: false
   	};
  var agtinfoSourceOptions = {
	    dataSource:[{text:"请选择",value:""},{text:"从协作人提取" , value:"1"},{text:"从代理人提取",value:"0"}],
	    editable: false
   	};
  //联系信息
  var tabHead = 0 || [ {header:"是否同步核心<br/>(只有一条可选'是')" , name:"getFlag",width:100, align:'center',editor:{type:"omCombo", name:"getFlag" ,options:getFlagOptions},renderer:getFlagRenderer},
                 {header:"联系人",name:"contact",width:80, align:'center',editor:{rules:["required",true,"联系人不能为空"],editable:true}},
               	 {header:"职务",name:"title",width:80, align:'center',editor:{editable:true}},
              	 {header:"手机",name:"mobile",width:85, align:'center',editor:{rules:["isMobilePhone"],editable:true}},
              	 {header:"电话号码",name:"tel",width:85, align:'center',editor:{rules:["isTelephone"],editable:true}},
              	 {header:"E-mail",name:"email",width:80, align:'center',editor:{rules:["isEmail"],editable:true}},
              	 {header:"传真",name:"fax",width:80, align:'center',editor:{editable:true}},
              	 {header:"地址", name:"addresss",width:80, align:'center',editor:{editable:true}},
               	 {header:"邮政编码", name:"post",width:80, align:'center',editor:{rules:["maxPostLength"],editable:true,type:"omNumberField",options:postOptions}},
               	 {header:"短信通<br/>知车行", name:"msgCar",width:50, align:'center',editor:{type:"omCombo", name:"msgCar" ,options:msgCarOptions},renderer:msgCarRenderer},
               	 {header:"发车行推荐<br/>短信给客户",name:"msgCustomer",width:80, align:'center',editor:{type:"omCombo", name:"msgCustomer" ,options:msgCustomerOptions},renderer:msgCustomerRenderer},
               	 {header:"我司联系<br/>人手机",name:"companyPhone",width:85, align:'center',editor:{rules:["isMobilePhone"],editable:true}},
               	 {header:"短信通知<br/>协作人", name:"isSendTrueagt",width:80, align:'center',editor:{type:"omCombo", name:"isSendTrueagt" ,options:isSendTrueagtOptions},renderer:isSendTrueagtRenderer},
             	 {header:"短信通知<br/>我司联系人",name:"isSendCmpnycontact",width:80, align:'center',editor:{type:"omCombo", name:"isSendCmpnycontact" ,options:isSendCmpnycontactOptions},renderer:isSendCmpnycontactRenderer},
             	 {header:"短信渠道<br/>信息来源",name:"agtinfoSource",width:80, align:'center',editor:{type:"omCombo", name:"agtinfoSource" ,options:agtinfoSourceOptions},renderer:agtinfoSourceRenderer},
             	 {header:"备注", name:"remark",width:50,editor:{editable:true}}
             	 ];	  
	/*
	 * 功能：总公司_渠道管理岗_市场开发，总公司_室主任、系统管理员角色   只有这三个角色可见“是否同步到核心”的开关并且操作
	 * 作者：sunyf
	 * 日期：2015-04-20
	 */ 
	var contactRole = 'headDeptChannel,headDeptDirector,xszcAdmin'; 
	$.ajax({url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName="+contactRole, type:"post", async:false, dataType:"JSON", success:function(data){
	    if(!data){tabHead.splice(0, 1);} 
	}});

	//联系信息
	$('#tables').omGrid({
         limit:0,
         height:200,
 		 singleSelect:true,
 		 showIndex:false,
         autoFit:false,
         colModel:tabHead,
	     dataSource:"<%=_path%>/mediumContect/queryMediumContect.do?"+$("#mediumContectFrm").serialize()
    });
	
	function getFlagRenderer(value){
		if("1" === value){
            return "<span>是</span>";
        }else if("0" === value){
            return "<span>否</span>";
        }else{
            return "";
        }
    }
	function msgCarRenderer(value){
        if("1" === value){
            return "<span>是</span>";
        }else if("0" === value){
            return "<span>否</span>";
        }else{
            return "";
        }
    }
	function msgCustomerRenderer(value){
        if("1" === value){
            return "<span>是</span>";
        }else if("0" === value){
            return "<span>否</span>";
        }else{
            return "";
        }
    }
	function isSendTrueagtRenderer(value){
        if("Y" === value){
            return "<span>发送</span>";
        }else if("G" === value){
            return "<span>发送并屏蔽代理人</span>";
        }else if("N" === value){
            return "<span>不发送</span>";
        }else{
            return "";
        }
    }
	function isSendCmpnycontactRenderer(value){
		if("Y" === value){
            return "<span>发送</span>";
        }else if("N" === value){
            return "<span>不发送</span>";
        }else{
            return "";
        }
    }
	function agtinfoSourceRenderer(value){
        if("1" === value){
            return "<span>从协作人提取</span>";
        }else if("0" === value){
            return "<span>从代理人提取</span>";
        }else{
            return "";
        }
    }
	
	/***********附件*************/
	//initFilePage();
	//初始化页面保存、重置、取消按钮
	$("#button-save").omButton({icons:{left:'<%=_path%>/images/add.png'},width:50});
	$("#button-reset").omButton({icons:{left:'<%=_path%>/images/clear.png'},width:50});
	$("#button-cancel").omButton({icons:{left:'<%=_path%>/images/remove.png'},width:50});
    //表单校验
	initValidate();
    //校验提示
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
    /* $.validator.addMethod("isPhone", function(value) {
    	var regu =/(((?:13\d|15[89])-?\d{5}(\d{3}|\*{3}))|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)/;
        var reg = new RegExp(regu);
        return reg.test(value);
    }, '不是有效的电话号码'); */
    $.validator.addMethod("isPhone", function(value) {
        var regu =/(^[1][358][0-9]{9}$)|(^((\d{3,4})-)?(\d{6,8})(-(\d{3,}))?$)/; 
        var reg = new RegExp(regu);
        return reg.test(value);  // 手机,固话验证
    }, '不是有效的联系电话');
    
    $.validator.addMethod("bankAccountCheck",function(value){
    	var reg = /^[0-9]+[\-]?[0-9]+$/;
    	return reg.test(value);
    },"银行帐号只允许包含数字或横线，例：10-1234");
    
    $.validator.addMethod("maxPostLength", function(value) {
    	if(value!='' && value !=undefined){
	        return /^\d{6}$/.test(value);
    	}else{
	        return /^\d{0}$/.test(value);
    	}
 	}, '邮编长度为6位数字');
    
    $.validator.addMethod("gtValidDate", function(value) {
    	var validDate = $("#validDate").val();
        return value > validDate;
 	}, '此日期应大于许可证颁发日期');
    
    $.validator.addMethod("deptCnameRequired", function(value) {
        return value != '请选择';
 	}, '经办部门必选');
    
 	$.validator.addMethod("processUserCodeRequired", function(value) {
        return value != '请选择';
 	}, '经办人必选');
 	
    $.validator.addMethod("parentChannelCodeRequired", function(value) {
        return value != '请选择';
 	}, '上级渠道必选');
    
    $.validator.addMethod("taxpayerIdNum",function(value){
    	var reg = /^[0-9a-zA-Z]{15,20}$/;
    	return reg.test(value);
    },"纳税人识别号只能由字母、数字组合");

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
		title:'合作机构证件',
		modelCode:'XSZC010101',
		mainBillNo:"",
		seriesNo:uploadId,
		srcUrl:'${sessionScope.imgUrl}',
		operateEmp:operateEmp
	});
}

//定义校验规则,此规则页面加载的时执行
var mediumConferRule = {
	supportFlagformMap:{
		required:true
	},
	childDeptLookformMap:{
		required:true
	},
	mediumCnameformMap:{
		required:true,
		maxlength:50
	},
	deptCnameformMap:{
		deptCnameRequired:true
	},
	licenceformMap:{
		required:true,
		maxlength:25
	},
	officeAddressformMap:{
		required:true,
		maxlength:100
	},
	processDeptCodeformMap:{
		required:true
	},
	processUserCodeformMap:{
		processUserCodeRequired:true
	},
	parterLevelformMap:{
		required:true
	},
	/* financeFlagformMap:{
		required:true
	}, */
	channelCategoryformMap:{
		required:true
	},
	/*channelTypeformMap:{
		required:true
	},*/
	channelFeatureformMap:{
		required:true
	},
	bankAccountformMap:{
		required:true,
		bankAccountCheck:true,
		maxlength:30
	},
	bankNameformMap:{
		required:true,
		maxlength:50
	},
	bankProvinceformMap:{
		required:true
	},
	bankCityformMap:{
		required:true
	},
	bankReceiveformMap:{
		required:true
	},
	bankNodeformMap:{
		required:true
	},
	businessLineformMap:{
		required:true
	},
	validDateformMap:{
		required:true,
		isDate:true
	},
	expireDateformMap:{
		required:true,
		gtValidDate:true,
		isDate:true
	},
	signDateformMap:{
		required:true,
		isDate:true
	},
	/* channelPropertyformMap:{
		required:true
	}, */
	contactformMap:{
		required:true,
		maxlength:25
	},
	telformMap:{
		required:true,
		isPhone:true
	},
	parentChannelCodeformMap:{
		parentChannelCodeRequired:true
	},
	parentMediumCodeformMap:{
		maxlength:50
	},
	mediumEnameformMap:{
		maxlength:200
	},
	salePolicyNameformMap:{
		maxlength:50
	},
	salePolicyAddressformMap:{
		maxlength:100
	},
	innerCodeformMap:{
		maxlength:50
	},
	channelOuterCodeformMap:{
		maxlength:50
	},
	channelExtendCodeformMap:{
		maxlength:50
	},
	channelRateformMap:{
		//required:true,
		number:true
	},
	legalformMap:{
		maxlength:25
	},
	registerAddressformMap:{
		maxlength:50
	},
	websiteformMap:{
		maxlength:100
	},
	areaCodeformMap:{
		maxlength:30
	},
	cityCodeformMap:{
		maxlength:30
	},
	mistakeFlagformMap:{
		required:true
	},
	taxpayerNameformMap:{
		required:true
	},
	taxpayerIdNumformMap:{
		required:true,
		minlength:15,
		maxlength:20,
		taxpayerIdNum:true
	},
	taxpayerQualifyformMap:{
		required:true
	},
	invoiceTypeformMap:{
		required:true
	},
	taxRateformMap:{
		required:true
	}
};

//定义校验的显示信息
var mediumConferMessages = {
	supportFlagformMap:{
		required:'是否协作人必选'
	},
	childDeptLookformMap:{
		required:'下级单位可以查看必选'
	},
	mediumCnameformMap:{
		required:'合作机构名称不能为空',
		maxlength:'合作机构名称最长50位'
	},
	deptCodeformMap:{
		required:'机构部门必选'
	},
	licenceformMap:{
		required:'经营许可证不能为空',
		maxlength:'经营许可证最长25位'
	},
	officeAddressformMap:{
		required:'办公地址不能为空',
		maxlength:'办公地址最长100位'
	},
	processDeptCodeformMap:{
		required:'经办部门编码必选'
	},
	/* processUserCodeformMap:{
		required:'经办人必选'
	}, */
	parterLevelformMap:{
		required:'合作层级必选'
	},
	/* financeFlagformMap:{
		required:'是否理财险渠道必选'
	}, */
	channelCategoryformMap:{
		required:'渠道大类必选'
	},
	channelFeatureformMap:{
		required:'渠道特征必选'
	},
	bankAccountformMap:{
		required:'银行帐号不能为空',
		maxlength:'银行帐号最长30位'
	},
	bankNameformMap:{
		required:'账户名称不能为空',
		maxlength:'账户名称最长50位'
	},
	bankProvinceformMap:{
		required:'开户行所在省必选'
	},
	bankCityformMap:{
		required:'开户行所在市必选'
	},
	bankReceiveformMap:{
		required:'收款方银行必选'
	},
	bankNodeformMap:{
		required:'开户行网点必选'
	},
	businessLineformMap:{
		required:'业务线必选'
	},
	validDateformMap:{
		required:'许可证颁发时间不能为空'
	},
	expireDateformMap:{
		required:'许可证有效时间至不能为空'
	},
	signDateformMap:{
		required:'与合作机构签约时间不能为空'
	},
	channelTypeformMap:{
	    required:'渠道大类选择"代理业务"时,渠道类型为必选项'
	},
	channelPropertyformMap:{
		required:'渠道类型选择"兼业代理"时,"渠道性质"为必选项'
	},
	channelOwnTypeformMap:{
		required:'渠道性质选择"银行代理","邮政代理”,"车行代理","非银行代理"时,"渠道属类"为必选项'
	},
	contactformMap:{
		required:'联系人不能为空',
		maxlength:'联系人最长25位'
	},
	telformMap:{
		required:'联系电话不能为空'
	},
	/* parentChannelCodeformMap:{
		required:'上级渠道必选'
	}, */
	parentMediumCodeformMap:{
		maxlength:"上级合作机构编码最长50位"
	},
	mediumEnameformMap:{
		maxlength:"合作机构英文名称最长200位"
	},
	salePolicyNameformMap:{
		maxlength:"出单点名称最长50位"
	},
	salePolicyAddressformMap:{
		maxlength:"出单点地址最长100位"
	},
	innerCodeformMap:{
		maxlength:"内部编码最长50位"
	},
	channelOuterCodeformMap:{
		maxlength:"渠道外编码最长50位"
	},
	channelExtendCodeformMap:{
		maxlength:"渠道编码最长50位"
	},
	channelRateformMap:{
		//required:'渠道系数不能为空',
		number:'渠道系数必须是数字'
	},
	legalformMap:{
		maxlength:"法人代表最长25位"
	},
	registerAddressformMap:{
		maxlength:"注册地址最长50位"
	},
	websiteformMap:{
		maxlength:"网站地址最长100位"
	},
	areaCodeformMap:{
		maxlength:"地区代码最长30位"
	},
	cityCodeformMap:{
		maxlength:"省市代码最长30位"
	},
	mistakeFlagformMap:{
		required:'是否有不良记录必选'
	},
	taxpayerNameformMap:{
		required:'纳税人名称不能为空'
	},
	taxpayerIdNumformMap:{
		required:'纳税人识别号不能为空',
		minlength:"纳税人识别号最短15位",
		maxlength:"纳税人识别号最长20位"
	},
	taxpayerQualifyformMap:{
		required:'纳税人资质为必选项'
	},
	invoiceTypeformMap:{
		required:'开具发票类型为必选项'
	},
	taxRateformMap:{
		required:'税率为必填项'
	}
};

//校验
function initValidate(){
	//将name属性修改进行验证
	$("#baseInfo").find("input[name^='formMap']").each(function(){
		$(this).attr("name",$(this).attr("id")+"formMap");
	});
	//
	var processDeptCode = $('#processDeptCode').val();
	if(processDeptCode == '请选择')
		$('#processDeptCode').val('');
	//
	$("#baseInfo").validate({
		rules: mediumConferRule,
		messages: mediumConferMessages,
		errorPlacement:function(error, element) {
	        if (error.html()) {
		        $(element).parents().map(function() {
			        if (this.tagName.toLowerCase() == 'td') {
				        var attentionElement = $(this).next().children().eq(0);
				        attentionElement.css({'display':'block'});
				        //attentionElement.css({'display':'block','position':'absolute','z-index':'3'}).parent().css('position','absolute');
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
        	//将name属性还原，提交保存
        	$("#baseInfo").find("input[name$='formMap']").each(function(){
        		$(this).attr("name","formMap['"+$(this).attr("id")+"']");
        	});
        	//经办部门编码处理
        	//var processDeptCode = $("#processDeptCode").val();
			//$("#processDeptCode").val(processDeptCode.split('-')[0]);
			//联系人信息
        	var jsonData = JSON.stringify($('#tables').omGrid('getData'));
        	$('#mediumContectJsonStr').val(jsonData);
        	//附件
        	$('#uploadId').val(uploadId);
        	//
        	$.omMessageBox.waiting({
                title:'请等待',
                content:'服务器正在处理请求...'
            });
        	var i_type = $("#invoiceType").val();
        	var i_t;
        	if(i_type == "专票"){
        		i_t = 2;
        	}
        	Util.post(
        		"<%=_path%>/medium/saveMedium.do?invoiceType="+i_t,$("#baseInfo").serialize(), function(data) {
        			$.omMessageBox.waiting('close');
        			if(data == "success"){
        				$.omMessageBox.alert({
        					type:'success',
        	                title:'成功',
    	 		 	        content:'合作机构保存成功',
    	 		 	        onClose:function(value){
			        			//保存成功后跳转回机构管理主页
			        			window.location.href = "medium.jsp";
    	 		 	        	return true;
    	 		 	        }
	 		 	        });
        			}
            });
        }
    });
}

//浙江IC卡读取及处理
function processIC(){
	try{
		var iccard = new ActiveXObject("icsAccessCtrl.icsAccess");
		ret = iccard.ReadAccess();
		if(0!=ret){
			$("#dialog-error").omDialog("open");
			returnFlag = '1';
			return;
		}
		$('#mediumCname').val(iccard.AgentName).attr('readonly','readonly');
		$('#licence').val(iccard.AgentLicNo).attr('readonly','readonly');
		returnFlag = '0';
		$("#dialog-error").omDialog("close");
	} catch(e){
		returnFlag = '1';
		$("#dialog-error").omDialog("open");
	}
}

//选择经办人
function selPerson(){
	var deptCode = $("#deptCode").val();
	if(deptCode == ''){
		$.omMessageBox.alert({
			type:'warning',
            title:'警告',
 	        content:'请先选择经办部门，再选择经办人！'
	    });
	}else{
		$("#user-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
	}
    //下面是缓加载iframe页面（提高性能）
    <%-- 
    var frameLoc;
    if(navigator.appName.indexOf("Microsoft Internet Explorer")!=-1 && document.all){//适应IE浏览器
    	frameLoc = window.frames[1].location;
    }else{//适应火狐浏览器
    	frameLoc = window.frames[0].location;
    }
    if (frameLoc.href == 'about:blank') {
       frameLoc.href = '<%=_path%>/view/demo/selectUserIframe.jsp';
    } 
    --%>
}

//选择上级渠道
function selParentMedium(){
	var deptCode = $("#deptCode").val();
	if(deptCode == ''){
		$.omMessageBox.alert({
			type:'warning',
            title:'警告',
 	        content:'请先选择经办部门，再选择上级渠道！'
	    });
	}else{
		$("#medium-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
	}
	//下面是缓加载iframe页面（提高性能）
    <%-- var frameLoc;
    if(navigator.appName.indexOf("Microsoft Internet Explorer")!=-1 && document.all){//适应IE浏览器
    	frameLoc = window.frames[2].location;
    }else{//适应火狐浏览器
    	frameLoc = window.frames[1].location;
    }
    if (frameLoc.href == 'about:blank') {
       frameLoc.href = '<%=_path%>/view/demo/selectParentMediumIframe.jsp';
    } --%>
}

//填充数据（选择经办人）
function fillBackAndCloseDialog(rowData) {
	  $("#processUserCode").val(rowData.salesmanCname); //郑仲铭(104036723)
	  $("#user-dialog-model").omDialog('close');
	  $("#processUserCode").focus();
}

//填充数据（选择上级机构）
function fillMediumBackAndCloseDialog(rowData) {
	  if(rowData.channelCode == '--'){
		  $("#parentChannelCode").val("无");
	  }else{
	  	  $("#parentChannelCode").val(rowData.channelCode+'-'+rowData.mediumCname);
	  }
	  //如果上级渠道的合作层级隶属于总对总，则合作层级为总对总，如果上级渠道的合作层级隶属于分对分，则合作层级为分对分
	  if(rowData.parterLevel == '隶属于总对总'){
		 rowData.parterLevel = '195001';
	  }else if(rowData.parterLevel == '隶属于分对分'||rowData.parterLevel == undefined||rowData.parterLevel == '--'){
		 rowData.parterLevel = '195002';
	  }else{
		 rowData.parterLevel = '';
	  }
	  $('#parterLevel').omCombo({value:rowData.parterLevel});
	  $("#medium-dialog-model").omDialog('close');
	  $("#parentChannelCode").focus();
}
//保存合作机构操作
function save(){
	var jsonData = JSON.stringify($('#tables').omGrid('getData'));
	var jsonRows = eval("["+jsonData+"]")[0].rows;
	var sumValue = 0;
	if(jsonRows.length > 0){
		for(var i = 0;i < jsonRows.length;i++){
			var getFlag = jsonRows[i].getFlag;
			if(getFlag == "1"){
				sumValue += 1;
			}
		}
		if(sumValue > 1){
			$.omMessageBox.alert({
		 	        content:'只有一条数据可以同步到核心，请重新编辑<联系信息表>第一列',
		 	        onClose:function(value){
		 	        	return false;
		 	        }
	 	        });
			return false;
		}
	}
	
	$("#baseInfo").submit();
}
//重置
function reset(){
	window.location.href = "<%=_path%>/view/channel/mediumAdd.jsp";
}
//键盘事件
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
     } else if (event.keyCode == 112) {
    	 $('#rightDiv').toggle('slow');
    	 event.returnValue = false;
     }
};
</script>
</head>
<body>
	<div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
    <!-- 	
    <div id="processDeptDropList" class="processDeptDropList"> 
		<ul id="processDeptDropListTree" class="processDeptDropListTree"></ul>
	</div>
	-->
	<div>
		<table class="navi-no-tab">
			<tr><td>合作机构新增</td></tr>
		</table>
	</div>
	<div>
		
			<form id="baseInfo">
			    <div id="leftDiv" style="float: left;">
			    <fieldSet>
			    <legend>基本信息</legend>
					<table>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">合作机构名称：</span></td>
							<td style="vertical-align: middle;"><input name="formMap['mediumCname']" id="mediumCname" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">合作机构英文名称：</span></td>
							<td><input type="text" name="formMap['mediumEname']" id="mediumEname" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">合作机构编码：</span></td>
							<td><input type="text" name="formMap['channelCode']" id="channelCode" readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">业务线：</span></td>
							<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
							<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['deptCname']" id="deptCname" readonly="readonly" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';"/><span id="choose" name="choose" class="om-combo-trigger"></span></span><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span>
							<input type="hidden" name="formMap['deptCode']" id="deptCode" /></td>
							<td style="padding-left:30px" align="right"><span class="label">经办人：</span></td>
							<td><input name="formMap['processUserCode']" id="processUserCode" readonly="readonly" onclick="selPerson();" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';"/><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<!-- 
							<td style="padding-left:30px" align="right"><span class="label">机构部门编码：</span></td>
							<td><input name="formMap['deptCode']" id="deptCode" readonly="readonly" /><span style="color:red">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td> 
							-->
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">渠道大类：</span></td>
							<td><input class="sele" name="formMap['channelCategory']" id="channelCategory" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">渠道类型：</span></td>
							<td><input class="sele" name="formMap['channelType']" id="channelType" /><span id="channelTypeStart" style="display: none;" class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">渠道性质：</span></td>
							<td><input class="sele" name="formMap['channelProperty']" id="channelProperty" /><span id="channelPropertyStart" style="display: none;" class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">渠道属类：</span></td>
							<td><input class="sele" name="formMap['channelOwnType']" id="channelOwnType" /><span id="channelOwnTypeStart" style="display: none;" class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">上级渠道：</span></td>
							<td><input name="formMap['parentChannelCode']" id="parentChannelCode" readonly="readonly" onclick="selParentMedium();" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">合作层级：</span></td>
							<td><input class="sele" name="formMap['parterLevel']" id="parterLevel" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">经营许可证：</span></td>
							<td><input name="formMap['licence']" id="licence" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">办公地址：</span></td>
							<td><input name="formMap['officeAddress']" id="officeAddress" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">注册地址：</span></td>
							<td><input name="formMap['registerAddress']" id="registerAddress" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">许可证颁发时间：</span></td>
							<td><input class="sele" name="formMap['validDate']" id="validDate" onblur="formatDate(this);" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">许可证有效时间至：</span></td>
							<td><input class="sele" name="formMap['expireDate']" id="expireDate" onblur="formatDate(this);" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">与合作机构签约时间：</span></td>
							<td><input class="sele" type="text" name="formMap['signDate']" id="signDate" onblur="formatDate(this);" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">是否协作人：</span></td>
							<td><input class="sele" name="formMap['supportFlag']" id="supportFlag" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">协议代理人：</span></td>
							<td><input name="formMap['agentCode']" id="agentCode" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">下级单位可以查看：</span></td>
							<td><input class="sele" type="text" name="formMap['childDeptLook']" id="childDeptLook" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">是否有不良记录：</span></td>
							<td><input class="sele" name="formMap['mistakeFlag']" id="mistakeFlag" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">不良记录：</span></td>
							<td><input type="text" name="formMap['mistakeContent']" id="mistakeContent" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">渠道系数：</span></td>
							<td><input name="formMap['channelRate']" id="channelRate" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">内部码：</span></td>
							<td><input type="text" name="formMap['innerCode']" id="innerCode" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">渠道外部码：</span></td>
							<td><input name="formMap['channelOuterCode']" id="channelOuterCode" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">渠道代码：</span></td>
							<td><input name="formMap['channelExtendCode']" id="channelExtendCode" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">渠道层级：</span></td>
							<td><input class="sele" name="formMap['channelLevel']" id="channelLevel" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">所属行业：</span></td>
							<td><input class="sele" name="formMap['profession']" id="profession" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">法人代表：</span></td>
							<td><input type="text" name="formMap['legal']" id="legal" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">网站地址：</span></td>
							<td><input name="formMap['website']" id="website" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">国家地区：</span></td>
							<td><input class="sele" type="text" name="formMap['country']" id="country" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">地区代码：</span></td>
							<td><input type="text" name="formMap['areaCode']" id="areaCode" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">省、市代码：</span></td>
							<td><input name="formMap['cityCode']" id="cityCode" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">是否理财险渠道：</span></td>
							<td><input class="sele" type="text" name="formMap['financeFlag']" id="financeFlag" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">理财险保单标识：</span></td>
							<td><input class="sele" type="text" name="formMap['financePolicyFlag']" id="financePolicyFlag" /></td>
							<td><span class="errorImg" id="financePolicyFlagImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">组织机构代码：</span></td>
							<td><input name="formMap['cAgentorgCde']" id="cAgentorgCde" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">数字证书编码：</span></td>
							<td><input type="text" name="formMap['cUkeyCde']" id="cUkeyCde" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">渠道特征：</span></td>
							<td><input class="sele" name="formMap['channelFeature']" id="channelFeature" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">车险平台备案代码：</span></td>
							<td><input name="formMap['cheatCode']" id="cheatCode" /></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">备注：</span></td>
							<td colspan="5"><textarea style="width:455px;" rows="2" name="formMap['remark']" id="remark"></textarea>
							<!--所有新增联系人信息封装json字符串 --> 
							<input type="hidden" name="mediumContectJsonStr" id="mediumContectJsonStr" />
							<!--附件id字符串 --> 
							<input type="hidden" name="uploadId" id="uploadId" /></td>
						</tr>
					</table>
					</fieldSet>
					<fieldSet>
			            <legend>账户信息</legend>
			            <table style="margin-left:25px;">
			            <tr>
							<td style="padding-left:30px" align="right"><span class="label">银行帐号：</span></td>
							<td><input type="text" name="formMap['bankAccount']" id="bankAccount" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:80px" align="right"><span class="label">        账户名称：</span></td>
							<td><input name="formMap['bankName']" id="bankName" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:65px" align="right"><span class="label">开户行所在省：</span></td>
							<td><input class="sele" name="formMap['bankProvince']" id="bankProvince" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">开户行所在市：</span></td>
							<td><input class="sele" type="text" name="formMap['bankCity']" id="bankCity" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">收款方银行：</span></td>
							<td><input class="sele" name="formMap['bankReceive']" id="bankReceive" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">开户行网点：</span></td>
							<td><input class="sele" name="formMap['bankNode']" id="bankNode"/><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
				</table>
			         </fieldSet>
			         <!-- <fieldSet>
			            <legend>纳税信息</legend>
			            <table>
			            <tr>
							<td style="padding-left:70px" align="right"><span class="label">纳税人名称：</span></td>
							<td><input type="text" name="formMap['taxpayerName']" id="taxpayerName" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:50px" align="right"><span class="label">纳税人识别号：</span></td>
							<td><input name="formMap['taxpayerIdNum']" id="taxpayerIdNum" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:80px" align="right"><span class="label">纳税人资质：</span></td>
							<td><input class="sele" name="formMap['taxpayerQualify']" id="taxpayerQualify" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">发票开具类型：</span></td>
							<td><input class="sele" type="text" name="formMap['invoiceType']" id="invoiceType" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">税率：</span></td>
							<td><input class="sele" name="formMap['taxRate']" id="taxRate"  readonly="readonly" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
			            </table>
			         </fieldSet> -->
				</div>
				<div id="rightDiv" style="margin-left: 960px;">
				  <span>提示</span><span onclick="javascript:$(this).parent().hide('slow');" class="msg-btn" title="关闭，连续按F1键试试">[×]</span><span></span>
				  <ul class="msg-info">
				    <li>经办人在核心系统添加，十分钟之后数据同步到销售支持系统，请先选择经办部门，再选择经办人。</li>
				    <li>渠道性质、渠道属类在核心系统添加，十分钟之后自动刷新到此页面。</li>
				    <li>开户行网点在核心系统添加，机构提供开户行网点的名称、联行号等信息，发送给总公司计划财务部的核心系统管理员，由计划财务部在核心系统添加开户行网点信息，十分钟之后自动刷新到此页面。</li>
				    <li>业务线、渠道大类、渠道类型、是否协作人、协议代理人，机构无权限修改，需要由总公司系统管理员修改。</li>
				    <li>协议签订日期、生效日期、协议类型，机构无权限修改，需要由总公司系统管理员修改。</li>
				    <li>渠道信息、协议信息分开审核，审核之后，数据即时同步到核心系统。</li>
				    <li>渠道短信通知功能，如短信通知车行、发车行推荐短信给客户，需要机构打签报之后，总公司在此页面打开短信发送的开关。</li>
				  </ul>
				</div>
			</form>
		
	</div>
	<!-- 联系人列表 -->
	<div style="float:left;">
	<div>
		<fieldSet>
			<legend>联系信息</legend>
			<div id="buttonbar" style="border-style:none none solid none;"></div>
			<table id="tables"></table>
			<form id="mediumContectFrm">
				<input type="hidden" name="formMap['channelCode']" value="" />
			</form>
		</fieldSet>
	</div>
	<!-- 老影像系统   <div id="program-upload-download" style="height:240px;"></div>-->
  <!-- 新影像系统bgn -->
	<div>
		<fieldSet>
			<legend>影像资料</legend>
			<div style="margin-left: 20px;margin-bottom: 10px;">
			  <a href='#' id="imgSys" target="_blank">合作机构证件</a>
			</div>
		</fieldSet>
	</div>
  <!-- 新影像系统end -->
	<div>
		<table style="width:100%; margin-top:20px;">
			<tr>
				<td align="center">
				<a class="om-button" id="button-save" onclick="save()">保存</a>
				<a class="om-button" id="button-reset" onclick="reset()">清空</a>
				<a class="om-button" href="javascript:history.go(-1);" id="button-cancel" onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
	</div>
	<div id="user-dialog-model" title="选择经办人">
		<iframe id="personIframe" frameborder="0" style="width: 100%; height: 99%; height: 100%; overflow-y:hidden; " src="about:blank"></iframe>
	</div>
	<div id="medium-dialog-model" title="选择上级渠道">
		<iframe id="mediumIframe" frameborder="0" style="width: 100%; height: 99%; height: 100%; overflow-y:hidden; " src="about:blank"></iframe>
	</div>
	<!-- 浙江IC卡 -->
	<div id="dialog-error" title="读卡失败" style="padding:30px; display: none;">
        <div style="padding-left:70px; height:auto!important; height:50px; min-height:50px;">
            <h4 style="font-size:14px; padding-top: 12px; margin: 0px;">读卡失败,请检查是否正确连接IC卡读卡器！</h4>
        </div>
    </div>
</body>
</html>