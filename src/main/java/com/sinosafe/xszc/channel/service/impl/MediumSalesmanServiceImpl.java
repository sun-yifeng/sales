package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_SALESMAN;

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
import com.sinosafe.xszc.channel.service.MediumSalesmanService;
import com.sinosafe.xszc.channel.vo.MediumSalesman;
import com.sinosafe.xszc.util.ExcelReader;
import com.sinosafe.xszc.util.ExcelWrite;
import com.sinosafe.xszc.util.PageDto;

public class MediumSalesmanServiceImpl implements MediumSalesmanService {

	private static final Log log = LogFactory.getLog(MediumSalesmanServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Override
	public Map<String,Object> saveMediumSalesmanInXls(Map<String, Object> paramMap) {
		Map<String,Object> returnMap = new HashMap<String,Object>();
		try {
			String fileDiskPath = paramMap.get("fileDiskPath").toString();
			IUserDetails curUserInfo = CurrentUser.getUser();
			String userName = curUserInfo.getUsername();
			// 对读取Excel表格内容测试
			InputStream is2 = new FileInputStream(fileDiskPath);
			ExcelReader excelReader = new ExcelReader();
			Map<Integer, String> map = excelReader.readExcelContent(is2);
			List<MediumSalesman> salesmanList = new ArrayList<MediumSalesman>();
			List<String> idexists = new ArrayList<String>();
			MediumSalesman sale = null;
			String curTime = DateUtil.dateToStr(new Date());
			for (int i = 1; i <= map.size(); i++) {
				String str = map.get(i) + "0";
				if (!map.get(i).replace("`", "").trim().equals("")) {
					sale = new MediumSalesman();
					String[] props = str.split("`");
					boolean idExists = querySalesmanId(props[1].trim());
					if(idExists){
						sale.setPkId(UUIDGenerator.getUUID());
						sale.setChannelCode(paramMap.get("channelCode").toString());
						sale.setName(props[0].trim());
						sale.setIdNumber(props[1].trim());
						String idCard = props[1].trim();
						if (idCard.length() == 15) {
							if (Integer.parseInt(idCard.substring(14, 15)) % 2 == 0) {
								sale.setSex("2");
							}
							else {
								sale.setSex("1");
							}
						}
						else {
							if (idCard.length() == 18) {
								if (Integer.parseInt(idCard.substring(14, 17)) % 2 == 0) {
									sale.setSex("2");
								}
								else {
									sale.setSex("1");
								}
							}
							else {
								sale.setSex("9");
							}
						}
						String birthdayValue = idCard.substring(6, 14);
						sale.setBirthday(birthdayValue);
						sale.setMobile(props[2].trim());
						if(props[3].trim().equals("在职")){
							sale.setStatus("1");
						}else if(props[10].trim().equals("离职")){
							sale.setStatus("2");
						}else{
							sale.setStatus("2");
						}
						sale.setEmail(props[4].trim());
						sale.setCreatedDate(curTime);
						sale.setCreatedUser(userName);
						sale.setUpdatedDate(curTime);
						sale.setUpdatedUser(userName);
						sale.setValidInd("1");
						salesmanList.add(sale);
					}else{
						idexists.add(props[1].trim());
					}
				}
			}
			saveLawRateList(salesmanList);
			returnMap.put("result", "success");
			returnMap.put("existsIdCard", idexists);
			return returnMap;
		} catch (Exception e) {
			e.printStackTrace();
			returnMap.put("result", "error");
			return returnMap;
		}
	}
	
	// 批量导入
		private void saveLawRateList(final List<MediumSalesman> salesmanList) {
			for (MediumSalesman mediumSale : salesmanList) {
				saveOrUpdateByWhere(mediumSale);
			}
		}
		
		public boolean saveOrUpdateByWhere(MediumSalesman mediumSale) {
			Map<String, Object> whereMap = new HashMap<String, Object>();
			whereMap.put("idNumber", mediumSale.getIdNumber());
			boolean flag = false;
			// 判断数据库是否存在，存在作修改,不存在作添加
			if (this.isExistByWhere(whereMap)) {
				dao.update(MEDIUM_SALESMAN + ".updateByPrimaryKey", mediumSale);
				flag = true;
			} else {
				dao.insert(MEDIUM_SALESMAN + ".insertVo", mediumSale);
				flag = true;
			}
			return flag;
		}

		public boolean isExistByWhere(Map<String, Object> whereMap) {
			long count = (Long) dao.selectOne(MEDIUM_SALESMAN + ".queryCount", whereMap);
			return count > 0;
		}

		@Override
		public PageDto queryMediumSalesmanToPage(PageDto pageDto) {
			try {
				String curDeptCode = pageDto.getWhereMap().get("curDeptCode").toString();
				Map<String, Object> tt=null;
				if(curDeptCode.equals("00")){
					tt = dao.selectOne(MEDIUM_SALESMAN + ".queryListPage", pageDto.getWhereMap());
				}else{
					tt = dao.selectOne(MEDIUM_SALESMAN + ".queryDeptListPage", pageDto.getWhereMap());
				}
				Long total = Long.parseLong(tt.get("count").toString());
				pageDto.setTotal(total);
				if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
					pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
				} else {
					pageDto.getWhereMap().put("startpoint", 1);
				}
				pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
				List<Map<String, Object>> list=null;
				if(curDeptCode.equals("00")){
					list = dao.selectList(MEDIUM_SALESMAN + ".queryListPage", pageDto.getWhereMap());
				}else{
					list = dao.selectList(MEDIUM_SALESMAN + ".queryDeptListPage", pageDto.getWhereMap());
				}
				pageDto.setRows(list);
				return pageDto;
			} catch (Exception e) {
				e.printStackTrace();
				pageDto.setRows(null);
				return pageDto;
			}
		}
		
