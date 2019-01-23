<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>团队成员</title>
<%String gCode = request.getParameter("gCode");%>
<script type="text/javascript">
var gCode = <%=gCode%>;
$(function(){
	$("#table1").omGrid({
      	limit : 0,
		showIndex : true,
        method : 'GET',
        dataSource : "<%=_path%>/groupMain/queryGroupMember.do?groupCode="+gCode,
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
          this.omGrid({height : 95 + data.rows.length * 24});
        },
   		colModel:[{header : "姓名",name : "name",rowspan : 2,width : 60},
   		   	{header : "工号",name : "employ",rowspan : 2,width : 120},
   			{header : "域账号",name : "salesmanCode",rowspan : 2,width : 150},
   			{header : "在职状态",name : "status",rowspan : 2,width : 80},
   		 	{header : "入司时间",name : "entryDate",rowspan : 2,width : 120},
   			{header : "加入团队日期",name : "entryGroupDate",rowspan : 2,width : 120},
   			{header : "离开团队日期",name : "leaveDate",rowspan : 2,width : 120}
                ]
	});
});
</script>
</head>
<body>
<div style="overflow-y:auto; height:400px; width:875px;">
	<div id="table1" style=" overflow-x:hidden;"></div>
	<br/><br/>
</div>	
</body>
</html>