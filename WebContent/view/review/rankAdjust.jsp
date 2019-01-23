<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*, com.hf.framework.service.security.CurrentUser"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>职级调整</title>
<script type="text/javascript">
var flag = false;
var roleEname;
$(function(){
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	
	//确认状态
	$('#confirmStatus').omCombo({
		dataSource :<%=Constant.getCombo("confirmStatus")%>,
			emptyText : '请选择',
			    editable : false
	});
	
	//评定结果
	$('#reviewResult').omCombo({
		dataSource :<%=Constant.getCombo("changeType")%>,
			emptyText : '请选择',
		    editable : false
	});
	
	//获取角色权限，中支公司或者业管部，没有确认的权限（隐藏确认按钮）
	$.ajax({ url: "<%=_path%>/common/findRolesInSystemByUserCode.do",
			type:"post",
			async: false, 
			dataType: "html",
			success: function(roleEname){
				// 中支公司或者业管部，隐藏确认按钮
				if( roleEname == "thirdDeptBusiMana" || roleEname == "thirdDeptMiddle"){
					$("#buttonbar").hide();
				}else{
					$("#buttonbar").show();
				}
			}
	});
	
	//按钮菜单
	$('#buttonbar').omButtonbar({
           	btns : [{label:"职级调整",
				 	 id:"confirmButton1",
				 	 icons : {left : '<%=_path%>/images/op-edit.png'},
		 		 	 onClick:function(){
			 		 		var rows = $('#tables').omGrid("getSelections",true);
			 		 		var row = eval(rows);
			 		 		if(row.length != 1){
			 		 	        $.omMessageBox.alert({
			 		 	            content: '请选择一条记录进行操作！'
			 		 	        });
			 		 			return false;
			 		 		}else if(rows[0].reviewResult=="淘汰" || rows[0].cusReviewResult=="淘汰"){
			 		 			
			 		 			Util.post("<%=_path%>/department/getDeptCodeByUser.do",'', function(data) {
				 		 			  if(data==00){
				 		 				   window.location.href = "rankConfirm.jsp?rankId="+row[0].rankId+"&deptCodeTwo="+row[0].deptCodeTwo+"&rankCode="+row[0].rankCode;
				 		 			  }else{
					 		 				$.omMessageBox.alert({
						 		 	            content: '选中记录中评定结果为淘汰,不能调整！'
						 		 	        });
						 		 			return false;
				 		 			  }
				 		  		});
			 		 			 
			 		 		} else if(row[0].confirmRank != undefined) {
			 		 			Util.post("<%=_path%>/department/getDeptCodeByUser.do",'', function(data) {
			 		 			  if(data==00){
			 		 				$.omMessageBox.confirm({
						                title:'确认操作',
						                content:'选中记录已经确认职级，是否确认重新调整?',
						                onClose:function(flag){
						                    if(flag){
						                    	window.location.href = "rankConfirm.jsp?rankId="+row[0].rankId+"&deptCodeTwo="+row[0].deptCodeTwo+"&rankCode="+row[0].rankCode;
						                    }
						                }
						            });
				 		 			return false;
			 		 			  }else{
				 		 				$.omMessageBox.alert({
					 		 	            content: '该人员职级已确认，不能再次进行调整！'
					 		 	        });
					 		 			return false;
			 		 			  }
			 		  		});
			 		 	      
				 		 	} else {
				            	window.location.href = "rankConfirm.jsp?rankId="+row[0].rankId+"&deptCodeTwo="+row[0].deptCodeTwo+"&rankCode="+row[0].rankCode;
			 		 		}
			 		 	  }
				    },
				    {label:"职级确认",
					 	 id:"confirmButton2",
					 	 icons : {left : '<%=_path%>/images/op-edit.png'},
			 		 	 onClick:function(){
				 		    var rows = $('#tables').omGrid("getSelections",true);
				 		    	Util.post("<%=_path%>/department/getDeptCodeByUser.do",'', function(data) {
				 		 			  if(data==00){
				 		 				 for(var i = 0;i<rows.length;i++){
				 		 					if(rows[i].confirmStatus == "已确认"){
					 		 					$.omMessageBox.alert({
							 		 	            content: '选中记录中包含‘已确认’人员，请重新选定！'
							 		 	        });
							 		 			return false;
					 		 				  }
				 		 				 }
				 		 				$.omMessageBox.confirm({
			 				                title:'确认操作',
			 				                content:'是否要对选中记录的职级进行确认?',
			 				                onClose:function(flag){
			 				                    if(flag){
			 				                    	var rankIds = "";
			 				                    	 for(var i = 0;i<rows.length;i++){
			 				                    		 rankIds += rows[i].rankId+","; 
			 				                    	 }
			 						 		    	$.ajax({ url: "<%=_path%>/reviewRank/confirmRank.do",
			 						 					type:"post",
			 						 					async: false,
			 						 					data:{rankIds:rankIds},
			 						 					dataType: "json",
			 						 					success: function(jsonData){
			 						 						if(jsonData.actionFlag){
			 						 							$.omMessageBox.alert({
			 								 		 	            content: jsonData.actionMsg
			 								 		 	        });
			 						 							$("#tables").omGrid("reload");
			 						 						}else{
			 						 							$.omMessageBox.alert({
			 								 		 	            content: jsonData.actionMsg
			 								 		 	        });
			 						 						}
			 						 					}
			 						 			   });
			 				                    }
			 				                }
			 				            });
				 		 			  }else{
				 		 				for(var i = 0;i<rows.length;i++){
				 		 					if(rows[i].confirmStatus == "已确认") {
							 		 	        $.omMessageBox.alert({
							 		 	            content: '选中记录中包含‘已确认’人员，请重新选定！'
							 		 	        });
							 		 			return false;
							 		 	 }
				 		 				}
				 		 				 $.omMessageBox.confirm({
								                title:'确认操作',
								                content:'是否要对选中记录的职级进行确认?',
								                onClose:function(flag){
								                    if(flag){
								                    	var rankIds = "";
								                    	 for(var i = 0;i<rows.length;i++){
								                    		 rankIds += rows[i].rankId+","; 
								                    	 }
										 		    	$.ajax({ url: "<%=_path%>/reviewRank/confirmRank.do",
										 					type:"post",
										 					async: false,
										 					data:{rankIds:rankIds},
										 					dataType: "json",
										 					success: function(jsonData){
										 						if(jsonData.actionFlag){
										 							$.omMessageBox.alert({
												 		 	            content: jsonData.actionMsg
												 		 	        });
										 							$("#tables").omGrid("reload");
										 						}else{
										 							$.omMessageBox.alert({
												 		 	            content: jsonData.actionMsg
												 		 	        });
										 						}
										 					}
										 			   });
								                    }
								                }
								            });
				 		 			  }	  
			 		  		    });
				 		  
					     }
				    },
				    {label:"职级恢复",
					 	 id:"confirmButton3",
					 	 icons : {left : '<%=_path%>/images/op-edit.png'},
			 		 	 onClick:function(){
			 		 		var rows = $('#tables').omGrid("getSelections",true);
			 		 		for(var i = 0;i<rows.length;i++){
	 		 					if(rows[i].confirmStatus == "待确认"){
		 		 					$.omMessageBox.alert({
				 		 	            content: '选中记录中包含‘待确认’人员，请重新选定！'
				 		 	        });
				 		 			return false;
		 		 				  }
	 		 				 }
			 		 		$.omMessageBox.confirm({
 				                title:'确认操作',
 				                content:'是否要对选中记录的职级进行恢复?',
 				                onClose:function(flag){
 				                    if(flag){
 				                    	var salesmanCodes = "";
 				                    	var calcMonth = rows[0].calcMonth;
 				                    	 for(var i = 0;i<rows.length;i++){
 				                    		salesmanCodes += rows[i].salesmanCode+","; 
 				                    	 }
 						 		    	$.ajax({ url: "<%=_path%>/reviewRank/recoverRank.do",
 						 					type:"post",
 						 					async: false,
 						 					data:{salesmanCodes:salesmanCodes,calcMonth:calcMonth},
 						 					dataType: "json",
 						 					success: function(jsonData){
 						 						if(jsonData.actionFlag){
 						 							$.omMessageBox.alert({
 								 		 	            content: jsonData.actionMsg
 								 		 	        });
 						 							$("#tables").omGrid("reload");
 						 						}else{
 						 							$.omMessageBox.alert({
 								 		 	            content: jsonData.actionMsg
 								 		 	        });
 						 						}
 						 					}
 						 			   });
 				                    }
 				                }
 				            });
					     }
				    }
       	  ]
 	 });
	
	
	 // 二级机构
	 $('#deptCodeTwo').omCombo({
		 dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		 onSuccess  : function(data, textStatus, event){
	       if(data.length == 2){
        		$('#deptCodeTwo').omCombo({value:data[1].value,readOnly : true});
        		$('#deptCodeThree').omCombo({
        			dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[1].value,
        			onSuccess  : function(data, textStatus, event){
        				if(data.length == 2){
        					$('#deptCodeThree').omCombo({value:data[1].value,readOnly : true});
        					$('#deptCodeFour').val('').omCombo({
        						dataSource : "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+$("#deptCodeThree").val(),
        						onSuccess  : function(data, textStatus, event){
        							if(data.length == 2){
        								$('#deptCodeFour').omCombo({value:data[1].value,readOnly : true});
        							}
        						}
        					});
        				}
        			}
        		});
	        	}
	        },
	        onValueChange : function(target, newValue, oldValue, event) {
	            var currentDeptCodeTwo = $('#deptCodeTwo').omCombo('value');
	            $('#deptCodeThree').omCombo('setData',[]);
	            if(currentDeptCodeTwo != ''){
		            $('#deptCodeThree').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
	            }else{
		        	$('#deptCodeThree').omCombo({
		                 dataSource : [ {text : '请选择', value : ''} ]
		            });
	            }
	            $('#deptCodeFour').omCombo('setData',[]);
	        },
	        emptyText : "请选择",
			filterStrategy : 'anywhere'
	    });
	    // 三级机构
		$('#deptCodeThree').omCombo({
			onValueChange : function(target, newValue, oldValue, event) {
	            var currentDeptCodeTwo = $('#deptCodeThree').omCombo('value');
	            if(currentDeptCodeTwo != ''){
		            $('#deptCodeFour').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+newValue);
	            }else{
		        	$('#deptCodeFour').omCombo({
		                 dataSource : [ {text : '请选择', value : ''} ]
		            });
	            }
			},
			emptyText : "请选择",
			valueField : 'value',
			inputField : 'text',
			filterStrategy : 'anywhere'
		});
		// 四级单位
		$('#deptCodeFour').omCombo({
			emptyText : "请选择",
			valueField : 'value',
			inputField : 'text',
			filterStrategy : 'anywhere'
	   });
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:57});
	
	$("#search-panel").omPanel({
	   	title : "考核职级管理  > 职级调整",
	   	collapsible:true,
	   	collapsed:false
	   });
	//评分月份
	var date = new Date();
	date.setMonth(date.getMonth()-1, date.getDate());
	$('#calcMonth').omCalendar({dateFormat:'yymm'});
	$('#calcMonth').val($.omCalendar.formatDate(date,"yymm"));
	//列表高度
	var bdnum = $("body").offset().top + $("body").outerHeight();
  	var btnum = $("#filterFrm").offset().top + $("#filterFrm").outerHeight();
	var topnum = bdnum - btnum;
  	//分页表格
	dataGrid = $("#tables").omGrid({
		colModel : tabHand,
		showIndex : true,
        singleSelect:false,
        height : topnum-20,
        method : 'POST',
      	limit : 100,
      	onRowDblClick : function(rowIndex,rowData,event){
          $("#calcDetail-dialog-model").omDialog({
            width : 900,
            height : $(window).height()-50,
            modal : true,
            resizable : false,
            onOpen:function(event) {
       	       $("#calcDetailIframe").attr("src","<%=_path%>/view/review/calcDetail.jsp?calcMonth="+rowData.calcMonth+"&deptCode="+rowData.deptCodeTwo+"&salesCode="+rowData.salesmanCode);
       	    }
          }).omDialog('open').css({'overflow-y':'hidden'});
      }
	});
	//初始化加载数据
	setTimeout("query()", 500) ;
	
	hideButton();
	
});

