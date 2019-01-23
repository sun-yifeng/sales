package com.sinosafe.xszc.channel.service;

import java.util.List;
import java.util.Map;

import com.sinosafe.xszc.channel.vo.ChannelMediumNode;
import com.sinosafe.xszc.util.PageDto;

public interface MediumNodeService {

	Map<String, String> saveMediumNode(ChannelMediumNode mediumNode);

	Map<String, String> updateMediumNode(ChannelMediumNode mediumNode);

	PageDto findMediumNodeByWhere(PageDto pageDto);

	PageDto findMediumNodesByWhere(PageDto pageDto);

	Boolean queryChannelCode(String nodeCode);

	PageDto findMediumNodeAccountByWhere(PageDto pageDto);

	List<Map<String, Object>> queryDeptSalesman(Map<String, Object> userMap);

	void deleteMediumNode(String nodeCode, String channelCode);

	void closeMediumNode(String nodeCode, String channelCode);

	List<Map<String, Object>> querySalesmanEmpCode(Map<String, Object> userMap);

	List<Map<String, Object>> queryDeptVirSalesman(Map<String, Object> userMap);

	List<Map<String, Object>> queryAllSalesmans(Map<String, Object> userMap);

}
