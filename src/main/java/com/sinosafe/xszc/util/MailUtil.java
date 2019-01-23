package com.sinosafe.xszc.util;

import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.UnknownHostException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class MailUtil {

	private static final Log log = LogFactory.getLog(MailUtil.class);

	private static String ip;
	private static String hostName;
	private static String mailNick;

	private final static String systemName = "销售支持系统";

	static {
		// 获取IP和机器名
		try {
			ip = InetAddress.getLocalHost().getHostAddress();
			hostName = InetAddress.getLocalHost().getHostName();
			log.debug("服务器的IP：" + ip + ",服务器的名称：" + hostName);
		} catch (UnknownHostException e) {
			log.error("取服务器IP地址时出错！");
			e.printStackTrace();
		}

		// 邮件发送人昵称
		try {
			mailNick = javax.mail.internet.MimeUtility.encodeText(systemName);
			log.debug("发送人的昵称：" + mailNick);
		} catch (UnsupportedEncodingException e) {
			log.error("设置邮件发送人昵称的时出错！");
			e.printStackTrace();
		}

	}

	public static String getServerIP() {
		return ip;
	}

	public static String getHostName() {
		return hostName;
	}

	public static String getMailNick() {
		return mailNick;
	}

	public static String getSystemName() {
		return systemName;
	}
}