//表头
var tabHand = [ 
		{header : "考核年月",name : "calcMonth",rowspan : 2,width : 70,align : 'center'},
		{header : "分公司",name : "deptNameTwo",rowspan : 2,width : 110},
		{header : "业务线",name : "lineCode",width : 70},
		{header : "支公司",name : "deptNameThree",rowspan : 2,width : 110},
		{header : "四级单位",name : "deptNameFour",rowspan : 2,width : 150},
		{header : "团队名称",name : "groupName",rowspan : 2,width : 150},
		{header : "销售人员",name : "salesmanName",rowspan : 2,width : 120},
		{header : "当前职级",name : "rankName",rowspan : 2,width : 100},
		{header : "考核得分",name : "rankScore",rowspan : 2,width : 70,align : 'center',renderer:function(v,r,i){
		   if(v == '') {
	         v = '---';
		   }
		   return '<div style="text-align:center;">' + v + '</div>';}
        },
		{header : "年化标准保费达成率",name : "premRate",rowspan : 2,width : 120,align : 'center',renderer:function(v,r,i){
		   if(v == '' || v=='%') {
	       v = '---';
		   }
		   return '<div style="text-align:center;">' + v + '</div>';
		 }
		},
		{header : "评定结果",name : "reviewResult",rowspan : 2,width : 70,align : 'center'},
		{header : "推荐职级",name : "recommendRankName",rowspan : 2,width : 120, renderer:function(v,r,i)
			{
			   return '<div style="text-align:center;">' + v + '</div>';
			}},
		{header : "评定结果(按客户经理考核)",name : "cusReviewResult",rowspan : 2,width : 150,align : 'center',renderer:function(v,r,i){
			if(v == '' || v=='%') {
			       v = '---';
			}
				   return '<div style="text-align:center;">' + v + '</div>';
		}},
		{header : "推荐职级(按客户经理考核)",name : "cusRecommendRankName",rowspan : 2,width : 150},
		{header : "确认状态",name : "confirmStatus",rowspan : 2,width : 100,renderer:function(v,r,i){
			   if(v == '' || v=='%') {
			       v = '---';
				   }
				   return '<div style="text-align:center;">' + v + '</div>';
		}},
		{header : "确认职级",name : "confirmRankName",rowspan : 2,width : 150,renderer:function(v,r,i){
			   if(v == '' || v=='%') {
			       v = '---';
				   }
				   return '<div style="text-align:center;">' + v + '</div>';
		}},
		{header : "确认职级(按客户经理考核)",name : "cusConfirmRankName",rowspan : 2,width : 150,renderer:function(v,r,i){
			if(v == '' || v=='%') {
			       v = '---';
			}
				   return '<div style="text-align:center;">' + v + '</div>';
		}},
		{header : "确认时间",name : "confirmDate",rowspan : 2,width : 150,renderer:function(v,r,i){
			   if(v == '' || v=='%') {
			       v = '---';
				   }
				   return '<div style="text-align:center;">' + v + '</div>';
		}},
		{header : "确认人",name : "confirmName",rowspan : 2,width : 100,renderer:function(v,r,i){
			   if(v == '' || v=='%') {
			       v = '---';
				   }
				   return '<div style="text-align:center;">' + v + '</div>';
		}},
		{header : "签报号",name : "signNo",rowspan : 2,width : 100,renderer:function(v,r,i){
			   if(v == '' || v=='%') {
			       v = '---';
			   }
			   return '<div style="text-align:center;">' + v + '</div>';
		}}
];

