
var json_data = { // 前后端交互数据模型
	useDW: " true 前后端基于datawindow配置, false 使用自定义的配置，使用者负责DW_DATA数据格式的组装，在后端将解析成Map",
	beanName: "", // 请求处理的bean id
	beanMethod: "doDeal", // 请求处理的method
	status: "success/error", // 请求返回时才设置
	successMsg: "附加的信息文本", // 请求返回时才设置
	errorMsg: "附加的异常信息文本", // 请求返回时才设置
	errorMsgDetail: "附加的异常详细信息文本", // 请求返回时才设置
	dwData: [
	    {   // dw数据模型
			dwType: "datawindow 类型 ONE_SELECT/MULTI_SELECT/GRID_EDIT/FREE_EDIT",
			dwName: "datawindow名称 common.work_list_DW", 
			isFilter: "false", //
			difFlag: false, //
			rowCount: "总行数", // 总行数
			pageSize: "每页大小行数",
			pageNo: "当前页码",
			pageCount: "总页数",
			filter: { // 查询条件
				CRptNo: { value: "2" },
				CLcnNo: { value: "粤A2345" }
			},
			dataObj: [ 
			{
				index: "行索引 1",
				status: "行状态 UNCHANGED/INSERTED/UPDATED/DELETED", 
				selected: "false",
				hiddened: "false",
				field: {
					CRptNo: {
						value: "",
						newValue: "",
						bakValue: "",
						text: ""
					},
					CLcnNo: {
						value: "",
						newValue: "",
						bakValue: "",
						text: ""
					}
				}
			},
			{
				index: "行索引 2",
				status: "行状态 UNCHANGED/INSERTED/UPDATED/DELETED", 
				selected: "false",
				hiddened: "false",
				field: {
					CRptNo: {
						value: "",
						newValue: "",
						bakValue: "",
						text: ""
					},
					CLcnNo: {
						value: "",
						newValue: "",
						bakValue: "",
						text: ""
					}
				}
			} ]
	    }
	],
	custData:{ // 自定义数据
		name1: "",
		name2: "",
		name3: {
			name4: "",
			name5: ""
		}
	}
};

var xml_data = '<data>'+
	'	<useDW>前后端基于datawindow配置, false 使用自定义的配置，使用者负责DW_DATA数据格式的组装，在后端将解析成Map</useDW>'+
	'	<beanName></beanName>'+
	'	<beanMethod>doDeal</beanMethod>'+
	'	<status>success/error</status>'+
	'	<successMsg>附加的信息文本</successMsg>'+
	'	<errorMsg>附加的异常信息文本</errorMsg>'+
	'	<errorMsgDetail>附加的异常详细信息文本</errorMsgDetail>'+
	'	<dwData>'+
	'		<dwType>datawindow 类型 ONE_SELECT/MULTI_SELECT/GRID_EDIT/FREE_EDIT</dwType>'+
	'		<dwName>datawindow名称 common.work_list_DW</dwName>'+ 
	'		<isFilter>false</isFilter>'+
	'		<difFlag>false</difFlag>'+
	'		<rowCount>总行数</rowCount>'+
	'		<pageSize>每页大小行数</pageSize>'+
	'		<pageNo>当前页码</pageNo>'+
	'		<pageCount>总页数</pageCount>'+
	'		<filter>'+
	'			<CRptNo>'+
	'				<value>2</value>'+
	'			</CRptNo>'+
	'			<CLcnNo>'+
	'				<value>粤A2345</value>'+
	'			</CLcnNo>'+
	'		</filter>'+
	'		<dataObj>'+
	'			<index>行索引 1</index>'+
	'			<status>行状态 UNCHANGED/INSERTED/UPDATED/DELETED</status>'+
	'			<selected>false</selected>'+
	'			<hiddened>false</hiddened>'+
	'			<field>'+
	'				<CRptNo>'+
	'					<value>1</value>'+
	'					<newValue>1</newValue>'+
	'					<bakValue>1</bakValue>'+
	'					<text>文本</text>'+
	'				</CRptNo>'+
	'				<CLcnNo>'+
	'					<value>1</value>'+
	'					<newValue>1</newValue>'+
	'					<bakValue>1</bakValue>'+
	'					<text>文本</text>'+
	'				</CLcnNo>'+
	'			</field>'+
	'		</dataObj>'+
	'		<dataObj>'+
	'			<index>行索引 2</index>'+
	'			<status>行状态 UNCHANGED/INSERTED/UPDATED/DELETED</status>'+
	'			<selected>false</selected>'+
	'			<hiddened>false</hiddened>'+
	'			<field>'+
	'				<CRptNo>'+
	'					<value>1</value>'+
	'					<newValue>1</newValue>'+
	'					<bakValue>1</bakValue>'+
	'					<text>文本</text>'+
	'				</CRptNo>'+
	'				<CLcnNo>'+
	'					<value>1</value>'+
	'					<newValue>1</newValue>'+
	'					<bakValue>1</bakValue>'+
	'					<text>文本</text>'+
	'				</CLcnNo>'+
	'			</field>'+
	'		</dataObj>'+
	'	</dwData>'+
	'	<custData>'+
	'		<name1>aa</name1>'+
	'		<name2>bb</name2>'+
	'		<name3>'+
	'			<name4></name4>'+
	'			<name5></name5>'+
	'		</name3>'+
	'	</custData>'+			
	"</data>";


