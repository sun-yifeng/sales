<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<style type="text/css">
.buttonbar{
	position: relative;
	z-index: 3;
}

.tables{
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
<%
String channelCode = request.getParameter("channelCode");
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';

$(function(){
	 $("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	 $(".sele").css({"width":"131px"});
	 $("#deptCode").css({"background-color":"#fff"});
	 
	 $("#channelCode").val(channelCode);
	
	 //初始化按钮菜单
	 $('#buttonbar').omButtonbar({
            	btns : [{label:"详情",
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
            	 		 			window.location.href = "mediumHistoryQuery.jsp?historyId="+row[0].historyId;
            	 		 		}
            	        	}
            	        }
            	]
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
		colModel:tabHand,
	    limit : 10,
		singleSelect : false,
        height: topnum,
        method : 'POST',
        autoFit : true,
        showIndex : false
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-back").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	
	$("#search-panel").omPanel({
    	title : "合作机构管理  > 历史修改记录",
    	collapsible:true,
    	collapsed:false
    });	
	
	//加载初始数据
	query();
	
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
		dataSource : "<%=_path%>/common/queryBusinessLine.do",
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
       //
       onBeforeSelect : function(nodedata) {
         if (nodedata.children) {
	        return true;
         }
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
      $("#deptDropListTree").css({"margin-left": leftnum + "px","margin-top": topnum +"px"})
      						.show();
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
});

//表头
var tabHand = [
	{header:"经办部门代码",name:"deptCode",width:80},
	{header:"经办部门",name:"deptCname",width:120},
	{header:"代理渠道代码",name:"channelCode",width:100},
	{header:"代理渠道名称",name:"mediumCname",width:150},
	/* {header:"经办部门",name:"processDeptCode",width:120}, */
	{header:"审核状态",name:"approveFlag",width:80},
	{header:"审核人",name:"approveCode",width:80},
	{header:"状态",name:"status",width:80},
	/* {header:"渠道类型" , name:"category",width:90}, */
 	{header:"业务线" , name:"businessLine",width:80},
 	{header:"修改时间",name:"updatedDate",width:120,align:"center",
 		renderer: function(value, rowData , rowIndex) {
 			var date = new Date(value);
 			return $.omCalendar.formatDate(date,'yy-mm-dd H:i:s');
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
	//$("#deptCode").val(deptCode.split('-')[0]);
	$("#tables").omGrid("setData","<%=_path%>/mediumHistory/queryMediumHistory.do?"+$("#filterFrm").serialize());
	$("#deptCode").val(deptCode);
}

function back(){
	window.location.href="medium.jsp";
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
					<td style="padding-left:15px" align="right"><span class="label">经办部门：</span></td>
					<td><span class="om-combo om-widget om-state-default"><input class="sele" id="deptCode" name="formMap['deptCode']" type="text" value="请选择" readonly="readonly" onfocus="javascript:if(this.value=='请选择')this.value='';" onblur="javascript:if(this.value=='')this.value='请选择';" style="width:136px;" /><span id="choose" name="choose" class="om-combo-trigger"></span></span></td>
					<td style="padding-left:15px" align="right"><span class="label">渠道代码：</span></td>
					<td><input name="formMap['channelCode']" id="channelCode" readonly="readonly" style="width:160px" /></td>
					<td style="padding-left:15px" align="right"><span class="label">渠道名称：</span></td>
					<td><input type="text" name="formMap['mediumCname']" id="mediumCname" style="width:160px" /></td>
					<!-- <td style="padding-left:15px" align="right"><span class="label">渠道类型：</span></td>
					<td><input class="sele" type="text" name="formMap['category']" id="category" /></td> -->
					<td style="padding-left:15px" align="right"><span class="label">业务线：</span></td>
					<td><input class="sele" type="text" name="formMap['businessLine']" id="businessLine" /></td>
					<!-- <td style="padding-left:15px" align="right"><span class="label">渠道性质：</span></td>
					<td><input class="sele" type="text" name="formMap['property']" id="property" /></td>
					<td style="padding-left:15px" align="right"><span class="label">所属行业：</span></td>
					<td><input class="sele" type="text" name="formMap['profession']" id="profession" /></td> -->
					<td style="padding-left:15px;margin-top:15px;" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-back" onclick="back()">返回</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" class="buttonbar"></div>
	<div id="tables" class="tables"></div>
</body>
</html>