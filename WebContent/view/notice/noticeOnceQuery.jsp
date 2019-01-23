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
	$(".sele").css({"width":"139px"});
	$(".omDateCalendar").css({"width":"139px"});
	
	$(".omDateCalendar").omCalendar();
    $("#status").omCombo({
    	dataSource : [{"text":"请选择","value":""},{"text":"草稿","value":"0"},{"text":"已发布","value":"1"},
    	              {"text":"执行结束","value":"3"},{"text":"待发布","value":"5"}] ,
    	
	 emptyText:'请选择',
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
        height:425,
        autoFit : true,
        method : 'POST'
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	$("#search-panel").omPanel({
    	title : "公告管理  > 单次公告查询",
    	collapsible:true,
    	collapsed:false
    });
	
	$('#operationBar').omButtonbar({
    	btns : [
	    		{label:"新增",
			     id:"button-new" ,
			     icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
		 		 onClick:function(){openSave();}
				},
				{separtor:true},
				{label:"修改",
				     id:"button-update" ,
				     icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
			 		 onClick:function(){openDetail("noticeModify");}
					},
				{separtor:true},
		        {label:"删除",
				 id:"button-modify",
			     disabled :  false,
				 icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/remove.png'},
		 		 onClick:function(){openDetail("noticeDelete");}
		        },
		        {separtor:true},
		        {label:"详情",
				 id:"button-detail",
			     disabled :  false,
				 icons : {left : Util.appCxtPath + '/images/detail.png'},
		 		 onClick:function(){openDetail("noticeDetail");}
		        }/* ,
		        
		        {separtor:true},
		        {label:"提交",
				 id:"button-submit",
			     disabled :  false,
				 icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
		 		 onClick:function(){openDetail("noticeSubmit");}
		        } */
			]
    });
	
	//获取角色权限 修改相应功能
	$.ajax({ 
		url: "<%=_path%>/common/findRolesInSystemByUserCode.do",
		type:"post",
		async: false, 
		dataType: "html",
		success: function(roleEname){
			
			if(roleEname == "thirdDeptBusiMana" || roleEname == "thirdDeptMiddle"){
 				$("#button-new").parent().parent().hide();
				$("#button-modify").parent().parent().hide();
				$("#button-submit").parent().parent().hide(); 
			}else{
 				$("#button-new").omButton("enable");
				$("#button-modify").omButton("enable");
				$("#button-submit").omButton("enable"); 
			}
		}
	});
	
	//加载初始数据
	//query();
	
	$('#parentDept').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#parentDept').omCombo({
				value:eval(data)[1].value,
    			readOnly : true
			});
        },
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	//初始化三级机构名称
	$('#deptName').omCombo({
		dataSource : [ {text : '华安财产保险', value : '00'}],
		value : '00',
		valueField : 'value',
		inputField : 'text',
        readOnly : true
	});
	 //query();
	setTimeout("query()",500);
});

//表头
var tabHand = [
                {header:"公告号",name:"noticId",width:250},
				{header:"公告标题",name:"tiltle",width:150},
				{header:"公告内容",name:"content",width:300},
				/* {header:"创建时间",name:"createdDate",width:150}, */
				{header:"发布时间",name:"publishDate",width:100},
				{header:"发布机构名称",name:"deptCname",width:150},
				{header:"公告状态",name:"status",width:100,renderer:statusRender},
				{header:"发送层级",name:"RELATION_TYPE",width:100,renderer:relationRender}
               ];

//查询操作
function query(){
	$("#tables").omGrid("setData","<%=_path%>/notice/queryNotice.do?action=peroidOnce&"+$("#filterFrm").serialize());
}

/**
 * 公告新增
 */
function openSave(){
	location.href = "<%=_path%>/notice/noticeRedirect.do?actionName=noticeOnceAdd&soursePage=noticeOnceQuery";
}



/**
 * 查看详情
 */
