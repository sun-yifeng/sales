package com.sinosafe.xszc.notice.service.impl;

import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

public class TestSpecialChar {
	public static void main(String[] args) {
		
			        // TODO Auto-generated method stub
		
			      //替换特殊字符
		
			        String str1 = "今天`~!@#$%^&*+=|{}':;',\\[\\].<>/?～！星期＠＃￥％……＆×（五）——＋｜｛｝［］【[]\"】‘；。，：＂？";
		
			        System.out.println("原字符：" + str1);      
		
			        System.out.println("处理后：" + StringFilter(str1));
		
			         
		
			        System.out.println("*****************************************");
		
			         
		
			        //检查是否存在特殊字符
		
			        String str2 = "明天就不用上班了|{}':;',\\[\\].<>/?～！＠＃￥％……＆×";
		
			        System.out.println("是否包含特殊字符：" + existSpecialChar(str2,SPECIAL_CHAR.toCharArray()));
	
			        System.out.println("");

			    }
		
			     
		
			     
		
			    public static final String SPECIAL_CHAR = "[`~!@#$%^&*+=|{}',:;\"[url=file://\\[\\].<]\\[\\].<>/[/url]?～！＠＃￥％……＆×（）——＋｜｛｝【】［］‘；：＂。，、．＜＞／？]";
		
			     
		
			    /**
		
			     * 替换特殊字符(全角&半角)
		
			     * 
		
			     * @param srcString 原字符串
		
			     * <a href="http://home.51cto.com/index.php?s=/space/34010" target="_blank">@return</a> 替换后的字符串
		
			     * <a href="http://home.51cto.com/index.php?s=/space/2305405" target="_blank">@throws</a> PatternSyntaxException 
		
			     * <a href="http://home.51cto.com/index.php?s=/space/34010" target="_blank">@return</a> String
		
			     */
		
			    public static String StringFilter(String srcString) throws PatternSyntaxException {     
		
			        return Pattern.compile(SPECIAL_CHAR).matcher(srcString).replaceAll("").replaceAll("[url=]\\\\[/url]", "").trim();       
		
			    }
		
			     
		
			    /**
		
			     * 检查指定字符串中是否包含特殊字符
		
			     * 
		
			     * @param srcString  原字符串
		
			     * @param specialChar  特殊字符数组
		
			     * <a href="http://home.51cto.com/index.php?s=/space/34010" target="_blank">@return</a> 是否存在特殊字符
		
			     * <a href="http://home.51cto.com/index.php?s=/space/2305405" target="_blank">@throws</a> void 
		
			     * <a href="http://home.51cto.com/index.php?s=/space/34010" target="_blank">@return</a> boolean
		
			     */
		
			    public static boolean existSpecialChar(String srcString,char[] specialChar){
		
			        for (Character c : specialChar) {
		
			            if(srcString.contains(c.toString())){
		
			                return true;                
		
			            }
		
			        }
		
			        return false;
		
			    }
}
