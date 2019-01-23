<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*,com.hf.framework.service.security.CurrentUser"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript"  src="<%=_path%>/core/js/huaanUI.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>活动反馈</title>
<style type="text/css">
	body{ margin: 0;}
	.button-stl-tab{color: blue;text-decoration:underline}
	.omDateCalendar,.omCombo{width: 120px;}
</style>
<script type="text/javascript">
var dataGrid;
$(function(){
	$('#downloadPage').omDialog({
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
			openFeedback();
		},
		colModel:tabHand,
		showIndex : false,
        height:400,
        limit : 10,
        method : 'POST'
	});


	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	$("#search-panel").omPanel({
    	title : "活动管理  > 活动反馈",
    	collapsible:true,
    	collapsed:false
    });
	
	$('#operationBar').omButtonbar({
    	btns : btnList
    });
	
	//加载初始数据
	query();
});
	
	
var btnList = [
	    		{label:"反馈	",
			     id:"button-feedback" ,
			     icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
		 		 onClick:function(){openFeedback();}
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
				{header:"本机构反馈状态",name:"feedbackStatusName",width:100},
				{header:"操作",name : 'operation', width: 100, align:'center', renderer:function(colValue, rowData, rowIndex){
            	 return '<span class="button-stl-tab" onClick="download('+rowIndex+',event)">下载</span>';
             	}}
               ];

//查询操作
function query(){
	Util.post("<%=_path%>/activity/queryFeedback.do",$("#filterFrm").serialize(),
			function(data){
				if("errorMsg" in data.whereMap){
					$.omMessageBox.alert({
						type:'error',
						content:data.whereMap.errorMsg
					});
					return false;
				} else {
					$("#tables").omGrid("setData",data);
				}
			});
}


function download(index,e){
	e.stopPropagation();
	var data = $("#tables").omGrid("getData").rows[index];
	$("#downloadPage").html("");
	var opts = {
			title:"方案下载",
			modelCode:"XSZC010201",
			mainBillNo:data.activityId,
			seriesNo:data.uploadId,
			srcUrl:'${sessionScope.imgUrl}',
			operateCode:'none',
			operateEmp:"<%=CurrentUser.getUser().getUserCode()%>"
	};
	$("#downloadPage").haImg(opts);
	$("#downloadPage").omDialog('open');
}
/**
 * 活动反馈
 */
function openFeedback(){
	try{
		var cells = dataGrid.omGrid("getSelections",true);
		var endDate = new Date(cells[0].endDate.replace(/-/g,"/"));
		if(cells.length<=0){
			$.omMessageBox.alert({
				type:'error',
				content:'请选择需更新的记录'
			});
			return;
		}
		if(cells.length > 1){
			$.omMessageBox.alert({
				type:'error',
		        content:'只能选择一条记录进行修改'
		    });
			return;
		}
		if(cells[0].status==2){
			$.omMessageBox.alert({
				type:'error',
		        content:'活动已结束不能反馈！'
		    });
			return false;
		}else if (cells[0].feedbackStatus=='3'){
			$.omMessageBox.alert({
				type:'error',
		        content:'本活动已完成反馈！'
		    });
			return false;
		}/* else if (endDate<new Date()){
			$.omMessageBox.alert({
				type:'error',
		        content:'活动已过期不能反馈！'
		    });
			return false;
		} */else{
			$("#activityIdHidden").val(cells[0].activityId);
			$("#actionName").val('activityFeedback');
			$("#soursePage").val("activityFeedback");
			document.activityGrid.submit();
		}
	}catch(e){
		$.omMessageBox.alert({
			type:'error',
	        content:'请选择需更新的记录'
	    });
	}
}


</script>
</head>
<body>
<div class="remodal-bg">
	<form id="filterFrm">
		<div id="search-panel">
			<table class="tabBase">
				<tr>
					<!-- 
					<td style="padding-left:30px"><span class="label">二级机构：</span></td>
					<td>
						<input name="parentDept" id="parentDept" />
						<input name="formMap['deptCode']" type="hidden" id="deptCode" />
					</td>
					<td style="padding-left:30px"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptName']" id="deptName" /></td>
					 -->
					<td style="padding-left:30px"><span class="label">活动名称：</span></td>
					<td><input type="text" name="formMap['activityName']" id="activityName" /></td>
					<td style="padding-left:30px"><span class="label">活动状态：</span></td>
					<td><input name="formMap['status']" class="omCombo" id="status" /></td>
					<td style="padding-left:30px"><span class="label">活动日期起：</span></td>
					<td><input class="omDateCalendar" name="formMap['beginDate']" id="beginDate" /></td>
					<td style="padding-left:30px"><span class="label">活动日期止：</span></td>
					<td><input class="omDateCalendar" name="formMap['endDate']" id="endDate" /></td>
				</tr>
				<tr>
					<td colspan="8"  style="text-align: right;"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<form id = 'activityGrid' name='activityGrid' action="<%=_path%>/activity/activityFeedbackQuery.do">
	<div id="operationBar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<div>
		<input type="hidden" value="" id="activityIdHidden" name="activityId"/>
		<input type="hidden" value="" id="actionName" name="actionName"/>
		<input type="hidden" value="" id="soursePage" name="soursePage"/>
	</div>
	</form>
	<div id = 'downloadPage' >
	</div>
</div>
</body>
</html>