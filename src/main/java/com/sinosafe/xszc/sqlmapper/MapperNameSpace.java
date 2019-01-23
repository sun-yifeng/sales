package com.sinosafe.xszc.sqlmapper;

public interface MapperNameSpace {
	/**
	 * 机构
	 */
	String MAIN_RESOURCE = "com.sinosafe.xszc.main.vo.MainResource";
	String UM_DEPARTMENT = "com.sinosafe.xszc.law.vo.UmDepartment";
	String DEPARTMENT = "com.sinosafe.xszc.department.vo.Department";

	/**
	 * 基本法
	 */
	String T_ORIGIN_RATE = "com.sinosafe.xszc.law.vo.TLawOriginRate";
	String T_RANK_VALUE = "com.sinosafe.xszc.law.vo.TRankValue";
	String T_CALC_VALUE = "com.sinosafe.xszc.law.vo.TCalcValue";
	String LAW_DEFINE = "com.sinosafe.xszc.law.vo.LawDefine";
	String T_INDEX_FACTOR = "com.sinosafe.xszc.law.vo.TIndexFactor";
	String T_INDEX_CALC = "com.sinosafe.xszc.law.vo.TIndexCalc";
	String T_RANK_DEF = "com.sinosafe.xszc.law.vo.TRankDef";
	String T_RANK_FACTOR = "com.sinosafe.xszc.law.vo.TRankFactor";
	String LAW_DEFINE_DEPT = "com.sinosafe.xszc.law.vo.LawDefineDept";
	String LAW_FACTOR = "com.sinosafe.xszc.law.vo.LawFactor";
	String LAW_TARGET = "com.sinosafe.xszc.law.vo.LawTarget";
	String T_RANK_CALC = "com.sinosafe.xszc.law.vo.TRankCalc";
	String T_COST_RATE = "com.sinosafe.xszc.law.vo.TLawCostRate";
	String T_LAW_LINE_RATE = "com.sinosafe.xszc.law.vo.TLawLineRate";
	String T_LAW_PRODUCT_RATE = "com.sinosafe.xszc.law.vo.TLawProductRate";
	String T_LAW_RATE = "com.sinosafe.xszc.law.vo.TLawRate";
	String T_LAW_CALC_PROCE = "com.sinosafe.xszc.law.vo.TLawCalcProce";
	String T_LAW_FACTOR_IMP_VALUE = "com.sinosafe.xszc.law.vo.TLawFactorImpValue";
	String T_LAW_RULE_CONFIG = "com.sinosafe.xszc.law.vo.TLawRuleConfig";
	String T_LAW_DEFINE_MANUAL = "com.sinosafe.xszc.law.vo.LawDefineManul";
	String T_LAW_DEFINE_MANUAL_STEP = "com.sinosafe.xszc.law.vo.LawDefineManulStep";
	

	/**
	 * 活动管理
	 */
	String REPORT_DAY_AGENT_CHANNEL = "com.sinosafe.xszc.report.vo.ReportDayAgentChannel";
	String REPORT_DAY_SALE_TRACE = "com.sinosafe.xszc.report.vo.ReportDaySaleTrace";
	String REPORT_WEEK_SALE_TRACE = "com.sinosafe.xszc.report.vo.ReportWeekSaleTrace";
	String REPORT_WEEK_AGENT_CHANNEL = "com.sinosafe.xszc.report.vo.ReportWeekAgentChannel";
	String REPORT_DAY_TRACE_HEBEI = "com.sinosafe.xszc.report.vo.ReportDuty";
	String REPORT_DAY_GROUP_MANAGER = "com.sinosafe.xszc.report.vo.ReportDayGroupManager";
	String REPORT_FOUNDATION_MEDIUM = "com.sinosafe.xszc.report.vo.ReportFoundationMedium";
	String REPORT_MONTH_AGENT_INFO = "com.sinosafe.xszc.report.vo.ReportMonthAgentInfo";
	String REPORT_WEEK_GROUP_MANAGER = "com.sinosafe.xszc.report.vo.ReportWeekGroupManager";
	String REPORT_MOTH_GROUP_MANAGER = "com.sinosafe.xszc.report.vo.ReportMothGroupManager";
	String REPORT_TOTAL_AGENT_INFO = "com.sinosafe.xszc.report.vo.ReportTotalAgentInfo";
	String REPORT_TOTAL_GROUP_MENBER = "com.sinosafe.xszc.report.vo.ReportTotalGroupMenber";
	String REPORT_DAY_GROUP_SALE = "com.sinosafe.xszc.report.vo.ReportDayGroupTotal";
	String REPORT_WEEK_GROUP_SALE = "com.sinosafe.xszc.report.vo.ReportWeekGroupTotal";
	String REPORT_MONTH_GROUP_SALE = "com.sinosafe.xszc.report.vo.ReportMonthGroupTotal";
	String REPORT_DAY_REMOTE_POLICY = "com.sinosafe.xszc.report.vo.ReportDayRemotePolicy";
	String REPORT_WEEK_REMOTE_POLICY = "com.sinosafe.xszc.report.vo.ReportWeekRemotePolicy";
	String REPORT_MONTH_REMOTE_POLICY = "com.sinosafe.xszc.report.vo.ReportMonthRemotePolicy";

