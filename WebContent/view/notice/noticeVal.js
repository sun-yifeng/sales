
//定义校验规则
var deptRule = {
	//反馈天数
	feedbackDay:{
		required : true,
		isNum:true,
		maxlength : 10
	},
	
};

//定义校验的显示信息
var deptMessages = {
	//机构代码
	feedbackDay:{
		required:'请输入反馈天数',
		isNum : '邮政编码必须是数字'
		maxlength:'最多10位'
	},
	
};

//校验
function initValidate(){
	//var parentCode  = $('#parentDeptCode').val();
	//if(parentCode == ''){
	//	$('#parentDeptName').val('');
	//}
	//
	$("#filterFrm").validate({
		rules: deptRule,
		messages: deptMessages,
		errorPlacement : function(error, element) {
	        if (error.html()) {
		        $(element).parents().map(function() {
			        if (this.tagName.toLowerCase() == 'td') {
				        var attentionElement = $(this).next().children().eq(0);
				        attentionElement.css('display', 'block');
				        attentionElement.next().html(error);
			        }
		        });
	        }
        },
        showErrors : function(errorMap, errorList) {
	        if (errorList && errorList.length > 0) {
		        $.each(errorList, function(index, obj) {
			        var msg = this.message;
			        $(obj.element).parents().map(function() {
				        if (this.tagName.toLowerCase() == 'td') {
					        var attentionElement = $(this).next().children().eq(0);
					        attentionElement.show();
					        attentionElement.next().html(msg);
				        }
			        });
		        });
	        } else {
		        $(this.currentElements).parents().map(function() {
			        if (this.tagName.toLowerCase() == 'td') {
				        $(this).next().children().eq(0).hide();
			        }
		        });
	        }
	        this.defaultShowErrors();
        },
                
    });
}