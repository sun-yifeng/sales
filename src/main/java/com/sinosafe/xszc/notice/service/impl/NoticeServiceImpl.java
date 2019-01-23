package com.sinosafe.xszc.notice.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.NOTICE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.NOTICE_DEPT;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.NOTICE_FEEDBACK;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.NOTICE_MISSION;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_LISTS_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_NOTICE_FOR_DEAL_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_NOTICE_FOR_FEEDBACK_PAGE;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.QUERY_WITHOUT_WEEK;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPLOAD;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.core.context.PlatformContext;
import com.hf.framework.dao.CommonDao;
import com.hf.framework.service.mail.Mail;
import com.hf.framework.service.mail.MailService;
import com.hf.framework.service.mail.MailType;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.notice.service.NoticeService;
import com.sinosafe.xszc.util.FillCommonInfo;
import com.sinosafe.xszc.util.MailUtil;
import com.sinosafe.xszc.util.PageDto;

/**
 * 
 * 类名:com.sinosafe.xszc.Notice.service.impl.NoticeServiceImpl
 * 
 * <pre>
 * 描述:活动管理业务实现
 * 基本思路:
 * 特别说明:
 * 编写者:mg
 * 创建时间:2014年6月19日 上午11:03:48
 * 修改说明: 类的修改说明
 * </pre>
 */
public class NoticeServiceImpl implements NoticeService {

  @Autowired
  @Qualifier(value = "baseDao")
  private CommonDao dao;

  @Autowired
  @Qualifier(value = "umService")
  private UmService umService;

  @Autowired
  @Qualifier(value = "mailService")
  private MailService mailService;

  public static final String MAIL_FROM = (String) PlatformContext.getGoalbalContext("mail.username");

  public static final String SPECIAL_CHAR = "[`~!@#$%^&*+=|{}',:;\"[url=file://\\[\\].<]\\[\\].<>/[/url]?～！＠＃￥％……＆×（）——＋｜｛｝［］‘；：＂。，、．＜＞／？]";

  @Override
  public PageDto findNoticeByWhere(PageDto pageDto, String action) {
    // 这里加入了,publisher , dept_code 的 条件,而且这两个参数不能为空.
    String querysqlcount = "";
    String querysql = "";
    if ("peroidOnce".equalsIgnoreCase(action)) {
      querysqlcount = NOTICE + ".ONCE_queryCount";
      querysql = NOTICE + ".ONCE_queryListPage";
    } else if ("peroidQuery".equalsIgnoreCase(action)) {
      querysqlcount = NOTICE + ".PERIOD_queryCount";
      querysql = NOTICE + ".PERIOD_queryListPage";
    } else {
      querysqlcount = NOTICE + ".queryCount";
      querysql = NOTICE + ".queryListPage";
    }
    Long total = dao.selectOne(querysqlcount, pageDto.getWhereMap());
    pageDto.setTotal(total);
    if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
      pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
    } else {
      pageDto.getWhereMap().put("startpoint", 1);
    }
    pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
    List<Map<String, Object>> rows = dao.selectList(querysql, pageDto.getWhereMap());

