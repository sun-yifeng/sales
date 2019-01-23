<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="static com.sinosafe.xszc.constant.Constant.getCombo"%>
<% String versionId = (String) request.getParameter("versionId"); 
   String versionCname = (String) request.getParameter("versionCname");
   String deptCode = (String)request.getParameter("deptCode");%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>管理办法-手动执行计算</title>
<style>
</style>
<script type="text/javascript">
var versionId = '<%=versionId %>';
var versionCname = '<%=versionCname%>';
var deptCode = '<%=deptCode%>';
var currMonth = '';
$(function(){
	
	//加载月份
	loadMonth();
    //导航菜单
    $("#search-panel").omPanel({
        title : "考核管理办法 > 手动执行计算 > "+ deptCode + versionCname,
        collapsible : false,
        collapsed : false
    });
    
    //任务状态(1未开始,2正在执行,3执行完成,9执行失败)
    $("#taskStatus").omCombo({
		dataSource:[{"text":"请选择","value":""},
		            {"text":"未开始","value":"1"},
		            {"text":"正在执行","value":"2"},
		            {"text":"执行完成","value":"3"},
		            {"text":"执行失败","value":"9"}],
        valueField : 'value',
   		inputField : 'text',
   		emptyText : '请选择',
   		value : ''		          
		
	});
    
    $.ajax({
  		 url: "<%=_path%>/lawManual/queryCalcMonth.do", 
  			type:"post",
  			async: false, 
  			dataType:"json",
  			success:function(data){
  				currMonth = data;
  			}
  		 });
    
    $("#tablesTasks").omGrid({
    	limit : 0,
    	showIndex : true,
    	autoFit: true,
    	method : 'GET',
    	colModel : [
					{header : '公司名称', name : 'deptSimpleName', width : 85, align : 'center'},
    	            {header : '任务名称', name : 'taskName', width : 150, align : 'center'},
    	            {header : '任务状态', name : 'taskStatus', width : 100, align : 'center',
    	            	renderer : function(value, rowData , rowIndex) {
    	            		if(value=='1')
    	            			return "未开始";
    	            		else if(value == '2')
    	            			return "正在执行";
    	            		else if(value == '3')
    	            			return "<span style='color:green'>执行完成</span>";
    	            		else if(value=='9')
    	            			return "<span style='color:red'>执行失败</span>";
    	            	}
    	            },
    	            {header : '操作', name : 'operate', width : 150, align : 'center',
    	            	renderer : function(value, rowData , rowIndex) {
    	            		if(currMonth==rowData.calcMonth){    	      
    	            			var tempStr = "'" + rowData.taskId + "'";
    	            			if(rowData.taskStatus == '3'){
        	            			return '<button class="om-button" id="button-exec" onclick="execAgain('+ rowData.taskCode +')">重新执行</button>'+ '&nbsp&nbsp' + '<button class="om-button" id="button-detail" onclick="detail(' + tempStr + ')">详情</button>';
        	            		}else{ 
        	            			return '<button class="om-button" id="button-exec" onclick="exec('+ rowData.taskCode +')">执行任务</button>'+ '&nbsp&nbsp' + '<button class="om-button" id="button-detail" onclick="detail('+ tempStr + ')">详情</button>';
        	            		}
    	            		}else{
    	            			return '<span style="color:green">任务已过期</span>';
    	            		}
    	            	}
    	            },
    	            {header : '操作人', name : 'updatedUser', width : 100, align : 'center'},
    	            {header : '操作人ip', name : 'operatorId', width : 100, align : 'center'},
    	            {header : '任务开始时间', name : 'taskBeginDate', width : 150, align : 'center'},
    	            {header : '任务结束时间', name : 'taskEndDate', width : 150, align : 'center'},
    	            {header : '说明', name : 'remark', width : 250, align : 'center'}
    	            ]
    });
    
  	//计算过程界面
	$("#calcLogDetail-dialog-model").omDialog({
		autoOpen:false,
		width : 875,
        height : $(window).height()-50,
        modal : true,
        resizable : false,
	    onOpen:function(event) {
	    	$("#calcLogDetailIframe").attr("src","<%=_path%>/view/demo/calcLogs.jsp?taskId="+$("#taskId").val());
	    }
	});
  	
    //按钮样式
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
    $("#button-exec").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
    $("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
    $("#button-searchAll").omButton({icons : {left : '<%=_path%>/images/search.png'},width:85});
    
    hideQueryAllTaskButton();
    
    setTimeout("query()",800);

});


//加载月份
function loadMonth(){
	var curDate = new Date();
	var year = curDate.getFullYear();
	var month = curDate.getMonth();
	//=================================年份===============================================
	var yearHtml = "<option value=''>请选择</option>";
	for ( var i = 0; i < 11; i++) {
		if((year-10+i)==year){
			yearHtml+="<option value='"+(year-10+i)+"' selected>"+(year-10+i)+"</option>";
		}else{
			yearHtml+="<option value='"+(year-10+i)+"'>"+(year-10+i)+"</option>";
		}
	}
	$("#year").html(yearHtml);
	$("#yearCalc").html(yearHtml);
	//=================================月份===============================================
	var monthHtml = "<option value=''>请选择</option>";
	for ( var i = 1; i<=month; i++) {
		var cMonth = i;
		if(i<10){
			cMonth="0"+cMonth;
		}
		if(i==(month)){
			monthHtml+="<option value='"+cMonth+"' selected>"+cMonth+"</option>";
		}else{
			monthHtml+="<option value='"+cMonth+"'>"+cMonth+"</option>";
		}
	}
	$("#month").html(monthHtml);
	$("#monthCalc").html(monthHtml);
}

function query(){
	$("#tablesTasks").omGrid("setData","<%=_path%>/lawManual/queryManualTask.do?versionId=<%=versionId%>&"+$("#filterFrm").serialize());
}

function queryAll(){
	$("#tablesTasks").omGrid("setData","<%=_path%>/lawManual/queryManualTask.do?"+$("#filterFrm").serialize());
}

//重新执行计算任务
function execAgain(taskCode){
	$.omMessageBox.confirm({
		 title:'确认信息',
         content:'重新执行会重置当前任务后面的任务状态，是否确定？',
         onClose:function(v){
        	 if(v){
        		 $.ajax({
            		 url: "<%=_path%>/lawManual/updateTaskStatus.do?taskCode="+taskCode+"&versionId="+ versionId + "&deptCode=<%=deptCode%>&"+$("#filterFrm").serialize(), //执行计算的方法
            			type:"post",
            			async: true, 
            			dataType:"json",
            			success:function(data){
            				if(data){
            					query();
            				}else{
            					$.omMessageBox.alert({
            				           content:'重置任务失败！',
            					});
            				}
            			}
            	 });
        	 }
         }
	});
} 

//执行操作任务
function exec(taskCode){
	Util.post({
		url: "<%=_path%>/lawManual/validateRuleConfig.do?taskCode="+taskCode+"&versionId="+ versionId + "&deptCode=<%=deptCode%>&"+$("#filterFrm").serialize(), 		
		type:"post",
		async: true, 
		dataType:"json",
		success:function(data){
			if(!data){
				$.omMessageBox.alert({
			           content:'请先设置其他配置项！',
				});
			}else{
				//获取上一条任务的执行状态
				Util.post({
					url: "<%=_path%>/lawManual/queryLastTaskStatus.do?taskCode="+taskCode+"&versionId="+ versionId + "&deptCode=<%=deptCode%>&"+$("#filterFrm").serialize(), //执行计算的方法
					type:"post",
					async: true, 
					dataType:"json",
					success:function(data){
						if("9"==data){
							$.omMessageBox.alert({
						           content:'上一步计算执行失败！',
							});
						}else if("2"==data){
							$.omMessageBox.alert({
						           content:'上一步计算正在执行中...',
							});
						}else if("1"==data){
							$.omMessageBox.alert({
						           content:'上一步未执行计算！',
							});
						}else{
							//验证手动执行任务的工作状态
							Util.post({
								url: "<%=_path%>/lawManual/validateTaskStatus.do?taskCode="+taskCode+"&versionId="+ versionId + "&deptCode=<%=deptCode%>&"+$("#filterFrm").serialize(), //执行计算的方法
								type:"post",
								async: true, 
								dataType:"json",
								success:function(data){
									if(data){
										$.omMessageBox.alert({
								           content:'服务器正忙，请稍候再试...',
									    });
									}else{
										$.omMessageBox.confirm({
									           title:'确认信息',
									           content:'是否执行计算?',
									           onClose:function(v){
									        	   if(v){
									        		   $.omMessageBox.waiting({
									                      	title:'请等待',
									                      	content:'服务器正在处理中...'
									                   	});
									        		   
									        		     showResult(taskCode);   
									        	   }
									        	   
									           }
									       });
										
									}
								}
							});
						}
					}
				});
			}
		}
	});
}

//显示计算完成提示
function showResult(taskCode){
	$.ajax({
		url: "<%=_path%>/lawManual/execManualCal.do?taskCode="+taskCode+"&versionId="+ versionId + "&deptCode=<%=deptCode%>&"+$("#filterFrm").serialize(), //执行计算的方法
		type:"post",
		async: true, 
		dataType:"json",
		success:function(msg){
			
			$.omMessageBox.waiting("close");
			$.omMessageBox.alert({
	           content:'执行完成!!',
		    });
			
			query();
			
		},
		error:function(){

			$.omMessageBox.waiting("close");
			$.omMessageBox.alert({
	           content:'执行完成!!',
		    });
			query();
		} 
	});
}

function detail(taskId){
	$("#taskId").val(taskId);
	$("#calcLogDetail-dialog-model").omDialog('open').css({'overflow-y':'hidden'});
}

function hideQueryAllTaskButton(){
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=xszcAdmin",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			if(data === "false"){
				$("#button-searchAll").remove();
			}
		}
	});
}


