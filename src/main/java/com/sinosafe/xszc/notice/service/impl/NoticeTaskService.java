package com.sinosafe.xszc.notice.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.sinosafe.xszc.department.service.DepartmentService;
import com.sinosafe.xszc.notice.service.NoticeService;

public class NoticeTaskService implements Job {
	
	private static final Log log = LogFactory.getLog(NoticeTaskService.class);

	@Autowired
	@Qualifier("DepartmentService")
	private DepartmentService departmentService;

	@Autowired
	@Qualifier("NoticeService")
	private NoticeService noticeService;

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		noticeService.findNoticeWithoutWeek();

		log.debug("Hello Quartz My Success!!!");
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		log.debug(sdf.format(date));

	}

}
