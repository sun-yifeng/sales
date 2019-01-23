package com.sinosafe.xszc.law.service;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.alibaba.fastjson.JSONObject;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.group.service.GroupMainService;
import com.sinosafe.xszc.group.service.SalesmanService;
import com.sinosafe.xszc.group.vo.GroupMain;
import com.sinosafe.xszc.group.vo.Salesman;
import com.sinosafe.xszc.law.vo.LawDefine;
import com.sinosafe.xszc.law.vo.TLawFactorImpValue;
import com.sinosafe.xszc.util.ExcelReader;
import com.sinosafe.xszc.util.ExcelWrite;
import com.sinosafe.xszc.util.PageDto;

public class TLawFactorImpValueServiceTest {

	private TLawFactorImpValueService tLawFactorImpValueService;
	private SalesmanService salesmanService;
	private LawDefineService lawDefineService;
	private GroupMainService groupMainService;
	Map<String, Object> whereMap = new HashMap<String, Object>();
	PageDto pageDto = new PageDto();
	CommonDao dao = null;

	@Before
	public void setUp() throws Exception {
		ApplicationContext app = new ClassPathXmlApplicationContext(
				"com/sinosafe/xszc/planNew/service/test-applicationContext.xml");
		dao = (CommonDao) app.getBean("baseDao");
		salesmanService = (SalesmanService) app.getBean("SalesmanService");
		groupMainService = (GroupMainService) app.getBean("GroupMainService");
		lawDefineService = (LawDefineService) app.getBean("LawDefineService");
		tLawFactorImpValueService = (TLawFactorImpValueService) app.getBean("TLawFactorImpValueService");
		// 初始查询条件
		// whereMap.put("deptCode", "00");
		whereMap.put("year", "2015");
		whereMap.put("validInd", "1");
		whereMap.put("planType", "1");
		whereMap.put("startpoint", "1");
		whereMap.put("endpoint", "20");
		// 以下为设置条件
		// {deptCode=00, year=2015, validInd=1, planType=1, startpoint=1,
		// endpoint=10}
		pageDto.setWhereMap(whereMap);
		pageDto.setStart("1");
		pageDto.setLimit("20");
	}

	/**
	 * 简要说明: 行导出模板<br><pre>
	 * 方法testGenTLawFactorImpValueXls的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月3日 上午8:37:06 </pre>
	 */
	//@Test
	public void testGenTLawFactorImpValueXls() {
		// 设置excel头部
		List<String> rowList = new ArrayList<String>();
		StringBuffer rowData = new StringBuffer();
		rowData.append("识别码`");
		rowData.append("二级机构`");
		rowData.append("三级机构`");
		rowData.append("四级单位`");
		rowData.append("姓名`");
		rowData.append("数值类型`");
		rowData.append("数值`");
		rowList.add(rowData.toString());
		// 查出数值类型
		whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", "1");
		whereMap.put("itemType", "0");
		List<Map<String, Object>> lawDefineMapList = this.lawDefineService.queryImportList(whereMap);
		// 查出客户经理
		whereMap = new HashMap<String, Object>();
		whereMap.put("deptCode", "01");
		List<Map<String, Object>> salesmanMapList = this.salesmanService
				.querySaleManList(whereMap);
		this.salesmanService.getMultiDeptInfo(salesmanMapList);
		for (Map<String, Object> saleMan : salesmanMapList) {
			System.out.println(saleMan.get("deptNameTwo") + ":"
					+ saleMan.get("salesmanCname"));
			// 查出数值类型
			for (Map<String, Object> lawDefine : lawDefineMapList) {
				rowData = new StringBuffer();
				rowData.append(saleMan.get("salesmanCode") + "`");
				rowData.append(saleMan.get("deptNameTwo") + "`");
				rowData.append(saleMan.get("deptNameThree") + "`");
				rowData.append(saleMan.get("deptNameFour") + "`");
				rowData.append(saleMan.get("salesmanCname") + "`");
				System.out.println(saleMan.get("salesmanCname"));
				rowData.append(lawDefine.get("itemName") + "`");
				rowData.append("0`");
				rowList.add(rowData.toString());
			}
		}
		ExcelWrite workBook = new ExcelWrite();
		boolean createFlag = workBook.createWorkBook(rowList,
				"d://salesman_law.xls");
		System.out.println("创建Excel的状态：" + createFlag);
	}
	
