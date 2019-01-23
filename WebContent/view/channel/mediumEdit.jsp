<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser,com.hf.framework.util.UUIDGenerator"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<style type="text/css">
*{padding:0;marging:0}
html, body{height:100%; margin:0px; padding:0px;}
/*只读灰化 */
input[readonly='readonly']:not(.sele),textarea[readonly='readonly'],input[readonly='true'],textarea[readonly='true']{background-color:#F0F0F0;color:gray;}
.om-grid div.hDivBox {float: left;padding-right: 0px;padding-right-value: 0px;padding-right-ltr-source: physical;padding-right-rtl-source: physical;}
.om-grid .gird-edit-btn{width:190px;}
fieldSet .om-grid{border:none;}
.om-button {font-size: 12px;}
#nav_cont {width: 580px;margin-left: auto;margin-right: auto;}
input{height:18px;border: 1px solid #A1B9DF;vertical-align: middle;}
input:focus {border: 1px solid #3A76C2;}
.input_slelct {width: 81%;}
.textarea_text {border: 1px solid #A1B9DF;height: 40px;width: 445px;}
table.grid_layout tr td {font-weight: normal;height: 15px;padding: 5px 0;vertical-align: middle;}
.color_red {color: red;}
.toolbar {padding: 12px 0 5px;
text-align: center;}
.birthplace,.address {width: 445px;}
.om-span-field input:focus {border: none;}
.tds { padding-left: 30px;}
.tdsDate {width:115px;}
.deptDropListTree {height:250px;width:151px;border: 1px solid #9AA3B9;overflow: auto;display: none;position: absolute;background: #FFF;z-index: 4;}
/*.processDeptDropListTree {height: 250px;width: 153px;border: 1px solid #9AA3B9;overflow: auto;display: none;position: absolute;background: #FFF;z-index: 4;}*/
.navi-tab {border: solid #d0d0d0 1px; width: 100%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px;}
/*校验错误提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error, textarea.error {border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px}
/*校验星号*/
span.asterisk{color:red;position:relative;top:4px;}
</style>
<title>中介编辑</title>
<%
String channelCode = request.getParameter("channelCode");
String tabFlag = request.getParameter("flag");
boolean trueOrFalse = Boolean.parseBoolean(request.getParameter("trueOrFalse")); //短信开关，只有总公司的人可以配置短信开关
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var tabFlag = '<%=tabFlag%>';
var trueOrFalse = <%=trueOrFalse%>;

var uploadId = "<%=UUIDGenerator.getUUID()%>";
var operateEmp = "<%=CurrentUser.getUser().getUserCode()%>";

var currentUploadId;
var expireDate;
var validDate;
var userDptCde = '';
var returnFlag = '1';
//经办部门是否修改
var jbDeptCode1 ="", jbDeptCode2 ="";
//
$(function(){
	$("#baseInfo").find("input[name^='formMap']").css({"width":"150px"});
	$("#mediumNodeFilterFrm").find("input[name^='formMap']").css({"width":"151px"});
	$("#mediumConferFilterFrm").find("input[name^='formMap']").css({"width":"151px"});
	$(".sele").css({"width":"131px"});
	//$("#deptCname").css({"background-color":"#fff"});
	$("#processDeptCode").css({"background-color":"#fff"});
	$("#parentChannelCode").css({"background-color":"#fff"});
	//$("#processUserCode").css({"background-color":"#fff"});
    $("#taxRate").width("150");
	
	//给该隐藏域赋值，为查询合作机构和相关联系人提供数据（外键）
	$('#mediumCode_fk').val(channelCode);
	//给该隐藏域赋值，为查询相关网点提供数据（外键）
	$('#mediumCode_fk_node').val(channelCode);
	//给该隐藏域赋值，为查询相关协议提供数据（外键）
	$('#mediumCode_fk_confer').val(channelCode);
	if(tabFlag==0){
		$("#tab1").css({"background-color":"#6EA2DB","color":"white"});
	}else{
		$("#tab2").css({"background-color":"#6EA2DB","color":"white"});
	}
	/******初始化tab标签页*********/
	$('#make-tab').omTabs({
	    closable : false,
	    active : tabFlag,
	    switchMode : 'mouseover',
	    onActivate : function(n,event) {
	    	$("#tab1").attr("style","height:27px;width:auto;");
	    	$("#tab2").attr("style","height:27px;width:auto;");
	     }
    });
	//是否协作人
	$('#supportFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        editable : false,
        emptyText : '请选择'
        /*,
        onValueChange:function(target,newValue,oldValue,event){
            if(newValue == 1){
            	$('#agentCode').rules('add',{
            		required : true,
           	    messages: {required : jQuery.format("代理人不能为空")}
            	});
            }else{
            	$("#agentCode").rules("remove", "required"); //remove可以配置多个rule，空格隔开
            }
        	$("#agentCode").focus();
        }
        readOnly : true*/
    });
	
	//合作层级
	$('#parterLevel').omCombo({
        dataSource : <%=Constant.getCombo("isParterLevel")%>,
        emptyText : '请选择',
        editable : false
    });
	
	//是否理财险渠道
	$('#financeFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        editable : false,
        onValueChange:function(target,newValue,oldValue,event){
            if(newValue == 1){
            	$('#financePolicyFlag').rules('add',{
            		required : true,
           	      	messages: {
           	      		required : jQuery.format("理财险保单标识必选")
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
		dataSource : "<%=_path%>/common/queryCategory.do",
		onValueChange : function(target, newValue, oldValue, event) {
            $('#channelType').omCombo("setData",[]);
        	$('#channelProperty').omCombo("setData",[]);
        	$('#channelOwnType').omCombo("setData",[]);
            if(newValue != ''){
	          $('#channelType').omCombo({
	                 dataSource : "<%=_path%>/common/queryProperty.do?parentCode="+newValue,
	                 emptyText : '请选择'
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
        },optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	//渠道类型
	$('#channelType').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
        	$('#channelProperty').omCombo("setData",[]);
        	$('#channelOwnType').omCombo("setData",[]);
            if(newValue != ''){
	           	$('#channelProperty').omCombo({
	                 dataSource : "<%=_path%>/common/queryProperty.do?parentCode="+newValue,
	                 emptyText : '请选择'
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
        },optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	//渠道性质
	$('#channelProperty').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
        	$('#channelOwnType').omCombo("setData",[]);
            if(newValue != ''){
            	$('#channelOwnType').omCombo({
	                 dataSource : "<%=_path%>/common/queryProperty.do?parentCode="+newValue,
	                 emptyText : '请选择'
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
        },optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false
    });
	
	//渠道属类
	$('#channelOwnType').omCombo({
		optionField : function(data, index) {
            return data.text;
		},
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
        editable : false
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
	            });
            }
        },optionField : function(data, index) {
            return data.text;
		},
		filterStrategy : 'anywhere'
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
		                 editable : false,
		                 listAutoWidth : true
		            });
            	}
            }else{
            	$('#bankNode').omCombo("setData",[]);
            }
        }
	});
	//收款方银行
	$('#bankReceive').omCombo({
		dataSource : "<%=_path%>/common/queryBank.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
		onValueChange : function(target, newValue, oldValue, event) {
            if(newValue != ''){
            	//清空银行网点中的所有选项
            	$('#bankNode').omCombo("setData",[]);
            	
            	var bankCityVal = $('#bankCity').val();
            	if(bankCityVal != ''){
	            	$('#bankNode').omCombo({
		                 dataSource : "<%=_path%>/common/queryBankNode.do?bank="+newValue+"&city="+bankCityVal,
		                 emptyText : '请选择',
		                 editable : false,
		                 listAutoWidth : true
		            });
            	}
            }else{
            	$('#bankNode').omCombo("setData",[]);
            }
        }
    });
	
	//银行网点
	$("#bankNode").omCombo({
		optionField : function(data, index) {
	        return data.text;
		},
		emptyText : '请选择',
		editable : false,
		filterStrategy : 'anywhere',
        listAutoWidth : true
	});
	//业务线
	$('#businessLine').omCombo({
		dataSource : "<%=_path%>/medium/getMediumEditBusinessline.do?channelCode="+channelCode,
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	//国家地区
	$('#country').omCombo({
		dataSource : "<%=_path%>/common/queryCountry.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false
    });
	//渠道层级
	$('#channelLevel').omCombo({
        dataSource : "<%=_path%>/common/queryChannelLevel.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false
    });
	//所属行业
	$('#profession').omCombo({
		dataSource : "<%=_path%>/common/queryProfession.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false
    });
	//是否有不良记录
	$('#mistakeFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        editable : false,
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
	//下级单位可以查看
	$('#childDeptLook').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        emptyText : '请选择',
        emptyText : '请选择',
        editable : false
    });
	//理财险保单标示
	$('#financePolicyFlag').omCombo({
		dataSource : "<%=_path%>/common/queryFinancePolicyFlag.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        lazyLoad : true
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
	//经办机构
    $("#deptDropListTree").omTree({
        dataSource : "<%=_path%>/department/queryDeptDropList.do",
	    simpleDataModel:true,
	    //展开之前
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
         //变更后的经办部门
         jbDeptCode2 = nodedata.deptCode;
         ndata = $("#deptDropListTree").omTree("getParent", ndata);
         while (ndata) {
	        //text = ndata.text + "-" + text;
	        ndata = $("#deptDropListTree").omTree("getParent", ndata);
         }
         //填充
         $("#deptCname").val(departCode+'-'+text);
         $("#deptCode").val(departCode);
         $("#parentChannelCode").val('请选择'); //选择经办部门后，上级渠道被清空
         $("#deptCname").focus();
         //隐藏
         hideDropList();
       },
       //选择后
       onBeforeSelect : function(nodedata) {
         if (nodedata.children) {
	        return true;
         }
       },
       onSuccess: function(data){
   	     $('#deptDropListTree').omTree('expandAll');
   	   }
   });
   //点击下拉按钮
   $("#choose").click(function() {
      showDropList();
   });
   //点击输入框
   $("#deptCname").click(function() {
      showDropList();
   });
   //定位显示
   function showDropList() {      
	  var cityInput = $("#deptCname");
   	  var cityOffset = cityInput.offset();
   	  var topnum = cityOffset.top+cityInput.outerHeight()-1;
   	  var leftnum = cityOffset.left-1;
   	  if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	  topnum = topnum + 2;
      }
      $("#deptDropListTree").css({"margin-left": leftnum + "px","margin-top": topnum +"px"}).show();
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
  
 //选择用户
$("#user-dialog-model").omDialog({
     autoOpen : false,
     width : 750,
     height : 465,
     modal : true,
     resizable : false,
     onOpen : function(event) {
	    $("#personIframe").attr("src","<%=_path%>/view/demo/selectUserIframe.jsp?deptCode="+$("#deptCode").val());
	 }
});

//选择上级合作机构
$("#medium-dialog-model").omDialog({
     autoOpen : false,
     width : 750,
     height : 465,
     modal : true,
     resizable : false,
     onOpen : function(event) {
    	$("#mediumIframe").attr("src","<%=_path%>/view/demo/selectParentMediumIframe.jsp");
     }
});

/*******基本信息**********/
//加载合作机构详细信息
Util.post("<%=_path%>/medium/queryMediums.do",$("#mediumContectFrm").serialize(),function(data) {
		//原来的经办部门
		jbDeptCode1 = data[0].deptCode;
		//为新增协议提供校验信息
		expireDate = data[0].expireDate;
		validDate = data[0].validDate;
		//填充数据
		$("#baseInfo").find(":input").each(function(){
			if($(this).val() != null || $(this).val() != "")
			$(this).val(data[0][$(this).attr("id")]);
		});
		//是否协作人
		$('#supportFlag').omCombo({value : data[0].supportFlag});
		//合作层级
		$('#parterLevel').omCombo({value : data[0].parterLevel});
		//是否理财险渠道
		$('#financeFlag').omCombo({value : data[0].financeFlag});
		//渠道大类
		$('#channelCategory').omCombo({value : data[0].channelCategory});
		
		//当进入编辑页面,渠道大类为"代理业务"时,渠道类型为必选
		if(data[0].channelCategory == '19002'){
			$('#channelType').rules("add","required");
          	$('#channelTypeStart').show();
		}
		//渠道类型
		$('#channelType').omCombo({
			dataSource : "<%=_path%>/common/queryProperty.do?parentCode="+data[0].channelCategory,
			value : data[0].channelType
		});
		//渠道性质
		$('#channelProperty').omCombo({
			dataSource : "<%=_path%>/common/queryProperty.do?parentCode="+data[0].channelType,
			value : data[0].channelProperty
		});
		
		//当进入编辑页面，渠道类型为‘兼业代理’时，“渠道性质”为必选
		if(data[0].channelType == '1900202'){
			$('#channelProperty').rules("add","required");
          	$('#channelPropertyStart').show();
		}
		
		//渠道属类
		$('#channelOwnType').omCombo({
			dataSource : "<%=_path%>/common/queryProperty.do?parentCode="+data[0].channelProperty,
			value : data[0].channelOwnType
		});
		//渠道特征
		$('#channelFeature').omCombo({value : data[0].channelFeature});
		//开户行所在省
		$('#bankProvince').omCombo({value : data[0].bankProvince});
		//开户行所在市
		$('#bankCity').omCombo({
			dataSource : "<%=_path%>/common/queryCity.do?province="+data[0].bankProvince,
			value : data[0].bankCity
		});
		//收款方银行
		$('#bankReceive').omCombo({value : data[0].bankReceive});
		//开户行网点
		$('#bankNode').omCombo({
			dataSource : "<%=_path%>/common/queryBankNode.do?bank="+data[0].bankReceive+"&city="+data[0].bankCity,
			value : data[0].bankNode
		});
		//业务线
		$('#businessLine').omCombo({value : data[0].businessLine});
		//国家地区
		$('#country').omCombo({value : data[0].country});
		//渠道层级
		$('#channelLevel').omCombo({value : data[0].channelLevel});
		//所属行业
		$('#profession').omCombo({value : data[0].profession});
		//是否有不良记录
		$('#mistakeFlag').omCombo({value : data[0].mistakeFlag});
		//下级单位可以查看
		$('#childDeptLook').omCombo({value : data[0].childDeptLook});
		//理财险保单标示
		$('#financePolicyFlag').omCombo({value : data[0].financePolicyFlag});
		//车险平台备案代码
		$('#cheatCode').val(data[0].cheatCode);
		//纳税人资质
		$('#taxpayerQualify').omCombo({value : data[0].taxpayerQualify});
		//开具发票类型
		$('#invoiceType').omCombo({value : data[0].invoiceType});
		//税率
		if(data[0].taxRate != undefined ){
		     $('#taxRate').val((data[0].taxRate)*100+"%");
		}
});

//加载合作机构附件信息

//加载日期控件
$('#validDate').omCalendar({editable : false,disabled : true});
$('#expireDate').omCalendar();
$('#signDate').omCalendar({editable : false,disabled : true});
//初始化联系信息列表按钮菜单
$('#buttonbar').omButtonbar({
   	btns : [{label:"新增",
      		     id:"addButton",
      		     icons : {left : '<%=_path%>/images/add.png'},
      	 		 	onClick:function(){
      	 				//新增联系人信息
       	 			$('#tables').omGrid("insertRow",0,{channelCode:channelCode,getFlag:0});
      	 				$(".gird-edit-btn").width("190px");
     	 			}
     			},
     			{separtor:true},
     	        {label:"删除",
     	        	id:"delButton",
     	        	icons : {left : '<%=_path%>/images/remove.png'},
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
   /********联系信息**********/
   var postOptions = {
			allowDecimals:false,
        	allowNegative:false
		};
   var getFlagOptions = {
   		    dataSource : [{text:"请选择",value:""},{text:"是", value:"1"},{text:"否",value:"0"}],
   		    disabled: trueOrFalse
    	};
   var msgCarOptions = {
   		    dataSource : [{text:"请选择",value:""},{text:"是", value:"1"},{text:"否",value:"0"}],
   		    editable: false
    	};
   var msgCustomerOptions = {
   		    dataSource : [{text:"请选择",value:""},{text:"是", value:"1"},{text:"否",value:"0"}],
   		    editable: false
    	};
	var isSendTrueagtOptions = {
   		    dataSource : [{text:"请选择",value:""},{text:"发送", value:"Y"},{text:"发送并屏蔽代理人",value:"G"},{text:"不发送",value:"N"}],
   		    listAutoWidth : true,
   		    editable: false
    	};
	var isSendCmpnycontactOptions = {
   		    dataSource:[{text:"请选择",value:""},{text:"发送", value:"Y"},{text:"不发送",value:"N"}],
   		    editable: false
    	};
	var agtinfoSourceOptions = {
   		    dataSource:[{text:"请选择",value:""},{text:"从协作人提取", value:"1"},{text:"从代理人提取",value:"0"}],
   		    editable: false
    	};
	//联系信息
	var tabHead = 0 || [{header:"是否同步核心<br/>(仅一条可选'是')",name:"getFlag",width:100,align:'center',editor:{type:"omCombo",name:"getFlag",options:getFlagOptions},renderer:getFlagRenderer},
                  {header:"联系人",name:"contact",width:80,align:'center',editor:{rules:["required",true,"联系人不能为空"],editable:true}},
               	  {header:"职务",name:"title",width:80,align:'center',editor:{editable:true}},
              	  {header:"手机",name:"mobile",width:85,align:'center',editor:{rules:["isMobilePhone"],editable:true}},
              	  {header:"电话号码",name:"tel",width:85,align:'center',editor:{rules:["isTelephone"],editable:true}},
              	  {header:"E-mail",name:"email",width:80,align:'center',editor:{rules:["isEmail"],editable:true}},
              	  {header:"传真",name:"fax",width:80,align:'center',editor:{editable:true}},
              	  {header:"地址",name:"addresss",width:80,align:'center',editor:{editable:true}},
               	  {header:"邮政编码",name:"post",width:80,align:'center',editor:{rules:["maxPostLength"],editable:true,type:"omNumberField",options:postOptions}},
               	  {header:"短信通<br/>知车行",name:"msgCar",width:50,align:'center',editor:{type:"omCombo",name:"msgCar",options:msgCarOptions},renderer:msgCarRenderer},
               	  {header:"发车行推荐<br/>短信给客户",name:"msgCustomer",width:80,align:'center',editor:{type:"omCombo",name:"msgCustomer",options:msgCustomerOptions},renderer:msgCustomerRenderer},
               	  {header:"我司联系<br/>人手机",name:"companyPhone",width:85,align:'center',editor:{rules:["isMobilePhone"],editable:true}},
             	  {header:"短信通知<br/>协作人",name:"isSendTrueagt",width:80,align:'center',editor:{type:"omCombo",name:"isSendTrueagt",options:isSendTrueagtOptions},renderer:isSendTrueagtRenderer},
           	 	  {header:"短信通知<br/>我司联系人",name:"isSendCmpnycontact",width:80,align:'center',editor:{type:"omCombo",name:"isSendCmpnycontact",options:isSendCmpnycontactOptions},renderer:isSendCmpnycontactRenderer},
           	  	  {header:"短信渠道<br/>信息来源",name:"agtinfoSource",width:80,align:'center',editor:{type:"omCombo",name:"agtinfoSource",options:agtinfoSourceOptions},renderer:agtinfoSourceRenderer},
               	  {header:"备注",name:"remark",width:50,editor:{editable:true}}
               	  ];
	/*
	 * 功能：总公司_渠道管理岗_市场开发，总公司_室主任、系统管理员角色   只有这三个角色可见“是否同步到核心”的开关并且操作
	 * 作者：sunyf
	 * 日期：2015-04-20
	 */ 
    var contactRole = 'headDeptAdminChannelNew,xszcAdmin'; 
    $.ajax({url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName="+contactRole, type:"post", async:false, dataType:"JSON", success:function(data){
        if(!data){tabHead.splice(0, 1);} 
    }});
    
	//联系信息
	$('#tables').omGrid({
         limit:0,
         height:200,
 		 singleSelect:true,
         autoFit:false,
         showIndex:false,
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
     
	//初始化页面保存、重置、取消按钮
	$("#button-save").omButton({icons:{left:'<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons:{left:'<%=_path%>/images/remove.png'},width:50});
	
	/************************************************************远程出单点维护***************************************************************/

	var heightNum = 350;
	if($.browser.msie&&($.browser.version == "8.0"||$.browser.version == "9.0"||$.browser.version == "10.0")){
		heightNum = heightNum + 35;
    }
	
	
	/************************************************************协议管理*********************************************************************/
	$("#medium-confer-search-panel").omPanel({
		title : "合作机构协议管理",
		collapsible:true,
		collapsed:false
	});
	
	//协议类型
	$('#conferType').omCombo({
		dataSource : "<%=_path%>/common/queryConferType.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        width : '153px'
    });
	
	$('#conferSignDate').omCalendar();

	//初始化协议按钮菜单
	$('#mediumConferButtonbar').omButtonbar({
	       	btns : [{label:"新增",
	           		     id:"addMediumConferButton",
	           		     icons : {left : '<%=_path%>/images/add.png'},
	           	 		 onClick:function(){
	           	 				var conferJsonData = JSON.stringify($('#mediumConferTables').omGrid('getData'));
	           	 				var jsonRows = eval("["+conferJsonData+"]")[0].rows;
	           	 				var maxExpireDate;
	           	 				if(jsonRows.length > 0){
	           	 					maxExpireDate = jsonRows[0].expireDate;
	           	 				}else{
	           	 					maxExpireDate = validDate;
	           	 				}
		           	 			//机构编码
		           	 			var deptCode = $('#deptCode').val();
		           	 			//机构部门
		           	 			var deptName = $('#deptCname').val();
		           	 			//代理机构代码
		           	 			var channelCode = $('#channelCode').val();
		           	 			//代理机构名称
		           	 			var mediumCname = $('#mediumCname').val();
		           	 			//渠道大类(协议类型与之相关,个人代理协议默认协议类型B)
		           	 			var channelCategory = $('#channelCategory').val();
	       	 			 		window.location.href = "mediumConferAdd.jsp?channelCode="+channelCode+"&mediumCname="+mediumCname+"&deptCode="+deptCode+"&deptName="+
	       	 			 				deptName+"&expireDate="+expireDate+"&maxExpireDate="+maxExpireDate+
	       	 			 				"&channelCategory="+channelCategory;
	       	 			 }
	       			},
	       			{separtor:true},
	       	        {label:"维护",
	       			 	id:"updaMediumConferButton",
	       			 	icons : {left : '<%=_path%>/images/op-edit.png'},
	       	 		 	onClick:function(){
	       	 		 		var rows = $('#mediumConferTables').omGrid("getSelections",true);
	       	 		 		var row = eval(rows);
	       	 		 		if(row.length != 1){
	    	 		 			$.omMessageBox.alert({
	        	 		 	        content:'请选择一条记录编辑',
	        	 		 	        onClose:function(value){
	        	 		 	        	return false;
	        	 		 	        }
	    	 		 	        });
	       	 		 		}else{
	       	 		 			window.location.href = "mediumConferEdit.jsp?conferCode="+row[0].conferCode+"&channelCode="+channelCode+"&expireDate="+expireDate;
	       	 		 		}
	       	 		 	}
	       	        },
	       	        {separtor:true},
           	        {label:"详情",
           			 	id:"queryMediumConferButton",
           			 	icons : {left : '<%=_path%>/images/detail.png'},
           	 		 	onClick:function(){
	           	 		 	var rows = $('#mediumConferTables').omGrid("getSelections",true);
	       	 		 		var row = eval(rows);
		       	 		 	if(row.length != 1){
	    	 		 			$.omMessageBox.alert({
	        	 		 	        content:'请选择一条记录查看',
	        	 		 	        onClose:function(value){
	        	 		 	        	return false;
	        	 		 	        }
	    	 		 	        });
	       	 		 		}else{
	       	 		 			window.location.href = "mediumConferDetail.jsp?conferCode="+row[0].conferCode+"&channelCode="+channelCode;
	       	 		 		}
           	 		 	}
           	        },
	       			{separtor:true},
	       	        {label:"删除",
	       	        	id:"delMediumConferButton",
	       	        	icons : {left : '<%=_path%>/images/remove.png'},
	       	        	onClick:function(){
	       	        		var rows = $('#mediumConferTables').omGrid("getSelections",true);
	       	 		 		var row = eval(rows);
		       	 		 	if(row.length != 1){
	    	 		 			$.omMessageBox.alert({
	        	 		 	        content:'请选择一条记录操作',
	        	 		 	        onClose:function(value){
	        	 		 	        	return false;
	        	 		 	        }
	    	 		 	        });
	       	 		 		}else if(row[0].conferType == 'H'){
			                        $.omMessageBox.alert({
			                          content:'您不能删除互联网服务协议',
			                          onClose:function(value){
			                              return false;
			                          }
			                        });
	       	 		 		}else{	       	 		 			
		       	 		 		$.omMessageBox.confirm({
		       	 		            title:'确认删除',
		       	 		            content:'你确定要删除该协议吗？',
		       	 		            onClose:function(v){
		       	 		                if(v){
					       	 		 		Util.post(
					       	 		 			"<%=_path%>/mediumConfer/deleteMediumConfer.do?conferCode="+row[0].conferCode,
					       	 		 			'',
					       	 		 			function(data) {
					       	 		 				if(data == "success"){
						       	 		 				$.omMessageBox.alert({
						       	        					type:'success',
						       	        	                title:'成功',
						       	    	 		 	        content:'删除协议成功',
						       	    	 		 	        onClose:function(value){
							       	 		 					//刷新列表
							       	 		 					$('#mediumConferTables').omGrid({});
						       	    	 		 	        	return true;
						       	    	 		 	        }
						       		 		 	        });
					       	 		 				}
					       	 		 			}
					       	 		 		);
		       	 		                }
		       	 		            }
		       	 		        });
	       	 		 		  }
	       	 		 		}
	       	        },
          			{separtor:true},
          	        {label:"审核",
          	        	id:"processButton",
          	        	icons : {left : '<%=_path%>/images/user.png'},
          	        	onClick:function(){
          	        		var dels = $('#mediumConferTables').omGrid('getSelections',true);
          	        		var del = eval(dels);
          	        		var conferCodes = "";
          	            	if(del.length == 0 ){
          	            		$.omMessageBox.alert({
            	 		 	        content:'请选择一条记录操作',
            	 		 	        onClose:function(value){
            	 		 	        	return false;
            	 		 	        }
        	 		 	        });
          	            	}else{
              	        		for(var i=0;i<del.length;i++){
              	        			if(del[i].approveFlag == "已审核"){
              	        				$.omMessageBox.alert({
                    	 		 	        content:'请选择未审核的记录操作'
                	 		 	        });
                    	 		 	    return false;
              	        			}
              	        			else if(userDptCde.length>2||userDptCde.length<1){
    	              	        		$.omMessageBox.alert({
              	        					type:'error',
                    	 		 	        content:'仅分公司及总公司所属人员有审核权限!'
                	 		 	        });
                    	 		 	    return false;
    	              	        	}else{
              	        				conferCodes += ","+del[i].conferCode;
              	        			}
              	        		}
              	        		conferCodes = conferCodes.substring(1, conferCodes.length);
          	            		$.omMessageBox.confirm({
          	                       title:'确认审核通过',
          	                       content:'你确定要审核该记录吗？',
          	                       onClose:function(v){
          	                           if(v){
          	                        	 	Util.post(
 					       	 		 			"<%=_path%>/mediumConfer/processConfers.do?conferCodes="+conferCodes+"&channelCode="+channelCode,
 					       	 		 			'',
 					       	 		 			function(data) {
 					       	 		 				if(data.flag == "1"){
 						       	 		 				$.omMessageBox.alert({
 						       	        					type:'success',
 						       	        	                title:'成功',
 						       	    	 		 	        content:'审核合作机构协议成功',
 						       	    	 		 	        onClose:function(value){
 							       	 		 					//刷新列表
 							       	 		 					$('#mediumConferTables').omGrid({});
 						       	    	 		 	        	return true;
 						       	    	 		 	        }
 						       		 		 	        });
 					       	 		 				} else {
     					       	 		 				$.omMessageBox.alert({
 						       	        					type:'error',
 						       	        	                title:'失败',
 						       	    	 		 	        content:'审核合作机构协议失败<br/>'+data.msg,
 						       	    	 		 	        onClose:function(value){
 							       	 		 					//刷新列表
 							       	 		 					$('#tables').omGrid({});
 						       	    	 		 	        	return true;
 						       	    	 		 	        }
 						       		 		 	        });
 					       	 		 				}
 					       	 		 			}
 					       	 		 		);
          	                           }
          	                       }
          	                    });
          	            	}
          	        	}
          	        },
        			{separtor:true},
        	        {label:"历史轨迹",
        			 	id:"historyButton",
        			 	icons : {left : '<%=_path%>/images/trace.png'},
        	 		 	onClick:function(){
        	 		 		var rows = $('#mediumConferTables').omGrid("getSelections",true);
        	 		 		var row = eval(rows);
        	 		 		if(row.length != 1){
        	 		 			$.omMessageBox.alert({
            	 		 	        content:'请选择一条记录',
            	 		 	        onClose:function(value){
            	 		 	        	return false;
            	 		 	        }
        	 		 	        });
	       	 		 		}else{
        	 		 			window.location.href = "mediumConferHistorys.jsp?conferId="+row[0].conferId+"&conferCode="+row[0].conferCode+"&channelCode="+channelCode;;
        	 		 		}
        	 		 	}
        	        }
	       	]
	});

	//初始化列表
	$("#mediumConferTables").omGrid({
		showIndex: true,
		singleSelect: true,
	    height: heightNum,
	    limit: 10,
	    method: 'POST',
        autoFit: true,
	    colModel: [ {header:"协议号",name:"conferId",width:120},
	    			{header:"协议补充号",name:"extendConferCode",width:80},
	         		{header:"经办部门编码",name:"deptCode",width:80},
	        		{header:"经办部门",name:"deptCname",width:150},
	        		{header:"代理机构编码",name:"channelCode",width:100},
	        		{header:"代理机构名称",name:"mediumCname",width:150},
	        		{header:"审核状态",name:"approveFlag",width:80},
	        		/* {header:"审核人",name:"approveCode",width:80}, */
	        		{header:"协议分类",name:"conferTypeName",width:80},
	        		{header:"签定日期", name:"signDate",width:100},
	        	 	{header:"生效日期", name:"validDate",width:100},
	        	 	{header:"截止日期", name:"expireDate",width:100},
	        	 	{header:"结费周期（天）",name:"calclatePeriod",width:90}],
		dataSource: "<%=_path%>/mediumConfer/queryMediumConfer.do?"+$("#mediumContectFrm").serialize()
	});
	
	$("#medium-confer-button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	//查询协议列表操作
	queryMediumConfer();
	
	hideButton();
	
	initValidate();
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
    //
    /* $.validator.addMethod("isPhone", function(value) {
    	var regu =/(((?:13\d|15[89])-?\d{5}(\d{3}|\*{3}))|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)/;
        var reg = new RegExp(regu);
        return reg.test(value);
    }, '不是有效的电话号码'); */
    
    $.validator.addMethod("isPhone", function(value) {
        var regu =/(^[1][3578][0-9]{9}$)|(^((\d{3,4})-)?(\d{6,8})(-(\d{3,}))?$)/; 
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
    
    $.validator.addMethod("cAgentorgCdeRequired", function(value) {
    	var deptCode = $("#deptCode").val().substr(0,2);
    	if(deptCode == '08'){
        	return value != '';
    	}else{
	        return /^.*$/.test(value);
    	}
 	}, '组织机构代码不合法');
    
    $.validator.addMethod("isMustChooseChannelType",function(value){
    	var channelCategory = $("#channelCategory").omCombo("value");
    	var channelType = $("#channelType").omCombo("value");
    	if(channelCategory=="19002"&&channelType==""){
    		return false;
    	}
    	return true;
    },"渠道大类选择“代理业务”后，“渠道类型”为必选项");
    
    $.validator.addMethod("isMustChooseChannelProperty",function(value){
    	var channelType = $("#channelType").omCombo("value");
    	var channelProperty = $("#channelProperty").omCombo("value");
    	if(channelType=="1900202"&&channelProperty==""){
    		return false;
    	}
    	return true;
    },"渠道大类为“代理业务”且渠道类型为“兼业代理”时，“渠道性质”为必选项");
    
    $.validator.addMethod("taxpayerIdNum",function(value){
    	var reg = /^[0-9a-zA-Z]{15,20}$/;
    	return reg.test(value);
    },"纳税人识别号只能由字母、数字组合");

    /*
     * 功能：关停按钮权限
     * 说明：总公司角色操作不受限制；分公司角色中，仅如下角色可见；分公司_渠道管理岗_市场开发 subDeptManager
     */
    var closeRoleArray = new Array('subDeptManager','headDepatFinanceSafe','headDepatChennelCh','headDeptChannel','haedDeptSalesman','headDeptDirector'); 
    //删除按钮，总公司可见删除可操作，分公司不可见删除按钮；
    $.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=headDeptAdminChannelNew,headDeptMediumChanelNew,xszcAdmin",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			if(data === "false"){
				$("#delMediumConferButton").remove();
				$(".om-buttonbar-sep:last").remove();
			}
		}
	});
    
    
    //浙江IC卡刷卡失败提示
    $("#dialog-error").omDialog({
        autoOpen : false, 
        resizable: false,
        width: 500,
        modal : true,
        buttons: [
                  {text : "重新读卡", 
		           click : function(){
		        	   processIC();
		           }},
		          {text : "取消读卡", 
		           click : function(){
		        	   $("#dialog-error").omDialog("close");
		           }}
       			]
    });
	
	//浙江IC卡特殊处理
	Util.post("<%=_path%>/department/getDeptCodeByUser.do",'',
 			function(data) {
				userDptCde = data;
				if(userDptCde.substring(0,2) == '09'){
					//setTimeout('processIC();',500);//浙江IC卡读取及处理,机构已经废除此功能
				}
 			}
 		);

	/*
  	 * 功能：系统管理员可以修改（机构不能修改）:渠道大类/渠道类型/是否协作人/协议代理人/业务线
  	 * 作者：sunyf
  	 * 日期：2014-04-15
  	 */
	$.ajax({ 
		url:"<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=xszcAdmin,headDeptAdminChannelNew",
		type:"post",
		async:true, 
		dataType:"JSON",
		success:function(data){
		  if (data) {
		     $("#channelCategory").omCombo({readOnly:false}).next(".sele").css({"background-color":"#FFFFFF"});
		     $("#channelType").omCombo({readOnly:false}).next(".sele").css({"background-color":"#FFFFFF"});
		     //$("#supportFlag").omCombo({readOnly:false}).next(".sele").css({"background-color":"#FFFFFF"});
		     $("#agentCode").removeAttr("readonly").css({"background-color":"#FFFFFF"});
		     $("#businessLine").omCombo({readOnly:false}).next(".sele").css({"background-color":"#FFFFFF"});
		  }
		}
	});    
    
}); //end onload();

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

/**
 * 文件上传下载通用方法（异步获取数据）
 */
function getImg1 (domId,data){
	if(data != '' && data != undefined){
		$(domId).haImg({
			title : data.name,
			modelCode : 'XSZC010101',
			mainBillNo : data.mainId,
			seriesNo : data.uploadId,
			srcUrl : '${sessionScope.imgUrl}',
			operateEmp : data.updatedUser,
			operateCode : 'none'
	    });
	}else{
		$(domId).haImg({
			title : '合作机构证件',
			modelCode : 'XSZC010101',
			mainBillNo : "",
			seriesNo : '未生成',
			srcUrl : '${sessionScope.imgUrl}',
			//operateEmp : operateEmp,
			operateCode : 'none'
		});
	}
}
 
function getImg (domId,data){
	if(data != '' && data != undefined){
		currentUploadId = data.uploadId;
		$(domId).haImg({
			title : data.name,
			modelCode : 'XSZC010101',
			mainBillNo : data.mainId,
			seriesNo : data.uploadId,
			srcUrl : '${sessionScope.imgUrl}',
			operateEmp : data.updatedUser
	    });
	}else{
		currentUploadId = uploadId;
		$(domId).haImg({
			title : '合作机构证件',
			modelCode : 'XSZC010101',
			mainBillNo : "",
			seriesNo : uploadId,
			srcUrl : '${sessionScope.imgUrl}',
			operateEmp : operateEmp
		});
	}
}

//定义校验规则,此规则页面加载的时执行
var mediumConferRule = {
	supportFlagformMap:{
		required : true
	},
	childDeptLookformMap:{
		required : true
	},
	channelCodeformMap:{
		required : true,
		isLetterAndInteger : true,
		maxlength : 50
	},
	mediumCnameformMap:{
		required : true,
		maxlength : 50
	},
	deptCnameformMap:{
		deptCnameRequired : true
	},
	licenceformMap:{
		required : true,
		maxlength : 25
	},
	officeAddressformMap:{
		required : true,
		maxlength : 100
	},
	processDeptCodeformMap:{
		required : true
	},
	processUserCodeformMap:{
		processUserCodeRequired : true
	},
	parterLevelformMap:{
		required : true
	},
	/* financeFlagformMap:{
		required : true
	}, */
	channelCategoryformMap:{
		required : true
	},
	/*channelTypeformMap:{
		isMustChooseChannelType:true
	},*/
	channelFeatureformMap:{
		required : true
	},
	bankAccountformMap:{
		required : true,
		bankAccountCheck:true,
		maxlength : 30
	},
	bankNameformMap:{
		required : true,
		maxlength : 50
	},
	bankProvinceformMap:{
		required : true
	},
	bankCityformMap:{
		required : true
	},
	bankReceiveformMap:{
		required : true
	},
	bankNodeformMap:{
		required : true
	},
	businessLineformMap:{
		required : true
	},
	validDateformMap:{
		required : true,
		isDate : true
	},
	expireDateformMap:{
		required : true,
		gtValidDate : true,
		isDate : true
	},
	signDateformMap:{
		required : true,
		isDate : true
	},
	channelPropertyformMap:{
		isMustChooseChannelProperty:true
	},
	contactformMap:{
		required : true,
		maxlength : 25
	},
	telformMap:{
		required : true,
		isPhone : true
	},
	parentMediumCodeformMap:{
		maxlength : 50
	},
	mediumEnameformMap:{
		maxlength : 200
	},
	salePolicyNameformMap:{
		maxlength : 50
	},
	salePolicyAddressformMap:{
		maxlength : 100
	},
	innerCodeformMap:{
		maxlength : 50
	},
	channelOuterCodeformMap:{
		maxlength : 50
	},
	channelExtendCodeformMap:{
		maxlength : 50
	},
	parentChannelCodeformMap:{
		parentChannelCodeRequired : true
	},
	channelRateformMap:{
		//required : true,
		number:true
	},
	legalformMap:{
		maxlength : 25
	},
	registerAddressformMap:{
		maxlength : 50
	},
	websiteformMap:{
		maxlength : 100
	},
	areaCodeformMap:{
		maxlength : 30
	},
	cityCodeformMap:{
		maxlength : 30
	},
	mistakeFlagformMap:{
		required : true
	},
	cAgentorgCdeformMap:{
		cAgentorgCdeRequired : true
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
	}
};

//定义校验的显示信息
var mediumConferMessages = {
	supportFlagformMap:{
		required : '是否协作人必选'
	},
	childDeptLookformMap:{
		required : '下级单位可以查看必选'
	},
	channelCodeformMap:{
		required : '合作机构编码不能为空',
		isLetterAndInteger : '合作机构编码必须是数字和字母',
		maxlength : '合作机构编码最长50位'
	},
	mediumCnameformMap:{
		required : '合作机构名称不能为空',
		maxlength : '合作机构名称最长50位'
	},
	deptCodeformMap:{
		required : '机构部门必选'
	},
	licenceformMap:{
		required : '经营许可证不能为空',
		maxlength : '经营许可证最长25位'
	},
	officeAddressformMap:{
		required : '办公地址不能为空',
		maxlength : '办公地址最长100位'
	},
	processDeptCodeformMap:{
		required : '经办部门编码必选'
	},
	/* processUserCodeformMap:{
		required : '经办人必选'
	}, */
	parterLevelformMap:{
		required : '合作层级必选'
	},
	/* financeFlagformMap:{
		required : '是否理财险渠道必选'
	}, */
	channelCategoryformMap:{
		required : '渠道大类必选'
	},
	channelFeatureformMap:{
		required : '渠道特征必选'
	},
	bankAccountformMap:{
		required : '银行帐号不能为空',
		maxlength : '银行帐号最长30位'
	},
	bankNameformMap:{
		required : '账户名称不能为空',
		maxlength : '账户名称最长50位'
	},
	bankProvinceformMap:{
		required : '开户行所在省必选'
	},
	bankCityformMap:{
		required : '开户行所在市必选'
	},
	bankReceiveformMap:{
		required : '收款方银行必选'
	},
	bankNodeformMap:{
		required : '开户行网点必选'
	},
	businessLineformMap:{
		required : '业务线必选'
	},
	validDateformMap:{
		required : '许可证颁发时间不能为空'
	},
	expireDateformMap:{
		required : '许可证有效时间至不能为空'
	},
	signDateformMap:{
		required : '与合作机构签约时间不能为空'
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
		required : '联系人不能为空',
		maxlength : '联系人最长25位'
	},
	telformMap:{
		required : '联系电话不能为空'
	},
	parentMediumCodeformMap:{
		maxlength : "上级合作机构编码最长50位"
	},
	mediumEnameformMap:{
		maxlength : "合作机构英文名称最长200位"
	},
	salePolicyNameformMap:{
		maxlength : "出单点名称最长50位"
	},
	salePolicyAddressformMap:{
		maxlength : "出单点地址最长100位"
	},
	innerCodeformMap:{
		maxlength : "内部编码最长50位"
	},
	channelOuterCodeformMap:{
		maxlength : "渠道外编码最长50位"
	},
	channelExtendCodeformMap:{
		maxlength : "渠道编码最长50位"
	},
	/* parentChannelCodeformMap:{
		required : '上级渠道必选'
	}, */
	channelRateformMap:{
		//required : '渠道系数不能为空',
		number : '渠道系数必须是数字'
	},
	legalformMap:{
		maxlength : "法人代表最长25位"
	},
	registerAddressformMap:{
		maxlength : "注册地址最长50位"
	},
	websiteformMap:{
		maxlength : "网站地址最长100位"
	},
	areaCodeformMap:{
		maxlength : "地区代码最长30位"
	},
	cityCodeformMap:{
		maxlength : "省市代码最长30位"
	},
	mistakeFlagformMap:{
		required : '是否有不良记录必选'
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
        	//联系人信息
        	var jsonData = JSON.stringify($('#tables').omGrid('getData'));
        	$('#mediumContectJsonStr').val(jsonData);

        	//附件
        	$('#uploadId').val(uploadId);
        	//经办部门编码处理
        	//var processDeptCode = $("#processDeptCode").val();
			//$("#processDeptCode").val(processDeptCode.split('-')[0]);
			$.omMessageBox.waiting({
                title:'请等待',
                content:'服务器正在处理请求...'
            });
    	    //保存提交
			var i_type = $("#invoiceType").val();
        	var i_t;
        	if(i_type == "专票"){
        		i_t = 2;
        	}
        	Util.post("<%=_path%>/medium/updateMedium.do?invoiceType="+i_t,$("#baseInfo").serialize(), function(data) {
      	        var msgContent = '保存成功';
     		      if (jbDeptCode1 != '' && jbDeptCode2 != '' && jbDeptCode1 != jbDeptCode2) {
     		    	  msgContent += '，您修改了渠道的经办部门，如果该渠道有协议，请到协议维护页面审核协议!';
                }
          	    $.omMessageBox.waiting('close');
       			if(data == "success"){
       				$.omMessageBox.alert({
       					type:'success',
       	                title:'提示',
   	 		 	        content:msgContent,
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

function selPerson(){
	//$("#user-dialog-model").omDialog('open');
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
	<%-- var frameLoc;
    if(navigator.appName.indexOf("Microsoft Internet Explorer")!=-1 && document.all){
    	frameLoc = window.frames[1].location;
    }else{
    	frameLoc = window.frames[0].location;
    }
    if (frameLoc.href == 'about:blank') {
       frameLoc.href = '<%=_path%>/view/demo/selectUserIframe.jsp';
    } --%>
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
    if(navigator.appName.indexOf("Microsoft Internet Explorer")!=-1 && document.all){
    	frameLoc = window.frames[2].location;
    }else{
    	frameLoc = window.frames[1].location;
    }
    if (frameLoc.href == 'about:blank') {
       frameLoc.href = '<%=_path%>/view/demo/selectParentMediumIframe.jsp';
    } --%>
}

//填充数据（选择经办人）
function fillBackAndCloseDialog(rowData) {
	  $("#processUserCode").val(rowData.salesmanCname);
	  $("#user-dialog-model").omDialog('close');
	  $("#processUserCode").focus();
};

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
	  $('#parterLevel').omCombo({value : rowData.parterLevel});
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
		 	        content:'有且只有一条数据可以同步到核心，请请重新编辑<联系信息表>第一列',
		 	        onClose:function(value){
		 	        	return false;
		 	        }
	 	        });
			return false;
		}
	}
	
	$("#baseInfo").submit();
}

//取消操作
function cancel(){
	window.location.href = "medium.jsp?channelCode="+channelCode;
}

 //查询远程出单点列表操作
function queryMediumNode(){
	$("#mediumNodeTables").omGrid("setData","<%=_path%>/mediumNode/queryMediumNode.do?"+$("#mediumNodeFilterFrm").serialize());
} 

//查询合作机构协议列表操作
function queryMediumConfer(){
	$("#mediumConferTables").omGrid("setData","<%=_path%>/mediumConfer/queryMediumConfer.do?"+$("#mediumConferFilterFrm").serialize());
}

function hideButton(){
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=thirdDeptMediumManage",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			//加载合作机构附件信息
				Util.post("<%=_path%>/upload/queryUploadByMainId.do?mainId="+channelCode+"&module=01",
						"",
						function(data) {
					  if(data == '' || data == null){
						  var sysUrl = "http://ecmp.sinosafe.com.cn:8080/Interface_Cluster/FileUpLoadAction?SystemCode=XSZC01&FunctionCode=XSZC0101&OrgCode=01010000&UserCode=100052692&BatchFlg=0&AuthorizCode=1111&BusinessCode=" + uploadId;
						  $('#imgSys').attr("href",sysUrl);
					  }else{
							  var sysUrl = "http://ecmp.sinosafe.com.cn:8080/Interface_Cluster/FileUpLoadAction?SystemCode=XSZC01&FunctionCode=XSZC0101&OrgCode=01010000&UserCode=100052692&BatchFlg=0&AuthorizCode=1111&BusinessCode=" + data[0].uploadId;
							  $('#imgSys').attr("href",sysUrl);
					  }
				 }
				);
			if(data === "true"){
				$("#addMediumConferButton").remove();
				$(".om-buttonbar-sep:last").remove();
				$("#updaMediumConferButton").remove();
				$(".om-buttonbar-sep:last").remove();
				$("#delMediumConferButton").remove();
				$(".om-buttonbar-sep:last").remove();
				$("#processButton").remove();
				$(".om-buttonbar-sep:last").remove();
				$("#historyButton").remove();
				$(".om-buttonbar-sep:last").remove();
				$("#button-save").remove();
				$(".om-buttonbar-sep:last").remove();
				$("#addButton").remove();
				$(".om-buttonbar-sep:last").remove();
				$("#delButton").remove();
				$(".om-buttonbar-sep:last").remove();
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
	<!-- 
	<div id="processDeptDropList" class="processDeptDropList">
		<ul id="processDeptDropListTree" class="processDeptDropListTree"></ul>
	</div>
	-->
	<div id="user-dialog-model" title="选择经办人">
		<iframe id="personIframe" frameborder="0" style="width:100%; height:99%; height:100%;" src="about:blank"></iframe>
	</div>
	<div id="medium-dialog-model" title="选择上级渠道">
		<iframe id="mediumIframe" frameborder="0" style="width:100%; height:99%; height:100%; src="about:blank"></iframe>
	</div>
	<div id="make-tab" >
        <ul>
            <li><a href="#medium" id="tab1">合作机构管理</a></li>
            <!-- <li><a href="#mediumNode">远程出单点维护</a></li> -->
            <li><a href="#mediumConfer" id="tab2">合作机构协议管理</a></li>
        </ul>
        <!------------------------------------------------------------- 合作机构管理  -------------------------------------------------------------->
        <div id="medium">
			<div>
				<table class="navi-tab">
					<tr><td>合作机构维护</td></tr>
				</table>
			</div>
			<div>
					<form id="baseInfo">
					<fieldSet>
					<legend>基本信息</legend>
						<table>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">合作机构名称：</span></td>
								<td><input name="formMap['mediumCname']" id="mediumCname" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">合作机构英文名称：</span></td>
								<td><input type="text" name="formMap['mediumEname']" id="mediumEname" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">合作机构编码：</span></td>
								<td><input type="text" name="formMap['channelCode']" id="channelCode" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">业务线：</span></td>
								<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" readonly="readonly"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
								<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['deptCname']" id="deptCname" /><span id="choose" name="choose" class="om-combo-trigger"></span></span><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span>
								<input type="hidden" name="formMap['deptCode']" id="deptCode" /></td>
								<td style="padding-left:30px" align="right"><span class="label">经办人：</span></td>
								<td><input name="formMap['processUserCode']" id="processUserCode"  onclick="selPerson();" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<!-- <td style="padding-left:30px" align="right"><span class="label">机构部门编码：</span></td>
								<td><input name="formMap['deptCode']" id="deptCode" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td> -->
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">渠道大类：</span></td>
								<td><input class="sele" name="formMap['channelCategory']" id="channelCategory" readonly="readonly"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">渠道类型：</span></td>
								<td><input class="sele" name="formMap['channelType']" id="channelType" readonly="readonly"/><span id="channelTypeStart" style="display: none;" class="asterisk">*</span></td>
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
								<td><input name="formMap['parentChannelCode']" id="parentChannelCode" readonly="readonly" onclick="selParentMedium();" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">合作层级：</span></td>
								<td><input class="sele" name="formMap['parterLevel']" id="parterLevel" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">经营许可证：</span></td>
								<td><input name="formMap['licence']" id="licence" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">办公地址：</span></td>
								<td><input name="formMap['officeAddress']" id="officeAddress" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">注册地址：</span></td>
								<td><input name="formMap['registerAddress']" id="registerAddress" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<!-- <td style="padding-left:30px" align="right"><span class="label">经办部门编码：</span></td>
								<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['processDeptCode']" id="processDeptCode" readonly="readonly" /><span id="processDeptChoose" name="processDeptChoose" class="om-combo-trigger"></span></span><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td> -->
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">许可证颁发时间：</span></td>
								<td><input class="sele" name="formMap['validDate']" id="validDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">许可证有效时间至：</span></td>
								<td><input class="sele" name="formMap['expireDate']" id="expireDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">与合作机构签约时间：</span></td>
								<td><input class="sele" type="text" name="formMap['signDate']" id="signDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">是否协作人：</span></td>
								<td><input class="sele" name="formMap['supportFlag']" id="supportFlag" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">协议代理人：</span></td>
								<td><input name="formMap['agentCode']" id="agentCode" readonly="readonly" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">下级单位可以查看：</span></td>
								<td><input class="sele" type="text" name="formMap['childDeptLook']" id="childDeptLook" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">是否有不良记录：</span></td>
								<td><input class="sele" name="formMap['mistakeFlag']" id="mistakeFlag" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">不良记录：</span></td>
								<td><input type="text" name="formMap['mistakeContent']" id="mistakeContent" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">渠道系数：</span></td>
								<td><input name="formMap['channelRate']" id="channelRate" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<!-- <td style="padding-left:30px" align="right"><span class="label">出单点名称：</span></td>
								<td><input name="formMap['salePolicyName']" id="salePolicyName" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">出单点地址：</span></td>
								<td><input name="formMap['salePolicyAddress']" id="salePolicyAddress" /></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td> -->
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
								<td><input class="sele" name="formMap['channelFeature']" id="channelFeature" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">车险平台备案代码：</span></td>
								<td><input name="formMap['cheatCode']" id="cheatCode" /></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">备注：</span></td>
								<td colspan="5"><textarea style="height:50px;width:97%;" name="formMap['remark']" id="remark"></textarea>
								<!--所有联系人信息封装json字符串 --> 
								<input type="hidden" name="mediumContectJsonStr" id="mediumContectJsonStr" />
								<!--附件id字符串 --> 
								<input type="hidden" name="uploadId" id="uploadId" /></td>
							</tr>
						</table>
				    </fieldSet>
				    <fieldSet>
					<legend>账户信息</legend>
					<table>
					    <tr>
							<td style="padding-left:80px" align="right"><span class="label">银行帐号：</span></td>
							<td><input type="text" name="formMap['bankAccount']" id="bankAccount" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:80px" align="right"><span class="label">账户名称：</span></td>
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
							<td><input class="sele" name="formMap['taxRate']" id="taxRate"  readonly="readonly"/><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
			            </table>
			         </fieldSet> -->
					</form>
			</div>
			<!-- 联系人列表 -->
			<div>
				<fieldSet>
					<legend>联系信息</legend>
					<div id="buttonbar" style="border-style:none none solid none;"></div>
					<table id="tables"></table>
					<form id="mediumContectFrm">
						<input type="hidden" name="formMap['channelCode']" id="mediumCode_fk" value="" />
					</form>
				</fieldSet>
			</div>
			<!-- 附件上传框 -->
<!-- 			<div id="program-upload-download"></div> -->
			<!-- 新影像系统bgn -->
		  <div>
		    <fieldSet>
		      <legend>影像资料</legend>
		      <div style="margin-left: 20px;margin-bottom: 10px;">
		        <a href='#' id="imgSys"  target="_blank">合作机构证件</a>
		      </div>
		    </fieldSet>
		  </div>
		  <!-- 新影像系统end -->
			<!-- 保存/取消按钮 -->
			<div>
				<table style="width:100%; margin-top:20px;">
					<tr>
						<td align="center">
						<a id="button-save" onclick="save()">保存</a>
						<a id="button-cancel" onclick="cancel()">取消</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<!------------------------------------------------------------- 远程出单点维护  -------------------------------------------------------------->
		
	    <!------------------------------------------------------------- 合作机构协议管理  -------------------------------------------------------------->
		<div id="mediumConfer">
			<form id="mediumConferFilterFrm">
				<div id="medium-confer-search-panel">
					<table>
						<tr>
							<td style="padding-left:15px" align="right"><span class="label">协议号：</span></td>
							<td><input type="text" name="formMap['conferId']" id="conferId" /></td>
							<td style="padding-left:15px" align="right"><span class="label">协议类型：</span></td>
							<td><input class="sele" type="text" name="formMap['conferType']" id="conferType" /></td>
							<td style="padding-left:15px" align="right"><span class="label">签订日期：</span></td>
							<td><input class="sele" type="text" name="formMap['signDate']" id="conferSignDate" /></td>
							<td colspan="2" style="padding-left:15px;padding-top:5px;" align="right"><span id="medium-confer-button-search" onclick="queryMediumConfer()">查询</span><input type="hidden" name="formMap['channelCode']" id="mediumCode_fk_confer" value="" /></td>
						</tr>
					</table>
				</div>
			</form>
			<div id="mediumConferButtonbar"></div>
			<div id="mediumConferTables"></div>
		</div>
	</div>
	<div id="dialog-error" title="读卡失败" style="padding:30px; display: none;">
        <div style="padding-left:70px;height:auto!important; height:50px; min-height:50px;">
            <h4 style="font-size:14px; padding-top: 12px; margin: 0px;">读卡失败,请检查是否正确连接IC卡读卡器！</h4>
        </div>
    </div>
</body>
</html>