	/**
	 * 活动管理
	 */
	String ACTIVITY = "com.sinosafe.xszc.activity.vo.Activity";
	String ACTIVITY_FEEDBACK = "com.sinosafe.xszc.activity.vo.ActivityFeedback";
	String ACTIVITY_EXPAND = "com.sinosafe.xszc.activity.vo.ActivityExpand";
	String ACTIVITY_RECEIVE_DEPT = "com.sinosafe.xszc.activity.vo.ActivityReceiveDept";

	/**
	 * 活动
	 */
	String NOTICE = "com.sinosafe.xszc.notice.vo.Notice";
	String NOTICE_DEPT = "com.sinosafe.xszc.notice.vo.NoticeReceiveDept";
	String NOTICE_FEEDBACK = "com.sinosafe.xszc.notice.vo.NoticeFeedback";
	String NOTICE_MISSION = "com.sinosafe.xszc.notice.vo.NoticeMission";

	/**
	 * 续保
	 */
	String RENEWAL = "com.sinosafe.xszc.renewal.vo.Renewal";
	String RENEWAL_LEVEL = "com.sinosafe.xszc.renewal.vo.RenewalLevel";
	String RENEWAL_ASSIGN_RECORD = "com.sinosafe.xszc.renewal.vo.RenewalAssignRecord";

	/**
	 * 市场调研
	 */
	String SURVEY = "com.sinosafe.xszc.survey.vo.Survey";
	String MARKET_RESINFOR_CHANNEL = "com.sinosafe.xszc.survey.vo.MarketResInforChannel";
	String MARKET_RESINFOR_LOCAL = "com.sinosafe.xszc.survey.vo.MarketResInforLocal";
	String MARKET_RESINFOR_MAIN = "com.sinosafe.xszc.survey.vo.MarketResInforMain";
	String MARKET_RESINFOR_PREMIUM = "com.sinosafe.xszc.survey.vo.MarketResInforPremium";

	/**
	 * 考核绩效管理
	 */
	String REVIEW_SALARY = "com.sinosafe.xszc.review.vo.ReviewSalary";
	String REVIEW_RANK = "com.sinosafe.xszc.review.vo.ReviewRank";
	String REVIEW_RANK_HISTORY = "com.sinosafe.xszc.review.vo.ReviewRankHistory";
	String NEW_YEAR_REWARD = "com.sinosafe.xszc.review.vo.NewYearReward";

	/**
	 * 营销团队管理
	 */
	String SALESMAN_EMPLOY = "com.sinosafe.xszc.group.vo.SalesmanEmploy";
	String SALESMAN_VIRTUAL = "com.sinosafe.xszc.group.vo.SalesmanVirtual";
	String SALESMAN = "com.sinosafe.xszc.group.vo.Salesman";
	String GROUP_MAIN = "com.sinosafe.xszc.group.vo.GroupMain";
	String GROUP_CHANGE_RECORD = "com.sinosafe.xszc.group.vo.GroupChangeRecord";
	String GROUP_LEADER_RECORD = "com.sinosafe.xszc.group.vo.GroupLeaderRecord";

	/**
	 * 销售保费计划
	 */
	String PLAN_MAIN = "com.sinosafe.xszc.plan.vo.PlanMain";
	String PLAN_DEPT_DETAIL = "com.sinosafe.xszc.plan.vo.PlanDeptDetail";
	String PLAN_CHANNEL_DETAIL = "com.sinosafe.xszc.plan.vo.PlanChannelDetail";

	/**
	 * 销售保费计划
	 */
	String PLAN_MAIN_NEW = "com.sinosafe.xszc.planNew.vo.PlanMainNew";
	String PLAN_DETAIL_NEW = "com.sinosafe.xszc.planNew.vo.PlanDetailNew";
	String PLAN_CHANNEL_DETAIL_NEW = "com.sinosafe.xszc.planNew.vo.PlanChannelDetailNew";

