<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.sinosafe.xszc.constant.*" %>
<% String salesmanCode = request.getParameter("salesmanCode"); %>
<% String deptCode = request.getParameter("deptCode"); // HR用户所在的机构（四级单位） %>
<% String deptCodeTwo = request.getParameter("deptCodeTwo"); // 分公司  %>
<% String option = request.getParameter("option"); // 处理页面或者详情页面 %>
<% String historyId = request.getParameter("historyId"); %>
<% String updatedDate = request.getParameter("updatedDate"); %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>销售人员维护处理或详情历史记录</title>
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
var historyId='<%=historyId%>';
var updatedDate='<%=updatedDate%>';
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
		dataSource : <%=Constant.getCombo("bizLine")%>,
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
	//婚姻状况
	$('#marry').omCombo({
		dataSource : <%=Constant.getCombo("marry")%>,
			emptyText : '请选择',
			readOnly : true,
		    editable : false
    });
	//政治面貌
	$('#party').omCombo({
        dataSource : <%=Constant.getCombo("party")%>,
       	 	emptyText : '请选择',
      	 	readOnly : true,
		    editable : false
    });
	//性别
	$('#sex').omCombo({
        dataSource : <%=Constant.getCombo("sex")%>,
       		emptyText : '请选择',
        	readOnly : true,
		    editable : false
    });
	//员工类型
	$('#salesmanType').omCombo({
        dataSource :"<%=_path%>/common/querySalesmanType.do",
	    emptyText : '请选择',
	    readOnly : true,
		editable : false
    });
	//员工状态
	$('#status').omCombo({
		dataSource :"<%=_path%>/common/querySalesmanStatus.do",
		emptyText : '请选择',
		readOnly : true,
	    editable : false
    });
	//民族
	$('#nation').omCombo({
		dataSource :"<%=_path%>/common/queryNational.do",
		emptyText : '请选择',
		readOnly : true,
	    editable : false
    });
	//学历
	$('#degree').omCombo({
		dataSource :"<%=_path%>/common/queryEducatioin.do",
	        emptyText : '请选择',
	        readOnly : true,
	        editable : false
    });
	//籍贯
	$('#fromAddress').omCombo({
        dataSource :"<%=_path%>/common/queryProvince.do",
	        emptyText : '请选择',
	        readOnly : true,
	        editable : false
    });
	//职务类型
	$('#titleType').omCombo({
        dataSource : [{text : '前台', value : '1'},
                      {text : '后勤', value : '2'},
                      {text : '安管', value : '3'},
                      {text : '经理', value : '4'}],
  		    editable : false,
  		 	readOnly : true
    });
	//查询详细
	Util.post("<%=_path%>/salesman/salesmanHistoryDetail.do",$("#saleUserFrm").serialize(), function(data) {
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
			emptyText : '请先选择业务线'
	    });
		//员工状态
		$('#status').omCombo({value:data[0].status});
		//是否参加考核
		$('#evaluate').omCombo({value:data[0].evaluate});
		//是否试用期
		$('#trytou').omCombo({value:data[0].trytou});
		//处理状态
		$('#processStatus').omCombo({value:data[0].processStatus});
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
    });
	//页面校验
	$("#updateSaleUser").validate({
	   	rules : {
	   		groupCode : "required",
	   		saleRank : "required",
	   		trytou: "required",
	   		evaluate:"required",
	   		businessLine:"required"
	   	},
	   	messages : {
	   		groupCode :"销售团队不能为空",
	   		saleRank  : "销售职级不能为空",
	   		trytou    :  "是否试用期不能为空",
	   		evaluate  :  "是否参加考核不能为空",
	   		businessLine:"业务线不能为空"
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
        colModel : [{header:"员工代码",name:"salesmanCode",width:150,editor:null},
                 	{header:"员工姓名",name:"salesmanCname",width:150,editor:null},
                  	{header:"身份证号码" , name:"certifyNo",width:200,editor:null},
                  	{header:"当前工号",name:"employCode",width:150,editor:null},
                  	{header:"关联工号" , name:"associateCode",width:150,editor:null}],
		dataSource : "<%=_path%>/salesmanEmploy/querySalesmanEmployHistory.do?"+$("#salesmanEmployFrm").serialize()
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
	if($('#businessLine').val()==''){
	   $('#saleRank').next().val('请先选择业务线').css({color:'black'});
	}
	if(($('#businessLine').val()!='')&&($('#saleRank').val()=='')){
	   $('#saleRank').next().val('该业务线下无职级！').css({color:'red'});
	}
    //处理或详情
	if (option=='queryDetail'){//详情
		$(".title").text("人员详情");
		$("#button-save").remove();
		//$("#buttonbar").css({'border-style':'border-style:none none solid none;'});
		$("input").css({'background-color':'#F0F0F0','color':'gray'}).attr('readonly','readonly');
		window.setTimeout("$('.sele').omCombo('disable');",500);
	}else{//处理
		$('#buttonbar').omButtonbar({
	           	btns : [{label:"新增",
	            		     id:"addButton" ,
	            		     icons : {left : '<%=_path%>/images/add.png'},
	            	 		 onClick:function(){
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
	Util.post("<%=_path%>/salesman/updateSalesman.do",$("#updateSaleUser").serialize(), function(data) {
		window.location.href = "employ.jsp";
    });
}
//取消
function cancel(){
	window.location.href = "employHistory.jsp?salesmanCode="+salesmanCode;
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
			<input type="hidden" name="formMap['historyId']"  id="historyId"  value="<%=historyId%>"/>
		</form>
		<fieldSet>
			<legend>基本信息</legend>
			<form id="updateSaleUser">
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
					</tr>
					<tr>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
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
						<td><input class="sele" type="text" name="contractDate"  id="contractDate"  readonly="readonly"/>
								<input name="contractDate"  id="contractDateNew"  type="hidden"/>
						</td>
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
						<td style="padding-left:30px;" align="right">销售团队：</td>
						<td><input class="sele" name="groupCode" id="groupCode"/><span style="color:red">*</span></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 40px;" align="right">业务线：</td>
						<td><input class="sele" type="text" name="businessLine"  id="businessLine" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 30px; " align="right">销售职级：</td>
						<td><input class="sele" type="text" name="saleRank" id="saleRank"/></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					</tr>
					<tr>
						<td style="padding-left:30px; " align="right">是否试用期：</td>
						<td><input class="sele" type="text" name="trytou"  id="trytou" /></td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left: 30px; " align="right">是否参加考核：</td>
						<td><input class="sele" type="text" name="evaluate"  id="evaluate" />
								<!--所有新增关联工号封装json字符串 --> 
								<input type="hidden" name="salesmanEmployJsonStr" id="salesmanEmployJsonStr" />
						</td>
						<td><span class="errorImg"></span><span class="errorMsg"></span></td>
						<td style="padding-left:30px;" align="right">修改者：</td>
						<td><input class=""  "text" name="updatedUser" id="updatedUser"/></td>
					</tr>
					<tr>
					<td style="padding-left:30px;" align="right">修改时间：</td>
						<td><input class="" type="text" name="updatedDate" id="updatedDate"/></td>
					</tr>
				</table>
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
				<input type="hidden" name="formMap['updatedDate2']" id ="" value="<%=updatedDate%>" />
			</form>
		</fieldSet>
	</div>
	<div id="buttonDiv" style="display: none;">
		<table style="width: 100%">
			<tr>
				<td style="" align="center">
				<a id="button-save" onclick="save()">保存</a>
				<a id="button-cancel" onclick="cancel()">返回</a>
				</td>
			</tr>
		</table>
	</div>
</div>
</body>
</html>