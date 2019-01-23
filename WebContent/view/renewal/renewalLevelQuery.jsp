<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>续保级别设置查询</title>
<style type="text/css">
    table.tabBase tr td{height: 35px}
</style>
<link rel="stylesheet"  type="text/css"  href="<%=_path%>/view/renewalLevel/add.css"/>
<style>

html, body{ width: 100%; height: 100%; padding: 0; margin: 0;overflow: hidden;}
body {font-size:12px;}
        .om-button {font-size:12px;}
        #nav_cont{width:580px;margin-left:auto;margin-right:auto;}
        input {border: 1px solid #A1B9DF; vertical-align: middle;}
        input:focus{border: 1px solid #3A76C2;}
        .input_slelct {width: 81%;}
        .textarea_text {border: 1px solid #A1B9DF; height: 40px;width: 445px;}
        table.grid_layout tr td {font-weight: normal; height: 15px; padding: 5px 0; vertical-align: middle;}
        .color_red { color: red; }
        .toolbar { padding: 12px 0 5px;text-align: center; }
        .birthplace ,.address {width:445px;}
        .om-span-field input:focus {border:none;}
        .errorImg{background: url("../../images/msg.png") no-repeat scroll 0 0 transparent;height: 16px;width: 16px;cursor: pointer;}
        input.error,textarea.error{border: 1px solid red;}
        .errorMsg{border: 1px solid gray;background-color: #FCEFE3;display: none;position: absolute;margin-top: -18px;margin-left: 18px;}
    
</style>
<script type="text/javascript" src="<%=_path%>/view/renewal/statusRenderer.js?v=123456"></script>
<script type="text/javascript">
var dataGrid;
var validator ;
$(function(){	
	$("#baseInfo").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"133px"});
	
	$(".omDateCalendar").omCalendar();
    $("#assignLevel").omCombo({
    //0-未下发,1-二级机构,2-三级机构,3-营业部,4-团队
    	dataSource : [{"text":"未下发","value":"0"},{"text":"分公司","value":"1"},{"text":"支公司","value":"2"},{"text":"团队经理","value":"3"},{"text":"客户经理","value":"4"}] ,
    	optionField:function(data,index){
    		  return data.value+'-'+ data.text; 
    	},
		valueField : 'value',
		forceSelction : true,
		inputField : function(data,index){
    		  return data.value+'-'+ data.text; 
    	},
		filterStrategy : 'anywhere'
	});
    
    var btnum = $("#search-panel").offset().top+$("#search-panel").outerHeight()+52;
	var bdnum = $("body").offset().top+$("body").outerHeight();
	var topnum = bdnum - btnum;
  	if($.browser.msie&&($.browser.version == "6.0"||$.browser.version == "7.0")){
	  	topnum = topnum + 2;
    }
	
   //初始化列表
	dataGrid = $("#tables").omGrid({
		limit : 10,
		colModel:tabHand,
		showIndex : false,
		singleSelect : false,
        height : topnum-23,
        method : 'POST',
        autoFit : true
	});
	
	$("#button-search").omButton({icons : {left : '<%=_path%>/images/search.png'},width:50});
	
	$("#search-panel").omPanel({
    	title : "续保级别管理  > 续保下发级别设置",
    	collapsible:true,
    	collapsed:false
    });
	
	// 对表单进行校验  remote : "<%=_path%>/renewal/RenewalLevelValidate.do"   remote : "机构不能重复提交"
    validator = $('#addRenewalLevelForm').validate({
        rules : {
        	deptCode : {
        		required : true
        		
        	}, 
        	assignLevel : {required : true}
        }, 
        messages : {
        	deptCode : {
        		required : "机构不能为空"
        		
        	},
        	assignLevel : {required : "下发层级不能为空"}
        },
        errorPlacement : function(error, element) { 
            if(error.html()){
                $(element).parents().map(function(){
                    if(this.tagName.toLowerCase()=='td'){
                        var attentionElement = $(this).next().children().eq(0);
                        attentionElement.css('display','block');
	                    attentionElement.next().html(error);
                    }
                });
            }
        },
        showErrors: function(errorMap, errorList) {
            if(errorList && errorList.length > 0){
                $.each(errorList,function(index,obj){
                    var msg = this.message;
                    $(obj.element).parents().map(function(){
                        if(this.tagName.toLowerCase()=='td'){
                            var attentionElement = $(this).next().children().eq(0);
                            attentionElement.show();
    	                    attentionElement.next().html(msg);
                        }
                    });
                });
            }else{
                $(this.currentElements).parents().map(function(){
                    if(this.tagName.toLowerCase()=='td'){
                        $(this).next().children().eq(0).hide();
                    }
                });
            }
            this.defaultShowErrors();
        }
    });
	
    $('.errorImg').bind('mouseover',function(){
        $(this).next().css('display','block');
    }).bind('mouseout',function(){
        $(this).next().css('display','none');
    });
	
    
	var dialog = $("#renewalLevel").omDialog({
		width: 400,
        autoOpen : false,
        modal : true,
        resizable : false,
        buttons : {
            "提交" : function(){
                if (validator.form()) {
	                Util.post(
	                		"<%=_path%>/renewal/renewalLevelSave.do",
	                		$("#addRenewalLevelForm").serialize(),
	                		function(data){
	                			if(data === "0"){
	                				validator.showErrors({"deptCode": "该机构已经设置下发级别，不能重复设置！！"});
	                			}else{
	                				setTimeout("query()",800);
		                			$("#renewalLevel").omDialog("close");
	                			}
	                		});
	                
                }
            },
            "取消" : function() {
                $("#renewalLevel").omDialog("close");//关闭dialog
                
                //validator.resetForm();
            }
        },
        onOpen : function(event) {
        	$('#deptCodeAdd').omCombo("setData","<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString());
        },
        onClose : function(event) {
        	$('#deptCodeAdd').omCombo("setData",[]);
        	$('.errorImg').hide();
        }
	});
	
	//显示dialog并初始化里面的输入框的数据
	var showDialog = function(title,rowData){
		validator.resetForm();
		rowData = rowData || {};
		$("#deptCode").val(rowData.deptCode);
		$("#assignLevel").val(rowData.assignLevel);
		dialog.omDialog("option", "title", title);
        dialog.omDialog("open");//显示dialog
	};
	
	
	$('#operationBar').omButtonbar({
    	btns : [
    	        {separtor:true},
	    		{label:"新增",
			     id:"button-new" ,
			     icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/add.png'},
		 		 onClick:function(){
		 			showDialog("续保自动下发层级新增");
		 			/* $("#renewalLevel").omDialog("open"); */
		 		 }
				},
				{separtor:true},
		        {label:"删除",
				 id:"button-modify",
			     disabled :  false,
				 icons : {left : Util.appCxtPath + '/core/js/ref/operamasks-ui-2.1/css/default/images/op-edit.png'},
		 		 onClick:function(){
			 			var selections = $('#tables').omGrid('getSelections',true);
			 			if (selections.length == 0) {
		                    alert('请至少选择一行记录');
		                    return false;
		                }
			 			var index = "";
			 			for(var i=0;i<selections.length;i++){
			 				index += ","+selections[i].renewallevelId;
			 			}
			 			index = index.substr(1);
			 			
			 			//alert(selections[0].renewallevelId);
			 			$.omMessageBox.confirm({
		 		           title:'确认删除',
		 		           content:'你确定要这样做吗？',
		 		           onClose:function(v){
		 		               if(v){
		 		            	  Util.post("<%=_path%>/renewal/RenewalLevelDelete.do?index="+index, "", function(data){
		 		            		 setTimeout("query()",800);
		 			               });
		 		               }
		 		           }
		 		       });
			 			
			 		}
		        },
		        {separtor:true}
			]
    });
	
	//加载二级机构名称
	$('#deptCode').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2)
        	$('#deptCode').omCombo({
				value:eval(data)[1].value,
    			readOnly : true
			});
        },
        emptyText : "请选择",
		filterStrategy : 'anywhere'
    });
	
	//加载提交的机构数据   dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ new Date().toTimeString(),
	$('#deptCodeAdd').omCombo({
		filterStrategy : 'anywhere'
    });
	
	setTimeout("query()",800);
});

