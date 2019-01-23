package com.sinosafe.xszc.constant;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

public class Constant {

	private static final Log log = LogFactory.getLog(Constant.class);

	@SuppressWarnings("deprecation")
	public final static JSONArray getCombo(String type) {
		JSONArray result = new JSONArray();
		JSONObject objc = new JSONObject();
		objc.put("value", "");
		objc.put("text", "请选择");
		result.add(objc);

		if (type.equals("isYesOrNo")) {
			for (String[] str : isYesOrNo) {
				result.add(setValue(str));
			}
		} else if (type.equals("isParterLevel")) {
			for (String[] str : isParterLevel) {
				result.add(setValue(str));
			}
		} else if (type.equals("channelCategory1")) {
			for (String[] str : channelCategory1) {
				result.add(setValue(str));
			}
		} else if (type.equals("sex")) {
			for (String[] str : sex) {
				result.add(setValue(str));
			}
		} else if (type.equals("quarter")) {
			for (String[] str : quarter) {
				result.add(setValue(str));
			}
		} else if (type.equals("party")) {
			for (String[] str : party) {
				result.add(setValue(str));
			}
		} else if (type.equals("marry")) {
			for (String[] str : marry) {
				result.add(setValue(str));
			}
		} else if (type.equals("processStatus")) {
			for (String[] str : processStatus) {
				result.add(setValue(str));
			}
		} else if (type.equals("groupType")) {
			for (String[] str : groupType) {
				result.add(setValue(str));
			}
		} else if (type.equals("statistic")) {
			for (String[] str : statistic) {
				result.add(setValue(str));
			}
		} else if (type.equals("year")) {
			Date date = new Date();
			int year = date.getYear() + 1900;
			String[] str = new String[2];
			for (int i = 0; i < 10; i++) {
				str[0] = "" + (year);
				str[1] = "" + (year++);
				result.add(setValue(str));
			}
		} else if (type.equals("docType")) {
			for (String[] str : docType) {
				result.add(setValue(str));
			}
		} else if (type.equals("isSuccess")) {
			for (String[] str : isSuccess) {
				result.add(setValue(str));
			}
		} else if (type.equals("confirmStatus")) {
			for (String[] str : confirmStatus) {
				result.add(setValue(str));
			}
		} else if (type.equals("dataType")) {
			for (String[] str : dataType) {
				result.add(setValue(str));
			}
		} else if (type.equals("exhibitType")) {
			for (String[] str : exhibitType) {
				result.add(setValue(str));
			}
		} else if (type.equals("condType")) {
			for (String[] str : condType) {
				result.add(setValue(str));
			}
		} else if (type.equals("indexGroup")) {
			for (String[] str : indexGroup) {
				result.add(setValue(str));
			}
		} else if (type.equals("changeType")) {
			for (String[] str : changeType) {
				result.add(setValue(str));
			}
		} else if (type.equals("channelOrigin")) {
			for (String[] str : channelOrigin) {
				result.add(setValue(str));
			}
		} else if (type.equals("managerFlag")) {
			for (String[] str : managerFlag) {
				result.add(setValue(str));
			}
		} else if (type.equals("renewalLevel")) {
			for (String[] str : renewalLevel) {
				result.add(setValue(str));
			}
		} else if (type.equals("businessLine")) {
			for (String[] str : businessLine) {
				result.add(setValue(str));
			}
		} else if (type.equals("bizLine")) {
			for (String[] str : bizLine) {
				result.add(setValue(str));
			}
		} else if (type.equals("businessOrigin")) {
			for (String[] str : businessOrigin) {
				result.add(setValue(str));
			}
		} else if (type.equals("channelCategory")) {
			for (String[] str : channelCategory) {
				result.add(setValue(str));
			}
		} else if (type.equals("businessType")) {
			for (String[] str : businessType) {
				result.add(setValue(str));
			}
		} else if (type.equals("originType")) {
			for (String[] str : originType) {
				result.add(setValue(str));
			}
		} else if (type.equals("bizType")) {
			for (String[] str : bizType) {
				result.add(setValue(str));
			}
		}else if (type.equals("bizSource")) {
			for (String[] str : bizSource) {
				result.add(setValue(str));
			}
		}
		else if (type.equals("carFlag")) {
			for (String[] str : carFlag) {
				result.add(setValue(str));
			}

		} else if (type.equals("workflag")) {
			for (String[] str : workflag) {
				result.add(setValue(str));
			}

		} else if ("isValid".equals(type)) {
			for (String[] str : isValid) {
				result.add(setValue(str));
			}
		} else if ("salesmanType1".equals(type)) {
			for (String[] str : salesmanType1) {
				result.add(setValue(str));
			}
		} else if ("salesmanType2".equals(type)) {
			for (String[] str : salesmanType2) {
				result.add(setValue(str));
			}
		} else if ("deptTwo".equals(type)) {
			for (String[] str : deptTwo) {
				result.add(setValue(str));
			}
		} else if ("versionStatus".equals(type)) {
			for (String[] str : versionStatus) {
				result.add(setValue(str));
			}
		} else if ("factorType".equals(type)) {
			for (String[] str : factorType) {
				result.add(setValue(str));
			}
		} else if ("rateType".equals(type)) {
			for (String[] str : rateType) {
				result.add(setValue(str));
			}
		} else if ("channelMailType".equals(type)) {
			for (String[] str : channelMailType) {
				result.add(setValue(str));
			}
		} else if ("carType".equals(type)) {
			for (String[] str : carType) {
				result.add(setValue(str));
			}
		} else if ("channelMailWarningType".equals(type)) {
			for (String[] str : channelMailWarningType) {
				result.add(setValue(str));
			}
		} else if ("status".equals(type)) {
			for (String[] str : status) {
				result.add(setValue(str));
			}
		}


		log.debug("常量(" + type + ")返回的json数据:" + result);
		return result;
	}