function openDetail(action){
	try{
	    var sourcePage = "noticeOnceQuery";
		var cells = dataGrid.omGrid("getSelections",true);
		if(cells.length<=0){
			$.omMessageBox.alert({
				content:'请选择需操作的记录'
			});
			return;
		}
		if(cells.length > 1){
			$.omMessageBox.alert({
		        content:'只能选择一条记录进行处理'
		    });
			return;
		}
		else{
			if (cells[0].status == '1' && action=='noticeDelete' ){
				$.omMessageBox.alert({
	       	        content: '公告正在运行,不能删除'
	       	    });
				return;
			}else if (cells[0].status == '3' && action=='noticeDelete' ){
				$.omMessageBox.alert({
	       	        content: '公告已结束,不能删除'
	       	    });
				return;
			}else if (action=='noticeDelete')
			{			
			
				$.omMessageBox.confirm({
		           title:'确认信息',
		           content:'是否要删除这些记录?',
		           onClose:function(v)
		           {
			            if(v){
				 				               
							var noticIds = "";
						    for (var i=0; i < cells.length ; i ++)
						    {
						     	noticIds += (cells[i].noticId+ ",");
						    }			
							$("#noticIds").val(noticIds);
							$("#actionName").val(action);
							$("#soursePage").val(sourcePage);
							document.noticeGrid.action = "<%=_path%>/notice/noticeDelete.do";
							document.noticeGrid.submit();
								
							return;
						}
					}
				}
				);
				return;
			}
			
			$("#noticId").val(cells[0].noticId);
			$("#actionName").val(action);
			$("#soursePage").val(sourcePage);
			
			if (cells[0].status == '3' && action=='noticeModify' ){
				$.omMessageBox.alert({
	       	        content: '公告已结束,不能修改'
	       	    });
				return;
			}
			
			if (cells[0].status == '3' && action=='noticeSubmit' ){
				$.omMessageBox.alert({
	       	        content: '公告已结束,不能发布'
	       	    });
				return;
			}else if ((cells[0].status == '1') && action=='noticeSubmit' )
			{
			$.omMessageBox.alert({
	       	        content: '公告已在运行中,不能发布'
	       	    });
				return;
			}else{
			if (action=='noticeSubmit')
			{
				Util.post("<%=_path%>/notice/noticeSubmit.do?noticId="+cells[0].noticId,null,
					function(data){
						$.omMessageBox.alert({
			                type:'success',
			                title:'成功',
			                content:'<font style="font:bold">提交成功！！</font>',
			                onClose:function(value){
			                    query();
			                }
			            });
					});	
				}	
			
				else
				{
				  document.noticeGrid.submit();	
							
				}
			}
		}
	}catch(e){
		$.omMessageBox.alert({
	        content:'请选择需查看的记录'
	    });
	}
}

function relationRender(svalue){
  	if(svalue == "0"){  			
 		return "总公司-分公司";
	}else if (svalue == "1"){
		return "分公司-支公司";
	}else if (svalue == "2"){
		return "总公司-支公司";
	}
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td style="padding-left:15px" align="right"><span class="label">发布一级机构：</span></td>
					<td><input name="formMap['deptName']" id="deptName"  class="sele" /></td>
					<td style="padding-left:15px" align="right"><span class="label">发布二级机构：</span></td>
					<td>
						<input name="formMap['parentDept']" id="parentDept"  class="sele" />
					</td>
					<td style="padding-left:15px" align="right" ><span class="label">公告标题：</span></td>
					<td><input type="text" name="formMap['tiltle']" id="tiltle" style="width:158px;"/></td>
					
					<td style="padding-left:15px" align="right" nowrap="nowrap"><span class="label">公告状态：</span></td>
					<td><input name="formMap['status']" id="status" /></td>
					
				</tr>
				<tr>
				
					<td style="padding-left:15px" align="right" nowrap="nowrap"><span class="label">公告日期起：</span></td>
					<td><input class="omDateCalendar" name="formMap['beginDate']" id="beginDate" /></td>
					<td style="padding-left:15px" align="right" nowrap="nowrap"><span class="label">公告日期止：</span></td>
					<td><input class="omDateCalendar" name="formMap['endDate']" id="endDate" /></td>
					<td colspan="3"></td>
					<td  style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
					
					
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
		<input type="hidden" value="" id="noticIds" name="noticIds">
		<input type="hidden" value="" id="actionName" name="actionName">
		<input type="hidden" value="" id="soursePage" name="soursePage">
	</div>
	</form>
</body>
</html>