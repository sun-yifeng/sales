package com.sinosafe.xszc.planNew.service;

import java.io.IOException;
import java.net.InetAddress;

public class Test extends Student{

public static void main(String[] args) throws IOException {
	   /* List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();
		String[] deptRiskType = {"1","2","3"};
	    JSONArray lineCodeArray = Constant.getCombo("bizLine");
	    ExcelWrite workBook  = new ExcelWrite();
	    List<String> emplist = new ArrayList<String>();
	    StringBuffer rowData = new StringBuffer();
	    rowData.append(b);
	    emplist.add("部门");
	    for (int i = 0; i < deptRiskType.length; i++) {
			for (Object object : lineCodeArray) {
				JSONObject jo = (JSONObject)object;
				rowData = new StringBuffer();
				//resultList.add(dataMap);
			}
		}
		boolean result = workBook.createWorkBook(emplist,"d://模板文件");*/
	   //101.深圳分公司
	   /* String deptCodeStr = "101.深圳分公司";
	    System.out.println(deptCodeStr.split("\\.")[0]);*/
	  /* InetAddress netAddress = InetAddress.getLocalHost();
	   System.out.println("本机IP:"+netAddress.getHostAddress());
	   System.out.println("本机名称:"+netAddress.getHostName());*/
	   System.out.println("dafasddddddd".substring(0, 2));
   }
   
   
   public int getRandom(String v){
	   return Integer.parseInt(v);
   }
   
   public int getRandom(String v,String y){
	   return Integer.parseInt(v+y);
   }
}


class Student{
	public int getAge(String birthday){
		return 10;
	}
}
