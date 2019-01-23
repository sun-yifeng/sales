<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>机构选择下拉框</title>
<style type="text/css">
.deptDropListTree {
	height: 300px;
    width: 155px;
	margin-left: 65px;
	border: 1px solid #9AA3B9;
	overflow: auto;
	display: none;
}
</style>
<script type="text/javascript">   
$(document).ready(function() {
	//树形机构，异步加载
    $("#deptDropListTree").omTree({
        dataSource : "<%=_path%>/department/queryDeptDropList.do",
	    simpleDataModel:true,
	    //树节点选择前触发事件
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
         var ndata = nodedata, text = ndata.text;
         ndata = $("#deptDropListTree").omTree("getParent", ndata);
         while (ndata) {
	        //text = ndata.text + "-" + text;
	        ndata = $("#deptDropListTree").omTree("getParent", ndata);
         }

         $("#deptCname").val(text); //填充部门名称
         $("#deptCode").val(nodedata.id); //填充部门代码

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
   $("#deptCname").click(function() {
      showDropList();
   });
   
   //显示下来框
   function showDropList() {      
      $("#deptDropListTree").show();     
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
</script>
</head>
<body>
	<div id="demo" style="font-size:13px;" >
		选择机构：<span class="om-combo om-widget om-state-default"><input id="deptCname" name="deptCname" type="text" ><span id="choose" name="choose" class="om-combo-trigger"></span></span>
	    <input type="hidden" name="deptCode" id="deptCode" value="" />
	</div>
	<div id="deptDropList" >
		<ul id="deptDropListTree" class="deptDropListTree"></ul>
	</div>
</body>
</html>