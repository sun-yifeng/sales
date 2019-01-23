<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>上传附件-影像接口</title>
</head>
<script type="text/javascript" src="<%=_path%>/core/js/ref/haim_plugin.js"></script>
<script type="text/javascript" src="<%=_path%>/core/js/ref/jquery.ba-postmessage.min.js"></script>
<script language="javascript">
	$(function() {
		var uploadPath = "http://10.1.101.10:8080/haim/general/display.do?action=dispalySpSN&operateCode=AD&sysCode=XSZC01&modelCode=XSZC010301&seriesNo=D0000000000021186369&mainBillNo=1205877390&operateEmp=hanyushan";
		document.getElementById('haim_iframe').src = uploadPath;
	});
//-->
</script>

</head>

<div height=100%>

	<fieldSet height=100% style="margin-top: 10px;">
		<legend style="margin-left: 40px; font-size: 14px;">
			上传附件by<%=CurrentUser.getUser().getUserCName()%></legend>
		<iframe id="haim_iframe" height=100% width="100%" frameborder="no" scrolling="no"></iframe>
	</fieldSet>
</div>

<script language="javascript">
	var seriesNo = '${param.seriesNo}';//批次号
	var mainBillNo = "1205877391";//主单证号-报案号
	var iframID = "haim_iframe"; //固定值
	var modelCode = '${param.modelCode}'; //传变量
	var sysCode = "XSZC01"; //固定值

	pushWriteToHaimIframe(modelCode, seriesNo, mainBillNo, iframID);
</script>
</body>

<body>
	<input type="hidden" value="aaaaa" id="aaaaa">
	<div>
		<iframe id="haim_iframe" name="haim_iframe" height="650" width="100%" frameborder="no" scrolling="no" src=""></iframe>
	</div>
</body>

</html>
