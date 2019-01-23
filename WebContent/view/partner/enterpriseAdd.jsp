<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
/*浏览器兼容*/
*{padding:0;margin:0}
/*页面边距*/
html, body{width: 100%; height: 100%; padding: 0; margin: 0; overflow: hidden;}
/*机构菜单*/
.deptDropListTree{height:250px;width:151xp;border:1px solid #9aa3b9;overflow:auto;display:none;position:absolute;background:#FFF;z-index:4;}
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
/*校验星号 */
span.asterisk{color:red;position:relative;top:4px;}
/*提示按钮*/
.msg-btn{cursor:pointer;font-size:14px;font-weight:bold;margin-right:4px;color:red}
</style>
<title>企业合作伙伴新增</title>
<script type="text/javascript">
$(function(){
	$("#baseInfo").find("input[name^='formMap']").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#processDeptCname").css({"background-color":"#fff"});
	$("#parentChannelName").css({"background-color":"#fff"});
	$("#processUserName").css({"background-color":"#fff"});
	
	/*******基本信息**********/
	
	//渠道来源:内部，外部
	$('#channelFlag').omCombo({
	    dataSource : [{"text":"请选择","value":""},{"text":"内部（传统渠道）","value":"0"},{"text":"外部（电商渠道）","value":"2"}],
	    disabled : true,
	    value: "2",
	});
	
	//业务线
	$('#businessLine').omCombo({
	    dataSource: [{"text":"网销业务","value":"925005"}],
	    disabled : true,
	    value: "925005",
	});
  
	//合作层级
	$('#parterLevel').omCombo({
	    dataSource:<%=Constant.getCombo("isParterLevel")%>,
	    emptyText:'请选择',
	    editable:false
	});
	
	//渠道大类
	$('#channelCategory').omCombo({
	    dataSource: [{"text":"直销业务","value":"19001"}],
	    value: "19001",
	    disabled: true
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
	
	//加载日期控件
	$('#validDate').omCalendar();
	$('#expireDate').omCalendar();
	$('#signDate').omCalendar();
  
	//经办部门
	$("#deptDropListTree").omTree({
	     dataSource:"<%=_path%>/department/queryDeptDropList.do",
	     simpleDataModel:true,
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
	         ndata = $("#deptDropListTree").omTree("getParent", ndata);
	      }
	      $("#processDeptCode").val(departCode);
	      $("#processDeptCname").val(departCode+'-'+text);
	      $("#parentChannelName").val('请选择');
	      $("#processDeptCname").focus();
	      // 隐藏
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
	$("#processDeptCname").click(function() {
	   showDropList();
	});
	//定位下拉框
	function showDropList() {
	   var cityInput = $("#processDeptCname");
	   var cityOffset = cityInput.offset();
	   var topnum = cityOffset.top+cityInput.outerHeight();
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
		   $("#personIframe").attr("src","<%=_path%>/view/demo/selectUserIframe.jsp?deptCode="+$("#processDeptCode").val());
		}
	});
	
	//选择上级企业
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
	   
	   $.validator.addMethod("processDeptCnameRequired", function(value) {
	       return value != '请选择';
	    }, '经办部门必选');
	   
	   $.validator.addMethod("processUserNameRequired", function(value) {
	       return value != '请选择';
	    }, '经办人必选');
	    
	   $.validator.addMethod("parentChannelNameRequired", function(value) {
	       return value != '请选择';
	    }, '上级渠道必选');
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

//定义校验规则,此规则页面加载的时执行
var mediumConferRule = {
  mediumCnameformMap:{
      required:true,
      maxlength:50
  },
  deptCodeformMap:{
  	required:true
  },
  officeAddressformMap:{
      maxlength:100
  },
  processDeptCnameformMap:{
  	processUserNameRequired: true
  },
  processUserNameformMap:{
      processUserNameRequired: true
  },
  channelCategoryformMap:{
      required:true
  },
  parterLevelformMap:{
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
  validDateformMap:{
      required:true,
      isDate:true
  },
  contactformMap:{
      maxlength:25
  },
  parentChannelNameformMap:{
      parentChannelNameRequired:true
  },
  parentMediumCodeformMap:{
      maxlength:50
  },
  mediumEnameformMap:{
      maxlength:200
  },
  areaCodeformMap:{
      maxlength:30
  }
};

//定义校验的显示信息
var mediumConferMessages = {
  mediumCnameformMap:{
      required:'企业名称不能为空',
      maxlength:'企业名称最长50位'
  },
  deptCodeformMap:{
      required:'机构部门必选'
  },
  officeAddressformMap:{
      maxlength:'办公地址最长100位'
  },
  processDeptCnameformMap:{
      required:'经办部门必选'
  },
  channelCategoryformMap:{
      required:'渠道大类必选'
  },
  parterLevelformMap:{
    required:'合作层级必选'
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
  signDateformMap:{
      required:'与企业签约时间不能为空'
  },
  contactformMap:{
      maxlength:'联系人最长25个字符'
  },
  parentMediumCodeformMap:{
      maxlength:"上级企业编码最长50位"
  },
  mediumEnameformMap:{
      maxlength:"企业英文名称最长200位"
  },
  areaCodeformMap:{
      maxlength:"地区代码最长30位"
  }
};

//校验
function initValidate(){
  //将name属性修改进行验证
  $("#baseInfo").find("input[name^='formMap']").each(function(){
      $(this).attr("name",$(this).attr("id")+"formMap");
  });
  //经办机构
  var processDeptCode = $('#processDeptCode').val();
  if(processDeptCname == '请选择') $('#processDeptCode').val('');
  //校验信息
  $("#baseInfo").validate({
      rules: mediumConferRule,
      messages: mediumConferMessages,
      errorPlacement: function(error, element) {
          if (error.html()) {
              $(element).parents().map(function() {
                  if (this.tagName.toLowerCase() == 'td') {
                      var attentionElement = $(this).next().children().eq(0);
                      attentionElement.css({'display':'block'});
                      attentionElement.next().html(error);
                  }
              });
          }
      },
      showErrors: function(errorMap, errorList) {
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
          //name属性还原,以便提交
          $("#baseInfo").find("input[name$='formMap']").each(function(){
              $(this).attr("name","formMap['"+$(this).attr("id")+"']");
          });
          //等待提示
          $.omMessageBox.waiting({
              title:'请等待',
              content:'服务器正在处理请求...'
          });
          //提交保存
          Util.post("<%=_path%>/enterprise/saveEnterprise.do", $("#baseInfo").serialize(), function(data) {
                  $.omMessageBox.waiting('close');
                  if(data == "success"){
                      $.omMessageBox.alert({
                          type:'success',
                          title:'成功',
                          content:'企业信息保存成功',
                          onClose:function(value){
                              window.location.href = "enterprise.jsp";
                              return true;
                          }
                      });
                  }
          });
      }
  });
}

//选择经办人
function selPerson(){
  var processDeptCode = $("#processDeptCode").val();
  if(processDeptCode == ''){
      $.omMessageBox.alert({
          type:'warning',
          title:'警告',
          content:'请先选择经办部门，再选择经办人！'
      });
  } else {
      $("#user-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
  }
}

//选择上级渠道
function selParentMedium(){
  var processDeptCode = $("#processDeptCode").val();
  if (processDeptCode == '') {
      $.omMessageBox.alert({
          type:'warning',
          title:'警告',
          content:'请先选择经办部门，再选择上级渠道！',
      });
  } else {
      $("#medium-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
  }
}

//填充数据（选择经办人）
function fillBackAndCloseDialog(rowData) {
	var obj1 = rowData.salesmanCname;
	var obj2 = obj1.replace(")","");
	var arr1 = obj2.split("(");
    $("#processUserCode").val(arr1[1]); //104036723
    $("#processUserName").val(rowData.salesmanCname); //郑仲铭(104036723)
    $("#user-dialog-model").omDialog('close');
    $("#processUserName").focus();
}

//填充数据（选择上级机构）
function fillMediumBackAndCloseDialog(rowData) {
    if(rowData.channelCode == '--' || rowData.channelCode == '' || rowData.channelCode == '无'){
        $("#parentChannelName").val("无");
        $("#parentChannelCodel").val("");
    }else{
        $("#parentChannelCode").val(rowData.channelCode);
        $("#parentChannelName").val(rowData.channelCode+'-'+rowData.mediumCname);
    }
    //如果上级渠道的合作层级隶属于总对总，新增渠道的合作层级为总对总；如果上级渠道的合作层级隶属于分对分，则新增渠道的合作层级为分对分
    if(rowData.parterLevel == '隶属于总对总'){
       rowData.parterLevel = '195001';
    }else if(rowData.parterLevel == '隶属于分对分'||rowData.parterLevel == undefined||rowData.parterLevel == '--'){
       rowData.parterLevel = '195002';
    }else{
       rowData.parterLevel = '';
    }
    $('#parterLevel').omCombo({value:rowData.parterLevel});
    $("#medium-dialog-model").omDialog('close');
    $("#parentChannelName").focus();
}

//保存操作
function save(){
  $("#baseInfo").submit();
}

//重置
function reset(){
  window.location.href = "<%=_path%>/view/partner/enterpriseAdd.jsp";
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
	<div>
		<table class="navi-no-tab">
			<tr><td>新增企业合作伙伴</td></tr>
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
							<td style="padding-left:30px" align="right"><span class="label">企业中文名称：</span></td>
							<td style="vertical-align: middle;"><input name="formMap['mediumCname']" id="mediumCname" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">企业英文名称：</span></td>
							<td><input type="text" name="formMap['mediumEname']" id="mediumEname" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">渠道编码：</span></td>
							<td><input type="text" name="formMap['channelCode']" id="channelCode" readonly="readonly" value="系统生成"/></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
						<tr>	
							<td style="padding-left:30px" align="right"><span class="label">签约时间：</span></td>
                            <td><input class="sele" type="text" name="formMap['signDate']" id="signDate" onblur="formatDate(this);" /><span class="asterisk">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">业务线：</span></td>
							<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" readonly="readonly"/><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">渠道大类：</span></td>
							<td><input class="sele" name="formMap['channelCategory']" id="channelCategory" readonly="readonly"/><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
                        <tr>
							<td style="padding-left:30px" align="right"><span class="label">渠道来源：</span></td>
							<td><input class="sele" name="formMap['channelFlag']" id="channelFlag" readonly="readonly" /><span id="channelFlag" class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
							<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['processDeptCname']" id="processDeptCname" readonly="readonly" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';"/><span id="choose" name="choose" class="om-combo-trigger"></span></span><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">上级渠道：</span></td>
							<td><input name="formMap['parentChannelName']" id="parentChannelName" readonly="readonly" onclick="selParentMedium();" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
                        <tr>    
							<td style="padding-left:30px" align="right"><span class="label">合作层级：</span></td>
							<td><input class="sele" name="formMap['parterLevel']" id="parterLevel" /><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">经办人：</span></td>
							<td><input name="formMap['processUserName']" id="processUserName" readonly="readonly" onclick="selPerson();" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';"/><span class="asterisk">*</span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
                            <td style="padding-left:30px" align="right"><span class="label">银行帐号：</span></td>
                            <td><input type="text" name="formMap['bankAccount']" id="bankAccount" /><span class="asterisk">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
						</tr>
                        <tr>
                            <td style="padding-left:30px" align="right"><span class="label">开户行所在省：</span></td>
                            <td><input class="sele" name="formMap['bankProvince']" id="bankProvince" /><span class="asterisk">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                            <td style="padding-left:30px" align="right"><span class="label">开户行所在市：</span></td>
                            <td><input class="sele" type="text" name="formMap['bankCity']" id="bankCity" /><span class="asterisk">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                            <td style="padding-left:30px" align="right"><span class="label">收款方银行：</span></td>
                            <td><input class="sele" name="formMap['bankReceive']" id="bankReceive" /><span class="asterisk">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        </tr>
                        <tr>
                            <td style="padding-left:30px" align="right"><span class="label">开户行网点：</span></td>
                            <td><input class="sele" name="formMap['bankNode']" id="bankNode"/><span class="asterisk">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                            <td style="padding-left:30px" align="right"><span class="label">账户名称：</span></td>
                            <td><input name="formMap['bankName']" id="bankName" /><span class="asterisk">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">所属行业：</span></td>
							<td><input class="sele" name="formMap['profession']" id="profession" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        </tr>
                        <tr>
							<td style="padding-left:30px" align="right"><span class="label">公司联系人：</span></td>
							<td><input name="formMap['contact']" id="contact" /><span class="asterisk"></span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">联系电话：</span></td>
							<td><input name="formMap['tel']" id="tel" /><span class="asterisk"></span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							<td style="padding-left:30px" align="right"><span class="label">办公地址：</span></td>
							<td><input name="formMap['officeAddress']" id="officeAddress" /><span class="asterisk"></span></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        </tr>
                        <tr>
							<td style="padding-left:30px" align="right"><span class="label">地区代码：</span></td>
							<td><input type="text" name="formMap['areaCode']" id="areaCode" /></td>
							<td><span class="errorImg"></span><span class="errorMsg"></span></td>   
							<td style="padding-left:30px" align="right"><span class="label">备注：</span></td>
							<td colspan="12"><textarea style="width:450px;" rows="2" name="formMap['remark']" id="remark"></textarea>
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
	<div>
		<table style="width:100%; margin-top:20px;">
			<tr>
				<td align="center">
				<a class="om-button" id="button-save" onclick="save()">保存</a>
				<a class="om-button" id="button-reset" onclick="reset()">清空</a>
				<a class="om-button" href="javascript: window.location.href = 'enterprise.jsp'; " id="button-cancel" onclick="cancel()">返回</a></td>
			</tr>
		</table>
	</div>
	<div id="user-dialog-model" title="选择经办人">
		<iframe id="personIframe" frameborder="0" style="width: 100%; height: 99%; height: 100%; overflow-y:hidden; " src="about:blank"></iframe>
	</div>
	<div id="medium-dialog-model" title="选择上级渠道">
		<iframe id="mediumIframe" frameborder="0" style="width: 100%; height: 99%; height: 100%; overflow-y:hidden; " src="about:blank"></iframe>
	</div>
</body>
</html>