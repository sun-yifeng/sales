<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>提示</title>
<script type="text/javascript">
$(function(){
  $("#dialog-error").omDialog({
    autoOpen : true, 
    resizable: false,
    width: 500,
    buttons: [{
        text : "确定", 
        click : function () {
            $("#dialog-error").omDialog("close");
        }
    }],
    onClose : function(event) {
      history.go(-1);
    }
   });
});
</script>
</head>
<body>
<div id="dialog-error" title="很遗憾..." style="padding: 30px; display: none;">
	<div style="background:url(<%=_path%>/images/ico_error.png) no-repeat -6px -5px; padding-left: 70px; height: auto !important; height: 50px; min-height: 50px;">
		<h4 style="font-size: 14px; padding-top: 12px; margin: 0px;">访问路径错误,页面将会回退</h4>
	</div>
</div>
</body>
</html>