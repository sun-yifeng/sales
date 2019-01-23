<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>薪酬确认</title>
<script type="text/javascript">
$(function(){
	//业务线
	$('#lineCode').omCombo({
			dataSource :"<%=_path%>/lawDefine/getCurLineCode",
			emptyText  : '请选择',
   		    editable   : false
    });
	
	//月份 开始
	var date = new Date();
	date.setMonth(date.getMonth()-1, date.getDate());
	$('#calcMonth').omCalendar({dateFormat:'yymm'});
	$('#calcMonth').val($.omCalendar.formatDate(date,"yymm"));
	//月份 结束
	
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
	
	var btInput = $("#buttonbar");
  	var btOffset = btInput.offset();
  	var btnum = btOffset.top+btInput.outerHeight()+84;
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
		showIndex : false,
		singleSelect :false,
        height:topnum,
        method : 'POST',
      	limit:100
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	$("#search-panel").omPanel({
    	title : "薪酬管理  > 薪酬确认",
    	collapsible:true,
    	collapsed:false
    });
	
	//初始化机构部门
	$('#deptCodeTwo').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?"+ new Date().toTimeString(),
        emptyText : "请选择",
		filterStrategy : 'anywhere',
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
        }
    });
	$('#deptCodeThree').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
    			$('#deptCodeThree').omCombo({
    				emptyText : "请选择",
    				value : data[1].value,
    				readOnly : true
    			});
        	}
        }
    });
	
	$('#statMonth').omCalendar({dateFormat:'yymm'});
		
	//初始化按钮菜单
	$('#buttonbar').omButtonbar({
           	btns : [{label:"确认薪酬",
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
				                content:'是否要对选中记录的薪酬进行确认?',
				                onClose:function(flag){
				                    if(flag){
				                    	var rowsStr = JSON.stringify(rows);
						 		    	$.ajax({ url: "<%=_path%>/reviewSalary/batchConfirmReviewSalary.do",
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
		
	//加载初始数据
	setTimeout("query()","300");
});

//表头
var tabHand = [ 
	{header : "计算年月",name : "calcMonth",width:60,align:'center'},
	{header : "分公司",name : "deptNameTwo",rowspan : 2,width : 100},
	{header : "支公司",name : "deptNameThree",rowspan : 2,width : 120},
	{header : "四级单位",name : "deptNameFour",rowspan : 2,width : 130},
	{header : "团队",name : "groupName",rowspan : 2,width : 150},
	{header : "销售人员",name : "salesmanName",rowspan : 2,width : 120},
	{header : "当前职级",name : "rankName",rowspan : 2,width : 100},
	{header : "入司时间",name : "companyDate",rowspan : 2,width : 80},
	{header : "入职时间",name : "positionDate",rowspan : 2,width : 80},
	{header : "固定工资(元)",name : "salaryFixed",rowspan : 2,width : 80,renderer:function(v,r,i){
	   if(v == '') {
	         v = '---';
	       }
	      return '<div style="text-align:center;">' + v + '</div>';}
	   },
	{header : "绩效工资(元)",name : "salaryPerform",rowspan : 2,width : 80,renderer:function(v,r,i){
	   if(v == '') {
	       v = '---';
	     }
	    return '<div style="text-align:center;">' + v + '</div>';}
	   },
	{header : "基本工资(元)",name : "salaryBase",rowspan : 2,width : 80,renderer:function(v,r,i){
	   if(v == '') {
	       v = '---';
	     }
	    return '<div style="text-align:center;">' + v + '</div>';}
	   },
   {header : "津贴(元)",name : "salaryBenefit",rowspan : 2,width : 80,renderer:function(v,r,i){
	   if(v == '') {
	       v = '---';
	     }
	    return '<div style="text-align:center;">' + v + '</div>';}
	   },
	{header : "合计(元)",name : "salaryTotal",rowspan : 2,width : 80,renderer:function(v,r,i){
	   if(v == '') {
	       v = '---';
	     }
	    return '<div style="text-align:center;">' + v + '</div>';}
	 },
	 {header : "确认状态",name : "confirmStatus",rowspan : 2,width : 100,renderer:function(v,r,i){
		   if(v == '' || v=='%') {
		       v = '---';
		   }else{
			   if(v=="已确认"){
				   v = "<font color=green>"+v+"</font>";
			   }else{
				   v = "<font color=#f47920>"+v+"</font>";
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

//查询操作
function query(){
	$("#calcMonthNew").val($("#calcMonth").val());
	$("#tables").omGrid("setData","<%=_path%>/reviewSalary/queryReviewSalary.do?"+$("#filterFrm").serialize());
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td align="right"><span class="label">分公司：</span></td>
					<td><input class="sele" name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
					<td align="right"><span class="label">支公司：</span></td>
					<td><input class="sele" name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">员工代码：</span></td>
					<td><input type="text" name="formMap['salesmanCode']" id="salesmanCode"/></td>
					<td style="padding-left:15px"><span class="label">员工姓名：</span></td>
					<td><input type="text" name="formMap['salesmanName']" id="salesmanName"/></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">计算年月：</span></td>
					<td><input class="sele" type="text" name="formMap['calcMonth']" id="calcMonth"/></td>
					<td colspan="4" style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar" class="buttonbar"></div>
	<div id="tables" class="tables"></div>
</body>
</html>