	public final static JSONArray getData(String type) {
		JSONArray result = new JSONArray();
		if (type.equals("isYesOrNo")) {
			for (String[] str : isYesOrNo) {
				result.add(setValue(str));
			}
		} else if (type.equals("isParterLevel")) {
			for (String[] str : isParterLevel) {
				result.add(setValue(str));
			}
		} else if (type.equals("sex")) {
			for (String[] str : sex) {
				result.add(setValue(str));
			}
		} else if (type.equals("quarter")) {
			for (String[] str : quarter) {
				result.add(setValue(str));
			}
		} else if (type.equals("party")) {
			for (String[] str : party) {
				result.add(setValue(str));
			}
		} else if (type.equals("marry")) {
			for (String[] str : marry) {
				result.add(setValue(str));
			}
		} else if (type.equals("processStatus")) {
			for (String[] str : processStatus) {
				result.add(setValue(str));
			}
		} else if (type.equals("groupType")) {
			for (String[] str : groupType) {
				result.add(setValue(str));
			}
		} else if (type.equals("statistic")) {
			for (String[] str : statistic) {
				result.add(setValue(str));
			}
		} else if (type.equals("year")) {
			Date date = new Date();
			@SuppressWarnings("deprecation")
			int year = date.getYear() + 1900;
			String[] str = new String[2];
			for (int i = 0; i < 10; i++) {
				str[0] = "" + (year);
				str[1] = "" + (year++);
				result.add(setValue(str));
			}
		} else if (type.equals("docType")) {
			for (String[] str : docType) {
				result.add(setValue(str));
			}
		} else if (type.equals("isSuccess")) {
			for (String[] str : isSuccess) {
				result.add(setValue(str));
			}
		} else if (type.equals("confirmStatus")) {
			for (String[] str : confirmStatus) {
				result.add(setValue(str));
			}
		} else if (type.equals("dataType")) {
			for (String[] str : dataType) {
				result.add(setValue(str));
			}
		} else if (type.equals("exhibitType")) {
			for (String[] str : exhibitType) {
				result.add(setValue(str));
			}
		} else if (type.equals("condType")) {
			for (String[] str : condType) {
				result.add(setValue(str));
			}
		} else if (type.equals("indexGroup")) {
			for (String[] str : indexGroup) {
				result.add(setValue(str));
			}
		} else if (type.equals("changeType")) {
			for (String[] str : changeType) {
				result.add(setValue(str));
			}
		} else if (type.equals("managerFlag")) {
			for (String[] str : managerFlag) {
				result.add(setValue(str));
			}
		} else if (type.equals("renewalLevel")) {
			for (String[] str : renewalLevel) {
				result.add(setValue(str));
			}
		} else if (type.equals("businessLine")) {
			for (String[] str : businessLine) {
				result.add(setValue(str));
			}
		} else if (type.equals("bizLine")) {
			for (String[] str : bizLine) {
				result.add(setValue(str));
			}
		} else if (type.equals("businessOrigin")) {
			for (String[] str : businessOrigin) {
				result.add(setValue(str));
			}
		} else if (type.equals("channelCategory")) {
			for (String[] str : channelCategory) {
				result.add(setValue(str));
			}
		} else if (type.equals("channelCategory1")) {
			for (String[] str : channelCategory1) {
				result.add(setValue(str));
			}
		}  else if (type.equals("channelOrigin")) {
			for (String[] str : channelOrigin) {
				result.add(setValue(str));
			}
		} else if (type.equals("businessType")) {
			for (String[] str : businessType) {
				result.add(setValue(str));
			}
		} else if (type.equals("originType")) {
			for (String[] str : originType) {
				result.add(setValue(str));
			}
		} else if (type.equals("bizType")) {
			for (String[] str : bizType) {
				result.add(setValue(str));
			}
		} else if (type.equals("carFlag")) {
			for (String[] str : carFlag) {
				result.add(setValue(str));
			}

		} else if (type.equals("workflag")) {
			for (String[] str : workflag) {
				result.add(setValue(str));
			}

		} else if ("isValid".equals(type)) {
			for (String[] str : isValid) {
				result.add(setValue(str));
			}
		} else if ("salesmanType1".equals(type)) {
			for (String[] str : salesmanType1) {
				result.add(setValue(str));
			}
		} else if ("salesmanType2".equals(type)) {
			for (String[] str : salesmanType2) {
				result.add(setValue(str));
			}
		} else if ("deptTwo".equals(type)) {
			for (String[] str : deptTwo) {
				result.add(setValue(str));
			}
		} else if ("versionStatus".equals(type)) {
			for (String[] str : versionStatus) {
				result.add(setValue(str));
			}
		} else if ("factorType".equals(type)) {
			for (String[] str : factorType) {
				result.add(setValue(str));
			}
		} else if ("rateType".equals(type)) {
			for (String[] str : rateType) {
				result.add(setValue(str));
			}
		} else if ("channelMailType".equals(type)) {
			for (String[] str : channelMailType) {
				result.add(setValue(str));
			}
		}

		log.debug("常量(" + type + ")返回的json数据:" + result);
		return result;
	}