    pageDto.setRows(rows);
    return pageDto;
  }

  /**
   * 查询按日月年发布的公告
   */
  @Override
  public List<Map<String, Object>> findNoticeWithoutWeek() {
    Map<String, Object> whereMap = new HashMap<String, Object>();

    List<Map<String, Object>> resultList = dao.selectList(NOTICE + QUERY_WITHOUT_WEEK, whereMap);

    return resultList;
  }

  /**
   * 替换特殊字符(全角&半角)
   * 
   * @param srcString
   * @return
   * @throws PatternSyntaxException
   */
  public String StringFilter(String srcString) throws PatternSyntaxException {

    return Pattern.compile(SPECIAL_CHAR).matcher(srcString).replaceAll("").replaceAll("[url=]\\\\[/url]", "").trim();

  }

  @Override
  public Map<String, Object> findNoticeDetailByWhere(Map<String, Object> whereMap) {
    Map<String, Object> resultMap = new HashMap<String, Object>();
    Map<String, Object> resultMap1 = new HashMap<String, Object>();
    List<Map<String, Object>> resultList = dao.selectList(NOTICE + QUERY, whereMap);
    if (resultList != null && resultList.size() > 0) {
      resultMap = resultList.get(0);
      String resultDept = "", resultRole = "";
      List<Map<String, Object>> resultDepts = dao.selectList(NOTICE_DEPT + QUERY, whereMap);
      if (resultDepts != null && resultDepts.size() > 0) {
        resultMap1 = resultDepts.get(0);
        resultRole = (String) resultMap1.get("ROLE_CODE");
      }
      // resultRole = (String) resultDepts.get(0).get("ROLE_CODE");
      for (Map<String, Object> forDept : resultDepts) {
        resultDept += forDept.get("deptCode") + ",";
      }
      // 去除掉公告内容中的特殊字符(全角&半角)
      resultMap.put("content", StringFilter((String) resultMap.get("content")));
      resultMap.put("depts", resultDept);
      resultMap.put("roles", resultRole);
    }
    return resultMap;
  }

  @Override
  public Map<String, Object> findNoticeFeeBackDetailByWhere(Map<String, Object> whereMap) {
    Map<String, Object> resultMap = new HashMap<String, Object>();
    List<Map<String, Object>> rows = dao.selectList(NOTICE_FEEDBACK + QUERY_LISTS_PAGE, whereMap);
    resultMap = rows.get(0);
    return resultMap;
  }

  @Override
  public PageDto findNoticeFeedbackByWhere(PageDto pageDto) {
    Map<String, Object> tt = dao.selectOne(NOTICE_FEEDBACK + QUERY_NOTICE_FOR_FEEDBACK_PAGE, pageDto.getWhereMap());

    if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
      pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
    } else {
      pageDto.getWhereMap().put("startpoint", 1);
    }
    pageDto.getWhereMap().put("endpoint", pageDto.getEnd());

    List<Map<String, Object>> rows = dao.selectList(NOTICE_FEEDBACK + QUERY_NOTICE_FOR_FEEDBACK_PAGE, pageDto.getWhereMap());
    List<Map<String, Object>> newRows = new ArrayList<Map<String, Object>>();
    // 获取登录人的角色权限
    String userCode = CurrentUser.getUser().getUserCode();
    String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
    List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);
    String flag_noticeId = "";
    for (Map<String, Object> map : rows) {
      List<String> listRoleNames = new ArrayList<String>();
      String feedbackType = map.get("feedbackType").toString();
      String noticeId = map.get("noticId").toString();
      if (feedbackType.equals("1") && roleCodeList.size() > 1) {
        Map<String, Object> whereMap = new HashMap<String, Object>();
        List<String> roleNameList = new ArrayList<String>();
        for (Map<String, Object> map2 : roleCodeList) {
          Map<String, Object> whereMapRoles = new HashMap<String, Object>();
          String roleName = map2.get("roleEname").toString();
          roleNameList.add(roleName);
          String sendRoleName = (String) map.get("noticId");
          whereMapRoles.put("noticeId", sendRoleName);
          whereMapRoles.put("deptCode", pageDto.getWhereMap().get("deptCode"));
          List<Map<String, Object>> sendRoles = dao.selectList(NOTICE_FEEDBACK + ".queryRoleNames", whereMapRoles);
          for (Map<String, Object> map3 : sendRoles) {
            String roles = map3.get("roleCode").toString();
            String[] role = roles.split(",");
            for (int i = 0; i < role.length; i++) {
              if (roleName.equals(role[i])) {
                listRoleNames.add(roleName);
              }
            }
          }
        }
        whereMap.put("noticId", noticeId);
        whereMap.put("roleCode", roleNameList);
        Long num = (Long) dao.selectOne(NOTICE_FEEDBACK + ".getFeedbackCount", whereMap);
        if (num > 1) {
          Map<String, Object> whereMapNew = new HashMap<String, Object>();
          whereMapNew.put("noticId", noticeId);
          whereMapNew.put("deptCode", pageDto.getWhereMap().get("deptCode"));
          // 获取该条公告接收人任意的一个角色代码
          whereMapNew.put("roleCode", listRoleNames.get(0));
          Map<String, Object> dataSource = dao.selectOne(NOTICE_FEEDBACK + ".queryFeedbackData", whereMapNew);
          if (!noticeId.equals(flag_noticeId) && com.hf.framework.util.StringUtil.isNotEmpty(noticeId)) {
            newRows.add(dataSource);
          }
          flag_noticeId = noticeId;
        }
        if (num == 1) {
          newRows.add(map);
        }
      } else {
        if (com.hf.framework.util.StringUtil.isNotEmpty(noticeId)) {
          newRows.add(map);
        }
      }
    }
    Long total = (long) newRows.size();
    pageDto.setTotal(total);
    pageDto.setRows(newRows);
    return pageDto;
  }

  @Override
  public PageDto findNoticeForDealByWhere(PageDto pageDto) {
    Map<String, Object> tt = dao.selectOne(NOTICE + QUERY_NOTICE_FOR_DEAL_PAGE, pageDto.getWhereMap());

    Long total = Long.parseLong(tt.get("count").toString());
    pageDto.setTotal(total);

    if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
      pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
    } else {
      pageDto.getWhereMap().put("startpoint", 1);
    }
    pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
    List<Map<String, Object>> rows = dao.selectList(NOTICE + QUERY_NOTICE_FOR_DEAL_PAGE, pageDto.getWhereMap());
    pageDto.setRows(rows);
    return pageDto;
  }

  /**
   * 这是按notice找反馈,就是找到反馈ID的一条数据.进行处理
   * 
   */
  @Override
  public Map<String, Object> findNoticeFeedbackForDeal(String feedbackId) {
    Map<String, Object> resultMap = new HashMap<String, Object>();
    resultMap = dao.selectOne(NOTICE_FEEDBACK + ".selectByPrimaryKey", feedbackId);
    return resultMap;
  }

  @Override
  public Boolean saveNotice(Map<String, Object> paraMap) {

    Date currentDate = new Date();
    String userCode = CurrentUser.getUser().getUserCode();
    Map<String, Object> dbMap = null;

    if (paraMap.get("noticId") == null) {
      paraMap.put("noticId", UUIDGenerator.getUUID());
    }
    try {
      paraMap.put("publishDate", new SimpleDateFormat("yyyy-MM-dd").parse((String) paraMap.get("publishDate")));
    } catch (ParseException e1) {
      e1.printStackTrace();
    }
    // 状态：0-暂存草稿，1-下发
    // paraMap.put("status", (String) paraMap.get("pubstat"));
    paraMap.put("missionId", UUIDGenerator.getUUID());
    paraMap.put("createdUser", userCode);
    paraMap.put("createdDate", currentDate);
    paraMap.put("updatedUser", userCode);
    paraMap.put("updatedDate", currentDate);
    paraMap.put("validInd", "1");

    // 下一次发布的时间，周期：1-每年，2-半年，3-每季度，4-每月，5-每周，6-每日
    String period = (String) paraMap.get("period");
    String months = null;
    String days = null;
    if (period != null) {
      if ("1".equals(period)) { // 周期-年
        months = "12";
      } else if ("2".equals(period)) { // 周期-半年
        months = "6";
      } else if ("3".equals(period)) { // 周期-季度
        months = "3";
      } else if ("4".equals(period)) { // 周期-月
        months = "1";
      } else if ("5".equals(period)) { // 周期-周
        days = "7";
      } else if ("6".equals(period)) { // 周期-日
        days = "1";
      }
      paraMap.put("months", months);
      paraMap.put("days", days);
    }
    // END

    // 保存公告信息表
    dao.insert(NOTICE + ".insertTimingNotice", paraMap);
    // 保存公告信息任务表
    dao.insert(NOTICE + ".insertTimingNoticeMission", paraMap);
    // 保存公告发布主附件
    dbMap = new HashMap<String, Object>();
    dbMap.put("updatedUser", userCode);
    dbMap.put("batchNumber", paraMap.get("batchNumber"));
    dbMap.put("name", "公告反馈");
    dbMap.put("createdUser", userCode);
    dbMap.put("deptCode", (String) umService.findDeptListByUserCode(userCode).get(0).get("deptCode"));
    dbMap.put("mainId", paraMap.get("noticId"));
    dbMap.put("validInd", '1');// 状态设置为有效
    dbMap.put("module", "08");
    dao.insert(NOTICE + ".insertTimingUpload", dbMap);

    try {
      String[] deptIds = ((String) paraMap.get("receiveDeptId")).split(",");
      String[] roleIds = ((String) paraMap.get("receiveRoleId")).split(",");
      String[] sendRoleIds = ((String) paraMap.get("createdUserRole")).split(",");
      Map<String, Object> paraMapNew = new HashMap<String, Object>();

      for (String deptCode : deptIds) {
        dbMap = new HashMap<String, Object>();
        dbMap.put("validInd", '1');// 状态设置为有效
        fillParamMap(dbMap, "insert");
        dbMap.put("receiverId", UUIDGenerator.getUUID());
        dbMap.put("noticId", paraMap.get("noticId"));
        dbMap.put("noticeId", paraMap.get("noticId"));
        dbMap.put("mainId", paraMap.get("noticId"));
        dbMap.put("deptCode", deptCode);
        dbMap.put("module", "10");
        dbMap.put("name", "公告反馈");
        dbMap.put("status", paraMap.get("status"));
        dbMap.put("validInd", ("1"));
        dbMap.put("roleCode", paraMap.get("receiveRoleId"));

        // 保存公告接收部门信息
        dao.insert(NOTICE + ".insertTimingReceiveDept", dbMap);

        for (String role : roleIds) {
          for (String sendRole : sendRoleIds) {
            dbMap.put("uploadId", UUIDGenerator.getUUID());
            dbMap.put("feedbackId", UUIDGenerator.getUUID());
            Map<String, Object> paraMapBackUser = new HashMap<String, Object>();
            paraMapNew.put("roleEname", role);
            paraMapNew.put("deptCode", deptCode);
            // 查询该公告的接收人是否存在
            Long userNum = (Long) dao.selectOne(NOTICE_FEEDBACK + ".queryUser", paraMapNew);
            if (userNum == 0) {
              paraMapBackUser.put("sendUserRole", sendRole);
              paraMapBackUser.put("receiveUserRole", role);
              String backUserUp = dao.selectOne(NOTICE + ".queryBackUserUp", paraMapBackUser);
              if (com.hf.framework.util.StringUtil.isNotEmpty(backUserUp)) {
                dbMap.put("roleCode", backUserUp);
              } else {
                dbMap.put("roleCode", role);
              }
            } else {
              dbMap.put("roleCode", role);
            }
            // 查询是否符合权限管理
            Map<String, Object> paraMapAuthority = new HashMap<String, Object>();
            paraMapAuthority.put("sendUserRole", sendRole);
            paraMapAuthority.put("receiveUserRole", dbMap.get("roleCode"));
            Long isAuthority = (Long) dao.selectOne(NOTICE + ".queryRoleAuthority", paraMapAuthority);

            // 保存公告发布反馈附件
            Map<String, Object> paraMapExist = new HashMap<String, Object>();
            paraMapExist.put("noticeId", paraMap.get("noticId"));
            paraMapExist.put("deptCode", deptCode);
            paraMapExist.put("roleCode", dbMap.get("roleCode"));
            Long isExist = (Long) dao.selectOne(NOTICE_FEEDBACK + ".queryDataExist", paraMapExist);
            if (isExist == 0 && isAuthority > 0) {
              dao.insert(NOTICE + ".insertTimingUpload", dbMap);
              dao.insert(NOTICE + ".insertTimingFeedback", dbMap);
            }
          }
        }

      }

      if ("1".equals(paraMap.get("status"))) {
        // 发送邮件提示公告接收部门
        String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");// 系统编码
        Set<String> recipientsSet = new HashSet<String>();
        String sendMailNoticeId = paraMap.get("noticId").toString();
        List<Map<String, Object>> listRoles = dao.selectList(NOTICE_FEEDBACK + ".querySendMailRoles", sendMailNoticeId);
        for (Map<String, Object> map : listRoles) {
          String deptCode = map.get("deptCode").toString();
          String roleName = map.get("roleCode").toString();
          recipientsSet.addAll(umService.findUserByRoleDept(systemCode, roleName, deptCode));
        }
        // recipientsSet.add("ex_xulinchao@sinosafe.com.cn");
        // 将收件人List转为String数组
        String[] recipients = (String[]) recipientsSet.toArray(new String[recipientsSet.size()]);

        Mail mail = new Mail();
        mail.setForm(MailUtil.getMailNick() + "<" + MAIL_FROM + ">");
        mail.setTo(recipients);
        Map<String, Object> model = new HashMap<String, Object>();
        mail.setSubject("公告下发提醒");
        mail.setTemplate("MailTemplateWarnNotice.vm");
        model.put("systemName", paraMap.get("tiltle")); // 公告标题
        model.put("systemNumber", paraMap.get("noticId")); // 公告号
        mail.setMailType(MailType.HTML_TEMPLATE);
        model.put("systemIp", MailUtil.getServerIP());
        model.put("reportUser", paraMap.get("deptCode")); // 发布机构
        model.put("reportUserIp", paraMap.get("publisher")); // 操作人员
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH : mm : ss");
        model.put("reportDate", formatter.format(new Date())); // 报告日期
        model.put("errorId", "errorIdTxt");
        model.put("msg", "errorMsgTxt");
        model.put("reportTxt", "reportTxt");
        model.put("stackTxt", "stackTxt");
        mail.setModel(model);
        mailService.send(mail);
      }
      return true;
    } catch (Exception e) {
      e.printStackTrace();
    }
    return false;
  }

  @Override
  public Boolean updateNotice(Map<String, Object> paraMap) {
    try {
      String userCode = CurrentUser.getUser().getUserCode();
      paraMap.put("updatedUser", userCode);
      dao.update(NOTICE + ".updateNotice", paraMap);

      // 更新公告反馈信息表状态
      dao.update(NOTICE_FEEDBACK + ".updateNoticeFeedbackStatus", paraMap);

      return true;
    } catch (Exception e) {
      e.printStackTrace();
    }
    return false;
  }

  @Override
  public Boolean saveNoticeFeedback(Map<String, Object> paraMap) {
    paraMap.put("status", "2");// 指定状态为已反馈
    try {

      String userCode = CurrentUser.getUser().getUserCode();

      if (paraMap.get("feedbackId") == null || paraMap.get("feedbackId").equals("undefined")) {
        fillParamMap(paraMap, "insert");
        paraMap.put("feedbackId", UUIDGenerator.getUUID());
        paraMap.put("noticeId", paraMap.get("noticId"));
        paraMap.put("status", ("1"));
        paraMap.put("validInd", ("1"));
        paraMap.put("feedbackUser", userCode);

        {
          paraMap.put("feedbackDate", new Timestamp(new Date().getTime()));
        }

        dao.insert(NOTICE_FEEDBACK + INSERT, paraMap);
      } else {
        paraMap.put("feedbackUser", userCode);
        paraMap.put("feedbackDate", "1");// 此处将时间设置为1只为让sqlmapper文件检索到该字段有值，调用if语句里面的sql
        paraMap.put("updatedUser", userCode);
        paraMap.put("updatedDate", "1");// 同上
        String noticeId = (String) paraMap.get("noticId");
        String feedBackaType = dao.selectOne(NOTICE + ".queryByNoticeId", noticeId);
        if (feedBackaType.equals("1")) {
          // 获取登录人的角色权限
          String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
          List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(userCode, systemCode);
          List<String> rolesList = new ArrayList<String>();
          Map<String, Object> paraMapNew = new HashMap<String, Object>();
          Map<String, Object> paraMapUpdate = new HashMap<String, Object>();
          paraMapNew.put("deptCode", paraMap.get("deptCode"));
          paraMapNew.put("noticeId", paraMap.get("noticId"));
          paraMapNew.put("rolesList", rolesList);
          for (Map<String, Object> map : roleCodeList) {
            rolesList.add(map.get("roleEname").toString());
          }
          List<Map<String, Object>> getUpdateNoticedId = dao.selectList(NOTICE_FEEDBACK + ".queryUpdateRoleName", paraMapNew);
          for (Map<String, Object> map : getUpdateNoticedId) {
            String f_id = (String) map.get("feedBackId");

            paraMapUpdate.put("feedBackId", f_id);
            paraMapUpdate.put("status", 2);
            paraMapUpdate.put("feedbackUser", userCode);
            paraMapUpdate.put("feedbackDate", new Date());
            paraMapUpdate.put("updatedUser", userCode);
            paraMapUpdate.put("updatedDate", new Date());
            paraMapUpdate.put("feedbackContent", paraMap.get("feedbackContent"));
            dao.update(NOTICE_FEEDBACK + ".updateFeedBackStuats", paraMapUpdate);
          }
        } else {
          dao.update(NOTICE_FEEDBACK + UPDATE_PK, paraMap);
        }

        if (!"".equals(paraMap.get("uploadId")) && paraMap.get("uploadId") != null && !"null".equals(paraMap.get("uploadId"))) {
          paraMap.put("mainId", paraMap.get("noticId"));
          paraMap.put("module", "10");
          paraMap.put("name", "公告反馈");
          paraMap.put("validInd", "1");
          dao.insert(UPLOAD + INSERT, paraMap);
        }
      }
      return true;
    } catch (ParseException e) {
      e.printStackTrace();
    }
    return false;
  }

  @Override
  public Boolean deleteNoticeByIds(String[] noticIdArray) throws ParseException {
    if (noticIdArray == null || noticIdArray.length == 0)
      return false;
    for (String noticeId : noticIdArray) {
      Map<String, Object> paraMap = new HashMap<String, Object>();
      paraMap.put("validInd", '0'); // 状态设置为有效
      paraMap.put("noticId", noticeId);
      fillParamMap(paraMap, "update");
      dao.update(NOTICE + UPDATE_PK, paraMap);// 公告主表删除
      dao.update(NOTICE_DEPT + ".deleteByNoticId", paraMap);// 公告子表删除
      dao.update(NOTICE_FEEDBACK + ".deleteByNoticId", paraMap);// 公告反馈表删除
      dao.update(NOTICE_MISSION + ".deleteByNoticId", paraMap);// 公告任务表删除
    }
    return true;
  }

  @Override
  public Boolean validNoticeByIds(String[] noticIdArray) throws ParseException {
    if (noticIdArray == null || noticIdArray.length == 0)
      return false;
    for (String noticeId : noticIdArray) {
      Map<String, Object> paraMap = new HashMap<String, Object>();
      paraMap.put("validInd", '0'); // 状态设置为无效
      paraMap.put("noticId", noticeId);
      // 状态为9代表终止
      paraMap.put("status", "9");
      fillParamMap(paraMap, "update");

      dao.update(NOTICE_MISSION + ".deleteByNoticId", paraMap);
      // dao.update(NOTICE + ".updateNoticeStatusById", paraMap);
      // dao.update(NOTICE + ".updateNoticeFeedbackStatusById", paraMap);
    }
    return true;
  }

  @Override
  public Boolean saveNoticeDeal(Map<String, Object> paraMap) {
    try {
      paraMap.put("validInd", '1');// 状态设置为有效

      String userCode = CurrentUser.getUser().getUserCode();

      String noticId = paraMap.get("noticId").toString();
      String updatedUser = paraMap.get("updatedUser").toString();
      String feedBackType = dao.selectOne(NOTICE + ".queryByNoticeId", noticId);
      Map<String, Object> paraMapUpdate = new HashMap<String, Object>();
      if (feedBackType.equals("1")) {
        Map<String, Object> paraMapNew = new HashMap<String, Object>();
        paraMapNew.put("noticeId", noticId);
        paraMapNew.put("deptCode", paraMap.get("deptCode"));
        List<Map<String, Object>> feedbackids = dao.selectList(NOTICE_FEEDBACK + ".queryFeedBackIds", paraMapNew);
        for (Map<String, Object> map : feedbackids) {
          if (updatedUser.equals(map.get("updatedUser"))) {
            paraMapUpdate.put("feedbackId", map.get("feedBackId"));
            paraMapUpdate.put("status", "3");
            paraMapUpdate.put("processor", userCode);
            paraMapUpdate.put("updatedUser", userCode);
            paraMapUpdate.put("processDate", "1");
            paraMapUpdate.put("updatedDate", "1");
            paraMapUpdate.put("processContent", paraMap.get("processContent"));
            dao.update(NOTICE_FEEDBACK + UPDATE_PK, paraMapUpdate);
          }
        }
      } else {
        if (paraMap.get("feedbackId") == null || paraMap.get("feedbackId").equals("undefined")) {
          fillParamMap(paraMap, "insert");
          return false;
        } else {
          fillParamMap(paraMap, "update");

          paraMap.put("status", "3");
          paraMap.put("processor", userCode);
          paraMap.put("updatedUser", userCode);
          paraMap.put("processDate", "1");
          paraMap.put("updatedDate", "1");

          dao.update(NOTICE_FEEDBACK + UPDATE_PK, paraMap);

          paraMap.put("noticeId", paraMap.get("noticId"));
          List<Map<String, Object>> list = dao.selectList(NOTICE_FEEDBACK + ".queryStatus", paraMap);
          if (list.size() == 1 && "3".equals(list.get(0).get("status").toString()) || list.size() == 0) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("updatedUser", userCode);
            map.put("status", 3);
            map.put("noticId", paraMap.get("noticId"));
            dao.update(NOTICE + ".updateStatus", map);
          }
        }
      }
      return true;
    } catch (ParseException e) {
      e.printStackTrace();
    }
    return false;
  }

  @Override
  public Boolean argueNoticeDeal(Map<String, Object> paraMap) {
    try {
      paraMap.put("validInd", '1');// 状态设置为有效

      String userCode = CurrentUser.getUser().getUserCode();
      String noticId = paraMap.get("noticId").toString();
      String updatedUser = paraMap.get("updatedUser").toString();
      String feedBackType = dao.selectOne(NOTICE + ".queryByNoticeId", noticId);
      Map<String, Object> paraMapUpdate = new HashMap<String, Object>();
      if (feedBackType.equals("1")) {
        Map<String, Object> paraMapNew = new HashMap<String, Object>();
        paraMapNew.put("noticeId", noticId);
        paraMapNew.put("deptCode", paraMap.get("deptCode"));
        List<Map<String, Object>> feedbackids = dao.selectList(NOTICE_FEEDBACK + ".queryFeedBackIds", paraMapNew);
        for (Map<String, Object> map : feedbackids) {
          if (updatedUser.equals(map.get("updatedUser"))) {
            paraMapUpdate.put("feedbackId", map.get("feedBackId"));
            paraMapUpdate.put("status", "4");// 设置公告状态为“驳回”
            paraMapUpdate.put("processor", userCode);
            paraMapUpdate.put("updatedUser", userCode);
            paraMapUpdate.put("processDate", "1");
            paraMapUpdate.put("updatedDate", "1");
            paraMapUpdate.put("processContent", paraMap.get("processContent"));
            dao.update(NOTICE_FEEDBACK + UPDATE_PK, paraMapUpdate);
          }
        }
        // 发送邮件提醒反馈部门
        Map<String, Object> paraMapFeedback = new HashMap<String, Object>();
        String deptCode = paraMap.get("deptCode").toString();
        String noticeId = paraMap.get("noticId").toString();
        paraMapFeedback.put("deptCode", deptCode);
        paraMapFeedback.put("noticeId", noticeId);
        String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");// 系统编码
        List<Map<String, Object>> roleEnames = dao.selectList(NOTICE_FEEDBACK + ".getFeedBackRoleNames", paraMapFeedback);
        for (Map<String, Object> map : roleEnames) {
          String roleEname = map.get("roleCode").toString();
          List<String> recipientsList = umService.findUserByRoleDept(systemCode, roleEname, deptCode);
          // recipientsList.add("ex_huangsikai@sinosafe.com.cn");
          // 将收件人List转为String数组
          String[] recipients = (String[]) recipientsList.toArray(new String[recipientsList.size()]);
          if (recipients.length < 1) {
            return false;// 如果收件人为空，放弃发送邮件
          }
          sendMail(recipients, paraMap);
        }
      } else {
        if (paraMap.get("feedbackId") == null || paraMap.get("feedbackId").equals("undefined")) {
          fillParamMap(paraMap, "insert");
          return false;
        } else {
          fillParamMap(paraMap, "update");

          paraMap.put("status", "4");// 设置公告状态为“驳回”
          paraMap.put("processor", userCode);
          paraMap.put("updatedUser", userCode);
          paraMap.put("processDate", "1");
          paraMap.put("updatedDate", "1");
          paraMap.put("noticeId", paraMap.get("noticId"));
          dao.update(NOTICE_FEEDBACK + UPDATE_PK, paraMap);// 更新相应公告状态

          // 发送邮件提醒反馈部门
          String deptCode = paraMap.get("deptCode").toString();
          String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");// 系统编码
          String feedbackId = paraMap.get("feedbackId").toString();
          String roleEname = dao.selectOne(NOTICE_FEEDBACK + ".getFeedBackRole", feedbackId);
          List<String> recipientsList = umService.findUserByRoleDept(systemCode, roleEname, deptCode);
          // recipientsList.add("ex_huangsikai@sinosafe.com.cn");
          // 将收件人List转为String数组
          String[] recipients = (String[]) recipientsList.toArray(new String[recipientsList.size()]);
          if (recipients.length < 1) {
            return false;// 如果收件人为空，放弃发送邮件
          }
          sendMail(recipients, paraMap);
        }
      }
      return true;
    } catch (ParseException e) {
      e.printStackTrace();
    }
    return false;
  }

  private void sendMail(String[] recipients, Map<String, Object> paraMap) {
    Mail mail = new Mail();
    mail.setForm(MailUtil.getMailNick() + "<" + MAIL_FROM + ">");
    mail.setTo(recipients);
    Map<String, Object> model = new HashMap<String, Object>();
    mail.setSubject("公告驳回提醒");
    mail.setTemplate("MailTemplateWarnNotice.vm");
    model.put("systemName", paraMap.get("tiltle"));
    model.put("systemNumber", paraMap.get("noticId"));
    mail.setMailType(MailType.HTML_TEMPLATE);
    model.put("systemIp", MailUtil.getServerIP());
    model.put("reportUser", paraMap.get("publishDeptCode"));
    model.put("reportUserIp", paraMap.get("publisher"));
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH : mm : ss");
    model.put("reportDate", formatter.format(new Date()));
    model.put("errorId", "errorIdTxt");
    model.put("msg", "errorMsgTxt");
    model.put("reportTxt", "reportTxt");
    model.put("stackTxt", "stackTxt");
    mail.setModel(model);
    mailService.send(mail);
  }

  /**
   * 这里需要返回主键. 查询可以批改的单据 <br>
   * 
   * @param 参数类型 filterPara 过滤条件参数
   * @return String 说明
   * @throws 异常类型
   * @param paraMap
   * @return
   * @throws ParseException
   */
  private String commonNoticeSave(Map<String, Object> paraMap) throws ParseException {
    paraMap.put("validInd", '1');// 状态设置为有效

    // checkDeptCode(paraMap);

    String userCode = CurrentUser.getUser().getUserCode();

    if (paraMap.get("noticId") == null || paraMap.get("noticId").equals("undefined")) {
      fillParamMap(paraMap, "insert");
      paraMap.put("noticId", UUIDGenerator.getUUID());
      paraMap.put("noticGroupId", UUIDGenerator.getUUID());
      paraMap.put("publisher", userCode);
      dao.insert(NOTICE + INSERT, paraMap);

      paraMap.put("uploadId", paraMap.get("programUploadId"));
      paraMap.put("mainId", paraMap.get("noticGroupId"));
      paraMap.put("module", "08");
      paraMap.put("name", "公告附件");
      dao.insert(UPLOAD + INSERT, paraMap);

      if ("0".equals(paraMap.get("status"))) {
        paraMap.put("missionId", UUIDGenerator.getUUID());
        String months = "";
        String days = "";
        if (!"".equals(paraMap.get("period"))) {
          if ("1".equals(paraMap.get("period"))) {// 周期-年
            months = "12";
          } else if ("2".equals(paraMap.get("period"))) {// 周期-半年
            months = "6";
          } else if ("3".equals(paraMap.get("period"))) {// 周期-季度
            months = "3";
          } else if ("4".equals(paraMap.get("period"))) {// 周期-月
            months = "1";
          } else if ("5".equals(paraMap.get("period"))) {// 周期-周
            days = "7";
          } else if ("6".equals(paraMap.get("period"))) {// 周期-日
            days = "1";
          }
          paraMap.put("months", months);
          paraMap.put("days", days);
        }
        dao.insert(NOTICE_MISSION + INSERT, paraMap);
      }
    } else {
      fillParamMap(paraMap, "update");
      paraMap.put("noticeId", paraMap.get("noticId"));
      dao.update(NOTICE + UPDATE_PK, paraMap);
      dao.update(NOTICE_FEEDBACK + ".updateFeedBackByNoticeId", paraMap);
    }
    return (String) paraMap.get("noticId");
  }

  private void fillParamMap(Map<String, Object> paraMap, String action) throws ParseException {
    String userCode = CurrentUser.getUser().getUserCode();

    if (action.equals("insert")) {
      paraMap.put("createdUser", userCode);
      paraMap.put("updatedUser", userCode);
      trunToDate(paraMap);

    } else if (action.equals("update")) {
      paraMap.put("updatedUser", userCode);
      trunToDate(paraMap, "update");
    }
  }

  @Override
  public void saveSubmitNotice(Map<String, Object> paraMap) {
    paraMap.put("status", "1");// 指定状态为活动进行中

    try {
      commonNoticeSave(paraMap);
    } catch (ParseException e) {
      e.printStackTrace();
    }
  }

  @Override
  public void updateSummaryNotice(Map<String, Object> paraMap) {
    paraMap.put("status", "2");// 指定状态为已结束
    FillCommonInfo.fillParamMap(paraMap, "update");
    dao.update(NOTICE + UPDATE_PK, paraMap);
  }

  @Override
  public List<Map<String, Object>> queryAllReceiveDept(Map<String, Object> moveSpaceForMap) {

    return dao.selectList(NOTICE_DEPT + ".queryDeptByParentCode", moveSpaceForMap);

  }

  @Override
  public List<Map<String, Object>> queryAllReceiveRole(Map<String, Object> moveSpaceForMap) {

    return dao.selectList(NOTICE_DEPT + ".queryRoleByRelationTypeAndRole", moveSpaceForMap);

  }

  /**
   * @param 参数类型 filterPara 过滤条件参数
   * @return String 说明
   * @throws 异常类型
   * @param paraMap
   * @throws ParseException
   */
  public static void trunToDate(Map<String, Object> paraMap) throws ParseException {
    SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
    String createDateS = (String) paraMap.get("createdDate");

    if (createDateS == null || (createDateS.trim().equals(""))) {
      paraMap.put("createdDate", new Timestamp(new Date().getTime()));
    } else {
      long tt = sf.parse(createDateS).getTime();
      Timestamp createDate = new Timestamp(tt);
      paraMap.put("createdDate", createDate);
    }

    String updateDateS = (String) paraMap.get("updatedDate");

    if (updateDateS == null || (updateDateS.trim().equals(""))) {
      paraMap.put("updatedDate", new Timestamp(new Date().getTime()));
    } else {
      long tt = sf.parse(updateDateS).getTime();
      Timestamp updateDate = new Timestamp(tt);
      paraMap.put("updatedDate", updateDate);
    }

    String publicDateS = (String) paraMap.get("publishDate");

    if (publicDateS == null || (publicDateS.trim().equals(""))) {
      paraMap.put("publishDate", new Timestamp(new Date().getTime()));
    } else {
      long tt = sf.parse(publicDateS).getTime();
      Timestamp updateDate = new Timestamp(tt);
      paraMap.put("publishDate", updateDate);
    }
  }

  /**
   * 
   * @param 参数类型 filterPara 过滤条件参数
   * @return String 说明
   * @throws 异常类型
   * @param paraMap
   * @throws ParseException
   */
  public static void trunToDate(Map<String, Object> paraMap, String update) throws ParseException {
    SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

    if ("update".equalsIgnoreCase(update)) {
      String updateDateS = (String) paraMap.get("updatedDate");

      if (updateDateS == null || (updateDateS.trim().equals(""))) {
        paraMap.put("updatedDate", new Timestamp(new Date().getTime()));
      } else {
        long tt = sf.parse(updateDateS).getTime();
        Timestamp updateDate = new Timestamp(tt);
        paraMap.put("updatedDate", updateDate);
      }

    } else {
      trunToDate(paraMap);
    }
  }

  @Override
  public PageDto findNoticeFeedbackByNoticId(PageDto pageDto) {
    if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
      pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
    } else {
      pageDto.getWhereMap().put("startpoint", 1);
    }
    pageDto.getWhereMap().put("endpoint", pageDto.getEnd());
    Map<String, Object> map = pageDto.getWhereMap();
    String statusNum = map.get("statusNum").toString();
    List<Map<String, Object>> newRows = new ArrayList<Map<String, Object>>();
    if (com.hf.framework.util.StringUtil.isBlank(statusNum)) {
      List<Map<String, Object>> rows = dao.selectList(NOTICE_FEEDBACK + ".queryAllByNoticeId", pageDto.getWhereMap());
      pageDto.setRows(rows);
    } else {
      String[] statusList = statusNum.split(",");
      Map<String, Object> selectMap = new HashMap<String, Object>();
      selectMap.put("noticeId", pageDto.getWhereMap().get("noticeId"));
      List<Map<String, Object>> rows = dao.selectList(NOTICE_FEEDBACK + ".queryAllByNoticeId", pageDto.getWhereMap());
      List<String> allSelectedStatus = new ArrayList<String>();
      if (statusList.length > 0) {
        for (int i = 0; i < statusList.length; i++) {
          if (com.hf.framework.util.StringUtil.isNotEmpty(statusList[i])) {
            allSelectedStatus.add(statusList[i]);
          }
        }
        for (Map<String, Object> map2 : rows) {
          String s_status = map2.get("status").toString();
          for (String str : allSelectedStatus) {
            if (str.equals(s_status)) {
              newRows.add(map2);
            }
          }
        }
        pageDto.setRows(newRows);
      } else {
        pageDto.setRows(rows);
      }
    }
    return pageDto;
  }

  @Override
  public PageDto findNoticeDealByWhere(PageDto pageDto) {
    Map<String, Object> tt = dao.selectOne(NOTICE_FEEDBACK + QUERY_NOTICE_FOR_DEAL_PAGE, pageDto.getWhereMap());
    // Long total = Long.parseLong(tt.get("count").toString());

    if (pageDto.getStart() != null && pageDto.getStart().intValue() != 1) {
      pageDto.getWhereMap().put("startpoint", pageDto.getStart() + 1);
    } else {
      pageDto.getWhereMap().put("startpoint", 1);
    }
    pageDto.getWhereMap().put("endpoint", pageDto.getEnd());

    List<Map<String, Object>> rows = dao.selectList(NOTICE_FEEDBACK + QUERY_NOTICE_FOR_DEAL_PAGE, pageDto.getWhereMap());
    List<Map<String, Object>> rowsNew = new ArrayList<Map<String, Object>>();
    Map<String, Object> paraMap = new HashMap<String, Object>();
    String n_id = "";
    for (Map<String, Object> map : rows) {
      String feedBackType = map.get("feedBackType").toString();
      if (feedBackType.equals("1")) {
        String noticeId = map.get("noticId").toString();
        String deptCode = map.get("deptCode").toString();
        String updatedUser = map.get("updatedUser").toString();
        paraMap.put("noticeId", noticeId);
        paraMap.put("deptCode", deptCode);
        paraMap.put("updatedUser", updatedUser);
        Long num = dao.selectOne(NOTICE_FEEDBACK + ".queryAuthorityNoticeNumber", paraMap);
        if (num > 1) {
          List<Map<String, Object>> singleNotice = dao.selectList(NOTICE_FEEDBACK + ".queryNoticeFeedbackData", paraMap);
          if (!n_id.equals(noticeId)) {
            rowsNew.add(singleNotice.get(0));
          }
          n_id = noticeId;
        } else {
          rowsNew.add(map);
        }
      } else {
        rowsNew.add(map);
      }
    }
    pageDto.setRows(rowsNew);
    Long total = (long) rowsNew.size();
    pageDto.setTotal(total);
    return pageDto;
  }

  /**
   * 每天调用定时任务查询需要发布的公告并自动发布
   */
  @Override
  public void publishNoticeByDate() {

    // 查询当前日期已经保存为待发布状态需要发布的定期公告和单次公告
    List<Map<String, Object>> rows = dao.selectList(NOTICE_MISSION + ".queryTaskByNow", null);

    if (rows.size() <= 0) {
      return;
    }

    for (int i = 0; i < rows.size(); i++) {

      Map<String, Object> paraMap = new HashMap<String, Object>();
      boolean isCopy = false;
      String period = (String) rows.get(i).get("period");
      // period不为空代表是定期公告的数据
      if (period != null) {
        String nextPublishDate = ((String) rows.get(i).get("nextPublishDate")).substring(0, 10);
        if (nextPublishDate.equals(new SimpleDateFormat("yyyy-MM-dd").format(new Date()))) {
          // 如果下一个发布日期为今天，则复制公告数据并进行发布
          isCopy = true;
        }
      }

      if (!isCopy) {
        paraMap.put("noticId", rows.get(i).get("noticId"));
        paraMap.put("status", "1");// 指定状态为公告进行中
        paraMap.put("noticeId", paraMap.get("noticId"));
        paraMap.put("updatedUser", "system");
        paraMap.put("updatedDate", "1");
        // 更新公告的状态
        dao.update(NOTICE + UPDATE_PK, paraMap);
        dao.update(NOTICE_FEEDBACK + ".updateFeedBackByNoticeId", paraMap);
      } else {
        Map<String, Object> paraMap1 = new HashMap<String, Object>();
        // 复制生成新的定期公告
        String newNoticId = UUIDGenerator.getUUID();
        String oldNoticId = (String) rows.get(i).get("noticId");
        paraMap1.put("newMissionId", UUIDGenerator.getUUID());
        paraMap1.put("newNoticId", newNoticId);
        paraMap1.put("oldNoticId", oldNoticId);
        paraMap1.put("publishDate", new Date());
        paraMap1.put("nextPublishDate", "1");
        paraMap1.put("status", "1");
        paraMap1.put("relationType", rows.get(i).get("relationType"));

        // 下一次发布的时间
        String months = null;
        String days = null;
        if ("1".equals(period)) { // 周期-年
          months = "12";
        } else if ("2".equals(period)) { // 周期-半年
          months = "6";
        } else if ("3".equals(period)) { // 周期-季度
          months = "3";
        } else if ("4".equals(period)) { // 周期-月
          months = "1";
        } else if ("5".equals(period)) { // 周期-周
          days = "7";
        } else if ("6".equals(period)) { // 周期-日
          days = "1";
        }
        // END

        paraMap1.put("months", months);
        paraMap1.put("days", days);

        dao.insert(NOTICE + ".copyToTimingNotice", paraMap1);
        dao.insert(NOTICE + ".copyToTimingNoticeMission", paraMap1);
        dao.insert(NOTICE + ".copyToTimingNoticeFeedback", paraMap1);
        dao.insert(NOTICE + ".copyToTimingNoticeReceiveDept", paraMap1);
        dao.insert(NOTICE + ".copyToTimingUpload", paraMap1);

      }

      // 查询该公告的反馈部门
      List<Map<String, Object>> receiveDeptList = dao.selectList(NOTICE_FEEDBACK + ".queryReceiveDept", paraMap);
      for (int j = 0; j < receiveDeptList.size(); j++) {
        String deptCode = receiveDeptList.get(j).get("deptCode").toString();
        // 发送邮件提示公告接收部门

        String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");// 系统编码
        Set<String> recipientsSet = new HashSet<String>();
        String sendMailNoticeId = paraMap.get("noticId").toString();
        List<Map<String, Object>> listRoles = dao.selectList(NOTICE_FEEDBACK + ".querySendMailRoles", sendMailNoticeId);
        for (Map<String, Object> map : listRoles) {
          String codeDept = map.get("deptCode").toString();
          String roleName = map.get("roleCode").toString();
          recipientsSet.addAll(umService.findUserByRoleDept(systemCode, roleName, codeDept));
        }
        // recipientsList.add("ex_huangsikai@sinosafe.com.cn");
        // 将收件人List转为String数组
        String[] recipients = (String[]) recipientsSet.toArray(new String[recipientsSet.size()]);
        if (recipients.length < 1) {
          continue;// 如果收件人为空，跳出本次循环(放弃发送邮件)，进行下次循环
        }

        Mail mail = new Mail();
        mail.setForm(MailUtil.getMailNick() + "<" + MAIL_FROM + ">");
        mail.setTo(recipients);
        Map<String, Object> model = new HashMap<String, Object>();
        mail.setSubject("公告下发提醒");
        mail.setTemplate("MailTemplateWarnNotice.vm");
        model.put("systemName", rows.get(i).get("tiltle"));
        model.put("systemNumber", rows.get(i).get("noticId"));
        mail.setMailType(MailType.HTML_TEMPLATE);
        model.put("systemIp", MailUtil.getServerIP());
        model.put("reportUser", rows.get(i).get("deptCode"));
        model.put("reportUserIp", rows.get(i).get("publisher"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH : mm : ss");
        model.put("reportDate", formatter.format(new Date()));
        model.put("errorId", "errorIdTxt");
        model.put("msg", "errorMsgTxt");
        model.put("reportTxt", "reportTxt");
        model.put("stackTxt", "stackTxt");
        mail.setModel(model);
        mailService.send(mail);
      }
    }
  }

  @Override
  public List<String> filterSubBusinessLines() {

    String roleEname = null;
    String businessLine = null;
    List<String> subBusinessLines = new ArrayList<String>();
    Map<String, String> roleConfigureMap = this.getRoleConfigureMap();

    String systemCode = (String) PlatformContext.getGoalbalContext("com.hf.framework.app.syscode");
    List<Map<String, Object>> roleCodeList = umService.findRolesInSystemByUserCode(CurrentUser.getUser().getUserCode(), systemCode);

    for (int index = 0; index < roleCodeList.size(); index++) {
      roleEname = (String) roleCodeList.get(index).get("roleEname");
      // 如果是销售支持系统开发角色（管理员），那么应该具有所有业务线的权限
      if ("xszcAdmin".equals(roleEname)) {
        subBusinessLines.clear();
        subBusinessLines.addAll(new HashSet(roleConfigureMap.values()));
        // 添加电话直销业务线，电话直销暂时没有具体对应的角色
        subBusinessLines.add("925004");
        subBusinessLines.add("925009");
        return subBusinessLines;
      }

      if ("headDeptdianxiao".equals(roleEname)) {
        subBusinessLines.clear();
        subBusinessLines.add("925005");
        return subBusinessLines;
      }

      if ("createBusiness".equals(roleEname)) {
        subBusinessLines.clear();
        subBusinessLines.add("925009");
        return subBusinessLines;
      }

      businessLine = roleConfigureMap.get(roleEname);
      if (businessLine == null) {
        continue;
      }
      if (!subBusinessLines.contains(businessLine)) {
        subBusinessLines.add(businessLine);
        // 如果是“渠道常规”，将“电话直销”业务线也添加进来，暂定“渠道常规”等同“电话直销”
        if ("925007".equals(businessLine)) {
          subBusinessLines.add("925004");
          subBusinessLines.add("925009");
        }

      }
    }

    // 如果没有发现业务线角色，赋予默认值noPermission，即查不出数据
    if (subBusinessLines.size() == 0) {
      subBusinessLines.addAll(new HashSet(roleConfigureMap.values()));
      // 添加电话直销业务线，电话直销暂时没有具体对应的角色
      subBusinessLines.add("925004");

    }

    return subBusinessLines;
  }

  @Override
  public Map<String, String> getRoleConfigureMap() {

    Map<String, String> roleConfigureMap = new HashMap<String, String>();
    roleConfigureMap.put("headDeptdianxiao", "925005");
    roleConfigureMap.put("headDeptDirectorChennel", "925006");
    roleConfigureMap.put("haedDeptSalesmanChannel", "925006");
    roleConfigureMap.put("headDepatChennelCh", "925006");
    roleConfigureMap.put("thirdDeptMiddleChennel", "925006");
    roleConfigureMap.put("thirdDeptBusiManaChennel", "925006");
    roleConfigureMap.put("subDeptSalesmanChennel", "925006");
    roleConfigureMap.put("subDeptAdminChennel", "925006");
    roleConfigureMap.put("subDeptChennelCh", "925006");
    roleConfigureMap.put("headDeptDirectorFinance", "925003");
    roleConfigureMap.put("haedDeptSalesmanFinance", "925003");
    roleConfigureMap.put("headDepatFinanceSafe", "925003");
    roleConfigureMap.put("thirdDeptMiddleFinance", "925003");
    roleConfigureMap.put("thirdDeptBusiManaFinance", "925003");
    roleConfigureMap.put("subDeptSalesmanFinance", "925003");
    roleConfigureMap.put("subDeptAdminFinance", "925003");
    roleConfigureMap.put("subDeptFinanceSafe", "925003");
    roleConfigureMap.put("headDeptDirector", "925007");
    roleConfigureMap.put("haedDeptSalesman", "925007");
    roleConfigureMap.put("headDeptChannel", "925007");
    roleConfigureMap.put("headDepatRenewal", "925007");
    roleConfigureMap.put("subDeptMarketM", "925007");
    roleConfigureMap.put("subDeptSalesman", "925007");
    roleConfigureMap.put("subDeptAdmin", "925007");
    roleConfigureMap.put("subDeptManager", "925007");
    roleConfigureMap.put("thirdDeptMiddle", "925007");
    roleConfigureMap.put("thirdDeptBusiMana", "925007");
    roleConfigureMap.put("headDeptCredit", "925008");
    roleConfigureMap.put("headDepatCredit", "925008");
    roleConfigureMap.put("haedDeptSalesmanCredit", "925008");
    roleConfigureMap.put("subDeptAdminCredit", "925008");
    roleConfigureMap.put("subDeptManagerCredit", "925008");
    roleConfigureMap.put("subDeptSalesmanCredit", "925008");

    return roleConfigureMap;
  }

  @Override
  public List<String> getAllRoleENameByBusinessLine(String[] businessLine) {
    List<String> result = new ArrayList<String>();

    if (businessLine == null) {
      return result;
    }

    Map<String, String> roleConfigureMap = this.getRoleConfigureMap();
    for (int i = 0; i < businessLine.length; i++) {
      for (Map.Entry<String, String> roleConfigureEntry : roleConfigureMap.entrySet()) {
        if (roleConfigureEntry.getValue().equals(businessLine[i])) {
          result.add(roleConfigureEntry.getKey());
        }
      }
    }
    return result;
  }

  @Override
  public List<Map<String, Object>> queryTimingUploadMajor(Map<String, Object> paraMap) {
    return dao.selectList(NOTICE + ".queryTimingUploadMajor", paraMap);
  }

  @Override
  public List<Map<String, Object>> queryTimingUploadFeedback(Map<String, Object> paraMap) {
    return dao.selectList(NOTICE + ".queryTimingUploadFeedback", paraMap);
  }

  @Override
  public boolean feedbackIsEffective(String feedbackId) {
    String result = dao.selectOne(NOTICE_FEEDBACK + ".feedbackIsEffective", feedbackId);
    if (result != null) {
      return true;
    }
    return false;
  }

  @Override
  public List<Map<String, String>> getBusinessLineInfo(List<String> subBusinessLines) {
    return dao.selectList(NOTICE + ".getBusinessLineInfo", subBusinessLines);
  }

  @Override
  public List<Map<String, String>> queryBusinessline(List<String> subBusinessLines) {
    return dao.selectList(NOTICE + ".queryBusinessline", subBusinessLines);
  }

}
