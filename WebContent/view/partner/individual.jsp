<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
html, body{width: 100%; height: 100%; padding: 0; margin: 0; overflow: hidden;}
.deptDropListTree{height:250px;width:152px;border:1px solid #9aa3b9;overflow:auto;display:none;position:absolute;background:#FFF;z-index:4}
</style>
<title>个人合作伙伴</title>
<script type="text/javascript">
$(function(){	
	$("#filterFrm").find("input[name^='formMap'][type!='checkbox']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	$("#deptCode").css({"background-color":"#fff"});
	
	//渠道来源
	$('#channelFlag').omCombo({
	    dataSource : [{"text":"请选择","value":""},{"text":"内部（传统渠道）","value":"1"},{"text":"外部（电商渠道）","value":"3"}],
	    valueField : 'value',
	    inputField : 'text',
	    emptyText : '请选择'
	});
	
	//审核状态
	$('#approveFlag').omCombo({
	    dataSource : [{"text":"请选择","value":""},{"text":"未审核","value":"0"},{"text":"已审核","value":"1"}],
	    valueField : 'value',
	    inputField : 'text',
	    emptyText : '请选择'
	});
	
	//初始化按钮菜单
	$('#buttonbar').omButtonbar({
            	btns : [{label:"新增",
	            		    id:"addButton" ,
	            		    icons : {left : '<%=_path%>/images/add.png'},
	            	 		onClick:function(){
            	 	        	window.location.href = "<%=_path%>/view/partner/individualAdd.jsp";
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
            	 		 			window.location.href = "individualEdit.jsp?flag=0&channelCode="+row[0].channelCode + "&channelFlag="+row[0].channelFlag;
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
              	            	}else if(del[0].approveFlag == "1"){
           	        				$.omMessageBox.alert({
           	        					type:'error',
                   	 		 	        content:'请选择未审核的记录操作'
               	 		 	        });
                   	 		 	    return false;
	              	        	}
           	        				channelCodes = del[0].channelCode;
              	            		$.omMessageBox.confirm({
              	                       title:'确认审核通过',
              	                       content:'你确定要审核该记录吗？',
              	                       onClose:function(v){
              	                           if(v){
              	                        	 	Util.post(
     					       	 		 			"<%=_path%>/channelMain/processMediums.do?channelCodes="+channelCodes,
     					       	 		 			'',
     					       	 		 			function(data) {
     					       	 		 				if(data.flag == "1"){
     						       	 		 				$.omMessageBox.alert({
     						       	        					type:'success',
     						       	        	                title:'成功',
     						       	    	 		 	        content:'审核个人合作伙伴成功',
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
	 						       	    	 		 	        content:'审核个人合作伙伴失败<br/>'+data.msg,
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
            	]
    });
	
	$("#button-search").omButton({icons: {left: '<%=_path%>/images/search.png'},width:50});
	$("#search-panel").omPanel({title : "电商渠道管理  > 个人合作伙伴",collapsible:true,collapsed:false});	
	
	//初始化机构部门
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
	        ndata = $("#deptDropListTree").omTree("getParent", ndata);
         }
         //
         $("#deptCode").val(departCode+"-"+text);
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
   
   //列表的高度,放到后面
   var bdnum = $("body").offset().top + $("body").outerHeight();
   var btnum = $("#buttonbar").offset().top + $("#buttonbar").outerHeight();
   //初始化列表
   $("#tables").omGrid({
       colModel:tabHand,
       limit : 20,
       singleSelect : true,
       height: bdnum - btnum,
       method : 'POST',
       showIndex : true,
       autoFit : true
   });
   
   //加载初始数据
   setTimeout("query()", 500);
   
});

//表头
var tabHand = [
	{header:"渠道编码",name:"channelCode",width:100},
	{header:"姓名",name:"channelName",width:120},
	{header:"经办部门编码",name:"deptCode",width:100},
	{header:"经办部门名称",name:"deptCname",width:300},
	{header:"经办人",name:"processUserCode",width:180},
	{header:"渠道来源",name:"channelOrigin",width:80,align:'center',renderer:function(value,rowData,rowIndex){
		if("0" === value){
			 return '内部';
		  }else if("1" === value){
		  	 return '外部';
		  }else{
		     return "";
		  }
    }},
	{header:"审核状态",name:"approveFlag",width:80,align:'center',renderer:function(value,rowData,rowIndex){      
	    if("0" === value){
	    	return '<span style="color:red;"><b>未审核</b></span>';
		  }else if("1" === value){
		  	return '<span style="color:green;"><b>已审核</b></span>';
		  }
		}
	}
];

//查询操作
function query(){
	var deptCode = $("#deptCode").val();
	if(deptCode == '请选择'){
		$("#deptCode").val('');
	}else{
		$("#deptCode").val(deptCode.split('-')[0]);
	}
	$("#tables").omGrid("setData","<%=_path%>/individual/queryIndividualByWhere.do?"+$("#filterFrm").serialize());
	$("#deptCode").val(deptCode);
}
</script>
</head>
<body>
	<div id="deptDropList" class="deptDropList">
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">渠道编码：</span></td>
					<td><input name="formMap['channelCode']" id="channelCode" style="width:160px" /></td>
					<td style="padding-left:15px" align="right"><span class="label">姓名：</span></td>
					<td><input type="text" name="formMap['channelName']" id="channelName" style="width:160px" /></td>
					<td style="padding-left:15px" align="right"><span class="label">经办部门：</span></td>
					<td><span class="om-combo om-widget om-state-default"><input class="sele" id="deptCode" name="formMap['deptCode']" type="text" readOnly="readOnly" value="请选择" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" style="width:136px;" /><span id="choose" name="choose" class="om-combo-trigger"></span></span></td>
					<td style="padding-left:15px" align="right"><span class="label">渠道来源：</span></td>
					<td><input class="sele" type="text" name="formMap['channelFlag']" id="channelFlag" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">审核状态：</span></td>
					<td><input class="sele" type="text" name="formMap['approveFlag']" id="approveFlag" /></td>
					<td style="padding-left:15px" align="right"><span class="label">含传统渠道：</span></td>
                    <td><input type="checkbox" id="existsFlag" name="formMap['existsFlag']" value="1"/></td>
					<td colspan="8" style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" class="buttonbar"></div>
	<div id="tables" class="tables"></div>
</body>
</html>