	public static JSONObject setValue(String[] str) {
		JSONObject oo = new JSONObject();
		oo.put("value", str[0]);
		oo.put("text", str[1]);
		return oo;
	}

	public static String[][] isYesOrNo = { { "1", "是" }, { "0", "否" } };

	// 车型数据
	public static String[][] carType = { { "100", "非营业个人客车" }, { "101", "非营业企业客车" }, { "102", "非营业机关客车" }, { "103", "非营业货车" }, { "104", "营业出租租赁" },
			{ "105", "营业城市公交" }, { "106", "营业公路客运" }, { "107", "营运货车" }, { "108", "特种车" }, { "109", "挂车" }, { "110", "摩托车" }, { "111", "拖拉机" },
			{ "112", "提车险" }, { "113", "无法分类" }, };

	public static String[][] isParterLevel = { { "195001", "隶属于总对总" }, { "195002", "隶属于分对分" } };

	public static String[][] sex = { { "106001", "男" }, { "106002", "女" }, { "106003", "不清楚" }, { "106009", "未说明" } };

	public static String[][] quarter = { { "1", "第一季度" }, { "2", "第二季度" }, { "3", "第三季度" }, { "4", "第四季度" } };

	public static String[][] party = { { "1", "党员" }, { "2", "预备党员" }, { "3", "共青团员" }, { "4", "群众" } };

