<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>销售支持平台</title>
<link rel="stylesheet" type="text/css" href="<%=_path%>/styles/main.css" />
<style>
*{padding:0;marging:0}
.navTree{font-weight: normal;padding-left:15px;}
</style>
<!-- view_source_begin -->
<script type="text/javascript">	
var treeLinkUrl = "";
var navLinkUrl = "";
$(document).ready(function() {
       //$("#logBtn").omButton({width:50,label:"注销"});
       var element = $('body').omBorderLayout({
       	   panels:[{
	       		id:"north-panel",
	   	        region:"north",
	   	        header : false,
	   	        height : 73,
	            resizable: false,
	   	        collapsible: false
       	    },{
       	        id:"center-panel",
       	     	header:false,
       	        region:"center"
       	    },{ //左边菜单
       	        id:"west-panel",
    	        resizable:true,
    	        collapsible:true,
    	        title:"<div class='menutop'><div class='menutitle'>销售支持平台</div><div class='lev1'><div class='lev2'><div class='lev3'></div></div></div></div>",
    	        region:"west",
    	        //expandToBottom : true,
    	        width:245 //一级菜单的宽度
       	    }],
       	    hideCollapsBtn : true,
       	    spacing : 8,
       	 	fit : true
        });
        var pp = $.parseJSON('${requestScope.fMenuJSON}');
        $(pp).each(function(index , panel){
            $("#"+panel.id).omPanel({
                title : panel.title,
                collapsible:true,
                collapsed:true,//设定初始不开启
                // 面板收缩和展开的时候重新计算自定义滚动条是否显示
                onCollapse : function(){
                    $("#west-panel").omScrollbar("refresh");
                },
                onExpand : function(){
                    $("#west-panel").omScrollbar("refresh");
                }
            });
        });
        $("#west-panel").omScrollbar();
        document.getElementById("contentFrame").src="<%=_path%>/view/main/welcome.jsp";  
        
        var tMenu = ${requestScope.tMenuJSON};
        var treeMenu = eval('('+tMenu+')');
        var fourthMenu ;
        var dataSou = [];
        var singlData = {};
        $(".nav-item").each(function(){
        	if( treeMenu[$(this).attr("id")] != '' ){
        		singlData = {id:$(this).attr("id") ,text:$(this).html(),expanded:true};
        		dataSou.push(singlData);
        		fourthMenu = treeMenu[$(this).attr("id")];
        		for(var key in fourthMenu){
        			if(typeof(fourthMenu[key]["resourceId"]) != "undefined" ){
         			singlData = {id : fourthMenu[key]["resourceId"] , pid : $(this).attr("id")  ,
         					text: fourthMenu[key]["resourceName"], url : fourthMenu[key]["url"], 
         					classes : "imagesC" };
         			dataSou.push(singlData);
        			}
        		}
        		//alert(JSON.stringify(dataSou));
        		$("#navtree_"+$(this).attr("id")).omTree({
        			dataSource : dataSou,
        			simpleDataModel : true,
        			onClick : function(node,event){
        				if(node.pid != "" && node.pid != null){
        					changeFrameByTree("<%=_path%>" + node.url);
        					treeLinkUrl = node.url;
        				}
        			}
        		});
        		$(this).remove();
        		dataSou = [];
        		//alert(JSON.stringify(fourthMenu[0]));
        	}
        });
       // 三级菜单加
       $(".imagesC").css("background","url('<%=_path%>/images/panel-com.png')  no-repeat scroll 0 0 rgba(0, 0, 0, 0) ");
        
       //捕捉链接
       $("#west-panel .om-panel").each(function(i){
	      var parentTitle = $(this).find(".om-panel-title").html();
	      $(this).find(".nav-item").click(function(){
		    	//alert(parentTitle+":"+nodeText+"\r\n"+navLinkUrl);
		    	var nodeText = clearTextFix($(this).text());
		    	var userAccessRecord = new Object();
		    	userAccessRecord.modelClass=parentTitle;
		    	userAccessRecord.modelChildClass=nodeText;
		    	userAccessRecord.actionUrl=navLinkUrl;
		    	submitVisit(userAccessRecord);
	       });
	    
	      $(this).find(".om-tree .om-tree-node span").click(function(){
		    	var forderName = clearTextFix($(this).parents(".om-tree").find(".folder").text());
		    	var nodeText   = clearTextFix($(this).text());
		    	var userAccessRecord = new Object();
		    	userAccessRecord.modelClass=parentTitle;
		    	userAccessRecord.modelChildClass=forderName+":"+nodeText;
		    	userAccessRecord.actionUrl=treeLinkUrl;
		    	submitVisit(userAccessRecord);
	      });
      });
       
      // 返回主页
      $("#leftdiv").click(function(){
      	 window.location.href = "<%=_path%>/main";
      });
      
      // 安全退出
      $("#exitButton").click(function(){
      	 window.location.href = "<%=_path%>/logout";
      });
});
   
   //提交访问记录
   function submitVisit(userAccessRecord){
	   $.ajax({
		   url:"<%=_path %>/userAccessRecord/saveVisit",
		   data:{
			  accessRecord:JSON.stringify(userAccessRecord)
		   },
		   dataType:"json",
		   success:function(jsonData){}
	   });
   }
   
   //清除字符串中空格换行空格
   function clearTextFix(text){
	   var resultStr=text.replace(/\ +/g,"");//去掉空格
	   resultStr=resultStr.replace(/[ ]/g,"");    //去掉空格
	   resultStr=resultStr.replace(/[\r\n]/g,"");//去掉回车换行
	   return resultStr;
   }
	    
	function changeFrame(url, obj) {
	   changeOtherColor();
	   document.getElementById("contentFrame").src = url;
	   navLinkUrl = url;
	   $(obj).attr("style", "border: 1px solid #99A8BC;background-color:#C4D6EC");
	}
	
	function changeFrameByTree(url) {
	   document.getElementById("contentFrame").src = url;
	}
	
	function getFrameUrl() {
		  return document.getElementById("contentFrame").src;
	}
	
	function changeOtherColor() {
	  $("#west-panel").find("div[menuDiv='true']").each(function() {
	      $(this).removeAttr("style");
	  });
	}
