<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page  import="com.sinosafe.xszc.constant.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
 <c:choose>
    <c:when test="${param.planType==1 }">
                销售保费计划
    </c:when>
    <c:when test="${param.planType==2 }">
                专属保费计划
    </c:when>
 </c:choose>
</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<link rel="stylesheet" type="text/css" href="<%=_path%>/css/form.css" />
<script type="text/javascript">
//定义表格对象
var dataGrid;
//取得计划类型
var planType = ""+${param.planType}+"";
var switchPlanName = "";
if(planType==1){
	switchPlanName = "销售保费计划";
}else if(planType==2){
	switchPlanName = "专属保费计划";
}
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
  	
  	//初始化导入窗口数据
  	$("#impXlsArea").omDialog({
		autoOpen:false,
		title:"批量导入"+switchPlanName+"明细数据",
		width:431,
		height: 261,
		modal: true
	});
  	
  	//初始化数据列表
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
	$("#button-imp").omButton({
		icons : {left:'<%=_path%>/images/page_white_excel.png'},
		width:80,
		height:30,
		onClick:submitDaoRuData
	});

	//查询面板
	var searchPanelTitle = "";
	if(planType==1){
		searchPanelTitle = "销售计划管理  > 销售保费计划";
	}else if(planType==2){
		searchPanelTitle = "销售计划管理  > 专属保费计划";
	}
	$("#search-panel").omPanel({
    	title : searchPanelTitle,
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
	
	$("#year").val(new Date().getFullYear());
	
	$("#year").omCombo({
		dataSource : <%=Constant.getCombo("year")%>,
		value : ((new Date().getFullYear())),
		editable : false
	}); 
	
	$('#buttonbar').omButtonbar({
		 btns : [
		     {
			    label:"下载明细模板",
				id:"addButton",
				icons : {left : '<%=_path%>/images/page_white_excel.png'},
				onClick:downloadXlsModel
			 },{
				label:"导入计划明细数据",
				id:"addButton" ,
				icons : {left : '<%=_path%>/images/page_white_excel.png'},
				onClick:importXlsData
			 },
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
	 				window.location = "salePlanEdit.jsp?planType="+planType+"&planMainId="+data[0].planMainId;
	 			}
	 		 }
			 },
			 {separtor:true},
			 	{
				 label:"审核",
				 id:"updateStuts",
				 icons:{left : "<%=_path%>/images/user.png"},
				 onClick:function(){
					var selectedRows = $('#tables').omGrid('getSelections',true);
   	        		var rows = eval(selectedRows);
   	            	if(rows.length == 0 ){
   	            		$.omMessageBox.alert({
     	 		 	        content:'请选择一条记录操作',
     	 		 	        onClose:function(value){
     	 		 	        	return false;
     	 		 	        }
 	 		 	        });
   	            	}else if(rows.length > 1){
   	            		$.omMessageBox.alert({
   						   type:'error',
   				           content:'只能选择一条记录进行操作！'
   				        });
   					    return;
   	            	}else if(rows[0].approveFlag == "已审核"){
	        		    $.omMessageBox.alert({
	        			    type:'error',
        	 		 	    content:'请选择未审核的记录操作'
    	 		 	    });
        	 		    return false;
       	        	}
   	            	//确认是否审核 
   	            	$.omMessageBox.confirm({
   	                   title:'审核',
   	                   content:'你确定将['+rows[0].deptCode+']的['+rows[0].year+']年度销售保费计划审核通过吗？',
   	                   onClose:function(flag){
   	                       if(flag){
   	                    	   $.post("<%=_path%>/salePlan/checkSalePlan",{approveFlag:1,planMainId:rows[0].planMainId},
   	                    	   function(jsonData){
   	                    		   if(jsonData.actionFlag){
   	                    			  $.omMessageBox.alert({
	   	     	        			      type:'success',
	   	             	 		 	      content:'审核操作成功！'
	   	         	 		 	      });
   	                    			  $('#tables').omGrid('reload');
   	                    		   }else{
   	                    			  $.omMessageBox.alert({
	   	     	        			      type:'error',
	   	             	 		 	      content:'审核操作失败！'
	   	         	 		 	      });
   	                    		   }
   	                    	   },"json");
   	                       }
   	                   }
   	               });
		     }
		 }]
	 });

	//新增
	$("#deptPlanAdd").click(function(){
		window.location = "salePlanEdit.jsp";
	});
	//加载初始数据
	setTimeout("query()",500);
	setTimeout("setTdStyle()",800); 
});

