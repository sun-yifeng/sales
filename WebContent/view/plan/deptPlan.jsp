<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page  import="com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>销售保费计划</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
var dataGrid;
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
  	
  	//数据列表
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

	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});

	//查询面板
	$("#search-panel").omPanel({
    	title : "销售计划管理  > 销售保费计划",
    	collapsible:true,
    	collapsed:false
    });	
	
	//加载二级机构名称
	$('#deptCode').omCombo({
        dataSource :  "<%=_path%>/department/queryDepartmentByUserCode.do?random="+Math.random(),
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
	
// 	$("#quarter").omCombo({
<%--     	dataSource : <%=Constant.getCombo("quarter")%>, --%>
//     	value : ((new Date().getMonth())/3  )+1
//     }); 
	
	$("#year").val(new Date().getFullYear());
	 
	$('#buttonbar').omButtonbar({
		 btns : [
			 {
			 label:"新增",
		     id:"deptPlanAdd" ,
		     icons : {left : '<%=_path%>/images/add.png'},
	 		 onClick:function(){window.location = "deptPlanAdd.jsp";}
		     },
		     {separtor:true},
			 {
			 label:"修改",
		     id:"updatePlan" ,
		     icons : {left : '<%=_path%>/images/op-edit.png'},
	 		 onClick:function(){
	 			var data = $("#tables").omGrid("getSelections",true);
	 			if(data.length!=1){
	 				$.omMessageBox.alert({
	 					content:"请选择一条记录"
	 				});
	 			}else{
	 				window.location = "deptPlanAdd.jsp?planMainId="+data[0].planMainId;
	 			}
	 		 }
			 },
			 {separtor:true},
			 	{
				 label:"审核",
				 id:"updateStuts",
				 icons:{left : "<%=_path%>/images/nav-search.png"},
				 onClick:function(){
	 				Util.post(
	 					"<%=_path%>/salePlanDept/updateStuts.do",
	 					$("#filterFrm").serialize(),
	 					function(data){
	 						alert(data);
	 					}
	 				);
				 }
		 }]
	 });

	//新增
	$("#deptPlanAdd").click(function(){
		window.location = "deptPlanAdd.jsp";
	});
	 
	//加载初始数据
	setTimeout("query()",500);
});
 
//表头
var tabHand = [
    [{header:"机构",name:"deptCode", rowspan:2,width:120,
    	renderer : function(value, rowData , rowIndex) {
			return value.substr(value.indexOf("-")+1);
		}
	},
	{header:"计划年度",name:"year", rowspan:2,width:120},
	{header:"保费(万元)",name:"deptPremium",rowspan:2,width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"车险",colspan:5,width:600},
	{header:"财产险",colspan:5,width:600} ,
	{header:"人身险",colspan:5,width:600}],
	
	[ 
     //车险	
	 {header:"业务线",name:"autoBizLine",width:100,
		renderer : function(value, rowData , rowIndex) {
			return "<span id='autoBizLine"+rowIndex+"'></span>";
		}
	  },
	  {header:"保费(万元)",name:"autoPrem",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoPreminum"+rowIndex+"'></span>";
			}
	  },
	  {header:"渠道业务占比(%)",name:"autoChennel",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoChannel"+rowIndex+"'></span>";
			}
	  },
	  {header:"车险保费(万元)",name:"autoPlanDeptDetail",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoPreminumAll"+rowIndex+"'></span>";
			}
	  },
	  {header:"险种占比(%)",name:"autoInsurePre",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoInsure"+rowIndex+"'></span>";
			}
	  },
	  //财险
	  {header:"业务线",name:"propertyBizLine",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='propertyBizLine"+rowIndex+"'></span>";
			}
		  },
	  {header:"保费(万元)",name:"propertyPrem",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='propertyPreminum"+rowIndex+"'></span>";
			}
	  },
	  {header:"渠道业务占比(%)",name:"propertyChennel",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='propertyChannel"+rowIndex+"'></span>";
			}
	  },
	  {header:"财险保费(万元)",name:"propertyPlanDeptDetail",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='propertyPreminumAll"+rowIndex+"'></span>";
			}
	  },
	  {header:"险种占比(%)",name:"propertyInsurePre",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='propertyInsure"+rowIndex+"'></span>";
			}
	  },
	  //财险 
	  {header:"业务线",name:"lifeBizLine",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='lifeBizLine"+rowIndex+"'></span>";
			}
		  },
	  {header:"保费(万元)",name:"lifePrem",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='lifePreminum"+rowIndex+"'></span>";
			}
	  },
	  {header:"渠道业务占比(%)",name:"lifeChennel",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='lifeChannel"+rowIndex+"'></span>";
			}
	  },
	  {header:"人险保费(万元)",name:"lifePlanDeptDetail",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='lifePreminumAll"+rowIndex+"'></span>";
			}
	  },
	  {header:"险种占比(%)",name:"lifeInsurePre",width:100,
			renderer : function(value, rowData , rowIndex) {
				return "<span id='lifeInsure"+rowIndex+"'></span>";
			}
	  }
	]
];

