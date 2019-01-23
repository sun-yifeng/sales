<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>计算过程</title>
<%String salesmanCode = request.getParameter("salesmanCode");%>
<script type="text/javascript">
$(function(){
	$("#table1").omGrid({
		//title : '1 计算因素',
      	limit : 0,
		showIndex : true,
        method : 'GET',
        dataSource : '<%=_path%>/salesman/queryHisHr.do?salesmanCode=<%=salesmanCode%>',
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
          this.omGrid({height : 95 + data.rows.length * 24});
        },
   		colModel:[
                  {header:'域账号',name:'account',width:60,align:'left'},
                  {header:'姓名',name:'employeename',width:60,align:'left'},
                  {header:'入职时间',name:'inpositiondate',width:80,align:'left'},
                  {header:'离职时间',name:'dimissiontime',width:80,align:'left'},
                  {header:'入司时间',name:'enterdate',width:80,align:'left'},
                  {header:'转正时间',name:'induedate',width:80,align:'left'},
                  {header:'是否劳务',name:'ifty',width:70,align:'left'},
                  {header:'是否前台',name:'jobcategoryname',width:'60',align:'left'},
                  {header:'在职状态',name:'status',width:'60',align:'left'},
   		          {header:'岗位名称',name:'positionname',width:80,align:'left'},
   		          {header:'所在单位',name:'companyname',width:120,align:'left'}  		          
                ]
	});
});
</script>
</head>
<body>
<div style="overflow-y:auto; height:600px; width:875px;">
	<div id="table1" style=" overflow-x:hidden;"></div>
	<br/><br/>
</div>	
</body>
</html>