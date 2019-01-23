var lastTR='';//行变色时使用,保存上次选中的行
function getThisId(id){
	getObject("pkID").value=id;  
}
/**
 * 设置选中行
 * @param {行对象} obj
 */
function selectThis(obj){
	if(lastTR!=''){
		if(lastTR.rowIndex % 2 == 1){
			lastTR.className="td1";
		}else{
			lastTR.className="td2";
		}
	}
	lastTR=obj;
	obj.className="td_hover";
}
/**
 * 设置编辑状态
 * @param {Object} obj
 */
 function getThisId(id){
	getObject("pkID").value=id;  
}

function setDisable(id){

 var obj=getObject(id);
 if(obj.disabled=true){
 	 obj.disabled=false;
	 }else{
	 	 obj.disabled=true;
	 }
}
/**
* 获得对象
* id:对象的id
* oWindow:window对象
* 
*/
function getObject(id, oWindow) {
	var obj;
	if (oWindow == null) {
		obj = window.document.getElementById(id);
	} else {
		obj = oWindow.document.getElementById(id);
	}
	return obj;
}
/**
 * 获得对象数组
 * name:对象数组的名字
 * oWindow:window对象
 */
function getObjects(name, oWindow) {
	var objs;
	if (oWindow == null) {
		objs = window.document.getElementsByName(name);
	} else {
		objs = oWindow.document.getElementsByName(name);
	}
	return objs;
}
/**
* 打开模态窗口
* url:链接页面或action动作
* width:打开模态窗口的宽度
* height:打开模态窗口的高度
* 注意：打开模态窗口的页面中要在<head>后面加上
* <meta http-equiv="Pragma" content="no-cache">：禁止模态窗口缓存
* <base target="_self"/>：模态窗口中的表单在本窗口中提交
* <a onClick='window.location = "view-source:" + window.location.href'><b>源文件</b></a> 可以查看模态窗口的源文件
* 
*/
function modalWindow(url, width, height){
  var sURL = url;
  var sFeatures = "dialogWidth:" + width + "px; dialogHeight:" + height + "px; "
                + "help:no; scroll:yes; center:yes; status:no;resizable:yes";
  window.showModalDialog(sURL, window, sFeatures);
}

/**
 * 打开一个窗口
 * @param {Object} url
 * @param {Object} width
 * @param {Object} height
 */
function openModalWindow(url, width, height) {
	var sFeatures = "toolbar=no, menubar=no, scrollbars=yes, resizable=yes, " + "location=no, status=no, titlebar=no, width=" + width + ", " + "height=" + height + ", top=100, left=100";
	window.open(url, "main1", sFeatures);
	
}

/**
 * 打开一个窗口
 * @param {Object} url
 * @param {Object} width
 * @param {Object} height
 */
function showModalWindow(url, width, height) {
	var sFeatures = "dialogWidth:" + width + "px; dialogHeight:" + height + "px; "+ "help:no; scroll:yes; center:yes; status:no;resizable:yes";
	var returnVal = window.showModalDialog(url, window, sFeatures);
	return returnVal;
}


/**
 */
function selectAll(thisObj, checkboxname) {
	var obj = getObjects(checkboxname);
	var n = obj.length;
	if (thisObj.checked == true) {
		for (var i = 0; i < n; i++) {
			obj[i].checked = true;
		}
	} else {
		for (var i = 0; i < n; i++) {
			obj[i].checked = false;
		}
	}
}

/**
 * 
 * @param {Object} obj
 */
function checkNumber(obj) {
	if ((window.event.keyCode < 48) || (window.event.keyCode > 57)) {
		if(event.keyCode!=46){
		event.keyCode = 0;
		}
	}
	if(isNaN(obj.value) || obj.value<0){
	 obj.value="";
	}
}

/**
 * 通过表单名字获得要提交的数据
 * @param {Object} thisForm
 */
function getParameter(thisForm) {
	var obj = document.all(thisForm);
	var action = document.getElementById(thisForm).action;
	var url = action + "?";
	for (var i = 0; i < obj.length; i++) {
		if (obj[i].type == "text" || obj[i].type == "password" || obj[i].type == "textarea" || obj[i].type == "hidden" || obj[i].type == "select-one") {
			url += obj[i].name + "=" + obj[i].value + "&";
		} else {
			if ((obj[i].type == "radio" || obj[i].type == "checkbox") && obj[i].checked == true) {
				url += obj[i].name + "=" + obj[i].value + "&";
			}
		}
	}
	return url;
}

/**
 * 创建DOM 对象
 */
