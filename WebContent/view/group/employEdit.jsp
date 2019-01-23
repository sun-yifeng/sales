<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.sinosafe.xszc.constant.*" %>
<% String salesmanCode = request.getParameter("salesmanCode"); %>
<% String deptCode = request.getParameter("deptCode"); // HR用户所在的机构（四级单位） %>
<% String deptCodeTwo = request.getParameter("deptCodeTwo"); // 分公司  %>
<% String option = request.getParameter("option"); // 处理页面或者详情页面 %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>销售人员详情</title>
<style type="text/css">
*{padding:0;marging:0}
body{font-family:微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun;font-size:12px;color:#1E1E1E;}
.om-grid{border:none;}
html,body{height:100%;margin:0;padding:0;overflow:auto;}
body{font-size:12px}
.om-button{font-size:12px}
#nav_cont{width:580px;margin-left:auto;margin-right:auto}
input{height:18px;border: 1px solid #A1B9DF;vertical-align: middle;}
input:focus{border:1px solid #3a76c2}
.input_slelct{width:81%}
.textarea_text{border:1px solid #a1b9df;height:40px;width:445px}
table.grid_layout tr td{font-weight:normal;height:15px;padding:5px 0;vertical-align:middle}
.color_red{color:red}
.toolbar{padding:12px 0 5px;text-align:center}
.birthplace,.address{width:445px}
.om-span-field input:focus{border:0}
.errorImg{background:url("../../images/msg.png") no-repeat scroll 0 0 transparent;height:16px;width:16px;cursor:pointer}
input.error,textarea.error{border:1px solid red}
.errorMsg{border:1px solid gray;background-color:#fcefe3;display:none;position:absolute;margin-top:-18px;margin-left:18px}
.om-grid .gird-edit-btn{width:190px;
}
</style>
<script type="text/javascript">
var salesmanCode = '<%=salesmanCode%>';
var deptCode = '<%=deptCode%>';
var deptCodeTwo = '<%=deptCodeTwo%>';
$(function(){
	$("#updateSaleUser").find("input").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	//获取CODE用于查询详细数据
	$('#salesmanCode_fk').val(salesmanCode);
	$('#salesmanCode_fk1').val(salesmanCode);
	$('#salesmanCode_fk2').val(salesmanCode);
	//表格的显示与隐藏
	if(deptCode.length == 2){
		$("#deptCodeTr").hide();
		$("#deptTd").show();
		$("#deptsTd").show();
	}
	/* $("#customerManagerRank1").hide();
	$("#customerManagerRank2").hide();
	$("#managerCheck1").hide();
	$("#managerCheck2").hide(); */
	/******初始化tab标签页*********/
	$('#make-tab').omTabs({
	    closable : false
    });
	//出生日期
	$('#birthday').omCalendar({
		  dateFormat : "yy-mm-dd",
		  disabled : true
    });
	//入司日期
	$('#contractDate').omCalendar({
		  dateFormat : "yy-mm-dd",
		  disabled : true
    });
	//性别
	$('#sex').omCombo({
	    dataSource : <%=Constant.getCombo("sex")%>,
	        emptyText : '请选择',
	        readOnly : true,
	        editable : false
	});
	//入职日期
	$('#entryDate').omCalendar({
		  dateFormat : "yy-mm-dd",
		  disabled : true
    });
	//转正日期
	$('#regularDate').omCalendar({
		  dateFormat : "yy-mm-dd",
		  disabled : true
    });
	//离职日期
	$('#quitDate').omCalendar({
		  dateFormat : "yy-mm-dd"
    });
	//加入团队日期
	$('#entryGroupDate').omCalendar({
		  dateFormat : "yy-mm-dd"
    });
	//加入团队日期
	$('#leaveGroupDate').omCalendar({
		  dateFormat : "yy-mm-dd",
    });
	
	//考核日期
	$('#frontDate').omCalendar({
		  dateFormat : "yy-mm-dd"
    });
	//是否参加考核
	$('#evaluate').omCombo({
			dataSource :<%=Constant.getCombo("isYesOrNo")%>,
			emptyText : '请选择',
 		    editable : false
  	});
	//是否试用期
	$('#trytou').omCombo({
		dataSource :<%=Constant.getCombo("isYesOrNo")%>,
		emptyText : '请选择',
	        editable : false
    });
	//业务线
	$('#businessLine').omCombo({
		dataSource : "<%=_path%>/common/queryEmployeeProcessBusinessLine.do",
		onValueChange : function(target, newValue, oldValue, event) {
			//销售职级
			if(newValue == '') {
				$('#saleRank').next().val('请先选择业务线').css({color:"black"});
			} else {
				$('#saleRank').omCombo('setData',[]).omCombo({
					dataSource : '<%=_path%>/lawRank/queryRankByLineCode.do?deptCode='+deptCodeTwo+'&lineCode='+newValue+'&param='+Math.random(),
					onSuccess : function(data, textStatus, event){
						if(data.length==0){
						   $('#saleRank').next().val('该业务线未配置职级！').css({color:"red"});
						}else{
						   $('#saleRank').next().val('请选择').css({color:"black"});
						}
				    }
			    });
			}
		},
		emptyText : '请选择',
	    editable : false
    });
	//处理状态
	$('#processStatus').omCombo({
        dataSource : <%=Constant.getCombo("processStatus")%>,
	    editable : false,
	    emptyText : '请选择'
    });
	//员工状态
	$('#status').omCombo({
		dataSource :"<%=_path%>/common/querySalesmanStatus.do",
		emptyText : '请选择',
		readOnly : true,
	    editable : false
    });
	//是否是销售总监
	$('#director').omCombo({
		dataSource :<%=Constant.getCombo("isYesOrNo")%>,
		emptyText : '请选择',
		readOnly : true,
	    editable : false
    });
	//查询详细
	Util.post("<%=_path%>/salesman/salesmanDetail.do",$("#saleUserFrm").serialize(), function(data) {
		$("#updateSaleUser").find(":text").each(function(){
			$(this).val(data[0][$(this).attr("name")]);
		});
		//销售团队，只取销售人员所在部门的团队
		$('#groupCode').omCombo({
			dataSource : "<%=_path%>/groupMain/queryDeptGroup.do?deptCode="+deptCode+"&param=" + new Date().toTimeString(),
			editable : false,
			value:data[0].groupCode
		});
		//业务线
		$('#businessLine').omCombo({value:data[0].businessLine});
		//销售职级
		$('#saleRank').omCombo({
			dataSource:'<%=_path%>/lawRank/queryRankByLineCode.do?deptCode='+deptCodeTwo+'&lineCode='+data[0].businessLine,
			value:data[0].saleRank,
			emptyText : '请先选择业务线',
	    });
        //在职状态
        $('#status').omCombo({value:data[0].status});
		//是否参加考核
		$('#evaluate').omCombo({value:data[0].evaluate});
		//是否销售总监
		$('#director').omCombo({value:data[0].director});
		//是否试用期
		$('#trytou').omCombo({value:data[0].trytou});
		//处理状态
		$('#processStatus').omCombo({value:data[0].processStatus});
		//性别
		$('#sex').omCombo({value:data[0].sex});
		//职务类型
		$('#titleType').omCombo({value:data[0].titleType});
		//赋值机构
		if(data[0].deptCodeTwo == '00'){
			$('#deptCodes').omCombo({
				value:data[0].deptCode
			});
		}
		//初始化机构
		$('#parentDept').omCombo({
			readOnly : true
		});
		$('#deptName').omCombo({
			readOnly : true
		});
		$('#deptMarket').omCombo({
			readOnly : true
		});
		$('#parentDepts').omCombo({
			readOnly : true
		});
		
		var parentDeptCode = data[0].parentDeptCode;
		var towValue = data[0].saleRankTwo;
		$.ajax({ 
			url: "<%=_path%>/lawDefine/queryBasicLaw.do?deptCode="+parentDeptCode,
			type:"post",
			async: false, 
			dataType: "html",
			success: function(data){
				if(data==1){
					$("#customerManagerRank1").show();
					$("#customerManagerRank2").show();
					$.ajax({ 
						url: "<%=_path%>/lawRank/queryRankName.do?rankCode="+towValue,
						type:"post",
						async: false, 
						dataType: "json",
						success: function(data){
							if(data.jsonStr==undefined){
								$('#saleRankTwo').val("无");
							}else{
								$('#saleRankTwo').val(data.jsonStr);
							}
						}
					});
				}else{
					$("#customerManagerRank1").remove();
					$("#customerManagerRank2").remove();
				}
			}
		});
		
		var saleRank = data[0].rankName;
		if(saleRank!=undefined && saleRank.indexOf("团队经理") == -1){
			$("#customerManagerRank1").remove();
			$("#customerManagerRank2").remove();
		}
		
		$("#saleRankTwo").width("151");
		//地域标识
		var parentDeptCode = data[0].parentDeptCode;
		$.ajax({ 
			url: "<%=_path%>/lawDefine/queryBasicLawArea.do?deptCode="+parentDeptCode,
			type:"post",
			async: false, 
			dataType: "html",
			success: function(data){
				if(data==1){
					$("#isArea").show();
				}else{
					$("#isArea").remove();
				}
			}
		});
		$('#areaBrand').omCombo({value:data[0].area});
    });
	
	$.validator.addMethod("valiEntryGroupDate", function(value) {
    	var frontDate = $("#frontDate").val();
    	var foundDate = '';
    	var groupCode = $("#groupCode").val();
    	$.ajax({ 
			url: "<%=_path%>/groupMain/queryGroupFoundDate.do?groupCode="+groupCode,
			type:"post",
			async: false, 
			dataType: "html",
			success: function(data){
				foundDate = JSON.parse(data).foundDate;
			}
		});
        return value >= frontDate && value >= foundDate;
 	}, '此日期应大于考核时间团队成立时间');
	
	$.validator.addMethod("valiLeaveGroupDate", function(value) {
    	var entryGroupDate = $("#entryGroupDate").val();
    	var frontDate = $("#frontDate").val();
    	var foundDate = '';
    	var groupCode = $("#groupCode").val();
    	$.ajax({ 
			url: "<%=_path%>/groupMain/queryGroupFoundDate.do?groupCode="+groupCode,
			type:"post",
			async: false, 
			dataType: "html",
			success: function(data){
				foundDate = JSON.parse(data).foundDate;
			}
		});
        return value >= frontDate && value >= foundDate && value >= entryGroupDate;
 	}, '此日期应大于加入团队时间,考核时间和团队成立时间');
	
	$("#updateSaleUser").validate({
	   	rules : {
	   		entryGroupDate:{valiEntryGroupDate:true},
	   		leaveGroupDate:{valiLeaveGroupDate:true}
	   	},
	   	messages : {
	   		entryGroupDate:"加入团队时间不能为空,且大于团队成立时间和考核时间",
	   		leaveGroupDate:"此日期应大于加入团队时间,考核时间和团队成立时间"
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
	    },
	    submitHandler : function(){
	        //alert('提交成功！');
	        $(this)[0].currentForm.reset();
	        return false;
	    }
	});
	
	//  
	$('.errorImg').bind('mouseover',function(){
          $(this).next().css('display','block');
    }).bind('mouseout',function(){
          $(this).next().css('display','none');
    });
    //
	$('#tables').omGrid({
		limit:0,
        height : 200,
		singleSelect : true,
		showIndex : false,
		
        colModel : [ {header:"员工代码",name:"salesmanCode",width:150,editor:option=='queryDetail'?null:{editable:false}},
                 	 {header:"员工工号",name:"employCode",width:150, editor:option=='queryDetail'?null:{editable:false}},
                  	 {header:"考核时间" , name:"frontDate",width:200, editor:option=='queryDetail'?null:{editable:false}},
                  	 {header:"加入时间",name:"entryDate",width:150, editor:option=='queryDetail'?null:{editable:false}},
                  	 {header:"离开时间" , name:"leaveDate",width:150,editor:option=='queryDetail'?null:{rules:[["required",true,"关联工号不能为空"],["maxlength",15,"工号长度不能大于15"]],editable:true}},
                  	 {header:"签报号",name:"signNum",width:150, editor:option=='queryDetail'?null:{editable:false}}],
		dataSource : "<%=_path%>/salesman/querySalesmanRecord.do?"+$("#salesmanEmployFrm").serialize()
    });
    //按钮样式
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
	//初始页面
	window.setTimeout('iniPage()',500);
});
var option = '<%=option%>';
//填充页面
function iniPage(){
	$("#saleRankTwo").width("151");
	var ageSalary=$("#ageSalary").val();
	if(ageSalary!=""){
	   $("#ageSalary").val($("#ageSalary").val()+"元");
	}
    //详情
	if (option=='queryDetail'){//详情
		$(".title").text("人员详情");
		//$("#buttonbar").css({'border-style':'border-style:none none solid none;'});
		$("input").css({'background-color':'#F0F0F0','color':'gray'}).attr('readonly','readonly');
		
		$("#frontDate").css({'background-color':'#ffffff '});
		$("#entryGroupDate").css({'background-color':'#ffffff '});
		$("#leaveGroupDate").css({'background-color':'#ffffff '});
		$("#signNum").css({'background-color':'#ffffff '});
		$("#signNum").attr("readonly",false);
		window.setTimeout("$('.sele').omCombo('disable');",500);
	}else{//处理
		$('#buttonbar').omButtonbar({
	           	btns : [{label:"新增",
	            		     id:"addButton" ,
	            		     icons : {left : '<%=_path%>/images/add.png'},
	            	 		 onClick:function(){
	            	 			if ($("#employCode").val()==''){
            	 					$.omMessageBox.alert({
            	 						content:'工号不能为空，请联系管理员！'
            	 					});
            	 					return false;
            	 				}
	            	 			$('#tables').omGrid("insertRow",0,{
	            	 				salesmanCode : salesmanCode,
	            	 				salesmanCname:$("#salesmanCname").val(),
	            	 				certifyNo:$("#certifyNo").val(),
	            	 				employCode:$("#employCode").val(),
	            	 			});
	            	 			
	           	 			 }
	           			},
	           			{separtor:true},
	           	        {label:"删除",
	           	        	id:"delButton",
	           	        	icons : {left : '<%=_path%>/images/remove.png'},
	           	        	onClick:function(){
	           	        		var dels = $('#tables').omGrid('getSelections');
	          	            	if(dels.length != 1 ){
	          	            		$.omMessageBox.alert({
	            	 		 	        content:'请选择一条记录操作',
	            	 		 	        onClose:function(value){
	            	 		 	        	return false;
	            	 		 	        }
	        	 		 	        });
	          	            	}else{
	               	            	$.omMessageBox.confirm({
	            	                       title:'确认删除',
	            	                       content:'你确定要删除该记录吗？',
	            	                       onClose:function(v){
	            	                           if(v){
	            	                        	   $('#tables').omGrid('deleteRow',dels[0]);
	            	                           }
	            	                       }
	            	                });
	          	            	}
	           	        	}
	           	        }
	           	]
	    }).css({'border-style':'none none solid none'});;
	}
	$('#buttonDiv').show();
}

//如果销售职级选择了其他，则提示
function tip(){
    var saleRankValue = $('#saleRank').omCombo("value");
	var saleRanks = $('#saleRank').omCombo('getData');
	var boo = true;
	for(var index=0;index<saleRanks.length;index++){
		if(saleRanks[index].value==saleRankValue&&saleRanks[index].text=="其他"){
			boo = false;
			//因为这个对话框是异步操作，所以不能控制循环后面的操作
	   		$.omMessageBox.confirm({
                title:"确认信息",
                content:"因为“销售职级”选择了“其他”，保存之后此HR人员会失效（前台页面查询不到该人员），该人员的信息会复制到非HR人员当中，确认保存？",
                onClose:function(value){
                    if(!value){
                   		return false;
                    }
                    save();
                }
            });
	   	}
	}
	
	if(boo){
		save();
	}
	
}

//保存
function save(){
	
	if (!$("#updateSaleUser").validate().form())
		return false;
	
	//关联的工号
	var jsonData = JSON.stringify($('#tables').omGrid('getData'));
	$('#salesmanEmployJsonStr').val(jsonData);
	$("#birthdayNew").val($("#birthday").val());
	$("#contractDateNew").val($("#contractDate").val());
	$("#entryDateNew").val($("#entryDate").val());
	$("#regularDateNew").val($("#regularDate").val());
	Util.post("<%=_path%>/salesman/updateSalemanDate.do",$("#updateSaleUser").serialize(), function(data) {
		window.location.href = "employ.jsp";
    });
}
//取消
function cancel(){
	window.location.href = "employ.jsp";
}
</script>
</head>
<body>
<div id="saleGroup">
	<table style="border: solid #d0d0d0 1px;width: 99.9%; margin-top:5px; padding-top: 8px;padding-bottom: 8px;padding-left: 20px;">
		<tr><td class="title">人员处理</td></tr>
	</table>
	<div>
		<form id="saleUserFrm">
			<input type="hidden" name="formMap['salesmanCode']"  id="salesmanCode_fk1"  value=""/>
		</form>
			<form id="updateSaleUser">
			<fieldSet>
			<legend>基本信息</legend>
				<table style="padding-left:30px;">
					<tr>
						<td style="padding-left:30px" align="right"><span class="label">人员编号：</span></td>
						<td><input name="salesmanCode" id="salesmanCode_fk"  readonly="readonly"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px" align="right"><span class="label">工号：</span></td>
						<td><input name="employCode" id="employCode"  readonly="readonly"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td id="deptTd"  style="padding-left: 30px;display:none;" align="right"><span class="label">机构：</span></td>
						<td class="sele" id="deptsTd" style="display:none;"><input name="deptMarket"  id="parentDepts"  readonly="readonly"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr id="deptCodeTr">
						<td style="padding-left:30px" align="right"><span class="label">二级机构：</span></td>
						<td><input class="sele" name="parentDept" id="parentDept" readonly="readonly"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 30px" align="right"><span class="label">三级机构：</span></td>
						<td><input class="sele" name="deptName" id="deptName" readonly="readonly"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 30px" align="right"><span class="label">四级单位：</span></td>
						<td><input class="sele" name="deptMarket"  id="deptMarket"  readonly="readonly"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px;" align="right">姓名：</td>
						<td><input type="text" name="salesmanCname" id="salesmanCname"  readonly="readonly"/></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 30px;" align="right">性别：</td>
						<td><input class="sele" type="text" name="sex"  id="sex" readonly="readonly"/></td>
						<td style="width:20px;"><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px;" align="right">出生年月：</td>
						<td><input class="sele" type="text" name="birthday" id="birthday" readonly="readonly"/>
								<input name="birthday"  id="birthdayNew"  type="hidden"/>
						</td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left: 30px;" align="right">身份证号：</td>
						<td><input type="text" name="certifyNo"  id="certifyNo"  readonly="readonly"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 30px; " align="right">年龄：</td>
						<td><input type="text" name="age"  id="age"  readonly="readonly"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        <td style="padding-left:30px;" align="right">在职状态：</td>
                        <td><input class="sele" type="text" name="status"  id="status" readonly="readonly"/></td>
                        <td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>

                        <td style="padding-left: 30px; " align="right">入司时间：</td>
                        <td><input class="sele" type="text" name="contractDate"  id="contractDate"  readonly="readonly"/><input name="contractDate"  id="contractDateNew"  type="hidden"/></td>
                        <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        <td style="padding-left:30px; " align="right">入职日期：</td>
                        <td><input class="sele" type="text" name="entryDate"  id="entryDate" readonly="readonly"/>
                                <input name="entryDate"  id="entryDateNew"  type="hidden"/>
                        </td>
                        <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        <td style="padding-left: 30px; " align="right">转正日期：</td>
                        <td><input class="sele" type="text" name="regularDate"  id="regularDate" readonly="readonly"/>
                                <input name="regularDate"  id="regularDateNew"  type="hidden"/>
                        </td>
                        <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                    </tr>
                    <tr>
                        <td style="padding-left: 30px;" align="right">司龄工资：</td>
                        <td><input type="text" name="ageSalary"  id="ageSalary"  readonly="readonly"/></td>
                        <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        <td style="padding-left: 30px;" align="right">是否销售总监：</td>
                        <td><input class="sele" type="text" name="director"  id="director" readonly="readonly"/></td>
                        <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        <td style="padding-left: 30px;" align="right">离职时间：</td>
                        <td><input class="sele" type="text" name="quitDate"  id="quitDate" readonly="readonly"/></td>
                        <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                    </tr>
                    <tr>
                        <td style="padding-left: 30px;" align="right">考核时间：</td>
                        <td><input class="sele" type="text" name="frontDate"  id="frontDate" readonly="readonly"/></td>
                        <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                    </tr>
				</table>
				</fieldSet>
				<fieldSet>
			    <legend>需处理项</legend>
				   <table style="padding-left:30px;">
					   <tr>
						<td style="padding-left:30px;" align="right">销售团队：</td>
						<td><input class="sele" name="groupCode" id="groupCode"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:40px;" align="right">业务线：</td>
						<td><input class="sele" type="text" name="businessLine"  id="businessLine" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px;" align="right">是否试用期：</td>
						<td><input class="sele" type="text" name="trytou"  id="trytou" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
					    <td style="padding-left:30px;" align="right">销售职级：</td>
						<td><input class="sele" type="text" name="saleRank" id="saleRank"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:40px;" align="right">是否参加考核：</td>
						<td><input class="sele" type="text" name="evaluate"  id="evaluate" /><span style="color:red">*</span>
								<!--所有新增关联工号封装json字符串 --> 
								<input type="hidden" name="salesmanEmployJsonStr" id="salesmanEmployJsonStr" />
						</td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px;" align="right"  id="customerManagerRank1">客户经理职级：</td>
						<td id="customerManagerRank2"><input class="sele" type="text" name="saleRankTwo"  id="saleRankTwo" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr id="isArea">
					    <td style="padding-left: 30px;" align="right">地域标识：</td>
						<td><input class="sele" type="text" name="areaBrand"  id="areaBrand" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left: 40px;" align="right">加入团队日期：</td>
						<td><input class="sele" type="text" name="entryGroupDate"  id="entryGroupDate" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 40px;" align="right">离开团队日期：</td>
						<td><input class="sele" type="text" name="leaveGroupDate"  id="leaveGroupDate" /><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<input type='text' style="display:none;" name="pkId" id = "pkId"/>
						<td style="padding-left: 40px;" align="right">签报号：</td>
						<td><input type="text" name="signNum"  id="signNum" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
				   </table>
			   </fieldSet>
			</form>
		</fieldSet>
	</div>
    <!-- 关联工号-->
	<div>
		<fieldSet>
			<legend>工号关联</legend>
			<div id="buttonbar"></div>
			<table id="tables"></table>
			<form id="salesmanEmployFrm">
				<input type="hidden" name="formMap['salesmanCode']" id ="salesmanCode_fk2" value="" />
			</form>
		</fieldSet>
	</div>
	<div id="buttonDiv" style="display: none;">
		<table style="width: 100%">
			<tr>
				<td style="padding-top:10px" align="center">
				<a id="button-save" onclick="tip()">保存</a>
				<a id="button-cancel" onclick="cancel()">返回</a>
				</td>
			</tr>
		</table>
	</div>
</div>
</body>
</html>