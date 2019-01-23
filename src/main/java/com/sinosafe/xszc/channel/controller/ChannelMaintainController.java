package com.sinosafe.xszc.channel.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hf.framework.exception.GeneralException;
import com.hf.framework.exception.ServiceException;
import com.sinosafe.xszc.channel.service.ChannelMaintainService;
import com.sinosafe.xszc.main.service.VisitDesc;
import com.sinosafe.xszc.util.FormDto;
import com.sinosafe.xszc.util.PageDto;
import com.sinosafe.xszc.util.SendUtil;


@Controller
@RequestMapping("/channelMaintain")
public class ChannelMaintainController {

	private static final Log log = LogFactory.getLog(ChannelMaintainController.class);
	
	@Autowired
	@Qualifier("ChannelMaintainService")
	private ChannelMaintainService channelMaintainService;

	/**
	 * 渠道远程出单点维护人列表展示
	 * @param request
	 * @param response
	 * @param dto
	 * @throws GeneralException
	 */
	@RequestMapping("/queryChannelMaintain")
	@VisitDesc(label=" 渠道远程出单点维护人列表展示",actionType=4)
	public void queryChannelMaintain(HttpServletRequest request, HttpServletResponse response, FormDto dto) throws GeneralException {
		Map<String, Object> paramMap = dto.getFormMap();
		String startStr = request.getParameter("start");
		String limitStr = request.getParameter("limit");
		String queryFlag = paramMap.get("queryFlag").toString();
		PageDto pageDto = new PageDto();
		pageDto.setStart(startStr);
		pageDto.setLimit(limitStr);
		pageDto.setWhereMap(dto.getFormMap());
		try {
			pageDto = channelMaintainService.findChannelMaintainByWhere(pageDto);
			for(int i=0;i<pageDto.getRows().size();i++){
				//判断人员编码中是否存在@符号
				String salesmanCode = pageDto.getRows().get(i).get("salesmanCode").toString();
				if(!queryFlag.equals("yes")){
					pageDto.getRows().get(i).put("salesmanCname", salesmanCode);
				}
				if(salesmanCode.lastIndexOf("@") == -1){
					pageDto.getRows().get(i).put("salesmanCode", salesmanCode+"@sinosafe.com.cn");
				}
			}
		} catch (Exception e) {
			log.error(e);
			throw new ServiceException("分页查询操作异常，传入参数为：" + paramMap, e);
		}
		SendUtil.sendJSON(response, pageDto);
	}
}
