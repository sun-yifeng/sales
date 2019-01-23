<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>公告查询</title>
<style type="text/css">
    table.tabBase tr td{height: 35px}
</style>
<link rel="stylesheet"  type="text/css"  href="<%=_path%>/view/notice/add.css"/>
<script type="text/javascript" src="<%=_path%>/view/notice/statusRenderer.js?v=123456"></script>
<script type="text/javascript">
var dataGrid;
$(function(){	
	$("#baseInfo").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"133px"});
	
	$(".omDateCalendar").omCalendar();
    $("#status").omCombo({
    	dataSource : [{"text":"待提交","value":"0"},{"text":"待执行","value":"1"},{"text":"执行中","value":"2"},{"text":"执行结束","value":"3"}] ,
    	
		valueField : 'value',
		forceSelction : true,
		
		filterStrategy : 'anywhere'
	});
	
   //初始化列表
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel:tabHand,
		showIndex : false,
		singleSelect : false,
        height:400,
        method : 'POST'
	});
	
		
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	$("#search-panel").omPanel({
    	title : "公告管理  > 公告查询",
    	collapsible:true,
    	collapsed:false
    });
	
	$('#operationBar').omButtonbar({
    	btns : [
    	        
		        {separtor:true},
		        {label:"详情",
				 id:"button-detail",
			     disabled :  false,
				 icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/detail.png'},
		 		 onClick:function(){openDetail("noticeDetail");}
		        },
		        
		        {separtor:true}
			]
    });
	
	//加载初始数据
	//query();
	
	//加载二级机构名称
	$('#parentDept').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#parentDept').omCombo({
				value:eval(data)[1].value,
    			readOnly : true
			});
        },
        onValueChange : function(target, newValue, oldValue, event) {
            $('#deptName').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
        },
        optionField : function(data, index) {
            return data.text;
		},
		filterStrategy : 'anywhere'
    });
	//初始化三级机构名称
	$('#deptName').omCombo({
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		onSuccess:function(data, textStatus, event){
			if(data.length == 2){
        		$('#deptCode').omCombo({
        			value : data[1].value,
        			readOnly : true
        		});
        	}
		}
	});
	
	 query();
	
});


//表头
var tabHand = [
                {header:"公告号",name:"noticId",width:130},
				{header:"公告标题",name:"tiltle",width:130},
				{header:"公告内容",name:"content",width:130},
				{header:"创建时间",name:"createdDate",width:130},
								
				{header:"发布机构名称",name:"deptCode",width:130},
				{header:"发布人",name:"publisher",width:130},
				{header:"公告状态",name:"status",width:130,renderer:statusRender}			
               ];
               
              

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/notice/queryNotice.do?"+$("#filterFrm").serialize());
}

//$("#tables tr").live("dbclick",openDetail);


/**
 * 文件下载
 */
function download(index,e){
	var data = $("#grid").omGrid("getData").rows[index];
}

/**
 * 公告新增
 */
function openSave(){
	location.href = "<%=_path%>/notice/noticeRedirect.do?actionName=noticeOnceAdd&soursePage=noticeOnceQuery";
}


/**
 * 公告总结
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
			           content:'只能选择一条记录进行修改'
			       });
				return;
			}
			else{
				Util.post("<%=_path%>/notice/noticeSummary.do",{
			        noticeId:cells[0].noticeId
			       },function(data){
			    	   if(cells[0].status=='0'){
			    		   $.omMessageBox.alert({
			       	           content: '公告尚未提交，请提交并下发!!!'
			       	       });
			    	   }else if(cells[0].status=='2'){
			    		   $.omMessageBox.alert({
			       	           content: '公告已结束!!!'
			       	       });
			    	   }else if(cells[0].status=='1'){
			    		   if(data.total>0){
				       			$.omMessageBox.alert({
				       	            content: '尚有机构未反馈，不能做总结处理!!!'
				       	        });
				       		}else if(data.total==0){//均已完成反馈
								$("#noticeIdHidden").val(cells[0].noticeId);
								$("#actionName").val("noticeSummary");
								$("#soursePage").val("noticeQuery");
								document.noticeGrid.submit();
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
		        content:'只能选择一条记录进行修改'
		    });
			return;
		}
		else{
			$("#noticId").val(cells[0].noticId);
			$("#actionName").val(action);
			$("#soursePage").val("noticeOnceQuery");
			if (cells[0].status == '2' && action=='noticeModify' ){
				$.omMessageBox.alert({
	       	        content: '公告已结束,不能修改!!!'
	       	    });
				return;
			}else if (cells[0].status == '1' && action=='noticeModify' )
			{
			$.omMessageBox.alert({
	       	        content: '公告已在运行中,不能修改!!!'
	       	    });
				return;
			}else{
				document.noticeGrid.submit();				
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
					<td style="padding-left:30px" align="right"><span class="label">二级机构：</span></td>
					<td>
						<input name="formMap['parentDept']" id="parentDept"  class="sele" />
					</td>
					<td style="padding-left:30px" align="right"><span class="label">三级机构：</span></td>
					<td><input name="formMap['deptName']" id="deptName"  class="sele" /></td>
					
					<td style="padding-left:30px"><span class="label">公告标题：</span></td>
					<td><input type="text" name="formMap['tiltle']" id="tiltle" style="width:158px;"/></td>
					
					<td style="padding-left:30px" nowrap="nowrap"><span class="label">公告状态：</span></td>
					<td><input name="formMap['status']" id="status" /></td>
					
				</tr>
				<tr>
				
					<td style="padding-left:30px" nowrap="nowrap"><span class="label">公告日期起：</span></td>
					<td><input class="omDateCalendar" name="formMap['beginDate']" id="beginDate" /></td>
					<td style="padding-left:30px" nowrap="nowrap"><span class="label">公告日期止：</span></td>
					<td><input class="omDateCalendar" name="formMap['endDate']" id="endDate" /></td>
					<td colspan="3"></td>
					<td  style="padding-left:30px;padding-top:10px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
					
					
				</tr>
				<tr>
				
				</tr>
			</table>
		</div>
	</form>
	<form id = 'noticeGrid' name='noticeGrid' action="<%=_path%>/notice/noticeDetail.do">
	<div id="operationBar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	<div>
		<input type="hidden" value="" id="noticId" name="noticId">
		<input type="hidden" value="" id="actionName" name="actionName">
		<input type="hidden" value="" id="soursePage" name="soursePage">
	</div>
	</form>
</body>
</html>