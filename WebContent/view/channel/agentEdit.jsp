<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser,com.hf.framework.util.UUIDGenerator"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<style type="text/css">
html,body{height:100%;margin:0;padding:0}
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
.deptDropListTree{height:250px;width:151px;border:1px solid #9aa3b9;overflow:auto;display:none;position:absolute;background:#FFF;z-index:4}
.tables{position:relative;z-index:3}
</style>
<title>个人代理人编辑</title>
<%
String channelCode = request.getParameter("channelCode");
String tabFlag = request.getParameter("flag");
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var tabFlag = '<%=tabFlag%>';

var uploadId = "<%=UUIDGenerator.getUUID()%>";
var operateEmp = "<%=CurrentUser.getUser().getUserCode()%>";

var currentUploadId;
var expireDate;
var validDate;

//经办部门是否修改
var jbDeptCode1 ="", jbDeptCode2 ="";

$(function(){
	$("#baseInfo").find("input[name^='formMap']").css({"width":"150px"});
	$("#agentConferFilterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	
	//给该隐藏域赋值，为查询个人代理人和相关附件信息提供数据（外键）
	$('#channelCode_fk').val(channelCode);
	//给该隐藏域赋值，为查询相关协议提供数据（外键）
	$('#channelCode_fk_confer').val(channelCode);
	//给联系人增加个人代理人编码
	$('#contactCode_fk').val(channelCode);
	
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
	
	/*******基本信息**********/
	//渠道大类
	$('#channelCategory').omCombo({
		dataSource : [{text:'代理业务',value:'19002'}],
        editable : false,
        value : '19002',
        readOnly : true
    });
	
	//渠道类型
	$('#channelType').omCombo({
		dataSource : [{text:'个人代理',value:'1900203'}],
        editable : false,
        value : '1900203',
        readOnly : true
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
        editable : false
    });
    
    //身份证件类型
	$('#certifyType').omCombo({
		dataSource : "<%=_path%>/common/queryCertifyType.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : true,
		filterStrategy : 'anywhere'
    });
    
	//性别
	$('#sex').omCombo({
        dataSource : <%=Constant.getCombo("sex")%>,
        emptyText : '请选择',
        editable : false
    });
    
    //学历
	$('#educatioin').omCombo({
		dataSource : "<%=_path%>/common/queryEducatioin.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : true,
		filterStrategy : 'anywhere'
    });
    
	//职业
	$('#title').omCombo({
		dataSource : "<%=_path%>/common/queryTitle.do",
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : true,
		filterStrategy : 'anywhere'
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
        }
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
        editable : false
    });
	//银行网点
	$("#bankNode").omCombo({
		optionField : function(data, index) {
	        return data.text;
		},
		filterStrategy : 'anywhere',
        listAutoWidth : true
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
	//业务线
	$("#businessLine").omCombo({
		dataSource : "<%=_path%>/agent/getAgentEditBusinessline.do?channelCode="+channelCode,
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	//加载个人代理人详细信息
	Util.post("<%=_path%>/agent/queryAgents.do",$("#agentContectFrm").serialize(),function(data) {
		    //原来的经办部门
		    jbDeptCode1 = data[0].deptCode;
			//为新增协议提供校验信息
			/*var licenseValidDate = data[0].licenseValidDate;
			var licenseExpireDate = data[0].licenseExpireDate;
			var businessValidDate = data[0].businessValidDate;
			var businessExpireDate = data[0].businessExpireDate;
			//取资格证号生效日期、展业证生效日期的最大值
			if(businessValidDate == "" || businessValidDate == "undefined" || businessValidDate == null){
				validDate = licenseValidDate;
			}else{
				if(licenseValidDate >= businessValidDate){
					validDate = licenseValidDate;
				}else{
					validDate = businessValidDate;
				}
			}
		    //取资格证号失效日期、展业证失效日期的最小值
			if(businessExpireDate == "" || businessExpireDate == "undefined" || businessExpireDate == null){
				expireDate = licenseExpireDate;
			}else{
				if(licenseExpireDate >= businessExpireDate){
					expireDate = businessExpireDate;
				}else{
					expireDate = licenseExpireDate;
				}
			}*/
			
			//执业证号起止日期
			validDate = data[0].qualificationValidDate;
			expireDate = data[0].qualificationExpireDate;

			//填充输入框
			$("#baseInfo").find(":input").each(function(){
				if($(this).val() != null || $(this).val() != "")
				   $(this).val(data[0][$(this).attr("id")]);
			});
		    $('#birthday').omCalendar({date : new Date(2010, 7, 15)});
			//渠道大类
			$('#channelCategory').omCombo({value : data[0].channelCategory});
			//渠道类别
			$('#channelType').omCombo({value : data[0].channelType});
			//是否理财险渠道
			$('#financeFlag').omCombo({value : data[0].financeFlag});
			//渠道特征
			$('#channelFeature').omCombo({value : data[0].channelFeature});
		    //身份证件类型
			$('#certifyType').omCombo({value : data[0].certifyType});
			//性别
			$('#sex').omCombo({value : data[0].sex});
		    //学历
			$('#educatioin').omCombo({value : data[0].educatioin});
			//职业
			$('#title').omCombo({value : data[0].title});
			//收款方银行
			$('#bankReceive').omCombo({value : data[0].bankReceive});
			//开户行所在省
			$('#bankProvince').omCombo({value : data[0].bankProvince});
			//开户行所在市
			$('#bankCity').omCombo({
				dataSource : "<%=_path%>/common/queryCity.do?province="+data[0].bankProvince,
		        value : data[0].bankCity
			});
			//下级单位可以查看
			$('#childDeptLook').omCombo({value : data[0].childDeptLook});
			//开户行网点
			$('#bankNode').omCombo({
				dataSource : "<%=_path%>/common/queryBankNode.do?bank="+data[0].bankReceive+"&city="+data[0].bankCity,
				value : data[0].bankNode
			});
			//是否有不良记录
			$('#mistakeFlag').omCombo({value : data[0].mistakeFlag});
			//业务线
			$('#businessLine').omCombo({value : data[0].businessLine});
    });
	
	//资格证号
    $('#licenseValidDate').omCalendar({editable:false});
    $('#licenseExpireDate').omCalendar();
    
    //展业证号
    $('#businessValidDate').omCalendar({editable:false});
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
         //变更后的经办部门
         jbDeptCode2 = ndata.departCode;
        
         ndata = $("#deptDropListTree").omTree("getParent", ndata);
         while (ndata) {
	        //text = ndata.text + "-" + text;
	        ndata = $("#deptDropListTree").omTree("getParent", ndata);
         }
         //经办机构
         $("#deptCname").val(departCode+'-'+text);
         $("#deptCode").val(departCode);
         $("#deptCname").focus();
         //
         hideDropList();
       },
       //
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
   
   //显示机构
   function showDropList() {      
	  var cityInput = $("#deptCname");
   	  var cityOffset = cityInput.offset();
   	  var topnum = cityOffset.top+cityInput.outerHeight();
   	  var leftnum = cityOffset.left-1;
   	  if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	  topnum = topnum + 2;
      }
      //显示机构
      $("#deptDropListTree").css({"margin-left": leftnum + "px","margin-top": topnum +"px"}).show();
      //body绑定mousedown事件
      $("body").bind("mousedown", onBodyDown);
   }
   //隐藏机构
   function hideDropList() {
      $("#deptDropListTree").hide();
      $("body").unbind("mousedown", onBodyDown);
   }
   //隐藏机构
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
   
   
   //加载个人代理人附件信息
   Util.post(
		"<%=_path%>/upload/queryUploadByMainId.do?mainId="+channelCode+"&module=03",
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
   //初始化页面保存、重置、取消按钮
   $("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
   $("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});

	/************协议管理*********************/
	$("#agent-confer-search-panel").omPanel({
		title : "个人代理人协议管理",
		collapsible:true,
		collapsed:false
	});
	
	$('#conferSignDate').omCalendar();
	
	//个代协议按钮菜单
	$('#agentConferButtonbar').omButtonbar({
	       	btns : [{label:"新增",
	           		     id:"addAgentConferButton" ,
	           		     icons : {left : '<%=_path%>/images/add.png'},
	           	 		 onClick:function(){
		           	 			var conferJsonData = JSON.stringify($('#agentConferTables').omGrid('getData'));
	           	 				var jsonRows = eval("["+conferJsonData+"]")[0].rows;
	           	 				var maxExpireDate;
	           	 				//如果有协议，则取协议的截止日期，如果无协议，则取执业证号有效期自。
	           	 				if(jsonRows.length > 0){
	           	 					maxExpireDate = jsonRows[0].expireDate; //取协议的截止日期
	           	 				}else{
	           	 					maxExpireDate = ''; //取执业证号有效期自
	           	 				}
		           	 			//机构编码
		           	 			var deptCode = $('#deptCode').val();
		           	 			//机构部门
		           	 			var deptName = $('#deptCname').val();
		           	 			//个人代理人编码
		           	 			var channelCode = $('#channelCode').val();
		           	 			//个人代理人姓名
		           	 			var channelName = $('#channelName').val();
		           	 			//是否理财渠道
		           	 			var financeFlag = $('#financeFlag').val();
		           	 			//渠道系数
		           	 			var channelRate = $('#channelRate').val();
		           	 			//渠道特征
		           	 			var channelFeature = $('#channelFeature').val();
	       	 			 		window.location.href = "agentConferAdd.jsp?channelCode="+channelCode
	       	 			 				+"&channelName="+channelName+"&deptCode="+deptCode+"&deptName="+deptName
	       	 			 				+"&financeFlag="+financeFlag+"&channelRate="+channelRate+
	       	 			 				"&channelFeature="+channelFeature+"&expireDate="+expireDate+
	       	 			 				"&maxExpireDate="+maxExpireDate+"&validDate="+validDate;
	       	 			 }
	       			},
	       			{separtor:true},
	       	        {label:"维护",
	       			 	id:"updaAgentConferButton",
	       			 	icons : {left : '<%=_path%>/images/op-edit.png'},
	       	 		 	onClick:function(){
	       	 		 		var rows = $('#agentConferTables').omGrid("getSelections",true);
	       	 		 		var row = eval(rows);
	       	 		 		if(row.length != 1){
	    	 		 			$.omMessageBox.alert({
	        	 		 	        content:'请选择一条记录编辑',
	        	 		 	        onClose:function(value){
	        	 		 	        	return false;
	        	 		 	        }
	    	 		 	        });
	       	 		 		}else{
	       	 		 			//只能查看互联网协议
	       	 		           if(row[0].conferType != 'H'){ 
	       	 		         	  window.location.href = "agentConferEdit.jsp?conferCode="+row[0].conferCode+"&channelCode="+channelCode+"&expireDate="+expireDate;
	       	 		           }else{	       	 		          	 
	       	 		        		$.omMessageBox.alert({
		  		                      content:'您不能维护互联网协议！',
		  		                      onClose:function(value){
		  		                          return false;
		  		                      }
		  		                  	});
	       	 		           }
	       	 		 		}
	       	 		 	}
	       	        },
	       	        {separtor:true},
           	        {label:"详情",
           			 	id:"queryAgentConferButton",
           			 	icons : {left : '<%=_path%>/images/detail.png'},
           	 		 	onClick:function(){
	           	 		 	var rows = $('#agentConferTables').omGrid("getSelections",true);
	       	 		 		var row = eval(rows);
		       	 		 	if(row.length != 1){
	    	 		 			$.omMessageBox.alert({
	        	 		 	        content:'请选择一条记录查看',
	        	 		 	        onClose:function(value){
	        	 		 	        	return false;
	        	 		 	        }
	    	 		 	        });
	       	 		 		}else{
	       	 		 		   window.location.href = "agentConferDetail.jsp?conferCode="+row[0].conferCode+"&channelCode="+channelCode;
	       	 		 		}
           	 		 	}
           	        },
	       			{separtor:true},
	       	        {label:"删除",
	       	        	id:"delAgentConferButton",
	       	        	icons : {left : '<%=_path%>/images/remove.png'},
	       	        	onClick:function(){
	       	        		var rows = $('#agentConferTables').omGrid("getSelections",true);
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
							       	 		 					$('#agentConferTables').omGrid({});
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
          	        		var dels = $('#agentConferTables').omGrid('getSelections',true);
          	        		var del = eval(dels);
          	        		var conferCodes = "";
          	            	if(del.length == 0 ){
          	            		$.omMessageBox.alert({
            	 		 	        content:'请选择一条记录操作',
            	 		 	        onClose:function(value){
            	 		 	        	return false;
            	 		 	        }
        	 		 	        });
          	            	}else if(del[0].conferType == 'H'){
	                            $.omMessageBox.alert({
	                              content:'您不能审核互联网服务协议',
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
 						       	    	 		 	        content:'审核代理人协议成功',
 						       	    	 		 	        onClose:function(value){
 							       	 		 					//刷新列表
 							       	 		 					$('#agentConferTables').omGrid({});
 						       	    	 		 	        	return true;
 						       	    	 		 	        }
 						       		 		 	        });
 					       	 		 				} else {
     					       	 		 				$.omMessageBox.alert({
 						       	        					type:'error',
 						       	        	                title:'失败',
 						       	    	 		 	        content:'审核代理人协议失败<br/>'+data.msg,
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
        	 		 		var rows = $('#agentConferTables').omGrid("getSelections",true);
        	 		 		var row = eval(rows);
        	 		 		if(row.length != 1){
        	 		 			$.omMessageBox.alert({
            	 		 	        content:'请选择一条记录',
            	 		 	        onClose:function(value){
            	 		 	        	return false;
            	 		 	        }
        	 		 	        });
	       	 		 		}else{
        	 		 			window.location.href = "agentConferHistorys.jsp?conferId="+row[0].conferId+"&conferCode="+row[0].conferCode+"&channelCode="+channelCode;;
        	 		 		}
        	 		 	}
        	        }
	       	]
	});

	var heightNum = 450;
	if($.browser.msie&&($.browser.version == "8.0"||$.browser.version == "9.0"||$.browser.version == "10.0")){
		heightNum = heightNum + 35;
    }
	
	//初始化协议列表
	$("#agentConferTables").omGrid({
		showIndex : false,
		singleSelect : false,
	    height: heightNum,
        limit : 15,
	    method : 'POST',
	    colModel : [{header:"协议号",name:"conferId",width:120},
	    			{header:"协议补充号",name:"extendConferCode",width:80},
	         		{header:"经办部门编码",name:"deptCode",width:80},
	        		{header:"经办部门",name:"deptCname",width:150},
	        		{header:"个人代理人编码",name:"channelCode",width:120},
	        		{header:"姓名",name:"channelName",width:80},
	        		{header:"审核状态",name:"approveFlag",width:80},
	        		/* {header:"审核人",name:"approveCode",width:80}, */
	        		{header:"签定日期", name:"signDate",width:100},
	        	 	{header:"生效日期", name:"validDate",width:100},
	        	 	{header:"截止日期", name:"expireDate",width:100},
	        	 	{header:"结费周期（天）",name:"calclatePeriod",width:100},
	        	 	{header:"是否理财渠道", name:"financeChannel",width:100},
	        	 	{header:"渠道特征", name:"feature",width:80},
	        	 	{header:"渠道系数", name:"rate",width:80}],
			dataSource : "<%=_path%>/mediumConfer/queryAgentConfer.do?"+$("#agentContectFrm").serialize()
	});
	
	$("#agent-confer-button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	//查询协议列表操作
	queryAgentConfer();
	
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
    
    
    $.validator.addMethod("gtLicenseValidDate", function(value) {
    	var validDate = $("#licenseValidDate").val();
        return value > validDate;
 	}, '此日期应大于资格证生效日期');   
    $.validator.addMethod("gtBusinessValidDate", function(value) {
    	var validDate = $("#businessValidDate").val();
        return value > validDate;
 	}, '此日期应大于执业证生效日期');
    
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
        return value != '';
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
	var contactRole = 'headDeptSalesmanAgentNew,subDeptMangerNew,xszcAdmin'; 
	$.ajax({url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName="+contactRole, type:"post", async:false, dataType:"JSON", success:function(data){
	    if(!data){tabHead.splice(0, 1);} 
	}}); 
	
	$.ajax({ 
		url: "<%=_path%>/common/queryCurrUserRoleEname.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			if(data.indexOf("head")==-1 && data.indexOf("xszcAdmin")==-1 && data.indexOf("subDept") == -1){
				$("#processButton").remove();
				$(".om-buttonbar-sep:last").remove();
				$("#historyButton").remove();
				$(".om-buttonbar-sep:last").remove();
			}
		}
	});
  
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
      }else if ("G" === value) {
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
	  
	  $.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=xszcAdmin,headDeptSalesmanAgentNew",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			if(data === "false"){
				$("#delAgentConferButton").remove();
				$(".om-buttonbar-sep:last").remove();
			}
		}
	});
    
  	/*
  	 * 功能：1.系统管理员可以修改（机构不能修改）:渠道大类/渠道类型/是否协作人/协议代理人/业务线
  	 *     2.由于是个代，渠道大类/渠道类型异动不可修改，无是否协作人、协议代理人选项，所以只需要控制业务线
  	 * 作者：sunyf
  	 * 日期：2014-04-15
  	 */
  	$.ajax({ 
  		url:"<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=xszcAdmin,existRolesInSystemByUserCode",
  		type:"post",
  		async:true, 
  		dataType:"JSON",
  		success:function(data){
  		  if (data) {
  		     $("#businessLine").omCombo({readOnly:false}).next(".sele").css({"background-color":"#FFFFFF"});
  		  }
  		}
  	}); 
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

/**
 * 文件上传下载通用方法（异步获取数据）
 */
function getImg (domId,data){
	if(data != '' && data != undefined){
		currentUploadId = data.uploadId;
		$(domId).haImg({
			title : '个人代理人证件',
			modelCode : 'XSZC010103',
			mainBillNo : data.mainId,
			seriesNo : data.uploadId,
			srcUrl : '${sessionScope.imgUrl}',
			operateEmp : data.updatedUser
	    });
	}else{
		currentUploadId = uploadId;
		$(domId).haImg({
			title : '个人代理人证件',
			modelCode : 'XSZC010103',
			mainBillNo : "",
			seriesNo : uploadId,
			srcUrl : '${sessionScope.imgUrl}',
			operateEmp : operateEmp
		});
	}
}

//是否校验资格证号
var isLicenseNo = true;
/*$.ajax({
	url:"/agent/queryChannelLicenseValid.do",
	type:"post",
	async:false,
	dataType:"JSON",
	success:function(msg){
		if(msg){
			isLicenseNo = false;
		}
	}
});*/

//定义校验规则
var mediumConferRule = {
	channelCategoryformMap:{
		required : true
	},channelTypeformMap:{
		required : true
	},channelCodeformMap:{
		required : true,
		isLetterAndInteger : true,
		maxlength : 50
	},channelNameformMap:{
		required : true,
		maxlength : 25
	},/* financeFlagformMap:{
		required : true
	}, */channelRateformMap:{
		//required : true,
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
		isDate: isLicenseNo
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
	},
	qualificationNoformMap:{
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
	},channelCodeformMap:{
		required : '个人代理人编码不能为空',
		isLetterAndInteger : '个人代理人编码必须是数字和字母',
		maxlength : '个人代理人编码最长50位'
	},channelNameformMap:{
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
	},
	qualificationNoformMap:{
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
		required : '机构部门编码不能为空'
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
        	//
        	$.omMessageBox.waiting({
                title:'请等待',
                content:'服务器正在处理请求...'
            });
        	//保存
        	Util.post("<%=_path%>/agent/updateAgent.do?",$("#baseInfo").serialize(),function(data) {
          	    var msgContent = '保存成功';
       		    if (jbDeptCode1 != '' && jbDeptCode2 != '' && jbDeptCode1 != jbDeptCode2) {
       		    	msgContent += '，您修改了渠道的经办部门，如果该渠道有协议，请到协议维护页面审核协议!';
                }
   				$.omMessageBox.waiting('close');
   				$.omMessageBox.alert({
   					type:'success',
                    title:'提示',
 		 	        content:msgContent,
 		 	        onClose:function(value){
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

//取消操作
function cancel(){
	window.location.href = "agent.jsp";
}

//查询个人代理人协议列表操作
function queryAgentConfer(){
	$("#agentConferTables").omGrid("setData","<%=_path%>/mediumConfer/queryAgentConfer.do?"+$("#agentConferFilterFrm").serialize());
}

//是否显示校验的星号
function hideValidateStar(){
	$.ajax({
		url:"/agent/queryChannelLicenseValid.do",
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
<body onload="hideValidateStar()">
	<div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
	<div id="make-tab" >
		<ul>
	       <li><a href="#agent" id="tab1">个人代理人管理</a></li>
	       <li><a href="#agentConfer" id="tab2">个人代理人协议管理</a></li>
	    </ul>
		<div id="agent">
			<div>
				<table style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
					<tr><td>个人代理人维护</td></tr>
				</table>
			</div>
			<div>
					<form id="baseInfo">
					<fieldSet style="margin-top: 10px;">
					<legend style="margin-left: 40px;">基本信息</legend>
						<table>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">个人代理人姓名：</span></td>
								<td><input name="formMap['channelName']" id="channelName"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">个人代理人编码：</span></td>
								<td><input type="text" name="formMap['channelCode']" id="channelCode" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
								<td><span class="om-combo om-widget om-state-default"><input class="sele" type="text" name="formMap['deptCname']" id="deptCname"/><span id="choose" name="choose" class="om-combo-trigger"></span></span><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span>
								<input type="hidden" name="formMap['deptCode']" id="deptCode" /></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">渠道大类：</span></td>
								<td><input class="sele" name="formMap['channelCategory']" id="channelCategory" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">渠道类型：</span></td>
								<td><input class="sele" name="formMap['channelType']" id="channelType" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">业务线：</span></td>
								<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" readonly="readonly" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span>
								<!--附件id字符串 --> 
								<input type="hidden" name="uploadId" id="uploadId" /></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">是否理财险渠道：</span></td>
								<td><input class="sele" type="text" name="formMap['financeFlag']" id="financeFlag"/></td>
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
								<td><input class="sele" name="formMap['channelFeature']" id="channelFeature"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">身份证件类型：</span></td>
								<td><input class="sele" name="formMap['certifyType']" id="certifyType" /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">证件号码：</span></td>
								<td><input name="formMap['certifyNo']" id="certifyNo"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<!-- 按监管要求：资格证号、有效期自、有效期至、展业证号、有效期有效期自、有效期至。这六项可以删除（如暂时无法删除，请均修改为非必录项） 20150930 -->
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">资格证号：</span></td>
								<td><input name="formMap['licenseNo']" id="licenseNo" /><span id="spanLicenseNo" style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
								<td><input class="sele" name="formMap['licenseValidDate']" id="licenseValidDate" onblur="formatDate(this);"/><span id="spanLicenseValidDate" style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
								<td><input class="sele" name="formMap['licenseExpireDate']" id="licenseExpireDate" onblur="formatDate(this);"/><span id="spanLicenseExpireDate" style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
							</tr>
							<tr>
								<td style="padding-left:30px" align="right"><span class="label">展业证号：</span></td>
								<td><input name="formMap['businessNo']" id="businessNo"  /><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">有效期自：</span></td>
								<td><input class="sele" name="formMap['businessValidDate']" id="businessValidDate" onblur="formatDate(this);"/><span style="color:red">*</span></td>
								<td><span class="errorImg"></span><span class="errorMsg"></span></td>
								<td style="padding-left:30px" align="right"><span class="label">有效期止：</span></td>
								<td><input class="sele" name="formMap['businessExpireDate']" id="businessExpireDate" onblur="formatDate(this);"/><span style="color:red">*</span></td>
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
								<td><input class="sele" name="formMap['birthday']" id="birthday" onblur="formatDate(this);"/><span style="color:red">*</span></td>
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
				<fieldSet style="margin-top: 10px;">
					<legend style="margin-left: 40px;">账户信息</legend>
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
				</form>
			</div>
			<!-- 联系人列表 -->
			<div id="contactInfo">
				<fieldSet>
					<legend>联系信息</legend>
					<div id="buttonbar" style="border-style:none none solid none;"></div>
					<table id="tables"></table>
					<form id="agentContectFrm">
						<input type="hidden" name="formMap['channelCode']" id="contactCode_fk" value="" />
					</form>
				</fieldSet>
			</div>
			<!-- 附件上传框 -->
<!-- 			<div id="program-upload-download" style="height:240px;"> -->
<!-- 				<form id="agentContectFrm"> -->
<!-- 					<input type="hidden" name="formMap['channelCode']" id="channelCode_fk" value="" /> -->
<!-- 				</form> -->
<!-- 			</div> -->
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
						<a id="button-save" onclick="save()">保存</a>
						<a id="button-cancel" onclick="cancel()">取消</a></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="agentConfer">
			<form id="agentConferFilterFrm">
				<div id="agent-confer-search-panel">
					<table>
						<tr>
							<td style="padding-left:15px" align="right"><span class="label">协议号：</span></td>
							<td><input type="text" name="formMap['conferId']" id="conferId" /></td>
							<td style="padding-left:15px" align="right"><span class="label">签订日期：</span></td>
							<td><input class="sele" type="text" name="formMap['signDate']" id="conferSignDate" /></td>
							<td colspan="4" style="padding-left:15px;padding-top:5px;" align="right"><span id="agent-confer-button-search" onclick="queryAgentConfer()">查询</span><input type="hidden" name="formMap['channelCode']" id="channelCode_fk_confer" value="" /></td>
						</tr>
					</table>
				</div>
			</form>
			<div id="agentConferButtonbar"></div>
			<div id="agentConferTables"></div>
		</div>
	</div>
</body>
</html>