<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<style type="text/css">
/*只读灰化 */
input[disabled='disabled'],textarea[disabled='disabled'],input[readonly='true'],textarea[readonly='true']{background-color:#F0F0F0;color:gray;}
</style>
<title>企业协议详情</title>
<%
String channelCode = request.getParameter("channelCode"); //渠道代码
String conferCode = request.getParameter("conferCode");   //数据主键（不是协议代码）
String expireDate = request.getParameter("expireDate");   //协议截止日期
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var conferCode = '<%=conferCode%>';
var expireDate = '<%=expireDate%>';

//
var prodTypeObj = ''; //产品分类
var pordNameObj = ''; //产品名称
var tempProdType = '';
var tempProdCode = '';
var tempRowIndex = -1;
var saveFlag = true;
var repeatFlag = false;
$(function(){
    $("#baseInfo").find("input").css({"width":"151px"});
    $(".sele").css({"width":"130px"});
    $("#conferId").css({"width":"120px"});
    $("#extendConferCode").css({"width":"24px"});
    
    
    /*******协议基本信息**********/
    Util.post("<%=_path%>/confer/queryIndividualConferByPk.do?conferCode=<%=conferCode%>","",function(data) {
         $("#baseInfo").find(":input").each(function(){
            $(this).val(data[$(this).attr("name")]);
            $(this).attr({disabled:"disabled"});
         });
         $('#conferType').omCombo({dataSource:"<%=_path%>/common/queryConferType.do",value:data.conferType,disabled:true});
         $('#calclateFlag').omCombo({dataSource:<%=Constant.getCombo("calclateFlag")%>,value:data.calclateFlag,disabled:true});
         $('#validDate').omCalendar({disabled:true});
         $('#expireDate').omCalendar({disabled:true});
         $('#signDate').omCalendar({disabled:true});
    });
    
    /**********************************************************产品手续费*****************************************************************/
    //加载所有的产品类别
    Util.post("<%=_path%>/common/queryTPrdKind.do","",function(data) {prodTypeObj = eval(data);});
    
    //加载所有的产品名称
    Util.post("<%=_path%>/common/queryPrdCode.do","",function(data) {
        pordNameObj = eval(data);
        //加载所有的产品(编辑页面)
        $("#tables").omGrid("setData","<%=_path%>/conferProduct/queryConferProduct.do?"+$("#conferProductFrm").serialize());
    });

    //产品分类下拉框
    var productTypeOptions = {
            dataSource : "<%=_path%>/common/queryTPrdKind.do",
            onValueChange : function(target1, newValue1, oldValue1, event1) {
                tempProdType = newValue1; //
                //
                $("#productName").omCombo("setData",[]);
                $("input[name='productCode']").val("");
                //按产品分类加载产品
                $("#productName").omCombo({
                    dataSource : "<%=_path%>/common/queryPrdCode.do?prdType="+newValue1,
                    onValueChange : function(target2, newValue2, oldValue2, event2) {
                        tempProdCode = newValue2;
                        $("input[name='productCode']").val(newValue2);
                    },
                    onSuccess:function(data, textStatus, event){}
                });
            },
            onSuccess:function(data, textStatus, event){}
    };

    //手续费比例校验
    var commissionRateOptions = {
            allowDecimals:true, //小数
            allowNegative:false //负数
    };

    //特殊批改校验
    var endorseRateOptions = {
            allowDecimals:true,
            allowNegative:false
    };
    
    //初始化产品手续费信息列表
    $('#tables').omGrid({
         limit: 10,
         height: 350,
         singleSelect: true,
         showIndex: true,
         colModel:[{header:"产品分类",name:"productType",width:150,align:'center',renderer:productTypeRenderer},
                   {header:"产品名称",name:"productName",width:250,align:'center',renderer:productNameRenderer},
                   {header:"产品编码",name:"productCode",width:100,align:'center'},
                   {header:"互联网服务费用比例（%）",name:"commissionRate",width:150,align:'center'},
                   {header:"特殊批改（%）",name:"endorseRate",width:150,align:'center'}],
         onPageChange:function(type,newPage,event){
            var jsonData = JSON.stringify($('#tables').omGrid('getData'));
            var jsonRows = eval("["+jsonData+"]")[0].rows;
            if(jsonRows.length > 0){
                for(var i=0; i<jsonRows.length; i++){
                    var breakFlag = false;
                    var productCode = jsonRows[i].productCode;
                    var commissionRate = jsonRows[i].commissionRate;
                    var endorseRate = jsonRows[i].endorseRate;
                    if(productCode == '' || productCode == undefined){
                        $.omMessageBox.alert({
                            type:'warning',
                            content:'产品代码不能为空,请选择产品名称带出产品代码！',
                            onClose:function(value){}
                        });
                        $("#tables").omGrid("editRow", i);
                        saveFlag = false;
                        break;
                    } else {
                        for(var j = jsonRows.length-1;j > i;j--){
                            var prepareCode = jsonRows[j].productCode;
                            if(productCode == prepareCode){
                                $.omMessageBox.alert({
                                    type:'warning',
                                    content:'产品编码不能重复',
                                    onClose:function(value){}
                                });
                                $("#tables").omGrid("editRow", i);
                                saveFlag = false;
                                breakFlag = true;
                                repeatFlag = true;
                            }
                        }
                    }
                    if(commissionRate == undefined){
                        $.omMessageBox.alert({
                            type:'warning',
                            content:'产品手续费比例不能为空',
                            onClose:function(value){}
                        });
                        $("#tables").omGrid("editRow", i);
                        return false;
                    }
                    if(endorseRate == undefined){
                        $.omMessageBox.alert({
                            type:'warning',
                            content:'产品特殊批改不能为空',
                            onClose:function(value){}
                        });
                        $("#tables").omGrid("editRow", i);
                        return false;
                    }
                    if(breakFlag){
                       break;
                    }
                }
             }
              
             var insertData = $('#tables').omGrid("getChanges","insert");
             var updateData = $('#tables').omGrid("getChanges","update");
             if(insertData.length>0 || updateData.length>0){
                var jsonData = JSON.stringify($('#tables').omGrid('getData'));
                var jsonRows = eval("["+jsonData+"]")[0].rows;
                var baseJsonStr;
                if(jsonRows.length > 0){
                    baseJsonStr = "[";
                    for(var i = 0;i < jsonRows.length;i++){
                        var conferProductId = jsonRows[i].conferProductId;
                        var productCode = jsonRows[i].productCode;
                        var commissionRate = jsonRows[i].commissionRate;
                        var endorseRate = jsonRows[i].endorseRate;
                        if(conferProductId != undefined){//修改产品手续费
                            baseJsonStr += "{\"conferProductId\":\""+conferProductId+"\",\"productCode\":\""+productCode+"\",\"commissionRate\":\""+commissionRate+"\",\"endorseRate\":\""+endorseRate+"\"},";
                        }else{//新增产品手续费
                            baseJsonStr += "{\"productCode\":\""+productCode+"\",\"commissionRate\":\""+commissionRate+"\",\"endorseRate\":\""+endorseRate+"\"},";
                        }
                    }
                    var index = baseJsonStr.lastIndexOf(",");
                    baseJsonStr = baseJsonStr.substring(0, index);
                    baseJsonStr += "]";
                }else{
                    baseJsonStr = "[]";
                }
                $('#conferJsonStr').val(baseJsonStr);

                $.omMessageBox.waiting({
                    title:'请等待',
                    content:'服务器正在处理请求...'
                });
                $.omMessageBox.waiting('close');
                // 提交 TODO:
                // Util.post("<%=_path%>/confer/updateConfer.do",$("#baseInfo").serialize(), function(data) {
                //    $.omMessageBox.waiting('close');
                //}); 
            }
         }, //end onPageChange
         onBeforeEdit:function(rowIndex, rowData){
           saveFlag = false;
           repeatFlag = false;
           tempRowIndex = rowIndex;
         },
         onAfterEdit:function(rowIndex, rowData){
           //产品代码不能为空
           if(rowData.productCode == '' || rowData.productCode == 'undefined'){
             $.omMessageBox.alert({
                 type:'warning',
                     content:'产品代码不能为空,请选择产品名称带出产品代码！'
                });
            saveFlag = false;
            $('#tables').omGrid("editRow", rowIndex);
           } else {
                saveFlag = true;
                //1.页面是否有重复的产品
                var jsonData = JSON.stringify($('#tables').omGrid('getData'));
                var jsonRows = eval("["+jsonData+"]")[0].rows;
                if (jsonRows.length > 0){
                   for(var i=0; i<jsonRows.length; i++){
                        var breakFlag = false;
                        var tempProdCode1 = jsonRows[i].productCode;
                        for(var j=jsonRows.length-1; j>i; j--){
                            var tempProdCode2 = jsonRows[j].productCode;
                            if(tempProdCode1 == tempProdCode2){
                                $.omMessageBox.alert({
                                    type:'warning',
                                    content:'产品编码重复,请重新选择产品',
                                    onClose:function(value){}
                                });
                                $("#tables").omGrid("editRow", i);
                                saveFlag = false;
                                breakFlag = true;
                                repeatFlag = true;
                                break;
                            }
                        }
                        if(breakFlag){
                             return;
                        }
                    }
                }
                //2.后台是否有重复的产品
                Util.post("<%=_path%>/conferProduct/queryMediumConferProductCode.do?conferProductId="+rowData.conferProductId+"&productCode="+rowData.productCode+"&conferCode="+conferCode,'',function(data) {
                    if(data != "success"){
                        $.omMessageBox.alert({
                            type:'warning',
                            content:'产品编码重复,请重新选择产品',
                            onClose:function(value){}
                        });
                        $("#tables").omGrid("editRow", rowIndex);
                        saveFlag = false;
                        repeatFlag = true;
                        return;
                    }
                    saveFlag = true;
                  }
                );    
             } //end if else
         },
         onCancelEdit:function(){
           if(repeatFlag){
              $('#tables').omGrid("deleteRow", tempRowIndex);
           }
           saveFlag = true;
        }
    });

    //显示产品分类
    function productTypeRenderer(value, rowData, rowIndex){
        if(value == ''){
           value = tempProdType;
        }
        if(prodTypeObj != ''){
            for(var i=0; i<prodTypeObj.length; i++){
                if(prodTypeObj[i].value === value){
                    return "<span>"+prodTypeObj[i].text+"</span>";
                } 
            }
        }
    }

    //显示产品名称
    function productNameRenderer(value, rowData, rowIndex){
        if(value == ''){
           value = tempProdCode;
        }
        if(pordNameObj != ''){
            for(var i=0; i < pordNameObj.length; i++){
                if(pordNameObj[i].value === value){
                    return "<span>"+pordNameObj[i].text+"</span>";
                }  
            }
        }
    }
    
    //初始化返回按钮
    $("#button-cancel").omButton({icons: {left: '<%=_path%>/images/remove.png'},width:50});

});

function formatDate(obj){
    var value = $(obj).val();
    if(value != "" && value != "undefined" && value != undefined){
        var dateSplit = value.split('-');
        if(dateSplit[1].length == 1){
            dateSplit[1] = "0" + dateSplit[1];
        }
        if(dateSplit[2].length == 1){
            dateSplit[2] = "0" + dateSplit[2];
        }
        $(obj).val(dateSplit[0]+"-"+dateSplit[1]+"-"+dateSplit[2]);
    }
}

//返回操作
function cancel(){
    window.location.href = "individualEdit.jsp?flag=1&channelCode="+channelCode;
}
</script>
</head>
<body>
    <div>
        <table class="navi-no-tab">
            <tr><td>企业协议详情</td></tr>
        </table>
    </div>
    <div>
        <form id="baseInfo">
            <input type="hidden" name="deptCode" id="deptCode" />
            <input type="hidden" name="updateFlag" id="updateFlag" />
            <input type="hidden" name="grantDept" id="grantDept" value="1" />
            <input type="hidden" name="conferCode" id="conferCode" value="<%=conferCode%>" />
            <input type="hidden" name="conferJsonStr" id="conferJsonStr" />
            <fieldSet>
                <legend>基本信息</legend>
                    <table>
                        <tr>
                            <td style="padding-left:30px" align="right"><span class="label">协议号：</span></td>
                            <td><input type="text" name="conferId" id="conferId" disabled="disabled" value="" style="color:gray;"/>-<input type="text" name="extendConferCode" id="extendConferCode" readonly="readonly" value="0" /><span style="color:red">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                            <td style="padding-left:30px" align="right"><span class="label">协议类型：</span></td>
                            <td><input class="sele" type="text" name="conferType" id="conferType" readonly="readonly" /><span style="color:red">*</span>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                            <td style="padding-left:30px" align="right"><span class="label">经办部门：</span></td>
                            <td><input type="text" name="deptCname" id="deptCname" readonly="readonly" /><span style="color:red">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span>
                        </tr>
                        <tr>
                            <td style="padding-left:30px" align="right"><span class="label">渠道编码：</span></td>
                            <td><input type="text" name="channelCode" id="channelCode" readonly="readonly" /><span style="color:red">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                            <td style="padding-left:30px" align="right"><span class="label">企业名称：</span></td>
                            <td><input type="text" name="mediumCname" id="mediumCname" readonly="readonly" /><span style="color:red">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                            <td style="padding-left:30px" align="right"><span class="label">签订日期：</span></td>
                            <td><input class="sele" type="text" name="signDate" id="signDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        </tr>
                        <tr>
                            <td style="padding-left:30px" align="right"><span class="label">生效日期：</span></td>
                            <td><input class="sele" type="text" name="validDate" id="validDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                            <td style="padding-left:30px" align="right"><span class="label">截止日期：</span></td>
                            <td><input class="sele" type="text" name="expireDate" id="expireDate" onblur="formatDate(this);" /><span style="color:red">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                            <td style="padding-left:30px" align="right"><span class="label">结费周期（天）：</span></td>
                            <td><input type="text" name="calclatePeriod" id="calclatePeriod" /><span style="color:red">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        </tr>
                        <tr>
                            <td style="padding-left:30px" align="right"><span class="label">是否独立结算：</span></td>
                            <td><input class="sele" type="text" name="calclateFlag" id="calclateFlag" /><span style="color:red">*</span></td>
                            <td><span class="errorImg"></span><span class="errorMsg"></span></td>
                        </tr>
                    </table>
            </fieldSet>
            <fieldSet>
                <legend>详细内容</legend>
                <textarea rows="5" cols="110" style="margin-left:70px;" name="remark" id="remark"></textarea>
            </fieldSet>
        </form>
    </div>
    <div>
        <fieldSet>
            <legend>产品手续费</legend>
            <table id="tables"></table>
            <form id="conferProductFrm">
                <input type="hidden" name="formMap['conferCode']" id="conferCode" value="<%=conferCode%>" />
            </form>
        </fieldSet>
    </div>
    <div>
        <table style="width:100%">
            <tr>
                <td style="padding-left:30px;padding-top:20px" align="center">
                <a class="om-button" id="button-cancel" onclick="cancel()">返回</a></td>
            </tr>
        </table>
    </div>
</body>
</html>