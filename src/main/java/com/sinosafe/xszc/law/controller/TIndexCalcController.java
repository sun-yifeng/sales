package com.sinosafe.xszc.law.controller;

import java.io.IOException;
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

import com.alibaba.fastjson.JSONObject;
import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.hf.framework.service.security.CurrentUser;
import com.sinosafe.xszc.law.service.LawTargetService;
import com.sinosafe.xszc.law.service.TIndexCalcService;
import com.sinosafe.xszc.law.vo.LawTarget;
import com.sinosafe.xszc.law.vo.TIndexCalc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;

@Controller
@RequestMapping("/tIndexCalc")
public class TIndexCalcController {

	private static final Log log = LogFactory.getLog(TIndexCalcController.class);

	@Autowired
	@Qualifier("TIndexCalcService")
	private TIndexCalcService tIndexCalcService;
	
	@Autowired
	@Qualifier("LawTargetService")
	private LawTargetService lawTargetService;
	
	@RequestMapping("/queryTIndexCalc")
	public void queryTIndexCalc(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = tIndexCalcService.findTIndexCalcByWhere(pageDto);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
	
	@RequestMapping("/queryLawTargetByVo")
	public void queryLawTargetByVo(HttpServletRequest request, HttpServletResponse response, String serno) throws GeneralException {
		LawTarget lawTarget = new LawTarget();
		lawTarget.setSerno(serno);
		lawTarget = lawTargetService.queryLawTargetByVo(lawTarget);
		response.setContentType("text/html;charset=UTF-8"); 
		SendUtil.sendJSON(response, lawTarget);
	}
	
	/**
	 * 		新增指标计算公式
	 * @param request
	 * @param response
	 * @param lawTarget
	 * @throws GeneralException
	 */
	@RequestMapping("/saveTIndexCalc")
	public void saveTIndexCalc(HttpServletRequest request, HttpServletResponse response, TIndexCalc tIndexCalc) throws GeneralException {
		tIndexCalc.setLastOpt(CurrentUser.getUser().getUserCode());
		tIndexCalc.setChannelId("1");
		tIndexCalc.setValidInd("1");
		//tIndexCalc.setVersionId("1");
		//tIndexCalc.setCondType("1");
	if( "".equals(tIndexCalc.getSerno()) ||  tIndexCalc.getSerno() == null){
			//获取最大流水号加 1
			String number = tIndexCalcService.getSerialNumber().toString();
			tIndexCalc.setSerno(number);
		}
		try {//在sql  insertVo语句中关联T_INDEX_DEF表  
			tIndexCalcService.saveTIndexCalc(tIndexCalc);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tIndexCalc), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
	
	/**
	 * 		修改计算
	 * @param request
	 * @param response
	 * @param serno
	 * @throws GeneralException
	 */
	@RequestMapping("/queryTIndexCalcToUpdate")
	public void queryTIndexCalcToUpdate(HttpServletRequest request, HttpServletResponse response, String serno) throws GeneralException {
		List<Map<String, Object>> rows;
		try {
			rows = tIndexCalcService.queryTIndexFactorToUpdate(serno);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + serno, e);
		}
		SendUtil.sendJSON(response, rows);
	}
	
	@RequestMapping("/deleteTIndexCalc")
	public void deleteTIndexCalc(HttpServletRequest request, HttpServletResponse response,String  serno) throws GeneralException, IOException {
		TIndexCalc tIndexCalc = new TIndexCalc();
		tIndexCalc.setSerno(serno);
		try {
			tIndexCalcService.deleteTIndexCalc(tIndexCalc);
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("失效操作异常，传入参数为：" + JSONObject.toJSONString(tIndexCalc), e);
		}
		SendUtil.sendJSON(response, "OK");
	}
}
