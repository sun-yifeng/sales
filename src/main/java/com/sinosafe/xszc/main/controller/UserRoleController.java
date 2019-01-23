package com.sinosafe.xszc.main.controller;

import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.um.service.UmService;
import com.sinosafe.xszc.main.service.UserRoleService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.ExportExcel;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/userRole")
public class UserRoleController {
  
  private static final Log log = LogFactory.getLog(UserRoleController.class);
  
  @Autowired
  @Qualifier("UserRoleService")
  private UserRoleService roleService;
  
  @Autowired 
  @Qualifier(value = "umService") 
  private UmService umService;
  
  /**
   * 查询用户权限角色
   * @param request
   * @param response
   * @param dto
   * @throws GeneralException
   */
  @RequestMapping("/queryUserRoles")
  @VisitDesc(label="查询用户权限",actionType=4)
  public void queryVisitRecords(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
    Map<String, Object> paramMap = dto.getFormMap();
    String startStr = request.getParameter("start");
    String limitStr = request.getParameter("limit");
    
    String userCode = CurrentUser.getUser().getUserCode();
  //查询出登录用户的所属机构编码
    List<Map<String, Object>> roleCodeList = umService.findDeptListByUserCode(userCode);
    String deptCode = (String) roleCodeList.get(0).get("deptCode");
    if(!"00".equals(deptCode)){
      paramMap.put("deptCode", deptCode);
    }else if("00".equals(deptCode)){
      paramMap.put("deptCode", "");
    }
    PageDto pageDto = new PageDto();
    pageDto.setStart(startStr);
    pageDto.setLimit(limitStr);
    pageDto.setWhereMap(dto.getFormMap());
    try {
      pageDto = roleService.queryUserRoles(pageDto);
    } catch (Exception e) {
      log.error(e);
      throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
    }
    SendUtil.sendJSON(response,pageDto);
  }
  
  /**
   * 查询用户权限角色
   * @param request
   * @param response
   * @param dto
   * @throws GeneralException
   */
  @RequestMapping("/exportUserRoles")
  @VisitDesc(label="导出用户权限数据",actionType=4)
  public void exportUserRoles(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
    Map<String, Object> paramMap = dto.getFormMap();
    //excel导出数据不分页
    PageDto pageDto = new PageDto();
    pageDto.setStart("0");
    pageDto.setLimit("200000");
    String userCode = CurrentUser.getUser().getUserCode();
    //查询出登录用户的所属机构编码
    List<Map<String, Object>> roleCodeList = umService.findDeptListByUserCode(userCode);
    String deptCode = (String) roleCodeList.get(0).get("deptCode");
    if(!"00".equals(deptCode)){
      paramMap.put("deptCode", deptCode);
    }else if("00".equals(deptCode)){
      paramMap.put("deptCode", "");
    }
    pageDto.setWhereMap(dto.getFormMap());
    try {
      pageDto = roleService.queryUserRoles(pageDto);
    //定义从数据库取出数据顺序数组
      String[] colum_name = {"deptCode","deptName","userCname","userCode","status","valid","roleCname","createdDate","openDate","closeDate","operator"};
      //模板路径
      String strFilePath = request.getSession().getServletContext().getRealPath("/") + "/ExportExcel/";
      String strFileName = "userRoles.xls";
      if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
        strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
      } else {
        strFileName = new String(strFileName.getBytes("UTF-8"), "ISO8859-1");// 其它浏览器
      }
      response.setHeader("Content-disposition","attachment;filename=" + strFileName);
      response.setContentType("application/x-download; charset=utf-8");
      //生成所需的Excel文件
      ExportExcel.dataToExcel(pageDto.getRows(), strFilePath+strFileName,colum_name,response.getOutputStream());
    } catch (Exception e) {
      log.error(e);
      throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
    }
  }
  
  @RequestMapping("/getRoleNames")
  public void getRoleNames(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
    List<Map<String,Object>> resList = roleService.queryRoleNames(dto);
    JSONArray result = new JSONArray();
    result.add(buildDept("","请选择"));
    try {
      for (int i = 0; i < resList.size(); i++) {
        result.add(buildDept(resList.get(i).get("roleCname").toString(),resList.get(i).get("roleCname").toString()));
      }
      SendUtil.sendJSON(response, result);
    } catch (Exception e) {
      log.debug("查询错误！！");
      e.printStackTrace();
    }
  }
  
  private JSONObject buildDept(String id, String name) {
    JSONObject result = new JSONObject();
    result.put("value", id);
    result.put("text", name);
    return result;
  }
  
}
