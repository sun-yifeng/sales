package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_LAW_FACTOR_IMP_VALUE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.group.service.GroupMainService;
import com.sinosafe.xszc.group.service.SalesmanService;
import com.sinosafe.xszc.group.vo.GroupMain;
import com.sinosafe.xszc.group.vo.Salesman;
import com.sinosafe.xszc.law.service.LawDefineService;
import com.sinosafe.xszc.law.service.TLawFactorImpValueService;
import com.sinosafe.xszc.law.vo.LawDefine;
import com.sinosafe.xszc.law.vo.TLawFactorImpValue;
import com.sinosafe.xszc.law.vo.TLawRate;
import com.sinosafe.xszc.util.ExcelReader;
import com.sinosafe.xszc.util.ExcelWrite;
import com.sinosafe.xszc.util.PageDto;

public class TLawFactorImpValueServiceImpl implements TLawFactorImpValueService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier("SalesmanService")
	private SalesmanService salesmanService;

	@Autowired
	@Qualifier("LawDefineService")
	private LawDefineService lawDefineService;

	@Autowired
	@Qualifier("GroupMainService")
	private GroupMainService groupMainService;

	/**
	 * 生成导出模板<br>
	 * 编写者:卢水发 创建时间:2015年6月30日 上午11:29:37 </pre>
	 * 
	 * @see com.sinosafe.xszc.law.service.TLawFactorImpValueService#genTLawFactorImpValueXls(java.lang.String, java.lang.String)
	 */
	@Override
	public boolean genTLawFactorImpValueXls(Map<String, Object> paramMap) {
		try {
			String savePath = paramMap.get("savePath").toString();
			String calcMonth = paramMap.get("calcMonth").toString();
			String versionId = paramMap.get("versionId").toString();
			// 得到相应的管理办法
			LawDefine lawDefine = this.lawDefineService.getLawDefineByPkId(versionId);
			String deptCode = lawDefine.getDeptCode();
			Map<String, Object> whereMap = null;
			// 查出数值类型
			List<Map<String, Object>> lawDefineMapList = this.getLawDefineImpList("0", versionId);
			// 设置excel头部
			List<String> rowList = new ArrayList<String>();
			StringBuffer rowData = new StringBuffer();
			rowData.append("月份`");
			rowData.append("所属机构`");
			rowData.append("HRID`");
			rowData.append("姓名`");
			for (Map<String, Object> lawImpType : lawDefineMapList) {
				rowData.append(lawImpType.get("itemName") + "`");
			}
			rowList.add(rowData.toString());
			// 查出客户经理
			whereMap = new HashMap<String, Object>();
			whereMap.put("deptCode", deptCode);
			List<Map<String, Object>> salesmanMapList = this.salesmanService.querySalemanForLawImp(whereMap);
			for (Map<String, Object> saleMan : salesmanMapList) {
				rowData = new StringBuffer();
				rowData.append(calcMonth + "`");
				rowData.append(saleMan.get("deptName") + "`");
				rowData.append(saleMan.get("salesmanCode") + "`");
				rowData.append(saleMan.get("salesmanCname") + "`");
				// 查出数值类型
				for (Map<String, Object> lawImpType : lawDefineMapList) {
					rowData.append("0`");
				}
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
	@Override
	public boolean batchSaveDataInXls(Map<String, Object> paramMap) {
		try {
			String fileDiskPath = paramMap.get("fileDiskPath").toString();
			String versionId = paramMap.get("versionId").toString();
			IUserDetails curUserInfo = CurrentUser.getUser();
			String userName = curUserInfo.getUsername();
			// 对读取Excel表格内容测试
			InputStream is2 = new FileInputStream(fileDiskPath);
			ExcelReader excelReader = new ExcelReader();
			Map<Integer, String> map = excelReader.readExcelContent(is2);
			// 得出第一行的数据
			String[] firstRow = (map.get(1) + "0").split("`");
			String calcMonth = firstRow[0];
			// 查出数值类型
			List<Map<String, Object>> lawDefineMapList = this.getLawDefineImpList("0", versionId);
			String salemanCode = "";
			Salesman salesman = null;
			List<TLawFactorImpValue> tivList = new ArrayList<TLawFactorImpValue>();
			TLawFactorImpValue tiv = null;
			String curTime = DateUtil.dateToStr(new Date());
			for (int i = 1; i <= map.size(); i++) {
				String str = map.get(i) + "0";
				if (!map.get(i).replace("`", "").trim().equals("")) {
					String[] props = str.split("`");
					if (!salemanCode.equals(props[2])) {
						salemanCode = props[2];
						salesman = this.salesmanService.findSalesmanByPrimaryKey(salemanCode);
					}
					for (int j = 0; j < lawDefineMapList.size(); j++) {
						tiv = new TLawFactorImpValue();
						tiv.setImpType("1");// 客户经理
						tiv.setVersionId(versionId);
						tiv.setCalcMonth(calcMonth);
						tiv.setDeptCode(salesman.getDeptCode());
						tiv.setSalesmanCname(salesman.getSalesmanCname());
						tiv.setSalesmanCode(salesman.getSalesmanCode());
						tiv.setEmployCode(salesman.getEmployCode());

						tiv.setValidInd("1");
						tiv.setCreatedDate(curTime);
						tiv.setCreatedUser(userName);
						tiv.setUpdatedDate(curTime);
						tiv.setUpdatedUser(userName);
						// 月份-管理办法ID
						tiv.setCalcMonth(calcMonth);
						tiv.setVersionId(versionId);
						tiv.setPkId(UUIDGenerator.getUUID());
						Map<String, Object> lawDefine = lawDefineMapList.get(j);
						String indexName = lawDefine.get("itemName").toString();
						String indexCode = getIndexCode(lawDefineMapList, indexName);
						String indexValue = props[j + 4];
						tiv.setIndexCode(indexCode);
						tiv.setIndexName(indexName);
						tiv.setIndexValue(Double.valueOf(indexValue));
						tivList.add(tiv);
					}
				}
			}
			this.saveTivList(tivList);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	// 批量导入
	private void saveTivList(final List<TLawFactorImpValue> tivList) {
		Thread saveThread = new Thread() {
			@Override
			public void run() {
				for (TLawFactorImpValue tiv : tivList) {
					saveOrUpdateByWhere(tiv);
				}
			}
		};
		saveThread.start();
	}

	/**
	 * 详细说明:导出团队excel模板<br>
	 * 编写者:卢水发 创建时间:2015年7月6日 上午9:57:51 </pre>
	 * @see com.sinosafe.xszc.law.service.TLawFactorImpValueService#genGroupImpXls(java.lang.String, java.lang.String)
	 */
	public boolean genGroupImpXls(Map<String, Object> paramMap) {
		Map<String, Object> whereMap = null;
		try {
			String savePath = paramMap.get("savePath").toString();
			String calcMonth = paramMap.get("calcMonth").toString();
			String versionId = paramMap.get("versionId").toString();
			// 查出数值类型
			List<Map<String, Object>> lawDefineMapList = this.getLawDefineImpList("1", versionId);
			// 设置excel头部
			List<String> rowList = new ArrayList<String>();
			StringBuffer rowData = new StringBuffer();
			rowData.append("月份`");
			rowData.append("所属机构`");
			rowData.append("团队代码`");
			rowData.append("团队名称`");
			// 动态设置
			for (Map<String, Object> lawImpType : lawDefineMapList) {
				rowData.append(lawImpType.get("itemName") + "`");
			}
			rowList.add(rowData.toString());
			// 查出团队
			whereMap = new HashMap<String, Object>();
			whereMap.put("versionId",versionId);
			List<Map<String, Object>> groupMapList = this.groupMainService.queryGroupListForLawImp(whereMap);
			for (Map<String, Object> group : groupMapList) {
				rowData = new StringBuffer();
				rowData.append(calcMonth + "`");
				rowData.append(group.get("deptName") + "`");
				rowData.append(group.get("groupCode") + "`");
				rowData.append(group.get("groupName") + "`");
				// 查出数值类型
				for (Map<String, Object> lawImpType : lawDefineMapList) {
					rowData.append("0`");
				}
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
	 * 详细说明:从excel中导入数据<br>
	 * 编写者:卢水发 创建时间:2015年7月6日 上午9:57:51 </pre>
	 */
	public boolean batchSaveGroupDataInXls(Map<String, Object> paramMap) {
		try {
			String fileDiskPath = paramMap.get("fileDiskPath").toString();
			String versionId = paramMap.get("versionId").toString();
			IUserDetails curUserInfo = CurrentUser.getUser();
			String userName = curUserInfo.getUsername();
			// 对读取Excel表格内容测试
			InputStream is2 = new FileInputStream(fileDiskPath);
			ExcelReader excelReader = new ExcelReader();
			Map<Integer, String> map = excelReader.readExcelContent(is2);
			// 得出第一行的数据
			String[] firstRow = (map.get(1) + "0").split("`");
			String calcMonth = firstRow[0];
			// 查出数值类型
			List<Map<String, Object>> lawDefineMapList = this.getLawDefineImpList("1", versionId);
			String groupCode = "";
			GroupMain group = null;
			TLawFactorImpValue tiv = null;
			String curTime = DateUtil.dateToStr(new Date());
			//用于存储团队长
			Map<String,Object> groupLeader = new HashMap<String, Object>();
			List<TLawFactorImpValue> tivList = new ArrayList<TLawFactorImpValue>();
			for (int i = 1; i <= map.size(); i++) {
				String str = map.get(i) + "0";
				if (!map.get(i).replace("`", "").trim().equals("")) {
					String[] props = str.split("`");
					if (!groupCode.equals(props[2])) {
						groupCode = props[2];
						groupLeader = this.dao.selectOne(T_LAW_FACTOR_IMP_VALUE + ".queryGroupLeaderByGroupCode", groupCode);
						group = this.groupMainService.findGroupByPrimaryKey(groupCode);
					}
					for (int j = 0; j < lawDefineMapList.size(); j++) {
						tiv = new TLawFactorImpValue();
						tiv.setImpType("2");// 团队管理
						tiv.setDeptCode(group.getDeptCode());
						tiv.setGroupName(group.getGroupName());
						tiv.setGroupCode(group.getGroupCode());
						//保存团队长信息
						if(groupLeader!=null){
							tiv.setSalesmanCode(groupLeader.get("salesmanCode").toString());
							tiv.setSalesmanCname(groupLeader.get("salesmanCname").toString());
						}
						tiv.setValidInd("1");
						tiv.setCreatedDate(curTime);
						tiv.setCreatedUser(userName);
						tiv.setUpdatedDate(curTime);
						tiv.setUpdatedUser(userName);
						// 月份-管理办法ID
						tiv.setCalcMonth(calcMonth);
						tiv.setVersionId(versionId);
						tiv.setPkId(UUIDGenerator.getUUID());
						Map<String, Object> lawDefine = lawDefineMapList.get(j);
						String indexName = lawDefine.get("itemName").toString();
						String indexCode = getIndexCode(lawDefineMapList, indexName);
						String indexValue = props[j + 4];
						tiv.setIndexCode(indexCode);
						tiv.setIndexName(indexName);
						tiv.setIndexValue(Double.valueOf(indexValue));
						tivList.add(tiv);
					}
				}
			}
			this.saveTivList(tivList);
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	@Override
	public boolean batchSaveLawElectricPolicy(Map<String, Object> paramMap)throws Exception{
		String versionId = paramMap.get("versionId").toString();
		String username = CurrentUser.getUser().getUsername();
		Map<String,Object> parameterMap = null;
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> rows = dao.selectList(T_LAW_FACTOR_IMP_VALUE + ".queryLawDefineByVersionId", versionId);
		//删除（失效）历史数据
		dao.update(T_LAW_FACTOR_IMP_VALUE + ".deleteElectricPolicy",versionId);
		
		// 对读取Excel表格内容测试
		InputStream is2 = new FileInputStream(paramMap.get("fileDiskPath").toString());
		ExcelReader excelReader = new ExcelReader();
		Map<Integer, String> map = excelReader.readExcelContent(is2);
		for(String value:map.values()){
			parameterMap = new HashMap<String,Object>();
			parameterMap.put("versionId", versionId);
			parameterMap.put("validInd", "1");
			parameterMap.put("lineCode", rows.get(0).get("lineCode"));
			parameterMap.put("deptCode", rows.get(0).get("deptCode"));
			parameterMap.put("createdUser", username);
			parameterMap.put("updatedUser", username);
			//防止最后一个为NULL，分隔符失效
			String[] row = (value+"0").split("`");
			parameterMap.put("policyNumber",row[0]);
			parameterMap.put("insuredPerson",row[1]);
			parameterMap.put("businessEmployeeNumber",row[2]);
			parameterMap.put("businessName",row[3]);
			parameterMap.put("batchNumber",row[4]);
			list.add(parameterMap);
			
			if(list.size()%2000==0){
				try{
					dao.insert(T_LAW_FACTOR_IMP_VALUE + ".insertLawElectricPolicy", list);
					list.clear();
				}catch(Exception e){
					return false;
				}
			}
		}
		
		if(list.size()>0){
			try{
				dao.insert(T_LAW_FACTOR_IMP_VALUE + ".insertLawElectricPolicy", list);
			}catch(Exception e){
				return false;
			}
		}
		
		return true;
	}
	
	// 得到编码
	private String getIndexCode(List<Map<String, Object>> lawDefineMapList, String indexName) {
		for (Map<String, Object> lawDefine : lawDefineMapList) {
			if (indexName.equals(lawDefine.get("itemName"))) {
				return lawDefine.get("itemCode").toString();
			}
		}
		return "";
	}

	@Override
	public PageDto findTLawFactorImpValueToPage(PageDto pageDto) {
		try {
			String versionId = pageDto.getWhereMap().get("versionId").toString();
			Long total = dao.selectOne(T_LAW_FACTOR_IMP_VALUE + QUERY_COUNT, pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> list = dao.selectList(T_LAW_FACTOR_IMP_VALUE + ".queryListPage", pageDto.getWhereMap());
			String firstIndexCode = "";
			if (pageDto.getWhereMap().get("impType").equals("1")) {
				List<Map<String, Object>> lawDefineList = getLawDefineImpList("0", versionId);
				if (lawDefineList.size() > 0) {					
					firstIndexCode = lawDefineList.get(0).get("itemCode").toString();
				}
			} else if (pageDto.getWhereMap().get("impType").equals("2")) {
				List<Map<String, Object>> lawDefineList = getLawDefineImpList("1", versionId);
				if (lawDefineList.size() > 0) {
					firstIndexCode = lawDefineList.get(0).get("itemCode").toString();
				}
			}
			list = this.revertRowToColumn(list, firstIndexCode);
			pageDto.setRows(list);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}
	
	@Override
	public PageDto queryLawElectricPolicy(PageDto pageDto) {
		pageDto.setTotal(10000L);
		List<Map<String, Object>> list = dao.selectList(T_LAW_FACTOR_IMP_VALUE + ".queryElectricPolicyListPage", pageDto.getWhereMap());
		pageDto.setRows(list);
		return pageDto;
	}

	/**
	 * 简要说明:行转列，将相同的人员的不同数值类型放到列上面显示 <br>
	 * 
	 * <pre>
	 * 方法revertRowToColumn的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月2日 下午4:31:54
	 * </pre>
	 */
	public List<Map<String, Object>> revertRowToColumn(List<Map<String, Object>> alrList, String firstIndexCode) {
		List<Map<String, Object>> revertMapList = new ArrayList<Map<String, Object>>();
		Map<String, Object> revertMap = new HashMap<String, Object>();
		String salesmanCode = "";
		String groupCode = "";
		int count = 0;
		String impType = "";
		for (Map<String, Object> map : alrList) {
			if (map.get("impType").equals("1")) {
				impType = "1";
				if (!salesmanCode.equals(map.get("salesmanCode"))) {
					salesmanCode = map.get("salesmanCode").toString();
					if (count != 0) {
						revertMap.put(firstIndexCode, revertMap.get("indexValue"));
						revertMap.remove("indexValue");
						revertMapList.add(revertMap);
						revertMap = new HashMap<String, Object>();
					}
					revertMap.putAll(map);
					count = 0;
				} else {
					revertMap.put(map.get("indexCode").toString(), map.get("indexValue"));
				}
			} else if (map.get("impType").equals("2")) {
				impType = "2";
				if (!groupCode.equals(map.get("groupCode"))) {
					groupCode = map.get("groupCode").toString();
					if (count != 0) {
						revertMap.put(firstIndexCode, revertMap.get("indexValue"));
						revertMap.remove("indexValue");
						revertMapList.add(revertMap);
						revertMap = new HashMap<String, Object>();
					}
					revertMap.putAll(map);
					count = 0;
				} else {
					revertMap.put(map.get("indexCode").toString(), map.get("indexValue"));
				}
			}
			count++;
		}
		if (impType.equals("1")) {
			revertMap.put(firstIndexCode, revertMap.get("indexValue"));
		} else {
			revertMap.put(firstIndexCode, revertMap.get("indexValue"));
		}
		revertMap.remove("indexValue");
		revertMapList.add(revertMap);
		return revertMapList;
	}

	/**
	 * 说明:判断是否在在<br>
	 * 
	 * <pre>
	 * 覆盖方法isExist详细说明:<br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月2日 下午4:31:22
	 * </pre>
	 * 
	 * @see com.sinosafe.xszc.law.service.TLawFactorImpValueService#isExist(java.lang.String)
	 */
	@Override
	public boolean isExist(String pkId) {
		long count = (Long) dao.selectOne(T_LAW_FACTOR_IMP_VALUE + ".countByPrimaryKey", pkId);
		return count > 0;
	}

	/**
	 * 简要说明: 通过销售人员判断是否存在<br>
	 * 
	 * <pre>
	 * 方法isExistByWhere的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月2日 下午4:20:56
	 * </pre>
	 */
	public boolean isExistByWhere(Map<String, Object> whereMap) {
		long count = (Long) dao.selectOne(T_LAW_FACTOR_IMP_VALUE + ".queryCount", whereMap);
		return count > 0;
	}

	/**
	 * 说明:保存与修改 通过条件判断 存在性<br>
	 * 编写者:卢水发 创建时间:2015年7月2日 下午4:30:40 </pre>
	 * 
	 * @see com.sinosafe.xszc.law.service.TLawFactorImpValueService#saveOrUpdateByWhere(com.sinosafe.xszc.law.vo.TLawFactorImpValue)
	 */
	@Override
	public boolean saveOrUpdateByWhere(TLawFactorImpValue lfiv) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", lfiv.getVersionId());
		whereMap.put("calcMonth", lfiv.getCalcMonth());
		whereMap.put("impType", lfiv.getImpType());
		// 客户经理
		if (lfiv.getImpType().equals("1")) {
			whereMap.put("salesmanCode", lfiv.getSalesmanCode());
			whereMap.put("indexCode", lfiv.getIndexCode());
		}
		// 团队
		else if (lfiv.getImpType().equals("2")) {
			whereMap.put("groupCode", lfiv.getGroupCode());
			whereMap.put("indexCode", lfiv.getIndexCode());
		}
		whereMap.put("validInd", "1");
		boolean flag = false;
		// 判断数据库是否存在，存在作修改,不存在作添加
		if (this.isExistByWhere(whereMap)) {
			TLawFactorImpValue tiv = (TLawFactorImpValue) dao.selectOne(T_LAW_FACTOR_IMP_VALUE + ".queryVo", whereMap);
			lfiv.setPkId(tiv.getPkId());
			dao.update(T_LAW_FACTOR_IMP_VALUE + UPDATE_PK_VO, lfiv);
			flag = true;
		} else {
			lfiv.setPkId(lfiv.getPkId());
			dao.insert(T_LAW_FACTOR_IMP_VALUE + INSERT_VO, lfiv);
			flag = true;
		}
		return flag;
	}

	/**
	 * 简单说明:更新修改后的数值<br>
	 * 
	 * <pre>
	 * 编写者:卢水发
	 * 创建时间:2015年7月2日 下午7:25:38
	 * </pre>
	 * 
	 * @see com.sinosafe.xszc.law.service.TLawFactorImpValueService#updateChange(java.util.List)
	 */
	public boolean updateChange(JSONArray changeList, String itemType, String versionId) {
		try {
			// 查出数值类型
			List<Map<String, Object>> lawDefineMapList = this.getLawDefineImpList(itemType, versionId);
			for (Object o : changeList) {
				JSONObject jsonObject = (JSONObject) o;
				List<Map<String, Object>> updateList = columnToRow(jsonObject, lawDefineMapList);
				for (Map<String, Object> whereMap : updateList) {
					dao.update(T_LAW_FACTOR_IMP_VALUE + ".updateChangeRow", whereMap);
				}
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// 将列转行
	private List<Map<String, Object>> columnToRow(JSONObject jsonObject, List<Map<String, Object>> lawDefineMapList) {
		Set<Entry<String, Object>> dataSet = jsonObject.entrySet();
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
		Map<String, Object> rowMap = null;
		Iterator<Entry<String, Object>> it = dataSet.iterator();
		while (it.hasNext()) {
			Entry<String, Object> entry = it.next();
			for (Map<String, Object> lawDefine : lawDefineMapList) {
				if (lawDefine.get("itemType").equals("0")) {
					if (entry.getKey().equals(lawDefine.get("itemCode"))) {
						rowMap = new HashMap<String, Object>();
						rowMap.put("versionId", jsonObject.get("versionId"));
						rowMap.put("calcMonth", jsonObject.get("calcMonth"));
						rowMap.put("salesmanCode", jsonObject.get("salesmanCode"));
						rowMap.put("indexCode", entry.getKey());
						rowMap.put("indexValue", entry.getValue());
						rowMap.put("impType", 1);
						updateList.add(rowMap);
					}
				} else if (lawDefine.get("itemType").equals("1")) {
					if (entry.getKey().equals(lawDefine.get("itemCode"))) {
						rowMap = new HashMap<String, Object>();
						rowMap.put("versionId", jsonObject.get("versionId"));
						rowMap.put("calcMonth", jsonObject.get("calcMonth"));
						rowMap.put("groupCode", jsonObject.get("groupCode"));
						rowMap.put("indexCode", entry.getKey());
						rowMap.put("indexValue", entry.getValue());
						rowMap.put("impType", 2);
						updateList.add(rowMap);
					}
				}
			}
		}
		return updateList;
	}

	// 获取导入类型
	public List<Map<String, Object>> getLawDefineImpList(String itemType, String versionId) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("itemType", itemType);
		whereMap.put("versionId", versionId);
		List<Map<String, Object>> lawDefineMapList = this.lawDefineService.queryImportList(whereMap);
		List<Map<String, Object>> lawDefineList = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> map : lawDefineMapList) {
			if(map.get("itemName")!=null&&!map.get("itemName").equals("")){
				lawDefineList.add(map);
			}
		}
		return lawDefineMapList;
	}

	// 查询管理办法
	public List<Map<String, Object>> getBFLawDefineList(String deptCode) {
		return this.lawDefineService.queryLawDefineForSelect(deptCode);
	}

}
