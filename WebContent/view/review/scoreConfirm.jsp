<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>考核评分查询</title>
<script type="text/javascript">
$(function(){
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	
	var btInput = $("#filterFrm");
	var btOffset = btInput.offset();
	var btnum = btOffset.top+btInput.outerHeight();
	var bdInput = $("body");
	var bdOffset = bdInput.offset();
	var bdnum = bdOffset.top+bdInput.outerHeight();
	var topnum = bdnum - btnum;
	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
		topnum = topnum + 2;
	}

	//初始化列表
	$("#tables").omGrid({
		colModel:tabHand,
		showIndex:false,
		singleSelect:false,
		limit : 100,
        height:topnum-85,
        method : 'POST',
        onRowDblClick : function(rowIndex,rowData,event){
          $("#calcDetail-dialog-model").omDialog({
            width : 900,
            height : $(window).height()-50,
            modal : true,
            resizable : false,
            onOpen : function(event) {
       	      $("#calcDetailIframe").attr("src","<%=_path%>/view/review/calcDetail.jsp?calcMonth="+rowData.calcMonth+"&deptCode="+rowData.deptCode+"&salesCode="+rowData.salesCode);
       	    }
          }).omDialog('open').css({'overflow-y':'hidden'});
      }
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:57});
	
	$("#search-panel").omPanel({
    	title : "考核评分管理  > 考核评分查询",
    	collapsible:true,
    	collapsed:false
    });
	
	//二级机构
	$('#deptCodeTwo').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?"+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCodeTwo').omCombo({
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptCodeTwo').omCombo('value');
            $('#deptCodeThree').omCombo("setData",[]);
            if(currentParentDept != ''){
	            $('#deptCodeThree').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptCodeThree').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
            $('#deptCodeFour').omCombo("setData",[]);
        },
        emptyText:"请选择",
		filterStrategy : 'anywhere'
    });
	
	$('#deptCodeThree').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
	        $('#deptCodeFour').omCombo('setData', "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+newValue);
		},
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCodeThree').omCombo({
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        },
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
	});
	//
	$('#deptCodeFour').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCodeFour').omCombo({
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        }
    });
	
	$('#managerFlag').omCombo({
		emptyText : "全部人员",
		valueField : 'value',
		inputField : 'text',
		dataSource:[
	      {text:'客户经理',value:'0'},
	      {text:'团队经理',value:'1'}
	    ]
    });
	
	var date = new Date();
	date.setMonth(date.getMonth()-1, date.getDate());
	$('#calcMonth').omCalendar({dateFormat:'yymm'});
	$('#calcMonth').val($.omCalendar.formatDate(date,"yymm"));
	
	//初始化按钮菜单
	$('#buttonbar').omButtonbar({
           	btns : [{label:"确认评分",
           			 	id:"updateButton",
           			 	icons : {left : '<%=_path%>/images/op-edit.png'},
           	 		 	onClick:function(){
           	 		 		var rows = $('#tables').omGrid("getSelections",true);
	           	 		 	if(rows.length != 1){
			 		 	        $.omMessageBox.alert({
			 		 	            content: '请选择一条记录进行操作！'
			 		 	        });
			 		 			return false;
			 		 		}
           	 		 		
           	 		 	    for(var i = 0;i<rows.length;i++){
				 		    	if(rows[i].confirmStatus=="已确认"){
				 		    		$.omMessageBox.alert({
				 		 	            content:'选中记录中包含‘已确认’记录，不允许确认!请重新选定！'
				 		 	        });
				 		    		return false;
				 		    	}
				 		    }
           	 		 	    
	           	 		  	$.omMessageBox.confirm({
				                title:'确认操作',
				                content:'是否要对选中记录的评分进行确认?',
				                onClose:function(flag){
				                    if(flag){
				                    	var rowsStr = JSON.stringify(rows);
						 		    	$.ajax({ url: "<%=_path%>/reviewScore/batchConfirmScore.do",
						 					type:"post",
						 					async: false,
						 					data:{rows:rowsStr},
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
	//加载数据
	setTimeout("query()","500");
});

//表头
var tabHand = [
	{header:"考核年月",name:"calcMonth",width:80},
	{header:"二级机构",name:"deptNameTwo",width:120},
	{header:"三级机构",name:"deptNameThree",width:120},
	{header:"四级单位名称",name:"deptNameFour",width:180},
	{header:"团队名称",name:"groupName",width:200},
	{header:"销售人员",name:"salesName",width:130},
	{header:"当前职级" , name:"rankName",width:100},
	{header:"当年累计<br/>标准保费(元)" , name:"yearSta",width:100},
	{header:"已决未决赔款(元)" , name:"thisYearClm",width:100},
 	{header:"销售团队累计<br/>标准保费达成率" , name:"scheduleRate",width:120},
 	{header:"考核得分",name:"score",width:80},
 	{header:"用户类型",name:"managerFlag",width:80,renderer:function(v,r,i){
		   if(v == '0') {
		       v = '客户经理';
		   }else if(v=="1"){
			   v = '团队经理';
		   }else if(v=="2"){
			   v = '其它';
		   }
		   return '<div style="text-align:center;">' + v + '</div>';
	}},
 	{header : "确认状态",name : "confirmStatus",rowspan : 2,width : 100,renderer:function(v,r,i){
		   if(v == '' || v=='%') {
		       v = '---';
		   }else{
			   if(v=="1"){
				   v = "<font color=green>已确认</font>";
			   }else{
				   v = "<font color=#f47920>未确认</font>";
			   }
		   }
			   return '<div style="text-align:center;">' + v + '</div>';
	}},
	{header : "确认时间",name : "confirmDate",rowspan : 2,width : 150,renderer:function(v,r,i){
		   if(v == '' || v=='%') {
		       v = '---';
			   }
			   return '<div style="text-align:center;">' + v + '</div>';
	}}
];

//导出Excel
function dataToExcel(){
	window.open("<%=_path%>/reviewScore/queryDataToExcel.do?"+$("#filterFrm").serialize()+"&identify=1");
}

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/reviewScore/queryReviewScore.do?"+$("#filterFrm").serialize());
}

</script>
</head>
<body>
	<div id="calcDetail-dialog-model" style="display:none;" title="计算过程">
		<iframe id="calcDetailIframe" frameborder="0" style="width:100%; height:90%; height:100%;" src="about:blank"></iframe>
	</div>
	<form id="filterFrm">
		<div id="search-panel" class="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">二级机构：</span></td>
					<td><input class="sele" id="deptCodeTwo" name="formMap['deptCodeTwo']" type="text"/></td>
					<td style="padding-left:15px" align="right"><span class="label">三级机构：</span></td>
					<td><input class="sele" name="formMap['deptCodeThree']" id="deptCodeThree" style="width:160px" /></td>
					<td style="padding-left:15px" align="right"><span class="label">四级单位：</span></td>
					<td><input class="sele" type="text" name="formMap['deptCodeFour']" id="deptCodeFour" /></td>
					<td style="padding-left:15px" align="right"><span class="label">团队名称：</span></td>
					<td><input type="text" name="formMap['groupName']" id="groupName" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">人员代码：</span></td>
					<td><input type="text" name="formMap['salsmanCode']" id="salsmanCode" /></td>
					<td style="padding-left:15px" align="right"><span class="label">人员名称：</span></td>
					<td><input type="text" name="formMap['salsmanName']" id="salsmanName" /></td>
					<td style="padding-left:15px" align="right"><span class="label">考核评分年月：</span></td>
					<td>
					   <input class="sele" type="text" name="formMap['calcMonth']" id="calcMonth" />
					</td>
					<td style="padding-left:15px" align="right"><span class="label">用户类型：</span></td>
					<td>
					   <input class="sele" type="text" name="formMap['managerFlag']" id="managerFlag" />
					</td>
					<td align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" class="buttonbar"></div>
	<div id="tables" class="tables"></div>
</body>
</html>