function cancel(){
	window.location.href = "lawDefine.jsp";
}

function yearChange(){
	var curDate = new Date();
	var n_year = curDate.getFullYear();
	var s_year = $("#year").val();
	if(s_year==n_year){
		c_month = curDate.getMonth();
	}else{
		c_month = 12;
	}
	var monthHtml = "";
	for ( var i = 1; i<=c_month; i++) {
		var cMonth = i;
		if(i<10){
			cMonth="0"+cMonth;
		}
		if(i==(c_month)){
			monthHtml+="<option value='"+cMonth+"' selected>"+cMonth+"</option>";
		}else{
			monthHtml+="<option value='"+cMonth+"'>"+cMonth+"</option>";
		}
	}
	$("#month").html(monthHtml);
}
</script>
</head>
<body>
	<div id="calcLogDetail-dialog-model" title="计算日志">
		<iframe id="calcLogDetailIframe" frameborder="0" scrolling="no" style="width: 100%; height: 100%; height: 100%; overflow:hidden; " src="about:blank"></iframe>
	</div>
	<fieldSet>
		<form id="filterFrm">
		    <div id="search-panel">
		    		<input type="hidden" id="taskId"/>
	                <table>
	                	<tr>
	                	<td style="padding-left:15px"><span class="label">月份：</span></td>
						<td>
						   <select  name="formMap['year']" id="year" style="width:70px" onChange="yearChange()">
						      <option value="">请选择</option>
						   </select>
						   年
						   <select name="formMap['month']" id="month" style="width:70px">
						      <option value="">请选择</option>
						   </select>
						   月
						</td>
						<td width="5%"></td>
						<td  align="left"><span class="label">任务状态：</span></td>
						<td><input name="formMap['taskStatus']" id="taskStatus" style="width:100px" /></td>
						<td width="30%"></td>
						<td  style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-searchAll" onclick="queryAll()">查询全部任务</span></td>
						<td style="padding-left:15px;" align="right"><a id="button-cancel" onclick="cancel()">返回</a></td>
	                	</tr>
	                </table>
	            
		    </div>
	    </form>
	    <div id="tables">
		    <table id="tablesTasks"></table>
		</div>
	</fieldSet>
</body>
<script type="text/javascript">
function save(){
    //
}
</script>
</html>