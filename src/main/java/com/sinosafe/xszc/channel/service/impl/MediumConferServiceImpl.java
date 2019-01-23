package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.AGENT_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CONFER_PRODUCT_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CONFER_TURNOVER;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_CONFER;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_CONFER_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_MAIN_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_AGENT_LISTS_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_AGENT_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LISTS_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPLOAD;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.channel.service.ChannelMainService;
import com.sinosafe.xszc.channel.service.ConferProductService;
import com.sinosafe.xszc.channel.service.MediumConferService;
import com.sinosafe.xszc.channel.vo.ChannelConfer;
import com.sinosafe.xszc.channel.vo.ChannelConferProduct;
import com.sinosafe.xszc.group.service.SalesmanService;
import com.sinosafe.xszc.upload.service.UploadService;
import com.sinosafe.xszc.upload.vo.Upload;
import com.sinosafe.xszc.util.PageDto;

public class MediumConferServiceImpl implements MediumConferService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "ConferProductService")
	private ConferProductService conferProductService;

	@Autowired
	@Qualifier("UploadService")
	private UploadService uploadService;

	@Autowired
	@Qualifier(value = "SalesmanService")
	private SalesmanService salesmanService;

	@Autowired
	@Qualifier("ChannelMainService")
	private ChannelMainService channelMainService;

	@Override
	public void saveMediumConfer(ChannelConfer confer, String uploadId) {
		String conferId = "";
		String conferType = "";// 协议类型
		String deptCode = confer.getDeptCode().substring(0, 2);// 所属二级机构

		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd_hhmmss");
		Date date = new Date();
		// String year = date.toLocaleString().substring(0, 4);//年份
		String year = simpleDateFormat.format(date).substring(0, 4);

		String channelFg = confer.getGrantDept();
		// 保存附件信息
		Upload upload = new Upload();
		upload.setUploadId(uploadId);
		if (channelFg != null && !"".equals(channelFg)) {// 中介机构协议
			conferType = confer.getConferType();

			upload.setModule("02");
			upload.setName("中介机构协议证书");
		} else {// 个人代理协
			conferType = "B";
			confer.setConferType("B");// 个人代理协议默认类型就是代理协议

			upload.setModule("04");
			upload.setName("代理人协议证书");
		}

		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("conferType", conferType);
		map1.put("deptCode", deptCode);
		map1.put("year", year);
		Integer lastNumber = dao.selectOne(CONFER_TURNOVER + ".queryLastNumber", map1);
		if (lastNumber == null) {// 往该流水号管理表中新增一条数据
			lastNumber = 0;
			map1.put("pkId", UUIDGenerator.getUUID());
			map1.put("lastNumber", lastNumber);
			map1.put("createdUser", confer.getCreatedUser());
			map1.put("updatedUser", confer.getCreatedUser());
			dao.insert(CONFER_TURNOVER + ".insert", map1);
		} else {// 更新协议流水表
			lastNumber = lastNumber + 1;
			map1.put("lastNumber", lastNumber);
			map1.put("updatedUser", confer.getUpdatedUser());
			dao.update(CONFER_TURNOVER + ".updateByPrimaryKey", map1);
		}

		// 拼接五位有效流水码
		if (lastNumber < 10) {
			conferId = "0000" + lastNumber;
		} else if (lastNumber >= 10 && lastNumber < 100) {
			conferId = "000" + lastNumber;
		} else if (lastNumber >= 100 && lastNumber < 1000) {
			conferId = "00" + lastNumber;
		} else if (lastNumber >= 1000 && lastNumber < 10000) {
			conferId = "0" + lastNumber;
		} else {
			conferId = lastNumber.toString();
		}

		conferId = conferType + deptCode + year + conferId;
		confer.setConferId(conferId);
		confer.setConferCode(UUIDGenerator.getUUID());
		confer.setApproveFlag("0");
		dao.insert(MEDIUM_CONFER + INSERT_VO, confer);

		// 保存产品手续费信息
		if (confer.getChannelConferProduct().size() > 0) {
			for (ChannelConferProduct conferProduct : confer.getChannelConferProduct()) {
				// 生成主键
				conferProduct.setConferProductId(UUIDGenerator.getUUID());
				conferProduct.setConferCode(confer.getConferCode());
				conferProduct.setExtendConferCode(confer.getExtendConferCode());
				conferProduct.setConferId(confer.getConferId());
				conferProduct.setCreatedUser(confer.getCreatedUser());
				conferProduct.setUpdatedUser(confer.getCreatedUser());
				conferProduct.setValidInd("1");
				conferProductService.saveConferProduct(conferProduct);
			}
		}
//		Map<String, Object> noTaxRate = new HashMap<String, Object>();
//		noTaxRate.put("conferCode", confer.getConferCode());
//		noTaxRate.put("paymentTax", confer.getPaymentTax());
//		conferProductService.updateNoTaxRate(noTaxRate);

		upload.setMainId(confer.getConferCode());
		upload.setValidInd("1");
		upload.setCreatedUser(confer.getCreatedUser());
		upload.setUpdatedUser(confer.getUpdatedUser());
		dao.insert(UPLOAD + INSERT_VO, upload);

		// 重置渠道数据的审核状态
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("approveFlag", '0');
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		map.put("channelCodes", confer.getChannelCode().split(","));
		dao.update(CHANNEL + ".approveChannel", map);
	}

	@Override
	public PageDto findMediumConferByWhere(PageDto pageDto) {
		Long total = dao.selectOne(MEDIUM_CONFER + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_CONFER + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void updateMediumConfer(ChannelConfer confer, String uploadId, String updateFlag) {
		String historyId = UUIDGenerator.getUUID();
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("historyId", historyId);
		map1.put("channelCode", confer.getChannelCode());
		map1.put("conferCode", confer.getConferCode());
		map1.put("updatedUser", CurrentUser.getUser().getUserCode());

		String channelFg = confer.getGrantDept();
		// 如果查询到一条数据，则证明此记录没有被修改
		Long total = dao.selectOne(MEDIUM_CONFER + ".queryCountForHistory", confer);
		if (total != 1 || "1".equals(updateFlag)) {
			// 保存渠道主表历史信息
			dao.insert(MEDIUM_MAIN_HISTORY + ".insertData", map1);
			if (channelFg != null && !"".equals(channelFg)) {
				// 保存中介机构明细历史信息
				dao.insert(MEDIUM_HISTORY + ".insertData", map1);
			} else {
				// 保存代理人明细历史信息
				dao.insert(AGENT_HISTORY + ".insertData", map1);
			}

			// 保存协议信息到历史表
			dao.insert(MEDIUM_CONFER_HISTORY + ".insertData", map1);
			// 保存相关协议的所有产品到历史轨迹表中
			dao.insert(CONFER_PRODUCT_HISTORY + ".insertData", map1);
		}

		confer.setApproveFlag("0");
		confer.setApproveCode("");
		// 修改协议信息
		dao.update(MEDIUM_CONFER + UPDATE_PK_VO, confer);

		// 查询该中介数据库中原有的所有有效产品信息
		// List<ChannelConferProduct> idLists = conferProductService.queryIdList(confer.getConferCode());

		// 保存产品手续费信息
		if (confer.getChannelConferProduct().size() > 0) {
			for (ChannelConferProduct conferProduct : confer.getChannelConferProduct()) {
				String pkId = conferProduct.getConferProductId();
				if (pkId != null && pkId != "") {// 修改维护人信息
					/*
					 * if(idLists.size() > 0){ //拿前台返回的数据与后台数据库中原有的数据对比，如果匹配则从idLists中移除（idLists中是需要删除的数据） 
					 * for(int i = 0;i < idLists.size();i++){
					 * ChannelConferProduct listCMC = idLists.get(i); if(conferProduct.getConferProductId().equals(listCMC.getConferProductId())){
					 * idLists.remove(listCMC); continue; } } }
					 */
					conferProduct.setUpdatedUser(confer.getUpdatedUser());
					conferProductService.updateConferProduct(conferProduct);
				} else {// 新增产品手续费信息
						// 生成主键
					pkId = UUIDGenerator.getUUID();
					conferProduct.setConferProductId(pkId);
					conferProduct.setConferCode(confer.getConferCode());
					conferProduct.setExtendConferCode(confer.getExtendConferCode());
					conferProduct.setConferId(confer.getConferId());
					conferProduct.setCreatedUser(confer.getUpdatedUser());
					conferProduct.setUpdatedUser(confer.getUpdatedUser());
					conferProduct.setValidInd("1");
					conferProductService.saveConferProduct(conferProduct);
				}
			}
		}
		
		/*
		 * String pkIds = ""; Map<String,Object> map = new HashMap<String,Object>(); for(int i = 0;i < idLists.size();i++){ pkIds +=
		 * ","+idLists.get(i).getConferProductId(); } if(pkIds != ""){ map.put("updatedUser", CurrentUser.getUser().getUserCode()); map.put("pkIds",
		 * pkIds.substring(1).split(",")); conferProductService.deleteConferProduct(map); }
		 */

		// 附件保存
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("mainId", confer.getConferCode());
		if (channelFg != null && !"".equals(channelFg)) {
			paramMap.put("module", "02");
		} else {
			paramMap.put("module", "04");
		}
		List<Map<String, Object>> resultList = uploadService.queryUploadByMainId(paramMap);

		Upload upload = new Upload();
		if (resultList.size() > 0) {
			// 修改附件信息
			upload.setUploadId(uploadId);
			upload.setUpdatedUser(confer.getUpdatedUser());
			dao.update(UPLOAD + ".updateByPrimaryKeySelectiveVo", upload);
		} else {
			// 保存附件信息
			upload.setUploadId(uploadId);
			if (channelFg != null && !"".equals(channelFg)) {
				upload.setModule("02");
				upload.setName("中介机构协议证书");
			} else {
				upload.setModule("04");
				upload.setName("代理人协议证书");
			}
			upload.setMainId(confer.getConferCode());
			upload.setValidInd("1");
			upload.setCreatedUser(confer.getCreatedUser());
			upload.setUpdatedUser(confer.getUpdatedUser());
			dao.insert(UPLOAD + INSERT_VO, upload);
		}

		// 重置渠道数据的审核状态
		/*
		 * Map<String,Object> channelMap = new HashMap<String,Object>(); channelMap.put("approveFlag", '0'); channelMap.put("updatedUser",
		 * CurrentUser.getUser().getUserCode()); channelMap.put("channelCodes", confer.getChannelCode().split(",")); dao.update(CHANNEL + ".approveChannel",
		 * channelMap);
		 */

		/* 保存渠道邮件预警
		ChannelMailWarning channelMailWarning = new ChannelMailWarning();
		channelMailWarning.setChannelCode(confer.getChannelCode());
		channelMailWarning.setConferCode(confer.getConferCode());
		// channelMailWarning.setSendDate(confer.getExpireDate());
		channelMailWarning.setSendStatus("0");
		channelMailWarning.setTaskType("3");
		channelMailWarning.setUpdatedUser(confer.getUpdatedUser());
		dao.update(CHANNEL_MAIL_WARNING + UPDATE_VO, channelMailWarning);*/
	}

	@Override
	public PageDto findMediumConfersByWhere(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_CONFER + QUERY_LISTS_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public void deleteMediumConfer(String conferCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("conferCode", conferCode);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());

		// 先逻辑删除相关明细
		conferProductService.deleteConferProducts(map);

		// 然后逻辑删除相关证书
		dao.update(UPLOAD + DELETE_BY_ID, map);

		// 最后逻辑删除该协议
		dao.update(MEDIUM_CONFER + DELETE_BY_ID, map);

		/*删除邮件预警信息
		dao.update(CHANNEL_MAIL_WARNING + DELETE_BY_ID, map);*/
	}

	@Override
	public PageDto findAgentConferByWhere(PageDto pageDto) {
		Long total = dao.selectOne(MEDIUM_CONFER + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_CONFER + QUERY_AGENT_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public PageDto findAgentConfersByWhere(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_CONFER + QUERY_AGENT_LISTS_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Boolean queryConferCode(String conferCode) {
		Long total = dao.selectOne(MEDIUM_CONFER + ".queryConferCode", conferCode);
		if (total > 0) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public PageDto findMediumConferHistorysByWhere(PageDto pageDto) {
		Long total = dao.selectOne(MEDIUM_CONFER_HISTORY + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_CONFER_HISTORY + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public List<Map<String, Object>> findMediumConferHistoryByWhere(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_CONFER_HISTORY + QUERY_LISTS_PAGE, pageDto.getWhereMap());
		return rows;
	}

	@Override
	public PageDto findAgentConferHistorysByWhere(PageDto pageDto) {
		Long total = dao.selectOne(MEDIUM_CONFER_HISTORY + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_CONFER_HISTORY + QUERY_AGENT_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public List<Map<String, Object>> findAgentConferHistoryByWhere(PageDto pageDto) {
		List<Map<String, Object>> rows = dao.selectList(MEDIUM_CONFER_HISTORY + QUERY_AGENT_LISTS_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return rows;
	}

	@Override
	public Map<String, String> processConfers(String conferCodes, String channelCode) {
		String userCode = CurrentUser.getUser().getUserCode();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("approveFlag", '1');
		map.put("approveCode", userCode);
		map.put("updatedUser", CurrentUser.getUser().getUserCode());
		map.put("conferCodes", conferCodes.split(","));
		dao.update(MEDIUM_CONFER + ".approveConfer", map);
		return channelMainService.channelSync(channelCode.split(","));
	}
}
