package com.sinosafe.xszc.channel.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Component;

import com.hf.framework.service.mail.Mail;
import com.hf.framework.service.mail.MailService;
import com.hf.framework.service.mail.MailType;
import com.hf.framework.service.mail.cmd.AddAttachment;
import com.hf.framework.service.mail.cmd.AddInline;
import com.hf.framework.service.template.VelocityService;
import com.hf.framework.service.template.VelocityServiceImpl;

/**
 * Junit使用，改造了框架的邮件服务，测试时，可以在发送邮件的业务类中使用
 */

@Component(value = "testMailService")
public class TestMailService implements MailService {

	String from;
	String subject;
	String host;
	String username;
	String password;
	String mailBase;
	String defaultEncoding = "UTF-8";
	Properties javaMailProperties = new Properties();
	VelocityService velocityService;

	JavaMailSenderImpl sender = new JavaMailSenderImpl();

	public TestMailService() {
		// 邮件服务器地址
		sender.setHost("mailha.sinosafe.local");
		sender.setJavaMailProperties(javaMailProperties);
		sender.setUsername("xszc@sinosafe.com.cn");
		sender.setPassword("ha-1013");
		// 邮件服务器编码
		sender.setDefaultEncoding(defaultEncoding);
	}

	//邮件发送方法
	public void send(final Mail mail) {

		// Spring提供的邮件信息的帮助
		MimeMessagePreparator preparator = new MimeMessagePreparator() {
			@SuppressWarnings("rawtypes")
			public void prepare(MimeMessage mimeMessage) throws Exception {

				// 邮件信息
				MimeMessageHelper message = null;
				if (mail.getAttachments() != null || mail.getInLine() != null) {
					// 构造方法中的参数ture标示邮件为multipart类型的邮件
					message = new MimeMessageHelper(mimeMessage, true, defaultEncoding);
				} else {
					// 简单邮件
					message = new MimeMessageHelper(mimeMessage, defaultEncoding);
				}

				if (mail.getBcc() != null)
					message.setBcc(mail.getBcc());
				if (mail.getCc() != null)
					message.setCc(mail.getCc());

				message.setTo(mail.getTo());

				if (mail.getForm() != null) {
					message.setFrom(mail.getForm());
				} else {
					message.setFrom(from);
				}
				if (mail.getSubject() != null) {
					message.setSubject(mail.getSubject());
				} else {
					message.setSubject(subject);
				}
				message.setSentDate(new Date());
				if (mail.getMailType() == MailType.HTML_CONTENT) {
					message.setText(mail.getContent(), true);
				} else if (mail.getMailType() == MailType.PLAIN_CONTENT) {
					message.setText(mail.getContent(), false);
				} else {
					Map model = mail.getModel();
					if (model == null) {
						model = new HashMap();
					}
					String mb = "";
					if (mailBase != null && mailBase.trim().length() > 0) {
						mb = mailBase + "/";
					}

					// 邮件正文
					String content = getVelocityService().mergeTemplateIntoString(mb + mail.getTemplate(), model);

					if (mail.getMailType() == MailType.HTML_TEMPLATE) {
						message.setText(content, true);
					} else if (mail.getMailType() == MailType.PLAIN_TEMPLATE) {
						message.setText(content, false);
					}
				}

				// 向邮件信息中添加附件
				if (mail.getAttachments() != null) {
					for (AddAttachment ad : mail.getAttachments()) {
						ad.execute(message);
					}
				}

				// 向邮件信息中添加内嵌文件
				if (mail.getInLine() != null) {
					for (AddInline il : mail.getInLine()) {
						il.execute(message);
					}
				}

			}

		};

		// 发送邮件
		sender.send(preparator);

	}

	//
	public VelocityService getVelocityService() {
		if (velocityService == null) {
			synchronized (this) {
				if (velocityService == null) {
					velocityService = new VelocityServiceImpl();
				}
			}
		}
		return velocityService;
	}

	public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getHost() {
		return host;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Properties getJavaMailProperties() {
		return javaMailProperties;
	}

	public void setJavaMailProperties(Properties javaMailProperties) {
		this.javaMailProperties = javaMailProperties;
	}

	public String getDefaultEncoding() {
		return defaultEncoding;
	}

	public void setDefaultEncoding(String defaultEncoding) {
		this.defaultEncoding = defaultEncoding;
	}

	public String getMailBase() {
		return mailBase;
	}

	public void setMailBase(String mailBase) {
		this.mailBase = mailBase;
	}

}
