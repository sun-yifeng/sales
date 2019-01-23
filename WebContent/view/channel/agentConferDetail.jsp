<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<title>个人代理人协议详情</title>
<style>
html,body{height:100%;margin:0;padding:0}
input{height:18px;border:1px solid #a1b9df;vertical-align:middle}
input:focus{border:1px solid #3a76c2}
.fontClass{font-size:12px;font-family:微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun}
</style>
<%
String channelCode = request.getParameter("channelCode");
String conferCode = request.getParameter("conferCode");
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var conferCode = '<%=conferCode%>';
$(function(){
	$("#baseInfo").find("input").css({"width":"151px"});
	$(".sele").css({"width":"130px"});
	$("#conferId").css({"width":"120px"});
	$("#extendConferCode").css({"width":"24px"});
	
	//协议主键，按协议主键加载相关产品
	$('#conferNoFK').val(conferCode);
	
	/*******基本信息**********/
	//是否理财险渠道
	$('#financeChannel').omCombo({
        dataSource:<%=Constant.getCombo("isYesOrNo")%>,
        emptyText:'请选择',
        editable:false,
        readOnly:true
    });
	
	//渠道特征
	$('#feature').omCombo({
		dataSource:"<%=_path%>/common/queryChannelFeature.do",
        optionField:function(data, index) {
            return data.text;
		},
		emptyText:'请选择',
        editable:false,
        readOnly:true
    });
	
	 //协议约定结算方式
	$('#paymentTax').omCombo({
		dataSource:[{text:'按不含税保费结算',value:'1'},{text:'按含税保费结算',value:'2'}],
        optionField : function(data, index) {
            return data.text;
		},
		emptyText : '请选择',
        editable : false,
        readOnly : true
    });
	
	//加载日期控件
    $('#validDate').omCalendar({editable:false,disabled:true});
    $('#expireDate').omCalendar({editable:false,disabled:true});
    $('#signDate').omCalendar({editable:false,disabled:true});
    
    Util.post(
    		"<%=_path%>/mediumConfer/queryAgentConfers.do",$("#conferProductFrm").serialize(),
    		function(data) {
    			$("#baseInfo").find(":input").each(function(){
    				$(this).val(data[0][$(this).attr("name")]);
    			});
    			//是否理财险渠道
    			$('#financeChannel').omCombo({value:data[0].financeChannel});
    			//渠道特征
    			$('#feature').omCombo({value:data[0].feature});
    			$('#paymentTax').omCombo({value : data[0].paymentTax});
    });

    /********产品手续费列表信息**********/
	//初始化联系信息列表
	$('#tables').omGrid({
         limit:10,
         height:350,
 		 singleSelect:false,
         showIndex:true,
         colModel:[ {header:"产品分类" , name:"productType",width:150, align:'center'},
                   	  {header:"产品名称" , name:"productName",width:260, align:'center'},
                      {header:"产品编码" , name:"productCode",width:80, align:'center'},
                  	  {header:"协议约定结算比例（%）",name:"commRate",width:150,align :'center'},
                  	  {header:"按不含税保费结算比例（%）",name:"commissionRate",width:160, align:'center',renderer:function(v,r,i){
                  		  return Number(v).toFixed(4);
                  	  }},
                   	  {header:"特殊批改（%）",name:"endorseRate",width:100, align:'center'}],
			dataSource:"<%=_path%>/conferProduct/queryConferProducts.do?"+$("#conferProductFrm").serialize()
    });

	//加载个人代理人协议附件信息
	Util.post(
		"<%=_path%>/upload/queryUploadByMainId.do?mainId="+conferCode+"&module=04",
		"",
		function(data) {
		    /* getImg("#program-upload-download",data[0]); */
			var sysUrl = "http://ecmp.sinosafe.com.cn:8080/Interface_Cluster/FileShowAction?SystemCode=XSZC01&FunctionCode=XSZC0102&OrgCode=01010000&UserCode=100052692&BatchFlg=0&AuthorizCode=1111&BusinessCode=" + data[0].uploadId;
			 $('#imgSys').attr("href",sysUrl);
		}
	);
	
    //初始化页面取消按钮
	$("#button-cancel").omButton({icons:{left:'<%=_path%>/images/remove.png'},width:50});
});

/**
 * 文件上传下载通用方法（异步获取数据）
 */
function getImg (domId,data){
	if(data != '' && data != undefined){
		$(domId).haImg({
			title:data.name,
			modelCode:'XSZC010104',
			mainBillNo:data.mainId,
			seriesNo:data.uploadId,
			srcUrl:'${sessionScope.imgUrl}',
			operateEmp:data.updatedUser,
			operateCode:'none'
	    });
	}else{
		$(domId).haImg({
			title:'个人代理人协议证书',
			modelCode:'XSZC010104',
			mainBillNo:"",
			seriesNo:'未生成',
			srcUrl:'${sessionScope.imgUrl}',
			//operateEmp:operateEmp,
			operateCode:'none'
		});
	}
}

//取消操作
function cancel(){
	window.location.href = "agentEdit.jsp?flag=1&channelCode="+channelCode;
}
</script>
</head>
<body>
	<div>
		<table class="fontClass" style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
			<tr><td>个人代理人协议详情</td></tr>
		</table>
	</div>
	<div>
		<form id="baseInfo">
			<fieldSet style="margin-top: 10px;">
				<legend class="fontClass" style="margin-left: 40px;">基本信息</legend>
					<table class="fontClass">
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">协议号：</span></td>
							<td><input type="text" name="conferId" id="conferId" readonly="readonly" />-<input type="text" name="extendConferCode" id="extendConferCode" readonly="readonly" /><input type="hidden" name="conferCode" id="conferCode" /></td>
							<!-- <td style="padding-left:30px" align="right"><span class="label">机构编码：</span></td>
							<td><input type="text" name="deptCode" id="deptCode" readonly="readonly" /></td> -->
							<td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
							<td><input type="text" name="deptCname" id="deptCname" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">个人代理人编码：</span></td>
							<td><input type="text" name="channelCode" id="channelCode" readonly="readonly" /></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">姓名：</span></td>
							<td><input type="text" name="channelName" id="channelName" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">签订日期：</span></td>
							<td><input class="sele" type="text" name="signDate" id="signDate" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">生效日期：</span></td>
							<td><input class="sele" type="text" name="validDate" id="validDate" readonly="readonly" /></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">截止日期：</span></td>
							<td><input class="sele" type="text" name="expireDate" id="expireDate" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">结费周期：</span></td>
							<td><input type="text" name="calclatePeriod" id="calclatePeriod" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">是否理财渠道：</span></td>
							<td><input class="sele" type="text" name="financeChannel" id="financeChannel" readonly="readonly" /></td>
						</tr>
						<tr>
							<td style="padding-left:30px" align="right"><span class="label">渠道系数：</span></td>
							<td><input type="text" name="rate" id="rate" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">渠道特征：</span></td>
							<td><input class="sele" type="text" name="feature" id="feature" readonly="readonly" /></td>
							<td style="padding-left:30px" align="right"><span class="label">协议约定结算方式：</span></td>
							<td><input class="sele" type="text" name="paymentTax" id="paymentTax"  readonly="readonly" /></td>
						</tr>
					</table>
			</fieldSet>
			<fieldSet style="margin-top:10px;">
				<legend class="fontClass" style="margin-left: 40px;">详细内容</legend>
				<textarea rows="5" cols="110" class="fontClass" style="margin-left:70px;" name="remark" id="remark" readonly="readonly"></textarea>
			</fieldSet>
		</form>
	</div>
	<div>
		<fieldSet style="margin-top: 10px;">
			<legend class="fontClass" style="margin-left: 40px;">产品手续费</legend>
			<div id="buttonbar"></div>
			<table id="tables"></table>
			<form id="conferProductFrm">
				<input type="hidden" name="formMap['conferCode']" id="conferNoFK" value="" />
			</form>
		</fieldSet>
	</div>
	<!-- 附件上传框 -->
	<!-- <div id="program-upload-download" style="height:180px;"></div> -->
	<!-- 新影像系统bgn -->
      <div>
        <fieldSet>
          <legend>影像资料</legend>
          <div style="margin-left: 20px;margin-bottom: 10px;">
            <a href='#' id="imgSys" target="_blank">个人代理人协议证件</a>
          </div>
        </fieldSet>
      </div>
      <!-- 新影像系统end -->
	<div>
		<table style="width: 100%">
			<tr>
				<td style="padding-right:20px;padding-top:80px" align="center">
				<a class="fontClass" class="om-button" id="button-cancel" onclick="cancel()">返回</a></td>
			</tr>
		</table>
	</div>
</body>
</html>