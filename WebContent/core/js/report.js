/*
 * 功能：报表JS代码
 * 作者：sunyf
 * 日期：2015-04-20
 */

// 计算grid高度
function calcHeight(id) {
	var panelObj = $('#' + id);
	var panelOffset = panelObj.offset();
	var panelNum = panelOffset.top + panelObj.outerHeight();
	var bodyObj = $("body");
	var bodyOffset = bodyObj.offset();
	var bodyNum = bodyOffset.top + bodyObj.outerHeight();
	var number = 50;
	switch (id){
	  case 'search-panel':
	  	number = 30;
	  case 'buttonbar':
	  	number = 50;
	  default:
	  	number = 50;
	}
	var gridNum = bodyNum - panelNum - number;
	if ($.browser.msie && ($.browser.version == "6.0" || $.browser.version == "7.0")) {
		gridNum = gridNum + 2;
	}
	return gridNum;
}

//计算grid高度
function calcHeight1(id, number) {
	var panelObj = $('#' + id);
	var panelOffset = panelObj.offset();
	var panelNum = panelOffset.top + panelObj.outerHeight();
	var bodyObj = $("body");
	var bodyOffset = bodyObj.offset();
	var bodyNum = bodyOffset.top + bodyObj.outerHeight();
	var gridNum = bodyNum - panelNum - number;
	if ($.browser.msie && ($.browser.version == "6.0" || $.browser.version == "7.0")) {
		gridNum = gridNum + 2;
	}
	return gridNum;
}

// 单元对齐
function alignCell(value) {
	if ('---' === value) {
		return '<div style="text-align:center;">' + value + '</div>';
	} else {
		return '<div style="text-align:right;">' + value + '</div>';
	}
}

// 查询或导出
function query(operType) {
	$('#operType').val(operType);
	$('#tableCols').val(JSON.stringify(tableCols));
	var url = Util.appCxtPath + "/reportCommon/queryReportList.do?" + $("#filterFrm").serialize();
	if (operType === 1) {
		$("#tables").omGrid("setData",url);
	} else if (operType === 2) {
		$("#filterFrm").attr("method","post").attr("action", Util.appCxtPath + "/reportCommon/queryReportList.do").submit();
	} 
	else {
		alert("操作类型错误！");
	}
}

// 查询
function iniQuery() {
	setTimeout('query(1)', 500);
}
// 报表页面初始化
function iniPage(panelTile) {
	// 样式
	$("#filterFrm").find("input[name^='formMap']").css({
		"width" : "150px"
	});
	$(".sele").css({
		"width" : "132px"
	});
    // 导航
	$("#search-panel").omPanel({
		title : (panelTile=="客户经理考核评分查询"||panelTile=="团队经理考核评分查询")? "考核评分管理  > " + panelTile:"报表管理  > " + panelTile,
		collapsible : true,
		collapsed : false
	});

	// 报表表格
	dataGrid = $("#tables").omGrid({
		limit : (panelTile=="业务来源统计报表")?0:15,
		colModel : tableHead,
		showIndex : true,
		height : calcHeight("search-panel"),
		method : 'POST'
	});

	// 按钮样式
	$("#button-search").omButton({
		icons : {
			left : Util.appCxtPath + '/images/search.png'
		},
		width : 50
	});
	$("#button-dataToExcel").omButton({
		icons : {
			left : Util.appCxtPath + '/images/op-edit.png'
		},
		width : 60
	});
}

// 机构级联下拉框
function iniDept(deptTwo, deptThree, deptFour) {
	// 分公司
	$('#' + deptTwo).omCombo({
		dataSource : Util.appCxtPath + "/department/queryDepartmentByUserCode.do?param=" + Math.random(),
		onSuccess : function(data, textStatus, event) {
			if (data.length == 2)
				$('#' + deptTwo).omCombo({
					value : eval(data)[1].value,
					readOnly : true
				});
		},
		onValueChange : function(target, newValue, oldValue, event) {
			// 加载三级机构
			$('#' + deptThree).val('').omCombo('setData', Util.appCxtPath + "/department/queryDepartmentCityByUserCode.do?upDept=" + newValue);
		},
		optionField : function(data, index) {
			return data.text;
		},
		emptyText : "请选择"
	});

	// 三级机构
	$('#' + deptThree).omCombo({
		onSuccess : function(data, textStatus, event) {
			if (data.length === 2) {
				$('#' + deptThree).omCombo("value", data[1].value);
				$('#' + deptThree).omCombo({
					readOnly : true
				});
			}
		},
		onValueChange : function(target, newValue, oldValue, event) {
			// 加载四级单位
			$('#' + deptFour).val('').omCombo('setData', Util.appCxtPath + "/department/queryDepartmentMarketByUserCode.do?upDept=" + newValue);
		},
		emptyText : '请选择'
	});

	// 四级单位
	$('#' + deptFour).omCombo({
		emptyText : "请选择"
	});

} // end iniDept()

// 业务线
function iniLine(data) {
	$("#bizLine").omCombo({
		dataSource : data,
		valueField : 'value',
		inputField : 'text',
		filterStrategy : 'anywhere',
		emptyText : '请选择'
	});
}

// 报表日期（日报、周报、月报）
function iniDate(dateType) {
	// 日报
	if ('reportDay' === dateType) {
		var preDate = new Date();
		$('#' + dateType).omCalendar({
			dateFormat : "yy-mm-dd",
			editable : false
		});
		preDate.setDate(preDate.getDate() - 1);
		$('#' + dateType).val($.omCalendar.formatDate(preDate, "yy-mm-dd"));
	}
	// 周报
	else if ('reportWeek' === dateType) {
		var time = new Date();
		// 开始日期
		time.setDate(time.getDate() - time.getDay() - 7); // 计算开始日期（周日）
		$('#reportWeekBng').val($.omCalendar.formatDate(time, "yy-mm-dd"));
		$('#reportWeekBng').omCalendar({
			disabledDays : [ 1, 2, 3, 4, 5, 6 ],
			dateFormat : "yy-mm-dd",
			editable : false,
			disabled : false,
			onSelect : function(date, event) {
				time.setTime(date.getTime() + (24 * 6 * 3600 * 1000));
				$('#reportWeekEnd').val($.omCalendar.formatDate(time, "yy-mm-dd"));
			}
		});
		// 结束日期
		time.setDate(time.getDate() - time.getDay() + 6); // 计算结束日期（周六）
		$('#reportWeekEnd').val($.omCalendar.formatDate(time, "yy-mm-dd"));
		$('#reportWeekEnd').omCalendar({
			disabledDays : [ 1, 2, 3, 4, 5, 7 ],
			dateFormat : "yy-mm-dd",
			editable : false,
			disabled : false,
			onSelect : function(date, event) {
				time.setTime(date.getTime() - (24 * 6 * 3600 * 1000));
				$('#reportWeekBng').val($.omCalendar.formatDate(time, "yy-mm-dd"));
			}
		});
	}
	// 月报
	else if ('reportMonth' === dateType) {
		$('#reportMonth').omCalendar({
			dateFormat : "yy-mm",
			editable : false
		});
		var preDate = new Date();
		preDate.setMonth(preDate.getMonth() - 1);
		$('#reportMonth').val($.omCalendar.formatDate(preDate, "yy-mm"));
	} else {
		alert("报表日期类型错误！");
	}
}