package com.sinosafe.xszc.util;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 加密
 *
 * 类名:cn.com.sinosafe.um.util.MD5Util <pre>
 * 描述:
 * 基本思路:
 * 特别说明:
 * 编写者:甄磊
 * 创建时间:2014年4月3日 下午7:02:19
 * 修改说明: 类的修改说明
 * </pre>
 */
public class MD5Util {
	
	private static final Log log = LogFactory.getLog(MD5Util.class);
 
    /**
     * 生成MD5 32位密文
     *
     * 方法encryption的简要说明 <br><pre>
     * 方法encryption的详细说明 <br>
     * 编写者：甄磊
     * 创建时间：2014年4月3日 下午7:00:18 </pre>
     * @param 参数名 说明
     * @return String 说明
     * @throws 异常类型 说明
     */
    public static String encryption(String plainText) {
        String re_md5 = new String();
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(plainText.getBytes());
            byte b[] = md.digest();
 
            int i;
 
            StringBuffer buf = new StringBuffer("");
            for (int offset = 0; offset < b.length; offset++) {
                i = b[offset];
                if (i < 0)
                    i += 256;
                if (i < 16)
                    buf.append("0");
                buf.append(Integer.toHexString(i));
            }
 
            re_md5 = buf.toString();
 
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            log.error("MD5加密异常！",e);
        }
        return re_md5;
    }
    
    // 加密
   	public static String doEncrypt(String str){
   		String enceypt = new String();
   		try {
   			String key = Encrypt.KEY;// 16位key
   			Encrypt desEncrypt = new Encrypt(key.getBytes());
   			enceypt = desEncrypt.doEncrypt(str);
  		} catch (Exception e) {
  			e.printStackTrace();
  			log.error("加密异常！",e);
  		}
   		return enceypt;
   	}
    
    /**
     * 给加密后的密文再转成MD5 32位密文
     *
     * 方法toMD5的简要说明 <br><pre>
     * 方法toMD5的详细说明 <br>
     * 编写者：甄磊
     * 创建时间：2014年4月3日 下午7:00:37 </pre>
     * @param 参数名 说明
     * @return String 说明
     * @throws Exception 
     * @throws 异常类型 说明
     */
    public static String toMD5(String str) {
    	String encryptStr = doEncrypt(str);
    	String mdStr = encryption(encryptStr);
    	return mdStr;
    }
}