//表头
var tabHand = [ {header:"编号",name:"renewallevelId",width:130},
				{header:"部门",name:"deptCode",width:130},
				{header:"下发层级",name:"assignLevel",width:130,
					renderer : function(colValue, rowData, rowIndex) {
						var dataCom = $("#assignLevel").omCombo("getData");
						//alert(dataCom[colValue].text);
						return dataCom[colValue].text;
					}
				},
				{header:"创建时间",name:"createdDate",width:130,
				 renderer : function(colValue, rowData, rowIndex) {
					 var date = new Date(colValue);
					 return $.omCalendar.formatDate(date, 'yy-mm-dd');
				  }
				}
               ];

//查询操作parentDept
function query(){
	$("#tables").omGrid("setData","<%=_path%>/renewal/queryRenewalLevel.do?action=query&"+$("#filterFrm").serialize());
}

</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
					<td  nowrap ="nowrap" style="padding-left:15px" align="right"><span class="label">二级机构：</span></td>
					<td>
						<input name="formMap['deptCode']" id="deptCode"  class="sele" />
					</td>
					<td width="50%"></td>
					<td  style="padding-left:15px;" align="right"><span id="button-search" onclick="query()">查询</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="operationBar" style="margin-bottom: 0px;"></div>
	<div id="tables"></div>
	
	<div id="renewalLevel" >
		<form id="addRenewalLevelForm" >
			<table>
				<tr>
					<td align="right">
						请选择机构：
					</td>
					<td align="left">  
						<input type="text" id="deptCodeAdd" name="deptCode" >
					</td>
			   		<td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				
				<tr>
					<td align="right">
						请选择下发层级：
					</td>
					<td align="left">  
						<input type="text" id="assignLevel" name="assignLevel" >
					</td>
			   		<td align="left"><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>