	/**
	 * 简要说明: 列导出模板<br><pre>
	 * 方法testGenTLawFactorImpValueXls的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月3日 上午8:37:06 </pre>
	 */
	//@Test
	public void testGenTLawFactorImpValueXlsToColumn() {
		// 查出数值类型
		whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", "1");
		whereMap.put("itemType", "0");
		List<Map<String, Object>> lawDefineMapList = this.lawDefineService.queryImportList(whereMap);
		// 设置excel头部
		List<String> rowList = new ArrayList<String>();
		StringBuffer rowData = new StringBuffer();
		rowData.append("识别码`");
		rowData.append("二级机构`");
		rowData.append("三级机构`");
		rowData.append("四级单位`");
		rowData.append("姓名`");
		for (Map<String, Object> lawDefine: lawDefineMapList) {
			rowData.append(lawDefine.get("itemName") + "`");
		}
		rowList.add(rowData.toString());
		// 查出客户经理
		whereMap = new HashMap<String, Object>();
		whereMap.put("deptCode", "01");
		List<Map<String, Object>> salesmanMapList = this.salesmanService.querySaleManList(whereMap);
		this.salesmanService.getMultiDeptInfo(salesmanMapList);
		for (Map<String, Object> saleMan : salesmanMapList) {
			System.out.println(saleMan.get("deptNameTwo") + ":"+ saleMan.get("salesmanCname"));
			rowData = new StringBuffer();
			rowData.append(saleMan.get("salesmanCode") + "`");
			rowData.append(saleMan.get("deptNameTwo") + "`");
			rowData.append(saleMan.get("deptNameThree") + "`");
			rowData.append(saleMan.get("deptNameFour") + "`");
			rowData.append(saleMan.get("salesmanCname") + "`");
			System.out.println(saleMan.get("salesmanCname"));
			// 查出数值类型
			for (Map<String, Object> lawDefine : lawDefineMapList) {
				rowData.append("0`");
			}
			rowList.add(rowData.toString());
		}
		ExcelWrite workBook = new ExcelWrite();
		boolean createFlag = workBook.createWorkBook(rowList,"d://salesman_law_column.xls");
		System.out.println("创建Excel的状态：" + createFlag);
	}

	/**
	 * 简要说明:查出数值类型<br>
	 * 方法getLawDefineList的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月30日 下午5:17:03
	 * </pre>
	 */
	@Test
	public void getLawDefineList() {
		whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", "1");
		whereMap.put("itemType", "0");
		List<Map<String, Object>> lawDefaineList = this.lawDefineService.queryImportList(whereMap);
		System.out.println(lawDefaineList);
		System.out.println(lawDefaineList.size());
	}

	//@Test
	public void testBatchSaveDataInXls() throws IOException {
		// 查出数值类型
		whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", "1");
		whereMap.put("itemType", "0");
		List<Map<String, Object>> lawDefineMapList = this.lawDefineService.queryImportList(whereMap);
		// 对读取Excel表格内容测试
		InputStream is2 = new FileInputStream("d://salesman_law_test.xls");
		ExcelReader excelReader = new ExcelReader();
		Map<Integer, String> map = excelReader.readExcelContent(is2);
		String salemanCode = "";
		Salesman salesman  =  null;
		TLawFactorImpValue tiv = null;
		String curTime = DateUtil.dateToStr(new Date());
		for (int i = 1; i <= map.size(); i++) {
			String str = map.get(i)+"0";
			if(!map.get(i).replace("`", "").trim().equals("")){
				tiv = new TLawFactorImpValue();
				String[] props = str.split("`");
				String indexName =  props[5];
				String indexCode =  getIndexCode(lawDefineMapList,indexName);
				String indexValue = props[6];
				if(!salemanCode.equals(props[0])){
					salemanCode = props[0];
					salesman =  this.salesmanService.findSalesmanByPrimaryKey(salemanCode);
					System.out.println(salesman.getSalesmanCname());
				}
				tiv.setPkId(UUIDGenerator.getUUID());
				tiv.setImpType("1");//客户经理
				tiv.setDeptCode(salesman.getDeptCode());
				tiv.setSalesmanCname(salesman.getSalesmanCname());
				tiv.setSalesmanCode(salesman.getSalesmanCode());

				tiv.setIndexCode(indexCode);
				tiv.setIndexName(indexName);
				tiv.setIndexValue(Double.valueOf(indexValue));
				String groupCode = salesman.getGroupCode().split("-")[0];
				String groupName = salesman.getGroupCode().split("-")[1];
				tiv.setGroupName(groupName);
				tiv.setGroupCode(groupCode);
				tiv.setEmployCode(salesman.getEmployCode());

				tiv.setValidInd("1");
				tiv.setCreatedDate(curTime);
				tiv.setCreatedUser("exlushuifa@virtual.com.cn");
				tiv.setUpdatedDate(curTime);
				tiv.setUpdatedUser("exlushuifa@virtual.com.cn");
				this.tLawFactorImpValueService.saveOrUpdateByWhere(tiv);
			}
		}
	}
	
