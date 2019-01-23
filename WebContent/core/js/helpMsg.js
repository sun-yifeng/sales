var url = "";
//contentFrame
$(function(){
     //判断是否是是主框架页面,如果是则不显示帮助浮动按钮
	 var frames = $("iframe[name='contentFrame']");
	 if(frames.length>0){
	    $("#onService_panel").hide();
	 }else{
	 	try{
	 	    url = parent.document.getElementById("contentFrame").contentWindow.location.href;
	 	    url = url.substring(url.indexOf("/xszc"),url.length);
	 	    if(url.lastIndexOf("?")>-1){
	 	        url = url.substring(0,url.lastIndexOf("?"));
	 	    }
		 	//var url = parent.getFrameUrl();
		    $("#onService_panel").show();
		    //判断父级页面是否有帮助信息显示，如果有，则隐藏掉
		    hideParentHelp();
		    //获取当前页面的帮助信息
		    readyCurPageMsg();
	 	}catch(e){
	 	     $("#onService_panel").hide();
	 	}
	 }
});



//获取当前页面的帮助信息,如果没有当前页面的信息则会创建一条信息
function readyCurPageMsg(){
   var basePath = Util.appCxtPath;
   $.ajax({ 
		url: basePath+"/userHelpMsg/readyCurPageMsg",
		data:{
		   pageCode:url
        },
		type:"post",
		async: true,
		dataType: "json",
		success: function(data){
		    if($("#helpBeanInput").length<1){
			   var helpBeanInputHtml = "<input type='hidden' id='helpBeanInput' value='' />";
			   $(helpBeanInputHtml).prependTo("body");
			}
			var jsonStr = JSON.stringify(data); 
			$("#helpBeanInput").val(jsonStr);
			//我来配置的是否显示状态值存到页面的隐藏中
			if($("#allowFlag").length<1){
			   var allowHtml = "<input type='hidden' id='allowFlag' value='' />";
			   $(allowHtml).prependTo("body");
			   $("#allowFlag").val(data.allowFlag);
			}
		}
  });
}

//弹出帮助信息
function showHelpMsg(){
	var basePath = Util.appCxtPath;
	//取到值
	var jsonStr = $("#helpBeanInput").val();
	var helpBean = JSON.parse(jsonStr); 
	
	if($("#helpMsgArea").length<1){
	   var areaHtml = "<div id=\"helpMsgArea\" style=\"width:630px;height:500px;display:none;font-size:14px;line-height:22px\">" +
	   		"</div>";
	   $(areaHtml).prependTo("body");
	}
	
	var helpContentHTML = "";
	$.ajax({ 
		url: basePath+"/userHelpMsg/revertContent",
		data:{
		   helpContent:helpBean.helpContent
        },
		type:"post",
		async: false,
		dataType: "html",
		success: function(dataHtml){
		    helpContentHTML = dataHtml;
		}
    });
	
	$("#helpMsgArea").html(helpContentHTML);
	$("#helpMsgArea").omDialog({
		  title:'帮助信息',
	      autoOpen: true,
		  width:630,
		  height:500,
		  modal: true
	});
}

//设置帮助信息
function setHelpMsg(){
    //取到值
	var jsonStr = $("#helpBeanInput").val();
	var helpBean = JSON.parse(jsonStr); 
	if($("#helpMsgArea").length<1){
	   var areaHtml = "<div id=\"helpMsgArea\" style=\"display:none\"></div>";
	   $(areaHtml).prependTo("body");
	}
	var basePath = Util.appCxtPath;
	var url = basePath+"/view/main/eidtHelpMsg.html";
	$("#helpMsgArea").load(url);
	//提交按钮
	$("#helpMsgArea").omDialog({
		  title:'帮助信息',
	      autoOpen: true,
		  width:650,
		  height:429,
		  modal: true
	});
	
	setTimeout(function(){
		$("input[name='pkId']").val(helpBean.pkId);
	    $("input[name='parentPkid']").val(helpBean.parentPkid);
	    $("input[name='pageName']").val(helpBean.pageName);
	    $("input[name='pageCode']").val(helpBean.pageCode);
	    $("textarea[name='helpContent']").val(helpBean.helpContent);
	},200);
}

//提交数据
function submitHelpData(){
	var pkId = $("input[name='pkId']").val();
	var parentPkid = $("input[name='parentPkid']").val();
	var pageName =   $("input[name='pageName']").val();
    var pageCode =   $("input[name='pageCode']").val();
    var helpContent =   $("textarea[name='helpContent']").val();
    
    //将值重新保存到临时区域--开始
	var jsonStr = $("#helpBeanInput").val();
	var helpBean = JSON.parse(jsonStr); 
	helpBean.pageName=pageName;
	helpBean.helpContent=helpContent;
    var jsonStr = JSON.stringify(helpBean); 
	$("#helpBeanInput").val(jsonStr);
	//将值重新保存到临时区域--结束
	
    var basePath = Util.appCxtPath;
    $.ajax({ 
		url: basePath+"/userHelpMsg/saveHelpMsg",
		data:{
		   pkId:pkId,
		   parentPkid:parentPkid,
		   pageName:pageName,
		   pageCode:pageCode,
		   helpContent:helpContent
        },
		type:"post",
		async: true,
		dataType: "json",
		success: function(jsonData){
		    if(jsonData.actionFlag){
		       alert("保存成功！");
		    }else{
		       alert("保存失败！");
		    }
		}
  });
}



//隐藏工具栏
function hiddenToolBar(){
   $("#onService_panel").hide();
}

//隐藏父级帮助信息
function hideParentHelp(){
   var showFlag = parent.isShowHelp();
   if(showFlag){
       parent.hiddenToolBar();
   }
}

//true代表已显示
function isShowHelp(){
   if($("#onService_panel").css("display")!="none"){
       return true;
   }else{
       return false;
   }
}

