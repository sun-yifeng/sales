<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page  import="com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>销售计划管理</title>
<script type="text/javascript">
var dataGrid;
var roleEname;

$(function(){
	$(".sele").css({"width":"130px"});
	
	var btInput = $("#buttonbar");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight()+72;
  	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel:tabHand, 
		showIndex : true,
		singleSelect : false,
        height:topnum,
        method : 'POST',
        onSuccess:function(data,testStatus,XMLHttpRequest,event){
        	setTimeout(setValue, 100);
        }
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
		
	$("#search-panel").omPanel({
    	title : "销售计划管理  > 专属保费计划",
    	collapsible:true,
    	collapsed:false
    });	
	
	$("#addAgentPlan").click(function(){
		window.location = "addAgentPlan.jsp";
	});
	//加载二级机构名称
	$('#deptCode').omCombo({
        dataSource :  "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2){
        		$('#deptCode').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
        },
        emptyText : '请选择'
    });
	
	$("#year").omCombo({
		dataSource : <%=Constant.getCombo("year")%>,
		emptyText : '请选择'
	 }); 
	
	 //初始化按钮菜单
	 $('#buttonbar').omButtonbar({
            	btns : [{label:"新增",
	            		     id:"addButton" ,
	            		     icons : {left : '<%=_path%>/images/add.png'},
	            	 		 onClick:function(){
            	 			 	window.location.href = "addAgentPlan.jsp";
            	 			 }
            			},
            			{separtor:true},
            	        {label:"修改",
            			 	id:"updateButton",
            			 	icons : {left : '<%=_path%>/images/op-edit.png'},
            	 		 	onClick:function(){
            	 		 		var data = $("#tables").omGrid("getSelections",true);
            		 			if(data.length!=1 && data.length == 0){
            		 				$.omMessageBox.alert({
            		 					content:"请选择一条记录"
            		 				});
            		 				return false;
            		 			}else if(data.length > 1){
            		 				$.omMessageBox.alert({
            		 					content:"一次只能修改一条记录"
            		 				});
            		 				return false;
            		 			}else{
            		 				window.location = "addAgentPlan.jsp?planMainId="+data[0].planMainId;
            		 			}
            	 		 	}
            	        },
            	        {separtor:true},
            	        {label:"详情",
            	        	id:"queryButton",
            	        	icons : {left : "<%=_path%>/images/detail.png" },
            	        	onClick:function(){
            	        		var rows = $('#tables').omGrid("getSelections",true);
            	 		 		var row = eval(rows);
            	 		 		if(row.length == 0 && row.length != 1){
            	 		 			 $.omMessageBox.alert({
             	 		 	            content: '请选择一条记录查看'
             	 		 	        });
            	 		 			return false;
            	 		 		}else if(row.length > 1){
            	 		 			$.omMessageBox.alert({
             	 		 	            content: '一次只能查看一条数据'
             	 		 	        });
            	 		 			return false;
            	 		 		}else{
            	 		 			window.location.href = "queryAgentPlan.jsp?planMainId="+row[0].planMainId;
            	 		 		}
            	        	}
            	        }
            	]
    });
	 //isSelected();
	// $('#addButton').attr("disabled");
	 setTimeout("query()",500);
});

