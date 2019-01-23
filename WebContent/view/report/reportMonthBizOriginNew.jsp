<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务来源统计报表</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<script type="text/javascript">
$(function(){
	iniPage('业务来源统计报表');
	iniDept('fComName', '', '');
	iniDate('reportMonth');
	iniQuery2();
	
});

//表头列名
var tableCols = eval([
    //第1行
    {header:"业务来源", name:"C_BSNS"},
    {header:"业务来源", name:"C_BSNS_TYP"},
    {header:"业务来源", name:"CHANNEL_TYPE"},
    {header:"企业财产保险"},
    {header:"家庭财产保险"},
    {header:"商业性机动车辆保险"},
    {header:"交强险"},
    {header:"工程保险"},
    {header:"责任保险"},
    {header:"信用保险"},
    {header:"保证保险"}, //10
    {header:"船舶保险"},
    {header:"货物运输保险"},
    {header:"特殊风险保险"},
    {header:"农业保险"},
    {header:"健康险"},
    {header:"意外伤害保险"},
   
    {header:"合计"},
  //第二行
    {header:"保费收入",name:"qcxprmtotal"},
    {header:"手续费及佣金支出",name:"qcxcmmamt"},
    {header:"实付佣金", name:"qcxpaidamt"},
    
    {header:"保费收入", name:"jtprmtotal"},
    {header:"手续费及佣金支出", name:"jtcmmamt"},
    {header:"实付佣金", name:"jtpaidamt"},
    
    {header:"保费收入", name:"syxprmtotal"},
    {header:"手续费及佣金支出", name:"syxcmmamt"},
    {header:"实付佣金", name:"syxpaidamt"},
    
    {header:"保费收入", name:"jqxprmtotal"},
    {header:"手续费及佣金支出", name:"jqxcmmamt"},
    {header:"实付佣金", name:"jqxpaidamt"},
    
    {header:"保费收入", name:"gcxprmtotal"},
    {header:"手续费及佣金支出", name:"gcxcmmamt"},
    {header:"实付佣金", name:"gcxpaidamt"},
    
    {header:"保费收入", name:"zrxprmtotal"},
    {header:"手续费及佣金支出", name:"zrx_cmm_amt"},
    {header:"实付佣金", name:"zrxpaidamt"},
    
    {header:"保费收入", name:"xybzprmtotal"},
    {header:"手续费及佣金支出", name:"xybzcmmamt"},
    {header:"实付佣金", name:"xybzpaidamt"},
    
    {header:"保费收入", name:"bzbzprmtotal"},
    {header:"手续费及佣金支出", name:"bzbzcmmamt"},
    {header:"实付佣金", name:"bzbzpaidamt"},
    
    {header:"保费收入", name:"cbxprmtotal"},
    {header:"手续费及佣金支出", name:"cbxcmmamt"},
    {header:"实付佣金", name:"cbxpaidamt"},
    
    {header:"保费收入", name:"hyxprmtotal"},
    {header:"手续费及佣金支出", name:"hyxcmmamt"},
    {header:"实付佣金", name:"hyxpaidamt"},
    
    {header:"保费收入", name:"tsxprmtotal"},
    {header:"手续费及佣金支出", name:"tsxcmmamt"},
    {header:"实付佣金", name:"tsxpaidamt"},
    
    {header:"保费收入", name:"nyxprmtotal"},
    {header:"手续费及佣金支出", name:"nyxcmmamt"},
    {header:"实付佣金", name:"nyxpaidamt"},
    
    {header:"保费收入", name:"jkxprmtotal"},
    {header:"手续费及佣金支出", name:"jkxcmmamt"},
    {header:"实付佣金", name:"jkxpaidamt"},
    
    {header:"保费收入", name:"ywxprmtotal"},
    {header:"手续费及佣金支出", name:"ywxcmmamt"},
    {header:"实付佣金", name:"ywxpaidamt"},
    
    
    
    {header:"保费收入", name:"rpprmtotal"},
    {header:"手续费及佣金支出", name:"ncmmamt"},
    {header:"实付佣金", name:"npaidamt"},
    
    
    //{header:"报表日期", name:"reportMonth", equal:true, hide:true}
]);

