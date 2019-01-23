package com.sinosafe.xszc.survey.controller;

import java.beans.IntrospectionException;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.hf.framework.util.UUIDGenerator;
import com.sinosafe.xszc.survey.service.SurveyService;
import com.sinosafe.xszc.survey.vo.Survey;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.ReflectMatch;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/survey")
public class SurveyController {
	
	private static final Log log = LogFactory.getLog(SurveyController.class);
	
	@Autowired
	@Qualifier("SurveyService")
	private SurveyService surveyService;
	
	/**
	 * 查询市场调研管理信息
	 */
	@RequestMapping("/querySurvey")
	public void querySurvey(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = surveyService.findSurveyByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	/**
	 * 保存上传文件记录
	 * , @RequestParam MultipartFile[] myfiles
	 */
	@RequestMapping("/saveSurvey")
	public void saveSurvey(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException,
												IntrospectionException, IllegalAccessException, InvocationTargetException {
		Map<String,Object> paramMap = dto.getFormMap();
		ReflectMatch rm = new ReflectMatch();
		Survey survey = new Survey();
		rm.setValue(survey, paramMap);
		survey.setSruveryId(UUIDGenerator.getUUID());
		survey.setCreatedUser(CurrentUser.getUser().getUserCode());
		survey.setUpdatedUser(CurrentUser.getUser().getUserCode());
		survey.setValidInd("1");
		survey.setDocName("hello.xls");
		survey.setDocPath("--");
		//FileOperateUtil fileOperateUtil = new FileOperateUtil();
		//fileOperateUtil.uploadFile(request, null, null);
		try {
			//fileOperateUtil.uploadFile(request, null, null);
			//defaultProcessFileUpload(request,response);
			surveyService.saveSurvey(survey);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(survey), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 下载指定模板文件路径 
	 */
	@RequestMapping("/downLoadFile")
	 public void downloadFile(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		/*String strFileName = "/uploadDir/CmszWorkManagement.zip";
		FileOperateUtil fou = new FileOperateUtil();
		fou.downLoadFile(request, response, strFileName);*/
		FileInputStream input = null;
		ServletOutputStream output = null;
		try {
			String strFileName = request.getSession().getServletContext().getRealPath("/") 
					+  "/uploadDir/document.zip";
			File file = new File( strFileName);
			if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
				strFileName = URLEncoder.encode(strFileName, "UTF-8");// IE浏览器
			} else {
				strFileName = new String(strFileName.getBytes("UTF-8"),"ISO8859-1");// 其它浏览器
			}
			response.setHeader("Content-disposition", "attachment;filename="
					+ strFileName);
			response.setContentType("application/x-download; charset=utf-8");

			input = new FileInputStream(file);
			output = response.getOutputStream();
			byte[] block = new byte[1024];
			int len = 0;
			while ((len = input.read(block)) != -1) {
				output.write(block, 0, len);
			}
			output.flush();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				if (input != null) {
					input.close();
				}
				if (output != null) {
					output.close();
				}
			} catch (IOException ex) {
				log.error(ex.getMessage());
			}
		}
	}
	
	@RequestMapping("/queryLocal")
	public void queryLocal(HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageDto pageDto = new PageDto();
		
		Map<String,Object> map;
		List<Map<String,Object>> rows = new ArrayList<Map<String,Object>>();
		map = new HashMap<String, Object>();
		map.put("contentName", "综合费用率");
		rows.add(map);
		map = new HashMap<String, Object>();
		map.put("contentName", "综合赔付率");
		rows.add(map);
		map = new HashMap<String, Object>();
		map.put("contentName", "综合成本率");
		rows.add(map);
		map = new HashMap<String, Object>();
		map.put("contentName", "保费（亿元）");
		rows.add(map);
		
		
		pageDto.setRows(rows);
		
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/queryPremium")
	public void queryPremium(HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageDto pageDto = new PageDto();
		
		Map<String,Object> map;
		List<Map<String,Object>> rows = new ArrayList<Map<String,Object>>();
		map = new HashMap<String, Object>();
		map.put("compnayType", "1");
		map.put("insuranceCompany", "人保");
		rows.add(map);
		map = new HashMap<String, Object>();
		map.put("compnayType", "1");
		map.put("insuranceCompany", "平安");
		rows.add(map);
		map = new HashMap<String, Object>();
		map.put("compnayType", "1");
		map.put("insuranceCompany", "太保");
		rows.add(map);
		
		pageDto.setRows(rows);
		
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/queryChannel")
	public void queryChannel(HttpServletRequest request, HttpServletResponse response) throws IOException {
		PageDto pageDto = new PageDto();
		
		Map<String,Object> map;
		List<Map<String,Object>> rows = new ArrayList<Map<String,Object>>();
		map = new HashMap<String, Object>();
		map.put("channelName", "专业代理");
		rows.add(map);
		map = new HashMap<String, Object>();
		map.put("channelName", "兼业-车商");
		rows.add(map);
		map = new HashMap<String, Object>();
		map.put("channelName", "兼业-银保");
		rows.add(map);
		map = new HashMap<String, Object>();
		map.put("channelName", "兼业-其他");
		rows.add(map);
		map = new HashMap<String, Object>();
		map.put("channelName", "经纪");
		rows.add(map);
		map = new HashMap<String, Object>();
		map.put("channelName", "直销");
		rows.add(map);
		
		pageDto.setRows(rows);
		
		SendUtil.sendJSON(response, pageDto);
	}
	
}