//表头
var tabHand = [
   [
	{header:"机构",name:"deptCode", rowspan:2,width:120,
    	renderer : function(value, rowData , rowIndex) {
			return value.substr(value.indexOf("-")+1);
		}
	},
	{header:"计划年度",name:"year", rowspan:2,width:120},
	{header:"保费(万元)",name:"deptPremium", rowspan:2,width:120,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"车险",colspan:5},
	{header:"财产险",colspan:5},
	{header:"人身险",colspan:5}
   ]
   ,
   [
	{header:"渠道",name:"autoChannelCode",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='autoChannelCode"+rowIndex+"'></span>";
		}
	},
	
	{header:"保费(万元)",name:"autoTargetPremium",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoTargetPremium"+rowIndex+"'></span>";
		}
	},
	{header:"渠道业务占比(%)",name:"autoChannel",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='autoChannel"+rowIndex+"'></span>";
		}
	},
	 {header:"车险保费(万元)",name:"autoPlanChannelDetail",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='autoPlanChannelDetail"+rowIndex+"'></span>";
		}
	},
	  
	{header:"险种占比(%)",name:"autoInsure",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='autoInsure"+rowIndex+"'></span>";
		}
	},
		 
	{header:"渠道",name:"propertyChannelCode",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='propertyChannelCode"+rowIndex+"'></span>";
		}
	},
	
	{header:"保费(万元)",name:"propertyTargetPremium",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='propertyTargetPremium"+rowIndex+"'></span>";
		}
	},
	{header:"渠道业务占比(%)",name:"propertyChannel",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='propertyChannel"+rowIndex+"'></span>";
		}
	},
	{header:"财险保费(万元)",name:"propertyPlanChannelDetail",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='propertyPlanChannelDetail"+rowIndex+"'></span>";
		}
	},
	{header:"险种占比(%)",name:"propertyInsure",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='propertyInsure"+rowIndex+"'></span>";
		}
	},
		 
	{header:"渠道",name:"lifeChannelCode",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='lifeChannelCode"+rowIndex+"'></span>";
		}
	},
	
	{header:"保费(万元)",name:"lifeTargetPremium",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='lifeTargetPremium"+rowIndex+"'></span>";
		}
	},
	{header:"渠道业务占比(%)",name:"lifeChannel",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='lifeChannel"+rowIndex+"'></span>";
		}
	},
	{header:"人险保费(万元)",name:"lifePlanChannelDetail",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='lifePlanChannelDetail"+rowIndex+"'></span>";
		}
	},
	{header:"险种占比(%)",name:"lifeInsurePre",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='lifeInsure"+rowIndex+"'></span>";
		}
	},
    ]
   	
];
//
function isSelected(){
	
	$.ajax({ 
		url: "<%=_path%>/reviewRank/findRolesInSystemByUserCode.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			roleEname = data;
		}
	});
	
	if(roleEname == "headDeptDirector"){
		$("#addButton").omButton("disable");
		$("#updateButton").omButton("disable");
	}else if(roleEname == "subDeptAdmin"){
		$("#addButton").omButton("disable");
		$("#updateButton").omButton("disable");
	}else if(roleEname == "thirdDeptMiddle"){
		$("#addButton").omButton("disable");
		$("#updateButton").omButton("disable");
	}else{
		$("#addButton").omButton("enable");
		$("#updateButton").omButton("enable");
	}
}
//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/salePlanChannel/queryAllSalePlanChannel.do?"+$("#filterFrm").serialize());
	//setTimeout("isSelected()",300) ; 
}

