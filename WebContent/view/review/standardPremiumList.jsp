<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">html, body {width:100%;height:100%;padding:0;margin:0;overflow:hidden;}</style>
<title>标准保费清单导出</title>
<script type="text/javascript">
var calcBgn = "", calcEnd = "", calcEnd1 = "";
$(function(){
   $(".sele").css({"width":"101px"});
	//按钮
	$("#button-search").omButton({icons:{left:'<%=_path%>/images/search.png'},width:50});
	$("#button-excel").omButton({icons:{left:'<%=_path%>/images/excel.png'},width:50});
	//导航
	$("#search-panel").omPanel({
    	title : "考核评分管理  > 保费清单",
    	collapsible:true,
    	collapsed:false
    });
	//分公司
	$('#deptCodeTwo').omCombo({
        dataSource: "<%=_path%>/department/queryDepartmentByUserCode.do?param="+ Math.random(),
        onSuccess:function(data, textStatus, event){
        	if(data.length == 2) { //分公司用户 ,分公司只读
	          $('#deptCodeTwo').omCombo({
			        value:eval(data)[1].value,
	    		    readOnly: true
			      });
        	} else {              //总公司用户,分公司可选
	          $('#deptCodeTwo').omCombo({
			       value:eval(data)[1].value,
	    		   readOnly: false
			    } );       		
        	}
        },
		emptyText: "请选择",
		filterStrategy: 'anywhere'
    });
	 //业务线
    $('#businessLine').omCombo({
		dataSource : [{"text":"常规系列","value":"925007"},{"text":"信保业务","value":"925008"}],
		emptyText : '请选择',
	    editable : false,
	    onSuccess:function(data, textStatus, event){
	    }
    });
	//日期
	dateInitai();
	dateChange();
	//分页
    $("#tables").omGrid({
      limit : 100,
      colModel : setHand(),
      height : calcHeight1('button-search',140),
      showIndex : true,
      method : 'POST'
    });
	//加载初始数据
	setTimeout("initQuery()", "500");
});

function setHand(){
	var result = [];
	result.push({header:"二级机构",name:"deptNameTwo", rowspan:2,width:70,align:"left"});
	result.push({header:"保单号",name:"policyNo", rowspan:2,width:160,align:"left"});
	result.push({header:"批单号",name:"endorseNo", rowspan:2,width:70,align:"center"});
	result.push({header:"业务员",name:"salesman", rowspan:2,width:120,align:"left"});
	result.push({header:"销售团队",name:"groupName", rowspan:2,width:100,align:"left"});
	result.push({header:"签单日期",name:"signDate", rowspan:2,width:80,align:"center"});
	result.push({header:"实收日期",name:"paymentDate", rowspan:2,width:80,align:"center"});
	result.push({header:"核保日期",name:"udrDate", rowspan:2,width:80,align:"center"});
	result.push({header:"保险起期",name:"insuranceStart", rowspan:2,width:80,align:"center"});
	result.push({header:"保险至期",name:"insuranceEnd", rowspan:2,width:80,align:"center"});
	result.push({header:"实收保费",name:"realPremium", rowspan:2,width:60,align:"right"});
	result.push({header:"标准保费",name:"standardPremium", rowspan:2,width:60,align:"right"});
	result.push({header:"业务线",name:"lineName", rowspan:2,width:60,align:"center"});
	result.push({header:"业务线系数",name:"busLineRate", rowspan:2,width:60,align:"center"});
	result.push({header:"产品代码",name:"productNo", rowspan:2,width:60,align:"center"});
	result.push({header:"产品系数",name:"productRate", rowspan:2,width:60,align:"center"});
	result.push({header:"车型",name:"car", rowspan:2,width:100,align:"center"});
	result.push({header:"车型系数",name:"carRate", rowspan:2,width:60,align:"center"});
	result.push({header:"渠道代码",name:"channelCode", rowspan:2,width:120,align:"center"});
	result.push({header:"渠道名称",name:"channelName", rowspan:2,width:120,align:"center"});
	result.push({header:"渠道系数",name:"channelRate", rowspan:2,width:60,align:"center"});
	result.push({header:"业务来源",name:"busOrigin", rowspan:2,width:100,align:"center"});
	result.push({header:"业务来源系数",name:"busOriginRate", rowspan:2,width:80,align:"center"});
	result.push({header:"从MIS取数日期",name:"createdDate", rowspan:2,width:150,align:"center"});
	return result;
}
//数据加载
function initQuery(){
	$("#tables").omGrid("setData","<%=_path%>/reviewScore/queryPlyPrmList.do?"+$("#filterFrm").serialize());
}
//查询按钮
function query(){
  var dept = $("#deptCodeTwo").val();
  var peri = $("#calcPeriod").val();
	if(dept=="" ){
		$.omMessageBox.alert({
 	        content:'请选择你要查询的分公司!',
 	        onClose:function(value){
 	        	return false;
 	        }
	    });
	    return false;
	}
	if(peri==""){
		$.omMessageBox.alert({
 	        content:'请选择统计期!',
 	        onClose:function(value){
 	        	return false;
 	        }
	    });
	    return false;
	}
	$("#tables").omGrid("setData","<%=_path%>/reviewScore/queryPlyPrmList.do?"+$("#filterFrm").serialize());
 }
