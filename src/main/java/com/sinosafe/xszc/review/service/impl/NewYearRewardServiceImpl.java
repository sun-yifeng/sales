package com.sinosafe.xszc.review.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.NEW_YEAR_REWARD;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.service.security.IUserDetails;
import com.hf.framework.util.DateUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.review.service.NewYearRewardService;
import com.sinosafe.xszc.review.vo.NewYearReward;
import com.sinosafe.xszc.util.ExcelReader;
import com.sinosafe.xszc.util.ExcelWrite;
import com.sinosafe.xszc.util.PageDto;

public class NewYearRewardServiceImpl implements NewYearRewardService {

	private static final Log log = LogFactory.getLog(NewYearRewardServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public boolean saveNewYearRewardInXls(Map<String, Object> paramMap) {
		try {
			String fileDiskPath = paramMap.get("fileDiskPath").toString();
			IUserDetails curUserInfo = CurrentUser.getUser();
			String userName = curUserInfo.getUsername();
			// 对读取Excel表格内容测试
			InputStream is2 = new FileInputStream(fileDiskPath);
			ExcelReader excelReader = new ExcelReader();
			Map<Integer, String> map = excelReader.readExcelContent(is2);
			List<NewYearReward> rewardList = new ArrayList<NewYearReward>();
			NewYearReward reward = null;
			String curTime = DateUtil.dateToStr(new Date());
			for (int i = 1; i <= map.size(); i++) {
				String str = map.get(i) + "0";
				if (!map.get(i).replace("`", "").trim().equals("")) {
					reward = new NewYearReward();
					String[] props = str.split("`");
					reward.setCreatedDate(curTime);
					reward.setCreatedUser(userName);
					reward.setPkId(UUIDGenerator.getUUID());
					reward.setRewardDate(props[0]);
					reward.setDeptCode(props[1]);
					reward.setRewardName(props[2]);
					reward.setEmployNum(props[3]);
					reward.setReward(Double.parseDouble(props[4]));
					reward.setUpdatedDate(curTime);
					reward.setUpdatedUser(userName);
					reward.setValidInd("1");
					rewardList.add(reward);
				}
			}
			saveLawRateList(rewardList);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	// 批量导入
		private void saveLawRateList(final List<NewYearReward> rewardList) {
			for (NewYearReward yearReward : rewardList) {
				saveOrUpdateByWhere(yearReward);
			}
		}
		
		public boolean saveOrUpdateByWhere(NewYearReward yearReward) {
			Map<String, Object> whereMap = new HashMap<String, Object>();
			whereMap.put("rewardDate", yearReward.getRewardDate());
			whereMap.put("employNum", yearReward.getEmployNum());
			boolean flag = false;
			// 判断数据库是否存在，存在作修改,不存在作添加
			if (this.isExistByWhere(whereMap)) {
				dao.update(NEW_YEAR_REWARD + ".updateByPrimaryKey", yearReward);
				flag = true;
			} else {
				dao.insert(NEW_YEAR_REWARD + ".insertVo", yearReward);
				flag = true;
			}
			return flag;
		}

		public boolean isExistByWhere(Map<String, Object> whereMap) {
			long count = (Long) dao.selectOne(NEW_YEAR_REWARD + ".queryCount", whereMap);
			return count > 0;
		}

		@Override
		public PageDto queryNewYearRewardToPage(PageDto pageDto) {
			try {
				if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
					pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
				} else {
					pageDto.getWhereMap().put("startpoint", 1);
				}
				pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
				String curDeptCode = pageDto.getWhereMap().get("curDeptCode").toString();
				List<Map<String, Object>> list=null;
				if(curDeptCode.equals("00")){
					list = dao.selectList(NEW_YEAR_REWARD + ".queryListPage", pageDto.getWhereMap());
				}else{
					list = dao.selectList(NEW_YEAR_REWARD + ".queryDeptListPage", pageDto.getWhereMap());
				}
				pageDto.setTotal((long)list.size());
				pageDto.setRows(list);
				return pageDto;
			} catch (Exception e) {
				e.printStackTrace();
				pageDto.setRows(null);
				return pageDto;
			}
		}
		
		public boolean genRateSafeTypeModelXls(Map<String, Object> paramMap) {
			try {
				String savePath = paramMap.get("savePath").toString();
				// 设置excel头部
				List<String> rowList = new ArrayList<String>();
				StringBuffer rowData = new StringBuffer();
				rowData.append("年份`");
				rowData.append("所属机构`");
				rowData.append("姓名`");
				rowData.append("工号`");
				rowData.append("新年奖(元)`");
				rowList.add(rowData.toString());
				ExcelWrite workBook = new ExcelWrite();
				boolean createFlag = workBook.createWorkBook(rowList, savePath);
				return createFlag;
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
		}
		
		@Override
		public boolean updateChange(List<NewYearReward> rewardList) {
			try {
				IUserDetails curUserInfo = CurrentUser.getUser();
				String userName = curUserInfo.getUsername();
				String curTime = DateUtil.dateToStr(new Date());
				for (NewYearReward reward : rewardList) {
					reward.setCreatedUser(userName);
					reward.setCreatedDate(curTime);
					reward.setUpdatedDate(curTime);
					reward.setUpdatedUser(userName);
					this.saveOrUpdateByWhere(reward);
				}
				return true;
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
		}

		@Override
		public Map<String, Object> queryAllEmployAndSalary(Map<String, Object> paramMap) {
			Map<String, Object> map=null;
			try {
				map = dao.selectOne(NEW_YEAR_REWARD + ".queryAllEmployAndSalary", paramMap);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return map;
		}

}
