<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>系统运行记录报表</title>
<script type="text/javascript">
	$(function() {
	    var tab = $('#make-tab').omTabs({
	        closable : false
	    });
	    $("iframe").attr("height",$(window).height());
	});
</script>
</head>
<body>
    <div id="make-tab" >
        <ul>
            <li><a href="#dataMonthReport">数据访问统计报表</a></li>
            <li><a href="#pageMonthReport">页面访问统计报表</a></li>
            <li><a href="#userMonthReport">用户访问统计报表</a></li>
        </ul>
        <div id="dataMonthReport">
        	<iframe src="sysVisiteDataMonthReport.jsp" width="100%" height="100%" border=0 frameBorder='no'></iframe>
        </div>
        <div id="pageMonthReport">
        	<iframe src="sysVisitePageMonthReport.jsp" width="100%" height="100%" border=0 frameBorder='no'></iframe>
        </div>
        <div id="userMonthReport">
        	<iframe src="sysVisiteUserMonthReport.jsp" width="100%" height="100%" border=0 frameBorder='no'></iframe>
        </div>
    </div>
</body>
</html>