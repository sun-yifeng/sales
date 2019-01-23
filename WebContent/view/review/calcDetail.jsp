<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>计算过程</title>
<%String calcMonth = request.getParameter("calcMonth");%>
<%String deptCode = request.getParameter("deptCode");%>
<%String salesCode = request.getParameter("salesCode");%>
<script type="text/javascript">
$(function(){
	//取数过程
	$("#table1").omGrid({
		title : '1 计算因素',
      	limit : 0,
		showIndex : true,
        method : 'GET',
        dataSource : '<%=_path%>/lawCalcProce/queryCalcScore.do?calcType=1&calcMonth='+'<%=calcMonth%>'+'&deptCode='+'<%=deptCode%>'+'&salesCode='+'<%=salesCode%>',
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
          this.omGrid({height : 95 + data.rows.length * 24});
        },
   		colModel:[{header : '代码', name : 'calcCode', width : 60, align : 'left'}, 
                 {header : '计算公式', name : 'calcNote', width : '180', align : 'left'}, 
                 {header : '计算条件', name : 'calcNote', width : '180', align : 'left'}, 
                 {header : '计算结果', name : 'calcResult', align : 'left', width : 100, renderer:function(v,r,i){return '<div style="text-align:right;">' + v + '</div>';}}, 
                 {header : '描述', name : 'indexNote', align : 'left', width : 300}, 
                ]
	});
	//计算逻辑
	$("#table2").omGrid({
		title : '2 计算公式',
      	limit : 0,
		showIndex : true,
        method : 'GET',
        dataSource : '<%=_path%>/lawCalcProce/queryCalcScore.do?calcType=2&calcMonth='+'<%=calcMonth%>'+'&deptCode='+'<%=deptCode%>'+'&salesCode='+'<%=salesCode%>',
		colModel:[{header : '代码', name : 'calcCode', width : 60, align : 'left'}, 
                  {header : '计算公式', name : 'calcNote', width : '180', align : 'left'}, 
                  {header : '计算条件', name : 'calcCond', width : '180', align : 'left'}, 
                  {header : '计算结果', name : 'calcResult', align : 'left', width : 100, renderer:function(v,r,i){return '<div style="text-align:right;">' + v + '</div>';}}, 
                  {header : '描述', name : 'indexNote', align : 'left', width : 300}, 
                 ],
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
          this.omGrid({height : 100 + data.rows.length * 24});
        }
	});
	// 职级考核
	$("#table3").omGrid({
		title : '3 考核结果',
      	limit : 0,
		showIndex : true,
        method : 'GET',
        colModel:[{header : '代码', name : 'formulaCode', width : 60, align : 'left'}, 
                  {header : '考核操作', name : 'calcDesc', width : '180', align : 'left'}, 
                  {header : '考核规则', name : 'countCond', width : '430', align : 'left'},
                  {header : '推荐职级', name : 'recoRank', align : 'left', width : 150}],
        dataSource : '<%=_path%>/lawCalcProce/queryCalcRank.do?calcType=3&calcMonth='+'<%=calcMonth%>'+'&deptCode='+'<%=deptCode%>'+'&salesCode='+'<%=salesCode%>',
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
          this.omGrid({height : 60 + data.rows.length * 48});
        }         
	});
});
</script>
</head>
<body>
<div style="overflow-y:auto; height:600px; width:875px;">
	<div id="table1" style=" overflow-x:hidden;"></div>
	<div id="table2" style=" overflow-x:hidden;"></div>
	<div id="table3" style=" overflow-x:hidden;"></div>
	<br/><br/>
</div>	
</body>
</html>