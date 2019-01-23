package com.sinosafe.xszc.law.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.T_LAW_DEFINE_MANUAL_STEP;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.util.StringUtil;
import com.sinosafe.xszc.constant.Constant;
import com.sinosafe.xszc.law.service.LawDefineManualStepService;

public class LawDefineManualStepServiceImpl implements LawDefineManualStepService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	private List<Map<String, Object>> queryManualStep() {
		return dao.selectList(T_LAW_DEFINE_MANUAL_STEP + ".queryManualTaskList", null);
	}

	private String queryVersionId(Map<String, Object> paramMap) {
		return dao.selectOne(T_LAW_DEFINE_MANUAL_STEP + ".queryVersionId", paramMap);
	}

	@Override
	public void saveManualTaskList(String calcMonth) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		// 如果参数为空，则取当前时间
		if (StringUtil.isEmpty(calcMonth)) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM"); // 有大小写
			calcMonth = sdf.format(new Date());
		}
		String[][] arr1 = Constant.deptTwo;
		for (int i = 0; i < arr1.length; i++) {
			paramMap.put("deptCode", arr1[i][0]);
			paramMap.put("versionId", queryVersionId(paramMap));
			// 遍历基本法步骤
			List<Map<String, Object>> stepList = queryManualStep();
			for (Map<String, Object> map : stepList) {
				paramMap.put("calcMonth", calcMonth);
				paramMap.put("taskCode", map.get("taskCode"));
				paramMap.put("taskName", map.get("taskCode"));
				paramMap.put("procName", map.get("procName"));
				Long count = (Long) dao.selectOne(T_LAW_DEFINE_MANUAL_STEP + ".existsLawVersion", paramMap);
				if (count == 0)
					dao.insert(T_LAW_DEFINE_MANUAL_STEP + ".insertManualStep", paramMap);
			}
		}
	}

	public static void main(String arg[]) {
	 Date date = new Date();
	 //date.
	}

}