	public static String[][] marry = { { "1", "已婚" }, { "2", "未婚" }, { "3", "离婚" } };

	public static String[][] processStatus = { { "1", "未处理" }, { "2", "已处理" } };

//	public static String[][] groupType = { { "7", "常规团队" }, { "6", "重客团队" }, { "3", "金融团队" }, { "8", "信保团队" } };
	
	public static String[][] groupType = {{"1","真实团队"},{"2","虚拟团队"},{"3","四级机构（团队考核）"}};
			
	public static String[][] statistic = { { "1", "本级" }, { "2", "上级" } };

	public static String year = "";

	public static String[][] docType = { { "1", "制式文档" }, { "2", "非制式文档" } };

	public static String[][] isSuccess = { { "1", "成功" }, { "0", "失败" } };

	public static String[][] confirmStatus = { { "0", "待确认" },{ "9", "已确认" } };

	public static String[][] dataType = { { "1", "整数" }, { "2", "小数" }, { "3", "字符串" } };

	public static String[][] exhibitType = { { "1", "等于" }, { "2", "区间" }, { "3", "枚举" } };

	public static String[][] condType = { { "0", "不可编辑" }, { "1", "可编辑" } };

	public static String[][] indexGroup = { { "0", "得分" }, { "1", "薪酬" } };

	public static String[][] changeType = { { "S", "升级" }, { "W", "维持" }, { "J", "降级" }, { "T", "淘汰" } };

	public static String[][] managerFlag = { { "0", "客户经理" }, { "1", "团队经理" }, { "2", "其他" } };

	public static String[][] renewalLevel = { { "0", "未下发" }, { "1", "分公司" }, { "2", "支公司" }, { "3", "团队经理" }, { "4", "客户经理" } };

	// 业务线（8条业务线，不适用销售支持系统）
	public static String[][] businessLine = { { "925004", "电话直销" }, { "925005", "网销业务" },{ "925006", "渠道重客" }, { "925007", "其他业务" }, { "925008", "信用保证险" }, { "925009", "创新" } };

	// 业务线（4条业务线，适用于销售支持系统）
	public static String[][] bizLine = { { "925007", "其他业务" }, { "925006", "渠道重客" },  { "925008", "信用保证险" } };

	public static String[][] businessOrigin = { { "01", "公司业务" }, { "02", "非公司业务" } };

	public static String[][] channelCategory = { { "01", "经代" }, { "02", "车商及其他" } };
	
	public static String[][] channelFlag = { {"0", "机构（传统渠道）"}, {"1", "个人（传统渠道）"}, {"2", "机构（互联网渠道）"}, {"3", "个人（互联网渠道）"}};
	
	public static String[][] calclateFlag = { {"0", "否"}, {"1", "是"}};
	
	public static String[][] channelOrigin = { {"0", "内部（传统渠道）"}, {"1", "外部（电商渠道）"}};

	public static String[][] channelCategory1 = { { "19001", "直销业务" }, { "19002", "代理业务" }, { "19003", "经纪业务" }, { "19004", "代理业务" }, { "19005", "修理厂" },
			{ "19006", "医院" }, { "19007", "电销业务" }, { "19008", "店面直销" } };