//设置表格样式
function setTdStyle(){
	$("td").css("padding-right","5px");
	$("th").css("padding-right","5px");
}

/**
 * 生成excel模板并下载
 */
function downloadXlsModel(){
	//弹出提示
    $.omMessageBox.waiting({
        title:'请稍候',
        content:'服务器正在生成模板，请稍候...',
    });
	//生成模板
    $.ajax({ 
		url: "<%=_path%>/salePlan/getSalePlanDetailXls",
		data:{
			planType:planType
		},
		type:"post",
		async: true, 
		dataType: "json",
		success: function(data){
			//关闭提示
            $.omMessageBox.waiting('close');
			if(data.actionFlag){
				window.location.href="<%=_path %>/"+data.fileUrl;
			}else{
				$.omMessageBox.alert({
	                type:'error',
	                title:'失败',
	                content:data.actionMsg
	            });
			}
		}
	});
}

/**
 * 提交导入表单
 */
function submitDaoRuData(){
	var impFile = $("#impFile").val();
	var planYear = $("#planYear").val();
	if(impFile==""){
		$("#confirmMsg").html("<font color=red>请选择文件后再提交！</font>");
		return;
	}else{
		var extStr = impFile.substring(impFile.length-4,impFile.length);
		if(extStr.indexOf("xls")==-1){
			$("#confirmMsg").html("<font color=red>请选择拓展名为.xls文件后再提交！</font>");
			return;
		};
	}
	
	if(planYear==""){
		$("#confirmMsg").html("<font color=red>请选择计划年度！</font>");
		return;
	}
	
	$.omMessageBox.waiting({
        title:'请稍候',
        content:'服务器正在导入数据...',
    });
	
	$("#impXlsForm").submit();
}

/**
 * 导入excel数据
 */
function importXlsData(){
	if(planType==2){
		$.omMessageBox.alert({
            type:'error',
            title:'失败',
            content:"销售专属保费计划需求确认中"
        });
		return;
	}
	$("#impXlsArea").omDialog("open");
	var planYearHtml = "<option value=\"\">--请选择--</option>";
	var date = new Date();
	var curYear = date.getFullYear();
	for ( var i = curYear; i < curYear+10; i++) {
		var year = i+"";
		planYearHtml+="<option value=\""+year+"\">--"+year+"--</option>";
	}
	$("select[name='planYear']").html(planYearHtml);
}
 