//权限管控
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
		  $("#deptPlanAdd").omButton("disable");
		  $("#updatePlan").omButton("disable");
	}else if(roleEname == "subDeptAdmin"){
		 $("#deptPlanAdd").omButton("disable");
		 $("#updatePlan").omButton("disable");
	}else if(roleEname == "thirdDeptMiddle"){
		 $("#deptPlanAdd").omButton("disable");
		 $("#updatePlan").omButton("disable");
	}else{
		$("#deptPlanAdd").omButton("enable");
		$("#updatePlan").omButton("enable");
	}
}

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/salePlanDept/queryAllSalePlanDept.do?"+$("#filterFrm").serialize());
	//setTimeout("isSelected()",300) ; 
}

function setValue(){
	var data = $("#tables").omGrid("getData");
	var rows = data.rows;
	for(var i=0;i<rows.length;i++){
		//销售保费计划详细
		var planDeptDetail = rows[i].planDeptDetail;
		//alert(planDeptDetail[0].deptRiskType);
		for(var j=0;j<planDeptDetail.length;j++){
			var sum = 0;
			//1-车险
			if(planDeptDetail[j].deptRiskType==1){
				sum = planDeptDetail[j].financePreminum + planDeptDetail[j].iportantPremium + planDeptDetail[j].normalPremium;
				$("#autoBizLine"+i).html("金融保险<br>&nbsp;渠道重客<br>&nbsp;其他业务");
				$("#autoPreminum"+i).html("<div style='text-align:right;'>"+planDeptDetail[j].financePreminum +"<br>&nbsp;"+ planDeptDetail[j].iportantPremium+"<br>&nbsp;" + planDeptDetail[j].normalPremium+"</div>");
				if(sum != 0){
					$("#autoChannel"+i).html("<div style='text-align:right;'>"+((planDeptDetail[j].financePreminum / sum)*100).toFixed(2) + "% <br>&nbsp;" + ((planDeptDetail[j].iportantPremium / sum)*100).toFixed(2) + "% <br>&nbsp;" + ((planDeptDetail[j].normalPremium / sum)*100).toFixed(2) + "%"+"</div>");
				}
				$("#autoPreminumAll"+i).html("<div style='text-align:right;'>"+sum+"</div>");
				if(rows[i].deptPremium !=0 ){
				    $("#autoInsure"+i).html("<div style='text-align:right;'>"+((((sum / rows[i].deptPremium)*100).toFixed(2)) + "%")+"</div>");
				}
			}
			//2-财险
			else if(planDeptDetail[j].deptRiskType==2){
				sum = planDeptDetail[j].financePreminum+planDeptDetail[j].iportantPremium+planDeptDetail[j].normalPremium;
				$("#propertyBizLine"+i).html("金融保险<br>&nbsp;渠道重客<br>&nbsp;其他业务");
				$("#propertyPreminum"+i).html("<div style='text-align:right;'>"+planDeptDetail[j].financePreminum +"<br>&nbsp;"+planDeptDetail[j].iportantPremium+"<br>&nbsp;"+planDeptDetail[j].normalPremium+"</div>");
				if(sum != 0){
					$("#propertyChannel"+i).html("<div style='text-align:right;'>"+ ((planDeptDetail[j].financePreminum / sum)*100).toFixed(2) + "% <br>&nbsp;"+((planDeptDetail[j].iportantPremium / sum)*100).toFixed(2) + "% <br>&nbsp;"+((planDeptDetail[j].normalPremium / sum)*100).toFixed(2) + "%"  +"</div>");
				}
				$("#propertyPreminumAll"+i).html("<div style='text-align:right;'>"+sum+"</div>");
				if(rows[i].deptPremium !=0 ){
					$("#propertyInsure"+i).html("<div style='text-align:right;'>"+(((sum / rows[i].deptPremium)*100).toFixed(2) + "%") +"</div>");
				}
			}
			//3-人险
			else if(planDeptDetail[j].deptRiskType==3){
				sum = planDeptDetail[j].financePreminum+planDeptDetail[j].iportantPremium+planDeptDetail[j].normalPremium;
				$("#lifeBizLine"+i).html("金融保险<br>&nbsp;渠道重客<br>&nbsp;其他业务");
				$("#lifePreminum"+i).html("<div style='text-align:right;'>"+planDeptDetail[j].financePreminum +"<br>&nbsp;"+planDeptDetail[j].iportantPremium+"<br>&nbsp;"+planDeptDetail[j].normalPremium+"</div>");
				if(sum != 0){
					$("#lifeChannel"+i).html("<div style='text-align:right;'>"+((planDeptDetail[j].financePreminum / sum)*100).toFixed(2) + "% <br>&nbsp;"+((planDeptDetail[j].iportantPremium / sum)*100).toFixed(2) + "% <br>&nbsp;"+((planDeptDetail[j].normalPremium / sum)*100).toFixed(2) + "%"  +"</div>");
				}
				$("#lifePreminumAll"+i).html("<div style='text-align:right;'>"+sum+"</div>");
				if(rows[i].deptPremium !=0 ){
					$("#lifeInsure"+i).html("<div style='text-align:right;'>"+(((sum / rows[i].deptPremium)*100).toFixed(2) + "%") +"</div>");
				}
			}
			
		}
	} 
}

</script>
</head>
<body>
	<form id="filterFrm">
		<input type="hidden" id="planType" name="planType" value="1">
		<div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">机构名称：</span></td>
					<td><input name="formMap['deptCode']" id="deptCode" class="sele" /></td>
					<td align="right"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;计划年度：</span></td>
					<td align="left"><input name="formMap['year']" id="year" /></td>
					<td colspan="6" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>