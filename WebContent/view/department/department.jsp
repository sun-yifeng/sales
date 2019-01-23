<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/page.css"/>
<title>机构维护</title>
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
<script type="text/javascript">
var btnArray = ["newUser","button-search"];
$("#button-new").omButton({width:50});
$(function(){
	//父机构名称
	$("#parentDeptName").css({"background-color":"transparent"});
	$("#button-new").omButton({width:50});
	$("#deptFrm").find("input").css({"width":"151px"});
	$(".sele").css({"width":"132px"});	
	
	//机构
	initTree();	
	
	//布局
	initLayout();	
	
	$('#buttonbar').omButtonbar({
    	btns : [
    	    	{label:"新增",
    		     id:"button-new" ,
    		     name:"button-new" ,
    		     icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
    	 		 onClick:function(){
    	 			 openSaveDept(true);
    	 	       }
    			},
    			{separtor:true},
    	        {label:"修改",
    			 id:"button-update",
    		     disabled :  false,
    			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
    	 		 onClick:function(){
    	 			updateDept();
    	 		   }
    	        },
    	        {separtor:true},
    	        {label:"删除",
    			 id:"button-remove",
    		     disabled :  false,
    			 icons : {left : '<%=_path%>/core/js/ref/operamasks-ui-2.1/css/default/images/remove.png'},
    	 		 onClick:function(){removeDept();}
    	        }
    	      ]
    });
	
	//时间
	$('#foundDate').omCalendar({editable : false});
	$('#expireDate').omCalendar({editable : false});
	$('#licenseValid').omCalendar({editable : false});
	$('#licenseExpire').omCalendar({editable : false});
	
	//个性化机构
	$('input[name=specialDept]').omCombo({ 
		editable : false,
        dataSource : [ {text : '请选择', value : ''}, {text : '是',value : '1'}, {text : '否', value : '0'}],
        onValueChange : function() {
	        $('input[name=specialDept]').focus();
        }
    });
	$("#specialDept").omCombo('value','');	
	
	//是否电销机构
	$('input[name=telDeptFlag]').omCombo({
		editable : false,
        dataSource : [{text : '请选择', value : ''}, {text : '是', value : '1'}, {text : '否',value : '0'}],
        onValueChange : function() {
	        $('input[name=telDeptFlag]').focus();
        }
    });
	$("#telDeptFlag").omCombo('value','');
	
	//报警标志
	$('input[name=alarmFlag]').omCombo({
		editable : false,
        dataSource : [ {text : '请选择', value : ''}, {text : '是', value : '1'}, {text : '否',value : '0'}],
        onValueChange : function() {
	        $('input[name=telDeptFlag]').focus();
        }
    });
	$("#alarmFlag").omCombo('value','');
    
    //机构成立日期
    $.validator.addMethod("getDeptFoundDate", function(value) {
    	var deptExpireDate = $("#expireDate").val();
    	if(value != '' && deptExpireDate !='' ){
           return value < deptExpireDate;
    	} else {
    	   return true;
    	}
 	}, '此日期应小于机构期满日期');
    
    //机构期满日期
    $.validator.addMethod("getDeptExireDate", function(value) {
    	var deptFoundDate = $("#foundDate").val();
    	if(value != '' && deptFoundDate !='' ){
           return value > deptFoundDate;
    	} else {
    	   return true;
    	}
 	}, '此日期应大于机构成立日期');
    
    //许可证颁发日期
    $.validator.addMethod("getLicenseValidDate", function(value) {
    	var licenseExpire = $("#licenseExpire").val();
    	if(value != '' && licenseExpire !='' ){    		
            return value < licenseExpire;
    	} else {
    	   return true;
    	}
 	}, '此日期应小于许可证终止日期');
    
    //校验许终止日期
    $.validator.addMethod("getLicenseExpireDate", function(value) {
    	var licenseValid = $("#licenseValid").val();
    	if(value != '' && licenseValid !='' ){    		
            return value > licenseValid;
    	} else {
    	   return true;
    	}
 	}, '此日期应大于许可证颁发日期');
    
    //只能在分公司或支公司下建虚拟机构
    $.validator.addMethod("checkDeptCode", function(value) {
    	//如果是修改,则跳过
    	if($('#operateType').val() == 'update'){
    		return true;
    	}
    	//如果是提交,则跳过
    	if($('#submitFlag').val() == 'submitFlag'){
    		return true;
    	}
    	var parentDeptCode = $("#parentDeptCode").val();
    	if(parentDeptCode.length ==2  || parentDeptCode.length ==4 ){    		
            if(parentDeptCode != '00'){
            	//带出机构代码
            	generateDeptInfo(parentDeptCode);
            	return true;
            }         	
            return false;
    	}
    	return false;
 	}, '只能在分公司或支公司下建虚拟机构');
    
    //校验图片
    $('.errorImg').bind('mouseover', function() {
	    $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
	    $(this).next().css('display', 'none');
    });
    
   //隐藏详情
   $("#center-panel").omPanel({closed:true});
    
   //按钮样式
   $("#button-submit").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
   $("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
   
   /************************开始 机构选择树，异步加载*****************************************************************/
   $("#deptDropListTree").omTree({
      dataSource : "<%=_path%>/department/queryDeptDropList.do",
      simpleDataModel:true,
      //展开树节点事件，统计团队数量
      onBeforeExpand : function(node){
	   	  var nodeDom = $("#"+node.nid);
	   	  if(nodeDom.hasClass("hasChildren")){
	   		nodeDom.removeClass("hasChildren");
	   		$.ajax({
	   			url: '<%=_path%>/department/queryDeptDropList.do?parentCode='+node.id,
	   			method: 'POST',
	   			dataType: 'JSON',
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
        
        //填充输入框
        $("#parentDeptCode").val(departCode);
        $("#parentDeptName").val(text);
        
        //隐藏下来框
        hideDropList();
        
        //选择机构后去掉校验图片
        $("#parentDeptName").focus().blur();
        
      },onSuccess: function(data){
  		$('#deptDropListTree').omTree('expandAll');
  	  }
   });

   //显示下拉框,定位位置
   function showDropList() {
	  //新增才显示下拉树 
	  if($("#operateType").val() != 'save' ){
		  return;
	  }
      var deptInput = $("#parentDeptName");
   	  var deptOffset = deptInput.offset();
   	  //alert("top:" + deptOffset.top + ",height:" + deptInput.outerHeight() + ",left:" + deptOffset.left);
   	  var topnum = deptOffset.top - deptInput.outerHeight(); // 顶部距离
   	  var leftnum = deptOffset.left;                         // 左边距离
   	  if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
     	  topnum = topnum + 2;
     }
   	 //用CSS定位机构树的位置
     //$("#deptDropListTree").css({"margin-left": leftnum + "px","margin-top": topnum +"px"}).show();
     $("#deptDropListTree").css({"margin-left":"110px", "margin-top":"23px"}).show();
     $("body").bind("mousedown", onBodyDown);
   }

   //点击机构下拉按钮，显示下来树
   $("#choose").click(function() {
     showDropList();
   });
   //点击机构输入框，显示下来树
   $("#parentDeptName").click(function() {
     showDropList();
   });

   //隐藏下拉框
   function hideDropList() {
     $("#deptDropListTree").hide();
     $("body").unbind("mousedown", onBodyDown);
   }

   //mousedown事件
   function onBodyDown(event) {
     if(!(event.target.id == "choose" || event.target.id == "deptDropList" || $(event.target).parents("#deptDropList").length > 0)) {
          hideDropList();
       }
   }
   /************************结束  机构选择树，异步加载******************************************************************************/
 
}); //end $(function(){});



//自动带出机构代码
function generateDeptInfo(parentCode){   
   Util.post("<%=_path%>/department/generateDeptInfo.do?parentCode="+parentCode, "", function(data) {
	   //填充机构信息
	   $("#deptCode").val(data.deptCode);
	   $("#deptCname").val(data.deptName);
	   $("#deptSimpleName").val(data.deptName);
	   $("#interCode").val(data.interCode);
   });	
}

//组织架构树，统计(XXX个团队/XXX人/常规XXX人/重客XXX人/金融XXX人)
function initTree(){
	Util.post("<%=_path%>/department/queryDeptByParentCode.do", "", function(data){
		if (data == null){
			$("#buttonbar").hide();
			$.omMessageBox.alert({
		        content:'未分配业务机构，请联系管理员！'
		    });
		} else {
			$("#departmentTree").omTree({
				dataSource : "<%=_path%>/department/queryDeptByParentCode.do",
				simpleDataModel:true,
				onBeforeExpand : function(node){
					var nodeDom = $("#"+node.nid);
					if(nodeDom.hasClass("hasChildren")){
						nodeDom.removeClass("hasChildren");
						$.ajax({
							url: '<%=_path%>/department/queryDeptByParentCode.do?parentCode='+node.id,
							method: 'POST',
							dataType: 'json',
							success: function(data){
							  $("#departmentTree").omTree("insert", data, node);
							}
						});
					}
					return true;
				},
				//选中结构树
				onSelect: function(node,event) {
		            Util.post("<%=_path%>/department/queryDeptInfo.do", "deptCode="+node.id, function(data){
		            	//填充详情
		            	fillForm(data);
		            	//显示详情
		            	$("#center-panel").omPanel({closed:false});
		            	//隐藏隐藏
		            	$("#oldDeptCode").val(data['deptCode']);
		            	//失效功能
		            	deptFrmDisable(true);
			        });
				},onSuccess: function(data){
		  		    $('#departmentTree').omTree('expandAll');
	  	        }
			});
		} // end else
    });
	
}

//初始化页面
function initLayout(){
	$('#page').omBorderLayout({
	  panels:[
			   //树形结构
			   { 
			       id:"west-panel", 
			       title:"组织架构树",
			       header:false,
			       region:"west", 
			       width:500  //树结构的宽度
			   },
			   //组织信息
			   { 
			       id:"center-panel", 
			       title:"组织架构详情",
			       header:true,
			       region:"center"
			       //width:600
			   }
	         ],
	   spacing:0
	});
}

//填充数据
function fillForm(data){
	$('.errorImg').css("display", "none");
	$('.error').css("border", "1px solid #9AA3B9");
	//fill combo
	$("#alarmFlag").omCombo({
		dataSource:[{text:'请选择', value:''},{text:'是', value:'1'},{text:'否', value:'0'}],
		value : data.alarmFlag,
        editable : false,
        lazyLoad : true
	});
	$("#specialDept").omCombo({
		dataSource:[{text:'请选择', value:''},{text:'是', value:'1'},{text:'否', value:'0'}],
		value : data.specialDept,
        editable : false,
        lazyLoad : true
	});
	$("#telDeptFlag").omCombo({
		dataSource:[{text:'请选择', value:''},{text:'是', value:'1'},{text:'否', value:'0'}],
		value : data.telDeptFlag,
        editable : false,
        lazyLoad : true
	});
	$("#deptFrm").find("input").each(function(){
		$(this).val(data[$(this).attr("name")]);
	});
}

//详情是否失效
function deptFrmDisable(flag){
	if(flag){
		$("#deptFrm").find("input").each(function(){
			//设置只读属性
			$(this).attr({readonly:"readonly"});   
			//设置只读背景
			$(this).css({"background-color":"#F0F0F0"});
		});
		//失效日期选择
		$("#foundDate").omCalendar({disabled : true});
		$("#expireDate").omCalendar({disabled : true});
		$("#licenseValid").omCalendar({disabled : true});
		$("#licenseExpire").omCalendar({disabled : true});
		//失效下拉选择
		$("#alarmFlag").omCombo({disabled : true});
		$("#specialDept").omCombo({disabled : true});
		$("#telDeptFlag").omCombo({disabled : true});
		//失效机构选择(选择即失效，修改时不需求再次失效)
		//$("#choose").unbind();
		//$("#parentDeptName").unbind();
		//隐藏按钮
		$("#buttonDiv").hide();
	} else {
		$("#deptFrm").find("input").each(function(){
			//设置只读属性
			$(this).removeAttr("readonly");   
			//设置只读背景
			$(this).css({"background-color":"#FFFFFF"});
		});
		//失效日期选择
		$("#foundDate").omCalendar({disabled : false});
		$("#expireDate").omCalendar({disabled : false});
		$("#licenseValid").omCalendar({disabled : false});
		$("#licenseExpire").omCalendar({disabled : false});
		//失效下拉选择
		$("#alarmFlag").omCombo({disabled : false});
		$("#specialDept").omCombo({disabled : false});
		$("#telDeptFlag").omCombo({disabled : false});
		//显示按钮
		$("#buttonDiv").show();
	}
	
}

//定义校验规则
var deptRule = {
	//机构代码
	deptCode:{
		required : true,
		isLetterAndInteger : true,
		maxlength : 30
	},
	//机构中文名称
	deptCname:{
		required:true,
		isChinese:true,
		minlength:2,
		maxlength:50
	},
	//机构英文名称
	deptEname:{
		maxlength:200
	},
	//机构简称
	deptSimpleName:{
		required:true,
		minlength:2,
		maxlength:50
	},
	//父机构代码
	parentDeptCode:{
		required:true
	},
	//父机构名称
	parentDeptName:{
		required:true,
		checkDeptCode:true
	},
	//传真
	fax:{
 		isTelephone : true
	},	
	//联系电话
	tel:{
		isTelephone : true
	},	
	//咨询电话
	consultTel:{
		isTelephone : true
	},
	//报案电话
	caseTel:{
		isTelephone : true
	},
	//邮政编码
	postCode:{
		isNum:true
	},	
	//机构内部码
// 	interCode:{
// 		isNum:true
// 	},
	//机构成立日期
	foundDate:{
		getDeptFoundDate : true
	},
	//机构期满日期
	expireDate:{
		getDeptExireDate : true
	},
	//许可证颁发日期
	licenseValid:{
		getLicenseValidDate : true
	},
	//许可证终止日期
	licenseExpire:{
		getLicenseExpireDate : true
	}
};

//定义校验的显示信息
var deptMessages = {
	//机构代码
	deptCode:{
		required:'请选择父机构',
		isLetterAndInteger:'机构代码必须是数字和字母',
		maxlength:'机构代码最多30位'
	},
	//机构名称
	deptCname:{
		required:'请输入机构名称',
		isChinese:'机构中文名称必须为中文字符',
		minlength:'机构中文名称最少5个字符',
		maxlength:'机构中文名称最多50个字符'
	},
	//机构英文名称
	deptEname:{
		maxlength:'机构英文名称不能超过200个字符'
	},
	//机构简称
	deptSimpleName:{
		required:'请输入机构简称',
		minlength:'最少2个字符',
		maxlength:'最多25个字符'
	},
	
	//父级机构代码
	parentDeptCode:{
    		required:'请选择父级机构',
    		checkDeptCode:'只能在分公司或支公司下建虚拟机构'
	},
	
	//父级机构名称
	parentDeptName:{
		required:'请选择父级机构'
	},
	//传真
	fax:{
		isTelephone : '不是有效的传真号码'
	},	
	//邮政编码
	postCode:{
		isNum : '邮政编码必须是数字'
	},	
 	//机构内部码
// 	interCode:{
// 		isNum : '机构内部码必须是数字'
// 	}
};

//校验
function initValidate(){
	var parentCode  = $('#parentDeptCode').val();
	if(parentCode == ''){
		$('#parentDeptName').val('');
	}
	//
	$("#deptFrm").validate({
		rules: deptRule,
		messages: deptMessages,
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
    		//增加和修改确认
    		var operateType  = $('#operateType').val();
    		if(operateType == 'save'){
    			submitMsg = '您确定要新增组织架构吗？';
    		} else if(operateType == 'update'){
    			submitMsg = '您确定要修改组织架构信息吗？';
    		} else{ }
			$.omMessageBox.confirm({
		         title:'确认信息',
		         content:submitMsg,
		         onClose:function(v){
		             if(v){
			        	//提交机构信息
			        	Util.post("<%=_path%>/department/saveDept.do", $("#deptFrm").serialize(), function(data) {
			        		$.omMessageBox.alert({
			                    type:'success',
			                    title:'提示信息',
			                    content:data,
			                    onClose:function(v){
			        		      //刷新树结构;
			                      refreshDept();
			                      closeDialogDept();
			                    }
			                });  
			        	});
				     } else {
				    	 $('#submitFlag').val('');
				     }
			     }
			});
        }
    });
}

//提交
function saveDept(){
  $("#submitFlag").val('submitFlag');
  $("#deptFrm").submit();
}

//修改机构
function updateDept(){
	var deptCode = $("#deptFrm").find("#deptCode").val();
	if(deptCode == ''){
		$.omMessageBox.alert({
	           content:'请选择要修改的机构！'
	       });
	} else {
	    openSaveDept(false);
	    $("#deptSimpleName").focus();
	}
}

//删除机构
function removeDept(){
	try{
		var deptCode = $("#deptFrm").find("#deptCode").val();
		if(deptCode == ''){
			$.omMessageBox.alert({
		           content:'请选择一个机构进行删除！'
		       });
		} else {			
			var checked = $("#departmentTree").omTree("getSelected");
			var text = checked.text.substring(checked.text.indexOf("(")+1,checked.text.length-1);
			if(text.split("/")[0].substring(0,1) != "0" || text.split("/")[1].substring(0,1) != "0"){
				$.omMessageBox.alert({
			           content:"该机构下有团队"+ text.split("/")[0]+",人员" + text.split("/")[1]+",不能删除"
			       });
				return;
			}
			$.omMessageBox.confirm({
		           title:'确认信息',
		           content:'是否要删除该机构，删除后不可恢复！',
		           onClose:function(v){
		               if(v){
		       			   Util.post("<%=_path%>/department/removeDept.do", $("#deptFrm").serialize(), function(data) {
			    		        $.omMessageBox.alert({
			    		            type : 'success',
			    		            title : '提示信息',
			    		            content : data,
			    		            onClose : function(v) {
			    		              //刷新机构
			    		              refreshDept();
			    		              closeDialogDept();
			    		            }
			    		        });
		    	           });
		               }
		            }
		       });
		}
	}catch(e){
		$.omMessageBox.alert({
	           content:'没有选择要删除的记录'
	     });
	}
}

//清空
function clearDept(){
	$(':input','#deptFrm')
	 //.not(':button, :submit, :reset, :hidden')  
	 .val('')  
	 //.removeAttr('checked')  
	 .removeAttr('selected');
	 //.removeAttr('readonly');
}

//刷新
function refreshDept(){
	$("#departmentTree").omTree("refresh");
	$("#deptDropListTree").omTree("refresh");
}

//打开新增
function openSaveDept(flag){
	$("#deptFrm").omDialog({
		autoOpen:false,
		resizable:false,
		width:620,
		height:530,
		modal:true,
		title: flag ? "新增组织架构" : "修改组织架构",
		closeOnEscape : true,
		onClose:function(){
			window.location.href = "<%=_path%>/view/department/department.jsp";
		},
		onOpen:function(){
			//校验
			initValidate();
		}
	});
	//失效只读
	deptFrmDisable(false);
	$("#deptFrm").omDialog('open');
	$("#parentDeptName").attr({readonly:"readonly"});
	//如果是新增
	if(flag){		
 	   clearDept();
 	   $("#operateType").val('save');
	} else {
		$("#operateType").val('update');
		$("#parentDeptName").css({"background-color":"#F0F0F0"});
	}
	//隐藏详情标题
	$("#center-panel").omPanel({closed:true});
    //设置只读属性
    $("#parentDeptCode").attr({readonly:"readonly"});
	$("#parentDeptCode").css({"background-color":"#F0F0F0"});
    $("#deptCode").attr({readonly:"readonly"});
	$("#deptCode").css({"background-color":"#F0F0F0"});
    $("#interCode").attr({readonly:"readonly"});
	$("#interCode").css({"background-color":"#F0F0F0"});
	
}

//关闭新增
function closeDialogDept(){
	$("#deptFrm").omDialog('close');
	window.location.href = "<%=_path%>/view/department/department.jsp";
}

</script>
</head>
<body>
<div id="page" style="width:99%;height:100%;">
    <!-- begin center-panel 机构详情 -->
	<div id="center-panel" style="width:70%">
	<form id="deptFrm">
	    <input type="hidden" name="operateType" id="operateType" value="" />
	    <input type="hidden" name="submitFlag" id="submitFlag" value="" />
	    <input type="hidden" name="oldDeptCode" id="oldDeptCode" value="" />
	    <div id="deptDropList" class="deptDropList">
		   <ul id="deptDropListTree" class="deptDropListTree"></ul>
	    </div>
		<div id="deptInfoDiv">
			<table>
				<tr>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">父级机构名称：</span></td>
					<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="parentDeptName" id="parentDeptName" class="sele" readonly="true" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" /><span id="choose" name="choose" class="om-combo-trigger"></span></span><span style="color:red">*</span></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">父级机构代码：</span></td>
					<td><input type="text" name="parentDeptCode" id="parentDeptCode" readonly="readonly"/><span style="color:red">*</span></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right"><span class="label">机构代码：</span></td>
					<td><input type="text" name="deptCode" id="deptCode" maxlength="30"/><span style="color:red">*</span></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">机构中文名称：</span></td>
					<td><input type="text" name="deptCname" id="deptCname" maxlength="50"/><span style="color:red">*</span></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
			    </tr>
				<tr>	
					<td style="padding-left:10px" align="right"><span class="label">机构中文简称：</span></td>
					<td><input type="text" name="deptSimpleName" id="deptSimpleName" maxlength="25" /><span style="color:red">*</span></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">机构英文名称：</span></td>
					<td><input type="text" name="deptEname" id="deptEname" maxlength="200"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
			    </tr>
				<tr>		
					<td style="padding-left:10px" align="right"><span class="label">机构关系码：</span></td>
					<td><input type="text" name="deptRelationCode" id="deptRelationCode" maxlength="50"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">保险许可证号：</span></td>
					<td><input type="text" name="insureLicenseNo" id="insureLicenseNo" maxlength="50"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
			    </tr>
				<tr>	
					<td style="padding-left:10px" align="right" class="tds"><span class="label">报案地址：</span></td>
					<td><input type="text" name="caseAddress" id=caseAddress maxlength="50"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right"><span class="label">报案电话：</span></td>
					<td><input type="text" name="caseTel" id="caseTel" maxlength="20"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">报警标志：</span></td>
					<td><input type="text" name="alarmFlag" id="alarmFlag" class="sele"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">部门标志：</span></td>
					<td><input type="text" name="deptFlag" id="deptFlag"  maxlength="10"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right" ><span class="label">传真：</span></td>
					<td><input type="text" name="fax" id="fax" maxlength="20"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">联系电话：</span></td>
					<td><input type="text" name="tel" id="tel" maxlength="20"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">咨询电话：</span></td>
					<td><input type="text" name="consultTel" id="consultTel" maxlength="20"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right"><span class="label">中文地址：</span></td>
					<td><input type="text" name="deptCaddress" id="deptCaddress" maxlength="50"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">英文地址：</span></td>
					<td><input type="text" name="deptEaddress" id="deptEaddress" maxlength="100"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">邮政编码：</span></td>
					<td><input type="text" name="postCode" id="postCode"  maxlength="7"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right"><span class="label">机构流水号：</span></td>
					<td><input type="text" name="deptSeries" id="deptSeries"  maxlength="30"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">机构联系人：</span></td>
					<td><input type="text" name="contactUser" id="contactUser"  maxlength="15"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">机构内部编码：</span></td>
					<td><input type="text" name="interCode" id="interCode" maxlength="30"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right"><span class="label">机构成立日期：</span></td>
					<td><input type="text" name="foundDate" id="foundDate" class="sele" /></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">机构期满日期：</span></td>
					<td><input type="text" name="expireDate" id="expireDate" class="sele" /></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">税务登记号：</span></td>
					<td><input type="text" name="taxRegistNo" id="taxRegistNo" maxlength="50"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
			    </tr>
				<tr>
					<td style="padding-left:10px" align="right"><span class="label">营业执照：</span></td>
					<td><input type="text" name="licenseNo" id="licenseNo" maxlength="30"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">展业资格证号：</span></td>
					<td><input type="text" name="qualifyNo" id="qualifyNo" maxlength="30"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
			    </tr>
				<tr>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">个性化引用机构：</span></td>
					<td><input type="text" name="specialDept" id="specialDept" class="sele"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right"><span class="label">是否电销机构：</span></td>
					<td><input type="text" name="telDeptFlag" id="telDeptFlag" class="sele"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">许可证颁发日期：</span></td>
					<td><input type="text" name="licenseValid" id="licenseValid" class="sele" /></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">许可证终止日期：</span></td>
					<td><input type="text" name="licenseExpire" id="licenseExpire" class="sele" /></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right"><span class="label">保监会规定代码：</span></td>
					<td><input type="text" name="circCode" id="circCode"  maxlength="25"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">经营区域代码：</span></td>
					<td><input type="text" name="saleRegionCode" id="saleRegionCode"  maxlength="25"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr>
					<td style="padding-left:10px" align="right" class="tds"><span class="label">纳税人识别号：</span></td>
					<td><input type="text" name="taxRecognizeNo" id="taxRecognizeNo"  maxlength="25"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
			</table>
		</div>
		<!-- 提交 取消 按钮-->
		<div id="buttonDiv" style="display: none">
			<table style="width: 100%">
				<tr>
					<td style="padding-left: 30px; padding-top: 10px" align="center"><a class="om-button" id="button-submit" onclick="saveDept()">保存</a><a id="button-cancel" onclick="closeDialogDept()">取消</a></td>
				</tr>
			</table>
		</div>
	</form>
	</div>
    <!-- end center-panel 机构详情-->
    <!--树型机构 -->
	<div id="west-panel" >
		<div id="buttonbar" style="position:absolute;padding-top:0px;z-index:100;width:496px;"></div>
		<div id="departmentTree" style="z-index:-1;padding-top:25px;width:480px;"/>
	</div>
</div>
</body>
</html>