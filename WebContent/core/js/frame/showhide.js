function hve_display1(t_id,i_id){//��ʾ���س���
		//var t_id;//���ID
		//var i_id;//ͼƬID
		var on_img="img/searchhidden.gif";//��ʱͼƬ
		var off_img="img/searchshow.gif";//����ʱͼƬ
		if (t_id.style.display == "none") {//���Ϊ����״̬


		t_id.style.display="";//�л�Ϊ��ʾ״̬
		i_id.src=on_img;}//��ͼ
		else{//����


			t_id.style.display="none";//�л�Ϊ����״̬
			i_id.src=off_img;
			//document.getElementById('t_id').parentNode.parentNode.style.background="#ff0000";
			}//��ͼ
		}

/*��ʾ������*/
function showSomeDiv(divid)
{
	document.getElementById(divid).style.display="";
	document.getElementById("bg").style.display="block";
}
/*
��ʾdiv
*/
function showDiv(divid)
{
	document.getElementById(divid).style.display="";

}