	//第二种导入方式，行转列之后
	//@Test
	public void testBatchSaveDataInXlsByColumn() throws IOException, InterruptedException {
		// 查出数值类型
		whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", "1");
		whereMap.put("itemType", "0");
		List<Map<String, Object>> lawDefineMapList = this.lawDefineService.queryImportList(whereMap);
		// 对读取Excel表格内容测试
		InputStream is2 = new FileInputStream("d://salesman_law_column_test.xls");
		ExcelReader excelReader = new ExcelReader();
		Map<Integer, String> map = excelReader.readExcelContent(is2);
		String salemanCode = "";
		Salesman salesman  =  null;
		TLawFactorImpValue tiv = null;
		String curTime = DateUtil.dateToStr(new Date());
		for (int i = 1; i <= map.size(); i++) {
			String str = map.get(i)+"0";
			if(!map.get(i).replace("`", "").trim().equals("")){
				tiv = new TLawFactorImpValue();
				String[] props = str.split("`");
				if(!salemanCode.equals(props[0])){
					salemanCode = props[0];
					salesman =  this.salesmanService.findSalesmanByPrimaryKey(salemanCode);
					System.out.println(salesman.getSalesmanCname());
				}
				tiv.setImpType("1");//客户经理
				tiv.setDeptCode(salesman.getDeptCode());
				tiv.setSalesmanCname(salesman.getSalesmanCname());
				tiv.setSalesmanCode(salesman.getSalesmanCode());
				String groupCode = "";
				String groupName = "";
				try{
					groupCode = salesman.getGroupCode().split("-")[0];
					groupName = salesman.getGroupCode().split("-")[1];
				}catch(Exception e){
					groupCode = "";
					groupName = "";
				}
				tiv.setGroupName(groupName);
				tiv.setGroupCode(groupCode);
				tiv.setEmployCode(salesman.getEmployCode());

				tiv.setValidInd("1");
				tiv.setCreatedDate(curTime);
				tiv.setCreatedUser("exlushuifa@virtual.com.cn");
				tiv.setUpdatedDate(curTime);
				tiv.setUpdatedUser("exlushuifa@virtual.com.cn");
				for (int j = 0; j < lawDefineMapList.size(); j++) {
					tiv.setPkId(UUIDGenerator.getUUID());
					Map<String, Object> lawDefine = lawDefineMapList.get(j);
					String indexName  =  lawDefine.get("itemName").toString();
					String indexCode  =  getIndexCode(lawDefineMapList,indexName);
					String indexValue = props[j+5];
					tiv.setIndexCode(indexCode);
					tiv.setIndexName(indexName);
					tiv.setIndexValue(Double.valueOf(indexValue));
					this.tLawFactorImpValueService.saveOrUpdateByWhere(tiv);
				}
				Thread.sleep(50);
			}
		}
	}

	//得到编码
	private String getIndexCode(List<Map<String, Object>> lawDefineMapList,String indexName) {
		for (Map<String, Object> lawDefine : lawDefineMapList) {
			if(indexName.equals(lawDefine.get("itemName"))){
				return lawDefine.get("itemCode").toString();
			}
		}
		return "";
	}

