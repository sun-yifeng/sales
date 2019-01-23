package com.sinosafe.xszc.channel.service;

import com.sinosafe.xszc.channel.vo.ChannelMailRecord;
import com.sinosafe.xszc.util.PageDto;

/**
 * 类名:com.sinosafe.xszc.channel.service.ChannelMailRecordService
 * 
 * <pre>
 * 描述:渠道邮件预警记录 基础业务处理接口
 * 编写者:卢水发
 * 创建时间:2015年6月18日 下午2:59:06
 * </pre>
 */
public interface ChannelMailRecordService {

	// 定时发送邮件
	public void sendMailByTime();

	// 增加修改
	public void saveMailRecord(ChannelMailRecord cmr);

	// 查出对象通过主键
	public ChannelMailRecord getByPkId(String pkId);

	// 设置成无效的
	public void setToValidByPkId(String pkId);

	// 查出列表 并分页显示
	public PageDto queryByPage(PageDto pageDto);

	// 根据Id查询是否存在
	boolean isExist(String pkId);

}
