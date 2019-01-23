package com.sinosafe.xszc.constant;

/**
 * <pre>
 * 销售支持系统角色共16个
 * </pre>
 */
public class RoleConstant {

	public static final String XSZC_ADMIN = "xszcAdmin"; // 销售支持系统开发角色

	// 总公司角色共5个
	public static final String HEAD_DEPT_DIRECTOR = "headDeptDirector"; // 总公司_室主任
	public static final String HEAD_DEPT_SALESMAN = "haedDeptSalesman"; // 总公司_人员管理岗
	public static final String HEAD_DEPT_CHANNEL_CH = "headDepatChennelCh"; // 总公司_渠道管理岗_渠道重客
	public static final String HEAD_DEPT_CHANNEL = "headDeptChannel"; // 总公司_渠道管理岗_市场开发
	public static final String HEAD_DEPT_FINANCE_SAFE = "headDepatFinanceSafe"; // 总公司_渠道管理岗_金融保险
	// 分公司角色共6个
	public static final String SUB_DEPT_SALESMAN = "subDeptSalesman"; // 分公司渠道部门_人员管理岗
	public static final String SUB_DEPT_MANAGER = "subDeptManager"; // 分公司_渠道管理岗_市场开发
	public static final String SUB_DEPT_CHANNEL_CH = "subDeptChennelCh"; // 分公司_渠道管理岗_渠道重客
	public static final String SUB_DEPT_FINANCE_SAFE = "subDeptFinanceSafe"; // 分公司_渠道管理岗_金融保险
	public static final String SUB_DEPT_MARKET_MANAGER = "subDeptMarketM"; // 分公司市场部_续保管理岗
	public static final String SUB_DEPT_ADMIN = "subDeptAdmin"; // 分公司渠道部门_经理
	// 三级公司角色共2个
	public static final String THIRD_DEPT_MIDDLE = "thirdDeptMiddle"; // 三级机构_中支总
	public static final String THIRD_DEPT_BUSI_MANAGER = "thirdDeptBusiMana"; // 三级机构_业管
	// 团队长角色共2个
	public static final String GROUP_CAPTAIN = "groupCaptain"; // 团队_团队长
	public static final String GROUP_MANAGER = "groupManager"; // 团队_客户经理

	// 分公司角色
	public static final String[] RoleSubArray = { SUB_DEPT_MANAGER, SUB_DEPT_CHANNEL_CH, SUB_DEPT_SALESMAN, SUB_DEPT_FINANCE_SAFE,
			SUB_DEPT_MARKET_MANAGER, SUB_DEPT_ADMIN };

}
