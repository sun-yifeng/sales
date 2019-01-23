package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_LAW_RATE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_LAW_RULE_CONFIG;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.constant.Constant;
import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.department.vo.Department;
import com.sinosafe.xszc.law.service.LawDefineService;
import com.sinosafe.xszc.law.service.LawRateService;
import com.sinosafe.xszc.law.vo.LawDefine;
import com.sinosafe.xszc.law.vo.TLawRate;
import com.sinosafe.xszc.law.vo.TLawRuleConfig;
import com.sinosafe.xszc.util.ExcelReader;
import com.sinosafe.xszc.util.ExcelWrite;
import com.sinosafe.xszc.util.PageDto;

public class LawRateServiceImpl implements LawRateService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier("LawDefineService")
	private LawDefineService lawDefineService;
	
	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;

	// =====================导入 导出 编辑 新功能=开始==============================
	// 更新修改
	public boolean updateChange(List<TLawRate> LawRateList, String rateType, String versionId) {
		try {
			for (TLawRate lawRate : LawRateList) {
				lawRate.setRateType(rateType);
				lawRate.setVersionId(versionId);
				this.saveOrUpdateByWhere(lawRate);
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * 生成险种模板 编写者:卢水发 创建时间:2015年7月10日 上午11:08:55
	 * </pre>
	 * 
	 * @see com.sinosafe.xszc.law.service.LawRateService#genRateSafeTypeModelXls(java.util.Map)
	 */
	public boolean genRateSafeTypeModelXls(Map<String, Object> paramMap) {
		try {
			String savePath = paramMap.get("savePath").toString();
			// 设置excel头部
			List<String> rowList = new ArrayList<String>();
			StringBuffer rowData = new StringBuffer();
			rowData.append("险种编码`");
			rowData.append("险种名称`");
			rowData.append("系数值`");
			rowList.add(rowData.toString());
			// 查出险种类型
			List<Map<String, Object>> safeTypeList = this.dao.selectList(T_LAW_RATE + ".querySafeType", paramMap);
			for (Map<String, Object> safeType : safeTypeList) {
				rowData = new StringBuffer();
				rowData.append(safeType.get("safeCode") + "`");
				rowData.append(safeType.get("safeName") + "`");
				rowData.append(safeType.get("safeRate") + "`");
				rowList.add(rowData.toString());
			}
			ExcelWrite workBook = new ExcelWrite();
			boolean createFlag = workBook.createWorkBook(rowList, savePath);
			return createFlag;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * 生成渠道模板 编写者:卢水发 创建时间:2015年7月10日 上午11:08:55
	 * </pre>
	 * 
	 * @see com.sinosafe.xszc.law.service.LawRateService#genRateSafeTypeModelXls(java.util.Map)
	 */
	public boolean genRateChannelModelXls(Map<String, Object> paramMap) {
		try {
			String savePath = paramMap.get("savePath").toString();
			String versionId = paramMap.get("versionId").toString();
			// 得到相应的管理办法
			LawDefine lawDefine = this.lawDefineService.getLawDefineByPkId(versionId);
			String deptCode = lawDefine.getDeptCode();
			// 设置excel头部
			List<String> rowList = new ArrayList<String>();
			StringBuffer rowData = new StringBuffer();
			rowData.append("渠道编码`");
			rowData.append("渠道名称`");
			rowData.append("系数值`");
			rowList.add(rowData.toString());
			// 查出险种类型
			Map<String, String> whereMap = new HashMap<String, String>();
			whereMap.put("deptCode", deptCode);
			List<Map<String, Object>> channelList = this.dao.selectList(T_LAW_RATE + ".queryRateChannel", whereMap);
			for (Map<String, Object> channel : channelList) {
				rowData = new StringBuffer();
				rowData.append(channel.get("channelCode") + "`");
				rowData.append(channel.get("channelName") + "`");
				rowData.append(channel.get("channelRate") + "`");
				rowList.add(rowData.toString());
			}
			ExcelWrite workBook = new ExcelWrite();
			boolean createFlag = workBook.createWorkBook(rowList, savePath);
			return createFlag;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// 批量导入数据
	public boolean batchSaveLawRateDataInXls(Map<String, Object> paramMap) {
		try {
			String fileDiskPath = paramMap.get("fileDiskPath").toString();
			String versionId = paramMap.get("versionId").toString();
			String rateType = paramMap.get("rateType").toString();
			IUserDetails curUserInfo = CurrentUser.getUser();
			String userName = curUserInfo.getUsername();
			// 对读取Excel表格内容测试
			InputStream is2 = new FileInputStream(fileDiskPath);
			ExcelReader excelReader = new ExcelReader();
			Map<Integer, String> map = excelReader.readExcelContent(is2);
			List<TLawRate> lawRateList = new ArrayList<TLawRate>();
			TLawRate law = null;
			String curTime = DateUtil.dateToStr(new Date());
			for (int i = 1; i <= map.size(); i++) {
				String str = map.get(i) + "0";
				if (!map.get(i).replace("`", "").trim().equals("")) {
					law = new TLawRate();
					String[] props = str.split("`");
					law.setCreatedDate(curTime);
					law.setCreatedUser(userName);
					law.setPkId(UUIDGenerator.getUUID());
					double rate = 0;
					try {
						rate = Double.valueOf(props[2]);
					} catch (Exception e) {
						rate = 0;
					}
					law.setRate(rate);
					law.setRateCode(props[0]);
//					if (rateType.equals("4")) {
//						String channelCode = props[0];
//						Map<String, Object> channelMap = this.dao.selectOne(T_LAW_RATE + ".queryRateChannelByCode", channelCode);
//						String processDeptCode = channelMap.get("processDeptCode") != null ? channelMap.get("processDeptCode").toString() : "";
//						String processUserCode = channelMap.get("processUserCode") != null ? channelMap.get("processUserCode").toString() : "";
//						law.setProcessDeptCode(processDeptCode);
//						law.setProcessUserCode(processUserCode);
//					}
					law.setRateName(props[1]);
					law.setRateType(rateType);
					law.setRemark("");
					law.setUpdatedDate(curTime);
					law.setUpdatedUser(userName);
					law.setValidInd("1");
					law.setVersionId(versionId);
					if (rateType.equals("1")) {
						if (props[0].length() == 4) {
							lawRateList.add(law);
						}
					} else {
						lawRateList.add(law);
					}
				}
			}
			saveLawRateList(lawRateList);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// 批量导入
	private void saveLawRateList(final List<TLawRate> lawRateList) {
		for (TLawRate tLawRate : lawRateList) {
			saveOrUpdateByWhere(tLawRate);
		}
		/*
		 * Thread saveThread = new Thread(){
		 * 
		 * @Override public void run() { for (TLawRate tLawRate : lawRateList) { saveOrUpdateByWhere(tLawRate); } } }; saveThread.start();
		 */
	}

	/**
	 * 简要说明:通过条件 判断是否存在<br>
	 * 
	 * <pre>
	 * 方法isExistByWhere的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月2日 下午4:20:56
	 * </pre>
	 */
	public boolean isExistByWhere(Map<String, Object> whereMap) {
		long count = (Long) dao.selectOne(T_LAW_RATE + ".queryCount", whereMap);
		return count > 0;
	}

	/**
	 * 说明:保存与修改 通过条件判断 存在性<br>
	 * 编写者:卢水发 创建时间:2015年7月2日 下午4:30:40
	 * </pre>
	 * 
	 * @see com.sinosafe.xszc.law.service.TLawFactorImpValueService#saveOrUpdateByWhere(com.sinosafe.xszc.law.vo.TLawFactorImpValue)
	 */
	@Override
	public boolean saveOrUpdateByWhere(TLawRate lawRate) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", lawRate.getVersionId());
		whereMap.put("rateType", lawRate.getRateType());
		whereMap.put("rateCode", lawRate.getRateCode());
		whereMap.put("validInd", "1");
		boolean flag = false;
		// 判断数据库是否存在，存在作修改,不存在作添加
		if (this.isExistByWhere(whereMap)) {
			TLawRate law = (TLawRate) dao.selectOne(T_LAW_RATE + ".queryVo", whereMap);
			lawRate.setPkId(law.getPkId());
			dao.update(T_LAW_RATE + UPDATE_PK_VO, lawRate);
			flag = true;
		} else {
			lawRate.setPkId(lawRate.getPkId());
			dao.insert(T_LAW_RATE + INSERT_VO, lawRate);
			flag = true;
		}
		return flag;
	}

	// =====================导入 导出 编辑 新功能=结束==============================
	/**
	 * 不分页
	 */
	@Override
	public PageDto queryRateList(Map<String, Object> whereMap) {
		PageDto pageDto = new PageDto();
		List<Map<String, Object>> rows = dao.selectList(T_LAW_RATE + ".queryRateList", whereMap);
		pageDto.setRows(rows);
		return pageDto;
	}
	
	/**
	 * 不分页
	 */
	@Override
	public PageDto queryAreaRateList(Map<String, Object> whereMap) {
		PageDto pageDto = new PageDto();
		List<Map<String, Object>> rows = dao.selectList(T_LAW_RATE + ".queryAreaRateList", whereMap);
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public List<Map<String, Object>> queryRateType() {
		List<Map<String, Object>> list = dao.selectList(T_LAW_RATE + ".queryRateType", null);
		return list;
	}

	@Override
	public List<Map<String, Object>> queryRateCol(String rateType) {
		HashMap<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("rateType", rateType);
		List<Map<String, Object>> list = dao.selectList(T_LAW_RATE + ".queryRateCol", whereMap);
		return list;
	}

	@Override
	public void updateLawRate(String pkId, String rate) {
		HashMap<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("pkId", pkId);
		whereMap.put("rate", rate);
		dao.update(T_LAW_RATE + ".updateLawRateById", whereMap);
	}

	// 得到业务线系数默认输入模板
	@Override
	public List<Map<String, Object>> getDefaultInputModel(Map<String, Object> whereMap) {
		String userName = "";
		List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
		JSONArray lineCodeArray = Constant.getCombo("bizLine");
		Map<String, Object> map = null;
		String curTime = DateUtil.dateToStr(new Date());
		for (Object object : lineCodeArray) {
			map = new HashMap<String, Object>();
			JSONObject jo = (JSONObject) object;
			if (jo.get("value") != null && !jo.get("value").toString().equals("")) {
				String rateName = jo.get("text").toString();
				String rateCode = jo.get("value").toString();
				map.put("versionId", whereMap.get("versionId"));
				map.put("rateType", "2");
				map.put("rateName", rateName);
				map.put("rateCode", rateCode);
				map.put("rate", 1);
				map.put("createdDate", curTime);
				map.put("updatedDate", curTime);
				map.put("createdUser", userName);
				map.put("updatedUser", userName);
				map.put("pkId", UUIDGenerator.getUUID());
				map.put("validInd", "1");
				rows.add(map);
			}
		}
		saveList(rows);
		return rows;
	}

	// 得到车型输入模板
	@Override
	public List<Map<String, Object>> getDefaultCarTypeInputModel(Map<String, Object> whereMap) {
		String userName = "";
		List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
		JSONArray lineCodeArray = Constant.getCombo("carType");
		Map<String, Object> map = null;
		String curTime = DateUtil.dateToStr(new Date());
		for (Object object : lineCodeArray) {
			map = new HashMap<String, Object>();
			JSONObject jo = (JSONObject) object;
			if (jo.get("value") != null && !jo.get("value").toString().equals("")) {
				String rateName = jo.get("text").toString();
				String rateCode = jo.get("value").toString();
				map.put("versionId", whereMap.get("versionId"));
				map.put("rateType", "3");
				map.put("rateName", rateName);
				map.put("rateCode", rateCode);
				map.put("rate", 1);
				map.put("createdDate", curTime);
				map.put("updatedDate", curTime);
				map.put("createdUser", userName);
				map.put("updatedUser", userName);
				map.put("pkId", UUIDGenerator.getUUID());
				map.put("validInd", "1");
				rows.add(map);
			}
		}
		saveList(rows);
		return rows;
	}

	@Override
	public void saveList(List<Map<String, Object>> rows) {
		TLawRate lawRate = null;
		for (Map<String, Object> map : rows) {
			lawRate = new TLawRate();
			lawRate.setPkId(map.get("pkId").toString());
			lawRate.setVersionId(map.get("versionId").toString());
			lawRate.setRateType(map.get("rateType").toString());
			lawRate.setRateCode(map.get("rateCode").toString());
			lawRate.setRateName(map.get("rateName").toString());
			lawRate.setRate(Double.valueOf(map.get("rate").toString()));
			lawRate.setValidInd(map.get("validInd").toString());
			lawRate.setCreatedUser(map.get("createdUser").toString());
			lawRate.setCreatedDate(map.get("createdDate").toString());
			lawRate.setUpdatedUser(map.get("updatedUser").toString());
			lawRate.setUpdatedDate(map.get("updatedDate").toString());
			this.saveOrUpdateByWhere(lawRate);
		}
	}

	/*
	 * 
	 * (non-Javadoc)
	 * 
	 * @see com.sinosafe.xszc.law.service.LawRateService#initRateData(java.util.List)
	 */
	public void initRateData(List<Map<String, Object>> rows) {
		for (Map<String, Object> lawDefine : rows) {
			String[] rateTypes = { "2", "3" };
			for (String rateType : rateTypes) {
				Map<String, Object> whereMap = new HashMap<String, Object>();
				whereMap.put("versionId", lawDefine.get("versionId"));
				whereMap.put("rateType", rateType);
				// 查询出该版本的基本法系数
				PageDto pageDto = queryRateList(whereMap);
				int rowLength = pageDto.getRows().size();
				if (rowLength == 0) {
					if (whereMap.get("rateType").equals("2")) {
						// 设置业务线系数默认输入模板
						this.getDefaultInputModel(whereMap);
					}
					if (whereMap.get("rateType").equals("3")) {
						// 设置车型
						this.getDefaultCarTypeInputModel(whereMap);
					}
				}
			}
		}
	}
	
	/**
	 * 修改基本法区域系数参数
	 */
	@Override
	public void saveAreaRateConfig(Map<String, Object> formMap) throws JsonParseException, JsonMappingException, IOException {
		String areaRateJsonStr = (String) formMap.get("areaRateJsonStr");
		String updateFlag = (String) formMap.get("updateFlag");
		int beginIndex = areaRateJsonStr.lastIndexOf("[");
		int endIndex = areaRateJsonStr.lastIndexOf("]");
		areaRateJsonStr = areaRateJsonStr.substring(beginIndex, endIndex+1);
		
		ObjectMapper objectMapper = new ObjectMapper();
		Department[] department = objectMapper.readValue(areaRateJsonStr, Department[].class);
		Set<Department> departments = new HashSet<Department>();
		for (int i = 0; i < department.length; i++) {
			departments.add(department[i]);
		}
		
		//修改department表中的区域系数
		if("1".equals(updateFlag)){
			for(Department dept : departments){
				String deptCode = dept.getDeptCode();
				if(deptCode != null && deptCode != ""){
					dept.setUpdatedUser(CurrentUser.getUser().getUserCode());
					departmentService.updateDepartment(dept);
				}
			}
		}
		
	}
	
	/**
	 * 修改基本法其他配置项参数
	 */
	@Override
	public void saveLawRuleConfig(Map<String, Object> formMap) throws JsonParseException, JsonMappingException, IOException {
		//如果配置表中有记录则修改数据，无记录则插入数据
		Long total = dao.selectOne(T_LAW_RULE_CONFIG+".selectCountByVersionId", formMap.get("versionId"));
		if(total > 0){
			dao.update(T_LAW_RULE_CONFIG + ".updateLawRuleConfig", formMap);
		}else{
			dao.insert(T_LAW_RULE_CONFIG+".insertLawRuleConfig",formMap);
		}
		
	}
	

	@Override
	public Map<String, Object> findLawRateConfigByVersionId(String versionId) {
		TLawRuleConfig lawRuleConfig  = dao.selectOne(T_LAW_RULE_CONFIG + ".selectAreaConfigByVersionId", versionId);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		if(lawRuleConfig != null){
			resultMap.put("salaryCalPinDu", lawRuleConfig.getSalaryCalPinDu());
			resultMap.put("levelCalPindu", lawRuleConfig.getLevelCalPindu());
			resultMap.put("clientManagerKaoHe", lawRuleConfig.getClientManagerKaoHe());
			resultMap.put("isWorkingAge",lawRuleConfig.getIsWorkingAge());
			resultMap.put("isArea", lawRuleConfig.getIsArea());
			resultMap.put("passCountMonth",lawRuleConfig.getPassCountMonth());
			if(lawRuleConfig.getWorkingAgeCalBegin() != null){
				resultMap.put("workingAgeCalBegin", new SimpleDateFormat("yyyy-MM-dd").format(lawRuleConfig.getWorkingAgeCalBegin()));
			}
			resultMap.put("salesDirectorBuTie", lawRuleConfig.getSalesDirectorBuTie());
			resultMap.put("tmpEmploySalaryRate", lawRuleConfig.getTmpEmploySalaryRate());
		}
		return resultMap;
	}

	@Override
	public void saveLawRulePermission(Map<String, Object> formMap) {
		Long total = dao.selectOne(T_LAW_RULE_CONFIG+".queryCountByVersionId", formMap.get("versionId"));
		if(total>0){
			dao.update(T_LAW_RULE_CONFIG + ".updateLawRulePermission", formMap);
		}else{
			dao.insert(T_LAW_RULE_CONFIG+".insertLawRulePermission",formMap);
		}
		
	}

	@Override
	public Map<String, Object> queryButtonStatus(String versionId) {
		TLawRuleConfig lawRuleConfig  = dao.selectOne(T_LAW_RULE_CONFIG + ".selectButtonStatus", versionId);
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		if(lawRuleConfig != null){
			resultMap.put("salesSysSwitch", lawRuleConfig.getSalesSysSwitch());
			resultMap.put("salesImpSwitch", lawRuleConfig.getSalesImpSwitch());
			resultMap.put("salesCheckSwitch", lawRuleConfig.getSalesCheckSwitch());
			resultMap.put("salesExpSwitch", lawRuleConfig.getSalesExpSwitch());
			resultMap.put("salesRegSwitch", lawRuleConfig.getSalesRegSwitch());
			resultMap.put("groupSysSwitch", lawRuleConfig.getGroupSysSwitch());
			resultMap.put("groupImpSwitch", lawRuleConfig.getGroupImpSwitch());
			resultMap.put("groupCheckSwitch", lawRuleConfig.getGroupCheckSwitch());
			resultMap.put("groupExpSwitch", lawRuleConfig.getGroupExpSwitch());
			resultMap.put("groupRegSwitch", lawRuleConfig.getGroupRegSwitch());
			resultMap.put("insuranceSwitch", lawRuleConfig.getInsuranceSwitch());
			resultMap.put("motorSwitch", lawRuleConfig.getMotorSwitch());
			resultMap.put("channelSwitch", lawRuleConfig.getChannelSwitch());
			resultMap.put("businessSwitch", lawRuleConfig.getBusinessSwitch());
			resultMap.put("areaSwitch", lawRuleConfig.getAreaSwitch());
		}
		return resultMap;
	}

	@Override
	public boolean queryFactorImp(Map<String, Object> paraMap) {
		long total = dao.selectOne(T_LAW_RULE_CONFIG + ".queryFactorImpCount", paraMap);
		if(total>0){
			return true;
		}
		return false;
	}
}