function setValue(){
	
	var data = $("#tables").omGrid("getData");
	
	var rows = data.rows;
	for(var i=0;i<rows.length;i++){
		var planChannelDetail = rows[i].planChannelDetail;
		
		var autoChannelCode = "";
		var autoTargetPremium = "";
		var autoPre = new Array();
		var autoSum = 0;
		var auto = 0;
		
		var propertyChannelCode = "";
		var propertyTargetPremium = "";
		var propertyPre = new Array();
		var propertySum = 0;
		var property = 0;
		
		var lifeChannelCode = "";
		var lifeTargetPremium = "";
		var lifePre = new Array();
		var lifeSum = 0;
		var life = 0;
		
		for(var j=0;j<planChannelDetail.length;j++){
			var sum = 0;
			if(planChannelDetail[j].channelRiskType==1){
				//sum += planChannelDetail[j].targetPremium;
				autoSum += planChannelDetail[j].targetPremium;
				autoChannelCode += (planChannelDetail[j].channelCode) + "<br>&nbsp;";
				autoTargetPremium += (planChannelDetail[j].targetPremium) +"<br>&nbsp;";
				autoPre[auto++] = planChannelDetail[j].targetPremium;
				
			}else if(planChannelDetail[j].channelRiskType==2){
				//alert(planChannelDetail[0].channelRiskType);
				propertySum += planChannelDetail[j].targetPremium;
				propertyChannelCode += (planChannelDetail[j].channelCode) + "<br>&nbsp;";
				propertyTargetPremium += (planChannelDetail[j].targetPremium) +"<br>&nbsp;";
				propertyPre[property++] = planChannelDetail[j].targetPremium;
			}else if(planChannelDetail[j].channelRiskType==3){
				
				lifeSum += planChannelDetail[j].targetPremium;
				lifeChannelCode += (planChannelDetail[j].channelCode) + "<br>&nbsp;";
				lifeTargetPremium += (planChannelDetail[j].targetPremium) +"<br>&nbsp;";
				lifePre[life++] = planChannelDetail[j].targetPremium;
			}
		}
		
		//车险相关信息
		autoChannelCode = autoChannelCode.substr(0,autoChannelCode.lastIndexOf("<br>"));
		autoTargetPremium = autoTargetPremium.substr(0,autoTargetPremium.lastIndexOf("<br>"));
		$("#autoChannelCode" + i).html(autoChannelCode);
		$("#autoTargetPremium" + i).html("<div style='text-align:right;'>"+autoTargetPremium+"</div>");
		autoChannelCode = "";
		for(var k=0;k<autoPre.length;k++){
			autoChannelCode += ((autoPre[k]/autoSum)*100).toFixed(2) + "% <br>&nbsp;";
		}
		autoChannelCode = autoChannelCode.substr(0,autoChannelCode.lastIndexOf("<br>")-1);
		$("#autoChannel" + i).html("<div style='text-align:right;'>"+autoChannelCode+"</div>");
		$("#autoPlanChannelDetail"+i).html("<div style='text-align:right;'>"+autoSum+"</div>");
		$("#autoInsure"+i).html(("<div style='text-align:right;'>"+((autoSum / rows[i].deptPremium)*100).toFixed(2) + "%") +"</div>");

		//财险相关信息
		propertyChannelCode = propertyChannelCode.substr(0,propertyChannelCode.lastIndexOf("<br>"));
		propertyTargetPremium = propertyTargetPremium.substr(0,propertyTargetPremium.lastIndexOf("<br>"));
		$("#propertyChannelCode" + i).html(propertyChannelCode);
		$("#propertyTargetPremium" + i).html("<div style='text-align:right;'>"+propertyTargetPremium+"</div>");
		propertyChannelCode = "";
		for(var k=0;k<propertyPre.length;k++){
			propertyChannelCode += ((propertyPre[k]/propertySum)*100).toFixed(2) + "% <br>&nbsp;";
		}
		propertyChannelCode = propertyChannelCode.substr(0,propertyChannelCode.lastIndexOf("<br>")-1);
		$("#propertyChannel" + i).html("<div style='text-align:right;'>"+propertyChannelCode+"</div>");
		$("#propertyPlanChannelDetail"+i).html("<div style='text-align:right;'>"+propertySum+"</div>");
		$("#propertyInsure"+i).html(("<div style='text-align:right;'>"+((propertySum / rows[i].deptPremium)*100).toFixed(2) + "%") +"</div>");
		
		//人险相关信息
		lifeChannelCode = lifeChannelCode.substr(0,lifeChannelCode.lastIndexOf("<br>"));
		lifeTargetPremium = lifeTargetPremium.substr(0,lifeTargetPremium.lastIndexOf("<br>"));
		$("#lifeChannelCode" + i).html(lifeChannelCode);
		$("#lifeTargetPremium" + i).html(lifeTargetPremium);
		lifeChannelCode = "";
		for(var k=0;k<lifePre.length;k++){
			lifeChannelCode += ((lifePre[k]/lifeSum)*100).toFixed(2) + "% <br>&nbsp;";
		}
		lifeChannelCode = lifeChannelCode.substr(0,lifeChannelCode.lastIndexOf("<br>")-1);
		$("#lifeChannel" + i).html(lifeChannelCode);
		$("#lifePlanChannelDetail"+i).html(lifeSum);
		$("#lifeInsure"+i).html( ((lifeSum / rows[i].deptPremium)*100).toFixed(2) + "%" );
		
        //$("#bizLine"+i).html(planDeptDetail[0].deptRiskType);
	} 
}
</script>
</head>
<body>
	<form id="filterFrm">
		<input type="hidden" id="planType" name="planType" value = "2" >
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" >
						<span class="label">机构名称：</span>
					</td>
					<td>
						<input name="formMap['deptCode']" id="deptCode" class="sele" />
					</td>
					<td align="right" >
						<span class="label">&nbsp;&nbsp;&nbsp;&nbsp;计划年度：</span>
					</td>
					<td align="left">
						<input name="formMap['year']" id="year" class="sele"/>
					</td>
					<td  align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		 
			 
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>