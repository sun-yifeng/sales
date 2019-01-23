package com.sinosafe.xszc.planNew.service;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL_MAIL_RECORD;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.constant.Constant;
import com.sinosafe.xszc.planNew.vo.PlanDetailNew;
import com.sinosafe.xszc.planNew.vo.PlanMainNew;
import com.sinosafe.xszc.util.ExcelReader;
import com.sinosafe.xszc.util.ExcelWrite;
import com.sinosafe.xszc.util.PageDto;

public class SalePlanChannelServiceTest {

	private SalePlanDetailService salePlanDetailService;
	private PlanMainService planMainService;
	Map<String, Object> whereMap = new HashMap<String, Object>();
	PageDto pageDto = new PageDto();
	CommonDao dao = null;

	@Before
	public void setUp() throws Exception {
		ApplicationContext app = new ClassPathXmlApplicationContext("com/sinosafe/xszc/planNew/service/test-applicationContext.xml");
		dao = (CommonDao) app.getBean("baseDao");
		salePlanDetailService = (SalePlanDetailService) app.getBean("SalePlanDetailService");
		planMainService = (PlanMainService) app.getBean("PlanMainNewService");
		//初始查询条件
		//whereMap.put("deptCode", "00");
		whereMap.put("year", "2015");
		whereMap.put("validInd", "1");
		whereMap.put("planType", "1");
		whereMap.put("startpoint", "1");
		whereMap.put("endpoint", "10");
		//以下为设置条件
		//{deptCode=00, year=2015, validInd=1, planType=1, startpoint=1, endpoint=10}
		pageDto.setWhereMap(whereMap);
		pageDto.setStart("1");
		pageDto.setLimit("10");
	}
	
	@Test
	public void getMails(){
		List<Map<String, Object>> validRows = this.dao.selectList(CHANNEL_MAIL_RECORD + ".findValidRows", null);
		String mailString = "";
		for (Map<String, Object> rowObj : validRows) {
			//2、取出邮件
			Map<String, String> whereMap = new HashMap<String, String>();
			whereMap.put("deptCode",rowObj.get("DEPTCODE").toString());
			whereMap.put("businessLine", rowObj.get("LINECODE").toString());
			Map<String, String> mailMap = dao.selectOne(CHANNEL_MAIL_RECORD + ".getMails", whereMap);
			mailString+="部门ID:"+rowObj.get("DEPTCODE").toString()+",业务线ID:"+rowObj.get("LINECODE").toString()+"  "+mailMap.get("mails").toString()+"\r\n";
		}
		System.out.println(mailString);
	}
	
	/**
	 * TODO 方法isExistTest的简要说明 <br><pre>
	 * 方法isExistTest的详细说明: 查看是否存在<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月2日 下午5:09:58 </pre>
	 * @param 参数名 说明
	 * @return void 说明
	 * @throws 异常类型 说明
	 */
	//@Test
	public void isExistTest(){
		boolean flag = planMainService.isExist("00");
		System.out.println(flag);
	}
	