	public static String[][] businessType = { { "01", "营业车" }, { "02", "营业货车" }, { "03", "营业车（含其他非营业货车）" }, { "04", "货车" }, { "05", "货车（2吨以上）" },
			{ "06", "货车（2吨以下）" }, { "07", "其他货车" }, { "08", "非营业客车" }, { "09", "非营业客车（含皮卡及微货）" }, { "10", "非营业货车" }, { "11", "非营业车（含部分营业车）" },
			{ "12", "所有车型" } };
	// 分公司
	public static String[][] deptTwo = { { "01", "01深圳分公司" }, { "02", "02广东分公司" }, { "03", "03湖南分公司" }, { "04", "04福建分公司" }, { "05", "05广西分公司" },
			{ "06", "06上海分公司" }, { "07", "07北京分公司" }, { "08", "08江苏分公司" }, { "09", "09浙江分公司" }, { "10", "10四川分公司" }, { "11", "11大连分公司" }, { "12", "12山东分公司" },
			{ "13", "13重庆分公司" }, { "14", "14云南分公司" }, { "15", "15陕西分公司" }, { "16", "16辽宁分公司" }, { "17", "17江西分公司" }, { "18", "18山西分公司" }, { "19", "19天津分公司" },
			{ "20", "20安徽分公司" }, { "21", "21湖北分公司" }, { "22", "22河南分公司" }, { "23", "23宁波分公司" }, { "24", "24东莞中支" }, { "25", "25河北分公司" }, { "26", "26黑龙江分公司" },
			{ "27", "27吉林分公司" }, { "28", "28内蒙古分公司" }, { "29", "29贵州分公司" }, { "30", "30青岛分公司" }, { "31", "31海南分公司" } };

	public static String[][] carFlag = { { "0", "非车险" }, { "1", "车险" } };

	public static String[][] workflag = { { "0", "非营运车" }, { "1", "营运车" } };

	public static String[][] originType = { { "1", "公司业务" }, { "2", "其他业务" } };

	public static String[][] bizType = { { "1", "经代及其他" }, { "2", "车商" } };

	public static String[][] isValid = { { "0", "否" }, { "1", "是" } };

	public static String[][] salesmanType1 = { { "0", "销售助理" }, { "2", "独立考核的非HR人员" } };

	public static String[][] salesmanType2 = { { "0", "销售助理" }, { "1", "远程出单点出单人员" }, { "2", "独立考核的非HR人员" } };

	// 渠道管理邮件发送类型
	public static String[][] channelMailType = { { "1", "中介机构的许可证过期预警邮件" }, { "2", "个人代理人的执业证过期预警邮件" }, { "3", "中介机构的协议过期预警邮件" }, { "4", "个人代理人的协议过期预警邮件" } };

	public static String[][] channelMailWarningType = { { "1", "渠道预警" }, { "3", "渠道协议预警" }, { "5", "渠道合同预警" } };

	// 基本法版本状态
	public static String[][] versionStatus = { { "0", "未启用" }, { "1", "正在使用" }, { "2", "停用" } };

	// 基本法因素类型
	public static String[][] factorType = { { "1", "整数" }, { "2", "小数" }, { "3", "字符串" } };

	// 基本法系数类型
	public static String[][] rateType = { { "1", "险种调整系数" }, { "2", "业务线调整系数" }, { "3", "车型调整系数" }, { "4", "渠道调整系数" }, { "5", "成本调整系数" } };
	
	//HR人员管理页面的查询条件中增加“员工状态”下拉框:全部，在职，离职，离退休，不在职
	public static String[][] status = {{"1","在职"},{"2","离职"},{"3","离退休"},{"4","不在职"}};
	
	public static String[][] bizSource = {{"190020301","传统个人代理"},{"190020302","全名营销个人代理"}};
}
