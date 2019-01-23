<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser,com.hf.framework.util.UUIDGenerator"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<style type="text/css">
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
/*校验错误提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer;}
input.error, textarea.error {border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px;}
/*机构菜单*/
.deptDropListTree{height:250px;width:151px;border:1px solid #9aa3b9;overflow:auto;display:none;position:absolute;background:#FFF;z-index:4;}
</style>
<title>个人代理人新增</title>
<script type="text/javascript">
var uploadId = "<%=UUIDGenerator.getUUID()%>";
var operateEmp = "<%=CurrentUser.getUser().getUserCode()%>";
$(function(){
	$("#baseInfo").find("input[name^='formMap']").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#deptCname").css({"background-color":"#fff"});

	
	/*******基本信息**********/
	//渠道大类
	$('#channelCategory').omCombo({
		dataSource : [{text:'代理业务',value:'19002'}],
        editable : false,
        value : '19002'
    });
	
	//渠道类型
	$('#channelType').omCombo({
		dataSource : [{text:'个人代理',value:'1900203'}],
        editable : false,
        value : '1900203'
    });
	
	//是否理财险渠道
	$('#financeFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        editable : false
    });
	
	//渠道特征
	$('#channelFeature').omCombo({
		dataSource : "<%=_path%>/common/queryChannelFeature.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
		value : '192001',
        editable : false,
        lazyLoad : true
    });
    
    //身份证件类型
	$('#certifyType').omCombo({
		dataSource : "<%=_path%>/common/queryCertifyType.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
		value : '120001',
        editable : true,
		filterStrategy : 'anywhere',
        lazyLoad : true
    });
    
	//性别
	$('#sex').omCombo({
        dataSource : <%=Constant.getCombo("sex")%>,
        emptyText : '请选择',
        editable : false,
        lazyLoad : true
    });
    
    //学历
	$('#educatioin').omCombo({
		dataSource : "<%=_path%>/common/queryEducatioin.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : true,
		filterStrategy : 'anywhere',
        lazyLoad : true
    });
    
	//职业
	$('#title').omCombo({
		dataSource : "<%=_path%>/common/queryTitle.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : true,
		filterStrategy : 'anywhere',
        lazyLoad : true
    });
	
	//收款方银行
	$('#bankReceive').omCombo({
		dataSource : "<%=_path%>/common/queryBank.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : true,
		filterStrategy : 'anywhere',
		onValueChange : function(target, newValue, oldValue, event) {
            if(newValue != ''){
            	//清空银行网点中的所有选项
            	$('#bankNode').omCombo("setData",[]);
            	
            	var bankCityVal = $('#bankCity').val();
            	if(bankCityVal != ''){
	            	$('#bankNode').omCombo({
		                 dataSource : "<%=_path%>/common/queryBankNode.do?bank="+newValue+"&city="+bankCityVal,
		                 emptyText : '请选择',
		                 listAutoWidth : true
		            });
            	}
            }
        },
        lazyLoad : true
    });
	
	//开户行所在省
	$('#bankProvince').omCombo({
        dataSource : "<%=_path%>/common/queryProvince.do",
        onValueChange : function(target, newValue, oldValue, event) {
        	//清空市的所有选项
            $('#bankCity').omCombo("setData",[]);
            //清空银行网点中的所有选项
        	$('#bankNode').omCombo("setData",[]);
            if(newValue != ''){
            	$('#bankCity').omCombo({
	                 dataSource : "<%=_path%>/common/queryCity.do?province="+newValue,
	                 emptyText : '请选择'
	                 /* onSuccess:function(data, textStatus, event){
	                	 $('#bankCity').omCombo({value:data[0].value});
	                 } */
	            });
            }
        },optionField : function(data, index) {
            return data.text;
		},
        emptyText : '请选择',
		filterStrategy : 'anywhere',
        lazyLoad : true
    });
	
	//开户行所在市
	$('#bankCity').omCombo({
		optionField : function(data, index) {
	        return data.text;
		},
		filterStrategy : 'anywhere',
		onValueChange : function(target, newValue, oldValue, event) {
            if(newValue != ''){
            	//清空银行网点中的所有选项
            	$('#bankNode').omCombo("setData",[]);
            	
            	var bankReceiveVal = $('#bankReceive').val();
            	if(bankReceiveVal != ''){
	            	$('#bankNode').omCombo({
		                 dataSource : "<%=_path%>/common/queryBankNode.do?city="+newValue+"&bank="+bankReceiveVal,
		                 emptyText : '请选择',
		                 listAutoWidth : true
		            });
            	}
            }
        }
	});

	//下级单位可以查看
	$('#childDeptLook').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        editable : false,
        lazyLoad : true
    });
	
	//银行网点
	$("#bankNode").omCombo({
		optionField : function(data, index) {
	        return data.text;
		},
		filterStrategy : 'anywhere'
	});
	
	//是否有不良记录
	$('#mistakeFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        editable : false,
        lazyLoad : true,
        onValueChange:function(target,newValue,oldValue,event){
            if(newValue == 1){
            	$('#mistakeContent').rules('add',{
            		required : true,
           	      	messages: {
           	      		required : jQuery.format("不良记录不能为空")
           	      	}
            	});
            }else{
            	$("#mistakeContent").rules("remove", "required"); //remove可以配置多个rule，空格隔开
            }
        	$("#mistakeContent").focus();
        }
    });
	
	//业务线
	$('#businessLine').omCombo({
		dataSource : "<%=_path%>/agent/getAgentEditBusinessline.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false
    });
	
	
	//资格证号
    $('#licenseValidDate').omCalendar();
    $('#licenseExpireDate').omCalendar();
    
    //展业证号
    $('#businessValidDate').omCalendar();
    $('#businessExpireDate').omCalendar();
    
    //执业证号
    $('#qualificationValidDate').omCalendar();
    $('#qualificationExpireDate').omCalendar();
    $('#birthday').omCalendar();
    
    //经办机构
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
         var ndata = nodedata, text = ndata.text, departCode = ndata.departCode;
         ndata = $("#deptDropListTree").omTree("getParent", ndata);
         while (ndata) {
	        //text = ndata.text + "-" + text;
	        ndata = $("#deptDropListTree").omTree("getParent", ndata);
         }
         //填充
         $("#deptCname").val(departCode+'-'+text);
         $("#deptCode").val(departCode);
         $("#deptCname").focus();
         //隐藏
         hideDropList();
       },
       onBeforeSelect : function(nodedata) {
         if (nodedata.children) {
	        return true;
         }
       },
       onSuccess: function(data){
   	     $('#deptDropListTree').omTree('expandAll');
   	   }
   });
   //隐藏
   $("#choose").click(function() {
      showDropList();
   });
   //显示
   $("#deptCname").click(function() {
      showDropList();
   });
   //定位
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
   //绑定
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
   
   //对于拥有【三级机构_代理人维护】角色权限的账户,隐藏联系信息
   $.ajax({ 
		url: "<%=_path%>/common/queryCurrUserRoleEname.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			if(data.indexOf("thirdDeptAgentManageNew")>=0){
				$("#contactInfo").hide();
			}
		}
	});

   /***********附件*************/
   //initFilePage();
     
	//初始化页面保存、重置、取消按钮
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-reset").omButton({icons : {left : '<%=_path%>/images/clear.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	
	initValidate();
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
    
    $.validator.addMethod("bankAccountCheck",function(value){
    	var reg = /^[0-9]+[\-]?[0-9]+$/;
    	return reg.test(value);
    },"银行帐号只允许包含数字或横线，例：10-1234");
    
    $.validator.addMethod("isPhone", function(value) {
        var regu =/(^[1][358][0-9]{9}$)|(^((\d{3,4})-)?(\d{6,8})(-(\d{3,}))?$)/; 
        var reg = new RegExp(regu);
        return reg.test(value);  // 手机,固话验证
    }, '不是有效的联系电话');
    
    $.validator.addMethod("maxPostLength", function(value) {
    	if(value!='' && value !=undefined){
	        return /^\d{6}$/.test(value);
    	}else{
	        return /^\d{0}$/.test(value);
    	}
 	}, '邮编长度为6位数字');
    
    //资格证号起止日期校验
    $.validator.addMethod("gtLicenseValidDate", function(value) {
    	var validDate = $("#licenseValidDate").val();
        return value > validDate;
 	}, '此日期应大于资格证生效日期');
    
    //展业证号起止日期校验
    $.validator.addMethod("gtBusinessValidDate", function(value) {
    	var validDate = $("#businessValidDate").val();
	    return value > validDate;
 	}, '此日期应大于展业证生效日期');
    
    
 	//执业证号起止日期校验
    $.validator.addMethod("gtQualificationValidDate", function(value) {
    	var validDate = $("#qualificationValidDate").val();
        return value > validDate;
 	}, '此日期应大于执业证生效日期');
    
    $.validator.addMethod("validDay", function(value) {
    	var date = new Date();
    	//date.setFullYear(date.getFullYear()-18, date.getMonth(), date.getDate());
        return $.omCalendar.parseDate(value, 'yy-mm-dd') < date;
 	}, '此日期无效');

    $.validator.addMethod("deptCnameRequired", function(value) {
        return value != '请选择';
 	}, '经办部门必选');
    
    //==============================联系人处理开始=============================================
	//初始化联系信息列表
	var postOptions = {
	  allowDecimals:false,
	       allowNegative:false
	};
	var getFlagOptions = {
	   dataSource:[{text:"请选择",value:""},{text:"是" , value:"1"},{text:"否",value:"0"}],
	   disabled: false
	  };
	var msgCarOptions = {
	      dataSource:[{text:"请选择",value:""},{text:"是" , value:"1"},{text:"否",value:"0"}],
	    editable: true
	   };
	var isSendCmpnycontactOptions = {
	    dataSource:[{text:"请选择",value:""},{text:"发送" , value:"Y"},{text:"不发送",value:"N"}],
	    editable: false
	   };
	var isSendTrueagtOptions = {
	    dataSource:[{text:"请选择",value:""},{text:"发送" , value:"Y"},{text:"发送并屏蔽代理人",value:"G"},{text:"不发送",value:"N"}],
	    editable: false
	  };
	var agtinfoSourceOptions = {
	    dataSource:[{text:"请选择",value:""},{text:"从代理人提取" , value:"0"},{text:"从协作人提取",value:"1"}],
	    editable: false
	  };
	//联系信息
	var tabHead = 0 || [ {header:"是否同步核心<br/>(只有一条可选'是')" , name:"getFlag",width:100, align:'center',editor:{type:"omCombo", name:"getFlag" ,options:getFlagOptions},renderer:getFlagRenderer},
	                 {header:"联系人",name:"contact",width:80, align:'center',editor:{rules:["required",true,"联系人不能为空"],editable:true}},
	               	 {header:"职务",name:"title",width:80, align:'center',editor:{editable:true}},
	              	 {header:"手机",name:"mobile",width:105, align:'center',editor:{rules:["isMobilePhone"],editable:true}},
	              	 {header:"电话号码",name:"tel",width:105, align:'center',editor:{rules:["isTelephone"],editable:true}},
	              	 {header:"E-mail",name:"email",width:155, align:'center',editor:{rules:["isEmail"],editable:true}},
	              	 {header:"传真",name:"fax",width:105, align:'center',editor:{editable:true}},
	              	 {header:"地址", name:"addresss",width:150, align:'center',editor:{editable:true}},
	               	 {header:"邮政编码", name:"post",width:80, align:'center',editor:{rules:["maxPostLength"],editable:true,type:"omNumberField",options:postOptions}},
	               	 {header:"短信通<br/>知代理人", name:"msgCar",width:80, align:'center',editor:{type:"omCombo", name:"msgCar" ,options:msgCarOptions},renderer:msgCarRenderer},
	               	 {header:"我司联系<br/>人手机",name:"companyPhone",width:105, align:'center',editor:{rules:["isMobilePhone"],editable:true}},
	             	 {header:"短信通知<br/>我司联系人",name:"isSendCmpnycontact",width:80, align:'center',editor:{type:"omCombo", name:"isSendCmpnycontact" ,options:isSendCmpnycontactOptions},renderer:isSendCmpnycontactRenderer},
	             	 {header:"短信通知<br/>协作人",name:"isSendTrueagt",width:80, align:'center',editor:{type:"omCombo", name:"isSendTrueagt" ,options:isSendTrueagtOptions},renderer:isSendTrueagtRenderer},
	             	 {header:"短信中代理<br/>人信息来源",name:"agtinfoSource",width:120, align:'center',editor:{type:"omCombo", name:"agtinfoSource" ,options:agtinfoSourceOptions},renderer:agtinfoSourceRenderer},
	             	 {header:"备注", name:"remark",width:80,editor:{editable:true}}
	             	];	
	/*
	 * 功能：总公司_渠道管理岗_市场开发，总公司_室主任、系统管理员角色   只有这三个角色可见“是否同步到核心”的开关并且操作
	 * 作者：sunyf
	 * 日期：2015-04-20
	 */ 
	var contactRole = 'headDeptChannel,headDeptDirector,subDeptMangerNew,xszcAdmin'; 
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
         width:'fit',
	     dataSource:"<%=_path%>/mediumContect/queryMediumContect.do?"+$("#agentContectFrm").serialize(),
	     onAfterEdit:function(rowIndex,rowData){
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
	    		    				$("#tables").omGrid("cancelChanges");
	    			 	        	return false;
	    			 	        }
	    		 	        });
	    				return false;
	    			}
	    		}
	     }
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
    
		var sysUrl = "http://ecmp.sinosafe.com.cn:8080/Interface_Cluster/FileUpLoadAction?SystemCode=XSZC01&FunctionCode=XSZC0102&OrgCode=01010000&UserCode=100052692&BatchFlg=0&AuthorizCode=1111&BusinessCode="+uploadId;
	  $('#imgSys').attr("href",sysUrl);
    //初始化联系列表按钮菜单
	$('#buttonbar').omButtonbar({
           	btns:[{label:"新增",
            		     id:"addButton" ,
            		     icons:{left:'<%=_path%>/images/add.png'},
            	 		 onClick:function(){
            	 			$('#tables').omGrid("insertRow",0,{getFlag:0,agtinfoSource:0});
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
    //==============================联系人处理结束=============================================
    
    //隐藏校验星号
    //setTimeout("hideValidateStar()", 500);
    
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
		title : '个人代理人证件',
		modelCode : 'XSZC010103',
		mainBillNo : "",
		seriesNo : uploadId,
		srcUrl : '${sessionScope.imgUrl}',
		operateEmp : operateEmp
	});
}

//是否校验资格证号
var isLicenseNo = true;
/* $.ajax({
	url:Util.appCxtPath+"/agent/queryChannelLicenseValid.do",
	type:"POST",
	dataType:"JSON",
	async:false,
	success:function(msg){
		if (msg)
			isLicenseNo = false;
	}
}); */

//定义校验规则
var mediumConferRule = {
	channelCategoryformMap:{
		required : true
	},channelTypeformMap:{
		required : true
	}/*,channelCodeformMap:{
		required : true,
		remote : Util.appCxtPath+"/agent/queryChannelCode.do",
		isLetterAndInteger : true,
		maxlength : 50
	} */,channelNameformMap:{
		required : true,
		maxlength : 25
	},/* financeFlagformMap:{
		required : true
	},*/channelRateformMap:{
		number:true
	},channelFeatureformMap:{
		required : true
	},certifyTypeformMap:{
		required : true
	},certifyNoformMap:{
		required : true
	},licenseNoformMap:{
		required : isLicenseNo,
		isLetterAndInteger : isLicenseNo,
		maxlength : 50
	},licenseValidDateformMap:{
		required : isLicenseNo,
		isDate:isLicenseNo
	},licenseExpireDateformMap:{
		required : isLicenseNo,
		gtLicenseValidDate : isLicenseNo,
		isDate:isLicenseNo
	},businessNoformMap:{
		required : true,
		isLetterAndInteger : true,
		maxlength : 50
	},businessValidDateformMap:{
		required : true,
		isDate:true
	},businessExpireDateformMap:{
		required : true,
		gtBusinessValidDate : true,
		isDate:true
	},qualificationNoformMap:{
		isLetterAndInteger : true,
		maxlength : 50
	},qualificationValidDateformMap:{
		required : true,
		isDate:true
	},qualificationExpireDateformMap:{
		required : true,
		gtQualificationValidDate : true,
		isDate:true
	},contractNoformMap:{
		required : true,
		isLetterAndInteger : true,
		maxlength : 50
	},mobileformMap:{
		required : true,
		isMobilePhone : true
	},deptCnameformMap:{
		deptCnameRequired : true
	},telformMap:{
		required : true,
		isTelephone : true
	},emailformMap:{
		required : true,
		email : true
	},adderssformMap:{
		required : true
	},sexformMap:{
		required : true
	},postCodeformMap:{
		maxlength : 6
	},birthdayformMap:{
		required : true,
		validDay : true,
		isDate:true
	},educatioinformMap:{
		required : true
	},mistakeFlagformMap:{
		required : true
	},bankNameformMap:{
		required : true,
		maxlength : 50
	},bankAccountformMap:{
		required : true,
		bankAccountCheck:true,
		maxlength : 30
	},bankReceiveformMap:{
		required : true
	},bankProvinceformMap:{
		required : true
	},bankCityformMap:{
		required : true
	},bankNodeformMap:{
		required : true
	},businessLineformMap:{
		required : true
	}
};

//定义校验的显示信息
var mediumConferMessages = {
	channelCategoryformMap:{
		required : '渠道大类必选'
	},channelTypeformMap:{
		required : '渠道类型必选'
	}/*,channelCodeformMap:{
		required : '个人代理人编码不能为空',
		remote : "此编码已经被注册",
		isLetterAndInteger : '个人代理人编码必须是数字和字母',
		maxlength : '个人代理人编码最长50位'
	} */,channelNameformMap:{
		required : '姓名不能为空',
		maxlength : '姓名最长25位'
	},/* financeFlagformMap:{
		required : '是否理财险渠道必选'
	}, */channelRateformMap:{
		//required : '渠道系数不能为空',
		number : '渠道系数必须是数字'
	},channelFeatureformMap:{
		required : '渠道特征必选'
	},certifyTypeformMap:{
		required : '身份证件类型必选'
	},certifyNoformMap:{
		required : '证件号码不能为空'
	},licenseNoformMap:{
		required : '资格证号不能为空',
		isLetterAndInteger : '资格证号必须是数字和字母',
		maxlength : '资格证号最长50位'
	},licenseValidDateformMap:{
		required : '此日期不能为空'
	},licenseExpireDateformMap:{
		required : '此日期不能为空',
		isLetterAndInteger : '资格证号必须是数字和字母',
		maxlength : '资格证号最长50位'
	},businessNoformMap:{
		required : '展业证号不能为空',
		maxlength : '展业证号最长50位'
	},businessValidDateformMap:{
		required : '此日期不能为空'
	},businessExpireDateformMap:{
		required : '此日期不能为空'
	},qualificationNoformMap:{
		isLetterAndInteger : '执业证号必须是数字和字母',
		maxlength : '执业证号最长50位'
	},qualificationValidDateformMap:{
		required : '此日期不能为空'
	},qualificationExpireDateformMap:{
		required : '此日期不能为空'
	},contractNoformMap:{
		required : '代理合同编码不能为空',
		isLetterAndInteger : '代理合同编码必须是数字和字母',
		maxlength : '代理合同编码最长50位'
	},mobileformMap:{
		required : '手机号不能为空'
	},deptCodeformMap:{
		required : '机构部门必选'
	},telformMap:{
		required : '联系电话不能为空'
	},emailformMap:{
		required : '邮箱不能为空',
		email : '邮箱格式不正确'
	},adderssformMap:{
		required : '通讯地址不能为空'
	},sexformMap:{
		required : '性别必选'
	},postCodeformMap:{
		maxlength : '邮编最长6位'
	},birthdayformMap:{
		required : '出生年月不能为空'
	},educatioinformMap:{
		required : '学历必选'
	},mistakeFlagformMap:{
		required : '是否有不良记录必选'
	},bankNameformMap:{
		required : '账户名称不能为空',
		maxlength : '账户名称最长50位'
	},bankAccountformMap:{
		required : '银行帐号不能为空',
		maxlength : '银行帐号最长30位'
	},bankReceiveformMap:{
		required : '收款方银行必选'
	},bankProvinceformMap:{
		required : '开户行所在省必选'
	},bankCityformMap:{
		required : '开户行所在市必选'
	},bankNodeformMap:{
		required : "开户行名称必选"
	},businessLineformMap:{
		required : '业务线必选'
	}
};

//校验
function initValidate(){
	//将name属性修改进行验证
	$("#baseInfo").find("input[name^='formMap']").each(function(){
		$(this).attr("name",$(this).attr("id")+"formMap");
	});
	
	$("#baseInfo").validate({
		rules: mediumConferRule,
		messages: mediumConferMessages,
		errorPlacement : function(error, element) {
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
        showErrors : function(errorMap, errorList) {
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
        submitHandler : function() {
        	//将name属性还原，提交保存
        	$("#baseInfo").find("input[name$='formMap']").each(function(){
        		$(this).attr("name","formMap['"+$(this).attr("id")+"']");
        	});
        	var jsonData = JSON.stringify($("#tables").omGrid("getData")["rows"]);
        	$('#agentContectJsonStr').val(jsonData);
        	//附件
        	$('#uploadId').val(uploadId);
        	
        	$.omMessageBox.waiting({
                title:'请等待',
                content:'服务器正在处理请求...'
            });
        	
        	Util.post(
       			"<%=_path%>/agent/saveAgent.do?",
       			$("#baseInfo").serialize(),
       			function(data) {
       				$.omMessageBox.waiting('close');
       				$.omMessageBox.alert({
       					type:'success',
                        title:'成功',
   	 		 	        content:'个人代理人保存成功',
   	 		 	        onClose:function(value){
		       				//保存成功后跳转回个人代理人管理主页
		       				window.location.href = "agent.jsp";
   	 		 	        	return true;
   	 		 	        }
 		 	        });
       	    	}
        	);
        }
    });
}

//保存个人代理人操作
function save(){
	$("#baseInfo").submit();
}

//重置
function reset(){
	window.location.href = "<%=_path%>/view/channel/agentAdd.jsp";
}

//是否显示资格证号及起止日期的校验星号，此校验已经废除
function hideValidateStar(){
	$.ajax({
		url:Util.appCxtPath+"/agent/queryChannelLicenseValid.do",
		type:"post",
		dataType:"json",
		async:false,
		success:function(msg){
			if (msg){
				$("#spanLicenseNo").hide();
				$("#spanLicenseValidDate").hide();
				$("#spanLicenseExpireDate").hide();
			}
		}
	});
}

</script>
</head>
<body>
	<div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
	<div>
		<table class="navi-no-tab">
			<tr><td>个人代理人新增</td></tr>
		</table>
	</div>
	<div>
			<form id="baseInfo">
			<fieldSet>
				<legend>基本信息</legend>
				<table>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">个人代理人姓名：</span></td>
						<td><input name="formMap['channelName']" id="channelName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">个人代理人编码：</span></td>
						<td><input type="text" name="formMap['channelCode']" id="channelCode" readonly="readonly" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
						<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['deptCname']" id="deptCname" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" readonly="readonly" /><span id="choose" name="choose" class="om-combo-trigger"></span></span><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span>
						<input type="hidden" name="formMap['deptCode']" id="deptCode" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">渠道大类：</span></td>
						<td><input class="sele" name="formMap['channelCategory']" id="channelCategory" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">渠道类型：</span></td>
						<td><input class="sele" name="formMap['channelType']" id="channelType" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">业务线：</span></td>
						<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span>
						<!--附件id字符串 --> 
						<input type="hidden" name="uploadId" id="uploadId" /></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">是否理财险渠道：</span></td>
						<td><input class="sele" type="text" name="formMap['financeFlag']" id="financeFlag" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">渠道系数：</span></td>
						<td><input name="formMap['channelRate']" id="channelRate" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">下级单位可以查看：</span></td>
						<td><input class="sele" type="text" name="formMap['childDeptLook']" id="childDeptLook" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">渠道特征：</span></td>
						<td><input class="sele" name="formMap['channelFeature']" id="channelFeature" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">身份证件类型：</span></td>
						<td><input class="sele" name="formMap['certifyType']" id="certifyType" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">证件号码：</span></td>
						<td><input name="formMap['certifyNo']" id="certifyNo" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<!-- 按监管要求：资格证号、有效期自、有效期至、展业证号、有效期有效期自、有效期至。这六项可以删除（如暂时无法删除，请均修改为非必录项） 20150930 -->
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">资格证号：</span></td>
						<td><input name="formMap['licenseNo']" id="licenseNo" /><span id="spanLicenseNo" style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
						<td><input class="sele" name="formMap['licenseValidDate']" id="licenseValidDate" onblur="formatDate(this);" /><span id="spanLicenseValidDate" style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
						<td><input class="sele" name="formMap['licenseExpireDate']" id="licenseExpireDate" onblur="formatDate(this);" /><span id="spanLicenseExpireDate" style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">展业证号：</span></td>
						<td><input name="formMap['businessNo']" id="businessNo" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
						<td><input class="sele" name="formMap['businessValidDate']" id="businessValidDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
						<td><input class="sele" name="formMap['businessExpireDate']" id="businessExpireDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">执业证号：</span></td>
						<td><input name="formMap['qualificationNo']" id="qualificationNo" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
						<td><input class="sele" name="formMap['qualificationValidDate']" id="qualificationValidDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
						<td><input class="sele" name="formMap['qualificationExpireDate']" id="qualificationExpireDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">代理合同编码：</span></td>
						<td><input name="formMap['contractNo']" id="contractNo" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">手机：</span></td>
						<td><input type="text" name="formMap['mobile']" id="mobile" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<!-- <td style="padding-left:30px" align="right"><span class="label">机构部门编码：</span></td>
						<td><input name="formMap['deptCode']" id="deptCode" readonly="readonly" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td> -->
						<td style="padding-left:30px" align="right"><span class="label">电话号码：</span></td>
						<td><input type="text" name="formMap['tel']" id="tel" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">E-mail：</span></td>
						<td><input name="formMap['email']" id="email" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">传真：</span></td>
						<td><input type="text" name="formMap['fax']" id="fax" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">通讯地址：</span></td>
						<td><input name="formMap['adderss']" id="adderss" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">性别：</span></td>
						<td><input class="sele" name="formMap['sex']" id="sex" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">邮编：</span></td>
						<td><input type="text" name="formMap['postCode']" id="postCode" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">出生年月：</span></td>
						<td><input class="sele" name="formMap['birthday']" id="birthday" onblur="formatDate(this);" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">学历：</span></td>
						<td><input class="sele" name="formMap['educatioin']" id="educatioin" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">职业：</span></td>
						<td><input class="sele" type="text" name="formMap['title']" id="title" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">职务：</span></td>
						<td><input name="formMap['duty']" id="duty" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">是否有不良记录：</span></td>
						<td><input class="sele" name="formMap['mistakeFlag']" id="mistakeFlag" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">不良记录：</span></td>
						<td><input type="text" name="formMap['mistakeContent']" id="mistakeContent" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">备注：</span></td>
						<td colspan="4">
						   <textarea rows="2" style="width:97%;" name="formMap['remark']" id="remark"></textarea>
						   <input type="hidden" name="agentContectJsonStr" id="agentContectJsonStr" />
						</td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
				</table>
		  </fieldSet>
			<fieldSet>
			<legend>账户信息</legend>
			<table>
			        <tr>
						<td style="padding-left:70px" align="right"><span class="label">银行帐号：</span></td>
						<td><input type="text" name="formMap['bankAccount']" id="bankAccount" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:60px" align="right"><span class="label">账户名称：</span></td>
						<td><input name="formMap['bankName']" id="bankName" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:60px" align="right"><span class="label">开户行所在省：</span></td>
						<td><input class="sele" name="formMap['bankProvince']" id="bankProvince" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
					    <td style="padding-left:30px" align="right"><span class="label">开户行所在市：</span></td>
						<td><input class="sele" type="text" name="formMap['bankCity']" id="bankCity" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">收款方银行：</span></td>
						<td><input class="sele" name="formMap['bankReceive']" id="bankReceive" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">开户行名称：</span></td>
						<td><input class="sele" name="formMap['bankNode']" id="bankNode" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
			</table>
			</fieldSet>
			<!-- <fieldSet>
			            <legend>纳税信息</legend>
			            <table>
			            <tr>
							<td style="padding-left:60px" align="right"><span class="label">纳税人名称：</span></td>
							<td><input type="text" name="formMap['taxpayerName']" id="taxpayerName" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:40px" align="right"><span class="label">纳税人识别号：</span></td>
							<td><input name="formMap['taxpayerIdNum']" id="taxpayerIdNum" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:80px" align="right"><span class="label">纳税人资质：</span></td>
							<td><input class="sele" name="formMap['taxpayerQualify']" id="taxpayerQualify" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">发票开具类型：</span></td>
							<td><input class="sele" type="text" name="formMap['invoiceType']" id="invoiceType" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">税率(自动带出)：</span></td>
							<td><input class="sele" name="formMap['taxRate']" id="taxRate"  readonly="readonly" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
			            </table>
			     </fieldSet> -->
		</form>
	</div>
	<!-- 联系人列表 -->
	<div id="contactInfo">
		<fieldSet>
			<legend>联系信息</legend>
			<div id="buttonbar" style="border-style:none none solid none;"></div>
			<table id="tables"></table>
			<form id="agentContectFrm">
				<input type="hidden" name="formMap['channelCode']" value="" />
			</form>
		</fieldSet>
	</div>
	<!-- 附件上传框 -->
<!-- 	<div id="program-upload-download" style="height:240px;"></div> -->
  <!-- 新影像系统bgn -->
  <div>
    <fieldSet>
      <legend>影像资料</legend>
      <div style="margin-left: 20px;margin-bottom: 10px;">
        <a href='#' id="imgSys" target="_blank">个代证件</a>
      </div>
    </fieldSet>
  </div>
  <!-- 新影像系统end -->
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-left:30px;padding-top:20px" align="center">
				<a class="om-button" id="button-save" onclick="save()">保存</a>
				<a class="om-button" id="button-reset" onclick="reset()">清空</a>
				<a class="om-button" href="javascript:history.go(-1);" id="button-cancel" onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
</body>
</html>