</script>
</head>
<body>
	<!-- view_source_begin -->
	<div id="north-panel">
	    <div id="leftdiv" style="position: absolute; width: 80%; height: 71px; cursor: pointer;" title="刷新" ></div>
		<div class="head">
			<div class="logo-${requestScope.env}">
                <ul class="rightdiv">
                    <li><div class="userinfoBlank"></div></li>
					<li>
					    <div >
						<span style="width: ${nameLength}px;" class="userinfo">${currentName}&nbsp;&nbsp;</span>
						<span><button class="exit" id="exitButton">安全退出</button></span>
						</div>
					</li>
				</ul>
			</div> 
		</div>
	</div>
	<div id="center-panel" style="padding: 0px 0px 0px 0px;">
		<iframe id="contentFrame" name="contentFrame" frameborder="0" src=""
			style="border: none; width: 100%; _width: 100%; height: 99%; _height: 99%; padding: 0px, 0px, 0px, 0px;"></iframe>
	</div>
	<div id="west-panel" class="om-accordion" style="position: relative;">
	    <!-- 一级菜单 -->
		<c:forEach items="${requestScope.fMenu}" var="fp">
			<div id="nav-panel-${fp.resourceId}" class="nav-panel" style="font-weight:bold;">
				<c:forEach items="${requestScope.sMenu}" var="sp">
					<c:if test="${fp.resourceId == sp.key}">
					    <!-- 二级菜单 -->
						<c:forEach items="${sp.value}" var="spl">
							<div class="nav-item pisu" id="${spl.resourceId}" menuDiv="true" onclick="changeFrame('<%=_path%>${spl.url}',this);">
								${spl.resourceName}
							</div>
							<!-- 三级菜单 -->
							<c:forEach items="${requestScope.tMenu}" var="tp">
								<c:if test="${not empty tp.value and tp.key == spl.resourceId }">
									<ul id="navtree_${spl.resourceId}" class="navTree"></ul>
								</c:if>
							</c:forEach>
						</c:forEach>
					</c:if>
				</c:forEach>
			</div>
		</c:forEach>
	</div>
	<!-------------------------------------------------待办工作开始------------------------------------------------->
	<!--最大化-->
	<DIV id="pop_win" style="z-index:99999;left:0px;visibility:hidden;width:320px;position:absolute;top:0px;height:170px;">
		<TABLE cellSpacing=0 cellPadding=0 width="100%" bgcolor="#FFFFFF" border=0>
		  <TR>
		    <td width="100%" valign="top" align="center">
			    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			      <tr>
				      <td width="40" class="pop_win_head" style="white-space:nowrap" align="center">提示</td>
				      <td width="25" class="pop_win_head"> </td>
				      <td align="right" class="pop_win_head">
						<!--  <span style="CURSOR:pointer;font-size:12px;font-weight:bold;margin-right:4px;" title=最小化 onclick=minDiv() >- </span> -->
				        <span style="CURSOR:pointer;font-size:12px;font-weight:bold;margin-right:4px;" title="关闭" onclick=closeDiv() >×</span>
				      </td>
			      </tr>
			    </table>
		    </td>
		  </TR>
		  <TR>
		    <td height="130" align="center" valign="middle" colSpan=3>
			    <div id="contentDiv">
			      <table width="100%" height="100%" cellpadding="0" cellspacing="0" border=0>
				      <tr border=0>
				        <td align="left" height="100%" style="padding-left: 5px;">
				        <div>
							<ul id="popMsg" style="padding-left:18px;list-style-type:none;list-style:url('<%=_path%>/images/panel-com.png');"></ul>
				        </div>
				        </td>
				      </tr>
			      </table>
			    </div>
		    </td>
		  </TR>
		</TABLE>
	</DIV>
	
	<!--最小化-->
	<DIV id="pop_win_min" style="Z-INDEX:99999; LEFT: 0px; VISIBILITY: hidden;WIDTH: 320px; POSITION: absolute; TOP: 0px;">
		<TABLE cellSpacing=0 cellPadding=0 width="100%" bgcolor="#FFFFFF" border=0>
		  <TR>
		    <td width="100%" valign="top" align="center">
		    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
		      <td width="70" class="pop_win_head" style="white-space:nowrap">工作提示（<span id="countMinWin">0</span>）</td>
		      <td width="26" class="pop_win_head"></td>
		      <td align="right" class="pop_win_head">
		        <span title=还原 style="CURSOR:pointer;font-size:13px;font-weight:bold;margin-right:4px;" onclick=maxDiv() >□</span><span title=关闭 style="cursor:pointer;font-size:13px;font-weight:bold;margin-right:4px;" onclick=closeDiv() >×</span>
		      </td>
		      </tr>
		    </table>
		    </td>
		  </TR>
		</TABLE>
	</DIV>
	<!-------------------------------------------------待办工作结束------------------------------------------------->