	/**
	 * 渠道管理
	 */
	String CHANNEL = "com.sinosafe.xszc.channel.vo.ChannelMain";
	String MEDIUM = "com.sinosafe.xszc.channel.vo.ChannelMediumDetail";
	String MEDIUM_CONTECT = "com.sinosafe.xszc.channel.vo.ChannelMediumContact";
	String MEDIUM_NODE = "com.sinosafe.xszc.channel.vo.ChannelMediumNode";
	String CHANNEL_MAINTAIN = "com.sinosafe.xszc.channel.vo.ChannelMediumMaintain";
	String MEDIUM_CONFER = "com.sinosafe.xszc.channel.vo.ChannelConfer";
	String CONFER_PRODUCT = "com.sinosafe.xszc.channel.vo.ChannelConferProduct";
	String CHANNEL_WARNING = "com.sinosafe.xszc.channel.vo.ChannelWarning";
	String AGENT = "com.sinosafe.xszc.channel.vo.ChannelAgentDetail";
	String MEDIUM_MAIN_HISTORY = "com.sinosafe.xszc.channel.vo.ChannelMainHistory";
	String MEDIUM_HISTORY = "com.sinosafe.xszc.channel.vo.ChannelMediumDetailHistory";
	String AGENT_HISTORY = "com.sinosafe.xszc.channel.vo.ChannelAgentDetailHistory";
	String REVIEW_SCORE = "com.sinosafe.xszc.review.vo.ReviewScore";
	String FACTOR_GOT_PRM = "com.sinosafe.xszc.review.vo.TLawFactorGotPrm";
	String T_MISSION = "com.sinosafe.xszc.review.vo.TMission";
	String MEDIUM_CONFER_HISTORY = "com.sinosafe.xszc.channel.vo.ChannelConferHistory";
	String CONFER_PRODUCT_HISTORY = "com.sinosafe.xszc.channel.vo.ChannelConferProductHistory";
	String MEDIUM_NODE_ACCOUNT = "com.sinosafe.xszc.channel.vo.ChannelMediumNodeAccount";
	String PERSON_INFO_HISTORY = "com.sinosafe.xszc.review.vo.TPersonInfoHistory";
	String CHANNEL_MAIL_WARNING = "com.sinosafe.xszc.channel.vo.ChannelMailWarning";
	String CONFER_TURNOVER = "com.sinosafe.xszc.channel.vo.ConferTurnover";
	String CHANNEL_MAIL_RECORD = "com.sinosafe.xszc.channel.vo.ChannelMailRecord";
	String RECOMMENDER = "com.sinosafe.xszc.channel.vo.ChannelRecommendDetail";
	String MEDIUM_SALESMAN = "com.sinosafe.xszc.channel.vo.MediumSalesman";
	
	
	/**
	 * 电商渠道管理
	 */
	String ENTERPISE = "com.sinosafe.xszc.partner.vo.Enterprise";
	String INDIVIDUAL = "com.sinosafe.xszc.partner.vo.Individual";
	String CONFER = "com.sinosafe.xszc.partner.vo.Confer";

	/**
	 * common下拉框字典
	 */
	String COMMON_AREA = "com.sinosafe.xszc.common.vo.Area";
	String COMMON_BANK = "com.sinosafe.xszc.common.vo.Bank";
	String COMMON_BANK_NODE = "com.sinosafe.xszc.common.vo.BankNode";
	String COMMON_CITY = "com.sinosafe.xszc.common.vo.City";
	String COMMON_PROVINCE = "com.sinosafe.xszc.common.vo.Province";
	String COMMON_CATEGORY = "com.sinosafe.xszc.common.vo.Category";
	String COMMON_CHANNEL_FEATURE = "com.sinosafe.xszc.common.vo.ChannelFeature";
	String COMMON_PROFESSION = "com.sinosafe.xszc.common.vo.Profession";
	String COMMON_BUSINESS_LINE = "com.sinosafe.xszc.common.vo.BusinessLine";
	String COMMON_GROUP_MAIN="com.sinosafe.xszc.group.vo.GroupMain";
	String COMMON_CHANNEL_LEVEL = "com.sinosafe.xszc.common.vo.ChannelLevel";
	String COMMON_COUNTRY = "com.sinosafe.xszc.common.vo.Country";
	String COMMON_PROPERTY = "com.sinosafe.xszc.common.vo.Property";
	String COMMON_CONFER_TYPE = "com.sinosafe.xszc.common.vo.ConferType";
	String COMMON_CHANNEL_PARTNER_TYPE = "com.sinosafe.xszc.common.vo.ChannelPartnerType";
	String COMMON_CERTIFY_TYPE = "com.sinosafe.xszc.common.vo.CertifyType";
	String COMMON_EDUCATIOIN = "com.sinosafe.xszc.common.vo.Educatioin";
	String COMMON_TITLE = "com.sinosafe.xszc.common.vo.Title";
	String COMMON_T_PRD_KIND = "com.sinosafe.xszc.common.vo.TPrdKind";
	String COMMON_T_PRD_PROD = "com.sinosafe.xszc.common.vo.TPrdProd";
	String COMMON_NATIONAL       = "com.sinosafe.xszc.common.vo.National";
	String COMMON_SALESMAN_RANK  = "com.sinosafe.xszc.common.vo.SalesmanRank";
	String COMMON_SALESMAN_STATUS = "com.sinosafe.xszc.common.vo.SalesmanStatus";
	String COMMON_SALESMAN_TYPE  = "com.sinosafe.xszc.common.vo.SalesmanType";
	String COMMON_GROUP_RANK     = "com.sinosafe.xszc.common.vo.GroupRank";
	String COMMON_FINANCE_POLICY = "com.sinosafe.xszc.common.vo.FinancePolicyFlag";
	
