package com.sinosafe.xszc.autoTask;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.AUTO_TASK;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.CronTrigger;
import org.quartz.TriggerUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.fastjson.JSON;
import com.hf.framework.dao.CommonDao;

public class AutoTaskDispatch {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	private static final Log log = LogFactory.getLog(AutoTaskDispatch.class);

	/**
	 * 功能：执行数据库配置的自动任务 <br>
	 * 思路：将定时任务配置到数据库中，减少QUATZ配置及JAVA代码<br>
	 * 注意： <br>
	 * 1、存过固定为三个参数，一个输入参数，两个输出参数<br>
	 * 2、定时任务是每半个小时执行一次，如果某个存过执行超过半个小时，会不会前一个任务未处理完，后面的任务又开始运行。
	 */
	public void taskDispatch() {
		List<Map<String, Object>> dispatchList = new ArrayList<Map<String, Object>>();
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("validInd", "1");
		// 取下次执行时间小于当前时间的任务
		dispatchList = dao.selectList(AUTO_TASK + ".queryInfo", whereMap);
		log.info("需要调度的任务:" + JSON.toJSONString(dispatchList));
		for (Map<String, Object> taskMap : dispatchList) {
			try {
				// Cron表达式,如
				String nextDispatchTime = getNextTime((String) taskMap.get("dispatchTarget"), (String) taskMap.get("dispatchCycle"));
				taskMap.put("dispatchTime", nextDispatchTime);
				log.debug("任务：" + taskMap.get("dispatchTarget") + "调度开始！！" + taskMap.get("dispatchTime"));
				taskMap.put("dispatchResult", "2");
				// 更新任务状态（1-成功（未开始），0-失败，2-进行中）
				dao.update(AUTO_TASK + ".updateByPrimaryKeySelective", taskMap);
				// 执行任务对应的存过
				dao.selectOne(AUTO_TASK + ".callTask", taskMap);
				taskMap.put("dispatchResult", "1");
				taskMap.put("dispatchResultDescription", "成功！！！！");
				log.debug("任务：" + taskMap.get("dispatchTarget") + "调度成功！！" + taskMap.get("dispatchTime"));
			} catch (Exception e) {
				taskMap.put("dispatchResult", "0");
				// 存过异常信息
				taskMap.put("dispatchResultDescription", e.getCause().getMessage());
				log.error("任务：" + taskMap.get("dispatchTarget") + "调度失败！！", e);
			} finally {
				// 更新任务状态（1-成功（未开始），0-失败，2-进行中）
				dao.update(AUTO_TASK + ".updateByPrimaryKeySelective", taskMap);
			}
		}
	}

	@SuppressWarnings("unchecked")
	public String getNextTime(String dispatchTarget, String cronStr) throws ParseException, InterruptedException {
		String nextTime = "";
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// cron表达式
		CronTrigger cronTrigger = new CronTrigger();
		cronTrigger.setCronExpression(cronStr);
		// 取当前日历的时间
		Calendar calendar = Calendar.getInstance();
		Date fromDate = calendar.getTime();
		// 取12个月后的时间
		calendar.add(Calendar.MONTH, 12);
		Date toDate = calendar.getTime();
		// 根据cron表达式取某段时间所有的任务
		List<Date> dateList = TriggerUtils.computeFireTimesBetween(cronTrigger, null, fromDate, toDate);
		if (dateList.size() < 1) {
			nextTime = "9999-01-01 00:00:00";
		} else {
			nextTime = dateFormat.format(dateList.get(0));
		}
		log.debug("任务" + dispatchTarget + "下次执行的时间是:" + nextTime);
		return nextTime;
	}

	public static void main(String arg[]) throws ParseException, InterruptedException {
		AutoTaskDispatch tastTest = new AutoTaskDispatch();
		tastTest.getNextTime("p_dict_info_sync", "0 0 5 ? * *");
	}
}
