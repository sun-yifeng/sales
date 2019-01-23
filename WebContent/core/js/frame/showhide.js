function hve_display1(t_id,i_id){//显示隐藏程序
		//var t_id;//表格ID
		//var i_id;//图片ID
		var on_img="img/searchhidden.gif";//打开时图片
		var off_img="img/searchshow.gif";//隐藏时图片
		if (t_id.style.display == "none") {//如果为隐藏状态


		t_id.style.display="";//切换为显示状态
		i_id.src=on_img;}//换图
		else{//否则


			t_id.style.display="none";//切换为隐藏状态
			i_id.src=off_img;
			//document.getElementById('t_id').parentNode.parentNode.style.background="#ff0000";
			}//换图
		}

/*显示弹出层*/
function showSomeDiv(divid)
{
	document.getElementById(divid).style.display="";
	document.getElementById("bg").style.display="block";
}
/*
显示div
*/
function showDiv(divid)
{
	document.getElementById(divid).style.display="";

}