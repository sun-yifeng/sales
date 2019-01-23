<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*" %>
<% String rankId = request.getParameter("rankId"); %>
<% String rankCode = request.getParameter("rankCode"); %>
<% String deptCodeTwo = request.getParameter("deptCodeTwo"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>职级调整</title>

<style type="text/css">
	html, body{ height:100%; margin:0px; padding:0px;}
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
<script type="text/javascript">
var rankId = '<%=rankId%>';
var deptCodeTwo = '<%=deptCodeTwo%>';
var rankCode = '<%=rankCode%>';
$(function(){
	$("#rankId").val(rankId);
	//调整职级
	$('#confirmRank').omCombo({
		optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        lazyLoad:true,
		width : '171px',
    }); 
	
	//(客户经理)调整职级
	$('#cusConfirmRank').omCombo({
		optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        lazyLoad:true,
		width : '171px',
    }); 
	
	//填充页面
	Util.post("<%=_path%>/reviewRank/findReviewRankDetail.do?&rankId="+rankId,"",function(data) {
		$("#rankConfirmForm").find(":input").each(function(){
			  $(this).val(data[$(this).attr("name")]);
			});
		if(data.cusRecommendRankName == "---"){
			$("#customerRank").remove();
			 $('#confirmRank').omCombo('setData',"<%=_path%>/lawRank/queryConfirmRank.do?deptCodeTwo="+deptCodeTwo+"&rankCode="+rankCode+"&rankId="+rankId);
			 $("#confirmRank").omCombo('value',data.confirmRank);
		}else{
			$('#confirmRank').omCombo('setData',"<%=_path%>/lawRank/queryConfirmRank.do?deptCodeTwo="+deptCodeTwo+"&rankCode="+rankCode+"&rankId="+rankId);
			$('#cusConfirmRank').omCombo('setData',"<%=_path%>/lawRank/queryCusAdjustRank.do?rankId="+rankId+"&deptCodeTwo="+deptCodeTwo);
			$("#confirmRank").omCombo('value',data.confirmRank);
			$("#cusConfirmRank").omCombo('value',data.cusConfirmRank);
		}
		
    });
	
	
	//页面校验
    $("#rankConfirmForm").validate({
     	rules : {
     		confirmRank : "required"
     	},
     	messages : {
     		confirmRank:"调整职级不能为空"
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
             $(this)[0].currentForm.reset();
             return false;
         }
     }); // end  页面校验
	  
	  $('.errorImg').bind('mouseover',function(){
          $(this).next().css('display','block');
      }).bind('mouseout',function(){
          $(this).next().css('display','none');
      });
	
	//保存、取消按钮样式
	$("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
	$("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});

});

//保存职级调整操作
function save(){
	var confirmRankCode = $("#confirmRank").val();           //调整职级
	//页面校验
	if (!$("#rankConfirmForm").validate().form()){
		return false;
	} 

	if(confirmRankCode==""){
		 $.omMessageBox.alert({
	 	        content: '调整职级不能为空！'
	 	    });
	        return false;
	}
		Util.post("<%=_path%>/reviewRank/chnageReviewRank.do?",$("#rankConfirmForm").serialize(), function(data) {
			//保存成功后跳转回
			window.location.href = "rankAdjust.jsp";
	    });
}

function cancel(){
	window.location.href = "rankAdjust.jsp";
}
</script>
</head>
<body>
    <div id="saleGroup">
	<table style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
		<tr><td>职级调整</td></tr>
	</table>
	<div>
	<fieldSet style="margin-top: 10px;">
		<legend style="margin-left: 40px;font-size:12px;">基本信息</legend>
		<form id="rankConfirmForm">
               <input type="hidden" name="rankId" id="rankId"  value=""/>
			<table align="center"  style="font-size: 12px;">
				<tr>
					<td style="padding-left: 30px" align="right"><span class="label">考核年月：</span></td>
					<td><input name="calcMonth" id="calcMonth" readonly="readonly"/></td>
					<td style="padding-left: 30px" align="right"><span class="label">二级机构：</span></td>
					<td><input name="deptNameTwo" id="deptNameTwo"  readonly="readonly"/></td>
					<td style="padding-left: 30px" align="right"><span class="label">三级机构：</span></td>
					<td><input name="deptNameThree"  id="deptNameThree"   readonly="readonly"/></td>
				</tr>
				<tr>
					<td style="padding-left: 30px;" align="right">四级单位代码：</td>
					<td><input type="text" name="deptCodeFour" id="deptCodeFour"  readonly="readonly"/></td>
					<td style="padding-left: 30px;" align="right">四级单位名称：</td>
					<td><input type="text" name="deptNameFour" id="deptNameFour"  readonly="readonly" /></td>
					<td style="padding-left: 30px;" align="right">团队名称：</td>
					<td><input type="text" name="groupName"  id="groupName"   readonly="readonly"/></td>
				</tr>
				<tr>
					<td style="padding-left: 30px;" align="right">人员代码：</td>
					<td><input type="text" name="salesmanCode"  id="salesmanCode"  readonly="readonly"/></td>
					<td style="padding-left: 30px; " align="right">人员名称：</td>
					<td><input type="text" name="salesmanName"  id="salesmanName"  readonly="readonly"/></td>
					<td style="padding-left: 30px;" align="right">当前职级：</td>
					<td><input type="text" name="rankName" id="rankName" readonly="readonly"/></td>
				</tr>
				<tr>
					<td style="padding-left: 30px; " align="right">考核得分：</td>
					<td><input type="text" name="rankScore"  id="rankScore"  readonly="readonly"/></td>
					<td style="padding-left: 30px; " align="right">年化标准保费达成率：</td>
					<td><input type="text" name="premRate"  id="premRate"  readonly="readonly" /></td>
					<td style="padding-left: 30px; " align="right">评定结果：</td>
					<td><input type="text" name="reviewResult"  id="reviewResult" readonly="readonly"/></td>
				</tr>
				<tr>
					<td style="padding-left: 30px; " align="right">推荐职级：</td>
					<td><input type="text" name="recommendRankName" id="recommendRankName" readonly="readonly"/></td>
					<td style="padding-left: 30px;" align="right">签报号：</td>
					<td><input type="text" name="signNo"  id="signNo"  /></td>
					<td style="padding-left: 30px; " align="right">调整职级：</td>
					<td><input name="confirmRank"  id="confirmRank"/><span style="color:red">*</span></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				</tr>
				<tr id="customerRank">
				    <td style="padding-left: 30px; " align="right">(客户经理)评定结果：</td>
					<td><input type="text" name="cusReviewResult"  id="cusReviewResult" readonly="readonly"/></td>
					<td style="padding-left: 30px; " align="right">(客户经理)推荐职级：</td>
					<td><input type="text" name="cusRecommendRankName" id="cusRecommendRankName" readonly="readonly"/></td>
					<td style="padding-left: 30px; " align="right">(客户经理)调整职级：</td>
					<td><input name="cusConfirmRank"  id="cusConfirmRank"/></td>
					<td><span class="errorImg"></span><span class="errorMsg"></span></td>
					<td><input type="hidden" name="confirmRankName"  id="confirmRankName" /></td>
					<td><input type="hidden" name="cusConfirmRankName"  id="cusConfirmRankName" /></td>
					<td><input type="hidden" name="cusRecommendRank"  id="cusRecommendRank" /></td>
				</tr>
			</table>
		</form>
	</fieldSet>
	</div>
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-left:30px;padding-top:10px" align="center">
				<a id="button-save" onclick="save()">保存</a>
				<a id="button-cancel"  onclick="cancel()">取消</a></td>
			</tr>
		</table>
	</div>
</div>
</body>
</html>