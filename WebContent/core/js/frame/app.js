	/**���ص�����������**/
	function ChatHidden(div1,div2) {

           document.getElementById(div2).style.display = "none";

           document.getElementById(div1).style.height = "30px";

       }
		/**��ʾ����div**/
       function ChatShow(div1,div2,heig) {

           document.getElementById(div1).style.display = "block";

           document.getElementById(div1).style.height =heig+"px"; /**���ָ߶�һ��**/

           document.getElementById(div2).style.display = "block";

       }
		/**�ر�������������**/
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

                   var temp1 = D(div1).offsetLeft; //������ߵĳ�ʼֵ

                   var temp2 = D(div1).offsetTop;  //���붥�ߵĳ�ʼֵ

                   x = oevent(e).clientX;

                   y = oevent(e).clientY;

                   document.onmousemove = function(e) {

                       if (!drag_) {

                           return false;

                       }

                       with (this) {

                           D(div1).style.left = temp1 + oevent(e).clientX - x + "px"; //������߾������

                           D(div1).style.top = temp2 + oevent(e).clientY - y + "px"; //���붥���������

                       }

                   }

               }

               document.onmouseup = new Function("drag_=false");

           }

       }
	   
	   
	   