	/**
	 * 用户帮助信息
	 */
	String USER_HELP_MSG = "com.sinosafe.xszc.main.vo.UserHelpMsg";
	String USER_ROLE = "com.sinosafe.xszc.main.vo.UserRole";

	/**
	 * 文件上传
	 */
	String UPLOAD = "com.sinosafe.xszc.upload.vo.Upload";
	
	/**
	 * 定时任务
	 */
	String AUTO_TASK = "com.sinosafe.xszc.autoTask.AutoTask";
	
	/**
	 * 访问记录
	 */
	String USER_ACCESS = "com.sinosafe.xszc.main.vo.UserAccessRecord";

	/**
	 * 查询所有需要被禁掉保存，修改，删除的区域
	 */
	String AUTH = "com.sinosafe.xszc.auth.vo.Auth";
	
	/**
	 * 代码生成器定义的VO操作方法名
	 */
	String INSERT_VO = ".insertVo";
	String UPDATE_PK_VO = ".updateByPrimaryKeySelectiveVo";
	String UPDATE_VO = ".updateByPrimaryKeyVo";
	String QUERY_ONE_VO = ".selectByPrimaryKeyVo";
	String QUERY_COUNT_VO = ".queryCountVo";
	String QUERY_LIST_PAGE_VO = ".queryListPageVo";
	String QUERY_VO = ".queryVo";
	String QUERY_PAGE_VO = ".queryPage";
	String QUERY_CHANNELONE_VO = ".selectByPrimaryKeyChannel";

	/**
	 * 代码生成器定义的Map操作方法名
	 */
	String INSERT = ".insert";
	String UPDATE_PK = ".updateByPrimaryKeySelective";
	String UPDATE = ".updateByPrimaryKey";
	String UPDATE_RESOURCE = ".updateResourceAndChild";
	String QUERY_ONE = ".selectByPrimaryKey";
	String QUERY_COUNT = ".queryCount";
	String VIRTUAL_HISTORY=".countVirtualHistory";
	String QUERY_COUNT_New = ".queryCountNew";
	String QUERY_COUNT_WITHUSER = ".queryCountWithUser";
	String QUERY_LIST_PAGE = ".queryListPage";
	String QUERY_LIST_PAGE_WITHUSER = ".queryListPageWithUser";
	String QUERY = ".query";
	String QUERY_PAGE = ".queryPage";
	String QUERY_USER_BY_DEPT = "queryUserCNameByDept";
	String QUERY_PARENT_DEPT = ".queryParentDept";
	String QUERY_DEPT = ".queryDept";
	String QUERY_LIST_TO_EXCEL = ".queryListToExcel";
	String QUERY_DEPT_CODE = ".queryDeptCode";
	String QUERY_LISTS_PAGE = ".queryListsPage";
	String QUERY_GROUP_LISTS_PAGE = ".querySaleGroupListsPage";
	String QUERY_SALESMAN_LIST_PAGE = ".querySalesmanListPage";
	String QUERY_PARENT_MEDIUMS = ".queryParentMediums";
	String QUERY_ID_LIST = ".queryIdList";
	String QUERY_AGENT_LIST_PAGE = ".queryAgentListPage";
	String QUERY_AGENT_LISTS_PAGE = ".queryAgentListsPage";
	String QUERY_CUSTOMER_MANAGER_LIST_PAGE = ".queryCustomerManagerListPage";
	String QUERY_GROUP_MANAGER_LIST_PAGE = ".queryGroupManagerListPage";

	/**
	 * 公告
	 */
	String QUERY_NOTICE_FOR_FEEDBACK_PAGE = ".query_notic_for_feedback";
	String QUERY_NOTICE_FOR_DEAL_PAGE = ".query_notic_for_deal";
	String QUERY_WITHOUT_WEEK = ".query_without_week";

	/**
	 * 代码生成器定义的统一Delete操作
	 */
	String DELETE_PK = ".deleteByPrimaryKey";
	String DELETE_BY_ID = ".deleteById";
	String DELETE_BY_PID = ".deleteByParentId";

}
