function capture()
	{
		var obj = document.getElementById("CAP");
		try {
			obj.OnCapture();
		}catch(e) {
			alert('该截图功能只支持IE浏览器!');
			//window.location = "<%=path%>/core/screencapture/WebCapture.ocx";
		}
	}


function uploadImgData(url,data,proc)
{
	$.ajax({
		type: "POST",
		url: url,
		data: data,
		error:function()
		{
			alert('HTTPRequest请求出错');
			return false;
		},
		success: function(msg)
		{
			alert("保存成功");
		}
	});
	return false;
}