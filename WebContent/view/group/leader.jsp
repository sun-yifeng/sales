<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<title>团队长设定</title>
<script type="text/javascript">
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
	$("#tables").omGrid({
		colModel:tabHand,
		showIndex : false,
        height:topnum,
        method : 'POST',
        singleSelect : false,
      	limit:10
	});
	
	 //团队类型
	$('#groupType').omCombo({
        dataSource : [{"text":"请选择","value":""},{"text":"真实团队","value":"1"},{"text":"四级机构（团队考核）","value":"3"}],
        editable : false,
        emptyText : '请选择'
    });
	 //显示虚拟团队
	$('#virtualFlag').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        editable : false,
        emptyText : '请选择'
    });
	 //显示已设团队长
	$('#identify').omCombo({
        dataSource : <%=Constant.getCombo("isYesOrNo")%>,
        value : "",
        editable : false,
        emptyText : '请选择'
    });
	
	 //初始化按钮菜单
	 $('#buttonbar').omButtonbar({
		 	btns : [{label:"团队长设定",
			 	id:"updateButton",
			 	icons : {left : '<%=_path%>/images/op-edit.png'},
	 		 	onClick:function(){
	 		 		var rows = $('#tables').omGrid("getSelections",true);
	 		 		var row = eval(rows);
	 		 		if(row.length == 0){
	 		 	        $.omMessageBox.alert({
	 		 	            content: '请选择一条数据进行操作！'
	 		 	        });
	 		 			return false;
	 		 		}else if(row.length > 1){
	 		 	        $.omMessageBox.alert({
	 		 	            content: '每次只能操作一条数据！'
	 		 	        });
	 		 			return false;
	 		 		}else{
	 		 			if(row[0].groupLeader != null){
		 		 	        $.omMessageBox.alert({
		 		 	            content: '该团队已有团队长，若需重新设定，请先撤销当前团队长职务！'
		 		 	        });
	 		 				return false;
	 		 			}
		            	window.location.href = "leaderAssign.jsp?groupCode='"+row[0].groupCode+"'";
	 		 		}
	 		 	}
	        },
	        {separtor:true},
    	      {label:"历史轨迹",
    			 	id:"updateButton",
    			 	icons : {left : '<%=_path%>/images/trace.png'},
    	 		 	onClick:function(){
    	 		 		var rows = $('#tables').omGrid("getSelections",true);
    	 		 		var row = eval(rows);
    	 		 		if(row.length == 0){
    	 		 	        $.omMessageBox.alert({
    	 		 	            content: '请选择一条记录编辑！'
    	 		 	        });
    	 		 			return false;
    	 		 		}else if(row.length > 1){
    	 		 	        $.omMessageBox.alert({
    	 		 	            content: '每次只能操作一条数据！'
    	 		 	        });
    	 		 			return false;
    	 		 		}else{
    		            	window.location.href = "leaderHistory.jsp?groupCode="+row[0].groupCode;
    	 		 		}
    	 		 	}
    	        }
           ]
    });
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	$("#search-panel").omPanel({
    	title : "销售团队管理  > 团队长设定",
    	collapsible:true,
    	collapsed:false
    });	
	
	//初始化机构部门
	$('#parentDept').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
        		$('#parentDept').omCombo({value:data[1].value,readOnly : true});
        		$('#deptName').omCombo({
        			dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[1].value,
        			onSuccess  : function(data, textStatus, event){
        				if(data.length == 2){
        					$('#deptName').omCombo({value:data[1].value,readOnly : true});
        					$('#deptMarket').val('').omCombo({
        						dataSource : "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+$("#deptName").val(),
        						onSuccess  : function(data, textStatus, event){
        							if(data.length == 2){
        								$('#deptMarket').omCombo({value:data[1].value,readOnly : true});
        							}
        						}
        					});
        				}
        			}
        		});
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#parentDept').omCombo('value');
            $('#deptName').omCombo('setData',[]);
            if(currentParentDept != ''){
	            $('#deptName').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptName').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
            $('#deptMarket').omCombo('setData',[]);
        },
        emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	$('#deptName').omCombo({
		onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptName').omCombo('value');
            if(currentParentDept != ''){
	            $('#deptMarket').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptMarket').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
		},
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
	});
	$('#deptMarket').omCombo({
		emptyText : "请选择",
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere'
   });
	
	//初始化加载数据
	setTimeout("query()", 500) ;
	
});

//表头
var tabHand = [
	[{header:"二级机构",name:"parentDept", width:130},
	{header:"三级机构",name:"deptName",width:130},
	{header:"四级单位",name:"deptMarket",width:140},
// 	{header:"团队代码",name:"groupCode",width:140},
	{header:"团队名称",name:"groupName",width:190},
	{header:"团队类型",name:"groupType",width:190,
		renderer : function(value, rowData , rowIndex) {
			if(value == '1'){
				return '真实团队';
			}else if(value == '3'){
				return '四级机构（团队考核）';
			}else{
				return '';
			}
		}	},
	{header:"团队长",name:"salesmanCname",width:140},
	{header:"团队长职级",name:"groupRank",width:140},
	{header:"团队设立时间",name:"foundDate", width:140}]
];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/groupMain/queryGroupLeader.do?"+$("#filterFrm").serialize());
}
</script>
</head>
<body>
	<form id="filterFrm">
	<input style="display:none" name="formMap['queryHistory']" id="queryHistory" value="queryList"/>
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px"><span class="label">二级机构：</span></td>
					<td><input class="sele"  name="formMap['parentDept']" id="parentDept" /></td>
					<td style="padding-left:15px"><span class="label">三级机构：</span></td>
					<td><input class="sele"  name="formMap['deptName']" id="deptName" /></td>
					<td style="padding-left:15px"><span class="label">四级单位：</span></td>
					<td><input class="sele"  name="formMap['deptCode']" id="deptMarket" /></td>
					<td align="right" style="padding-left:15px"><span class="label">团队类型：</span></td>
					<td ><input class="sele"  name="formMap['groupType']"  id="groupType"  /></td>
				</tr>
				<tr>
					<td style="padding-left:15px"><span class="label">团队名称：</span></td>
					<td><input type="text"  name="formMap['groupName']"  id="groupName" style="width:158px"/></td>
					<!--  
					<td align="right"><span class="label">虚拟团队：</span></td>
					<td><input class="sele"  name="formMap['virtualFlag']"  id="virtualFlag" /></td>
					-->
					<td align="right"><span class="label">已设团队长：</span></td>
					<td><input class="sele"   name="formMap['identify']"   id="identify"  /></td>
					<td align="right" colspan="2" ><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="buttonbar"></div>
	<div id="tables"></div>
</body>
</html>