package com.sinosafe.xszc.util;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;

import java.util.Map;
import java.util.Map.Entry;  
import java.util.Set;


/**
 *
 * 类名:cn.com.sinosafe.um.util.ArrayUtil <pre>
 * 描述:
 * 基本思路: 数组处理工具类，用于获取两个数组的交、并、差集等
 * 特别说明:
 * 编写者:刘志浩
 * 创建时间:2014年4月25日 下午5:22:45
 * 修改说明: 类的修改说明
 * </pre>
 */
public class ArrayUtil {
			 
	   //求两个字符串数组的并集，利用set的元素唯一性   
	   public static String[] union(Object[] arr1, Object[] arr2) {   
	       Set<String> set = new HashSet<String>();   
	       for (Object str : arr1) {   
	           set.add(str.toString());   
	       }   
	       for (Object str : arr2) {   
	           set.add(str.toString());   
	       }   
	       String[] result = {};   
	       return set.toArray(result);   
	   }   
	 
	   //求两个数组的交集   
	   public static String[] intersect(Object[] arr1, Object[] arr2) {   
	       Map<String, Boolean> map = new HashMap<String, Boolean>();   
	       LinkedList<String> list = new LinkedList<String>();   
	       for (Object str : arr1) {   
	           if (!map.containsKey(str)) {   
	               map.put(str.toString(), Boolean.FALSE);   
	           }   
	       }   
	       for (Object str : arr2) {   
	           if (map.containsKey(str)) {   
	               map.put(str.toString(), Boolean.TRUE);   
	           }   
	       }
	 
	       for (Entry<String, Boolean> e : map.entrySet()) {   
	           if (e.getValue().equals(Boolean.TRUE)) {   
	               list.add(e.getKey());   
	           }   
	       }   
	 
	       String[] result = {};   
	       return list.toArray(result);    
	   }   
	 
	   //求两个数组的差集   
	   public static String[] minus(String[] arr1, String[] arr2) {   
	       LinkedList<String> list = new LinkedList<String>();   
	       LinkedList<String> history = new LinkedList<String>();   
	       String[] longerArr = arr1;   
	       String[] shorterArr = arr2;   
	       //找出较长的数组来减较短的数组   
	       if (arr1.length > arr2.length) {   
	           longerArr = arr2;   
	           shorterArr = arr1;   
	       }   
	       for (String str : longerArr) {   
	           if (!list.contains(str)) {   
	               list.add(str);   
	           }   
	       }   
	       for (String str : shorterArr) {   
	           if (list.contains(str)) {   
	               history.add(str);   
	               list.remove(str);   
	           } else {   
	               if (!history.contains(str)) {   
	                   list.add(str);   
	               }   
	           }   
	       }   
	 
	       String[] result = {};   
	       return list.toArray(result);   
	   }   

}