//导出Excel
function dataToExcel(){
  var dept = $("#deptCodeTwo").val();
  var peri = $("#calcPeriod").val();
  if(dept=="" ){
      $.omMessageBox.alert({
          content:'请选择你要查询的分公司!',
          onClose:function(value){
              return false;
          }
      });
      return false;
  }
  if(peri==""){
      $.omMessageBox.alert({
          content:'请选择统计类型!',
          onClose:function(value){
              return false;
          }
      });
      return false;
  }
  window.open("<%=_path%>/reviewScore/exportPlyPrmList.do?"+$("#filterFrm").serialize());
}
//年月
function dateInitai(){
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    //=================================年份===============================================
    var year1 = year - 10;
    var yearHtml = "<option value='' >请选择</option>";
    for (var i = 0; i < 11; i++){
        if((year1+i)==year){
            yearHtml+="<option value='"+(year1+i)+"' selected>"+(year1+i)+"</option>";
        }else{
            yearHtml+="<option value='"+(year1+i)+"'>"+(year1+i)+"</option>";
        }
    }
    $("#year").html(yearHtml);
    //=================================月份===============================================
    var monthHtml = "<option value='' >请选择</option>";
    for (var i = 1; i<=12; i++){
        var cMonth = i;
        if(i<10)
          cMonth="0"+cMonth;
        if(i==(month)){
            monthHtml+="<option value='"+cMonth+"' selected>"+cMonth+"</option>";
        }else{
            monthHtml+="<option value='"+cMonth+"'>"+cMonth+"</option>";
        }
    }
    $("#month").html(monthHtml);
    //=================================统计类型=============================================
    var calcHtml = "";
        calcHtml+="<option value='' >请选择</option>";
        calcHtml+="<option value='0' selected>当年累计</option>";
        calcHtml+="<option value='1'>当季累计</option>";
        calcHtml+="<option value='2'>当月累计</option>";
    $("#calcPeriod").html(calcHtml);
}
//取月的最后一天
function getLastDay(year,month,addMonth){
  month = eval(month)+addMonth;
  if((month+1)>12) return 31; //当年最后一天
  var date = new Date(year,month,1); //下个月的第一天  
  var date1 = new Date(date.getTime()-1000*60*60*24);
  return date1.getDate(); //获取当月最后一天
}
//取n个月后的月份
function getLastMonth(month,addMonth){
  var month1 = eval(month)+eval(addMonth);
  if(eval(month1)<10) month1="0"+month1;
  if(eval(month1)>12) month1=12;
  return month1;
}
//日期变化
function dateChange(){
  var year = $("#year").val();
  var month = $("#month").val();
  if(year == "" || month == "") return;
  var calcPeriod = $("#calcPeriod").val();
  var lastDay = getLastDay(year,month,0);
  var lastDay1 = getLastDay(year,month,3);
  var month1 = getLastMonth(month,3);
  if(calcPeriod=="0"){ //当年累计
    calcBgn = year+"-01-01";
    calcEnd = year+"-"+month+"-"+lastDay;
    calcEnd1 = year+"-"+month1+"-"+lastDay1;
  }else if(calcPeriod=="1"){ //当季累计
    var quarer = Math.ceil(month/4);
    if(quarer==1){
       calcBgn = "2017-01-01";
       calcEnd = "2017-03-31";
       calcEnd1 = "2017-06-30";
    }else if(quarer==2){
       calcBgn = "2017-04-01";
       calcEnd = "2017-06-30";
       calcEnd1 = "2017-09-30";
    }else if(quarer==3){
       calcBgn = "2017-07-01";
       calcEnd = "2017-09-30";
       endDate1 = "2017-12-31";
    }else if(quarer==3){
       calcBgn = "2017-10-01";
       calcEnd = "2017-12-31";          
       calcEnd1 = "2017-12-31";         
    }
  }else if(calcPeriod=="2"){ //当月累计
    calcBgn = year+"-"+month+"-01";
    calcEnd = year+"-"+month+"-"+lastDay;
    calcEnd1 = calcEnd;
  }
  //通用代码
  $("#calcBgn").val(calcBgn);
  $("#calcEnd").val(calcEnd);
  $("#gotBgn1").val(calcBgn);
  $("#gotEnd1").val(calcEnd);
  $("#insEnd1").val(calcEnd1);
  $("#gotEnd2").val(calcBgn);
  $("#insBgn2").val(calcBgn);     
  $("#insEnd2").val(calcEnd1);
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table style="margin-left:20px">
				<tr>
				    <td align="right" style="padding-left:0px"><span class="label">二级机构：</span></td>
					<td><input style="width:130px;" name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
				    <td align="right" style="padding-left:15px"><span class="label">统计类型：</span></td>
					<td><select name="formMap['calcPeriod']" id="calcPeriod" style="width:135px" onChange="dateChange()"/></td>
					<td align="right" style="padding-left:15px">统计期：</td>
			   		<td colspan="4" align="left">
			   		  <input type="text" name="formMap['calcBgn']" id="calcBgn" class="sele" readonly="readonly">-
			   		  <input type="text" name="formMap['calcEnd']" id="calcEnd" class="sele" readonly="readonly">
			   		</td>
				</tr>
				<tr>
                	<td align="right" style="padding-left:0px"><span class="label">评分年月：</span></td>
					<td>
					   <select name="formMap['year']" id="year" style="width:70px" onChange="dateChange()"></select>年
					   <select name="formMap['month']" id="month" style="width:70px" onChange="dateChange()"></select>月
					</td>
				    <td align="right" style="padding-left:15px"><span class="label">团队名称：</span></td>
					<td><input style="width:130px;" name="formMap['groupName']" id="groupName"/></td>
				    <td align="right" style="padding-left:15px"><span class="label">业务员：</span></td>
					<td><input class="sele" name="formMap['employNo']" id="employNo" width="100"/></td>
					<td colspan="4"><span id="button-search" onclick="query()">查询</span><span id="button-excel" onclick="dataToExcel()">导出</span></td>
				</tr>
			 </table>
			<fieldSet>
			   <legend>统计口径</legend>
			<div id="leftDiv" style="float: left;">
			<table>
			    <tr>
			        <td align="left" style="padding-left:0px" colspan="8">统计当年、当季的保费，保险起期往后延三个月，统计算当月的保费，不往后延三个月。</td>
			    </tr>
			    <tr>
			   		<td align="left" style="padding-left:0px">1、实收日期在当期，保险起期在往期或当期，</td>
			   		<td align="left" style="padding-left:0px">即：</td>
			   		<td align="left" ><input type="text" name="formMap['gotBgn1']" id="gotBgn1" class="sele" readonly="readonly"></td>
			   		<td align="left" style="padding-left:0px">&nbsp;&le;&nbsp;实收日期&nbsp;&le;&nbsp;</td>
			        <td align="left" style="padding-left:0px"><input  type="text" name="formMap['gotEnd1']" id="gotEnd1" class="sele" readonly="readonly"></td>
			        <td align="left" style="padding-left:0px">&nbsp;并且&nbsp;保险起期&nbsp;&le;&nbsp;</td>
			   		<td align="left" style="padding-left:0px"><input type="text" name="formMap['insEnd1']" id="insEnd1" class="sele" readonly="readonly"></td>
			    </tr>
			    <tr>
			        <td align="left" style="padding-left:0px">2、保险起期在当期，实收日期在往期，</td>
			   		<td align="left" style="padding-left:0px">即：</td>
			   		<td align="left" ><input type="text" name="formMap['insBgn2']" id="insBgn2" class="sele" value="" readonly="readonly"></td>
			   		<td align="left" style="padding-left:0px">&nbsp;&le;&nbsp;保险起期&nbsp;&le;&nbsp;</td>
			        <td align="left" ><input  type="text" name="formMap['insEnd2']" id="insEnd2" class="sele" readonly="readonly"></td>
			        <td align="left" style="padding-left:0px">&nbsp;并且&nbsp;实收日期&nbsp;&lt;&nbsp;</td>
			        <td align="left" style="padding-left:0px"><input type="text" name="formMap['gotEnd2']" id="gotEnd2" class="sele" readonly="readonly"></td>
			    </tr>
			</table>
			</div>
			</fieldSet>
		</div>
	</form>
	<tables id="tables" class="tables"/>
</body>
</html>