	/**
	 * 方法insertPlan的详细说明:测试添加销售计划 <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月2日 下午3:21:28 </pre>
	 * whereMap:{deptCode=00, year=2015, validInd=1, planType=1, startpoint=1, endpoint=10}
	 * 业务线查询地址：dataSource :"/xszc/common/queryBusinessLine.do",
	 * @param 参数名 说明
	 * @return void 说明
	 * @throws Exception 
	 * @throws 异常类型 说明
	 */
	//@Test
	public void insertPlan() throws Exception{
	    PlanMainNew planMainNew = null;
	    //String[] deptCodeArray = {"0103","00","01020000","01","06","0102","0404","0402","21"};
	    String[] deptCodeArray = {"00","00","00","00","00","00","00","00","00"};
	    String[] deptRiskType = {"1","2","3"};
	    JSONArray lineCodeArray = Constant.getCombo("bizLine");
	    for (int i = 0; i < deptCodeArray.length; i++) {
	    	Timestamp curTime =  Timestamp.valueOf(DateUtil.getSystemDateStr("yyyy-MM-dd hh:mm:ss"));
	    	String planMainId = UUIDGenerator.getUUID();
	    	planMainNew = new PlanMainNew();
	    	planMainNew.setPlanMainId(planMainId);
	    	planMainNew.setDeptCode(deptCodeArray[i]);
	    	planMainNew.setPlanType("1");//销售计划
	    	planMainNew.setYear(2015);
	    	planMainNew.setQuarter("2");
	    	planMainNew.setPlanWriter("卢水发");
	    	planMainNew.setPlanWriteDate(curTime);
	    	
	    	planMainNew.setValidInd("1");
	    	planMainNew.setStatus("0");
	    	
	    	planMainNew.setCreatedDate(curTime);
	    	planMainNew.setCreatedUser("exlushuifa@virtual.com.cn");
	    	planMainNew.setUpdatedDate(curTime);
	    	planMainNew.setUpdatedUser("exlushuifa@virtual.com.cn");
			//增加明细子集
	    	Set<PlanDetailNew> planDetailSet = new HashSet<PlanDetailNew>();
	    	PlanDetailNew planDetailNew = null;
	    	double premiumCount = 0.0;
	    	for (int j = 0; j < deptRiskType.length; j++) {
	    		for (Object o : lineCodeArray) {
	    			JSONObject jo = (JSONObject)o;
	    			if(jo.get("value")!=null&&!jo.get("value").toString().equals("")){
	    				planDetailNew = new PlanDetailNew();
		    			planDetailNew.setPlanMainId(planMainId);
		    			planDetailNew.setPlanDeptId(UUIDGenerator.getUUID());
		    			planDetailNew.setDeptCode(deptCodeArray[i]);
		    			planDetailNew.setDeptRiskType(deptRiskType[j]);
		    			planDetailNew.setLineCode(jo.get("value").toString());
		    			planDetailNew.setPlanFee(200+j);
		    			planDetailNew.setContent("无");
		    			planDetailNew.setRemark("无");
		    			
		    			planDetailNew.setValidInd("1");
		    			planDetailNew.setStatus("0");
		    	    	
		    			planDetailNew.setCreatedDate(curTime);
		    			planDetailNew.setCreatedUser("exlushuifa@virtual.com.cn");
		    			planDetailNew.setUpdatedDate(curTime);
		    			planDetailNew.setUpdatedUser("exlushuifa@virtual.com.cn");
		    			premiumCount+=planDetailNew.getPlanFee();
		    			//添加到列表中
		    	    	planDetailSet.add(planDetailNew);
		    	    	Thread.sleep(50);
	    			}
				}
			}
	    	planMainNew.setDeptPremium(premiumCount);
	    	planMainNew.setDeptUnderwritingPremium(0);
	    	planMainNew.setPlanDetailSet(planDetailSet);
	    	this.salePlanDetailService.savePlanWithDetail(planMainNew);
	    	System.out.println("添加["+deptCodeArray[i]+"]成功！");
		}
	}
	
	/**
	 * TODO 查询销售计划  <br><pre>
	 * 方法queryAllPlanMainListTest的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月1日 下午3:09:51 </pre>
	 */
	@Test
	public void queryAllPlanMainListTest(){
		List<PlanMainNew> planList = this.planMainService.queryAllPlanMain(pageDto);
		for (PlanMainNew planMainNew : planList) {
			System.out.println(planMainNew.getDeptCode()+":"+planMainNew.getDeptPremium());
		}
	}
	
