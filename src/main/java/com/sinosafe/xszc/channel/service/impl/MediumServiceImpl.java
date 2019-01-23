package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL_MAIL_WARNING;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CONFER_PRODUCT_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_CONFER;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_CONFER_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_MAIN_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_NODE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LISTS_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_PARENT_MEDIUMS;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPLOAD;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.StringUtil;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.channel.service.ChannelMainService;
import com.sinosafe.xszc.channel.service.MediumContectService;
import com.sinosafe.xszc.channel.service.MediumService;
import com.sinosafe.xszc.channel.vo.ChannelMain;
import com.sinosafe.xszc.channel.vo.ChannelMediumContact;
import com.sinosafe.xszc.channel.vo.ChannelMediumDetail;
import com.sinosafe.xszc.upload.service.UploadService;
import com.sinosafe.xszc.upload.vo.Upload;
import com.sinosafe.xszc.util.PageDto;

public class MediumServiceImpl implements MediumService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier("ChannelMainService")
	private ChannelMainService channelMainService;

	@Autowired
	@Qualifier("MediumContectService")
	private MediumContectService mediumContectService;

	@Autowired
	@Qualifier("UploadService")
	private UploadService uploadService;

	@Autowired
	@Qualifier(value = "umService")
	private UmService umService;

	@Override
	public PageDto findMediumByWhere(PageDto pageDto) {
		Long total = dao.selectOne(MEDIUM + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MEDIUM + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void saveMedium(ChannelMain channelMain, ChannelMediumDetail channelMediumDetail, String uploadId) {
		// 给核心系统使用的两个字段赋值
		channelMain.setApproveFlag("0");
		channelMain.setCategory(channelMain.getChannelCategory());
		if (channelMain.getChannelOwnType() != null && !"".equals(channelMain.getChannelOwnType())) {
			channelMain.setProperty(channelMain.getChannelOwnType());
		} else if (channelMain.getChannelProperty() != null && !"".equals(channelMain.getChannelProperty())) {
			channelMain.setProperty(channelMain.getChannelProperty());
		} else {
			channelMain.setProperty(channelMain.getChannelType());
		}
		if ("".equals(channelMain.getFinanceFlag())) {
			channelMain.setFinanceFlag("0");
		}

		// 截取经办人工号：郑仲铭(104036723)
		String processUserCode = channelMediumDetail.getProcessUserCode();
		int beginIndex = processUserCode.indexOf("(");
		int endIndex = processUserCode.indexOf(")");
		channelMediumDetail.setProcessUserCode(processUserCode.substring(beginIndex + 1, endIndex));
		// 处理上级渠道字段
		String parentChannelCode = channelMediumDetail.getParentChannelCode();
		int pcIndex = parentChannelCode.indexOf("-");
		if (pcIndex != -1) {
			channelMediumDetail.setParentChannelCode(parentChannelCode.substring(0, pcIndex));
		} else {
			channelMediumDetail.setParentChannelCode("无");
		}

		// 生成渠道主键
		dao.getSqlSession().selectOne(MEDIUM + ".execProcedure", channelMain);
		channelMediumDetail.setChannelCode(channelMain.getChannelCode());

		// 保存中介主表信息
		channelMainService.saveChannelMain(channelMain);

		// 保存中介机构明细信息
		dao.insert(MEDIUM + INSERT_VO, channelMediumDetail);

		// 保存联系人信息
		if (channelMediumDetail.getChannelMediumContact().size() > 0) {
			for (ChannelMediumContact mediumContect : channelMediumDetail.getChannelMediumContact()) {
				// 生成主键
				String pkId = UUIDGenerator.getUUID();
				mediumContect.setContectId(pkId);
				mediumContect.setChannelCode(channelMediumDetail.getChannelCode());
				mediumContect.setCreatedUser(channelMediumDetail.getCreatedUser());
				mediumContect.setUpdatedUser(channelMediumDetail.getUpdatedUser());
				mediumContect.setValidInd("1");
				mediumContectService.saveMediumContect(mediumContect);
			}
		}

		// 保存附件信息
		Upload upload = new Upload();
		upload.setUploadId(uploadId);
		upload.setModule("01");
		upload.setMainId(channelMediumDetail.getChannelCode());
		upload.setName("中介机构证书");
		upload.setValidInd("1");
		upload.setCreatedUser(channelMediumDetail.getCreatedUser());
		upload.setUpdatedUser(channelMediumDetail.getCreatedUser());
		dao.insert(UPLOAD + INSERT_VO, upload);
	}

	@Override
	public PageDto findMediumsByWhere(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(MEDIUM + QUERY_LISTS_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void updateMedium(Map<String, Object> whereMap, ChannelMain channelMain, ChannelMediumDetail channelMediumDetail, String uploadId) {
		String historyId = UUIDGenerator.getUUID();
		String channelCode = channelMain.getChannelCode();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("historyId", historyId);
		map.put("channelCode", channelCode);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());

		// 如果查询到一条数据，则证明此记录没有被修改
		Long total = dao.selectOne(MEDIUM + ".queryCountForHistory", whereMap);
		if (total != 1) {// 如果该中介机构信息由更改，则保存历史信息
			// 保存中介主表历史信息
			dao.insert(MEDIUM_MAIN_HISTORY + ".insertData", map);
			// 保存中介机构明细历史信息
			dao.insert(MEDIUM_HISTORY + ".insertData", map);

			// 保存该中介机构当前所有协议到历史轨迹表中
			dao.insert(MEDIUM_CONFER_HISTORY + ".insertDatas", map);
			// 保存相关协议的所有产品到历史轨迹表中
			dao.insert(CONFER_PRODUCT_HISTORY + ".insertDatas", map);
		}

		// 处理经办人字段,如：李彦军(115069736)
		String processUserCode = channelMediumDetail.getProcessUserCode();
		int beginIndex = processUserCode.lastIndexOf("(");
		int endIndex = processUserCode.lastIndexOf(")");
		channelMediumDetail.setProcessUserCode(processUserCode.substring(beginIndex + 1, endIndex));
		// 处理上级渠道字段
		String parentChannelCode = channelMediumDetail.getParentChannelCode();
		int pcIndex = parentChannelCode.indexOf("-");
		if (pcIndex != -1) {
			channelMediumDetail.setParentChannelCode(parentChannelCode.substring(0, pcIndex));
		} else {
			channelMediumDetail.setParentChannelCode("无");
		}

		// 给核心系统使用的两个字段赋值
		channelMain.setCategory(channelMain.getChannelCategory());
		channelMain.setApproveFlag("0"); // 审核状态
		channelMain.setApproveCode(""); // 审核工号
		if (channelMain.getChannelOwnType() != null && !"".equals(channelMain.getChannelOwnType())) {
			channelMain.setProperty(channelMain.getChannelOwnType());
		} else if (channelMain.getChannelProperty() != null && !"".equals(channelMain.getChannelProperty())) {
			channelMain.setProperty(channelMain.getChannelProperty());
		} else {
			channelMain.setProperty(channelMain.getChannelType());
		}
		if ("".equals(channelMain.getFinanceFlag())) {
			channelMain.setFinanceFlag("0");
		}
		// 修改中介主表信息
		channelMainService.updateChannelMain(channelMain);
		// 修改中介明细信息
		dao.update(MEDIUM + UPDATE_VO, channelMediumDetail);
		// 修改中介网点
		dao.update(MEDIUM_NODE + ".updateDeptCodeByChannelCode", channelMain);
		// 修改中介协议(只修改经办机构、其他项要再协议页面修改，修改协议单独审核)
		dao.update(MEDIUM_CONFER + ".updateDeptCodeByChannelCode", channelMain);

		// 查询该中介数据库中原有的所有有效联系人
		List<ChannelMediumContact> idLists = mediumContectService.queryIdList(channelCode);

		// 保存联系人信息
		if (channelMediumDetail.getChannelMediumContact().size() > 0) {
			for (ChannelMediumContact mediumContect : channelMediumDetail.getChannelMediumContact()) {
				String pkId = mediumContect.getContectId();
				if (pkId != null && pkId != "") {// 修改联系人信息
					if (idLists.size() > 0) {
						// 拿前台返回的数据与后台数据库中原有的数据对比，如果匹配则从idLists中移除（idLists中是需要删除的数据）
						for (int i = 0; i < idLists.size(); i++) {
							ChannelMediumContact listCMC = idLists.get(i);
							if (mediumContect.getContectId().equals(listCMC.getContectId())) {
								idLists.remove(listCMC);
								continue;
							}
						}
					}
					mediumContect.setUpdatedUser(channelMediumDetail.getUpdatedUser());
					mediumContectService.updateMediumContect(mediumContect);
				} else {// 新增联系人
						// 生成主键
					pkId = UUIDGenerator.getUUID();
					mediumContect.setContectId(pkId);
					mediumContect.setChannelCode(channelCode);
					mediumContect.setCreatedUser(channelMediumDetail.getUpdatedUser());
					mediumContect.setUpdatedUser(channelMediumDetail.getUpdatedUser());
					mediumContect.setValidInd("1");
					mediumContectService.saveMediumContect(mediumContect);
				}
			}
		}

		String pkIds = "";
		Map<String, Object> map2 = new HashMap<String, Object>();
		for (int i = 0; i < idLists.size(); i++) {
			pkIds += "," + idLists.get(i).getContectId();
		}
		if (pkIds != "") {
			map2.put("updatedUser", CurrentUser.getUser().getUserCode());
			map2.put("pkIds", pkIds.substring(1).split(","));
			mediumContectService.deleteMediumContect(map2);
		}

		// 附件保存
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("mainId", channelCode);
		paramMap.put("module", "01");
		List<Map<String, Object>> resultList = uploadService.queryUploadByMainId(paramMap);

		Upload upload = new Upload();
		if (resultList.size() > 0) {
			// 修改附件信息
			upload.setUploadId(uploadId);
			upload.setUpdatedUser(channelMediumDetail.getUpdatedUser());
			dao.update(UPLOAD + ".updateByPrimaryKeySelectiveVo", upload);
		} else {
			// 保存附件信息
			upload.setUploadId(uploadId);
			upload.setModule("01");
			upload.setMainId(channelMediumDetail.getChannelCode());
			upload.setName("中介机构证书");
			upload.setValidInd("1");
			upload.setCreatedUser(channelMediumDetail.getCreatedUser());
			upload.setUpdatedUser(channelMediumDetail.getUpdatedUser());
			dao.insert(UPLOAD + INSERT_VO, upload);
		}
	}

	@Override
	public List<Map<String, Object>> queryParentMedium(String deptCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptCode", deptCode);
		List<Map<String, Object>> list = dao.selectList(MEDIUM + QUERY_PARENT_MEDIUMS, map);
		return list;
	}

	@Override
	public Boolean queryChannelCode(String channelCodeformMap) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("channelCode", channelCodeformMap);
		Long total = dao.selectOne(MEDIUM + QUERY_COUNT, map);
		if (total > 0) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public void deleteMediums(String channelCode) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("channelCode", channelCode);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		// 删除中介机构主表信息
		dao.update(CHANNEL + DELETE_BY_ID, map);
		// 删除中介机构附表信息
		dao.update(MEDIUM + DELETE_BY_ID, map);
		// 删除联系人表信息
		// dao.update(MEDIUM_CONTECT + DELETE_BY_ID, map);
		// 删除中介机构网点信息
		// dao.update(MEDIUM_NODE + DELETE_BY_ID, map);
		// 删除网点维护人信息
		// dao.update(CHANNEL_MAINTAIN + DELETE_BY_ID, map);
		// 删除网点出单点账号信息
		// dao.update(MEDIUM_NODE_ACCOUNT + DELETE_BY_ID, map);
		// 删除中介机构协议信息
		// dao.update(MEDIUM_CONFER + DELETE_BY_ID, map);
		// 删除中介机构协议产品信息
		// dao.update(CONFER_PRODUCT + DELETE_BY_ID, map);
		// 删除渠道相关邮件预警信息
		dao.update(CHANNEL_MAIL_WARNING + DELETE_BY_ID, map);
	}

	@Override
	public PageDto queryParentChannel(PageDto pageDto) {
		String deptCode = (String) pageDto.getWhereMap().get("deptCode");
		if (StringUtils.isBlank(deptCode)) {
			deptCode = (String) pageDto.getWhereMap().get("processDeptCode");
		}
		List<Map<String, Object>> list = dao.selectList(MEDIUM + ".queryAllParentDept", deptCode);
		list.remove(0);
		String allParentDept = "";
		for (Map<String, Object> map : list) {
			allParentDept += "," + map.get("deptCode");
		}
		if (allParentDept == "") {
			pageDto.getWhereMap().put("deptCode", "");
		} else {
			pageDto.getWhereMap().put("deptCode", allParentDept.substring(1).split(","));
		}

		Long total = dao.selectOne(MEDIUM + ".queryAllParentChannelCount", pageDto.getWhereMap());
		pageDto.setTotal(total + 1);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MEDIUM + ".queryAllParentChannel", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto queryMediumInfoByDeptCode(PageDto pageDto) {

		Long total = dao.selectOne(MEDIUM + ".queryAllMediumInfoCount", pageDto.getWhereMap());
		pageDto.setTotal(total + 1);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MEDIUM + ".queryMediumInfoByDeptCode", pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto queryChooseMedium(PageDto pageDto) {
		String threeDeptCode = pageDto.getWhereMap().get("threeDeptCode").toString();
		Long total = null;
		if(StringUtil.isNotEmpty(threeDeptCode)){
			total = dao.selectOne(MEDIUM + ".queryChooseMediumCountThree", pageDto.getWhereMap());
		}else{
			total = dao.selectOne(MEDIUM + ".queryChooseMediumCount", pageDto.getWhereMap());
		}
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows=null;
		if(StringUtil.isNotEmpty(threeDeptCode)){
			rows = dao.selectList(MEDIUM + ".queryChooseMediumThree", pageDto.getWhereMap());
		}else{
			rows = dao.selectList(MEDIUM + ".queryChooseMedium", pageDto.getWhereMap());
		}
		pageDto.setRows(rows);
		return pageDto;
	}

}