var http_request;
function createXMLRequest() {
	if (window.XMLHTTPRequest) {//Mozilla Saftri,,,,
		http_request = new XMLHTTPRequest();
	} else {
		if (window.ActiveXObject) {//IE
			http_request = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	//http_request.setRequestHeader("Content-Type","text/html;charset=UTF-8"); 
	return http_request;
}
/**
 * 触发动作的对象必须是inupt,button等
 * 提交按钮所在的表单
 * url:表单要提交的动作(可选)
 */
function postForm(thisForm) {
	if (thisForm == null) {
		thisForm = document.forms[0];
	}
	var URL = getParameter(thisForm);
	http_request = createXMLRequest();
	
	http_request.open("post", URL, true);
	
	http_request.onreadystatechange = function () {
		if (http_request.readyState == 4) {
			if (http_request.status == 200) {
				var rs = http_request.responseText;
				alert(rs);
				if(rs=='保存数据成功'){
					window.close();
				}
			}
		}
	};
	http_request.send(null);
}


/**
 * 触发动作的对象必须是inupt,button等
 * 提交按钮所在的表单
 * url:提交的动作
 */
function postURL(URL,frm){
    var xRequest=createXMLRequest(); 
   xRequest.open("post",URL,true);
	xRequest.onreadystatechange = function () {
		if (xRequest.readyState == 4) {
			if (xRequest.status == 200) {
				var rs = xRequest.responseText;
				alert(rs);
				getObject(frm).submit();
			   }
		  }
		}
		xRequest.send(null);
 }
/**
 * 通过一个对象的名字,检查一个对象是否已经存在
 * @param {Object} obj
 */
function isExist(obj){
	if(obj==null)return;
	var count=0;
	var arr=getObjects(obj.name);
	for(var i=0;i<arr.length;i++){
	   if(obj.value==arr[i].value){
	    count+=1;
	   }
	   if(count>=2){
	   alert("已存在选项");
	   obj.value="";
	    return;
	   }
	}
}

/*
*通过名字检查一个对象是否存在空值。
*/
function isHasEmptyByName(objName){
var arr=getObjects(objName);
for(var i=0;i<arr.length;i++){
	  if(arr[i].value==''){
	    alert("该值不能为空");
	    arr[i].focus();
	    return true;
	  }
}
}



/**
*检查是否为百分数 <100
*/
function checkPrecent(obj){
	if(obj.value>100){
		obj.value="";
	}	
}

function hve_display(t_id,i_id){//显示隐藏程序

var on_img="../images/fold.gif";//打开时图片
var off_img="../images/open.gif";//隐藏时图片
if (t_id.style.display == "none") {//如果为隐藏状态

t_id.style.display="";//切换为显示状态
i_id.src=on_img;}//换图
else{//否则

t_id.style.display="none";//切换为隐藏状态
i_id.src=off_img;}//换图

}


/**
  表格增加行
  flagTable=1 在动作所在的Table找addTable，否则为在整个页面找addTable
*/
function addRow(addTable,headRows,flagTable){
  var objTab;
  if (flagTable == 1){
    objTab = getEvenTable();
    objTab = getChildTableInTable(objTab,addTable);  
    
  }else{
    objTab = document.all(addTable);
  }
  if (objTab == null) {
    alert("No table:" + addTable);
    return;
  }
  if (isNaN(headRows)) headRows = 0;
  
  
  var c=objTab.rows;
  
  
  var r=c[0 + headRows];

  var newTR = r.cloneNode(true);
  
  r.parentNode.insertAdjacentElement("beforeEnd",newTR);
  initialValue(newTR);
}

/**
表格删除行
flagTable=1 在动作所在的Table找addTable，否则为在整个页面找addTable
flagInput=0 在整个页面找checkName，否则为在addTable找checkName
*/
function delRow(addTable,checkName,headRows,flagTable,flagInput){
  var objTab;
  if (flagTable != 1){
    objTab = document.all(addTable);
  }else{
    objTab = getEvenTable();  
    objTab = getChildTableInTable(objTab,addTable);     
  }
  
  if (objTab == null) {
    alert("No table:" + addTable);
    return;
  }
  
  if (isNaN(headRows)) headRows = 0;
  var aInput;
  if (flagInput == 0){
    aInput = document.getElementsByName(checkName);
  }else{ 
    aInput = objTab.getElementsByTagName("input");
  }
  var c = new Array();
  if ( aInput == null || aInput.length == 0 ) return;
  
  for ( var i = 0; i < aInput.length; i++){
    if ( aInput[i].type.toLowerCase() == "checkbox" && aInput[i].name == checkName ){
      c[c.length] = aInput[i];
    }
    
  }
 
  if (c == null || c.length == 0){
    alert ("No check box:" + checkName );
    return;
  }
  var countCheck = 0;
  for ( var i = 0; i<c.length; i++){
    if(c[i].checked){
       countCheck++;
    }
  }
  if ( objTab.rows.length - headRows - countCheck < 1 ) {
    alert("对不起，不可以全部删除，至少要保留一条记录！");
    return;
  }
  for (var k = 0; k < countCheck; k++){
      for(i=0; i<c.length; i++){
        if(c[i].checked){
          objTab.deleteRow(i + headRows);
          break;
        }
      }
  }
}

/**
  initialValue 初始化新增行中的控件中的值
  @param trObj 行对象
*/
function initialValue(trObj){
   for (var childIndex = 0; childIndex < trObj.childNodes.length; ++childIndex){
     nodeIterator(trObj.childNodes[childIndex]);
   }
}

/**
  nodeIterator节点数据iterator
*/
function nodeIterator(parentNode){

  if (parentNode == null ) return;

  if (parentNode.hasChildNodes()){

    var childNodes = parentNode.childNodes;   //子节点数组

    for (var index=0; index<childNodes.length; ++index){
         nodeIterator(childNodes[index]);
    }

  }
  else {

  var inputObj = parentNode;

  if ( inputObj == null || inputObj.type == null ) return;

  if (inputObj.type == "text") {       //控件类型为text
      //inputObj.value = "";

  }
  else if (inputObj.type.toLowerCase().indexOf("select") >=0){ //控件类型为select
     if (inputObj.options.length >0){
        inputObj.options[0].selected = true;
     }
  }
  else if(inputObj.type.toLowerCase() == "checkbox"){  //控件类型为checkbox
   inputObj.checked = false;
   }
   else if(inputObj.type.toLowerCase() == "radio"){     //控件类型radio
     inputObj.checked = false;
   }
  }
}

function getCurrentDate(){
 var d = new Date();
 var str = d.getYear()+"-"+(d.getMonth()+1)+"-"+d.getDate();
 return str;
}

function compareDate(DateOne,DateTwo)
{ 
var OneMonth = DateOne.substring(5,DateOne.lastIndexOf ("-"));
var OneDay = DateOne.substring(DateOne.length,DateOne.lastIndexOf ("-")+1);
var OneYear = DateOne.substring(0,DateOne.indexOf ("-"));

var TwoMonth = DateTwo.substring(5,DateTwo.lastIndexOf ("-"));
var TwoDay = DateTwo.substring(DateTwo.length,DateTwo.lastIndexOf ("-")+1);
var TwoYear = DateTwo.substring(0,DateTwo.indexOf ("-"));

if (Date.parse(OneMonth+"/"+OneDay+"/"+OneYear) >Date.parse(TwoMonth+"/"+TwoDay+"/"+TwoYear))
{
return true;
}
else
{
return false;
}

}





/**
* 触发动作的对象必须是inupt,button等
* 清除表单上的非隐藏域输入框的值
* 姜敏
*/
function clearForm(thisForm,param){
    var obj = document.all(thisForm);
	for (var i = 0; i < obj.length; i++) {
		
		if (obj[i].type == "text" || obj[i].type == "password" || obj[i].type == "textarea") {
			obj[i].value="";
		} 
		
		if( obj[i].type == "hidden"){
          if(param=='all'){
           obj[i].value="";
          }
        }
        
		if (obj[i].type == "select-one") {
				obj[i].options[0].selected=true;
			}
	    
	    if (obj[i].type == "radio"||obj[i].type == "checkbox") {
				obj[i].checked=false;
			}
			
		}
	}
/*

获取当前动作所在的Table

*/
function getEvenTable(){
  var obj = event.srcElement;
  for(var i = 0; i < 10; i++){
    if (obj.tagName == "TABLE") {
      return(obj);
    }else{
      obj = obj.parentElement;
      if (obj == null) return(null);
    }    
  }  
}

/*

获取oTable中id＝sTableId的Table

*/
function getChildTableInTable(oTable,sTableId){
  if (oTable == null || sTableId == null || sTableId == "") return(null);
  aChildTable = oTable.getElementsByTagName("table");
  for ( var i = 0; i < aChildTable.length; i++){
    if ( aChildTable[i].id == sTableId ){
      return(aChildTable[i]);
    }
    
  }
  return(null);
}  


function fullScreen(){
   window.dialogHeight=window.screen.availHeight;
   window.dialogWidth=window.screen.availWidth;
 }
 
 function Resize_dialog(t,l,w,h) { 
   window.dialogTop = t+"px"; 
   window.dialogLeft = l+"px"; 
   window.dialogHeight = h+"px"; 
   window.dialogWidth = w+"px"; 
} 

// 选中一列
function selectColumn(args){
	
	connectColumn(args);
	isAllSelect(args.checked);
	
}

// 是否全选
function isAllSelect(args){
	var checkB = document.getElementsByName("checkB");
	var flag = true;
	for(var  i = 0; i < checkB.length; i++){
		if(args){
			if(checkB[i].checked != args){
				flag = false;
			}
		}else{
			if(checkB[i].checked == args){
				flag = false;
			}
		}
	}
	document.getElementById("checkAll").checked = flag;
	connectColumn(document.getElementById("checkAll"));
}

function connectColumn(args){
	var column = document.getElementById("column").value;
	if(args.checked){
		if(column.indexOf(args.value) < 0){
			column = column + args.value + ",";
		}
	}else{
		if(column.indexOf(args.value) >= 0){
			var endIndex1 = column.indexOf(args.value + ",", 0);
			var startIndex2 = endIndex1 + args.value.length + 1;
			column = column.substring(0, endIndex1) + column.substring(startIndex2, column.length)
		}
	}
	document.getElementById("column").value = column;
}

//全选、反选
function allSelect(args){
	connectColumn(args);
	var checkB = document.getElementsByName("checkB");
	var flag = true;
	if(args.checked){
		flag = true;
	}else{
		flag = false;
	}
	for(var  i = 0; i < checkB.length; i++){
		checkB[i].checked = flag;
		connectColumn(checkB[i]);
	}
}
