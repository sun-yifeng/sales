/**
 * @TODO 自定义UI插件
 * created by lixiaoliang
 */
;(function ($) {
	/**
	 * 影像系统插件处理
	 * 
	 */
	$.fn.haImg = function(options){
		var defaults = {
				title:"附件下载",//标题
				sysCode:"XSZC01",//系统代码
				modelCode:"",//模块代码
				operateEmp:"xszcSystem",//操作人员代码
				srcUrl: undefined,//影像系统URL
				operateCode:"AD",//操作编码     none：表示不拼接相关参数
				seriesNo:"",//批次号
				mainBillNo:""//关联号
		};
		var opts = $.extend(defaults, options);
		if(opts.srcUrl.length > 0 && opts.srcUrl != undefined) {
			opts.srcUrl=opts.srcUrl+"&sysCode="+opts.sysCode+"&modelCode="+opts.modelCode+"&seriesNo="+opts.seriesNo+"&mainBillNo="+opts.mainBillNo+"&operateEmp="+opts.operateEmp;
			if(opts.operateCode!="none"){
				opts.srcUrl+="&operateCode="+opts.operateCode;
			}
			var htmlStr='<fieldSet style="border:solid #d0d0d0 1px;margin-top:10px; margin-left:0px;"><legend style="margin-left:20px;font-size:12px;">'+opts.title+'</legend>'+
				'<iframe height="230px" width="100%" frameborder="no" scrolling="no" src="'+opts.srcUrl+'"></iframe>'+'</fieldSet>';
			$(this).append(htmlStr);
		} else {
			$(this).append('<span style="font-size: 20px;color: red;font-weight: bolder;">error！！！该页面已失效，请按F5刷新主界面后重新操作！</span>');
		}
	};
	/**
	 * 左右选框插件
	 * 注意：单div中只支持放置一个左右选框
	 */
	$.fn.haMltSelect = function(options){
		var defaults = {
			leftTitle:"待选项：",
			rightTitle:"已选项：",
			DataSource:""//返回结果必须为Json数据，标准结构：{left:{value:'',name:''},right:{value:'',name:''}}
		};
		var opts = $.extend(defaults,options);
		var htmlStr = 
			'<table id="haMltTab">'+
			'<tr>'+
			'<td style="font-weight: bold;text-align: left;">'+opts.leftTitle+'</td>'+
			'<td/>'+
			'<td style="font-weight: bold;text-align: left;">'+opts.rightTitle+'</td>'+
			'</tr>'+
			'<tr>'+
			'<td>'+
			'<select name="leftSlt" id = "leftSlt" multiple="multiple" style="height: 315px;width: 230px;">'+
			'</select>'+
			'</td>'+
			'<td style="text-align: center;width: 80px;">'+
			'<span id="addBtn" class="button-stl">>></span><br/><br/>'+
			'<span id="addAllBtn" class="button-stl">>>|</span><br/><br/>'+
			'<span id="removeAllBtn" class="button-stl">|<<</span><br/><br/>'+
			'<span id="removeBtn" class="button-stl"><<</span>'+
			'</td>'+
			'<td>'+
			'<select name="rightSlt" id = "rightSlt" multiple="multiple" style="height: 315px;width: 230px;">'+
			'</select>'+
			'</td>'+
			'</tr>'+
			'</table>';
		$(this).children("#haMltTab").remove();//清除原有左右选框
		$(this).append(htmlStr);
		//初始化触发事件
		if(opts.DataSource!=''){
			Util.post(opts.DataSource,'',
			function(data){
				var optionLeftStr = '';
				var optionRightStr = '';
				for(var i=0;i<data.left.length;i++){
					optionLeftStr+='<option value="'+data.left[i].value+'">'+data.left[i].name+'</option>';
				}
				for(var i=0;i<data.right.length;i++){
					optionRightStr+='<option value="'+data.right[i].value+'">'+data.right[i].name+'</option>';
				}
				$("#leftSlt").html(optionLeftStr);
				$("#rightSlt").html(optionRightStr);
			});
		}
		initMltSelect();
	};
	
	
	$.fn.bsCombobox = function(options){
		var defaults = {dataSourse:undefined};
		var opts = $.extend(defaults, options);
		var a = $(this);
		if(opts.dataSourse!=undefined&&opts.dataSourse.length>0){
			$.ajax({
				type:'post',
				url:opts.dataSourse,
				async:false,
				success: function(data){
					var json = JSON.parse(data);
				    var optionStr = '';
					for(var i=0;i<json.length;i++){
						optionStr+="<option value='"+json[i].value+"'>"+json[i].name+"</option>";
					}
					$(a).children(" option[value!='']").remove();
					$(a).append(optionStr);
				}
			});
		}
		$(a).combobox();
	}
	
	
	
	/**
	 * 初始化左右选框各类点击事件函数
	 */
	function initMltSelect(){
			$("#leftSlt option:first,#rightSlt option:first").attr("selected", true);

			$("#leftSlt").dblclick(function() {
				$("option:selected", this).clone().appendTo("#rightSlt");
				$("option:selected", this).remove();
				$("#leftSlt option:first,#rightSlt option:first").attr("selected", true);
			});
	
			$("#rightSlt").dblclick(function() {
				$("option:selected", this).clone().appendTo("#leftSlt");
				$("option:selected", this).remove();
				$("#leftSlt option:first,#rightSlt option:first").attr("selected", true);
			});
	
			$("#addBtn").click(function() {
				$("#leftSlt option:selected").clone().appendTo("#rightSlt");
				$("#leftSlt option:selected").remove();
				$("#leftSlt option:first,#rightSlt option:first").attr("selected", true);
			});
	
			$("#removeBtn").click(function() {
				$("#rightSlt option:selected").clone().appendTo("#leftSlt");
				$("#rightSlt option:selected").remove();
				$("#leftSlt option:first,#rightSlt option:first").attr("selected", true);
			});
	
			$("#addAllBtn").click(function() {
				$("#leftSlt option").clone().appendTo("#rightSlt");
				$("#leftSlt option").remove();
				$("#leftSlt option:first,#rightSlt option:first").attr("selected", true);
			});
	
			$("#removeAllBtn").click(function() {
				$("#rightSlt option").clone().appendTo("#leftSlt");
				$("#rightSlt option").remove();
				$("#leftSlt option:first,#rightSlt option:first").attr("selected", true);
			});
	};
	
})(jQuery);