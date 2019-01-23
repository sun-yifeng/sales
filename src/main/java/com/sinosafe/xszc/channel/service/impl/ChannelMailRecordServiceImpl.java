package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL_MAIL_RECORD;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_ONE_VO;

import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSON;
import com.hf.framework.core.context.PlatformContext;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.mail.Mail;
import com.hf.framework.service.mail.MailService;
import com.hf.framework.service.mail.MailType;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.StringUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.channel.service.ChannelMailRecordService;
import com.sinosafe.xszc.channel.vo.ChannelMailRecord;
import com.sinosafe.xszc.util.MailUtil;
import com.sinosafe.xszc.util.PageDto;

/**
 * 类名:com.sinosafe.xszc.channel.service.ChannelMailRecordService
 * 
 * <pre>
 * 描述:渠道邮件预警记录
 * </pre>
 */
public class ChannelMailRecordServiceImpl implements ChannelMailRecordService {

	private static final Log log = LogFactory.getLog(ChannelMainServiceImpl.class);

	public static final String MAIL_FROM = (String) PlatformContext.getGoalbalContext("mail.username");

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "mailService")
	private MailService mailService;

	/**
	 * <pre>
	 * 功能描述：</br>
	 * 1、发送邮件，定时发送，发送成功存取记录， 不成功则提示邮件发送失败  </br>
	 * 2、手动在页面上添加的提醒，系统默认的提醒都在此处发送预警邮件 </br>
	 * 实现思路：</br>
	 * </pre>
	 */
	@Override
	public void sendMailByTime() {
		log.info("定时任务开始发送渠道预警邮件...");
		try {
			// 邮件发送开关
			boolean mailSendFlag = Boolean.parseBoolean((String) PlatformContext.getGoalbalContext("com.hf.xszc.mail.send"));
			log.info("发送渠道预警邮件开关是否打开:" + mailSendFlag);
			if (mailSendFlag) {
				// 提前15天发送邮件
				sendBySysWarning(15);
				// 提前3天发送邮件
				sendBySysWarning(3);
				// 发送手动预警邮件
				sendByManualDay();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		log.info("定时任务结束发送渠道预警邮件...");
	}

	/**
	 * 发送系统预警邮件
	 * 
	 * @param warningDay
	 * @throws Exception
	 */
	public void sendBySysWarning(int warningDay) throws Exception {
		ChannelMailRecord cmr = null; // 邮件发送记录
		Map<String, Object> model = null; // 邮件model
		Mail mail = null; // 邮件对象
		log.info("处理系统自动发送的邮件，预警邮件天数为:" + warningDay);
		// 检测渠道（中介机构和个人代理）是否存在协议到期，许可证(资格证)到期，销售渠道合同到期，将15天内要到期的记录取出
		List<Map<String, Object>> validRows = this.dao.selectList(CHANNEL_MAIL_RECORD + ".findValidRows", warningDay);
		for (Map<String, Object> rowObj : validRows) {
			cmr = new ChannelMailRecord();
			// 初始化邮件记录
			setRecordsVal(cmr, rowObj, "1");

			// 取出邮件接收人及抄送人(UM系统设置的收件人及抄送人)
			Map<String, String> whereMap = new HashMap<String, String>();
			whereMap.put("channelCode", cmr.getChannelCode());
			dao.getSqlSession().selectOne(CHANNEL_MAIL_RECORD + ".getMails", whereMap);
			String receiveMail = whereMap.get("receiveMail");
			String copyMail = whereMap.get("copyMail");

			// 设置收件人邮箱
			cmr.setRecipients(receiveMail);

			// 判断前warningDay内是否有发送过记录，无则发送，有则跳过
			if (!isExistAlrSend(cmr, warningDay)) {
				model = new HashMap<String, Object>();
				// 邮件对象
				mail = new Mail();
				// 设置发件人
				mail.setForm(MailUtil.getMailNick() + "<" + MAIL_FROM + ">");
				// 设置收件人
				mail.setTo(receiveMail.split(","));
				// 设置抄送人
				if (StringUtil.isNotBlank(copyMail)) {
					if (copyMail.startsWith(",", 0)) {
						copyMail = copyMail.substring(1, copyMail.length());
					}
					mail.setCc(copyMail.split(","));
					cmr.setCopyMail(copyMail);
				}
				if (cmr.getTaskType().contains("1") || cmr.getTaskType().contains("2")) {
					mail.setSubject("销售渠道经营许可证(或执业证)到期预警 - [" + cmr.getChannelCode() + cmr.getChannelName() + "]");
					mail.setTemplate("MailTemplateWarnChannelLicence.vm");
				} else if (cmr.getTaskType().contains("3") || cmr.getTaskType().contains("4")) {
					mail.setSubject("销售渠道协议到期预警 - [" + cmr.getChannelCode() + cmr.getChannelName() + "]");
					mail.setTemplate("MailTemplateWarnChannelConfer.vm");
					model.put("conferCode", cmr.getConferCode());
				}
				mail.setMailType(MailType.HTML_TEMPLATE);
				model.put("channelCode", cmr.getChannelCode());
				model.put("channelName", cmr.getChannelName());
				model.put("reportDate", new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
				model.put("endDate", rowObj.get("expireDate")); // 失效日期
				model.put("endDay", rowObj.get("expireDay")); // 剩余天数
				mail.setModel(model);
				if(StringUtil.isNotEmpty(rowObj.get("expireDate").toString())&&StringUtil.isNotEmpty(rowObj.get("expireDay").toString())){
					cmr.setMailContent(rowObj.get("expireDate").toString()+"||"+rowObj.get("expireDay"));
				}
				// 发送邮件
				sendMail(cmr, mail, receiveMail);
			}
		}
	}

	/**
	 * 发送手动预警的邮件
	 */
	public void sendByManualDay() throws Exception {
		ChannelMailRecord cmr = null; // 邮件发送记录
		Map<String, Object> model = null; // 邮件model
		Mail mail = null; // 邮件对象
		log.info("处理用户在页面上自己定义预警天数的邮件");
		// 取出手动添加（web页面添加）的预警渠道，不包括设置预警天数为15天的渠道（设置为15天的渠道和系统默认天数相同，发送同一封邮件）
		List<Map<String, Object>> manualRows = this.dao.selectList(CHANNEL_MAIL_RECORD + ".findManualMail", null);
		for (Map<String, Object> rowObj : manualRows) {
			cmr = new ChannelMailRecord();
			// 初始化邮件记录
			setRecordsVal(cmr, rowObj, "2");
			// 设置收件人邮箱
			cmr.setRecipients(rowObj.get("email").toString());
			// 是否满足发送邮件的条件：达到预警天数，未发送过预警邮件
			if (manualSendContition(rowObj)) {
				model = new HashMap<String, Object>();
				// 邮件对象
				mail = new Mail();
				mail.setForm(MailUtil.getMailNick() + "<" + MAIL_FROM + ">");
				mail.setTo(rowObj.get("email").toString().split(","));
				mail.setSubject("销售渠道经营许可证(或执业证)到期预警");
				mail.setTemplate("MailTemplateWarnChannelLicence.vm");
				mail.setMailType(MailType.HTML_TEMPLATE);
				model.put("channelCode", cmr.getChannelCode());
				model.put("channelName", cmr.getChannelName());
				model.put("reportDate", new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()));
				mail.setModel(model);
				// 发送邮件
				sendMail(cmr, mail, rowObj.get("email").toString());
			}
		}
	}

	// 给邮件记录设值
	private void setRecordsVal(ChannelMailRecord cmr, Map<String, Object> rowObj, String mailType) throws Exception {
		try {
			IUserDetails curUserInfo = CurrentUser.getUser();
			String userName = "  ";
			if (curUserInfo != null) {
				userName = curUserInfo.getUsername();
			}
			InetAddress netAddress = InetAddress.getLocalHost();
			// 本机IP
			String localIp = netAddress.getHostAddress();
			// 本机名称
			String localHostName = netAddress.getHostName();

			cmr.setMailType(mailType);
			cmr.setPkId(UUIDGenerator.getUUID());
			cmr.setChannelType(rowObj.get("channelType").toString());
			cmr.setChannelName(rowObj.get("channelName").toString());
			cmr.setChannelCode(rowObj.get("channelCode").toString());
			cmr.setDeptCode(rowObj.get("deptCode").toString());
			String conferCode = "";
			if (rowObj.get("conferCode") != null) {
				conferCode = rowObj.get("conferCode").toString();
			}
			cmr.setConferCode(conferCode);
			cmr.setLineCode(rowObj.get("lineCode").toString());
			cmr.setTaskType(rowObj.get("taskType").toString());
			cmr.setSendIp(localIp);
			cmr.setSendStatus("1");
			cmr.setSendName(localHostName);
			cmr.setValidInd("1");
			cmr.setCreatedUser(userName);
			cmr.setUpdatedUser(userName);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("组装邮件记录时出现异常rowObj：" + JSON.toJSONString(rowObj), e);
		}
	}

	/**
	 * 保存记录
	 */
	@Override
	public void saveMailRecord(ChannelMailRecord cmr) {
		dao.insert(CHANNEL_MAIL_RECORD + INSERT_VO, cmr);
	}

	/**
	 * 根据主键查出邮件对象
	 */
	@Override
	public ChannelMailRecord getByPkId(String pkId) {
		ChannelMailRecord cmr = (ChannelMailRecord) dao.selectOne(CHANNEL_MAIL_RECORD + QUERY_ONE_VO, pkId);
		return cmr;
	}

	/**
	 * 根据主键将记录设置为无效值
	 */
	@Override
	public void setToValidByPkId(String pkId) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("validInd", "0");
		whereMap.put("pkId", pkId);
		dao.delete(CHANNEL_MAIL_RECORD + ".updateByPrimaryKeySelective", whereMap);
	}

	/**
	 * 分页查出列表
	 */
	@Override
	public PageDto queryByPage(PageDto pageDto) {
		try {
			Long total = dao.selectOne(CHANNEL_MAIL_RECORD + QUERY_COUNT, pageDto.getWhereMap());
			pageDto.setTotal(total);
			if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
				pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
			} else {
				pageDto.getWhereMap().put("startpoint", 1);
			}
			pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
			List<Map<String, Object>> list = dao.selectList(CHANNEL_MAIL_RECORD + ".queryListPage", pageDto.getWhereMap());
			pageDto.setRows(list);
			return pageDto;
		} catch (Exception e) {
			e.printStackTrace();
			pageDto.setRows(null);
			return pageDto;
		}
	}

	/**
	 * 根椐ID判断主键是否在
	 */
	@Override
	public boolean isExist(String pkId) {
		long count = (Long) dao.selectOne(CHANNEL_MAIL_RECORD + ".countByPrimaryKey", pkId);
		return count > 0;
	}

	/**
	 * 查看是否已发送(warningDay天以内)
	 */
	public boolean isExistAlrSend(ChannelMailRecord cmr, int warningDay) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("channelCode", cmr.getChannelCode());
		whereMap.put("taskType", cmr.getTaskType());
		whereMap.put("warningDay", warningDay);
		long count = (Long) dao.selectOne(CHANNEL_MAIL_RECORD + ".countByalrSendRow", whereMap);
		return count > 0;
	}

	/**
	 * 功能描述： 1、发送邮件给收件人 2、保存邮件发送记录
	 */
	private void sendMail(ChannelMailRecord cmr, Mail mail, String receiver) {
		log.info("正在发送邮件，渠道：" + cmr.getChannelCode() + cmr.getChannelName() + "，邮件接收人：" + receiver);
		try {
			// 发送邮件
			mailService.send(mail);
			cmr.setSendStatus("1");
		} catch (Exception e) {
			log.info("邮件发送失败，邮件邮件人：" + receiver);
			e.printStackTrace();
			cmr.setSendStatus("2");
		}
		// 保存记录
		this.saveMailRecord(cmr);
	}

	/**
	 * 手工预警邮件发送条件：1、满足预警天数，2、未发送过预警邮件
	 */
	public boolean manualSendContition(Map<String, Object> warnRow) {
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("channelCode", warnRow.get("channelCode")); // 手动选择的渠道
		whereMap.put("warningDay", warnRow.get("warningDay")); // 手动设置的预警天数
		// 满足预警天数
		long count1 = (Long) dao.selectOne(CHANNEL_MAIL_RECORD + ".countWarningDay", whereMap);
		// 未发送过预警邮件
		if (count1 > 0) {
			long count2 = (Long) dao.selectOne(CHANNEL_MAIL_RECORD + ".countManualSend", whereMap);
			if (count2 > 0)
				return true;
		}
		return false;
	}

}
