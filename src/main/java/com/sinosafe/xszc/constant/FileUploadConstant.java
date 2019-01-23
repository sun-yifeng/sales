package com.sinosafe.xszc.constant;

import com.hf.framework.core.context.PlatformContext;

/**
 * 
 * 类名:com.sinosafe.xszc.constant.FileUploadConstant
 * 
 * <pre>
 * 描述:文件上传常量类
 * 编写者:孙益峰
 * 创建时间:2014年7月14日 下午4:14:49
 * 修改说明:无修改说明
 * </pre>
 */
public class FileUploadConstant {

	public static final String FILE_UPLOAD_URL = (String) PlatformContext.getGoalbalContext("file.upload.url");

	public static final String SYSTEM_CODE = "XSZC01"; //系统代码

	public static final String MODEL_CODE_MEDIUM_LICENSE = "XSZC010101"; // 中介机构证书

	public static final String MODEL_CODE_MEDIUM_CONFER = "XSZC010102"; // 中介机构协议

	public static final String MODEL_CODE_AGENT_LICENSE = "XSZC010103"; // 代理人证件

	public static final String MODEL_CODE_AGENT_CONFER = "XSZC010104"; // 代理人协议

	public static final String MODEL_CODE_ACTIVITY_RESOLUTION = "XSZC010201"; // 活动方案文件

	public static final String MODEL_CODE_ACTIVITY_FEEDBACK = "XSZC010202"; // 活动反馈文件

	public static final String MODEL_CODE_ACTIVITY_SUMMARY = "XSZC010203"; // 活动总结文件

	public static final String MODEL_CODE_NOTICE = "XSZC010301"; // 公告附件文件

}