	// 保存修改
	//@Test
	public void testSaveOrUpdate() {
		String curTime = DateUtil.dateToStr(new Date());
		TLawFactorImpValue tiv = new TLawFactorImpValue();
		tiv.setPkId(UUIDGenerator.getUUID());
		tiv.setImpType("1");
		tiv.setDeptCode("01564");
		tiv.setSalesmanCname("测试用户");
		tiv.setSalesmanCode("0000");

		tiv.setIndexCode("2222");
		tiv.setIndexName("xxx达成率");
		tiv.setIndexValue(0);

		tiv.setGroupName("模拟团队");
		tiv.setGroupCode("5644613");
		tiv.setEmployCode("665465");

		tiv.setValidInd("1");
		tiv.setCreatedDate(curTime);
		tiv.setCreatedUser("exlushuifa@virtual.com.cn");
		tiv.setUpdatedDate(curTime);
		tiv.setUpdatedUser("exlushuifa@virtual.com.cn");
		this.tLawFactorImpValueService.saveOrUpdateByWhere(tiv);
	}

	//@Test
	public void testFindTLawFactorImpValueToPage() {
        List<Map<String,Object>> mapList = this.tLawFactorImpValueService.findTLawFactorImpValueToPage(pageDto).getRows();
	    System.out.println("转换前：========="+mapList.size()+"=================================");
        for (Map<String, Object> map : mapList) {
        	System.out.println(map.get("salesmanCode")+":"+map.size());
			//System.out.println(JSONObject.toJSON(map).toString());
		}
        System.out.println("转换后：==========================================");
        List<Map<String,Object>> revertMapList = this.revertRowToColumn(mapList);
        
        for (Map<String, Object> map : revertMapList) {
        	System.out.println(map.get("salesmanCode")+":"+JSONObject.toJSON(map).toString());
		}
        System.out.println("转换后长度："+revertMapList.size());
	}
	
	public List<Map<String,Object>> revertRowToColumn(List<Map<String,Object>> alrList){
		List<Map<String, Object>> revertMapList = new ArrayList<Map<String, Object>>();
		Map<String, Object> revertMap = new HashMap<String, Object>();
		String salesmanCode = "";
		int count = 0;
		for (Map<String, Object> map : alrList) {
			if (!salesmanCode.equals(map.get("salesmanCode"))) {
				salesmanCode = map.get("salesmanCode").toString();
				if (count != 0) {
					revertMap.put("E_001", revertMap.get("indexValue"));
					revertMap.remove("indexValue");
					revertMapList.add(revertMap);
					revertMap = new HashMap<String, Object>();
				}
				revertMap.putAll(map);
			} else {
				revertMap.put(map.get("indexCode").toString(),
						map.get("indexValue"));
			}
			count++;
		}
		revertMap.put("E_001", revertMap.get("indexValue"));
		revertMap.remove("indexValue");
		revertMapList.add(revertMap);
		return revertMapList;
	}
	
	//==============================================团队相关操作==================================================================
	
	/**
	 * 简要说明: 团队列导出模板<br><pre>
	 * 方法testGenTLawFactorImpValueXls的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年7月3日 上午8:37:06 </pre>
	 */
	//@Test
	public void testGenGroupXlsToColumn() {
		// 查出数值类型
		whereMap = new HashMap<String, Object>();
		whereMap.put("versionId", "1");
		whereMap.put("itemType", "1");
		List<Map<String, Object>> lawDefineMapList = this.lawDefineService.queryImportList(whereMap);
		// 设置excel头部
		List<String> rowList = new ArrayList<String>();
		StringBuffer rowData = new StringBuffer();
		rowData.append("识别码`");
		rowData.append("二级机构`");
		rowData.append("三级机构`");
		rowData.append("四级单位`");
		rowData.append("团队名称`");
		//动态设置
		for (Map<String, Object> lawDefine: lawDefineMapList) {
			rowData.append(lawDefine.get("itemName") + "`");
		}
		rowList.add(rowData.toString());
		// 查出团队
		whereMap = new HashMap<String, Object>();
		whereMap.put("deptCode", "01");
		List<Map<String, Object>> groupMapList = this.groupMainService.queryGroupListForLawImp(whereMap);
		this.salesmanService.getMultiDeptInfo(groupMapList);
		for (Map<String, Object> group : groupMapList) {
			System.out.println(group.get("deptNameTwo") + ":"+ group.get("groupName"));
			rowData = new StringBuffer();
			rowData.append(group.get("groupCode") + "`");
			rowData.append(group.get("deptNameTwo") + "`");
			rowData.append(group.get("deptNameThree") + "`");
			rowData.append(group.get("deptNameFour") + "`");
			rowData.append(group.get("groupName") + "`");
			// 查出数值类型
			for (Map<String, Object> lawDefine : lawDefineMapList) {
				rowData.append("0`");
			}
			rowList.add(rowData.toString());
		}
		ExcelWrite workBook = new ExcelWrite();
		boolean createFlag = workBook.createWorkBook(rowList,"d://group_law_column.xls");
		System.out.println("创建Excel的状态：" + createFlag);
	}
	
