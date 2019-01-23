<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>人员异动</title>
<script type="text/javascript">
var dataGrid;

$(function(){
	 $("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	 $(".sele").css({"width":"131px"});
	
		var btInput = $("#buttonbar");
	  	var btOffset = btInput.offset();
	  	var btnum = btOffset.top+btInput.outerHeight()+87;
	  	var bdInput = $("body");
		var bdOffset = bdInput.offset();
		var bdnum = bdOffset.top+bdInput.outerHeight();
		var topnum = bdnum - btnum;
	  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
		  	topnum = topnum + 2;
	    } 
	 
	//初始化列表
	dataGrid = $("#tables").omGrid({
		colModel:[],
		showIndex : false,
        height:topnum,
        method : 'POST',
        singleSelect : false,
      	limit:20
	});
	
	$("#search-panel").omPanel({
    	title : "销售团队管理  > 人员异动",
    	collapsible:true,
    	collapsed:false
    });	
	
	 //初始化按钮菜单
	 $('#buttonbar').omButtonbar({
            	btns : [{label:"异动",
            			 	id:"changeButton",
            			 	icons : {left : '<%=_path%>/images/op-edit.png'},
            	 		 	onClick:changeSalesman
            	        },
            	        {separtor:true},
            	        {label:"历史轨迹",
            	    	 id:"historyButton",
            			 	icons : {left : '<%=_path%>/images/trace.png'},
            	 		 	onClick:function(){
            	 		 		var rows = $('#tables').omGrid("getSelections",true);
            	 		 		
            	 		 		var row = eval(rows);
            	 		 		if(row.length != 1){
            	 		 			$.omMessageBox.alert({
                	 		 	        content:'请选择一条记录',
                	 		 	        onClose:function(value){
                	 		 	        	return false;
                	 		 	        }
            	 		 	        });
               	 		 		}else{
               	 		 			
            	 		 			window.location.href = "menberChangeHistory.jsp?salesmanCode="+row[0].salesmanCode;
            	 		 		}
            	 		 	}
            	        }
            	]
    });
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	//二级机构
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
            var currentParentDept = $('#deptCodeTwo').omCombo('value');
            $('#deptCodeThree').omCombo('setData',[]);
            if(currentParentDept != ''){
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
    
	//三级机构
	$('#deptCodeThree').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptCodeThree').omCombo('value');
            if(currentParentDept != ''){
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

	//四级单位
	$('#deptCodeFour').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
   });
	//初始化加载数据
	setTimeout("query()", 500) ;
});

//表头
function setHand(){
	var result = [];
	result.push({header:"二级机构",name:"deptNameTwo", width:150});
	result.push({header:"三级机构",name:"deptNameThree", width:150});
	result.push({header:"四级单位",name:"deptNameFour", width:150});
	result.push({header:"团队名称",name:"groupName", width:150});
	result.push({header:"姓名",name:"salesmanCname", width:110});
	result.push({header:"职位",name:"position", width:110});
	result.push({header:"性别",name:"sex",width:110,
		renderer : function(value, rowData , rowIndex) {
			if (value == '106001')
				return "男";
			else if(value == '106002')
				return "女";
			else if(value == '106003')
				return "不清楚";
			else if(value == '106009')
				return "未知";
			else
				return "";
		}		
	});
	result.push({header:"出生日期",name:"birthday", width:110});
	result.push({header:"身份证号",name:"certifyNo", width:140});
	result.push({header:"年龄",name:"age", width:110});
	result.push({header:"民族",name:"nation", width:110});
	result.push({header:"籍贯",name:"fromAddress", width:110});
	result.push({header:"党派",name:"party",width:110,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "党员";
			else if(value == '2')
				return "预备党员";
			else if(value == '3')
				return "共青团员";
			else if(value == '4')
				return "群众";
			else
				return "";
		}		
	});
	result.push({header:"最高学历",name:"degree",width:110});
	result.push({header:"毕业院校",name:"education", width:110});
	result.push({header:"专业",name:"magor", width:110});
	result.push({header:"员工状态",name:"status",width:110});
	result.push({header:"员工类别",name:"salesmanType",width:110});
	result.push({header:"入司日期",name:"contractDate", width:110});
	result.push({header:"入职日期",name:"entryDate", width:110});
	result.push({header:"转正日期",name:"regularDate", width:110});
	result.push({header:"职务类型",name:"titleType",width:110,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "前台";
			else if(value == '2')
				return "后勤";
			else if(value == '3')
				return "安管";
			else if(value == '4')
				return "经理";
			else
				return "";
		}		
	});
	result.push({header:"职务",name:"title", width:110});
	result.push({header:"婚姻状态",name:"marry",width:110,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "已婚";
			else if(value == '2')
				return "未婚";
			else if(value == '3')
				return "离婚";
			else
				return "";
		}		
	});
	result.push({header:"业务线",name:"businessLine",width:110});
	return result;
}

//异动处理
function changeSalesman(){
		var rows = $('#tables').omGrid("getSelections",true);
		var row = eval(rows);
		if(row.length == 0){
	        $.omMessageBox.alert({
	            content: '请选择一条记录进行变更操作！'
	        });
			return false;
		}else if(row.length > 1){
	        $.omMessageBox.alert({
	            content: '每次只能操作一条数据！'
	        });
			return false;
		}else if(row[0].isLeader>0){
			$.omMessageBox.alert({
	            content: '该人员是团队长，不能做异动处理，请先撤销团队长！'
	        });
			return false;
		}else {
    	window.location.href = "menberChangeEdit.jsp?salesmanCode="+row[0].salesmanCode;
		}
	}

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/salesman/querySalesman.do?"+$("#filterFrm").serialize());
	//var dept = $("#deptCodeTwo").val();
	$("#tables").omGrid({colModel : setHand()});
}
</script>
</head>
<body>
	<form id="filterFrm">
		<input type="hidden" name="formMap['bLine']" id="bLine"  value ='1'/>
		<input type="hidden" name="formMap['processStatus']" id="processStatus" value="2"/>
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td><input class="sele"  name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
					<td style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input class="sele"  name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td><input class="sele"  name="formMap['deptCodeFour']" id="deptCodeFour" /></td>
					<td style="padding-left:15px"><span class="label">员工编码：</span></td>
					<td><input type="text"   name="formMap['salesmanCode']"  id="salesmanCode"  style="width:158px"/></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">员工名称：</span></td>
					<td><input type="text"  name="formMap['salesmanCname']"   id="salesmanCname" style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">团队名称：</span></td>
					<td><input type="text"   name="formMap['groupName']"  id="groupName"  style="width:158px"/></td>
					<td colspan="6" align="right"><span id="button-search" onclick="query()">查询</span>
					</td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>