//表头
var tabHand = [
    [{header:"机构",name:"deptCode", rowspan:2,width:120,align:'center',
    	renderer : function(value, rowData , rowIndex) {
			return value.substr(value.indexOf("-")+1);
		}
	},
	{header:"计划年度",name:"year", rowspan:2,width:120,align:'center'},
	{header:"保费(万元)",name:"deptPremium",rowspan:2,width:100,
		renderer : function(value, rowData , rowIndex) {
			return '<div style="text-align:right;">'+value+'</div>';
		}
	},
	{header:"审核状态",name:"approveFlag",rowspan:2,width:65,align:'center',
		renderer : function(value, rowData , rowIndex) {
			if(value=="1"){
				return '<img src="<%=_path%>/images/look_yes.png" width=25 height=25 />';
			}else{
				return '<img src="<%=_path%>/images/ico_error.png" width=25 height=25 />';
			}
		}
	},
	{header:"车险",colspan:5,width:600},
	{header:"财产险",colspan:5,width:600},
	{header:"人身险",colspan:5,width:600}],
	[ 
      //车险	
	  {header:"业务线",name:"lineCode1",width:100,align:'center',
		renderer : function(value, rowData , rowIndex) {
			return "<span id='lineCode1"+rowIndex+"'></span>";
		}
	  },
	  {header:"保费(万元)",name:"planFee1",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='planFee1"+rowIndex+"'></span>";
			}
	  },
	  {header:"渠道业务占比(%)",name:"autoChannel1",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoChannel1"+rowIndex+"'></span>";
			}
	  },
	  {header:"车险保费(万元)",name:"planFeeAll1",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='planFeeAll1"+rowIndex+"'></span>";
			}
	  },
	  {header:"险种占比(%)",name:"autoInsure1",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoInsure1"+rowIndex+"'></span>";
			}
	  },
	  //财险
	  {header:"业务线",name:"lineCode2",width:100,align:'center',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='lineCode2"+rowIndex+"'></span>";
			}
	  },
	  {header:"保费(万元)",name:"planFee2",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='planFee2"+rowIndex+"'></span>";
			}
	  },
	  {header:"渠道业务占比(%)",name:"autoChannel2",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoChannel2"+rowIndex+"'></span>";
			}
	  },
	  {header:"财险保费(万元)",name:"planFeeAll2",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='planFeeAll2"+rowIndex+"'></span>";
			}
	  },
	  {header:"险种占比(%)",name:"autoInsure2",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoInsure2"+rowIndex+"'></span>";
			}
	  },
	  //财险 
	  {header:"业务线",name:"lineCode3",width:100,align:'center',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='lineCode3"+rowIndex+"'></span>";
			}
		  },
	  {header:"保费(万元)",name:"planFee3",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='planFee3"+rowIndex+"'></span>";
			}
	  },
	  {header:"渠道业务占比(%)",name:"autoChannel3",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoChannel3"+rowIndex+"'></span>";
			}
	  },
	  {header:"人险保费(万元)",name:"planFeeAll3",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='planFeeAll3"+rowIndex+"'></span>";
			}
	  },
	  {header:"险种占比(%)",name:"autoInsure3",width:100,align:'right',
			renderer : function(value, rowData , rowIndex) {
				return "<span id='autoInsure3"+rowIndex+"'></span>";
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
	$("#tables").omGrid("setData","<%=_path%>/salePlan/queryAllSalePlanDetail.do?"+$("#filterFrm").serialize());
	//setTimeout("isSelected()",300) ; 
	setTimeout("setTdStyle()",200); 
}

function setValue(){
	var data = $("#tables").omGrid("getData");
	var rows = data.rows;
	for(var i=0;i<rows.length;i++){
		//销售保费计划详细
		var detailSet = rows[i].planDetailMapList;
		for ( var m = 1; m <=3; m++) {
			for(var j=0;j<detailSet.length;j++){
				if(detailSet[j].deptRiskType==m){
					var sum = detailSet[j].SUMV;
					//业务线
					var lineHtml = $("#lineCode"+m+""+i).html();
					if(lineHtml!=null&&lineHtml!=""){
						lineHtml = lineHtml.replace("	","");
					}
					var lineCodeHtml=lineHtml+detailSet[j].lineCode+"<br/>&nbsp;";
					$("#lineCode"+m+""+i).html(lineCodeHtml);
					//保费(万元)
					var feeHtml = $("#planFee"+m+""+i).html();
					if(feeHtml!=null){
						feeHtml = feeHtml.replace("	","");
					}
					var planFeeHtml=feeHtml+detailSet[j].planFee+"<br/>&nbsp;";
					$("#planFee"+m+""+i).html(planFeeHtml);
					$("#planFee"+m+""+i).css({"text-align":"right","display":"inline"});
					//渠道业务占比(%)
					if(sum != 0){
					   var channelHtml = $("#autoChannel"+m+""+i).html();
					   if(channelHtml!=null){
						   channelHtml = channelHtml.replace("	","");
					   }
					   var autoChannelHtml=channelHtml+((detailSet[j].planFee / sum)*100).toFixed(2) + "% <br>&nbsp;"; 
					   $("#autoChannel"+m+""+i).html(autoChannelHtml);
					}
					//总保费
					$("#planFeeAll"+m+""+i).html("<div style='text-align:right;'>"+sum+"</div>");
					//险种占比(%)
					if(rows[i].deptPremium !=0 ){
					    $("#autoInsure"+m+""+i).html("<div style='text-align:right;'>"+((((sum / rows[i].deptPremium)*100).toFixed(2)) + "%")+"</div>");
					}
				}
			}
		}
	} 
	
	//======================去除===========================
    //定义末尾带<br>&nbsp;的方法
	var reg=new RegExp("<br>&nbsp;"+"$"); 
    for(var i=0;i<rows.length;i++){
		//销售保费计划详细
		var detailSet = rows[i].planDetailMapList;
		for ( var m = 1; m <=3; m++) {
			for(var j=0;j<detailSet.length;j++){
				if(detailSet[j].deptRiskType==m){
					//=======业务线====
					var lineCodeHtml = $("#lineCode"+m+""+i).html();
					if(reg.test(lineCodeHtml)){
						lineCodeHtml +="AA";
						lineCodeHtml = lineCodeHtml.substring(0,lineCodeHtml.indexOf("<br>&nbsp;AA"));
					}
					$("#lineCode"+m+""+i).html(lineCodeHtml);
					//=======保费====
					var planFeeHtml = $("#planFee"+m+""+i).html();
					var reg=new RegExp("<br>&nbsp;"+"$");     
					if(reg.test(planFeeHtml)){
						planFeeHtml +="AA";
						planFeeHtml = planFeeHtml.substring(0,planFeeHtml.indexOf("<br>&nbsp;AA"));
					}
					$("#planFee"+m+""+i).html(planFeeHtml);	
					//=======渠道业务占比(%)====
					var autoChannelHtml = $("#autoChannel"+m+""+i).html();
					var reg=new RegExp("<br>&nbsp;"+"$");     
					if(reg.test(autoChannelHtml)){
						autoChannelHtml +="AA";
						autoChannelHtml = autoChannelHtml.substring(0,autoChannelHtml.indexOf("<br>&nbsp;AA"));
					}
					$("#autoChannel"+m+""+i).html(autoChannelHtml);	
					//=======总保费====
					var planFeeAllHtml = $("#planFeeAll"+m+""+i).html();
					var reg=new RegExp("<br>&nbsp;"+"$");     
					if(reg.test(planFeeAllHtml)){
						planFeeAllHtml +="AA";
						planFeeAllHtml = planFeeAllHtml.substring(0,planFeeAllHtml.indexOf("<br>&nbsp;AA"));
					}
					$("#planFeeAll"+m+""+i).html(planFeeAllHtml);	
					//=======险种占比====
					var autoInsureHtml = $("#autoInsure"+m+""+i).html();
					var reg=new RegExp("<br>&nbsp;"+"$");     
					if(reg.test(autoInsureHtml)){
						autoInsureHtml +="AA";
						autoInsureHtml = autoInsureHtml.substring(0,autoInsureHtml.indexOf("<br>&nbsp;AA"));
					}
					$("#autoInsure"+m+""+i).html(autoInsureHtml);	
				}
			}
		}
    }
	setTimeout("setTdStyle()",200); 
}
</script>
</head>
<body>
	<form id="filterFrm">
		<input type="hidden" id="planType" name="formMap['planType']" value="${param.planType }">
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
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
	<div id="impXlsArea">
	    <form action="<%=_path %>/salePlan/impPlanDetailInXls" id="impXlsForm" method="post" class="easyWebForm" enctype="multipart/form-data">
			<input type="hidden" name="planType" value="${param.planType }" >
			<table>
				<tr>
					<td style="text-align:right" width="130"><span class="label">选择要导入的文件:</span></td>
					<td><input type="file" name="impFile" id="impFile" /></td>
				</tr>
				<tr>
					<td style="text-align:right"  width="130"><span class="label">&nbsp;&nbsp;&nbsp;&nbsp;计划年度：</span></td>
					<td align="left">
						<select name="planYear" id="planYear">
						     <option value="">--请选择--</option>
						</select>
					</td>
				</tr>
				<tr>
				  <td style="text-align:center" colspan="2">
				     <button id="button-imp" type="button">导入</button>
				  </td>
				</tr>
				<tr>
				  <td style="text-align:center" colspan="2">
				          导入说明：导入文件必需有数据，否则将被过滤掉<br/>
				     <span id="confirmMsg" ></span>     
				  </td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>