		public boolean downloadSalesmanModel(Map<String, Object> paramMap) {
			try {
				String savePath = paramMap.get("savePath").toString();
				// 设置excel头部
				List<String> rowList = new ArrayList<String>();
				StringBuffer rowData = new StringBuffer();
				rowData.append("姓名`");
				rowData.append("身份证号`");
				rowData.append("手机`");
				rowData.append("员工状态`");
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
		public boolean updateChange(List<MediumSalesman> rewardList) {
			try {
				IUserDetails curUserInfo = CurrentUser.getUser();
				String userName = curUserInfo.getUsername();
				String curTime = DateUtil.dateToStr(new Date());
				for (MediumSalesman medium : rewardList) {
					String status = medium.getStatus();
					if(status.equals("在职")){
						medium.setStatus("1");
					}else{
						medium.setStatus("2");
					}
					medium.setUpdatedDate(curTime);
					medium.setUpdatedUser(userName);
					this.saveOrUpdateByWhere(medium);
				}
				return true;
			} catch (Exception e) {
				e.printStackTrace();
				return false;
			}
		}

		@Override
		public void saveSalesmanAdd(Map<String, Object> paramMap) {
			try {
				dao.insert(MEDIUM_SALESMAN + ".saveSalesmanAdd", paramMap);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		@Override
		public int saveRowsApprove(List<String> pkIds) {
			
			Map<String, Object> param = null;
			int approveFail = 0;
			try {
				for (String pkId : pkIds) {
					param = new HashMap<String, Object>();
					param.put("i_pk_id", pkId);
					dao.selectOne(MEDIUM_SALESMAN + ".syncChannelSalesman", param);
					String resultCode = param.get("o_result_code").toString();
					if(resultCode.equals("1")){
						dao.update(MEDIUM_SALESMAN + ".updateRowsApprove", pkId);
					}else{
						approveFail +=1;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return approveFail;
		}

		@Override
		public boolean querySalesmanId(String idCard) {
			long count = 0;
			try {
				count = dao.selectOne(MEDIUM_SALESMAN + ".querySalesmanId", idCard);
			} catch (Exception e) {
				e.printStackTrace();
			}
			if(count>0){
				return false;
			}else{
				return true;
			}
		}
}