</body>
<script type="text/javascript">
    
	// 右下脚弹出窗口开始
	window.onload = getMsg;
	window.onresize = resizeDiv;
	window.onerror = function(){;}
	var divTop,divLeft,divWidth,divHeight,docHeight,docWidth,objTimer,i = 0;

	//onload
	function getMsg(){
		try {
		  divTop = parseInt(document.getElementById("pop_win").style.top,10);
		  divLeft = parseInt(document.getElementById("pop_win").style.left,10);
		  divHeight = parseInt(document.getElementById("pop_win").offsetHeight,10);
		  divWidth = parseInt(document.getElementById("pop_win").offsetWidth,10);
		  docWidth = document.body.clientWidth;
		  docHeight = document.body.clientHeight;
		  document.getElementById("pop_win").style.top = parseInt(document.body.scrollTop,10) + docHeight + 180 + "px";
		  document.getElementById("pop_win").style.left = parseInt(document.body.scrollLeft,10) + docWidth - divWidth + "px";
		} catch(e){;}
	}
	
	//onresize
	function resizeDiv(){
		i+=1;
		try{
		  divHeight = parseInt(document.getElementById("pop_win").offsetHeight,10);
		  divWidth = parseInt(document.getElementById("pop_win").offsetWidth,10);
		  docWidth = document.body.clientWidth;
		  docHeight = document.body.clientHeight;
		  document.getElementById("pop_win").style.top = docHeight - divHeight + parseInt(document.body.scrollTop,10) + "px";
		  document.getElementById("pop_win").style.left = docWidth - divWidth + parseInt(document.body.scrollLeft,10) + "px";
		}catch(e){;}
	}
	
	//最小化
	function minsizeDiv(){
		i+=1
		//if(i>300) closeDiv() //自动消失
		try{
		  divHeight = parseInt(document.getElementById("pop_win_min").offsetHeight,10);
		  divWidth = parseInt(document.getElementById("pop_win_min").offsetWidth,10);
		  docWidth = document.body.clientWidth;
		  docHeight = document.body.clientHeight;
		  document.getElementById("pop_win_min").style.top = docHeight - divHeight + parseInt(document.body.scrollTop,10) + "px";
		  document.getElementById("pop_win_min").style.left = docWidth - divWidth + parseInt(document.body.scrollLeft,10) + "px";
		}catch(e){;}
	}
	
	//上升动画
	function moveDiv(){
		try{
			var tmp1 = parseInt(document.getElementById("pop_win").style.top,10);
			var tmp2 = docHeight - divHeight + parseInt(document.body.scrollTop,10);
			if(tmp1 <= tmp2){
			  window.clearInterval(objTimer);
			  objTimer = window.setInterval("resizeDiv()",1);
			}
			divTop = parseInt(document.getElementById("pop_win").style.top,10);
			document.getElementById("pop_win").style.top = divTop -1 + "px";
		}catch(e){;}
	}

	//最小化
	function minDiv(){
		//closeDiv();
		document.getElementById('pop_win').style.visibility='hidden';
		document.getElementById('pop_win_min').style.visibility='visible';
		objTimer = window.setInterval("minsizeDiv()",1);
	}

	//最大化
	function maxDiv(){
		document.getElementById('pop_win_min').style.visibility='hidden';
		document.getElementById('pop_win').style.visibility='visible';
		objTimer = window.setInterval("resizeDiv()",1);
		getMsg();
	}

	//关闭
	function closeDiv(){
		//document.getElementById('pop_win').style.visibility='hidden';
		//document.getElementById('pop_win_min').style.visibility='hidden';
		$('#pop_win').fadeToggle('slow');
		$('#pop_win_min').fadeToggle('slow');
		if(objTimer) window.clearInterval(objTimer);
	}
	
	window.setTimeout('showMsg()', 200);

	/**
	 * <pre>
	 * 在线提醒：
	 * 1.提醒分三类：人员提醒、渠道提醒、公告提醒。
	 * 2.分公司和总公司角色可见提醒框，只是不同角色所见提醒的内容不同；三级机构的角色不可见提醒框。
	 * 3.分公司、总公司人员管理岗可见人员提醒；分公司、总公司渠道管理岗可见渠道提醒；分公司、总公司角色都可见公告提醒。
	 * 4.分公司渠道部门经理可见所有提醒，总公司室主任可见所有提醒，系统管理员可见所有提醒。
	 * 5.提醒数的统计范围是登录用户所在的操作机构及子机构，操作机构是指在UM分配给用户的机构，非用户所属的行政机构。
	 * </pre>
	 */
	function showMsg(){
		var tmpHtml = "";
		$.ajax({url:'<%=_path%>/getWorkMsg.do', type:'post', async:true, dataType:'JSON', success:function(data){
			var sum = 0; //待办工作总数
			if(data.show){
				document.getElementById("pop_win").style.visibility="visible";
				if(data.roleSalesman){
					tmpHtml += '<li><a href=\'javascript:changeFrame("<%=_path%>/view/main/tipSalesMan.jsp", this)\' style="color:#1D74BB"><font color="red">'+data.count1+'</font>名销售人员未配置职级及业务线</a></li>';
					sum += data.count1;
				}
				
				if(data.roleMediumLicence){
					tmpHtml += '<li><a href=\'javascript:changeFrame("<%=_path%>/view/main/mediumValid.jsp", this)\' style="color:#1D74BB"><font color="red">'+data.count2+'</font>家合作机构的许可证将于七日内到期</a></li>';
					sum += data.count2;
				}
				
				if(data.roleAgentQualification){
					tmpHtml += '<li><a href=\'javascript:changeFrame("<%=_path%>/view/main/agentValid.jsp", this)\'  style="color:#1D74BB"><font color="red">'+data.count3+'</font>名个人代理人执业证书将于七日内到期</a></li>';
					sum += data.count3;
				}
				
				if(data.roleMediumConfer){
					tmpHtml += '<li><a href=\'javascript:changeFrame("<%=_path%>/view/main/mediumConferValid.jsp", this)\' style="color:#1D74BB"><font color="red">'+data.count4+'</font>家合作机构的协议即将于七日内到期</a></li>';
					sum += data.count4;
				}
				
				if(data.roleAgentConfer){
					tmpHtml += '<li><a href=\'javascript:changeFrame("<%=_path%>/view/main/agentConferValid.jsp", this)\'  style="color:#1D74BB"><font color="red">'+data.count5+'</font>名个人代理人的协议即将于七日内到期</a></li>';
					sum += data.count5;
				}
				
				tmpHtml += '<li><a href=\'javascript:changeFrame("<%=_path%>/view/main/tipNotice.jsp?status=1", this)\' style="color:#1D74BB"><font color="red">'+data.count6+'</font>个公告待反馈</a>'+
				           '<a href=\'javascript:changeFrame("<%=_path%>/view/main/tipNotice.jsp?status=4", this)\' style="color:#1D74BB"><font color="red">'+data.count7+'</font>个公告反馈被驳回</a></li>'+
				           '<li><a href=\'javascript:changeFrame("<%=_path%>/view/main/employThreeNotice.jsp", this)\' style="color:#1D74BB"><font color="red">'+data.count8+'</font>个试用期满三个月至六个月的员工转正自动提醒</a></li>'+
				           '<li><a href=\'javascript:changeFrame("<%=_path%>/view/main/employSixNotice.jsp", this)\' style="color:#1D74BB"><font color="red">'+data.count9+'</font>个试用期满六个月的员工转正或淘汰提醒</a></li>';
				sum += data.count6 + data.count8 + data.count9;
				document.getElementById("popMsg").innerHTML=tmpHtml;
				//document.getElementById("countMaxWin").innerHTML='<font color="">' + sum + '</font>'; //[<span id="countMaxWin">0</span>]
				document.getElementById("countMinWin").innerHTML='<font color="">' + sum + '</font>';
				//
				document.getElementById("pop_win").style.visibility="visible";
				objTimer = window.setInterval('moveDiv()',10);
		     }
		   }
		});
	}	
	// 右下脚弹出窗口结束
	
    // 键盘事件
	document.onkeydown = function() {
		 // 如果按下的是退格键
	     if(event.keyCode == 8) {
		     // 如果是在textarea内不执行任何操作
		     if(event.srcElement.tagName.toLowerCase() != "input"  && event.srcElement.tagName.toLowerCase() != "textarea" && event.srcElement.tagName.toLowerCase() != "password"){
		         event.returnValue = false;
		     }
		     // 如果是readOnly或者disable不执行任何操作
		     if(event.srcElement.readOnly == true || event.srcElement.disabled == true){
		         event.returnValue = false;
		     }
	     } else if (event && event.keyCode == 112) {
	    	 event.returnValue = false;
	    	 $('#pop_win').fadeToggle('slow');
	    	 event.keyCode = 0; 
	    	 return false; 
	     }
	};
</script>
<style>
*{padding:0;marging:0}
#pop_win {border:#6EA2DB 1px solid;}
#pop_win_min{border:#6EA2DB 1px solid; }
.pop_win_head{color:#FFFFFF;font-size:12px;background: url("<%=_path%>/core/js/ref/operamasks-ui-2.1/css/hf/images/dialog/poptitle.jpg") repeat-x scroll 0 0 transparent;height:25px;padding:0,5,0,5;}
#contentDiv {background-color:#FFFFFF;font-size:12px;border:#6EA2DB 0px solid;border-left-style:none;border-right-style:none;}
a {font-size:12px;color:#000000;}
a:link {font-size:12px;color:#999999;text-decoration:none;}
a:visited {font-size:12px;color:#999999;text-decoration:none;}
a:hover {font-size:12px;color:#999999;text-decoration:none;border:#FF9900 1px dashed;border-left-style:none;border-right-style:none;border-top-style:none;}
a:actived {font-size:12px;color:#000000;text-decoration:none;}
</style>
</html>