Util = {
	
	/**
	 * 常量表
	 */
	consts: {
		STATUS_SUCCESS: "success",
		STATUS_ERROR: "error",
		ADAPTER_JSON: "json",
		ADAPTER_XML: "xml",
		UID: 0
	},
	
	appCxtPath: "/", // 在base.jspf文件解析输出此变量值，类似: /hf (以斜杠开头，不以斜杠结尾)
	
	/**
	 * ajax方式文件上传，使用方式：Util.uploadFile();
	 * 
	 * html:
	 * 
	 * <input id="file_upload" name="file_upload" type="file" />
	 * 
	 * js:
	 * 
	 * $( function() {
	 * 		Util.uploadFile("file_upload", {});
	 * } );
	 * 
	 * @param obj 一个html元素或id名称字符串
	 * @param
	 *		options { 参考文档
	 *			action: "" // 接受上传的后端服务地址
	 *		}
	 */
	uploadFile: function(obj, option) {
		if ( typeof(obj) == "string" && obj.substring(0,1) != "#") {
			obj = "#" + obj;
		}
		var err = [];
		$( obj ).wrap( '<div style="position:relative;"/>' ).omFileUpload( $.extend( {
		    action : Util.appCxtPath + "/dispatchActionServletForUpload",
		    swf : Util.appCxtPath + "/core/js/ref/operamasks-ui-2.1/swf/om-fileupload.swf",
		    multi: true,
		    queueSizeLimit: 20,
		    onComplete : function(ID, fileObj, response, data, event) { // 单个上传完成
		    	if (response == Util.consts.STATUS_ERROR) {
		    		err.push( fileObj.name );
		    	}
		    },
		    onAllComplete : function(data, event) { // 全部上传完成
		    	$.omMessageTip.show({
		            title : '上传完成',
		            content : '文件上传结束！' + ( err.length > 0 ? "其中上传失败"+err.length+"个("+err+")" : ""),
		            timeout : 2000
		        });
		    }
		}, option) );
		$( obj ).after( $( '<input type="button" value="上传" style="position:absolute;left:125px;height:26px;top:2px;"/>' ).click( function(event) {
			$( obj ).omFileUpload( 'upload' );
		} ) )
	},
	
	downloadFile: function(storeName, realName, debug) {
		var iframe = $( "#download_iframe" );
		if( iframe.length == 0 ) {
			iframe = $( '<iframe id="download_iframe" width="100" height="100" frameborder="1" style="display: none;"></iframe>' );
		    $( "body" ).append( iframe );
		}
		if( storeName || storeName == 0 ) {
			storeName = encodeURIComponent( encodeURIComponent( storeName ) );
		}
		if( realName || realName == 0 ){
			realName = encodeURIComponent( encodeURIComponent( realName ) );
		}
		if( debug || debug == 0 ){
			debug = encodeURIComponent( encodeURIComponent( debug ) );
		}
		iframe[ 0 ].src = Util.appCxtPath + "/dispatchActionServletForDownload?storeName="
			+ storeName + "&realName=" + realName + "&debug=" + debug;
	},
	
	/**
	 * 前后台交互方法，使用方式：Util.request( {} );
	 * 
	 * @param
	 *		options { // 通常开发人员只需要提供以下四个数据
	 * 			modelType: "JSON" or "XML",　默认为 JSON
	 * 			model: {} or <data></data>, 数据模型，参考顶部的格式
	 * 			onSuccess: function(jqXHR, textStatus, data) {},
	 * 			onError: function(jqXHR, textStatus, data) {}
	 *		}
	 */
	request : function(options) {

		var options = $.extend( {
			
			/**
			 * 请求路径
			 */
			url : "/hfDispatchActionServlet",
			
			/**
			 * 异步请求
			 */
			async : true,
			
			/**
			 * 请求数据格式：XML/JSON
			 */
			modelType: Util.consts.ADAPTER_JSON,
			
			/**
			 * 请求数据
			 */
			model : {},
			
			/**
			 * 请求成功回调方法
			 * @param jqXHR XMLHttpRequest
			 * @param testStatus "success", "notmodified", "error", "timeout", "abort", or "parsererror" 
			 * @param data 服务器返回数据 json对象
			 */
			onSuccess : function(jqXHR, textStatus, data) {

			},

			/**
			 * 请求失败回调方法
			 * @param jqXHR XMLHttpRequest
			 * @param testStatus "success", "notmodified", "error", "timeout", "abort", or "parsererror"
			 * @param data 服务器返回数据 json对象
			 * @param sendError true 标识用户在弹出的错误详细信息显示框中点击了“发送错误给管理员”按钮
			 */
			onError : function(jqXHR, textStatus, data, sendError) {

			}
			
		}, options );

		if ( !/json/i.test( options.modelType ) ) {
			options.modelType = Util.consts.ADAPTER_XML;
		}
		if ( options.url && options.url.indexOf( Util.appCxtPath + "/" ) != 0 ) {
			// 不是以上下文路径为开头的，则补充上上下文路径  Util.appCxtPath + "/" 为了区别 url带了上下文同名的字符
			options.url = Util.appCxtPath  + options.url;
		}
		
		//options.modelType = "xml";
		//options.model = xml_data;
		
		$.ajax( options.url, {
			
			async : options.async,
			
			type : "POST",
			
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			
			data : {
				_modelType : options.modelType,
				_model : options.modelType == Util.consts.ADAPTER_JSON ? JSON.stringify( options.model ) : options.model
			},					
			
			beforeSend : function(jqXHR, settings) {
				
				// 显示请求处理等待动画
				$.omMessageBox.waiting( {
					title: "请稍候",
	                content: "服务器正在处理您的请求，请稍候..."
			    } );
				
			},
			
			success : function(data, textStatus, jqXHR) {
				// 关闭请求处理等待动画
				$.omMessageBox.waiting('close');
				
				var outputModel = null; 

				try { 
					
					outputModel = JSON.parse( jqXHR.responseText );
					
				} catch (e) {

					// 回调错误处理方法
					Util._onError(options, jqXHR, "PARSERERROR", { 
						errorMsg: "解析服务器返回数据失败（" + e + "），请联系管理员！",
						errorMsgDetail: "返回数据为: " + jqXHR.responseText } );
					
					return;
					
				}
				if ( outputModel.status == Util.consts.STATUS_SUCCESS ) {
					
					// 回调成功处理方法
					Util._onSuccess(options, jqXHR, "success", outputModel );
					
				} else if ( outputModel.status == Util.consts.STATUS_ERROR ) {
					
					// 回调错误处理方法	
					Util._onError(options, jqXHR, "error", outputModel );
					
				}
			},
			
			error : function(jqXHR, textStatus, errorThrown) {
				
				// 关闭请求处理等待动画
				$.omMessageBox.waiting('close');
				
				// 回调错误处理方法
				Util._onError(options, jqXHR, textStatus, { errorMsg: errorThrown } );
				
			}
		} );
		
		
		
	},
	
	//post方式提交请求
	post:function(url,param,callBack){
		var op = $.extend( {
			
			/**
			 * 请求路径
			 */
			url : "/hfDispatchActionServlet",
			
			/**
			 * 异步请求
			 */
			async : true,
			
			/**
			 * 请求数据格式：XML/JSON
			 */
			modelType: Util.consts.ADAPTER_JSON,
			
			/**
			 * 请求数据
			 */
			model : {},
			
			/**
			 * 请求成功回调方法
			 * @param jqXHR XMLHttpRequest
			 * @param testStatus "success", "notmodified", "error", "timeout", "abort", or "parsererror" 
			 * @param data 服务器返回数据 json对象
			 */
			onSuccess : '',

			/**
			 * 请求失败回调方法
			 * @param jqXHR XMLHttpRequest
			 * @param testStatus "success", "notmodified", "error", "timeout", "abort", or "parsererror"
			 * @param data 服务器返回数据 json对象
			 * @param sendError true 标识用户在弹出的错误详细信息显示框中点击了“发送错误给管理员”按钮
			 */
			onError :''
			
		});
		$.ajax( url, {
			
			async : true,
			
			type : "POST",
			
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			
			data : param,					
			
			beforeSend : function(jqXHR, settings) {
				
				// 显示请求处理等待动画
				$.omMessageBox.waiting( {
					title: "请稍候",
	                content: "服务器正在处理您的请求，请稍候..."
			    } );
				
			},
			
			success : function(data, textStatus, jqXHR) {
				// 关闭请求处理等待动画
				$.omMessageBox.waiting('close');
				
				var outputModel = null; 

				try { 
						if(jqXHR.responseText&&jqXHR.responseText!=''){
							outputModel = JSON.parse( jqXHR.responseText );
						}
				} catch (e) {

					// 回调错误处理方法
					Util._onError(op, jqXHR, "PARSERERROR", { 
						errorMsg: "解析服务器返回数据失败（" + e + "），请联系管理员！",
						errorMsgDetail: "返回数据为: " + jqXHR.responseText } );
					
					return;
					
				}
				if (!outputModel||outputModel._status == Util.consts.STATUS_SUCCESS || outputModel._status == undefined || outputModel._status == null) {
					// 回调成功处理方法
					Util._onCallBack(outputModel,callBack);
				} else if ( outputModel.status == Util.consts.STATUS_ERROR ) {
					
					// 回调错误处理方法	
					/*Util._onError(op, jqXHR, "PARSERERROR", { 
						errorMsg: "解析服务器返回数据失败（" + e + "），请联系管理员！",
						errorMsgDetail: "返回数据为: " + jqXHR.responseText } );*/
					Util._onError(op, jqXHR, "error", outputModel );
					
				}
			},
			
			error : function(jqXHR, textStatus, errorThrown) {
				
				// 关闭请求处理等待动画
				$.omMessageBox.waiting('close');
				
				// 回调错误处理方法
				Util._onError(op, jqXHR, textStatus, { errorMsg: errorThrown } );
				
			}
		} );
	},
	
	/**
		 * 请求成功回调方法 (内部方法)
		 * @param options 配置选项 (传递进来，避免多次调用request方法时出现引用错误)
		 * @param jqXHR XMLHttpRequest
		 * @param testStatus "success", "notmodified", "error", "timeout", "abort", or "parsererror" 
		 * @param data 服务器返回数据 json对象
		 */
	_onSuccess: function(options, jqXHR, textStatus, data) {

		if ( $.isFunction( options.onSuccess ) ) {
			
			// 回调自定义的成功处理方法
			options.onSuccess( jqXHR, textStatus, data );
			
		}
		
	},
	_onCallBack:function(data,callback){
		if($.isFunction(callback)){
			callback(data);
		}
	},
	
	/**
	 * 请求失败回调方法 (内部方法)
	 * @param options 配置选项 (传递进来，避免多次调用request方法时出现引用错误)
	 * @param jqXHR XMLHttpRequest
	 * @param testStatus "success", "notmodified", "error", "timeout", "abort", or "parsererror"
	 * @param data 服务器返回数据 json对象
	 */
	_onError: function(options, jqXHR, textStatus, data) {
		var tm = Util.consts.UID++;
		var errorMsg= data.errorMsg, errorMsgDtl = data.errorMsgDetail;
		if ( errorMsgDtl ) {
			
			var dlg = $('<div id="dialog' + tm + '" style="display: none;"></div>')
				.html( "<p>" +errorMsg + "</p><p>"+errorMsgDtl+"</p>" + 
						"<div style='text-align:right'>" +
						"	<input type='button' value='发送错误给管理员' " +
						"		onclick='" +
						"			$(this).closest(\".om-dialog-content\").data(\"sendError\", true).closest(\".om-dialog\")" +
						"				.find(\".om-dialog-titlebar-close\").click();'" +
						"	/>" +
						"</div>")
				.appendTo("body");
			
			if( $.isFunction( options.onError ) ) {
				// 定义全局引用，否则在弹出框中回调方法不能引用到，在弹出框关闭时，必须用delete释放全局引用				
				dlg.data( "_gOnErrorFn", options.onError );
				dlg.data( "_gjqXHR", jqXHR );
				dlg.data( "_gtextStatus", textStatus );
				dlg.data( "_gdata", data );
				dlg.data("_excDtl",errorMsgDtl);//异常详细信息
			}
							
			var _click = 
				" $('#dialog" + tm + "').omDialog( {" +
				"	modal: true," +
				"	title: '系统错误'," +
				"	onClose: function(){" +
				"	 if( this.data( '_gOnErrorFn' ) ) {" + // 回调错误处理方法
				"		this.data('_gOnErrorFn')(this.data('_gjqXHR'),this.data('_gtextStatus'),this.data('_gdata'),!!this.data('sendError' ),this.data('_excDtl'));"+ 
				"	 }" +
				"	 this.remove(); " + // 删除对话框div
				"	}" +
				" } );";
			errorMsg += "<p><a style=\"font: bold;color: red;\" href=\"javascript:void(0);\" onclick=\"" + _click + // 打开详细错误信息显示窗口							
					"$(this).closest('div.om-messageBox').data('detail', true).find('#confirm').click();"+ // 关闭简要错误信息显示窗口
				"\">查看详细错误</a></p>"; 
		}
		$.omMessageBox.alert( {
			type: "error",
			title: "系统错误",
			content: errorMsg,
			onClose: function(value) {
				// 没有打开详细错误显示窗口，则在简要错误信息显示窗口关闭时，回调错误处理方法，
				// 如果己打开详细错误显示窗口，则详细错误显示窗口关闭时会回调错误处理方法，此处不需要再次调用
				if ( !$( this ).data( 'detail' ) ) {
					if( $.isFunction( options.onError ) ) {
						options.onError( jqXHR, textStatus, data );
					}
				}
				
			}
		} );		
	}

}