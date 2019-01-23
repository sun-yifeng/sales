<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript"  src="<%=_path%>/core/js/huaanUI.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>活动查询</title>
<style type="text/css">
	body{margin: 0;}
    .button-stl-tab{color: blue;text-decoration:underline}
</style>
<script type="text/javascript">
var dataGrid;

$(function(){
	$("#filterFrm input").css({width:'140px'});
	$(".omDateCalendar,.omCombo").css({width:'121px'});
	$('#dialog').omDialog({
		zIndex : 99999,
		autoOpen : false,
		modal : true,
		height : 400,
		width : 650
		});
	$(".omDateCalendar").omCalendar();
    $("#status").omCombo({
    	dataSource : [{"text":"请选择","value":""},{"text":"草稿","value":"0"},{"text":"已下发","value":"1"},{"text":"活动结束","value":"2"}] ,
    	optionField:function(data,index){
    		  return data.value+'-'+ data.text; 
    	},
    	emptyText : "请选择",
		valueField : 'value',
		forceSelection : true,
		
		inputField : function(data,index){
    		  return data.value+'-'+ data.text; 
    	},
		filterStrategy : 'anywhere'
	});
    
	dataGrid = $("#tables").omGrid({
		onRowDblClick:function(){
			openDetail("activityDetail");
		},
		colModel:tabHand,
		singleSelect : false,
		showIndex : false,
        height : 400,
        width : 'fit',
       // autoFit : true,
        limit : 10,
        method : 'POST'
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	$("#search-panel").omPanel({
    	title : "活动管理  > 活动查询",
    	collapsible:true,
    	collapsed:false
    });
	
	$('#operationBar').omButtonbar({
    	btns : btnList
    });
	
	//加载初始数据
	//query();
	//初始化机构部门
	$('#parentDept').omCombo({
		dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?"+ new Date().toTimeString(),
		optionField:function(data,index){
  			return data.value+data.text; 
  		},
  		filterStrategy : 'anywhere',
  		filterDelay : 100,
		onSuccess  : function(data, textStatus, event){
    		if(data.length == 2){
        		$('#parentDept').omCombo({value:eval(data)[1].value,readOnly : true});
        		//$('#deptName').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[1].value);
        	}
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#parentDept').omCombo('value');
            $('#deptName').omCombo('setData',[]);
            $("#deptCode").val(currentParentDept);
            if(currentParentDept != ''){
	            $('#deptName').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
            }else{
	        	$('#deptName').omCombo({
	                 dataSource : [ {text : '请选择', value : ''} ]
	            });
            }
        },
        emptyText : "请选择",
    });
	$('#deptName').omCombo({
		optionField:function(data,index){
  			return data.text; 
  		},
  		onSuccess:function(data, textStatus, event){
        	if(data.length == 2){
        		$('#deptName').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
        },
		emptyText : '请选择',
		valueField : 'value',
		filterStrategy : 'anywhere',
		filterDelay : 100
	});
	
	//获取角色权限 修改相应功能
	$.ajax({ 
		url: "<%=_path%>/common/findRolesInSystemByUserCode.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(roleEname){
			
			if(roleEname == "subDeptMarketM" ){
 				$("#button-issue").parent().parent().hide();
				$("#button-summary").parent().parent().hide();
			}else if( roleEname == "thirdDeptBusiMana" || roleEname == "thirdDeptMiddle"){
 				$("#button-issue").parent().parent().hide();
				$("#button-summary").parent().parent().hide();
				$("#button-modify").parent().parent().hide();
				$("#button-new").parent().parent().hide();
				$("#button-delete").parent().parent().hide();
			}else{
 				$("#button-issue").omButton("enable");
				$("#button-summary").omButton("enable");
				$("#button-detail").omButton("enable"); 
				$("#button-modify").omButton("enable");
				$("#button-new").omButton("enable"); 
				$("#button-delete").omButton("enable"); 
			}
		}
	});
	
	setTimeout("query()", 500) ;
});

/* *********************************************初始化数据******************************************* */
var btnList =  [
	    		{label:"新增",
			     id:"button-new" ,
			     icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
		 		 onClick:function(){openSave();}
				},
				{separtor:true},
		        {label:"下发",
					 id:"button-issue",
				     disabled :  false,
					 icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
			 		 onClick:function(){openDetail("activityIssue");}
			        },
				{separtor:true},
		        {label:"修改",
				 id:"button-modify",
			     disabled :  false,
				 icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
		 		 onClick:function(){openDetail("activityModify");}
		        },
		        {separtor:true},
		        {label:"详情",
				 id:"button-detail",
			     disabled :  false,
				 icons : {left : '<%=_path%>/images/detail.png'},
		 		 onClick:function(){openDetail("activityDetail");}
		        },
		        {separtor:true},
		        {label:"总结",
				 id:"button-summary",
			     disabled :  false,
				 icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
		 		 onClick:function(){openSummary();}
		        },
		        {separtor:true},
		        {label:"删除",
				 id:"button-delete",
			     disabled :  false,
				 icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/remove.png'},
		 		 onClick:function(){openDelete();}
		        }
			   ];


//表头
var tabHand = [
                {header:"活动号",name:"activityId",width:240},
				{header:"活动名称",name:"activityName",width:130},
				{header:"活动参与对象",name:"attend",width:130},
				{header:"活动开始时间",name:"beginDate",width:150},
				{header:"活动终止时间",name:"endDate",width:150},
				{header:"活动负责人",name:"projectUser",width:100},
				{header:"活动预算",name:"premium",width:100},
				{header:"考核频度",name:"frequency",width:100},
				{header:"活动状态",name:"statusName",width:100},
				{header:"操作",name : 'operation', width: 100, align:'center', renderer:function(colValue, rowData, rowIndex){
            	 return '<span class="button-stl-tab" onClick="download('+rowIndex+',event)">下载</span>';
             	}}
               ];
/* *********************************************初始化数据end******************************************* */


/**
 * 查询函数
 */
function query(){
	initDept();
	$("#tables").omGrid("setData","<%=_path%>/activity/queryActivity.do?"+$("#filterFrm").serialize());
}


/**
 * 文件下载
 */
function download(index,e){
	var data = $("#tables").omGrid("getData").rows[index];
	$("#dialog").html("");
	var opts = {
			title:"方案下载",
			modelCode:"XSZC010201",
			mainBillNo:data.activityId,
			seriesNo:data.uploadId,
			srcUrl:'${sessionScope.imgUrl}',
			operateCode:'none',
			operateEmp:"<%=CurrentUser.getUser().getUserCode()%>"
	};
	$("#dialog").haImg(opts);
	$("#dialog").omDialog('open');
}

/**
 * 初始化机构查询条件
 */
function initDept(){
	var currentParentDept = $('#deptName').omCombo('value');
	if(currentParentDept!=''){
	    $("#deptCode").val(currentParentDept);
	}else {
		$("#deptCode").val($('#parentDept').omCombo('value'));
	}
}


/**
 * 活动新增
 */
function openSave(){
	location.href = "<%=_path%>/activity/activityRedirect.do?actionName=activityAdd&soursePage=activityQuery";
	$(".omButton").omButton();
}


/**
 * 活动总结
 */
 function openSummary(){
	 try{
			var cells = dataGrid.omGrid("getSelections",true);
			if(cells.length<=0){
				$.omMessageBox.alert({
			           content:'请选择需更新的记录'
			       });
				return;
			}
			if(cells.length > 1){
				$.omMessageBox.alert({

					   type:'error',
			           content:'只能选择一条记录进行操作！'
			       });
				return;
			}
			else{
				Util.post("<%=_path%>/activity/activitySummary.do",{
			        activityId:cells[0].activityId
			       },function(data){
			    	   if(cells[0].status=='0'){
			    		   $.omMessageBox.alert({
			       	           content: '活动尚未提交，请提交并下发!!!'
			       	       });
			    	   }else if(cells[0].status=='2'){
			    		   $.omMessageBox.alert({
			       	           content: '活动已结束!!!'
			       	       });
			    	   }else if(cells[0].status=='1'){
			    		   if(data.total>0){
				       			$.omMessageBox.alert({
				       	            content: '尚有机构未反馈，不能做总结处理!!!'
				       	        });
				       		}else if(data.total==0){//均已完成反馈
								$("#activityIdHidden").val(cells[0].activityId);
								$("#actionName").val("activitySummary");
								$("#soursePage").val("activityQuery");
								document.activityGrid.submit();
				       		}
			    	  }
   		 		});
			}
		}catch(e){
			$.omMessageBox.alert({
		        content:'请选择需查看的记录'
		    });
		}
}

/**
 * 删除记录
 */
 function openDelete(){
	 try{
			var cells = dataGrid.omGrid("getSelections",true);
			if(cells.length<=0){
				$.omMessageBox.alert({
			           content:'请选择需更新的记录'
			       });
				return;
			}
   	    	$.omMessageBox.confirm({
                   title:'确认删除',
                   content:'即将删除活动，您确定要这样做吗？',
                   onClose:function(value){
                       if(value){
                    	   var activityIds=new Array();
                    	   $.each(cells,function(index, value){
                    		   activityIds.push(value.activityId);
                    	   });
                    	   Util.post("<%=_path%>/activity/activityDelete.do",{
              			        activityId:activityIds.join('&')
              			       },function(data){
              			    	   $.omMessageBox.alert({
              			                type:'success',
              			                title:'成功',
              			                content:'<font style="font:bold">删除成功!</font>',
              			           		onClose:function(value){query();}
              			            });
                 		 		});
                       }else{return;}
                   }
               });
		}catch(e){
			$.omMessageBox.alert({
		        content:'请选择需查看的记录'
		    });
		}
}

/**
 * 查看详情
 */
function openDetail(action){
	try{
		var cells = dataGrid.omGrid("getSelections",true);
		if(cells.length<=0){
			$.omMessageBox.alert({
				content:'请选择需更新的记录'
			});
			return;
		}
		if(cells.length > 1){
			$.omMessageBox.alert({

				type:'error',
		        content:'只能选择一条记录进行操作！'
		    });
			return;
		}
		else{
			$("#activityIdHidden").val(cells[0].activityId);
			$("#actionName").val(action);
			$("#soursePage").val("activityQuery");
			if (cells[0].status == '2' && action=='activityModify' ){
				$.omMessageBox.alert({
					type:'error',
	       	        content: '<font color="red">活动已结束,不能修改!!!</font>'
	       	    });
				return;
			}else if(cells[0].status != '0' && action=='activityIssue'){
				$.omMessageBox.alert({
					type:'error',
	       	        content: '活动已完成下发,不能再次下发!!!'
	       	    });
				return;
			}else{
				document.activityGrid.submit();				
			}
		}
	}catch(e){
		$.omMessageBox.alert({
	        content:'请选择需查看的记录'
	    });
	}
}

</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table class="tabBase">
				<tr>
					<td style="padding-left:30px"><span class="label">二级机构：</span></td>
					<td>
						<input name="parentDept" id="parentDept" class="omCombo"/>
						<input name="formMap['deptCode']" type="hidden" id="deptCode" />
					</td>
					<td style="padding-left:30px"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptName']" id="deptName" class="omCombo"/></td>
					<td style="padding-left:30px"><span class="label">活动名称：</span></td>
					<td><input type="text" name="formMap['activityName']" id="activityName"/></td>
					<td style="padding-left:30px"><span class="label">活动状态：</span></td>
					<td><input name="formMap['status']" class="omCombo" id="status" /></td>
				</tr>
				<tr>
					<td style="padding-left:30px"><span class="label">活动日期起：</span></td>
					<td><input class="omDateCalendar" name="formMap['beginDate']" id="beginDate" /></td>
					<td style="padding-left:30px"><span class="label">活动日期止：</span></td>
					<td><input class="omDateCalendar" name="formMap['endDate']" id="endDate" /></td>
					<td colspan="3"></td>
					<td style="text-align:right;"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="operationBar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<div id="dialog"></div>
	<form id = 'activityGrid' name='activityGrid' action="<%=_path%>/activity/activityDetail.do">
	<input id="" type="hidden" value=""/>
	<div>
		<input type="hidden" value="" id="activityIdHidden" name="activityId">
		<input type="hidden" value="" id="actionName" name="actionName">
		<input type="hidden" value="" id="soursePage" name="soursePage">
	</div>
	</form>
</body>
</html>