	//第二种导入方式，行转列之后
		//@Test
		public void testBatchGroupByColumn() throws IOException, InterruptedException {
			// 查出数值类型
			whereMap = new HashMap<String, Object>();
			whereMap.put("versionId", "1");
			whereMap.put("itemType", "1");
			List<Map<String, Object>> lawDefineMapList = this.lawDefineService.queryImportList(whereMap);
			// 对读取Excel表格内容测试
			InputStream is2 = new FileInputStream("d://group_law_column_test.xls");
			ExcelReader excelReader = new ExcelReader();
			Map<Integer, String> map = excelReader.readExcelContent(is2);
			String groupCode = "";
			GroupMain group  =  null;
			TLawFactorImpValue tiv = null;
			String curTime = DateUtil.dateToStr(new Date());
			for (int i = 1; i <= map.size(); i++) {
				String str = map.get(i)+"0";
				if(!map.get(i).replace("`", "").trim().equals("")){
					tiv = new TLawFactorImpValue();
					String[] props = str.split("`");
					if(!groupCode.equals(props[0])){
						groupCode = props[0];
						group =  this.groupMainService.findGroupByPrimaryKey(groupCode);
						System.out.println(group.getGroupName());
					}
					tiv.setImpType("2");//团队管理
					tiv.setDeptCode(group.getDeptCode());
					tiv.setGroupName(group.getGroupName());
					tiv.setGroupCode(group.getGroupCode());

					tiv.setValidInd("1");
					tiv.setCreatedDate(curTime);
					tiv.setCreatedUser("exlushuifa@virtual.com.cn");
					tiv.setUpdatedDate(curTime);
					tiv.setUpdatedUser("exlushuifa@virtual.com.cn");
					for (int j = 0; j < lawDefineMapList.size(); j++) {
						tiv.setPkId(UUIDGenerator.getUUID());
						Map<String, Object> lawDefine = lawDefineMapList.get(j);
						String indexName  =  lawDefine.get("itemName").toString();
						String indexCode  =  getIndexCode(lawDefineMapList,indexName);
						String indexValue = props[j+5];
						tiv.setIndexCode(indexCode);
						tiv.setIndexName(indexName);
						tiv.setIndexValue(Double.valueOf(indexValue));
						this.tLawFactorImpValueService.saveOrUpdateByWhere(tiv);
					}
					Thread.sleep(50);
				}
			}
		}

	//@Test
	public void testHebingCell() throws IOException {
		POIFSFileSystem fs;
		HSSFWorkbook wb = null;
		HSSFSheet sheet;
		HSSFRow row;
		InputStream is = new FileInputStream("d://salesman_law.xls");
		Map<Integer, String> content = new HashMap<Integer, String>();
		String str = "";
		try {
			fs = new POIFSFileSystem(is);
			wb = new HSSFWorkbook(fs);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			is.close();
		}
		sheet = wb.getSheetAt(0);
		// 得到总行数
		int rowNum = sheet.getLastRowNum();
		row = sheet.getRow(0);
		int colNum = row.getPhysicalNumberOfCells();
		for (int i = 0; i < colNum; i++) {
			for (int j = 0; j < rowNum; j++) {
				row.getCell(j).getStringCellValue();
			}
		}
		// 正文内容应该从第二行开始,第一行为表头的标题
		/*
		 * for (int i = 1; i <= rowNum; i++) { row = sheet.getRow(i); int j = 0;
		 * while (j < colNum) {
		 * } content.put(i, str); str = ""; }
		 * 
		 */
	}
	
	//查询基本法
	//@Test
	public void getLawDefine(){
		Map<String,Object> lawDefine = this.lawDefineService.getLawDefineByDeptCode("01","925007");
		System.out.println(lawDefine.get("versionId"));
	}
	
	// 查询基本法
	@Test
	public void getLawDefineByPkId() {
		LawDefine lawDefine = this.lawDefineService.getLawDefineByPkId("1A0B7605C30427A4E0530C6C010A7E76");
		System.out.println(lawDefine.getVersionCname());
	}
}