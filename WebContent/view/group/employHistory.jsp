<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>销售人员维护历史记录查询页面</title>
<% String salesmanCode=request.getParameter("salesmanCode"); %>
<script type="text/javascript">
var salesmanCode='<%=salesmanCode%>';
var dataGrid;
var roleEname;
$(function(){
	$("#salesmanCode").val(salesmanCode);
	//input框 整体样式
	$("#filterFrm").find("input").css({"width":"150px"});
	$(".sele").css({"width":"131px"});
  	//
	$("#search-panel").omPanel({
    	title : "销售人员维护>历史修改记录",
    	collapsible:true,
    	collapsed:false
    });	
 	//按钮样式
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-back").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	//初始化列表
	dataGrid = $("#tables").omGrid({
		colModel:[],
		showIndex : false,
        height:calcHeight('buttonbar'),
        method : 'POST',
        singleSelect : false,
      	limit:10
	});
	
	//初始化按钮菜单
	$('#buttonbar').omButtonbar({
      	btns : [
        {label:"详情",
        	id:"queryButton",
        	icons : {left : '<%=_path%>/images/detail.png'},
        	onClick:function(){
        		var rows = $('#tables').omGrid("getSelections",true);
 		 		var row = eval(rows);
 		 		if(row.length == 0){
 		 	        $.omMessageBox.alert({
 		 	            content: '请选择一条记录查看！'
 		 	        });
 		 			return false;
 		 		}else if(row.length > 1){
 		 	        $.omMessageBox.alert({
 		 	            content: '每次只能操作一条数据！'
 		 	        });
 		 			return false;
 		 		}else{
 		 			window.location.href = "employDetail.jsp?historyId="+row[0].historyId+"&salesmanCode="+row[0].salesmanCode+"&deptCode="+row[0].deptCode+"&deptCodeTwo="+row[0].deptCodeTwo+"&option=queryDetail"
 		 					+"&deptNameCode="+row[0].deptCodeTwo+"&threeDeptName="+row[0].threeDeptName+"&deptNameFour="+row[0].deptNameFour+"&updatedDate="+row[0].updatedDate;
 		 		}
        	}
        },
        
       ]
    });
	 
 	//处理状态
	$('#processStatus').omCombo({
        dataSource : <%=Constant.getCombo("processStatus")%>,
        editable : false,
        emptyText : '请选择'
    });
    
 	//是否前台
	$('#salesmanFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        value:'1',
        editable : false,
        emptyText : '请选择'
    });
	
	//二级机构
	$('#deptCodeTwo').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
			//alert(data);
			//如果是分公司登录
    		if(data.length == 2){
        		$('#deptCodeTwo').omCombo({value:eval(data)[1].value, readOnly : true});
        		//取三级机构下拉框的数据
        		$('#deptCodeThree').omCombo({
        			dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[1].value,
        			onSuccess  : function(data, textStatus, event){
        				if(data.length == 2){
        					$('#deptCodeThree').omCombo({value:eval(data)[1].value,readOnly : true});
        					//取四级单位下拉框
        					$('#deptCodeFour').val('').omCombo({
        						dataSource : "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+$("#deptCodeThree").val(),
        						onSuccess  : function(data, textStatus, event){
        							if(data.length == 2){
        								$('#deptCodeFour').omCombo({value:eval(data)[1].value,readOnly : true});
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
	
	//总公司人员管理岗才可以重置
	hideButton();
	
	//初始化加载数据
	window.setTimeout("query()",500);
	
});

//表头
function setHand(dept){
	var result = [];
	result.push({header:"二级机构",name:"deptNameTwo",width:100});
	result.push({header:"三级机构",name:"deptNameThree", width:100});
	result.push({header:"四级单位",name:"deptNameFour", width:150});
	result.push({header:"团队名称",name:"groupName", width:150});
	result.push({header:"姓名",name:"salesmanCname", width:100});
	result.push({header:"当前工号",name:"employCode", width:100});
	result.push({header:"处理状态",name:"processStatus",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "未处理";
			else if(value == '2')
				return "已处理";
			else
				return "";
		}			
	});
	result.push({header:"是否前台",name:"salesmanFlag",width:100,
		renderer : function(value, rowData , rowIndex) {
			if (value == '1')
				return "是";
			else if(value == '0')
				return "否";
			else
				return "";
		}			
	});
	result.push({header:"销售职级",name:"rankName", width:100});
	result.push({header:"业务线",name:"businessLine", width:100});
	result.push({header:"入职日期",name:"entryDate", width:100});
	result.push({header:"转正日期",name:"regularDate", width:100});
	result.push({header:"入司日期",name:"contractDate", width:100});
	result.push({header:"在职状态",name:"status",width:100});
	result.push({header:"性别",name:"sex",width:100,
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
	result.push({header:"出生日期",name:"birthday", width:100});
	result.push({header:"身份证号",name:"certifyNo", width:140});
	result.push({header:"年龄",name:"age", width:100});
	result.push({header:"修改者",name:"updatedUser",width:150,});
	result.push({header:"修改时间",name:"updatedDate",width:130,});
	return result;
}

/*
 * 功能：总公司人员管理岗，可以重置,其他角色如系统管理员无重置权限
 * 日期：2015-05-20
 */
function hideButton(){
	$.ajax({ 
		url: "<%=_path%>/common/existRolesInSystemByUserCode.do?roleName=haedDeptSalesman",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(data){
			//alert(typeof(data));
			if(data === "false"){
				$("#resetButton").remove();
				$(".om-buttonbar-sep:last").remove();
			}
		}
	});
}

//查询操作
function query(){
	var param = $("#filterFrm").serialize();
	$("#tables").omGrid("setData","<%=_path%>/salesman/querySalesmanhistory.do?"+param);
	$("#tables").omGrid({colModel : setHand()});
}
function back(){
	window.location.href="employ.jsp";
}

</script>
</head>
<body>
	<form id="filterFrm">
	 <div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td><input class="sele" name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
					<td style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input class="sele" name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td><input class="sele" name="formMap['deptCodeFour']" id="deptCodeFour" /></td>
					<td style="padding-left:15px"><span class="label">处理状态：</span></td>
					<td><input class="sele" name="formMap['processStatus']" id="processStatus"  /></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">员工编码：</span></td>
					<td><input type="text" name="formMap['salesmanCode']" id="salesmanCode" readonly="readonly" style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">员工名称：</span></td>
					<td><input type="text" name="formMap['salesmanCname']" id="salesmanCname" style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">团队名称：</span></td>
					<td><input type="text" name="formMap['groupName']" id="groupName" style="width:158px"/></td>
				    <td style="padding-left:15px"><span class="label">是否前台：</span></td>
					<td><input class="sele" name="formMap['salesmanFlag']" id="salesmanFlag"  /></td>
					</tr>
				<tr>
				<td colspan="8" align="right"><span id="button-search" onclick="query()">查询</span>
				<span id="button-back" onclick="back()">返回</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>