var openID = ""; //����չ��״̬�Ĳ˵�ID
var firstLength = 3; //һ���Ӳ˵��ĳ���
var secondLength = 6; //�����Ӳ˵��ĳ���
var subLength = 3; //�����˵��ĳ��Ȳ�

var off_img = "img/add.gif";//����ʱͼƬ
var on_img = "img/sub.gif";//չ��ʱͼƬ
var functionCde = '';

function setFunctionCde(args){
	this.functionCde = args;
}

function tdclick(urlname) {
	form1.action = urlname + '&functionCde=' + functionCde;
	form1.target = "main";
	//ȥ������ûѡ�е�trΪ
	var rows = document.getElementsByTagName("tr");
	for ( var i = 0; i < rows.length; i++) {
		rows[i].className = "";
	}
	//����ѡ�е�tr
	event.srcElement.parentNode.className = "red";
	//form1.submit();
	parent.frames['main'].location = urlname + '&functionCde=' + functionCde;
}

function tree(ctlID) //����˵�ʱ�˵�������
{
	var isOpen = -1; //�ò˵��µ����в˵���չ���������� 0Ϊ����,1Ϊչ��
	var obj;
	for ( var i = 0; i < document.all.length; i++) {
		obj = document.all.item(i);
		if(obj.id.length==ctlID.length&&obj.id!=ctlID){
			changeImage(obj, off_img);
		}
	}
	for ( var i = 0; i < document.all.length; i++) {
		obj = document.all.item(i);
		if (obj.id.length > firstLength) {
			if (obj.id.substring(0, ctlID.length) == ctlID
					&& obj.id.length == (ctlID.length + subLength)) {
				if (obj.style.display == "none") {
					obj.style.display = "";
					changeImage(document.all(ctlID), on_img);
				} else {
					obj.style.display = "none";
					changeImage(document.all(ctlID), off_img);
				}
			} 
			if (obj.id.substring(0, ctlID.length) != ctlID) {//����ͬ���˵�������
				if (obj.id.length == ctlID.length) {
					changeImage(obj, off_img);
				} else if (obj.id.length > ctlID.length) {
					obj.style.display = "none";
				}
			}
		}
	}
}

function tree1(ctlID) //�����Ӳ˵�
{

	var isOpen = -1; //�ò˵��µ����в˵���չ���������� 0Ϊ����,1Ϊչ��
	var obj;

	for ( var i = 0; i < document.all.length; i++) {
		obj = document.all.item(i);
		if (obj.id.length > firstLength) {
			if (obj.id.substring(0, ctlID.length) == ctlID
					&& obj.id.length > ctlID.length) {

				if (obj.style.display == "none") {

					obj.style.display = "";
					changeImage(document.all(ctlID), on_img);

				} else {

					obj.style.display = "none";
					changeImage(document.all(ctlID), off_img);

				}

			} else if (obj.id.substring(0, ctlID.length) != ctlID) {//����ͬ���˵�������
				if (obj.id.length == ctlID.length) {

					changeImage(obj, off_img);

				} else if (obj.id.length > ctlID.length) {

					obj.style.display = "none";

				}
			}
		}
	}

}

function iniTtree() {
	var thisID = "";
	for ( var i = 0; i < document.all.length; i++) {
		if (document.all.item(i).id.length > 0) {
			if (thisID == "")
				thisID = document.all.item(i).id;
			if (document.all.item(i).id.length > thisID.length)
				document.all.item(i).style.display = "none";
		}
	}
	tree(thisID);
}

//��oTr���ͼƬ����sImg
function changeImage(oTr, sImg) {
	//var oTr = event.srcElement.parentElement;
	if (oTr.tagName != "TR")
		return (false);

	var aObj = oTr.getElementsByTagName("IMG");
	for ( var i = 0; i < aObj.length; i++) {
		if (aObj[i].src != null
				&& (aObj[i].src.indexOf(on_img.substring(on_img.indexOf("/"),
						on_img.length - 1)) != -1 || aObj[i].src
						.indexOf(off_img.substring(off_img.indexOf("/"),
								off_img.length - 1)) != -1)) {
			aObj[i].src = sImg;
		}
	}
}
//ѡ�е���ɫ
function selectThis(obj) {
	alert(obj.table);

	for ( var i = 1; i < obj1.rows.length; i++) {
		obj1.rows[i].className = "";
	}
	obj.className = "red";

}
function change(pic) {
	if (pic.value == "images/plus.gif") {
		pic.value = "images/minus.gif"
	} else {
		pic.value = "images/plus.gif"
	}
}
