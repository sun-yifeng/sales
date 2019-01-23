<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">html, body {width:100%;height:100%;padding:0;margin:0;overflow:hidden;}</style>
<title>赔付率清单导出</title>
<script type="text/javascript">
var calcBgn = "", calcEnd = "";
$(function(){
	$(".sele").css({"width":"100px"});
	//导航
	$("#search-panel").omPanel({
    	title : "考核评分管理  > 赔付率清单",
    	collapsible:true,
    	collapsed:false
    });	
    //按钮
    $("#button-search").omButton({icons:{left:'<%=_path%>/images/search.png'},width:50});
    $("#button-excel").omButton({icons:{left:'<%=_path%>/images/excel.png'},width:50});
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
              });               
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
      height : calcHeight1('button-search',50),
      showIndex : true,
      method : 'POST'
    });
    //加载初始数据
    setTimeout("query()", "500");
});
//表头
function setHand(){
	var result = [];
	result.push({header:"分公司",name:"deptNameTwo", rowspan:2,width:100,align:"center"});
	result.push({header:"保单号",name:"policyNo", rowspan:2,width:150,align:"center"});
	result.push({header:"业务员",name:"salesman", rowspan:2,width:120,align:"center"});
	result.push({header:"销售团队",name:"groupName", rowspan:2,width:120,align:"center"});
	result.push({header:"未决金额",name:"wjPrm", rowspan:2,width:100,align:"right"});
	result.push({header:"已决金额",name:"yjPrm", rowspan:2,width:100,align:"right"});
	result.push({header:"满期保费",name:"manQi", rowspan:2,width:100,align:"right"});
	result.push({header:"保险起期",name:"bgnDate", rowspan:2,width:100,align:"center"});
	result.push({header:"保险至期",name:"endDate", rowspan:2,width:100,align:"center"});
	result.push({header:"核保日期",name:"udrDate", rowspan:2,width:100,align:"center"});
	result.push({header:"从MIS取数日期",name:"createdDate", rowspan:2,width:150,align:"center"});
	return result;
}
//年月
function dateInitai(){
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth();
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
        calcHtml+="<option value='0' selected>当年累计赔付</option>";
        calcHtml+="<option value='1'>滚动12个月赔付</option>";
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
//日期变化
function dateChange(){
  var year = $("#year").val();
  var month = $("#month").val();
  if(year == "" || month == "") return;
  var calcPeriod = $("#calcPeriod").val();
  var lastDay = getLastDay(year,month,0);
  if(calcPeriod=="0"){ //当年累计赔付率
    calcBgn = year+"-01-01";
    calcEnd = year+"-"+month+"-"+lastDay;
  }else if(calcPeriod=="1"){ //滚动12个月赔付率
  	var year1 = 2000, month1 = "";
  	if(eval(month)<12) year1 = year-1;
  	var month2 = eval(month)+1;
  	if(month2<10) month1 = "0"+month2; 
  	calcBgn = year1+"-"+month1+"-01";
  	calcEnd = year+"-"+month+"-"+lastDay;
  }
  $("#calcBgn").val(calcBgn);
  $("#calcEnd").val(calcEnd);
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
    $("#tables").omGrid("setData","<%=_path%>/reviewScore/queryClmRateList.do?"+$("#filterFrm").serialize());
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
  window.open("<%=_path%>/reviewScore/exportClmRate.do?"+$("#filterFrm").serialize());
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
        </div>
    </form>
	<div id="tables" class="tables"></div>
</body>
</html>