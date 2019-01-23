	/**隐藏弹出窗体内容**/
	function ChatHidden(div1,div2) {

           document.getElementById(div2).style.display = "none";

           document.getElementById(div1).style.height = "30px";

       }
		/**显示弹出div**/
       function ChatShow(div1,div2,heig) {

           document.getElementById(div1).style.display = "block";

           document.getElementById(div1).style.height =heig+"px"; /**保持高度一致**/

           document.getElementById(div2).style.display = "block";

       }
		/**关闭整个弹出窗口**/
       function ChatClose(div1) {
		   document.getElementById(div1).style.display = "none";
		   document.getElementById('bg').style.display = "none";
		   
       }


       var drag_ = false

       var D = new Function('obj', 'return document.getElementById(obj);');

       var oevent = new Function('e', 'if (!e) e = window.event;return e');

       function Move_obj(obj,div1,div3) {

           var x, y;

           D(div3).onmousedown = function(e) {

               drag_ = true;

               with (this) {

                   D(div3).style.position = "absolute";

                   var temp1 = D(div1).offsetLeft; //距离左边的初始值

                   var temp2 = D(div1).offsetTop;  //距离顶边的初始值

                   x = oevent(e).clientX;

                   y = oevent(e).clientY;

                   document.onmousemove = function(e) {

                       if (!drag_) {

                           return false;

                       }

                       with (this) {

                           D(div1).style.left = temp1 + oevent(e).clientX - x + "px"; //层离左边距的像素

                           D(div1).style.top = temp2 + oevent(e).clientY - y + "px"; //层离顶部距的像素

                       }

                   }

               }

               document.onmouseup = new Function("drag_=false");

           }

       }
	   
	   
	   