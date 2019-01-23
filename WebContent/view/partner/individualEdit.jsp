<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
html, body{width: 100%; height: 100%; padding: 0; margin: 0; overflow: hidden;}
/*校验错误提示*/
.errorImg{background:url(<%=_path%>/images/msg.png) no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error, textarea.error {border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:-2px}
/*校验星号*/
span.asterisk{color:red;position:relative;top:4px;}
/*提示按钮*/
.msg-btn{cursor:pointer;font-size:14px;font-weight:bold;margin-right:4px;color:red}
/*提示信息*/
.msg-info{/*list-style-type:none;*/margin:0 30px 0 0;padding-left:20px;background:#FCEFE3;min-width:200px;}
/*只读灰化 */
input[disabled='disabled'],textarea[disabled='disabled']{background-color:#F0F0F0;color:gray;}
</style>
<title>个人合作伙伴编辑</title>
<%
String channelCode = request.getParameter("channelCode");
Integer tabFlag = Integer.parseInt(request.getParameter("flag"));
String channelFlag = request.getParameter("channelFlag");
%>
<script type="text/javascript">
var tabFlag = <%=tabFlag%>;
var channelCode = <%=channelCode%>;
var channelFlag = <%=channelFlag%>;

var expireDate;
var validDate;
var userDptCde = '';
var returnFlag = '1';
//经办部门是否修改
var jbDeptCode1 ="", jbDeptCode2 ="";
//
$(function(){
	$("#baseInfo").find("input[name^='formMap']").css({"width":"150px"});
	$("#conferFilterFrm").find("input[name^='formMap']").css({"width":"151px"});
	$(".sele").css({"width":"131px"});
	
	/******初始化tab标签页*********/
	$('#make-tab').omTabs({
	    closable: false,
	    active: tabFlag,
	    switchMode: 'mouseover'
	   });
	
	/************************************************************ 基本信息 开始  *********************************************************************/
	Util.post("<%=_path%>/individual/queryIndividualByPk.do?channelCode=<%=channelCode%>", "",function(data) {
	        $("#baseInfo").find(":input").each(function(){
	            if($(this).val() != null || $(this).val() != "")
	            $(this).val(data[$(this).attr("id")]);
	        });
	        $('#businessLine').omCombo({dataSource:<%=Constant.getCombo("businessLine")%>,value:data.businessLine,disabled:true});
	        $('#channelCategory').omCombo({dataSource:<%=Constant.getCombo("channelCategory1")%>,value: data.channelCategory,disabled:true});
	        $('#channelOrigin').omCombo({dataSource:<%=Constant.getCombo("channelOrigin")%>,value:data.channelOrigin,disabled:true});
		    $('#certifyType').omCombo({dataSource:"<%=_path%>/common/queryCertifyType.do",value:data.certifyType,disabled:true});
			// 内部渠道不能修改
			if (data.channelOrigin == "0") {
			    $('#button-read').show();
			    $("#baseInfo").find(":input").each(function(){
			      $(this).attr("disabled","disabled");
			    });
			    //禁用下拉框
			    $('#bankProvince').omCombo({dataSource:"<%=_path%>/common/queryProvince.do",value:data.bankProvince,disabled:true});
			    $('#bankCity').omCombo({dataSource:"<%=_path%>/common/queryCity.do?province="+data.bankProvince,value:data.bankCity,disabled:true});
			    $('#bankReceive').omCombo({dataSource:"<%=_path%>/common/queryBank.do",value:data.bankReceive,disabled:true});
			    $('#bankNode').omCombo({dataSource: "<%=_path%>/common/queryBankNode.do?bank="+data.bankReceive+"&city="+data.bankCity,value:data.bankNode,disabled:true});
			    $('#profession').omCombo({dataSource:"<%=_path%>/common/queryProfession.do",value:data.profession,disabled:true});
			    $('#signDate').omCalendar({editable:false,disabled:true});
			    $("#choose").unbind("click");
			} else if (data.channelOrigin == "1") {
			    $('#button-edit').show();
			    $('#bankProvince').omCombo({dataSource:"<%=_path%>/common/queryProvince.do",value:data.bankProvince});
			    $('#bankCity').omCombo({dataSource:"<%=_path%>/common/queryCity.do?province="+data.bankProvince,value:data.bankCity});
			    $('#bankReceive').omCombo({dataSource:"<%=_path%>/common/queryBank.do",value:data.bankReceive});
			    $('#bankNode').omCombo({dataSource: "<%=_path%>/common/queryBankNode.do?bank="+data.bankReceive+"&city="+data.bankCity,value:data.bankNode});
			    $('#profession').omCombo({dataSource:"<%=_path%>/common/queryProfession.do",value:data.profession});
			    $('#signDate').omCalendar({editable:false});
			}
	});
	//开户行所在省
	$('#bankProvince').omCombo({
	       onValueChange : function(target, newValue, oldValue, event) {
	           $('#bankCity').omCombo("setData",[]);
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
	    editable : false,
		filterStrategy: 'anywhere'
	   });
	//开户行所在市
	$('#bankCity').omCombo({
		optionField: function(data, index) {
	        return data.text;
		},
		filterStrategy: 'anywhere',
		onValueChange: function(target, newValue, oldValue, event) {
	           if(newValue != ''){
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
	        ndata = $("#deptDropListTree").omTree("getParent", ndata);
	        }
	        //填充
	        $("#processDeptCname").val(departCode+'-'+text);
	        $("#deptCode").val(departCode);
	        $("#parentChannelCode").val('请选择'); //选择经办部门后，上级渠道被清空
	        $("#processDeptCname").focus();
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
	  $("#processDeptCname").click(function() {
	     showDropList();
	  });
	  //定位显示
	  function showDropList() {      
	  var cityInput = $("#processDeptCname");
	  	  var cityOffset = cityInput.offset();
	  	  var topnum = cityOffset.top+cityInput.outerHeight()-1;
	  	  var leftnum = cityOffset.left-1;
	  	  if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	  topnum = topnum + 2;
	     }
	     $("#deptDropListTree").css({"margin-left": leftnum + "px", "margin-top": topnum +"px"}).show();
	     //body绑定mousedown事件
	     $("body").bind("mousedown", onBodyDown);
	  }
	  //隐藏下来框
	  function hideDropList() {
	     $("#deptDropListTree").hide();
	     $("body").unbind("mousedown", onBodyDown);
	  }
	  //鼠标点击后
	  function onBodyDown(event) {
	     if(!(event.target.id == "choose" || event.target.id == "deptDropList" || $(event.target).parents("#deptDropList").length > 0)) {
	       hideDropList();
	       }
	  }
  
	//保存、取消按钮
	$("#button-save").omButton({icons:{left:'<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons:{left:'<%=_path%>/images/remove.png'},width:50});
	$("#button-back").omButton({icons:{left:'<%=_path%>/images/remove.png'},width:50});
	
	/************************************************************ 基本信息 结束  *********************************************************************/
	
	/************************************************************ 协议管理  开始 *********************************************************************/
	//页面导航 
	$("#medium-confer-search-panel").omPanel({title: "个人合作伙伴协议", collapsible: true, collapsed: false });
	//协议类型
	$('#conferType').omCombo({
	  dataSource: "<%=_path%>/common/queryConferType.do",
	    optionField: function(data, index) {
	        return data.text;
	    },
	    emptyText: '请选择',
	    editable: false,
	    width: '153px'
	});
	//签约时间
	$('#conferSignDate').omCalendar();
	//按钮菜单
	$('#conferButtonbar').omButtonbar({
	   	btns : [{label:"新增",
	       		     id:"addConferButton",
	       		     icons : {left : '<%=_path%>/images/add.png'},
	       	 		 onClick:function(){
	       	 				var conferJsonData = JSON.stringify($('#conferTables').omGrid('getData'));
	       	 				var jsonRows = eval("["+conferJsonData+"]")[0].rows;
	       	 				var maxExpireDate; //协议最大的失效日期
	       	 				if(jsonRows.length > 0){
	       	 					maxExpireDate = jsonRows[0].expireDate;
	       	 				} else {
	       	 					maxExpireDate = validDate;
	       	 				}
	        	 			var deptCode = $('#processDeptCode').val();
	        	 			var deptName = $('#processDeptCname').val();
	        	 			var channelCode = $('#channelCode').val();
	        	 			var channelName = $('#channelName').val();
	        	 			var channelCategory = $('#channelCategory').val();
	   	 			 		window.location.href = "individualConferAdd.jsp?channelCode=<%=channelCode%>&channelName="+channelName
	   	 			 				+"&deptCode="+deptCode+"&deptName="+deptName+"&expireDate="+expireDate
	   	 			 				+"&maxExpireDate="+maxExpireDate+"&channelCategory="+channelCategory;
	   	 			 }
	   			},
	   			{separtor:true},
	   	        {label:"维护",
	   			 	id:"updaConferButton",
	   			 	icons: {left: '<%=_path%>/images/op-edit.png'},
	   	 		 	onClick: function(){
	   	 		 		var rows = $('#conferTables').omGrid("getSelections",true);
	   	 		 		var row = eval(rows);
	   	 		 		var channelFlag = <%=channelFlag%>;
	   	 		 		if(row.length!=1){
		   	 		 		$.omMessageBox.alert({
	    	 		 	        content:'请选择一条记录维护',
	    	 		 	        onClose:function(value){
	    	 		 	        	return false;
	    	 		 	        }
		 		 	        });
	   	 		 		}else{
	   	 		 			if(row[0].conferType=='H'){
	 		 					window.location.href = "individualConferEdit.jsp?conferCode="+row[0].conferCode+"&channelCode=<%=channelCode%>&channelFlag=<%=channelFlag%>&expireDate="+expireDate;
	 		 				}else{
	   	 		 				$.omMessageBox.alert({
		    	 		 	        content:'您只能维护互联网服务协议',
		    	 		 	        onClose:function(value){
		    	 		 	        	return false;
		    	 		 	        }
			 		 	        });
	 		 				}
	   	 		 			<%-- if(channelFlag=="3"){
	   	 		 				if(row[0].conferType=='H'){
	   	 		 					window.location.href = "individualConferEdit.jsp?conferCode="+row[0].conferCode+"&channelCode=<%=channelCode%>&channelFlag=<%=channelFlag%>&expireDate="+expireDate;
	   	 		 				}else{
		   	 		 				$.omMessageBox.alert({
			    	 		 	        content:'您只能维护互联网服务协议',
			    	 		 	        onClose:function(value){
			    	 		 	        	return false;
			    	 		 	        }
				 		 	        });
	   	 		 				}
	   	 		 			}else if(channelFlag=='1'){
		   	 		 			if(row[0].conferType=='B' || row[0].conferType=='Q'){
		   	 		 				window.location.href = "individualConferEdit.jsp?conferCode="+row[0].conferCode+"&channelCode=<%=channelCode%>&channelFlag=<%=channelFlag%>&expireDate="+expireDate;
	     	        			}else{
	     	        				$.omMessageBox.alert({
			  		                      content:'您只能维护代理协议和经纪协议！',
			  		                      onClose:function(value){
			  		                          return false;
			  		                      }
			  		                  });
	     	        			}
	   	 		 			} --%>
	   	 		 		}
	   	 		 	}
	   	        },
	   	        {separtor:true},
	      	    {label:"详情",
	      			 	id:"queryConferButton",
	      			 	icons : {left : '<%=_path%>/images/detail.png'},
	      	 		 	onClick:function(){
	       	 		 	var rows = $('#conferTables').omGrid("getSelections",true);
	   	 		 		var row = eval(rows);
	    	 		 	if(row.length != 1){
		 		 			$.omMessageBox.alert({
	    	 		 	        content:'请选择一条记录查看',
	    	 		 	        onClose:function(value){
	    	 		 	        	return false;
	    	 		 	        }
		 		 	        });
	   	 		 		}else{
	   	 		 			window.location.href = "individualConferDetail.jsp?conferCode="+row[0].conferCode+"&channelCode="+row[0].channelCode;
	   	 		 		}
	      	 		 	}
	      	        },
	   			{separtor:true},
	     	    {label:"审核",
	     	        	id:"processButton",
	     	        	icons : {left : '<%=_path%>/images/user.png'},
	     	        	onClick:function(){
	     	        		var channelFlag = <%=channelFlag%>;
	     	        		var rows = $('#conferTables').omGrid("getSelections",true);
        	 		 		var row = eval(rows);
        	 		 		if(row.length!=1){
        	 		 			$.omMessageBox.alert({
    	    	 		 	        content:'请选择一条协议审核',
    	    	 		 	        onClose:function(value){
    	    	 		 	        	return false;
    	    	 		 	        }
    		 		 	        });
        	 		 		}else{
	           	 		 			if(row[0].conferType=='H'){
	           	 		 			var dels = $('#conferTables').omGrid('getSelections',true);
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
	     	         	        			if(del[i].approveFlag == "1"){
	     	         	        				$.omMessageBox.alert({
	     	               	 		 	        content:'请选择未审核的记录操作'
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
	     	     	                        Util.post("<%=_path%>/mediumConfer/processConfers.do?conferCodes="+conferCodes+"&channelCode="+channelCode,'', 
	     		       	 		 			function(data) {
	     		       	 		 				if(data.flag == "1"){
	     			       	 		 				$.omMessageBox.alert({
	     			       	        					type:'success',
	     			       	        	                title:'成功',
	     			       	    	 		 	        content:'审核合作机构协议成功',
	     			       	    	 		 	        onClose:function(value){
	     				       	 		 					//刷新列表
	     				       	 		 					$('#conferTables').omGrid({});
	     			       	    	 		 	        	return true;
	     			       	    	 		 	        }
	     			       		 		 	        });
	     		       	 		 				} else {
	     						       	 		 	$.omMessageBox.alert({
	     			       	        					type:'error',
	     			       	        	                title:'失败',
	     			       	    	 		 	        content:'审核合作机构协议失败<br/>'+data.msg,
	     			       	    	 		 	        onClose:function(value){
	     				       	 		 					//刷新列表 TODO:
	     				       	 		 					//$('#tables').omGrid({});
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
   	     	        			}else{
   	     	        				$.omMessageBox.alert({
   			  		                      content:'您只能审核互联网协议！',
   			  		                      onClose:function(value){
   			  		                          return false;
   			  		                      }
   			  		                    });
   	     	        			}
        	 		 		}
 	     	        		
	     	        	}
	     	        }
	   	]
	});

	//初始化列表
	$("#conferTables").omGrid({
		showIndex: true,
		singleSelect: true,
	    height: 450,
	    limit: 10,
	    method: 'POST',
	    colModel: [ {header:"协议号",name:"conferId",width:120},
	    			{header:"协议补充号",name:"extendConferCode",width:80},
	         		{header:"经办部门编码",name:"deptCode",width:80},
	        		{header:"经办部门",name:"deptSimpleName",width:150},
	        		{header:"渠道编码",name:"channelCode",width:100},
	        		{header:"姓名",name:"channelName",width:180},
	        		{header:"审核状态",name:"approveFlag",width:80,align:'center',renderer:function(value,rowData,rowIndex){      
	        		    if("0" === value){
	        		        return '<span style="color:red;"><b>未审核</b></span>';
	        		      }else if("1" === value){
	        		        return '<span style="color:green;"><b>已审核</b></span>';
	        		      }
	        		    }},
	        		{header:"协议分类",name:"conferTypeName",width:100},
	        		{header:"签定日期", name:"signDate",width:80,align:'center'},
	        	 	{header:"生效日期", name:"validDate",width:80,align:'center'},
	        	 	{header:"截止日期", name:"expireDate",width:80,align:'center'},
	        	 	{header:"结费周期（天）",name:"calclatePeriod",width:90}],
			dataSource: "<%=_path%>/confer/queryConferByWhere.do?"+$("#conferFilterFrm").serialize()
	});
	
	$("#button-search-confer").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	initValidate();
    
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
    
    $.validator.addMethod("processDeptCnameRequired", function(value) {
	    return value != '请选择';
	}, '经办部门必选');
	
	$.validator.addMethod("parentChannelNameRequired", function(value) {
	    return value != '请选择';
	}, '上级渠道必选');
	
	$.validator.addMethod("isPhone", function(value) {
	    var regu =/(^[1][358][0-9]{9}$)|(^((\d{3,4})-)?(\d{6,8})(-(\d{3,}))?$)/; 
	    var reg = new RegExp(regu);
	    return reg.test(value);  // 手机,固话验证
	}, '不是有效的联系电话');
	
	$.validator.addMethod("bankAccountCheck",function(value){
	 var reg = /^[0-9]+[\-]?[0-9]+$/;
	 return reg.test(value);
	},"银行帐号只允许包含数字或横线，例：10-1234");
	
	selectIframe();
    
}); //end onload();

//日期格式化
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

/************************************************************ 页面校验  开始 *********************************************************************/
//定义校验规则,此规则页面加载的时执行
var validateRule = {
  channelNameformMap:{
    required: true,
    maxlength: 25
  },
  processDeptCnameformMap:{
    required: true,
    processDeptCnameRequired: true
  },
  parentChannelNameformMap:{
    required: true,
    parentChannelNameRequired: true
  },
  certifyTypeformMap:{
    required: true
  },
  certifyNoformMap:{
    required: true,
    maxlength: 25
  },
  bankAccountformMap:{
    required: true,
    bankAccountCheck: true,
    maxlength: 30
  },
  bankNameformMap:{
    required: true,
    maxlength: 50
  },
  bankProvinceformMap:{
    required: true
  },
  bankCityformMap:{
    required: true
  },
  bankReceiveformMap:{
    required: true
  },
  bankNodeformMap:{
    required: true
  },
  telformMap:{
    required: true
  },
  mobileformMap:{
    required: true,
    isMobilePhone: true
  },
  emailformMap:{
    email: true
  },
  adderssformMap:{
    maxlength: 100
  }
};

//定义校验的显示信息
var validateMessages = {
  channelNameformMap:{
    required: '姓名不能为空',
    maxlength: '姓名最长25位'
  },
  processDeptCnameformMap:{
    required: '经办部门必选'
  },
  parentChannelNameformMap:{
    required: true
  },
  certifyTypeformMap:{
    required: '证件类型必选'
  },
  certifyNoformMap:{
    required: '证件号码不能为空',
    maxlength: '证件号码最长25位'
  },
  bankAccountformMap:{
    required: '银行帐号不能为空',
    maxlength: '银行帐号最长30位'
  },
  bankNameformMap:{
    required: '账户名称不能为空',
    maxlength: '账户名称最长50位'
  },
  bankProvinceformMap:{
    required: '开户行所在省必选'
  },
  bankCityformMap:{
    required: '开户行所在市必选'
  },
  bankReceiveformMap:{
    required: '收款方银行必选'
  },
  bankNodeformMap:{
    required: '开户行网点必选'
  },
  mobileformMap:{
    required: '手机号不能为空',
    isPhone: '联系电话不能为空'
  },
  telformMap:{
    required: '联系电话不能为空'
  },
  emailformMap:{
    email: '邮箱格式不正确'
  },
  adderssformMap:{
    maxlength: '账户名称最长100个字符'
  }
};

//校验
function initValidate(){
	//将name属性修改进行验证
	$("#baseInfo").find("input[name^='formMap']").each(function(){
	    $(this).attr("name",$(this).attr("id")+"formMap");
	});
	
	$("#baseInfo").validate({
		rules: validateRule,
		messages: validateMessages,
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
        submitHandler: function() {
			//name属性还原,以便提交
			$("#baseInfo").find("input[name$='formMap']").each(function(){
			    $(this).attr("name","formMap['"+$(this).attr("id")+"']");
			});
			$.omMessageBox.waiting({
                title:'请等待',
                content:'服务器正在处理请求...'
            });
    	    //保存提交
        	Util.post("<%=_path%>/individual/updateIndividual.do",$("#baseInfo").serialize(), function(data) {
          	    $.omMessageBox.waiting('close');
       			if(data == "success"){
       				$.omMessageBox.alert({
       					type: 'success',
       	                title: '提示',
   	 		 	        content: '保存成功',
   	 		 	        onClose: function(value){
		        			window.location.href = "individual.jsp";
   	 		 	        	return true;
   	 		 	        }
 		 	        });
       			}
            });
        }
    });
}
/************************************************************ 页面校验  结束 *********************************************************************/

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

//填充数据（选择上级机构）
function fillMediumBackAndCloseDialog(rowData) {
	if(rowData.channelCode == '--'){
		  $("#parentChannelName").val("无");
		  $("#parentChannelCodel").val("");
	  }else{
	      $("#parentChannelCode").val(rowData.channelCode);
	      $("#parentChannelName").val(rowData.channelCode+'-'+rowData.mediumCname);
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

//选择窗口
function selectIframe(){
   //选择上级渠道
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
}

//保存合作机构操作
function save(){
  $("#baseInfo").submit();
}

//取消操作
function cancel(){
  window.location.href = "individual.jsp?channelCode="+channelCode;
}

//查询合作机构协议列表操作
function queryConfer(){
	$("#conferTables").omGrid("setData","<%=_path%>/confer/queryConferByWhere.do?"+$("#conferFilterFrm").serialize());
}
</script>
</head>
<body>
	<div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
	<div id="medium-dialog-model" title="选择上级渠道">
		<iframe id="mediumIframe" frameborder="0" style="width:100%; height:99%; height:100%; src="about:blank"></iframe>
	</div>
	<div id="make-tab" >
        <ul>
            <li><a href="#medium">个人合作伙伴信息</a></li>
            <li><a href="#mediumConfer">个人合作伙伴协议</a></li>
        </ul>
        <!------------------------------------------------------------- 基本信息开始  -------------------------------------------------------------->
        <div id="medium">
			<div>
				<table class="navi-tab">
					<tr><td>个人合作伙维护</td></tr>
				</table>
			</div>
			<div>
				<fieldSet>
					<legend>基本信息</legend>
		            <form id="baseInfo" >
		                <!-- 隐藏域参数 -->
		                <input type="hidden" name="formMap['processDeptCode']" id="processDeptCode" />
		                <input type="hidden" name="formMap['parentChannelCode']" id="parentChannelCode" />
		                <input type="hidden" name="formMap['processUserCode']" id="processUserCode" />
		                <div id="leftDiv" style="float: left;">
		                    <table>
		                        <tr>
		                            <td style="padding-left:30px" align="right"><span class="label">姓名：</span></td>
		                            <td style="vertical-align: middle;"><input name="formMap['channelName']" id="channelName" /><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">渠道编码：</span></td>
		                            <td><input type="text" name="formMap['channelCode']" id="channelCode" readonly="readonly" value="系统生成"/></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
		                            <td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['processDeptCname']" id="processDeptCname" readonly="readonly" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';"/><span id="choose" name="choose" class="om-combo-trigger"></span></span><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                        </tr>
		                        <tr>    
		                            <td style="padding-left:30px" align="right"><span class="label">渠道大类：</span></td>
		                            <td><input class="sele" name="formMap['channelCategory']" id="channelCategory" readonly="readonly"/><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">渠道来源：</span></td>
		                            <td><input class="sele" name="formMap['channelOrigin']" id="channelOrigin" readonly="readonly" /><span id="channelOrigin" class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">上级渠道：</span></td>
		                            <td><input name="formMap['parentChannelName']" id="parentChannelName" readonly="readonly" onclick="selParentMedium();" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" /><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                        </tr>
		                        <tr>
		                            <td style="padding-left:30px" align="right"><span class="label">业务线：</span></td>
		                            <td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" readonly="readonly"/><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">身份证件类型：</span></td>
		                            <td><input class="sele" name="formMap['certifyType']" id="certifyType" /><span style="color:red">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">证件号码：</span></td>
		                            <td><input name="formMap['certifyNo']" id="certifyNo" /><span style="color:red">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                        </tr>
		                        <tr>
		                            <td style="padding-left:30px" align="right"><span class="label">银行帐号：</span></td>
		                            <td><input type="text" name="formMap['bankAccount']" id="bankAccount" /><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">开户行所在省：</span></td>
		                            <td><input class="sele" name="formMap['bankProvince']" id="bankProvince" /><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">开户行所在市：</span></td>
		                            <td><input class="sele" type="text" name="formMap['bankCity']" id="bankCity" /><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                        </tr>
		                        <tr>
		                            <td style="padding-left:30px" align="right"><span class="label">收款方银行：</span></td>
		                            <td><input class="sele" name="formMap['bankReceive']" id="bankReceive" /><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">开户行网点：</span></td>
		                            <td><input class="sele" name="formMap['bankNode']" id="bankNode"/><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">账户名称：</span></td>
		                            <td><input name="formMap['bankName']" id="bankName" /><span class="asterisk">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                        </tr>
		                        <tr>
		                            <td style="padding-left:30px" align="right"><span class="label">手机：</span></td>
		                            <td><input type="text" name="formMap['mobile']" id="mobile" /><span style="color:red">*</span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">电话号码：</span></td>
		                            <td><input name="formMap['tel']" id="tel" /><span class="asterisk"></span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                            <td style="padding-left:30px" align="right"><span class="label">E-mail：</span></td>
		                            <td><input name="formMap['email']" id="email" /><span style="color:red"></span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                        </tr>
		                        <tr>
		                            <td style="padding-left:30px" align="right"><span class="label">通讯地址：</span></td>
		                            <td><input name="formMap['adderss']" id="adderss" /><span style="color:red"></span></td>
		                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
		                        </tr>
		                    </table>
		                </div>
		                <div id="rightDiv" style="margin-left: 930px;">
		                  <span>提示</span><span onclick="javascript:$(this).parent().hide('slow');" class="msg-btn" title="关闭">[×]</span><span></span>
		                  <ul class="msg-info">
		                    <li>渠道信息、协议信息审核之后，数据即时同步到核心系统。</li>
		                    <li>渠道性质、渠道属类在核心系统添加，十分钟之后自动刷新到此页面。</li>
		                    <li>经办人在核心系统添加，十分钟之后数据同步到销售支持系统，请先选择经办部门，再选择经办人。</li>
		                    <li>开户行网点在核心系统添加，机构提供开户行网点的名称、联行号等信息，发送给总公司计划财务部的核心系统管理员，由计划财务部在核心系统添加开户行网点信息，十分钟之后自动刷新到此页面。</li>
		                  </ul>
		                </div>
		            </form>
				</fieldSet>
			</div>
            <div id="button-edit" style="display: none;">
                <table style="width:100%; margin-top:20px;">
                    <tr>
                        <td align="center">
                        <a id="button-save" onclick="save()">保存</a>
                        <a id="button-cancel" onclick="cancel()">取消</a>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="button-read" style="display: none;">
                <table style="width:100%; margin-top:20px;">
                    <tr>
                        <td align="center">
                        <a id="button-back" onclick="cancel()">返回</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <!------------------------------------------------------------- 基本信息 结束  -------------------------------------------------------------->
        
        <!------------------------------------------------------------- 协议管理 开始  -------------------------------------------------------------->
		<div id="mediumConfer">
			<form id="conferFilterFrm">
			    <input type="hidden" name="formMap['channelCode1']" id="channelCode1" value='<%=channelCode%>'/>
				<div id="medium-confer-search-panel">
					<table>
						<tr>
							<td style="padding-left:15px" align="right"><span class="label">协议号：</span></td>
							<td><input type="text" name="formMap['conferId']" id="conferId" /></td>
							<td style="padding-left:15px" align="right"><span class="label">协议类型：</span></td>
							<td><input class="sele" type="text" name="formMap['conferType']" id="conferType" /></td>
							<td style="padding-left:15px" align="right"><span class="label">签订日期：</span></td>
							<td><input class="sele" type="text" name="formMap['signDate']" id="conferSignDate" /></td>
							<td colspan="2" style="padding-left:15px;padding-top:5px;" align="right"><span id="button-search-confer" onclick="queryConfer()">查询</span></td>
						</tr>
					</table>
				</div>
			</form>
			<div id="conferButtonbar"></div>
			<div id="conferTables"></div>
		</div>
	</div>
</body>
</html>