var lastTR='';//�б�ɫʱʹ��,�����ϴ�ѡ�е���
function getThisId(id){
	getObject("pkID").value=id;  
}
/**
 * ����ѡ����
 * @param {�ж���} obj
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
 * ���ñ༭״̬
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
* ��ö���
* id:�����id
* oWindow:window����
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
 * ��ö�������
 * name:�������������
 * oWindow:window����
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
* ��ģ̬����
* url:����ҳ���action����
* width:��ģ̬���ڵĿ��
* height:��ģ̬���ڵĸ߶�
* ע�⣺��ģ̬���ڵ�ҳ����Ҫ��<head>�������
* <meta http-equiv="Pragma" content="no-cache">����ֹģ̬���ڻ���
* <base target="_self"/>��ģ̬�����еı��ڱ��������ύ
* <a onClick='window.location = "view-source:" + window.location.href'><b>Դ�ļ�</b></a> ���Բ鿴ģ̬���ڵ�Դ�ļ�
* 
*/
function modalWindow(url, width, height){
  var sURL = url;
  var sFeatures = "dialogWidth:" + width + "px; dialogHeight:" + height + "px; "
                + "help:no; scroll:yes; center:yes; status:no;resizable:yes";
  window.showModalDialog(sURL, window, sFeatures);
}

/**
 * ��һ������
 * @param {Object} url
 * @param {Object} width
 * @param {Object} height
 */
function openModalWindow(url, width, height) {
	var sFeatures = "toolbar=no, menubar=no, scrollbars=yes, resizable=yes, " + "location=no, status=no, titlebar=no, width=" + width + ", " + "height=" + height + ", top=100, left=100";
	window.open(url, "main1", sFeatures);
	
}

/**
 * ��һ������
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
 * ͨ�������ֻ��Ҫ�ύ������
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
 * ����DOM ����
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
 * ���������Ķ��������inupt,button��
 * �ύ��ť���ڵı�
 * url:��Ҫ�ύ�Ķ���(��ѡ)
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
				if(rs=='�������ݳɹ�'){
					window.close();
				}
			}
		}
	};
	http_request.send(null);
}


/**
 * ���������Ķ��������inupt,button��
 * �ύ��ť���ڵı�
 * url:�ύ�Ķ���
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
 * ͨ��һ�����������,���һ�������Ƿ��Ѿ�����
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
	   alert("�Ѵ���ѡ��");
	   obj.value="";
	    return;
	   }
	}
}

/*
*ͨ�����ּ��һ�������Ƿ���ڿ�ֵ��
*/
function isHasEmptyByName(objName){
var arr=getObjects(objName);
for(var i=0;i<arr.length;i++){
	  if(arr[i].value==''){
	    alert("��ֵ����Ϊ��");
	    arr[i].focus();
	    return true;
	  }
}
}



/**
*����Ƿ�Ϊ�ٷ��� <100
*/
function checkPrecent(obj){
	if(obj.value>100){
		obj.value="";
	}	
}

function hve_display(t_id,i_id){//��ʾ���س���

var on_img="../images/fold.gif";//��ʱͼƬ
var off_img="../images/open.gif";//����ʱͼƬ
if (t_id.style.display == "none") {//���Ϊ����״̬

t_id.style.display="";//�л�Ϊ��ʾ״̬
i_id.src=on_img;}//��ͼ
else{//����

t_id.style.display="none";//�л�Ϊ����״̬
i_id.src=off_img;}//��ͼ

}


/**
  ���������
  flagTable=1 �ڶ������ڵ�Table��addTable������Ϊ������ҳ����addTable
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
���ɾ����
flagTable=1 �ڶ������ڵ�Table��addTable������Ϊ������ҳ����addTable
flagInput=0 ������ҳ����checkName������Ϊ��addTable��checkName
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
    alert("�Բ��𣬲�����ȫ��ɾ��������Ҫ����һ����¼��");
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
  initialValue ��ʼ���������еĿؼ��е�ֵ
  @param trObj �ж���
*/
function initialValue(trObj){
   for (var childIndex = 0; childIndex < trObj.childNodes.length; ++childIndex){
     nodeIterator(trObj.childNodes[childIndex]);
   }
}

/**
  nodeIterator�ڵ�����iterator
*/
function nodeIterator(parentNode){

  if (parentNode == null ) return;

  if (parentNode.hasChildNodes()){

    var childNodes = parentNode.childNodes;   //�ӽڵ�����

    for (var index=0; index<childNodes.length; ++index){
         nodeIterator(childNodes[index]);
    }

  }
  else {

  var inputObj = parentNode;

  if ( inputObj == null || inputObj.type == null ) return;

  if (inputObj.type == "text") {       //�ؼ�����Ϊtext
      //inputObj.value = "";

  }
  else if (inputObj.type.toLowerCase().indexOf("select") >=0){ //�ؼ�����Ϊselect
     if (inputObj.options.length >0){
        inputObj.options[0].selected = true;
     }
  }
  else if(inputObj.type.toLowerCase() == "checkbox"){  //�ؼ�����Ϊcheckbox
   inputObj.checked = false;
   }
   else if(inputObj.type.toLowerCase() == "radio"){     //�ؼ�����radio
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
* ���������Ķ��������inupt,button��
* ������ϵķ�������������ֵ
* ����
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

��ȡ��ǰ�������ڵ�Table

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

��ȡoTable��id��sTableId��Table

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

// ѡ��һ��
function selectColumn(args){
	
	connectColumn(args);
	isAllSelect(args.checked);
	
}

// �Ƿ�ȫѡ
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

//ȫѡ����ѡ
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
