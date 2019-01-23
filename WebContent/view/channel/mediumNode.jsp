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
boolean trueOrFalse = Boolean.parseBoolean(request.getParameter("trueOrFalse"));
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
	$("#deptCode").css({"background-color":"#fff"});
	
	//给该隐藏域赋值，为查询合作机构和相关联系人提供数据（外键）
	$('#mediumCode_fk').val(channelCode);
	//给该隐藏域赋值，为查询相关网点提供数据（外键）
	$('#mediumCode_fk_node').val(channelCode);
	//给该隐藏域赋值，为查询相关协议提供数据（外键）
	$('#mediumCode_fk_confer').val(channelCode);

	/******初始化tab标签页*********/
	$('#make-tab').omTabs({
	    closable : false,
	    active : tabFlag,
	    switchMode : 'mouseover'
    });
	//是否协作人
	$('#supportFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        editable : false,
        emptyText : '请选择',
        onValueChange:function(target,newValue,oldValue,event){
            if(newValue == 1){
            	$('#agentCode').rules('add',{
            		required : true,
           	      	messages: {
           	      		required : jQuery.format("代理人不能为空")
           	      	}
            	});
            }else{
            	$("#agentCode").rules("remove", "required"); //remove可以配置多个rule，空格隔开
            }
        	$("#agentCode").focus();
        },
        readOnly : true
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
	                 /* onSuccess:function(data, textStatus, event){
	                	 $('#bankCity').omCombo({value:data[0].value});
	                 } */
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
		dataSource : "<%=_path%>/medium/getMediumQueryBusinessline.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false
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
	//经办机构
    //树形机构，异步加载
    $("#deptDropListTree").omTree({
        dataSource : "<%=_path%>/department/queryDeptDropList.do",
	    simpleDataModel:true,
	    //
	    onBeforeExpand : function(node){
		  var nodeDom = $("#"+node.nid);
		  $("#deptCode").val(node.id + "-" + node.text);
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
         
         $("#deptCode").val(departCode+"-"+text);
         
         //
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
	
   //点击下拉按钮
   $("#choose").click(function() {
      showDropList();
   });
   //点击输入框
   $("#deptCode").click(function() {
      showDropList();
   });
   //定位显示
   function showDropList() {      
	  var cityInput = $("#deptCode");
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


	/************************************************************远程出单点维护***************************************************************/
	$("#search-panel").omPanel({
		title:"销售渠道管理 > 远程出单点维护",
		collapsible:true,
		collapsed:false
	});

	//初始化按钮菜单
	$('#mediumNodeButtonbar').omButtonbar({
	       	btns : [{label:"新增",
	           		     id:"addMediumNodeButton",
	           		     icons : {left : '<%=_path%>/images/add.png'},
	           	 		 onClick:function(){
	           	 			var rows = $('#mediumNodeTables').omGrid("getSelections",true);
	       	 		 		var row = eval(rows);
		       	 		 	window.location.href = "mediumNodeAddNew.jsp";
	       	 			 }
	       			},
	       			{separtor:true},
	       	        {label:"维护",
	       			 	id:"updaMediumNodeButton",
	       			 	icons : {left : '<%=_path%>/images/op-edit.png'},
	       	 		 	onClick:function(){
	       	 		 		var rows = $('#mediumNodeTables').omGrid("getSelections",true);
	       	 		 		var row = eval(rows);
		       	 		 	if(row.length != 1){
	    	 		 			$.omMessageBox.alert({
	        	 		 	        content:'请选择一条记录编辑',
	        	 		 	        onClose:function(value){
	        	 		 	        	return false;
	        	 		 	        }
	    	 		 	        });
	       	 		 		}else{
	       	 		 			if(row[0].closeFlag=='1'){
		       	 		 			$.omMessageBox.alert({
		        	 		 	        content:'已关停出单点不能修改',
		        	 		 	        onClose:function(value){
		        	 		 	        	return false;
		        	 		 	        }
		    	 		 	        });
		       	 		 		   return;
	       	 		 			}else{
	       	 		 			   window.location.href = "mediumNodeEdit.jsp?nodeCode="+row[0].nodeCode+"&channelCode="+channelCode+"&deptCode="+row[0].deptCode;
	       	 		 			}		
		       	 		 	}
		       	 		}
	       	        },
	       	        {separtor:true},
           	        {label:"详情",
           			 	id:"queryMediumNodeButton",
           			 	icons : {left : '<%=_path%>/images/detail.png'},
           	 		 	onClick:function(){
	           	 		 	var rows = $('#mediumNodeTables').omGrid("getSelections",true);
	       	 		 		var row = eval(rows);
		       	 		 	if(row.length != 1){
	    	 		 			$.omMessageBox.alert({
	        	 		 	        content:'请选择一条记录查看',
	        	 		 	        onClose:function(value){
	        	 		 	        	return false;
	        	 		 	        }
	    	 		 	        });
	       	 		 		}else{
		       	 		 			window.location.href = "mediumNodeDetail.jsp?nodeCode="+row[0].nodeCode+"&channelCode="+channelCode;
		       	 		 		}
		       	 		 	}
           	        },
	       			{separtor:true},
	       	        {label:"关停",
	       	        	id:"stopMediumNodeButton",
	       	        	icons : {left : '<%=_path%>/images/remove.png'},
	       	        	onClick:function(){
	       	        		var rows = $('#mediumNodeTables').omGrid("getSelections",true);
	       	 		 		var row = eval(rows);
		       	 		 	if(row.length != 1){
	    	 		 			$.omMessageBox.alert({
	        	 		 	        content:'请选择一条记录操作',
	        	 		 	        onClose:function(value){
	        	 		 	        	return false;
	        	 		 	        }
	    	 		 	        });
	       	 		 		} else {
		       	 		 		//alert(rows[0].closeFlag);
	    	       	 		 	if(rows[0].closeFlag == 1){
		    	 		 			$.omMessageBox.alert({
		        	 		 	        content:'该远程出单点已经关停！',
		        	 		 	        onClose:function(value){
		        	 		 	        	return false;
		        	 		 	        }
		    	 		 	        });
		       	 		 		} else {
			       	 		 		//
			       	 		 		$.omMessageBox.confirm({
			       	 		            title:'确认关停',
			       	 		            content:'你确定要关停该远程出单点吗？',
			       	 		            onClose:function(v){
			       	 		                if(v){
						       	 		 		Util.post("<%=_path%>/mediumNode/closeMediumNode.do?nodeCode="+row[0].nodeCode+"&channelCode="+row[0].channelCode,'',function(data) {
						       	 		 				if(data == "success"){
							       	 		 				$.omMessageBox.alert({
							       	        					type:'success',
							       	        	                title:'成功',
							       	    	 		 	        content:'关停远程出单点成功',
							       	    	 		 	        onClose:function(value){
								       	 		 					//刷新列表
								       	 		 					$('#mediumNodeTables').omGrid({});
							       	    	 		 	        	return true;
							       	    	 		 	        }
							       		 		 	        });
						       	 		 				}
						       	 		 			}
						       	 		 		);
			       	 		                }
			       	 		            }
			       	 		        }); // end confirm
				       	 	  } // end else
	       	 		 		}
	       	        	}
	       	        },
	       	        {separtor:true},
	       			{label:"删除",
	       	        	id:"delMediumNodeButton",
	       	        	icons : {left : '<%=_path%>/images/remove.png'},
	       	        	onClick:function(){
	       	        		var rows = $('#mediumNodeTables').omGrid("getSelections",true);
	       	 		 		var row = eval(rows);
		       	 		 	if(row.length != 1){
	    	 		 			$.omMessageBox.alert({
	        	 		 	        content:'请选择一条记录操作',
	        	 		 	        onClose:function(value){
	        	 		 	        	return false;
	        	 		 	        }
	    	 		 	        });
	       	 		 		}else{
		       	 		 		$.omMessageBox.confirm({
		       	 		            title:'确认删除',
		       	 		            content:'你确定要删除该远程出单点吗？',
		       	 		            onClose:function(v){
		       	 		                if(v){
					       	 		 		Util.post("<%=_path%>/mediumNode/deleteMediumNode.do?nodeCode="+row[0].nodeCode+"&channelCode="+row[0].channelCode,'',function(data) {
					       	 		 				if(data == "success"){
						       	 		 				$.omMessageBox.alert({
						       	        					type:'success',
						       	        	                title:'成功',
						       	    	 		 	        content:'删除远程出单点成功',
						       	    	 		 	        onClose:function(value){
							       	 		 					//刷新列表
							       	 		 					$('#mediumNodeTables').omGrid({});
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
	       	        }
	       	]
	});
	
	//列表高度
	var bdnum = $("body").offset().top + $("body").outerHeight();
	var btnum = $("#mediumNodeButtonbar").offset().top + $("#mediumNodeButtonbar").outerHeight();
	//--远程出单点维护列表--初始化列表
	$("#mediumNodeTables").omGrid({
		showIndex: true,
		singleSelect: true,
	    height: bdnum - btnum,
	    limit: 20,
	    method: 'POST',
	    colModel: [ {header:"代理机构编码",name:"channelCode",width:100},
	         		{header:"代理机构名称",name:"mediumCname",width:250},
	        		/* {header:"远程出单点代码",name:"nodeCode",width:100},*/
	        		{header:"远程出单点名称",name:"nodeName",width:200},
	        		{header:"保费目标(万元)",name:"targetPremium",width:100},
	        		{header:"出单点地址",name:"address",width:150},
	        		/* {header:"是否远程出单点",name:"remote",width:100},
	        	 	{header:"出单点名称",name:"name",width:150},
	        	 	{header:"出单帐号",name:"account",width:120},*/
	        	 	{header:"业务线" , name:"businessLine",width:80},
	        	 	{header:"联系人",name:"contact",width:100},
	        	 	{header:"电话",name:"mobile",width:100},
	        	 	{header:"邮箱",name:"email",width:120},
	        	 	{header:"维护人",name:"salesmanCname",width:100},
	        	 	{header:"是否关停",name:"closeFlag",width:80,renderer : function(colValue, rowData, rowIndex) {
                        if (colValue == '1') {
                            return "<span style='color:red;'><b>是 </b></span>";
                        } else {
                            return "<span style='color:green;'><b>否 </b></span>";
                        }
                      }
                    },
	        	 	{header:"关停日期",name:"closeDate",width:80}],
			dataSource : "<%=_path%>/mediumNode/queryMediumNode.do?"+$("#mediumContectFrm").serialize()
	});
	
	$("#medium-node-button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	//"关停"按钮权限管控
	hiddenStopMediumNodeButton();
	
	//删除按钮权限管控
	hiddenDelMediumNodeButton();
	
	//查询远程出单点列表操作
	queryMediumNode();
	
	
	/************************************************************协议管理*********************************************************************/       	  
	
	//查询协议列表操作
	queryMediumConfer();
	
	initValidate();
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
    
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

    /*
     * 功能：关停按钮权限
     * 说明：总公司角色操作不受限制；分公司角色中，仅如下角色可见；分公司_渠道管理岗_市场开发 subDeptManager
     */
    var closeRoleArray = new Array('subDeptManager','headDepatFinanceSafe','headDepatChennelCh','headDeptChannel','haedDeptSalesman','headDeptDirector'); 
    //删除按钮，总公司可见删除可操作，分公司不可见删除按钮；
    $.ajax({ 
		url: "<%=_path%>/common/findRolesInSystemByUserCode.do",
		type:"post",
		async: true, 
		dataType: "html",
		success: function(roleEname){
			if(roleEname == "subDeptAdmin" || roleEname == "subDeptManager" || roleEname == "subDeptFinanceSafe" || roleEname == "subDeptChennelCh"){
				$("#delMediumNodeButton").parent().parent().hide();  //删除按钮，远程出单点
				$("#delMediumNodeButton").parent().parent().next().hide();
				$("#delMediumConferButton").parent().parent().hide(); //删除按钮，协议
				$("#delMediumConferButton").parent().parent().next().hide();
			}
			//
			var hideCloseBtn = true; 
			for(var i=0; i<closeRoleArray.length; i++){
               if(roleEname == closeRoleArray[i]) {
            	   showCloseBtn = false;
               }
			}
			if(hideCloseBtn){
				$("#closeMediumConferButton").parent().parent().hide();
				$("#closeMediumConferButton").parent().parent().next().hide();
   		    }
		} // end success
	});
    
	/*
  	 * 功能：系统管理员可以修改（机构不能修改）:渠道大类/渠道类型/是否协作人/协议代理人/业务线
  	 * 作者：sunyf
  	 * 日期：2014-04-15
  	 */
	$.ajax({ 
		url:"<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=xszcAdmin,headDeptChannel,headDepatFinanceSafe,headDepatChennelCh,headDeptdianxiao,headDepatCredit",
		type:"post",
		async:true, 
		dataType:"JSON",
		success:function(data){
		  if (data) {
		     $("#channelCategory").omCombo({readOnly:false}).next(".sele").css({"background-color":"#FFFFFF"});
		     $("#channelType").omCombo({readOnly:false}).next(".sele").css({"background-color":"#FFFFFF"});
		     $("#supportFlag").omCombo({readOnly:false}).next(".sele").css({"background-color":"#FFFFFF"});
		     $("#agentCode").removeAttr("readonly").css({"background-color":"#FFFFFF"});
		     $("#businessLine").omCombo({readOnly:false}).next(".sele").css({"background-color":"#FFFFFF"});
		  }
		}
	});    
    
}); //end onload();

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
        	$('#uploadId').val(currentUploadId);
        	//经办部门编码处理
        	//var processDeptCode = $("#processDeptCode").val();
			//$("#processDeptCode").val(processDeptCode.split('-')[0]);
			$.omMessageBox.waiting({
                title:'请等待',
                content:'服务器正在处理请求...'
            });
    	    //保存提交
        	Util.post("<%=_path%>/medium/updateMedium.do",$("#baseInfo").serialize(), function(data) {
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
	var deptCode = $("#deptCode").val();
	if(deptCode == '请选择'){
		$("#deptCode").val('');
	}else{
		$("#deptCode").val(deptCode.split('-')[0]);
	}
	
	$("#mediumNodeTables").omGrid("setData","<%=_path%>/mediumNode/queryMediumNode.do?"+$("#mediumNodeFilterFrm").serialize());
	
	$("#deptCode").val(deptCode);
}

//“关停”按钮的权限管控
function hiddenStopMediumNodeButton(){
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=headDeptCreditChannelNew,headDeptAdminChannelNew,headDeptMediumNodeNew,subDeptManagerChannelNew,subDeptMediumNodeChannelNew,xszcAdmin",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			//alert(typeof(data));
			if(data === "false"){
				$("#stopMediumNodeButton").remove();
				$(".om-buttonbar-sep:last").remove();
			}
		}
	});
}

//“删除”按钮的权限管控
function hiddenDelMediumNodeButton(){
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=headDeptAdminChannelNew,xszcAdmin",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			//alert(typeof(data));
			if(data === "false"){
				$("#delMediumNodeButton").remove();
				$(".om-buttonbar-sep:last").remove();
			}
		}
	});
}


//查询合作机构协议列表操作
function queryMediumConfer(){
	$("#mediumConferTables").omGrid("setData","<%=_path%>/mediumConfer/queryMediumConfer.do?"+$("#mediumConferFilterFrm").serialize());
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
        
		<!------------------------------------------------------------- 远程出单点维护  -------------------------------------------------------------->

		<form id="mediumNodeFilterFrm">
		<div id="search-panel" class="search-panel">
				<table>
					<tr>
						<td style="padding-left:15px;" align="right"><span class="label">经办部门：</span></td>
						<td><span class="om-combo om-widget om-state-default"><input class="sele" id="deptCode" name="formMap['deptCode']" type="text" value="请选择" readonly="readonly" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" style="width:136px;" /><span id="choose" name="choose" class="om-combo-trigger"></span></span></td>
						<td style="padding-left:15px" align="right"><span class="label">合作机构编码：</span></td>
						<td><input name="formMap['channelCode']" id="channelCode" style="width:160px" /></td>
						<td style="padding-left:15px" align="right"><span class="label">合作机构名称：</span></td>
						<td><input type="text" name="formMap['mediumCname']" id="mediumCname" style="width:160px" /></td>
						<!-- <td style="padding-left:15px" align="right"><span class="label">渠道类型：</span></td>
						<td><input class="sele" type="text" name="formMap['category']" id="category" /></td> -->
						<td style="padding-left:15px" align="right"><span class="label">业务线：</span></td>
						<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" /></td>
						<!-- <td style="padding-left:15px" align="right"><span class="label">渠道性质：</span></td>
						<td><input class="sele" type="text" name="formMap['property']" id="property" /></td>
						<td style="padding-left:15px" align="right"><span class="label">所属行业：</span></td>
						<td><input class="sele" type="text" name="formMap['profession']" id="profession" /></td> -->
					</tr>
					<tr>
						<td style="padding-left:15px"><span class="label">远程出单点名称：</span></td>
						<td><input type="text" name="formMap['nodeName']" id="mediumNodeName" /></td>
						<!-- 
						<td style="padding-left:15px"><span class="label">远程出单点状态：</span></td>
						<td><input type="text" name="formMap['closeFlag']" id="closeFlag" /></td> 
						-->
						<td style="padding-left:15px;padding-top:5px;" align="right"><span id="medium-node-button-search" onclick="queryMediumNode()">查询</span></td>
					</tr>
				</table>
			</div>
		</form>
		
		<div id="mediumNodeButtonbar"></div>
		<div id="mediumNodeTables"></div>
</body>
</html>