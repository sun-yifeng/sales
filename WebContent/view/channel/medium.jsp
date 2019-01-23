<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<style type="text/css">
.buttonbar {
	position: relative;
	z-index: 3;
}

.tables {
	position: relative;
	z-index: 3;
}

.deptDropListTree {
	height: 250px;
	width: 152px;
	border: 1px solid #9AA3B9;
	overflow: auto;
	display: none;
	position: absolute;
	background: #FFF;
	z-index: 4;
}
</style>
<title>合作机构管理</title>
<script type="text/javascript">
var userDptCde = '';
var trueOrFalse; //短信开关，只有总公司的人可以配置短信开关

function queryStatusOnValueChange(){
	$("#certificateType").omCombo({onValueChange:function(target,newValue,oldValue,event){}});
	$("#certificateType").omCombo("value","");
	$("#queryValidDate").val("");
	$("#queryInvalidDate").val("");
	$("#certificateType").omCombo({onValueChange:function(target,newValue,oldValue,event){
		certificateTypeOnValueChange();
	}});
}

function certificateTypeOnValueChange(){
	$("#queryStatus").omCombo({onValueChange:function(target,newValue,oldValue,event){}});
	$("#queryStatus").omCombo("value","");
	$("#queryStatus").omCombo({onValueChange:function(target,newValue,oldValue,event){
		queryStatusOnValueChange();
	}});
}

