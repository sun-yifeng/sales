package com.sinosafe.xszc.channel.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.AGENT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.AGENT_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CHANNEL;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.CONFER_PRODUCT_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.DELETE_BY_ID;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_CONFER;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_CONFER_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.MEDIUM_MAIN_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_COUNT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LISTS_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LIST_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPLOAD;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.channel.service.AgentService;
import com.sinosafe.xszc.channel.service.ChannelMainService;
import com.sinosafe.xszc.channel.service.MediumContectService;
import com.sinosafe.xszc.channel.vo.ChannelAgentDetail;
import com.sinosafe.xszc.channel.vo.ChannelMain;
import com.sinosafe.xszc.channel.vo.ChannelMediumContact;
import com.sinosafe.xszc.upload.service.UploadService;
import com.sinosafe.xszc.upload.vo.Upload;
import com.sinosafe.xszc.util.PageDto;

public class AgentServiceImpl implements AgentService {

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
  public PageDto findAgentByWhere(PageDto pageDto) {
    Long total = dao.selectOne(AGENT + QUERY_COUNT, pageDto.getWhereMap());
    pageDto.setTotal(total);
    if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
      pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
    } else {
      pageDto.getWhereMap().put("startpoint", 1);
    }
    pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
    List<Map<String, Object>> rows = dao.selectList(AGENT + QUERY_LIST_PAGE, pageDto.getWhereMap());
    pageDto.setRows(rows);
    return pageDto;
  }

  @Override
  public void saveAgent(ChannelMain channelMain, ChannelAgentDetail channelAgentDetail, String uploadId) {
    channelMain.setApproveFlag("0");
    channelMain.setCategory(channelMain.getChannelCategory());
    channelMain.setProperty(channelMain.getChannelType());
    if ("".equals(channelMain.getFinanceFlag())) {
      channelMain.setFinanceFlag("0");
    }

    // 生成渠道主键
    dao.getSqlSession().selectOne(MEDIUM + ".execProcedure", channelMain);
    channelAgentDetail.setChannelCode(channelMain.getChannelCode());

    // 保存个人代理主表信息
    channelMainService.saveChannelMain(channelMain);

    // 保存个人代理明细信息
    dao.insert(AGENT + INSERT_VO, channelAgentDetail);
    /*新增个人代理人时，前台录入“个人代理人执业证号”后，后台将“个人代理人资格证号”指定为与执业证号相同。见米宏志2015-10-12 09:06的邮件。
    channelAgentDetail.setLicenseNo(channelAgentDetail.getQualificationNo());
    channelAgentDetail.setLicenseValidDate(channelAgentDetail.getQualificationValidDate());
    channelAgentDetail.setLicenseExpireDate(channelAgentDetail.getQualificationExpireDate());
    */
    
    // 保存联系人信息
    if (channelAgentDetail.getChannelMediumContact().size() > 0) {
      for (ChannelMediumContact mediumContect : channelAgentDetail.getChannelMediumContact()) {
        // 生成主键
        String pkId = UUIDGenerator.getUUID();
        mediumContect.setContectId(pkId);
        mediumContect.setChannelCode(channelAgentDetail.getChannelCode());
        mediumContect.setCreatedUser(channelAgentDetail.getCreatedUser());
        mediumContect.setUpdatedUser(channelAgentDetail.getUpdatedUser());
        mediumContect.setValidInd("1");
        mediumContectService.saveMediumContect(mediumContect);
      }
    }   

    // 保存附件信息
    Upload upload = new Upload();
    upload.setUploadId(uploadId);
    upload.setModule("03");
    upload.setMainId(channelAgentDetail.getChannelCode());
    upload.setName("代理人证书");
    upload.setValidInd("1");
    upload.setCreatedUser(channelAgentDetail.getCreatedUser());
    upload.setUpdatedUser(channelAgentDetail.getUpdatedUser());
    dao.insert(UPLOAD + INSERT_VO, upload);
  }

  @Override
  public PageDto findAgentsByWhere(PageDto pageDto) {
    List<Map<String, Object>> rows = dao.selectList(AGENT + QUERY_LISTS_PAGE, pageDto.getWhereMap());
    pageDto.setRows(rows);
    return pageDto;
  }

  @Override
  public void updateAgent(Map<String, Object> whereMap, ChannelMain channelMain, ChannelAgentDetail channelAgentDetail, String uploadId) {
    String historyId = UUIDGenerator.getUUID();
    String channelCode = channelMain.getChannelCode();
    if ("".equals(channelMain.getFinanceFlag())) {
      channelMain.setFinanceFlag("0");
    }

    Map<String, Object> map = new HashMap<String, Object>();
    map.put("historyId", historyId);
    map.put("channelCode", channelCode);
    map.put("updatedUser", CurrentUser.getUser().getUserCode());

    // 如果查询到一条数据，则证明此记录没有被修改
    Long total = dao.selectOne(AGENT + ".queryCountForHistory", whereMap);
    if (total != 1) {// 如果该代理人信息由更改，则保存历史信息
      // 保存代理人主表历史信息
      dao.insert(MEDIUM_MAIN_HISTORY + ".insertData", map);
      // 保存代理人明细历史信息
      dao.insert(AGENT_HISTORY + ".insertData", map);
      // 保存该中介机构当前所有协议到历史轨迹表中
      dao.insert(MEDIUM_CONFER_HISTORY + ".insertDatas", map);
      // 保存相关协议的所有产品到历史轨迹表中
      dao.insert(CONFER_PRODUCT_HISTORY + ".insertDatas", map);
    }

    // 修改代理人信息
    channelMain.setCategory(channelMain.getChannelCategory());
    channelMain.setProperty(channelMain.getChannelType());
    channelMain.setApproveFlag("0"); //未审核
    channelMain.setApproveCode("");  //审核人
    //修改个人代理主表信息
    channelMainService.updateChannelMain(channelMain);
    
    //修改个人代理明细信息
    dao.update(AGENT + UPDATE_VO, channelAgentDetail);
    /*修改个人代理人时，前台录入“个人代理人执业证号”后，后台将“个人代理人资格证号”指定为与执业证号相同。见米宏志2015-10-12 09:06的邮件。
    channelAgentDetail.setLicenseNo(channelAgentDetail.getQualificationNo());
    channelAgentDetail.setLicenseValidDate(channelAgentDetail.getQualificationValidDate());
    channelAgentDetail.setLicenseExpireDate(channelAgentDetail.getQualificationExpireDate());
    */
    
    //修改中介协议的经办机构(只修改经办机构，其他项要再协议页面修改，修改协议单独审核)
    dao.update(MEDIUM_CONFER + ".updateDeptCodeByChannelCode", channelMain);
    
    // 查询该中介数据库中原有的所有有效联系人
    List<ChannelMediumContact> idLists = mediumContectService.queryIdList(channelCode);

    // 保存联系人信息
    if (channelAgentDetail.getChannelMediumContact().size() > 0) {
      for (ChannelMediumContact mediumContect : channelAgentDetail.getChannelMediumContact()) {
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
          mediumContect.setUpdatedUser(channelAgentDetail.getUpdatedUser());
          mediumContectService.updateMediumContect(mediumContect);
        } else {// 新增联系人
            // 生成主键
          pkId = UUIDGenerator.getUUID();
          mediumContect.setContectId(pkId);
          mediumContect.setChannelCode(channelCode);
          mediumContect.setCreatedUser(channelAgentDetail.getUpdatedUser());
          mediumContect.setUpdatedUser(channelAgentDetail.getUpdatedUser());
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
    paramMap.put("module", "03");
    List<Map<String, Object>> resultList = uploadService.queryUploadByMainId(paramMap);

    Upload upload = new Upload();
    if (resultList.size() > 0) {
      // 修改附件信息
      upload.setUploadId(uploadId);
      upload.setUpdatedUser(channelAgentDetail.getUpdatedUser());
      dao.update(UPLOAD + ".updateByPrimaryKeySelectiveVo", upload);
    } else {
      // 保存附件信息
      upload.setUploadId(uploadId);
      upload.setModule("03");
      upload.setMainId(channelAgentDetail.getChannelCode());
      upload.setName("代理人证书");
      upload.setValidInd("1");
      upload.setCreatedUser(channelAgentDetail.getCreatedUser());
      upload.setUpdatedUser(channelAgentDetail.getUpdatedUser());
      dao.insert(UPLOAD + INSERT_VO, upload);
    }
  }

  @Override
  public Boolean queryChannelCode(String channelCodeformMap) {
    Map<String, Object> map = new HashMap<String, Object>();
    map.put("channelCode", channelCodeformMap);
    Long total = dao.selectOne(AGENT + QUERY_COUNT, map);
    if (total > 0) {
      return true;
    } else {
      return false;
    }
  }

  @Override
  public void deleteChannelAgents(String channelCode) {
    Map<String, Object> map = new HashMap<String, Object>();
    map.put("channelCode", channelCode);
    map.put("updatedUser", CurrentUser.getUser().getUserCode());
    // 删除代理人主表信息
    dao.update(CHANNEL + DELETE_BY_ID, map);
    // 删除代理人附表信息
    dao.update(AGENT + DELETE_BY_ID, map);
  }
  
  @Override
  public boolean queryChannelLicenseValid(String deptCode) {
    return (Long)dao.selectOne(AGENT + ".queryChannelLicenseValid", deptCode) > 0;
  }
}
