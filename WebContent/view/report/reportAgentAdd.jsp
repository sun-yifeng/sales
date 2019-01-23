<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
html,body{width:100%; height:100%;padding:0;margin:0;} /*自动计算分页高度需要重置样式*/
</style>
<title>全民营销代理人增员情况</title>
<script type="text/javascript">
$(function(){   
	$("#filterFrm").find("input[name^='formMap']").css({"width":"150px"});
	$(".sele").css({"width":"130px"});
	//导航
	$("#search-panel").omPanel({
	  title : "报表管理  > 全民营销代理人增员情况",
	  collapsible:true,
	  collapsed:false
	});
	//按钮
	$("#button-search").omButton({icons:{left:'<%=_path%>/images/search.png'},width:50});
	$("#button-excel").omButton({icons:{left:'<%=_path%>/images/excel.png'},width:50});
    //二级机构
    $('#deptCodeTwo').omCombo({
        dataSource : "<%=_path%>/department/queryDepartmentByUserCode.do?param="+Math.random(),
        onSuccess  : function(data, textStatus, event){
            //如果是分公司登录
            if(data.length == 2){
            	//分公司不可以选择分公司
                $('#deptCodeTwo').omCombo({value:eval(data)[1].value, readOnly : true});
                //取三级机构下拉框的数据
                $('#deptCodeThree').omCombo({
                    dataSource : "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+data[1].value,
                    onSuccess  : function(data, textStatus, event){
                        if(data.length == 2){
                            $('#deptCodeThree').omCombo({value:eval(data)[1].value,readOnly : true});
                            //取四级单位下拉框
                            $('#deptCodeFour').val('').omCombo({
                                dataSource : "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+$("#deptCodeThree").val(),
                                onSuccess  : function(data, textStatus, event){
                                    if(data.length == 2){
                                        $('#deptCodeFour').omCombo({value:eval(data)[1].value,readOnly : true});
                                    }
                                }
                            });
                        }
                    }
                });
            }
        },
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptCodeTwo').omCombo('value');
            if(currentParentDept != ''){
                $('#deptCodeThree').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentCityByUserCode.do?upDept="+newValue);
            }else{
                $('#deptCodeThree').omCombo({
                   dataSource : [ {text : '请选择', value : ''} ]
                });
            }
            $('#deptCodeFour').omCombo('setData',[]);
        },
        emptyText : "请选择",
        filterStrategy : 'anywhere'
    });
    //三级机构
    $('#deptCodeThree').omCombo({
        onValueChange : function(target, newValue, oldValue, event) {
            var currentParentDept = $('#deptCodeThree').omCombo('value');
            if(currentParentDept != ''){
                $('#deptCodeFour').val('').omCombo('setData', "<%=_path%>/department/queryDepartmentMarketByUserCode.do?upDept="+newValue);
            }else{
                $('#deptCodeFour').omCombo({
                     dataSource : [ {text : '请选择', value : ''} ]
                });
            }
        },
        emptyText : "请选择",
        valueField : 'value',
        inputField : 'text',
        filterStrategy : 'anywhere'
    });
    //四级单位
    $('#deptCodeFour').omCombo({
        emptyText : "请选择",
        valueField : 'value',
        inputField : 'text',
        filterStrategy : 'anywhere'
   });
   //证件有效性
   $('#certifyValid').omCombo({
       dataSource : [{"text":"请选择","value":""},{"text":"未过期","value":"0"},{"text":"已过期","value":"1"}],
       optionField : function(data, index) {
           return data.value+'-'+data.text;
       },
       valueField : 'value',
       inputField : 'text',
       value : ''
   });
   //推荐人在职
   $('#salesStatus').omCombo({
       dataSource : [{"text":"请选择","value":""},{"text":"是","value":"1"},{"text":"否","value":"0"}],
       optionField : function(data, index) {
           return data.value+'-'+data.text;
       },
       valueField : 'value',
       inputField : 'text',
       value : ''
   });
   //推荐人为空
   $('#salesEmpty').omCombo({
       dataSource : [{"text":"请选择","value":""},{"text":"是","value":"1"},{"text":"否","value":"0"}],
       optionField : function(data, index) {
           return data.value+'-'+data.text;
       },
       valueField : 'value',
       inputField : 'text',
       value : ''
   });
   //日期 
   $('#reportDateBgn').omCalendar({
     dateFormat:"yy-mm-dd",
     editable:true
   });
   $('#reportDateEnd').omCalendar({
     dateFormat:"yy-mm-dd",
     editable:true
   });
   $('#reportDateBgn').val(getBgnDay());
   $('#reportDateEnd').val(getEndDay());
   //分页 
   $("#tables").omGrid({
      colModel:setHand(),
      showIndex:true,
      height:calcHeight1('search-panel',20),
      method:'POST',
      limit:20
	});
    
    setTimeout("query()", "500");
});

