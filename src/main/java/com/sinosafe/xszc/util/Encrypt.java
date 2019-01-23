package com.sinosafe.xszc.util;

import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

public class Encrypt {
	
	public static String DES="DES";//DES
	public static String PADDING="DES/ECB/PKCS5Padding";//补位
	public static String NOPADDING="DES/ECB/NoPadding"; //不补位
	public static String KEY="0123456789ABCDEF";
	
	// 加密方式
	private String DES_TYPE = DES;

	private byte[] desKey;

	public Encrypt(byte[] desKey) {
		this.desKey = desKey;
	}

	//加密
	public byte[] doEncrypt(byte[] plainText) throws Exception {

		SecureRandom random = new SecureRandom();
		// //new SecureRandom();
		byte rawKeyData[] = desKey;
		DESKeySpec dks = new DESKeySpec(rawKeyData);
		SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(DES_TYPE);
		SecretKey key = keyFactory.generateSecret(dks);
		Cipher cipher = Cipher.getInstance(PADDING);
		cipher.init(Cipher.ENCRYPT_MODE, key, random);
		byte data[] = plainText;
		byte encryptedData[] = cipher.doFinal(data);
		return encryptedData;
	}

	// 对字符串实施加密,然后转换成16进制
	public String doEncrypt(String text) throws Exception {
		SecureRandom random = new SecureRandom();
		byte rawKeyData[] = desKey;
		DESKeySpec dks = new DESKeySpec(rawKeyData);
		SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(DES_TYPE);
		SecretKey key = keyFactory.generateSecret(dks);
		Cipher cipher = Cipher.getInstance(PADDING);
		cipher.init(Cipher.ENCRYPT_MODE, key, random);
		byte encryptedData[] = cipher.doFinal(text.getBytes());
		StringBuffer sb = new StringBuffer();
		for (int n = 0; n < encryptedData.length; n++) {
			String stmp = (java.lang.Integer
					.toHexString(encryptedData[n] & 0XFF));
			if (stmp.length() == 1) {
				sb.append("0" + stmp);
			} else {
				sb.append(stmp);
			}
		}

		return sb.toString().toUpperCase();
	}
}
