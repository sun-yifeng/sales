<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sinosafe.xszc.constant.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<%=_path%>/core/js/huaanUI.js"></script>
<style type="text/css">
*{padding:0;marging:0}
body{font-family:微软雅黑,宋体,Arial,Helvetica,sans-serif,simsun;font-size:12px;color:#1E1E1E; }
html,body{height: 100%; margin: 0px; padding: 0px;}
.om-grid .gird-edit-btn{width: 190px;}
.om-button{font-size: 12px;}
#nav_cont{width: 580px; margin-left: auto; margin-right: auto;}
input{height: 18px; border: 1px solid #A1B9DF; vertical-align: middle;}
input:focus{border: 1px solid #3A76C2;}
.input_slelct{width: 81%;}
.textarea_text{border: 1px solid #A1B9DF; height: 40px; width: 445px;}
table.grid_layout tr td{font-weight: normal; height: 15px; padding: 5px 0; vertical-align: middle;}
.color_red{color: red;}
.toolbar{padding: 12px 0 5px; text-align: center;}
.birthplace,.address{width: 445px;}
.om-span-field input:focus{border: none;}
.errorImg{background: url("<%=_path%>/images/msg.png") no-repeat scroll 0 0 transparent; height: 16px; width: 16px; cursor: pointer;}
input.error,textarea.error{border: 1px solid red;}
.errorMsg{border: 1px solid gray; background-color: #FCEFE3; display: none; position: absolute; margin-top: -18px; margin-left: -2px;}
.tds{padding-left: 30px;}
.tdsDate{width: 115px;}
.navi-no-tab {border: solid #d0d0d0 1px; width: 99.9%; padding-top: 8px; padding-bottom: 8px; padding-left: 20px; margin-top:10px;}
</style>
<title>企业协议维护</title>
<%
String channelCode = request.getParameter("channelCode"); //渠道代码
String conferCode = request.getParameter("conferCode");   //数据主键（不是协议代码）
String expireDate = request.getParameter("expireDate");   //协议截止日期
String channelFlag = request.getParameter("channelFlag"); //渠道类型
%>
<script type="text/javascript">
var channelCode = '<%=channelCode%>';
var conferCode = '<%=conferCode%>';
var expireDate = '<%=expireDate%>';
var channelFlag = '<%=channelFlag%>';

//
var prodTypeObj = ''; //产品分类
var pordNameObj = ''; //产品名称
var tempProdType = '';
var tempProdCode = '';
var tempRowIndex = -1;
var saveFlag = true;
var repeatFlag = false;
var editFlag = false;
$(function(){
    $("#baseInfo").find("input").css({"width":"151px"});
    $(".sele").css({"width":"130px"});
    $("#conferId").css({"width":"120px"});
    $("#extendConferCode").css({"width":"24px"});
    
    //协议类型
    $('#conferType').omCombo({
        dataSource: "<%=_path%>/common/queryConferType.do",
        readOnly: true,
        value: 'H'
    });
    
    //是否独立结算
    $('#calclateFlag').omCombo({
        dataSource: [{"text":"请选择","value":""},{"text":"否","value":"0"},{"text":"是","value":"1"}],
        editable: false,
        emptyText: '请选择'
    });
    
    /*******协议基本信息**********/
    Util.post("<%=_path%>/confer/queryEnterpriseConferByPk.do?conferCode=<%=conferCode%>","",function(data) {
         $("#baseInfo").find(":input").each(function(){
            $(this).val(data[$(this).attr("name")]);
         });
         $('#conferType').omCombo({value: data.conferType});
         $('#calclateFlag').omCombo({value: data.calclateFlag});
         $('#validDate').omCalendar();
         $('#expireDate').omCalendar();
         $('#signDate').omCalendar();
    });
    
    //产品手续费-按钮菜单
    $('#buttonbar').omButtonbar({
            btns : [{label:"新增",
                         id:"addButton" ,
                         icons : {left : '<%=_path%>/images/add.png'},
                         onClick:function(){
                        	 editFlag = false; 
                            $('#tables').omGrid("insertRow");
                         }
                    },
                    {separtor:true},
                    {label:"删除",
                        id:"delButton",
                        icons : {left : '<%=_path%>/images/search.png'},
                        onClick:function(){
                            var dels = $('#tables').omGrid('getSelections',true);
                            var delsf = $('#tables').omGrid('getSelections');
                            var del = eval(dels);
                            var delf = eval(delsf);
                            editFlag = false;
                            if(dels.length != 1 ){
                                $.omMessageBox.alert({
                                    content:'请选择一条记录操作',
                                    onClose:function(value){
                                        return false;
                                    }
                                });
                            } else {
                                $.omMessageBox.confirm({
                                   title:'确认删除',
                                   content:'你确定要删除该记录吗？',
                                   onClose:function(v){
                                       if(v){
                                            if(del[0].conferProductId != "" && del[0].conferProductId != "undefined" && del[0].conferProductId != undefined){
                                               Util.post("<%=_path%>/conferProduct/deleteMediumConferProduct.do?conferProductId="+del[0].conferProductId,'',function(data) {
                                                  //刷新列表
                                                  $('#tables').omGrid({});
                                                }
                                              );
                                            } else {
                                                 $('#tables').omGrid('deleteRow',delf[0]);
                                            }
                                       }
                                   }
                                });
                            }
                        }
                    }
            ]
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
                    listAutoWidth : true,
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
         limit:10,
         height:350,
         singleSelect:false,
         showIndex:true,
         colModel:[{header:"产品分类",name:"productType",width:150,align:'center',editor:{rules:["required",true,"此项必选"],type:"omCombo",name:"productType",options:productTypeOptions},editable:function(){return true;},renderer:productTypeRenderer},
                   {header:"产品名称",name:"productName",width:200,align:'center',editor:{type:"omCombo",name:"productName"},editable:function(){return true;},renderer:productNameRenderer},
                   {header:"产品编码",name:"productCode",width:150,align:'center'},
                   {header:"互联网服务费用比例（%）",name:"commissionRate",width:150,align:'center',editor:{rules:[["required",true,"手续费比例必填"],["max",100,"数值无效"],["min",0,"数值无效"]],type:"omNumberField",options:commissionRateOptions,editable:true,name:"commissionRate"}},
                   {header:"特殊批改（%）",name:"endorseRate",width:150,align :'center',editor:{rules:[["required",true,"特殊批改必填"],["max",100,"数值无效"],["min",0,"数值无效"]],type:"omNumberField",options:endorseRateOptions,editable:true,name:"endorseRate"}}],
         onPageChange:function(type,newPage,event){
            var jsonData = JSON.stringify($('#tables').omGrid('getData'));
            var jsonRows = eval("["+jsonData+"]")[0].rows;
            editFlag = false; 
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
                // 提交 TODO:
                Util.post("<%=_path%>/confer/updateConfer.do",$("#baseInfo").serialize(), function(data) {
                    $.omMessageBox.waiting('close');
                });
            }
         }, //end onPageChange
         onBeforeEdit:function(rowIndex, rowData){
           saveFlag = false;
           repeatFlag = false;
           editFlag = true;
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
                editFlag = false;
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
           editFlag = false;
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
        if(value == '' || editFlag == true){
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
    
    //初始化页面保存、重置、取消按钮
    $("#button-save").omButton({icons : {left : '<%=_path%>/images/add.png'},width:50});
    $("#button-reset").omButton({icons : {left : '<%=_path%>/images/op-edit.png'},width:50});
    $("#button-cancel").omButton({icons : {left : '<%=_path%>/images/remove.png'},width:50});
    
    initValidate();
    
    $('.errorImg').bind('mouseover', function() {
        $(this).next().css('display', 'block');
    }).bind('mouseout', function() {
        $(this).next().css('display', 'none');
    });

    $.validator.addMethod("gtSignDate", function(value) {
        var validDate = $("#signDate").val();
        return value > validDate;
    }, '此日期应大于签订日期');
    
    $.validator.addMethod("gtValidDate", function(value) {
        var validDate = $("#validDate").val();
        return value > validDate;
    }, '此日期应大于生效日期');

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

//定义校验规则
var mediumConferRule = {
    signDate:{
        required: true,
        isDate: true
    },
    validDate:{
        required: true,
        gtSignDate: true,
        isDate: true
    },
    expireDate:{
        required: true,
        gtValidDate: true,
        isDate: true
    },
    calclatePeriod:{
        required: true,
        number: true
    },
    conferType:{
        required: true
    }
};

//定义校验的显示信息
var mediumConferMessages = {
    signDate:{
        required:'签订日期不能为空'
    },
    validDate:{
        required:'生效日期不能为空'
    },
    expireDate:{
        required:'截止日期不能为空'
    },
    calclatePeriod:{
        required:'截费周期不能为空',
        number:'必须是数字类型'
    },
    conferType:{
        required:'协议类型必选'
    }
};

//校验
function initValidate(){
    $("#baseInfo").validate({
        rules: mediumConferRule,
        messages: mediumConferMessages,
        errorPlacement : function(error, element) {
            if (error.html()) {
                $(element).parents().map(function() {
                    if (this.tagName.toLowerCase() == 'td') {
                        var attentionElement = $(this).next().children().eq(0);
                        attentionElement.css('display', 'block');
                        attentionElement.next().html(error);
                    }
                });
            }
        },
        showErrors : function(errorMap, errorList) {
            if (errorList && errorList.length > 0) {
                $.each(errorList, function(index, obj) {
                    var msg = this.message;
                    $(obj.element).parents().map(function() {
                        if (this.tagName.toLowerCase() == 'td') {
                            var attentionElement = $(this).next().children().eq(0);
                            attentionElement.show();
                            attentionElement.next().html(msg);
                        }
                    });
                });
            } else {
                $(this.currentElements).parents().map(function() {
                    if (this.tagName.toLowerCase() == 'td') {
                        $(this).next().children().eq(0).hide();
                    }
                });
            }
            this.defaultShowErrors();
        },
        submitHandler : function() {
            var insertData = $('#tables').omGrid("getChanges","insert");
            var updateData = $('#tables').omGrid("getChanges","update");
            var deleteData = $('#tables').omGrid("getChanges","delete");
            if(insertData.length>0 || updateData.length>0 || deleteData.length>0){
                $('#updateFlag').val(1);
            }else{
                $('#updateFlag').val(0);
            }
            
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
            
            Util.post("<%=_path%>/confer/updateConfer.do",$("#baseInfo").serialize(), function(data) {
                $.omMessageBox.waiting('close');
                $.omMessageBox.alert({
                    type: 'success',
                    title: '成功',
                    content: '协议保存成功',
                    onClose: function(value){
                      window.location.href = "enterpriseEdit.jsp?flag=2&channelCode="+channelCode + "&channelFlag=<%=channelFlag%>";;
                    return true;
                   }
                });
            });
        }
    });
}

//保存协议维护
function save(){
    //产品手续费表处于编辑状态
    if(!saveFlag){
        $.omMessageBox.alert({
             type:'warning',
             content:'产品手续费信息处于编辑状态，请先确定或取消之后再保存！'
        });
        return;
    }
    
    $("#baseInfo").submit();
}

//取消操作
function cancel(){
    window.location.href = "enterpriseEdit.jsp?flag=1&channelCode="+channelCode + "&channelFlag=<%=channelFlag%>";
}
</script>
</head>
<body>
    <div>
        <table class="navi-no-tab">
            <tr><td>企业协议维护</td></tr>
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
            <div id="buttonbar" class="om-grid-btn-border"></div>
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
                <a class="om-button" id="button-save" onclick="save()">保存</a>
                <a class="om-button" id="button-cancel" onclick="cancel()">取消</a></td>
            </tr>
        </table>
    </div>
</body>
</html>