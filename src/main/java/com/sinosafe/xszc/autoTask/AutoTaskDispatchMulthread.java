package com.sinosafe.xszc.autoTask;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.quartz.CronTrigger;
import org.quartz.TriggerUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;








import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.AUTO_TASK;

public class AutoTaskDispatchMulthread {
	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;
	
	private static Logger logger = Logger.getLogger(AutoTaskDispatchMulthread.class);
	
	public void taskDispatch() {
		List<Map<String, Object>> dispatchList = new ArrayList<Map<String,Object>>();
		Map<String, Object> whereMap = new HashMap<String, Object>();
		whereMap.put("validInd", "1");
		dispatchList = dao.selectList(AUTO_TASK+".queryInfo", whereMap);
		for (Map<String, Object> taskMap : dispatchList) {
			Thread dispaThread = new Thread(new TaskDispatch(taskMap,dao));
			dispaThread.start();
		}
		logger.info("主线程结束！！！！");
	}

}

class TaskDispatch implements Runnable{
	
	private CommonDao dao;
	
	private static Logger logger = Logger.getLogger(AutoTaskDispatchMulthread.class);
	
	private Map<String, Object> taskMap = new HashMap<String, Object>();
	
	TaskDispatch(Map<String, Object> map, CommonDao dao2) {
		taskMap = map;
		dao = dao2;
	}

	@Override
	public void run() {
		try {
			String nextDispatchTime = getNextTime((String) taskMap.get("dispatchCycle"));
			taskMap.put("dispatchTime", nextDispatchTime);
			logger.error("任务："+taskMap.get("dispatchTarget")+"调度开始！！"+taskMap.get("dispatchTime"));
			dao.update(AUTO_TASK+".updateByPrimaryKeySelective", taskMap);
			taskMap.put("dispatchResult", "执行中");
			dao.selectOne(AUTO_TASK+".callTask", taskMap);
			taskMap.put("dispatchResult", "成功");
			taskMap.put("dispatchResultDescription", "成功！！！！");
			logger.error("任务："+taskMap.get("dispatchTarget")+"调度成功！！"+taskMap.get("dispatchTime"));
		} catch (Exception e) {
			taskMap.put("dispatchResult", "失败");
			taskMap.put("dispatchResultDescription", e.getCause().getMessage());
			logger.error("任务："+taskMap.get("dispatchTarget")+"调度失败！！", e);
		} finally {
			dao.update(AUTO_TASK+".updateByPrimaryKeySelective", taskMap);
		}
		
	}
	
	@SuppressWarnings("unchecked")
	public String getNextTime(String cronStr) throws ParseException, InterruptedException {
        CronTrigger cronTrigger = new CronTrigger();
        cronTrigger.setCronExpression(cronStr);//这里写要准备猜测的cron表达式
        Calendar calendar = Calendar.getInstance();
        Date now = calendar.getTime();
        calendar.add(Calendar.MONTH, 12);//把统计的区间段设置为从现在到2年后的今天（主要是为了方法通用考虑，如那些1个月跑一次的任务，如果时间段设置的较短就不足20条)
        List<Date> dates = TriggerUtils.computeFireTimesBetween(cronTrigger, null, now, calendar.getTime());//这个是重点，一行代码搞定~~
        logger.debug(dates.size());
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return dateFormat.format(dates.get(0));
     }
	
}