	/**
	 * TODO 测试查询专属保费计划  <br><pre>
	 * 方法queryAllSalePlanChannelTest的详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月1日 下午3:09:51 </pre>
	 */
	//@Test
	public void queryPlanWithDetailTest(){
		System.out.println(salePlanDetailService);
		List<Map<String,Object>> mapList = this.salePlanDetailService.queryPlanWidthDetailToPage(pageDto).getRows();
	    for (Map<String, Object> map : mapList) {
			Set<Entry<String,Object>> entryList = map.entrySet();
			System.out.println("======================开始=========================");
			for (Entry<String, Object> entry:entryList) {
				if(entry.getKey().equals("planDetailMapSet")){
					Set<Map<String, Object>> planDetailSet =  (Set<Map<String, Object>>) entry.getValue();
					System.out.println(planDetailSet.size());
					for (int i = 1; i <=3; i++) {
						System.out.println("==========【"+i+"】=险种开始===========");
						for (Map<String,Object> planDetailNew : planDetailSet) {
							double planFee = Double.parseDouble(planDetailNew.get("planFee").toString());
							double sumv = Double.parseDouble(planDetailNew.get("SUMV").toString());
							double deptPremium = Double.parseDouble(map.get("deptPremium").toString());
							if(Integer.valueOf(planDetailNew.get("deptRiskType").toString())==i){
								 System.out.println("业务线："+planDetailNew.get("lineCode")
										 +"  保费(万元):"+planFee
										 +"  渠道业务占比(%):"+(planFee / sumv)*100+"%"
										 +"  车险保费(万元):"+sumv
										 +"  险种占比(%):"+(sumv /deptPremium)*100+"%"
										 );
							}
						}
						System.out.println("==========【"+i+"】=险种结束===========\r\n");
					}
				}
			}
			System.out.println("======================结束=========================");
		}
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
	
	//@Test
	public void genDeptPlanDetailListXls() throws FileNotFoundException, IOException{
			String[] deptRiskType = {"1.车险","2.财险","3.人身险"};
		    JSONArray lineCodeArray = Constant.getCombo("bizLine");
		    ExcelWrite workBook  = new ExcelWrite();
		    List<String> rowList = new ArrayList<String>();
		    StringBuffer rowData = new StringBuffer();
		    rowData.append("部门机构`");
		    rowData.append("险种`");
		    rowData.append("业务线`");
		    rowData.append("保费(万元)`");
		    rowData.append("发展思路及举措`");
		    rowData.append("备注");
		    rowList.add(rowData.toString());
		    for (int i = 0; i < deptRiskType.length; i++) {
				for (Object object : lineCodeArray) {
					JSONObject jo = (JSONObject)object;
					if(!jo.get("value").toString().equals("")){
						rowData = new StringBuffer();
						rowData.append("华南分部`");
						rowData.append(deptRiskType[i]+"`");
						rowData.append(jo.get("value")+"."+jo.get("text")+"`");
						rowData.append("0`");
						rowData.append(" `");
						rowData.append(" `");
						rowList.add(rowData.toString());
					}
				}
			}
			workBook.createWorkBook(rowList,"d://deptPlanDetail.xls");
	}
	
	/**
	 * 方法batchImpDataTest的详细说明: 批量导入<br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月5日 下午6:24:43 </pre>
	 * @throws Exception 
	 */
	//@Test
	public void batchImpDataTest() throws Exception{
		//对读取Excel表格内容测试
		InputStream is2 = new FileInputStream("D:/salePlanDeptDetailModel.xls");
		ExcelReader excelReader = new ExcelReader();
		//部门机构|险种|业务线|保费(万元)|发展思路及举措|备注
		String[] title = excelReader.readExcelTitle(is2);
		Map<Integer, String> map = excelReader.readExcelContent(is2);
		System.out.println("\n获得Excel表格的内容:");
		List<PlanMainNew> planMainList = new ArrayList<PlanMainNew>();
		PlanMainNew planMainNew = null;
		String deptName = "";
		Timestamp curTime =  Timestamp.valueOf(DateUtil.getSystemDateStr("yyyy-MM-dd hh:mm:ss"));
		Set<PlanDetailNew> planDetailSet = null;
		PlanDetailNew planDetailNew = null;
		String planMainId = null;
		double premiumCount = 0;
		for (int i = 1; i <= map.size(); i++) {
			String str = map.get(i)+"0";
			if(!map.get(i).replace("`", "").trim().equals("")){
				String[] props = str.split("`");
				String deptCodeStr = props[0];
				String deptCode = deptCodeStr.split("\\.")[0];
				String deptRiskTypeStr = props[1];
				String deptRiskType = "";
				if(deptRiskTypeStr.equals("车险")){
					deptRiskType = "1";
				}else if(deptRiskTypeStr.equals("财险")){
					deptRiskType = "2";
				}else if(deptRiskTypeStr.equals("人身险")){
					deptRiskType = "3";
				}
				String lineName = props[2];
				String lineCode = getLineCodeByName(lineName);
				String planFee = props[3];
				String content = props[4];
				String remark = props[5];
				//保存数据
				if(!deptName.equals(deptCodeStr)){
				//	System.out.println("======"+deptName+"======");
					planMainNew = new PlanMainNew();
					planMainId = UUIDGenerator.getUUID();
			    	planDetailSet = new HashSet<PlanDetailNew>(); 
			    	
			    	planMainNew.setPlanMainId(planMainId);
			    	planMainNew.setDeptCode(deptCode);
			    	planMainNew.setPlanType("1");//销售计划
			    	planMainNew.setYear(2015);
			    	planMainNew.setQuarter("2");
			    	planMainNew.setPlanWriter("卢水发");
			    	planMainNew.setPlanWriteDate(curTime);
			    	
			    	planMainNew.setValidInd("1");
			    	planMainNew.setStatus("0");
			    	
			    	planMainNew.setCreatedDate(curTime);
			    	planMainNew.setCreatedUser("exlushuifa@virtual.com.cn");
			    	planMainNew.setUpdatedDate(curTime);
			    	planMainNew.setUpdatedUser("exlushuifa@virtual.com.cn");
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
	    			planDetailNew.setCreatedUser("exlushuifa@virtual.com.cn");
	    			planDetailNew.setUpdatedDate(curTime);
	    			planDetailNew.setUpdatedUser("exlushuifa@virtual.com.cn");
	    			premiumCount=planDetailNew.getPlanFee();
	    			//添加到列表中
	    	    	planDetailSet.add(planDetailNew);
	    	    	Thread.sleep(50);
	    	    	//保存总数
	    	    	planMainNew.setDeptPremium(premiumCount);
	    	    	
					planMainList.add(planMainNew);
				}else{
					planDetailNew = new PlanDetailNew();
					//System.out.println("==>>"+deptRiskTypeStr);
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
	    			planDetailNew.setCreatedUser("exlushuifa@virtual.com.cn");
	    			planDetailNew.setUpdatedDate(curTime);
	    			planDetailNew.setUpdatedUser("exlushuifa@virtual.com.cn");
	    			premiumCount+=planDetailNew.getPlanFee();
	    			//添加到列表中
	    	    	planDetailSet.add(planDetailNew);
	    	    	planMainNew.setPlanDetailSet(planDetailSet);
	    	    	planMainNew.setDeptPremium(premiumCount);
	    	    	//Thread.sleep(50);
				}
				deptName = deptCodeStr;
			}
		}
		
		for (PlanMainNew planMainNew1 : planMainList) {
			System.out.println("机构ID:"+planMainNew1.getDeptCode()+"==保费总额："+planMainNew1.getDeptPremium()+" 子集长度："+planMainNew1.getPlanDetailSet().size());
		}
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
	 * 详细说明: <br>
	 * 编写者:卢水发
	 * 创建时间:2015年6月16日 下午2:58:04 </pre>
	 */
	@Test
	public void updateValidInd(){
		this.planMainService.delPlanMainById("66669EDDDFCD487E8F8B67FFACEDFD60");
	}
}
