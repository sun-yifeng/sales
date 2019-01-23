package com.sinosafe.xszc.upload.service;

import java.util.List;
import java.util.Map;

/**
 * 文件上传下载通用服务接口
 * 
 * 类名:com.sinosafe.xszc.upload.service.UploadService
 * 
 * <pre>
 * 描述:
 * 基本思路:
 * 特别说明:
 * 编写者:李晓亮
 * 创建时间:2014年7月25日 上午11:25:56
 * 修改说明: 类的修改说明
 * </pre>
 */
public interface UploadService {

	List<Object> findUploadInfo(Map<String, Object> paramMap);

	List<Map<String, Object>> queryUploadByMainId(Map<String, Object> paramMap);

}
