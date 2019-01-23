<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>选择用户</title>
<script>
//
$(function() {
	//选择用户
	$("#user-dialog-modal").omDialog({
	     autoOpen : false,
	     width : 750,
	     height : 465,
	     modal : true,
	     resizable : false
	   });
 });
//
function openSelectUser(){
	 $("#user-dialog-modal").omDialog('open');
	    //下面是缓加载iframe页面（提高性能）
	    var frameLoc = window.frames[0].location;
	    if (frameLoc.href == 'about:blank') {
	       frameLoc.href = 'selectUserIframe.jsp';
	    }
}
//
function fillBackAndCloseDialog(rowData) {
	  $("#salesmanCname").val(rowData.salesmanCname);
	  $("#salesmanCode").val(rowData.salesmanCode);
	  $("#user-dialog-modal").omDialog('close');
};
</script>
</head>
<body>
<form id="myform">
	用户:<input id="salesmanCname" name="salesmanCname"/><input id="salesmanCode" name="salesmanCode" type="hidden"/>
	<input type="button" value="选择" onclick="openSelectUser();"/><br/>
</form>
<div id="user-dialog-modal" title="选择用户">
	<iframe frameborder="0" style="width: 100%; height: 99%; height: 100%;" src="about:blank"></iframe>
</div>
</body>
</html>