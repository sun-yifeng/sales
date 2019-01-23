package com.sinosafe.xszc.planNew.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.PLAN_DETAIL_NEW;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.PLAN_MAIN_NEW;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;

import java.beans.IntrospectionException;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.constant.Constant;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.department.vo.Department;
import com.sinosafe.xszc.planNew.service.PlanMainService;
import com.sinosafe.xszc.planNew.service.SalePlanDetailService;
import com.sinosafe.xszc.planNew.vo.PlanDetailNew;
import com.sinosafe.xszc.planNew.vo.PlanMainNew;
import com.sinosafe.xszc.util.ExcelReader;
import com.sinosafe.xszc.util.ExcelWrite;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.ReflectMatch;

public class SalePlanDetailServiceImpl implements SalePlanDetailService {

	private static final Log log = LogFactory.getLog(SalePlanDetailServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier("PlanMainNewService")
	private PlanMainService planMainService;
	
	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;
	
	/**
	 * 覆盖方法batchSaveDataInXls详细说明:从xls中批量读取<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月5日 下午6:20:53 </pre>
	 * @param 参数名 说明
	 * @return 返回值类型 说明
	 * @throws 异常类型 说明
	 * @see com.sinosafe.xszc.planNew.service.SalePlanDetailService#batchSaveDataInXls(java.lang.String)
	 */
	public boolean batchSaveDataInXls(String filePath,String planType,String planYear){
		IUserDetails curUserInfo = CurrentUser.getUser();
		String userName = curUserInfo.getUsername();
		boolean actionFlag = false;
		InputStream is2 = null;
		try{
			is2 = new FileInputStream(filePath);
			// 对读取Excel表格内容测试
			ExcelReader excelReader = new ExcelReader();
			// 部门机构|险种|业务线|保费(万元)|发展思路及举措|备注
			//String[] title = excelReader.readExcelTitle(is2);
			Map<Integer, String> map = excelReader.readExcelContent(is2);
			List<PlanMainNew> planMainList = new ArrayList<PlanMainNew>();
			PlanMainNew planMainNew = null;
			String deptName = "";
			Timestamp curTime = Timestamp.valueOf(DateUtil.getSystemDateStr("yyyy-MM-dd hh:mm:ss"));
			Set<PlanDetailNew> planDetailSet = null;
			PlanDetailNew planDetailNew = null;
			String planMainId = null;
			double premiumCount = 0;
			for (int i = 1; i <= map.size(); i++) {
				String str = map.get(i) + "0";
				if (!map.get(i).replace("`", "").trim().equals("")) {
					String[] props = str.split("`");
					String deptCodeStr = props[0];
					String deptCode = deptCodeStr.split("\\.")[0];
					String deptRiskTypeStr = props[1];
					String deptRiskType = "";
					if (deptRiskTypeStr.equals("车险")) {
						deptRiskType = "1";
					} else if (deptRiskTypeStr.equals("财险")) {
						deptRiskType = "2";
					} else if (deptRiskTypeStr.equals("人身险")) {
						deptRiskType = "3";
					}
					String lineName = props[2];
					String lineCode = getLineCodeByName(lineName);
					String planFee = props[3];
					String content = props[4];
					String remark = props[5];
					// 保存数据
					if(!deptName.equals(deptCodeStr)){
						planMainNew = new PlanMainNew();
						planMainId = UUIDGenerator.getUUID();
				    	planDetailSet = new HashSet<PlanDetailNew>(); 
				    	
				    	planMainNew.setPlanMainId(planMainId);
				    	planMainNew.setDeptCode(deptCode);
				    	planMainNew.setPlanType(planType);//销售计划
				    	planMainNew.setYear(Integer.valueOf(planYear));
				    	planMainNew.setQuarter("1");
				    	planMainNew.setPlanWriter("卢水发");
				    	planMainNew.setPlanWriteDate(curTime);
				    	//默认设置为未审核
				    	planMainNew.setApproveCode("0");
				    	planMainNew.setValidInd("1");
				    	planMainNew.setStatus("0");
				    	
				    	planMainNew.setCreatedDate(curTime);
				    	planMainNew.setCreatedUser(userName);
				    	planMainNew.setUpdatedDate(curTime);
				    	planMainNew.setUpdatedUser(userName);
						//增加明细子集
				    	planDetailSet = new HashSet<PlanDetailNew>();
				    	planDetailNew = new PlanDetailNew();
		    			planDetailNew.setPlanMainId(planMainId);
		    			planDetailNew.setPlanDeptId(UUIDGenerator.getUUID());
		    			planDetailNew.setDeptCode(deptCode);
		    			planDetailNew.setDeptRiskType(deptRiskType);
		    			planDetailNew.setLineCode(lineCode);
		    			planDetailNew.setPlanFee(Double.valueOf(planFee));
		    			planDetailNew.setContent(content);
		    			planDetailNew.setRemark(remark);
		    			
		    			planDetailNew.setValidInd("1");
		    			planDetailNew.setStatus("0");
		    	    	
		    			planDetailNew.setCreatedDate(curTime);
		    			planDetailNew.setCreatedUser(userName);
		    			planDetailNew.setUpdatedDate(curTime);
		    			planDetailNew.setUpdatedUser(userName);
		    			premiumCount=planDetailNew.getPlanFee();
		    			//添加到列表中
		    	    	planDetailSet.add(planDetailNew);
		    	    	Thread.sleep(50);
		    	    	//保存总数
		    	    	planMainNew.setDeptPremium(premiumCount);
		    	    	
						planMainList.add(planMainNew);
					}else{
						planDetailNew = new PlanDetailNew();
						//增加明细子集
		    			planDetailNew.setPlanMainId(planMainId);
		    			planDetailNew.setPlanDeptId(UUIDGenerator.getUUID());
		    			planDetailNew.setDeptCode(deptCode);
		    			planDetailNew.setDeptRiskType(deptRiskType);
		    			planDetailNew.setLineCode(lineCode);
		    			planDetailNew.setPlanFee(Double.valueOf(planFee));
		    			planDetailNew.setContent("无");
		    			planDetailNew.setRemark("无");
		    			
		    			planDetailNew.setValidInd("1");
		    			planDetailNew.setStatus("0");
		    	    	
		    			planDetailNew.setCreatedDate(curTime);
		    			planDetailNew.setCreatedUser(userName);
		    			planDetailNew.setUpdatedDate(curTime);
		    			planDetailNew.setUpdatedUser(userName);
		    			premiumCount+=planDetailNew.getPlanFee();
		    			//添加到列表中
		    	    	planDetailSet.add(planDetailNew);
		    	    	planMainNew.setDeptPremium(premiumCount);
		    	    	planMainNew.setPlanDetailSet(planDetailSet);
					}
					deptName = deptCodeStr;
				}
			}
			//循环保存
			for (PlanMainNew planMain2 : planMainList) {
				//保存之前先判断是否存在,存在则删除原有的，添加新的
				if(this.planMainService.isExist(planMain2.getDeptCode(),planMain2.getYear())){
					PlanMainNew curPlanMain = this.planMainService.selectByDeptYear(planMain2.getDeptCode(),planMain2.getYear());
				    String curPlanMainId = curPlanMain.getPlanMainId();
				    this.delPlanDetail(curPlanMainId);
					this.planMainService.delPlanMainById(curPlanMain.getPlanMainId());
				}
				this.savePlanWithDetail(planMain2);
			    Thread.sleep(20);
			}
			actionFlag = true;
		}catch(Exception e){
			e.printStackTrace();
			actionFlag = false;
		}
		return actionFlag;
	}
	
	/**
	 * 方法genDeptPlanDetailXls的详细说明: 生成销售保费计划模板文件<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月5日 上午10:31:57 </pre>
	 * @param savePath 保存路径
	 * @param deptCode 部门
	 * @return boolean  返回操作结果是否成功
	 */
	public boolean genDeptPlanDetailXls(String savePath,String deptCode){
	    ExcelWrite workBook  = new ExcelWrite();
	    List<String> rowList = new ArrayList<String>();
	    StringBuffer rowData = new StringBuffer();
	    rowData.append("机构`");
	    rowData.append("险种`");
	    rowData.append("业务线`");
	    rowData.append("保费(万元)`");
	    rowData.append("发展思路及举措`");
	    rowData.append("备注");
	    rowList.add(rowData.toString());
	    //如果是总公司则从常量中取二级机构列表
	    if(deptCode.equals("00")){
	    	JSONArray deptMapArray = Constant.getCombo("deptTwo");
	    	log.info("当前用户子机构数量："+deptMapArray.size());
	    	for (Object dept : deptMapArray) {
	    		JSONObject deptTwo = (JSONObject)dept;
	    		if(!deptTwo.get("value").toString().equals("")){
	    			setRowData(rowData,deptTwo.get("value")+"."+deptTwo.get("text").toString().substring(2),rowList);
	    		}
			}
	    }else{
	    	List<Map<String,Object>> deptMapList = this.departmentService.findDeptListByParentCode(deptCode);
	    	log.info("当前用户子机构数量："+deptMapList.size());
			for (Map<String, Object> map : deptMapList) {
		    	setRowData(rowData,map.get("departCode")+"."+map.get("text"),rowList);
			}
	    }
	    return workBook.createWorkBook(rowList,savePath);
	}

	/**
	 * 方法setRowData的详细说明: 设置行值<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月8日 上午8:59:22 </pre>
	 */
	private void setRowData(StringBuffer rowData,String deptStr,List<String> rowList) {
		String[] deptRiskType = {"车险","财险","人身险"};
		JSONArray lineCodeArray = Constant.getCombo("bizLine");
		for (int i = 0; i < deptRiskType.length; i++) {
			for (Object object : lineCodeArray) {
				JSONObject jo = (JSONObject)object;
				if(!jo.get("value").toString().equals("")){
					rowData = new StringBuffer();
					rowData.append(deptStr+"`");
					rowData.append(deptRiskType[i]+"`");
					rowData.append(jo.get("text")+"`");
					rowData.append("0`");
					rowData.append(" `");
					rowData.append(" `");
					rowList.add(rowData.toString());
				}
			}
		}
	}

	/**
	 * 详细说明:查询<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月3日 上午9:10:05 </pre>
	 * @param pageDto 分页对象
	 * @return PageDto
	 * @see com.sinosafe.xszc.planNew.service.SalePlanDetailService#findPlanDetailToPage(com.sinosafe.xszc.util.PageDto)
	 */
	@Override
	public PageDto findPlanDetailToPage(PageDto pageDto) {
		Long total = dao.selectOne(PLAN_DETAIL_NEW + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(PLAN_DETAIL_NEW + ".queryListPageInfoDept", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	/**
	 * 详细说明:分页查询计划及其明细<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月16日 下午3:03:28 </pre>
	 * @param 参数名 说明
	 * @return 返回值类型 说明
	 * @throws 异常类型 说明
	 * @see com.sinosafe.xszc.planNew.service.SalePlanDetailService#queryPlanWidthDetailToPage(com.sinosafe.xszc.util.PageDto)
	 */
	@Override
	public PageDto queryPlanWidthDetailToPage(PageDto pageDto) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			// 取主表的数据
			List<PlanMainNew> planInfoList = planMainService.queryAllPlanMain(pageDto);
			// 取子表的数据
			for (PlanMainNew planMain : planInfoList) {
				if(planMain.getDeptCode().contains("-")){
					planMain.setDeptCode(planMain.getDeptCode().substring(0, planMain.getDeptCode().indexOf("-")));
				}
				Department department = this.departmentService.findDepartmentVo(planMain.getDeptCode());
				String deptName = department.getDeptSimpleName();
				planMain.setDeptCode(deptName);
				Set<Map<String,Object>> set = new HashSet<Map<String,Object>>();
				List<Map<String,Object>> listDept = dao.selectList(PLAN_DETAIL_NEW + ".selectPlanDetailByPlanId", planMain.getPlanMainId());
				for (Map<String,Object> planDetailNew : listDept) {
					planDetailNew.put("lineCode", getLineNameByCode(planDetailNew.get("lineCode").toString()));
					set.add(planDetailNew);
				}
				//planMain.setPlanDetailMapSet(set);
				planMain.setPlanDetailMapList(listDept);
				Map<String, Object> map = ReflectMatch.convertBean(planMain);
				list.add(map);
			}
		} catch (IntrospectionException e) {
			log.debug(list);
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		pageDto.setRows(list);
		return pageDto;
	}
	
	public String getLineNameByCode(String code){
	     if(code.equals("")||code==null){
	    	 return "";
	     }	
		 JSONArray lineCodeArray = Constant.getCombo("bizLine");
		 for (Object o : lineCodeArray) {
			JSONObject jo = (JSONObject)o;
			if(jo.getString("value").equals(code)){
				return jo.getString("text");
			}
		 }
		return "";	
	}

	/**
	 * 覆盖方法queryPlanDetailToVo详细说明:查出计划明细<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月8日 上午10:38:02 </pre>
	 * @see com.sinosafe.xszc.planNew.service.SalePlanDetailService#queryPlanDetailToVo(com.sinosafe.xszc.planNew.vo.PlanMainNew)
	 */
	@Override
	public PlanMainNew queryPlanDetailToVo(PlanMainNew planInfo) {
		Set<PlanDetailNew> planDetailNewSet = new HashSet<PlanDetailNew>();
		PlanMainNew planInfos = planMainService.selectByPrimaryKey(planInfo);
		List<PlanDetailNew> list = dao.selectList(PLAN_DETAIL_NEW + ".selectPlanDetailByPlanIdVo", planInfos.getPlanMainId());
		for (PlanDetailNew planDetailNew : list) {
			planDetailNewSet.add(planDetailNew);
		}
		planInfos.setPlanDetailSet(planDetailNewSet);
		return planInfos;
	}
	
	
	/**
	 * 详细说明:查出计划信息通过planMainId<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月8日 下午3:14:05 </pre>
	 * @see com.sinosafe.xszc.planNew.service.SalePlanDetailService#querySalePlanByVo(java.lang.String)
	 */
	@Override
	public PlanMainNew querySalePlanByVo(String planMainId){
		PlanMainNew planInfo = new PlanMainNew();
		planInfo.setPlanMainId(planMainId);
		PlanMainNew planInfos = planMainService.selectByPrimaryKey(planInfo);
		return planInfos;
	}
	
	/**
	 * 覆盖方法queryPlanDetailToVo详细说明:通过计划Id得到明细列表<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月8日 上午10:38:02 </pre>
	 * @see com.sinosafe.xszc.planNew.service.SalePlanDetailService#queryPlanDetailToVo(com.sinosafe.xszc.planNew.vo.PlanMainNew)
	 */
	@Override
	public Set<PlanDetailNew> querySalePlanDetailListByPlanId(String planMainId) {
		Set<PlanDetailNew> planDetailNewSet = new HashSet<PlanDetailNew>();
		List<PlanDetailNew> list = dao.selectList(PLAN_DETAIL_NEW + ".selectPlanDetailByPlanIdVo",planMainId);
		for (PlanDetailNew planDetailNew : list) {
			planDetailNewSet.add(planDetailNew);
		}
		return planDetailNewSet;
	}

	@Override
	public void savePlanWithDetail(PlanMainNew planMain) {
		boolean flag = planMainService.saveOrUpdate(planMain);
		if (flag) {
			Set<PlanDetailNew> planDetailNew = planMain.getPlanDetailSet();
			Iterator<PlanDetailNew> it = planDetailNew.iterator();
			while (it.hasNext()) {
				PlanDetailNew spd = it.next();
				spd.setPlanMainId(planMain.getPlanMainId());
				spd.setValidInd("1");
				if (this.isExist(spd.getPlanDeptId())) {
					dao.update(PLAN_DETAIL_NEW + UPDATE_PK_VO, spd);
				} else {
					dao.insert(PLAN_DETAIL_NEW + INSERT_VO, spd);
				}
			}
		}
	}
	
	/**
	 * 详细说明:保存计划及其明细列表<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月10日 上午11:06:40 </pre>
	 * @param planMain 计划对象
	 * @param detailList 明细列表
	 * @return 返回值类型 说明
	 * @throws 异常类型 说明
	 * @see com.sinosafe.xszc.planNew.service.SalePlanDetailService#savePlanWithDetail(com.sinosafe.xszc.planNew.vo.PlanMainNew, java.util.List)
	 */
	@Override
	public void savePlanWithDetail(PlanMainNew planMain,List<PlanDetailNew> detailList) {
		boolean flag = planMainService.saveOrUpdate(planMain);
		if (flag) {
			Iterator<PlanDetailNew> it = detailList.iterator();
			while (it.hasNext()) {
				PlanDetailNew spd = it.next();
				spd.setPlanMainId(planMain.getPlanMainId());
				spd.setValidInd("1");
				if (this.isExist(spd.getPlanDeptId())) {
					dao.update(PLAN_DETAIL_NEW + UPDATE_PK_VO,spd);
				} else {
					dao.insert(PLAN_DETAIL_NEW + INSERT_VO,spd);
				}
			}
		}
	}

	/**
	 *
	 * TODO 覆盖方法delPlanDetail简单说明:将明细信息设置成无效的<br><pre>
	 * 覆盖方法delPlanDetail详细说明:<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月15日 下午4:09:57 </pre>
	 * @see com.sinosafe.xszc.planNew.service.SalePlanDetailService#delPlanDetail(java.lang.String)
	 */
	public void delPlanDetail(String planMainId) {
		this.planMainService.delPlanMainById(planMainId);
		Map<String,Object> whereMap = new HashMap<String,Object>();
		whereMap.put("validInd", "0");
		whereMap.put("planMainId", planMainId);
		dao.delete(PLAN_DETAIL_NEW + ".updateByPrimaryKeySelective", whereMap);
	}

	@Override
	public String updateStatus(Map<String, Object> formMap) {
		StringBuffer result = new StringBuffer("");
		formMap.put("userCode", "fengongsi@virtual.com.cn");// CurrentUser.getUser().getUserCode()
		List<Map<String, Object>> list = dao.selectList(PLAN_DETAIL_NEW + ".comparePlanMainNew", formMap);
		if (list.size() == 1 && list != null) {
			Map<String, Object> map = list.get(0);
			BigDecimal deptPremiuPro = (BigDecimal) map.get("deptPremiumPro");
			BigDecimal deptPremiumAll = (BigDecimal) map.get("deptPremiumAll");
			if (deptPremiuPro.doubleValue() > deptPremiumAll.doubleValue()) {
				result.append("中支机构保费之和应大于或等于该省分公司的保费，中支公司的保费为：" + deptPremiumAll + ";");
			}
			BigDecimal financePreminumPro = (BigDecimal) map.get("financePreminumPro");
			BigDecimal financePreminumAll = (BigDecimal) map.get("financePreminumAll");
			if (financePreminumPro.doubleValue() > financePreminumAll.doubleValue()) {
				result.append("中支机构金融报销保费之和应大于或等于该省分公司的金融报销保费，中支公司的金融报销保费为：" + financePreminumAll + ";");
			}
			BigDecimal iportantPremiumPro = (BigDecimal) map.get("iportantPremiumPro");
			BigDecimal iportantPremiumAll = (BigDecimal) map.get("iportantPremiumAll");
			if (iportantPremiumPro.doubleValue() > iportantPremiumAll.doubleValue()) {
				result.append("中支机构渠道重客保费之和应大于或等于该省分公司的渠道重客保费，中支公司的渠道重客保费为：" + iportantPremiumAll + ";");
			}
			BigDecimal normalPremiumPro = (BigDecimal) map.get("normalPremiumPro");
			BigDecimal normalPremiumAll = (BigDecimal) map.get("normalPremiumAll");
			if (normalPremiumPro.doubleValue() > normalPremiumAll.doubleValue()) {
				result.append("中支机构其他业务保费之和应大于或等于该省分公司的其他业务保费，中支公司的其他业务保费为：" + normalPremiumAll + ";");
			}
		}
		if (result.toString().equals("")) {
			result.append("审核通过");
			planMainService.updateStuts(formMap);
			dao.update(PLAN_DETAIL_NEW + ".updatePlanDetailNewStatus", formMap);
		}

		return result.toString();
	}

	@Override
	public long querySalePlanOneByDept(String deptCode, Integer year) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("deptCode", deptCode);
		map.put("year", String.valueOf(year));
		map.put("planType", "1");
		long count = planMainService.queryPlanOneByDept(map);
		return count;
	}
	
	private String getLineCodeByName(String lineName) {
		if(lineName.equals("")||lineName==null){
	    	 return "";
	     }	
		 JSONArray lineCodeArray = Constant.getCombo("bizLine");
		 for (Object o : lineCodeArray) {
			JSONObject jo = (JSONObject)o;
			if(jo.getString("text").equals(lineName)){
				return jo.getString("value");
			}
		 }
		return "";	
	}
	
	/**
	 * TODO 覆盖方法isExist简单说明:<br><pre>
	 * 覆盖方法isExist详细说明:查看表中是否存在某条计划明细,根据主键值<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月2日 下午4:59:28 </pre>
	 * @param planMainId主键
	 * @return 返回是否成功
	 * @see com.sinosafe.xszc.planNew.service.PlanMainService#isExist(java.lang.String)
	 */
	@Override
	public boolean isExist(String detailId) {
		long count = (Long)dao.selectOne(PLAN_DETAIL_NEW + ".countByPrimaryKey", detailId);
		return count>0;
	}
}
