///////////////////////////////////////影像系统集成/////////////////////////////////////////////////////

var haim_iframeSrcs = new Array();//用来存放集成影像系统的iframe的ID	
var haim_iframeIds = new Array();//用来存放对应集成影像系统的iframe要加载的src

//var _claim_clipboardData_oldvalue2 = window.clipboardData.getData('text');//原剪切板数据，若剪切板解决方案被去除后，调整影像系统为不操作剪切板，则可去除此步操作

/**
*@param iframeIds 页面上需要跨域访问并自适应高度的Iframe
*@param iframeSrcs 相应的iframe的地址src
*功能：根据地址src，加载相应的iframe。并在加载完成后，自适应高度
*注意：iframeIds与iframeSrcs是相对应的且都是数组，因此数组大小要一致
*     自适应是有条件的，在被加载的src对应的页面要做处理
*集成影像系统
*/
function loadAllIFrame(){
	if(haim_iframeIds.length>0 && haim_iframeSrcs.length>0){	
		var if_height;
		var iframe = document.all(haim_iframeIds.shift());
		var ifream_src = haim_iframeSrcs.shift();
		iframe.src=ifream_src;
		
		//alert(ifream_src+'\n'+iframe.src);

		jQuery.receiveMessage(function(e){
			var h = Number( e.data.replace( /.*if_height=(\d+)(?:&|$)/, '$1' ) );			
			if ( !isNaN( h ) && h > 0 && h != if_height ) { 
			  if_height = h;
			  iframe.height=if_height;
			  
			  loadAllIFrame();
//			  if(_claim_clipboardData_oldvalue2!=null)
//			  	window.clipboardData.setData('text', _claim_clipboardData_oldvalue2);//放回原剪切板数据
			}
			
		});	
	}
}


/**把从影像系统读取页面的iframe及其src，存放到相应的全局的数组中*/
function pushReadFromHaimIframe(seriesNo, mainBillNo, iframID, sysCode) {
	var url = generaterHaimURL('',seriesNo, mainBillNo, iframID, sysCode,'R');
	url+=' #';
	url+=encodeURIComponent(document.location.href);
	
	haim_iframeIds.push(iframID);
	haim_iframeSrcs.push(url);
}
/**把从影像系统可写页面的iframe及其src，存放到相应的全局的数组中*/
function pushWriteToHaimIframe(modelCode, seriesNo, mainBillNo, iframID, sysCode) {
	var url = generaterHaimURL(modelCode, seriesNo, mainBillNo, iframID, sysCode,'AD');
	url+=' #';
	url+=encodeURIComponent(document.location.href);
	
	haim_iframeIds.push(iframID);
	haim_iframeSrcs.push(url);
}

/**把从影像系统页面的iframe及其src，存放到相应的全局的数组中*/
function pushHaimIframeWithOpTag(modelCode, seriesNo, mainBillNo, iframID, sysCode,opTag) {
	var url = generaterHaimURL(modelCode, seriesNo, mainBillNo, iframID, sysCode,opTag);
	url+=' #';
	url+=encodeURIComponent(document.location.href);
	
	haim_iframeIds.push(iframID);
	haim_iframeSrcs.push(url);
}


/**
 * 取得从影像系统读图片的URL
 * @param seriesNo   任务号
 * @param mainBillNo 主单证号(报案号)
 * @param iframID 将显示图片的IFram
 * @return
 */
function readFromHaimURL(seriesNo, mainBillNo, iframID, sysCode) {
	var url = imageUrl + "/general/display.do?action=dispalySpSN&operateCode=R";
	
	if (sysCode == null || sysCode == "") {
		url += "&sysCode=S004";
	} else {
		url += "&sysCode=" + sysCode;
	}

	if (seriesNo != "") {
		url += "&seriesNo=";
		url += seriesNo;
	}
	if (mainBillNo != "") {
		url += "&mainBillNo=";
		url += mainBillNo;
	}

	url += "&operateEmp=" + operateEmp + "&operateEmpName=" + operateEmpName
			+ "&operateDpt=" + operateDpt + "&operateDptName=" + operateDptName;
	
	
	return encodeURI(url);

}
/**
 * 取得往影像系统写图片的URL
 * @param modelCode 模块代码
 * @param seriesNo 任务号
 * @param mainBillNo 主单证号(报案号)
 * @param iframID 将显示图片的IFram
 * @return
 */
function writeToHaimURL(modelCode, seriesNo, mainBillNo, iframID, sysCode) {
	var url = imageUrl + "/general/display.do?action=dispalySpSN&operateCode=AD";

	if (sysCode == null || sysCode == "") {
		url += "&sysCode=S004";
	} else {
		url += "&sysCode=" + sysCode;
	}
	if (modelCode != "") {
		url += "&modelCode=";
		url += modelCode;
	}
	if (seriesNo != "") {
		url += "&seriesNo=";
		url += seriesNo;
	}
	if (mainBillNo != "") {
		url += "&mainBillNo=";
		url += mainBillNo;
	}

	
	url += "&operateEmp=" + operateEmp + "&operateEmpName=" + operateEmpName+ "&operateDpt=" + operateDpt + "&operateDptName=" + operateDptName;
	
	return encodeURI(url);
}

/**
 * 取得影像系统操作类型为opTag的URL
 * @param modelCode 模块代码
 * @param seriesNo 任务号
 * @param mainBillNo 主单证号(报案号)
 * @param iframID 将显示图片的IFram
 * @return
 */
function generaterHaimURL(modelCode, seriesNo, mainBillNo, iframID, sysCode,opTag) {
	var url = imageUrl + "/general/display.do?action=dispalySpSN&operateCode="+opTag;

	if (sysCode == null || sysCode == "") {
		url += "&sysCode=S004";
	} else {
		url += "&sysCode=" + sysCode;
	}
	if (modelCode != "") {
		url += "&modelCode=";
		url += modelCode;
	}
	if (seriesNo != "") {
		url += "&seriesNo=";
		url += seriesNo;
	}
	if (mainBillNo != "") {
		url += "&mainBillNo=";
		url += mainBillNo;
	}

	
	url += "&operateEmp=" + operateEmp + "&operateEmpName=" + operateEmpName+ "&operateDpt=" + operateDpt + "&operateDptName=" + operateDptName;
	
	return encodeURI(url);
}