//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reviewRank/queryDataToExcel.do?"+$("#filterFrm").serialize()+"&identify=3");
}
	
//查询操作
function query(){
	$("#calcMonthNew").val($("#calcMonth").val());
	$("#tables").omGrid("setData","<%=_path%>/reviewRank/queryReviewRank.do?"+$("#filterFrm").serialize());
}

function hideButton(){
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=headDeptSalesmanCreditNew,headDeptSalesmanManageNew,xszcAdmin",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			//alert(typeof(data));
			if(data === "false"){
				$("#confirmButton3").remove();
				$(".om-buttonbar-sep:last").remove();
			}
		}
	});
}
</script>
</head>
<body>
	<div id="calcDetail-dialog-model" style="display:none;" title="计算过程">
		<iframe id="calcDetailIframe" frameborder="0" style="width:100%;height:90%;height:100%;" src="about:blank"></iframe>
	</div>
	<form id="filterFrm">
		<input type="hidden"  name="formMap['flag']" id="flag"  value="1"/>
		<div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">分公司：</span></td>
					<td><input class="sele" name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
					<td align="right"><span class="label">支公司：</span></td>
					<td><input class="sele" name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td><input class="sele" name="formMap['deptCodeFour']" id="deptCodeFour" /></td>
					<td style="padding-left:15px"><span class="label">考核年月：</span></td>
					<td><input class="sele" id="calcMonth"/><input type="hidden" name="formMap['calcMonth']" id="calcMonthNew" /></td>
					<td ><span class="label">销售团队：</span></td>
					<td><input type="text" name="formMap['groupName']" id="groupName"  style="width:158px"/></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">人员代码：</span></td>
					<td><input type="text" name="formMap['salesmanCode']" id="salesmanCode"  style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">人员名称：</span></td>
					<td><input type="text" name="formMap['salesmanName']" id="salesmanName"  style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">确认状态：</span></td>
					<td><input class="sele" name="formMap['confirmStatus']" id="confirmStatus"/></td>
					<td style="padding-left:15px"><span class="label">评定结果：</span></td>
					<td><input class="sele" name="formMap['reviewResult']" id="reviewResult"/></td>
					<td colspan="8" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>