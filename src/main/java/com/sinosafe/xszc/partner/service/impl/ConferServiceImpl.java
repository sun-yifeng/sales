package com.sinosafe.xszc.partner.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CONFER;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CONFER_TURNOVER;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_CONFER;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;

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
import com.sinosafe.xszc.partner.service.ConferProductService;
import com.sinosafe.xszc.partner.service.ConferService;
import com.sinosafe.xszc.partner.vo.Confer;
import com.sinosafe.xszc.partner.vo.ConferProduct;
import com.sinosafe.xszc.util.PageDto;

public class ConferServiceImpl implements ConferService {

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	@Autowired
	@Qualifier(value = "ConferProductService1")
	private ConferProductService conferProductService;

	@Override
	public PageDto findConferByWhere(PageDto pageDto) {
		Long total = dao.selectOne(CONFER + QUERY_COUNT, pageDto.getWhereMap());
		pageDto.setTotal(total);
		if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
			pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
		} else {
			pageDto.getWhereMap().put("startpoint", 1);
		}
		pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
		List<Map<String, Object>> rows = dao.selectList(CONFER + QUERY_LIST_PAGE, pageDto.getWhereMap());
		pageDto.setRows(rows);
		return pageDto;
	}

	@Override
	public Map<String, Object> findEnterpriseConferByPk(String conferId) {
		Map<String, Object> resultMap = dao.selectOne(CONFER + ".selectEnterpriseByPK", conferId);
		return resultMap;
	}
	
	@Override
	public Map<String, Object> findIndividualConferByPk(String conferId) {
		Map<String, Object> resultMap = dao.selectOne(CONFER + ".selectIndividualByPK", conferId);
		return resultMap;
	}

	@Override
	public void saveConfer(Confer confer) {
		String conferId = "", conferType = "H";
		String deptCode = confer.getDeptCode().substring(0, 2);// 所属二级机构

		Date date = new Date();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd_hhmmss");
		String year = simpleDateFormat.format(date).substring(0, 4);

		confer.setConferType(conferType);
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("year", year);
		map1.put("conferType", conferType);
		map1.put("deptCode", deptCode);
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
		if (confer.getConferProduct().size() > 0) {
			for (ConferProduct conferProduct : confer.getConferProduct()) {
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

		// 重置渠道数据的审核状态
		Map<String, Object> map = new HashMap<String, Object>();
		//当渠道为外部渠道(企业合作伙伴或个人合作伙伴)添加新协议的时候,才重置渠道数据的审核状态
		if("2".equals(confer.getChannelFlag()) || "3".equals(confer.getChannelFlag())){
			map.put("approveFlag", '0');
			map.put("updatedUser", CurrentUser.getUser().getUserCode());
			map.put("channelCodes", confer.getChannelCode().split(","));
			dao.update(CHANNEL + ".approveChannel", map);
		}
	}

	@Override
	public void updateConfer(Confer confer, String updateFlag) {
		confer.setApproveFlag("0");
		confer.setApproveCode("");

		// 修改协议信息
		dao.update(MEDIUM_CONFER + UPDATE_PK_VO, confer);

		// 保存产品手续费信息
		if (confer.getConferProduct().size() > 0) {
			for (ConferProduct conferProduct : confer.getConferProduct()) {
				String pkId = conferProduct.getConferProductId();
				if (pkId != null && pkId != "") {
					conferProduct.setUpdatedUser(confer.getUpdatedUser());
					conferProductService.updateConferProduct(conferProduct);
				} else {
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

	}

}
