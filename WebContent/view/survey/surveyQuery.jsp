<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import=" com.sinosafe.xszc.constant.*, com.hf.framework.service.security.CurrentUser"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>市场调研管理</title>
<style type="text/css">
html, body{ height:100%; margin:0px; padding:0px;}
body {font-size:12px;}
.div-header {
	width: auto;
	text-align: center;
}
table.gridtable {
	font-family: verdana,arial,sans-serif;
	font-size:12px;
	color:#333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
	width:100%;
	height:100%;
}
table.gridtable tr {
	border-width: 1px;
	padding: 0px;
	border-style: solid;
}
table.gridtable td {
	border-width: 1px;
	padding:0px;
	margin:0px;
	border-style: solid;
}
textarea {
	 border:solid 1px ;
	 border-color: #8c8c8c;
}

.spans{
	width : 100px;
	word-wrap:break-word;
	font-size : 14px;
}

.deptDropListTree {
		position: absolute;
	height: 180px;
    width: 155px;
	margin: 0px auto;
	border: 1px solid #9AA3B9;
	overflow: auto;
	display: none;
	background: #FFF;
	z-index: 4;
}

.STYLE1 {color: #FF0000}
.STYLE2 {width: auto; text-align: center; font-weight: bold; }

</style>
<%
String pkId = request.getParameter("pkId")==null?"":request.getParameter("pkId");
%>
<script type="text/javascript">

$(function(){
	$(".setWidth").css("width","130px");
	$("#tablesNoGrid").css("height","120px");
	
	//var tds = $(".gridtable tr:eq(2)").children('td').eq(1);
	var tdWidth =  710; //tds.width()
	
	var pkId = "<%=pkId %>";
	//alert(pkId);
	if(pkId == "undefined"){
		pkId = "";
	}
	
	if(pkId != "" && pkId != null){
	 	 	$.ajax({
	 			url:"<%=_path%>/marketResInforMain/queryMarketResInforMainByVo.do?pkId="+pkId,
	 			type:"post",
	 			error: function(){
	 				$.omMessageBox.alert({
	 					content:"后台出错！！！"
	 				}); 
	 			}, 
	 			success: function(result){
	 				//alert(JSON.stringify(result));
	 				var jsonResult = eval("["+result+"]");
	 				$("#addSurveyDocument").find(":input").each(function(){
	 					$(this).val(jsonResult[0][$(this).attr("name")]);
	 					$(this).attr("disabled",true);
	 				});
	 				$("#tableAll").find(".spans").each(function(){
	 					//alert($(this).html());
	 					$(this).html(jsonResult[0][$(this).attr("id")]);
	 				});
	 			}
	 		});
	 	}
	
	//
	$('#marketResInforLocal').omGrid({
		dataSource : "<%=_path%>/marketResInforMain/queryMarketResInforLocalByVo.do?pkId="+pkId,
		colModel :MRIlocal,
		height : 200,
		limit : 0,
		width : tdWidth,
		autoFit : true,
		showIndex : false,
	 	onSuccess:function(data, textStatus, event){
	 		var rows = data.rows;
  	       	if(rows != ''){
	  	    	 $("#agencyInfluenceLm").val(rows[0].agencyInfluenceLm);
	  	       	 $("#agencyMeasuresLm").val(rows[0].agencyMeasuresLm);
      	 	}
          }
	});
	
	//onRowDblClick
	$('#marketResInforPremium').omGrid({
		dataSource : "<%=_path%>/marketResInforMain/queryMarketResInforPremiumByVo.do?pkId="+pkId,
		colModel :MRIPremium,
		height : 200,
		limit : 0,
		width : tdWidth,
		autoFit : true,
		showIndex : false,
		onSuccess:function(data, textStatus, event){
			var rows = data.rows;
  	       	if(rows != ''){
	  	    	 $("#agencyInfluenceSip").val(rows[0].agencyInfluenceSip);
	  	       	 $("#agencyMeasuresSip").val(rows[0].agencyMeasuresSip);
   	 		}
          }
	});
	
	 //agencyInfluenceChannel
	 $('#marketResInforChannel').omGrid({
			dataSource : "<%=_path%>/marketResInforMain/queryMarketResInforChannelByVo.do?pkId="+pkId,
			colModel :MRIChannel,
			height : 230,
			limit : 0,
			width : tdWidth,
			autoFit : true,
			showIndex : false,
			onSuccess:function(data, textStatus, event){
				var rows = data.rows;
				if(rows != ''){
		  	    	 $("#agencyInfluenceChannel").val(rows[0].agencyInfluenceChannel);
		  	       	 $("#agencyMeasuresChannel").val(rows[0].agencyMeasuresChannel);
	   	 		}
	          }
		});
	 
	 //设置月份的日期组件
	 $("#insertMonth").omCalendar({
		 disabled : true,
		 dateFormat : "yy-mm"
	 });
	 
	 $("#buttonCancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},});
	 
	 
	//加载下拉框机构组件
     $("#deptDropListTree").omTree({
         dataSource : "<%=_path%>/department/queryDeptDropList.do",
 	    simpleDataModel:true,
 	    //
 	    onBeforeExpand : function(node){
 		  var nodeDom = $("#"+node.nid);
 		  if(nodeDom.hasClass("hasChildren")){
 			nodeDom.removeClass("hasChildren");
 			$.ajax({
 				url: '<%=_path%>/department/queryDeptDropList.do?parentCode='+node.id,
 				method: 'POST',
 				dataType: 'json',
 				success: function(data){
 					$("#deptDropListTree").omTree("insert", data, node);
 				}
 			});
 		 }
 		return true;
 	   },
 	   //触发选择事件时，回填数据到输入框
        onSelect : function(nodedata) {
          var ndata = nodedata, text = ndata.text;
          ndata = $("#deptDropListTree").omTree("getParent", ndata);
          while (ndata) {
 	        //text = ndata.text + "-" + text;
 	        ndata = $("#deptDropListTree").omTree("getParent", ndata);
          }
          //$("#deptCname").val(text); //填充部门名称
          $("#deptCode").val(nodedata.id+"-"+text); //填充部门代码
          hideDropList();
        },
        
        onBeforeSelect : function(nodedata) {
          if (nodedata.children) {
 	        return true;
          }
        }
    });
     
     //点击下拉按钮
     $("#choose").click(function() {
        //showDropList();
     });
     
     //点击输入框
     $("#deptCode").click(function() {
        //showDropList();
     });
     
   //显示下来框
     function showDropList() {  
        $("#deptDropListTree").show();     
        //body绑定mousedown事件
        $("body").bind("mousedown", onBodyDown);
     }
     
     //隐藏下来框
     function hideDropList() {
        $("#deptDropListTree").hide();
        $("body").unbind("mousedown", onBodyDown);
     }
     
     function onBodyDown(event) {
        if(!(event.target.id == "choose" || event.target.id == "deptDropList" || $(event.target).parents("#deptDropList").length > 0)) {
    	       hideDropList();
          }
     }
	 
});

var yearsOptions = {
		dateFormat:"yy-mm" 
};

var MRIlocal = [
       [{header:"内容",name:"contentName",align:"center", rowspan:2},
        {header:"当地市场", colspan:3},
        {header:"我司情况", colspan:3, width : 'autoExpand'}
       ],
       [{header:"当期数据",name:"localYears",align:"center"},
        {header:"上年同期",name:"localYearOnYear",align:"center"},
        {header:"同比",name:"localYearToYear",align:"center"},
        {header:"当期数据",name:"companyYears",align:"center"},
        {header:"上年同期",name:"companyYearOnYear",align:"center"},
        {header:"同比",name:"conpanyYearToYear",align:"center"}
       ]
];

var premiumCombo ={
	    dataSource : [{text : "主要保险公司", value : "1"}, 
	                   {text : "竞争对手", value : "2"}, 
	                   {text : "新驻公司", value : "3"}],
	    editable: false
	};
	
function premiumRenderer(value){
	if(value === "1"){
		return "主要保险公司";
	}else if(value === "2"){
		return "竞争对手";
	}else if(value === "3"){
		return "新驻公司";
	}
}

var MRIPremium = [{header:"保险公司类型",name:"compnayType",align:"center",renderer : premiumRenderer},
                 {header:"保险公司",name:"insuranceCompany",align:"center"},
                 {header:"商业险",name:"busiInsur",align:"center"},
                 {header:"交强险",name:"compulsoryInsur",align:"center"},
                 {header:"财产险",name:"propertyInsur",align:"center"},
                 {header:"人身险",name:"lifeInsur",align:"center"}
                 ];
                 
var MRIChannel = [{header:"渠道名称",name:"channelName",align:"center"},
				 {header:"商业险",name:"busiInsur",align:"center"},
				 {header:"交强险",name:"compulsoryInsur",align:"center"},
				 {header:"财产险",name:"propertyInsur",align:"center"},
				 {header:"人身险",name:"lifeInsur",align:"center"}
				 ];
                 
$.fn.MergeRows = function() {
    return this.each(function() {
        $(this).find('tr').each(function() {
            var s = null;
            var prevTd = null;
            for (var i = 0; i < 3; i++) {// 
                var td = $(this).find('td').eq(i);
                var s1 = td.text();
                if (s1 == s) { //相同即执行合并操作
                    td.hide(); //hide() 隐藏相同的td ,remove()会让表格错位 此处用hide
                    prevTd.attr('colspan', prevTd.attr('colspan') ? parseInt(prevTd.attr('colspan')) + 1 : 2); //赋值colspan属性
                }
                else {
                    s = s1;
                    prevTd = td;
                }
            }
        });
    });
};

function cancel(){
	window.location.href = "survey.jsp";
}
</script>
</head>

<body>
<div>
	<table class="fontClass" style="border: solid #d0d0d0 1px;width: 100%;padding-top: 8px;padding-bottom: 3px;padding-left: 20px;">
		<tr><td>市场调研管理详情</td></tr>
	</table>
</div>
<form id="addSurveyDocument">
	<input type="hidden" name="setLocal" id="setLocal" >
	<input type="hidden" name="setPremium" id="setPremium" >
	<input type="hidden" name="setChannel" id="setChannel" >
	<fieldSet style="margin-top: 10px;">
		<legend class="fontClass" style="margin-left: 40px;">市场调研信息项 </legend>
		<table>
			<tr>
				<td style="padding-left:30px"><span class="label">机构：</span></td>
				<td>
					<span class="om-combo om-widget om-state-default">
					<input class="setWidth" name="deptCode" id="deptCode" readOnly="true"/>
					<span id="choose" name="choose" class="om-combo-trigger"></span>
			   		</span>
			   		<span style="color:red">*</span>
					<div id="deptDropList" >
						<ul id="deptDropListTree" class="deptDropListTree"></ul>
					</div>
				</td>
				<td><span class="errorImg"></span><span class="errorMsg"></span></td>
				<td style="padding-left:30px"><span class="label">统计月份：</span></td>
				<td>
					<input class="setWidth" name="insertMonth" id="insertMonth" readOnly="true" />
				</td>
				<td><span class="errorImg"></span><span class="errorMsg"></span></td>
			</tr>
		</table>
		<table width="97%" height="271%" align="center" class="gridtable" id="tableAll">
		  <tr>
		    <td width="170"><div align="center"><strong>项目</strong></div></td>
		    <td width="458"><div align="center"><strong>信息内容</strong></div></td>
		    <td width="102"><div align="center"><strong>对本机构影响</strong></div></td>
		    <td width="102"><div align="center"><strong>本机构拟采取的对应措施</strong></div></td>
		  </tr>
		  <tr>
		    <td align="center"><strong>当地市场情况</strong></td>
		    <td valign="top">
		    	<div id="marketResInforLocal" >  </div>
		    </td>
		    <td> 
		    	<!-- <textarea rows="9" cols="15" name="agencyInfluenceLm" id="agencyInfluenceLm" ></textarea> -->
		    	<div id="agencyInfluenceLm" class="spans" readOnly="true"></div> 
		    </td>
		    <td> 
		    	<!-- <textarea rows="9" cols="15" name="agencyMeasuresLm" id="agencyMeasuresLm" ></textarea> -->
		    	<div id="agencyMeasuresLm" class="spans" readOnly="true"></div> 
		    </td>
		  </tr>
		  <tr>
		    <td align="center">
		    	<strong>同业公司的外部费用政策（<span class="STYLE1">可按照当地情况进行列举</span>）</strong>
		    </td>
		    <td valign="top">
		    	<!-- &nbsp;&nbsp;
		    	<a id="addPremium">新增</a> &nbsp;&nbsp;&nbsp; 
		    	<a id="delPremium">删除</a>
		    	<br> -->
		    	<div id="marketResInforPremium" >  </div>
		    </td>
		    <td> 
		    	<!-- <textarea rows="10" cols="15" name="agencyInfluenceSip" id="agencyInfluenceSip" ></textarea>  -->
		    	<div id="agencyInfluenceSip" class="spans" readOnly="true"></div> 
		    </td>
		    <td> 
		    	<!-- <textarea rows="10" cols="15" name="agencyMeasuresSip" id="agencyMeasuresSip" ></textarea>  -->
		    	<div id="agencyInfluenceSip" class="spans" readOnly="true"></div> 
		    </td>
		  </tr>
		  <tr>
		    <td height="202"><strong>渠道的费用政策</strong></td>
		    <td valign="top">
		    	<div id="marketResInforChannel" >  </div>
		    </td>
		    <td> 
		    	<!-- <textarea rows="10" cols="15" name="agencyInfluenceChannel" id="agencyInfluenceChannel" ></textarea>  -->
		    	<div id="agencyInfluenceCp" class="spans" readOnly="true"></div> 
		    </td>
		    <td> 
		    	<!-- <textarea rows="10" cols="15" name="agencyMeasuresChannel" id="agencyMeasuresChannel " ></textarea>  -->
		    	<div id="agencyMeasuresCp" class="spans" readOnly="true"></div> 
		    </td>
		  </tr>
		  <tr>
		    <td height="46"><strong>同业电销电销促销政策</strong></td>
		    <td> 
		    	<!-- <textarea rows="3" cols="85" name="sameIndusTeleSales" id="sameIndusTeleSales" ></textarea>  -->
		    	<div id="sameIndusTeleSales" class="spans" style="width:458px" readOnly="true" ></div> 
		    </td>
		    <td> 
		    	<!-- <textarea rows="3" cols="15" name="agencyInfluenceSits" id="agencyInfluenceSits" ></textarea> --> 
		    	<div id="agencyInfluenceSits" class="spans" readOnly="true"></div> 
		    </td>
		    <td> 
		    	<!-- <textarea rows="3" cols="15" name="agencyMeasuresSits" id="agencyMeasuresSits" ></textarea>  -->
		    	<div id="agencyMeasuresSits" class="spans" readOnly="true"></div> 
		    </td>
		  </tr>
		  <tr>
		    <td><strong>监管动态（包括监管、行协下达的文件规定、自律举措、检查工作等）</strong></td>
		    <td> 
		    	<!-- <textarea rows="3" cols="85" name="superviseDynamic" id="superviseDynamic" ></textarea>  -->
		    	<div id="superviseDynamic" class="spans" style="width:458px" readOnly="true"></div> 
		    </td>
		    <td> 
		    	<!-- <textarea rows="3" cols="15" name="agencyInfluenceSd" id="agencyInfluenceSd" ></textarea>  -->
		    	<div id="agencyInfluenceSd" class="spans" readOnly="true"></div> 
		    </td>
		    <td> 
		    	<!-- <textarea rows="3" cols="15" name="agencyMeasuresSd" id="agencyMeasuresSd" ></textarea>  -->
		    	<div id="agencyMeasuresSd" class="spans" readOnly="true"></div> 
		    </td>
		  </tr>
		  <tr>
		    <td height="109"><strong>渠道展业中的困难及需求<br />
		    （如：需派修、总对总协议等）</strong></td>
		    <td><table class="gridtable"  id="tablesNoGrid" >
		      <tr>
		        <td width="12%" align="center">常规</td>
		        <td width="88%"> 
		        	<!-- <textarea rows="1" cols="80" name="channelConventional" id="channelConventional" ></textarea>  -->
		    		<div id="channelConventional" class="spans" style="width:370px" readOnly="true" ></div> 
		        </td>
		      </tr>
		      <tr>
		        <td align="center">重客</td>
		        <td> 
		        	<!-- <textarea rows="1" cols="80" name="channelVip" id="channelVip" ></textarea>  -->
		    		<div id="channelVip" class="spans" style="width:370px" readOnly="true"></div> 
		        </td>
		      </tr>
		      <tr>
		        <td align="center">银保</td>
		        <td> 
		        	<!-- <textarea rows="1" cols="80" name="channelBank" id="channelBank" ></textarea>  -->
		    		<div id="channelBank" class="spans" style="width:370px" readOnly="true"></div> 
		        </td>
		      </tr>
		    </table></td>
		    <td> 
		    	<!-- <textarea rows="5" cols="15" name="agencyInfluenceChannel" id="agencyInfluenceChannel" ></textarea>  -->
		    	<div id="agencyInfluenceChannel" class="spans" readOnly="true"></div> 
		    </td>
		    <td> 
		    	<!-- <textarea rows="5" cols="15" name="agencyMeasuresChannel" id="agencyMeasuresChannel" ></textarea>  -->
		    	<div id="agencyMeasuresChannel" class="spans" readOnly="true" ></div> 
		    </td>
		  </tr>
		  <tr>
		    <td><strong>同业公司的服务新举措（可按照当地情况进行列举）</strong></td>
		    <td> 
		    	<!-- <textarea rows="4" cols="80" name="sameIndusServMeasures" id="sameIndusServMeasures" ></textarea>  -->
		    	<div id="sameIndusServMeasures" class="spans" style="width:458px" readOnly="true"></div> 
		    </td>
		    <td> 
		    	<!-- <textarea rows="4" cols="15" name="agencyInfluenceSism" id="agencyInfluenceSism" ></textarea>  -->
		    	<div id="agencyInfluenceSism" class="spans" readOnly="true"></div> 
		    </td>
		    <td> 
		    	<!-- <textarea rows="4" cols="15" name="agencyMeasuresSism" id="agencyMeasuresSism" ></textarea>  -->
		    	<div id="agencyMeasuresSism" class="spans" readOnly="true"></div> 
		    </td>
		  </tr>
		  <tr>
		    <td height="75"><strong>其它</strong></td>
		    <td colspan="3" > 
		    	<!-- <textarea rows="3" cols="120" name="others" id="others" ></textarea>  -->
		    	<div id="others" class="spans" style="width:658px" readOnly="true"></div> 
		    </td>
		  </tr>
		</table>
	</fieldSet>
</form>
<div>
	<table style="width: 100%">
		<tr>
			<td style="padding-left: 30px; padding-top: 10px" align="center">
				<a id="buttonCancel" onclick="cancel()" >取消</a>
			</td>
		</tr>
	</table>
</div>
</body>
</html>