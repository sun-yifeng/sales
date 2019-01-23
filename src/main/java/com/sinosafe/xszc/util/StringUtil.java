package com.sinosafe.xszc.util;

import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public abstract class StringUtil {
	
	private static final Log log = LogFactory.getLog(StringUtil.class);
      
    /**
     * 将map中所有键值对的值 首尾去空格及制表符等
     * @param map
     * @return
     * @author zhouwj
     * 2014年4月1日 下午5:45:57
     */
    public static Map<String,Object> moveSpaceForMap(Map<String,Object> map){       
        if(map.size() > 0) {
            Set<String> keySet = map.keySet();//获取map的key值的集合，set集合
            for(String key:keySet){//遍历key    
            	if(map.get(key) instanceof String){
            		map.put(key, ((String)map.get(key)).trim());
            	}else{
            		log.warn(map.get(key) + "不是String类型，不能进行去除空格处理！");
            	}
            }
        }
        return map;
    }
    
}