//表头样式
var tableHead = [
   //第1行
   [
    {header:tableCols[0].header,name:tableCols[0].name,rowspan:2,width:80,renderer : function(colValue, rowData, rowIndex){
		
    	if(rowData.C_BSNS==null){
    		return "合计";
    	}
    	else{
    	return rowData.C_BSNS;}
	}},
	{header:tableCols[1].header,name:tableCols[1].name,rowspan:2,width:120,renderer : function(colValue, rowData, rowIndex) {
		if(rowData.C_BSNS==null && rowData.C_BSNS_TYP==null){
			return "合计";
		}else if(rowData.C_BSNS!=null&& rowData.C_BSNS_TYP==null){
			return "小计";
		}
		else{
			return rowData.C_BSNS_TYP;
		}
		
    }},
	{header:tableCols[2].header,name:tableCols[2].name,rowspan:2,width:120,renderer : function(colValue, rowData, rowIndex) {
		
		if(rowData.C_BSNS==null && rowData.CHANNEL_TYPE==null){
			return "合计";
		}
		 if(rowData.C_BSNS!=null && rowData.CHANNEL_TYPE==null){
			return "小计";}
		else{
			
				return  rowData.CHANNEL_TYPE;
			}
		
        
    }},
	{header:tableCols[3].header,name:tableCols[3].name,colspan:3},
	{header:tableCols[4].header,name:tableCols[4].name,colspan:3},
	{header:tableCols[5].header,name:tableCols[5].name,colspan:3},
	{header:tableCols[6].header,name:tableCols[6].name,colspan:3},
	{header:tableCols[7].header,name:tableCols[7].name,colspan:3},
	{header:tableCols[8].header,name:tableCols[8].name,colspan:3},
	{header:tableCols[9].header,name:tableCols[9].name,colspan:3},
	{header:tableCols[10].header,name:tableCols[10].name,colspan:3},
	{header:tableCols[11].header,name:tableCols[11].name,colspan:3},
	{header:tableCols[12].header,name:tableCols[12].name,colspan:3},
	{header:tableCols[13].header,name:tableCols[13].name,colspan:3},
	{header:tableCols[14].header,name:tableCols[14].name,colspan:3},
	
	{header:tableCols[15].header,name:tableCols[15].name,colspan:3},
	{header:tableCols[16].header,name:tableCols[16].name,colspan:3},
	{header:tableCols[17].header,name:tableCols[17].name,colspan:3}
	
	],
	//第2行
	[{header:tableCols[18].header,name:tableCols[18].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
	{header:tableCols[19].header,name:tableCols[19].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[20].header,name:tableCols[20].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    
	{header:tableCols[21].header,name:tableCols[21].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[22].header,name:tableCols[22].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[23].header,name:tableCols[23].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    //
    {header:tableCols[24].header,name:tableCols[24].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[25].header,name:tableCols[25].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[26].header,name:tableCols[26].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[27].header,name:tableCols[27].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[28].header,name:tableCols[28].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[29].header,name:tableCols[29].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[30].header,name:tableCols[30].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[31].header,name:tableCols[31].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[32].header,name:tableCols[32].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[33].header,name:tableCols[33].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[34].header,name:tableCols[34].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[35].header,name:tableCols[35].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[36].header,name:tableCols[36].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[37].header,name:tableCols[37].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[38].header,name:tableCols[38].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[39].header,name:tableCols[39].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[40].header,name:tableCols[40].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[41].header,name:tableCols[41].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[42].header,name:tableCols[42].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[43].header,name:tableCols[43].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[44].header,name:tableCols[44].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[45].header,name:tableCols[45].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[46].header,name:tableCols[46].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[47].header,name:tableCols[47].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[48].header,name:tableCols[48].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[49].header,name:tableCols[49].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[50].header,name:tableCols[50].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[51].header,name:tableCols[51].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[52].header,name:tableCols[52].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[53].header,name:tableCols[53].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[54].header,name:tableCols[54].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[55].header,name:tableCols[55].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[56].header,name:tableCols[56].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[57].header,name:tableCols[57].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[58].header,name:tableCols[58].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[59].header,name:tableCols[59].name,width:130,renderer:function(v,r,i){return alignCell(v);}},
    
    {header:tableCols[60].header,name:tableCols[60].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[61].header,name:tableCols[61].name,width:100,renderer:function(v,r,i){return alignCell(v);}},
    {header:tableCols[62].header,name:tableCols[62].name,width:130,renderer:function(v,r,i){return alignCell(v);}}
   
    
   
   ]
];
//初始化
function iniQuery2(){
	setTimeout('BizOrigin()', 500);
}
//导出
function dataToExcel(){
	//$("#tables").omGrid("setData","<%=_path%>/reportFoundationMediumNew/queryDataToExcelNew.do?"+$("#filterFrm").serialize());
	//window.open("<%=_path%>/reportFoundationMedium/queryDataToExcel.do?"+$("#filterFrm").serialize());
	$("#filterFrm").attr("method","post").attr("action", Util.appCxtPath + "/reportFoundationMediumNew/queryDataToExcelNew.do").submit();
}
//查询
function BizOrigin(){
	$("#tables").omGrid({
		dataSource:"<%=_path%>/reportFoundationMediumNew/queryReportDayAgentChannelNew.do?"+$("#filterFrm").serialize(),
	    onSuccess:function(XMLHttpRequest,textStatus,errorThrown,event){
	    	setTimeout('$("#tables").MergeRows()',1);
	    	setTimeout('$("#tables").MergeColumns()',2);
	    		
	    }
	});
	}
//合并行
$.fn.MergeColumns = function() {
	return this.each(function() {
        for (var i = 2 ; i >= 0; i--) {  //获取表格td的数量进行循环  $(this).find('tr:first td').size() - 1
            var s = null;
            var prevTd = null;
            //alert(11);
            $(this).find('tr').each(function() {
                var td = $(this).find('td').eq(i);
                var s1 = td.text();
                if (s1 == s) { //相同即执行合并操作
                    td.hide(); //hide() 隐藏相同的td ,remove()会让表格错位 此处用hide
                    prevTd.attr('rowspan', prevTd.attr('rowspan') ? parseInt(prevTd.attr('rowspan')) + 1 : 2); //赋值rowspan属性
                }
                else {
                    s = s1;
                    prevTd = td;
                }
            });
        }
    });
};

//合并列
$.fn.MergeRows = function() {
    return this.each(function() {
        $(this).find('tr').each(function() {
            var s = null;
            var prevTd = null;
            //alert($(this).find('td').size());
            for (var i = 0; i < 4; i++) { 
                var td = $(this).find('td').eq(i);
                var s1 = td.text();
                if (s1 == s) { //相同即执行合并操作
                    td.hide(); //hide() 隐藏相同的td ,remove()会让表格错位 此处用hide
                    prevTd.attr('colspan', prevTd.attr('colspan') ? parseInt(prevTd.attr('colspan')) + 1 : 2); //赋值colspan属性
                    prevTd.attr('style','text-align:center');
                    prevTd.children().removeAttr("style");
                }
                else {
                    s = s1;
                    prevTd = td;
                }
            }
        });
    });
}
</script>
</head>
<body>
	<form id="filterFrm">
	    <!-- 报表配置项 -->
	    <input type="hidden" name="formMap['operType']" id="operType" value=""/>
	    <input type="hidden" name="formMap['tableCols']" id="tableCols" value=""/>
	    <!-- <input type="hidden" name="formMap['tableName']" id="tableName" value="REPORT_MONTH_BIZ_ORIGIN_NEW"/>-->
	    <input type="hidden" name="formMap['excelName']" id="excelName" value="reportMonthBizOriginNew"/> 
		<div id="search-panel">
			<table >
				<tr>
					<td align="right" style="padding-left:15px"><span class="label">分公司：</span></td>
					<td align="left"><input name="formMap['fComName']" id="fComName" class="sele" /></td>
					
					<td style="padding-left:15px" align="right"><span class="label">报表日期：</span></td>
					<td><input type="text" name="formMap['reportMonth']" id="reportMonth" value="" class="sele"/></td>
					<td  style="padding-left:15px;" align="right"><span id="button-search" onclick="BizOrigin()">查询</span><span id="button-dataToExcel" onclick="dataToExcel()">导出Excel</span></td>
				</tr>
			</table>
		</div>
	</form>
	<div id="tables"></div>
</body>
</html>