package com.sinosafe.xszc.dubbo.sqlmapper;

public interface MapperNameSpace {

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
	 * 代码生成器定义的统一Delete操作
	 */
	String DELETE_PK = ".deleteByPrimaryKey";
	String DELETE_BY_ID = ".deleteById";
	String DELETE_BY_PID = ".deleteByParentId";
	
	/**
	 * 渠道管理
	 */
	String CHANNEL = "com.sinosafe.xszc.dubbo.channel.vo.ChannelMain";
	String SALESMAN = "com.sinosafe.xszc.dubbo.salesman.vo.Salesman";
	

}
