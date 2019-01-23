/* 客服代码 */
$("#onlineOpen").mouseover(function(){
	var onService_panel=$("#onService_panel");
	onService_panel.animate({right:0},function(){});
	$(this).hide();
	
	//判断我来显示按钮是否显示按钮
		if($("#allowFlag").val()=="true"){
			$("#helpMsgControlBtn").show();
		}else{
		    $("#helpMsgControlBtn").hide();
		}
});

$("#onlineClose").click(function(){
	var onService_panel=$("#onService_panel");
	onService_panel.animate({right:-102});
	onService_panel.find(".online_tab").fadeOut(100);
	$("#onlineOpen").show();
});

$("#onService_panel .tab_close").click(function(){
	$(this).parents(".online_tab").hide();
});

/* 限制文字字数 */
function checkLen(obj,maxs){
	var maxChars = maxs;//最多字符数 
	if (obj.value.length > maxChars){
		obj.value = obj.value.substring(0,maxChars);
	}
	var curr = maxChars - obj.value.length; 
	$(obj).parents("dl").find(".text_length b").text(curr.toString());
} 