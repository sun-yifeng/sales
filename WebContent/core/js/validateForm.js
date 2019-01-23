/**
 * Form表单信息校验操作JS 
 * 编写者：李晓亮 
 * 时间：2014-07-03
 * 使用方法：
 * 1、必须使用class标记：omRequired表示必录      omDateCalendar表示日期格式校验  omTel联系电话格式校验
 * 2、校验项后续请加上兄弟节点 <td width="30px"><span class="errorImg"></span><span class="errorMsg" ></span></td>
 * 3、添加omMaxLength属性可控制最高可录入字符串长度
 */
validateForm = {
	validate : function(id) {
		$(id).validate(this._parseGetValidateJson(id));
		 $('.errorImg').bind('mouseover',function(){
             $(this).next().css('display','block');
         }).bind('mouseout',function(){
             $(this).next().css('display','none');
         });
	},
	// _parseGetName根据表单中的属性判断根据什么属性进行取。
	_parseGetValidateJson : function(id) {
		var validateJson = JSON.parse('{}');
		validateJson.rules = {};
		validateJson.messages = {};
		$(id + " .omRequired").each(function() {
					var elementName = $(this).attr("name");
					if (elementName != undefined && elementName != "") {
						validateJson.rules[elementName] = validateJson.rules[elementName]==undefined?{}:validateJson.rules[elementName];
						validateJson.rules[elementName].required = true;
						validateJson.messages[elementName] = validateJson.messages[elementName]==undefined?{}:validateJson.messages[elementName];
						validateJson.messages[elementName].required = "该项不能为空！";
					};
				});
				
				$(id + " .omIsNum").each(function() {
					var elementName = $(this).attr("name");
					if (elementName != undefined && elementName != "") {
						validateJson.rules[elementName] = validateJson.rules[elementName]==undefined?{}:validateJson.rules[elementName];
						validateJson.rules[elementName].isNum = true;
						validateJson.messages[elementName] = validateJson.messages[elementName]==undefined?{}:validateJson.messages[elementName];
						validateJson.messages[elementName].isNum = "该项只能是数字！";
					};
				});
		$(id + " .omDateCalendar").each(function() {
					var elementName = $(this).attr("name");
					if (elementName != undefined && elementName != "") {
						validateJson.rules[elementName] = validateJson.rules[elementName]==undefined?{}:validateJson.rules[elementName];
						validateJson.rules[elementName].isDate = true;
						validateJson.messages[elementName] = validateJson.messages[elementName]==undefined?{}:validateJson.messages[elementName];
						validateJson.messages[elementName].isDate = "请输入正确的日期格式！";
					};
				});
		$(id + " .omTel").each(function() {
					var elementName = $(this).attr("name");
					if (elementName != undefined && elementName != "") {
						validateJson.rules[elementName] = validateJson.rules[elementName]==undefined?{}:validateJson.rules[elementName];
						validateJson.rules[elementName].isTel = true;
					};
				});
		$(id + " [omMaxLength]").each(function() {
					var elementName = $(this).attr("name");
					if (elementName != undefined && elementName != "") {
						validateJson.rules[elementName] = validateJson.rules[elementName]==undefined?{}:validateJson.rules[elementName];
						validateJson.rules[elementName].maxlength = $(this).attr("omMaxLength");
						validateJson.messages[elementName] = validateJson.messages[elementName]==undefined?{}:validateJson.messages[elementName];
						validateJson.messages[elementName].maxlength = "内容长度必须小于"+$(this).attr("omMaxLength")+"！";
					};
				});
				
		validateJson.errorPlacement = function(error, element) {
			if (error.html()) {
				$(element).parents().map(function() {
							if (this.tagName.toLowerCase() == 'td') {
								var attentionElement = $(this).next()
										.children().eq(0);
								attentionElement.css('display', 'block');
								attentionElement.next().html(error);
							}
						});
			};
		};
		validateJson.showErrors = function(errorMap, errorList) {
			if (errorList && errorList.length > 0) {
				$.each(errorList, function(index, obj) {
							var msg = this.message;
							$(obj.element).parents().map(function() {
								if (this.tagName.toLowerCase() == 'td') {
									var attentionElement = $(this).next()
											.children().eq(0);
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
		};
		return validateJson;
	}
	
};

$.validator.addMethod("isTel", function(value) {
            var regu =/(^[1][3578][0-9]{9}$)|(^((\d{3,4})-)?(\d{6,8})(-(\d{3,}))?$)/; 
            var reg = new RegExp(regu);
            return reg.test(value);  // 手机,固话验证
        }, '不是有效的联系电话');

$.validator.addMethod("isIdCard", function(value) {
	idCard = trim(idCard.replace(/ /g, ""));
    if (idCard.length == 15) {
        return isValidityBrithBy15IdCard(idCard);
    }
    else 
        if (idCard.length == 18) {
            var a_idCard = idCard.split("");// 得到身份证数组   
            if (isValidityBrithBy18IdCard(idCard) && isTrueValidateCodeBy18IdCard(a_idCard)) {
                return true;
            }
            else {
                return false;
            }
        }
        else {
            return false;
        }
}, '不是有效的身份证号码');