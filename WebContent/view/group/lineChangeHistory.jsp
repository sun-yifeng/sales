<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<html>
<head>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务线变更历史轨迹</title>
<% String salesmanCode=request.getParameter("salesmanCode"); %>
<script type="text/javascript">
var dataGrid;
var salesmanCode='<%=salesmanCode%>';
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
      	limit:10
	});
	
	//业务线
	$('#businessLine').omCombo({
			dataSource :"<%=_path%>/common/queryBusinessLine.do",
			emptyText : '请选择',
   		    editable : false
    });
	 //初始化按钮菜单
	 $('#buttonbar').omButtonbar({
            	btns : [{label:"详细",
            			 	id:"detailButton",
            			 	icons : {left : '<%=_path%>/images/op-edit.png'},
            	 		 	onClick:function(){
            	 		 		var rows = $('#tables').omGrid("getSelections",true);
            	 		 		var row = eval(rows);
            	 		 		if(row.length == 0){
            	 		 	        $.omMessageBox.alert({
            	 		 	            content: '请选择一条记录进行查询操作！'
            	 		 	        });
            	 		 			return false;
            	 		 		}else if(row.length > 1){
            	 		 	        $.omMessageBox.alert({
            	 		 	            content: '每次只能操作一条数据！'
            	 		 	        });
            	 		 			return false;
            	 		 		}else{
            		            	window.location.href = "lineChangeDetail.jsp?historyId="+row[0].historyId+"&deptCode="+row[0].deptCode+"&parentDeptCode="+row[0].deptCodeTwo+"&salesmanCode="+row[0].salesmanCode;
            	 		 		}
            	 		 	}
            	        }
            	
            	]
    });
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	$("#button-back").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	$("#button-dataToExcel").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:60});
	
	$("#search-panel").omPanel({
    	title : "业务线变更  > 业务线变更历史轨迹",
    	collapsible:true,
    	collapsed:false
    });	
	
	//初始化机构部门
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
	result.push({header:"二级机构",name:"deptNameTwo", width:110});
	result.push({header:"三级机构",name:"deptNameThree", width:110});
	result.push({header:"四级单位",name:"deptNameFour", width:140});
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
	
	
	
	result.push({header:"职务",name:"title", width:110});
	
	result.push({header:"业务线",name:"businessLine",width:110});
	result.push({header:"修改者",name:"updatedUser",width:110});
	result.push({header:"修改时间",name:"updatedDate",width:140});
	return result;	
}

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/salesman/querySalesmanhistory.do?"+$("#filterFrm").serialize());
	$("#tables").omGrid({colModel : setHand()});
}
//返回
function back(){
	window.location.href="lineChange.jsp";
}
</script>
</head>
<body>
	<form id="filterFrm">
		<input type="hidden" name="formMap['bLine']" id="bLine"  value ='1'/>
		<input type="hidden" name="formMap['processStatus']" id="processStatus" value="2"/>
		<input type="hidden" name="formMap['changeType']" id="changeType" value="业务线变更"/>
		<%-- <input type="hidden" name="formMap['salesmanCode']" id="salesmanCode" value='<%=salesmanCode%>'/> --%>
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td><input class="sele"  name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
					<td style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input class="sele"  name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
					<td style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td><input class="sele"  name="formMap['deptCodeFour']" id="deptCodeFour" /></td>
					<td style="padding-left:27px"><span class="label">业务线：</span></td>
					<td align="left"><input class="sele" name="formMap['businessLine']"  id="businessLine" /></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">员工编码：</span></td>
					<td><input type="text"  readonly="readonly" name="formMap['salesmanCode']"  id="salesmanCode" value='<%=salesmanCode%>' style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">员工名称：</span></td>
					<td><input type="text"  name="formMap['salesmanCname']"   id="salesmanCname" style="width:158px"/></td>
					<td style="padding-left:15px"><span class="label">团队名称：</span></td>
					<td><input type="text"   name="formMap['groupName']"  id="groupName"  style="width:158px"/></td>
					<td  colspan="2" align="right"><span id="button-search" onclick="query()">查询</span><span id="button-back" onclick="back()">返回</span></td>
					
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>