function setHand(){
    var result = [];
    result.push({header:"二级公司",name:"deptNameTwo",rowspan:2,width:100,align:"center"});
    result.push({header:"三级公司",name:"deptNameThree",rowspan:2,width:100,align:"center"});
    result.push({header:"四级单位",name:"deptNameFour",rowspan:2,width:100,align:"center"});
    result.push({header:"销售团队",name:"groupName",rowspan:2,width:100,align:"center"});
    result.push({header:"人代姓名",name:"channelName",rowspan:2,width:60,align:"center"});
    result.push({header:"代理人代码",name:"channelCode",rowspan:2,width:60,align:"center"});
    result.push({header:"电话号码",name:"mobile", rowspan:2,width:80,align:"center"});
    result.push({header:"性别",name:"sex", rowspan:2,width:40,align:"center"});
    result.push({header:"出生年月",name:"birthday",rowspan:2,width:80,align:"center"});
    result.push({header:"学历",name:"education",rowspan:2,width:60,align:"center"});
    result.push({header:"推荐人",name:"recommenderName",rowspan:2,width:80,align:"center",
        renderer : function(colValue, rowData, rowIndex) {
            if (colValue=="") {
                return '无';
            } else{
                return colValue;
            }
        }   
    });
    result.push({header:"推荐人在职",name:"salesStatus", rowspan:2,width:80,align:"center"});
    result.push({header:"推荐人分类",name:"salesCategory", rowspan:2,width:80,align:"center"});
    result.push({header:"证件有效性标识",name:"newStatus", rowspan:2,width:100,align:"center"});
    result.push({header:"协议签订日期",name:"signDate", rowspan:2,width:80,align:"center"});
    result.push({header:"协议生效日期",name:"validDate", rowspan:2,width:80,align:"center"});
    result.push({header:"协议截止日期",name:"expireDate", rowspan:2,width:80,align:"center"});
    result.push({header:"代理人录入日期",name:"reportMoth", rowspan:2,width:80,align:"center"});
    return result;
}

//查询操作
function query(){
    $("#tables").omGrid("setData","<%=_path%>/channelMain/queryAgentALL.do?"+$("#filterFrm").serialize());
}

//导出Excel
function dataToExcel(){
    window.open("<%=_path%>/channelMain/queryDataToExcel.do?"+$("#filterFrm").serialize());
}

function getBgnDay(){
	var date = new Date();
	var year = date.getFullYear();
	var month = date.getMonth()+1;
	if(month<10) month = '0'+month;
	return year+'-'+month+'-01';;
}

function getEndDay(){
	var date = new Date();
	var year = date.getFullYear();
	var month = date.getMonth()+1;
	if(month<10) month = '0'+month;
	var day = date.getDate();
	if(day<10) day = '0'+day;
	return year+'-'+month+'-'+day;
}
</script>
</head>
<body>
	<form id="filterFrm">
		<div id="search-panel">
			<table>
				<tr>
                    <td align="right" style="padding-left:15px"><span class="label">二级机构：</span></td>
                    <td><input class="sele" name="formMap['deptCodeTwo']" id="deptCodeTwo" /></td>
                    <td align="right" style="padding-left:15px"><span class="label">三级机构：</span></td>
                    <td><input class="sele" name="formMap['deptCodeThree']" id="deptCodeThree" /></td>
                    <td align="right" style="padding-left:15px"><span class="label">四级单位：</span></td>
                    <td><input class="sele" name="formMap['deptCodeFour']" id="deptCodeFour" /></td>
                    <td align="right" style="padding-left:15px"><span class="label">销售团队：</span></td>
                    <td><input name="formMap['groupName']" id="groupName" /></td>
					<td align="right" colspan="2"><span id="button-search" onclick="query()">查询</span><span id="button-excel" onclick="dataToExcel()">导出</span></td>
				</tr>
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">个代姓名：</span></td>
					<td align="left"><input name="formMap['channelName']" id="channelName"/></td>
					<td align="right" style="padding-left:15px"><span class="label">代理人代码：</span></td>
					<td align="left"><input name="formMap['channelCode']" id="channelCode"/></td>
					<td style="padding-left:15px" align="right"><span class="label">证件有效性：</span></td>
					<td><input class="sele" type="text" name="formMap['certifyValid']" id="certifyValid" /></td>
				    <td align="right" style="padding-left:15px">录入日期：</td>
			   		<td align="left"><input name="formMap['reportDateBgn']" id="reportDateBgn" class="sele"></td>
				    <td align="left" style="padding-left:0px">-</td>
			   		<td align="left"><input name="formMap['reportDateEnd']" id="reportDateEnd" class="sele"></td>
				</tr>
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">推荐人为空：</span></td>
					<td align="left"><input type="text" class="sele" name="formMap['salesEmpty']" id="salesEmpty"/></td>
					<td align="right" style="padding-left:15px"><span class="label">推荐人在职：</span></td>
					<td align="left"><input type="text" class="sele" name="formMap['salesStatus']" id="salesStatus"/></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables" class="tables"></div>
</body>
</html>