$(function(){
	$("#filterFrm").find("input[name^='formMap'][type!='checkbox']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	$("#deptCode").css({"background-color":"#fff"});
	
	//证件有效性
	$('#certifyValid').omCombo({
		dataSource : [{"text":"请选择","value":""},{"text":"未过期","value":"0"},{"text":"已过期","value":"1"}],
        optionField : function(data, index) {
            return data.value+'-'+data.text;
		},
		valueField : 'value',
		inputField : 'text',
		value : '0'
    });
	
	//状态
	var queryStatus = [{"text":"请选择","value":""},{"text":"正在代理","value":"1"},{"text":"资质过期","value":"2"},
	                   {"text":"协议过期","value":"3"},{"text":"资质7日内过期","value":"4"},{"text":"协议7日内过期","value":"5"}];
	                   
	//类型
	var certificateType = [{"text":"请选择","value":""},{"text":"许可证有效期","value":"1"},{"text":"协议有效期","value":"2"}];
	
	$("#queryStatus").omCombo({
		dataSource:queryStatus,
		inputField:"text",
		valueField:"value",
		emptyText:"请选择",
		onValueChange:function(target,newValue,oldValue,event){ 
			queryStatusOnValueChange();
		}
	});
	
	$("#certificateType").omCombo({
		dataSource:certificateType,
		inputField:"text",
		valueField:"value",
		emptyText:"请选择",
		onValueChange:function(target,newValue,oldValue,event){ 
			certificateTypeOnValueChange();
		}
	});
	
	//起期
	$("#queryValidDate").omCalendar({
		dateFormat:"yy-mm-dd"		
	});
	
	//止期
	$("#queryInvalidDate").omCalendar({
		dateFormat:"yy-mm-dd"
	});

	Util.post("<%=_path%>/department/getDeptCodeByUser.do",'',
 			function(data) {
				userDptCde = data;
				if(userDptCde != '00'){
					trueOrFalse = true;
				}else{
					trueOrFalse = false;
				}
 			}
 		);
	 
	 //初始化按钮菜单
	 $('#buttonbar').omButtonbar({
            	btns : [{label:"新增",
	            		    id:"addButton" ,
	            		    icons : {left : '<%=_path%>/images/add.png'},
	            	 		onClick:function(){
            	 	        	window.location.href = "<%=_path%>/view/channel/mediumAdd.jsp?trueOrFalse="+trueOrFalse;
            	 			}
            			},
            			{separtor:true},
            	        {label:"维护",
            			 	id:"updateButton",
            			 	icons : {left : '<%=_path%>/images/op-edit.png'},
            	 		 	onClick:function(){
            	 		 		var rows = $('#tables').omGrid("getSelections",true);
            	 		 		var row = eval(rows);
            	 		 		if(row.length != 1){
            	 		 			$.omMessageBox.alert({
	            	 		 	        content:'请选择一条记录编辑',
	            	 		 	        onClose:function(value){
	            	 		 	        	return false;
	            	 		 	        }
            	 		 	        });
    	       	 		 		}else{
            	 		 			window.location.href = "mediumEdit.jsp?flag=0&channelCode="+row[0].channelCode+"&trueOrFalse="+trueOrFalse;
            	 		 		}
            	 		 	}
            	        },
            			{separtor:true},
            	        {label:"详情",
            	        	id:"queryButton",
            	        	icons : {left : '<%=_path%>/images/detail.png'},
            	        	onClick:function(){
            	        		var rows = $('#tables').omGrid("getSelections",true);
            	 		 		var row = eval(rows);
            	 		 		if(row.length != 1){
            	 		 			$.omMessageBox.alert({
	            	 		 	        content:'请选择一条记录查看',
	            	 		 	        onClose:function(value){
	            	 		 	        	return false;
	            	 		 	        }
            	 		 	        });
            	 		 		}else{
            	 		 			window.location.href = "mediumDetail.jsp?channelCode="+row[0].channelCode+"&paramChannelCode="+ $("#channelCode").val();
            	 		 		}
            	        	}
            	        },
              			{separtor:true},
              	        {label:"删除",
              	        	id:"delButton",
              	        	icons : {left : '<%=_path%>/images/remove.png'},
              	        	onClick:function(){
              	        		var dels = $('#tables').omGrid('getSelections',true);
              	        		var del = eval(dels);
              	            	if(del.length != 1 ){
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
              	                        	 	Util.post(
     					       	 		 			"<%=_path%>/medium/deleteMediums.do?channelCode="+del[0].channelCode,
     					       	 		 			'',
     					       	 		 			function(data) {
     					       	 		 				if(data == "success"){
     						       	 		 				$.omMessageBox.alert({
     						       	        					type:'success',
     						       	        	                title:'成功',
     						       	    	 		 	        content:'删除合作机构成功',
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
              	        {label:"审核",
              	        	id:"processButton",
              	        	icons : {left : '<%=_path%>/images/user.png'},
              	        	onClick:function(){
              	        		var dels = $('#tables').omGrid('getSelections',true);
              	        		var del = eval(dels);
              	        		var channelCodes = "";
              	            	if(del.length == 0 ){
              	            		$.omMessageBox.alert({
                	 		 	        content:'请选择一条记录操作',
                	 		 	        onClose:function(value){
                	 		 	        	return false;
                	 		 	        }
            	 		 	        });
              	            	}else if(del.length > 1){
              	            		$.omMessageBox.alert({
              						   type:'error',
              				           content:'只能选择一条记录进行操作！'
              				        });
              					    return;
              	            	}else if(del[0].approveFlag == "已审核"){
           	        				$.omMessageBox.alert({
           	        					type:'error',
                   	 		 	        content:'请选择未审核的记录操作'
               	 		 	        });
                   	 		 	    return false;
	              	        	}else if(userDptCde.length>2||userDptCde.length<1){
	              	        		$.omMessageBox.alert({
          	        					type:'error',
                	 		 	        content:'仅分公司及总公司所属人员有审核权限!'
            	 		 	        });
                	 		 	    return false;
	              	        	}
           	        				channelCodes = del[0].channelCode;
              	            		$.omMessageBox.confirm({
              	                       title:'确认审核通过',
              	                       content:'你确定要审核该记录吗？',
              	                       onClose:function(v){
              	                           if(v){
              	                        	 	Util.post("<%=_path%>/channelMain/processMediums.do?channelCodes="+channelCodes, '', function(data) {
     					       	 		 				if(data.flag == "1"){
     						       	 		 				$.omMessageBox.alert({
     						       	        					type:'success',
     						       	        	                title:'成功',
     						       	    	 		 	        content:'审核中介渠道成功！',
     						       	    	 		 	        onClose:function(value){
     							       	 		 					//刷新列表
     							       	 		 					$('#tables').omGrid({});
     						       	    	 		 	        	return true;
     						       	    	 		 	        }
     						       		 		 	        });
     					       	 		 				} else {
	     					       	 		 				$.omMessageBox.alert({
	 						       	        					type:'error',
	 						       	        	                title:'失败',
	 						       	    	 		 	        content:'审核中介渠道失败<br/>'+data.msg,
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
              	        },
            			{separtor:true},
            	        {label:"历史轨迹",
            			 	id:"historyButton",
            			 	icons : {left : '<%=_path%>/images/trace.png'},
            	 		 	onClick:function(){
            	 		 		var rows = $('#tables').omGrid("getSelections",true);
            	 		 		var row = eval(rows);
            	 		 		if(row.length != 1){
            	 		 			$.omMessageBox.alert({
	            	 		 	        content:'请选择一条记录',
	            	 		 	        onClose:function(value){
	            	 		 	        	return false;
	            	 		 	        }
            	 		 	        });
    	       	 		 		}else{
            	 		 			window.location.href = "mediumHistorys.jsp?channelCode="+row[0].channelCode;
            	 		 		}
            	 		 	}
            	        }
            	]
    });
	
	 $.ajax({ 
			url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=headDeptAdminChannelNew,xszcAdmin",
			type:"post",
			async: false, 
			dataType: "html",
			success: function(data){
				if(data === "false"){
					$("#delButton").remove();
					$(".om-buttonbar-sep:last").remove();
				}
			}
		});
	 
	var btInput = $("#buttonbar");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight()+52;
  	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }
	
	//初始化列表
	$("#tables").omGrid({
		colModel: tabHand,
		limit: 20,
		singleSelect: true,
        height: topnum,
        method: 'POST',
        autoFit: true,
        showIndex: true
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	$("#search-panel").omPanel({
    	title : "销售渠道管理  > 合作机构管理",
    	collapsible:true,
    	collapsed:false
    });	
	
	$("#channelCode").val("${param.paramChannelCode}");
	//加载初始数据
	query();
	
	hideButton();
	
	//初始化渠道类别
	$('#category').omCombo({
		dataSource : "<%=_path%>/common/queryCategory.do",
		optionField : function(data, index) {
            return data.text;
		},
		valueField : 'value',
		inputField : 'text',
		emptyText : '请选择'
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
	
	//树形机构，异步加载
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
   
   //显示下来框
   function showDropList() {      
	  var cityInput = $("#deptCode");
   	  var cityOffset = cityInput.offset();
   	  var topnum = cityOffset.top+cityInput.outerHeight();
   	  var leftnum = cityOffset.left-1;
   	  if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	  topnum = topnum + 2;
      }
      $("#deptDropListTree").css({"margin-left": leftnum + "px","margin-top": topnum +"px"}).show();
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
});

//表头
var tabHand = [
	{header:"经办部门编码",name:"deptCode",width:75},
	{header:"经办部门名称",name:"deptCname",width:100},
	{header:"合作机构编码",name:"channelCode",width:100},
	{header:"合作机构名称",name:"mediumCname",width:250},
	/* {header:"经办部门",name:"processDeptCode",width:120}, */
	{header:"审核状态",name:"approveFlag",width:80},
	/* {header:"审核人",name:"approveCode",width:80}, */
	{header:"是否已删除",name:"status",width:100},
 	{header:"状态",name:"newStatus",width:100},
	/* {header:"渠道类型" , name:"category",width:90}, */
 	{header:"业务线" , name:"businessLine",width:80},
 	{header:"客户出险时<br/>短信通知车行",name:"msgCar",width:80,align:"center"},
 	{header:"发送车行推<br/>荐短信给客户",name:"msgCustomer",width:80,align:"center"}
];

//查询操作
function query(){
	var deptCode = $("#deptCode").val();
	if(deptCode == '请选择'){
		$("#deptCode").val('');
	}else{
		$("#deptCode").val(deptCode.split('-')[0]);
	}
	$("#tables").omGrid("setData","<%=_path%>/medium/queryMedium.do?"+$("#filterFrm").serialize());
	$("#deptCode").val(deptCode);
}

function hideButton(){
	$.ajax({ 
		url: Util.appCxtPath + "/common/existRolesInSystemByUserCode.do?roleName=thirdDeptMediumManage",
					type : "post",
					async : false,
					dataType : "html",
					success : function(data) {
						if (data === "true") {
							$("#addButton").remove();
							$(".om-buttonbar-sep:last").remove();
							$("#delButton").remove();
							$(".om-buttonbar-sep:last").remove();
							$("#processButton").remove();
							$(".om-buttonbar-sep:last").remove();
							$("#historyButton").remove();
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
	<form id="filterFrm">
		<div id="search-panel" class="search-panel">
			<table>
				<tr>
					<td style="padding-left: 15px;" align="right"><span class="label">经办部门：</span></td>
					<td><span class="om-combo om-widget om-state-default"><input class="sele" id="deptCode" name="formMap['deptCode']" type="text" value="请选择" readonly="readonly" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" style="width: 136px;" /><span id="choose" name="choose" class="om-combo-trigger"></span></span></td>
					<td style="padding-left: 15px" align="right"><span class="label">合作机构编码：</span></td>
					<td><input name="formMap['channelCode']" id="channelCode" style="width: 160px" /></td>
					<td style="padding-left: 15px" align="right"><span class="label">合作机构名称：</span></td>
					<td><input type="text" name="formMap['mediumCname']" id="mediumCname" style="width: 160px" /></td>
					<!-- <td style="padding-left:15px" align="right"><span class="label">渠道类型：</span></td>
					<td><input class="sele" type="text" name="formMap['category']" id="category" /></td> -->
					<td style="padding-left: 15px" align="right"><span class="label">业务线：</span></td>
					<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" /></td>
					<!-- <td style="padding-left:15px" align="right"><span class="label">渠道性质：</span></td>
					<td><input class="sele" type="text" name="formMap['property']" id="property" /></td>
					<td style="padding-left:15px" align="right"><span class="label">所属行业：</span></td>
					<td><input class="sele" type="text" name="formMap['profession']" id="profession" /></td> -->
				</tr>
				<tr>
					<td style="padding-left: 15px" align="right"><span class="label">证件有效性：</span></td>
					<td><input class="sele" type="text" name="formMap['certifyValid']" id="certifyValid" /></td>
					<td style="padding-left: 15px" align="right"><span class="label">查询类型：</span></td>
					<td><input class="sele" type="text" name="formMap['certificateType']" id="certificateType" /></td>
					<td style="padding-left: 15px" align="right"><span class="label">止期：</span></td>
					<td><input class="sele" type="text" name="formMap['queryValidDate']" id="queryValidDate" /></td>
					<td style="padding-left: 15px" align="right"><span class="label">至：</span></td>
					<td><input class="sele" type="text" name="formMap['queryInvalidDate']" id="queryInvalidDate" /></td>
				</tr>
				<tr>
					<td style="padding-left: 15px" align="right"><span class="label">状态：</span></td>
					<td><input class="sele" type="text" name="formMap['queryStatus']" id="queryStatus" /></td>
					<td style="padding-left: 15px" align="right"><span class="label">含已删除：</span></td>
					<td><input type="checkbox" id="isDelete" name="formMap['isDelete']" value="1" /></td>
					<td></td>
					<td></td>
					<td></td>
					<td style="padding-left: 20px; margin-top: 15px; text-align: right;"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" class="buttonbar"></div>
	<div id="tables" class="tables"></div>
</body>
</html>