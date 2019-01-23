package com.sinosafe.xszc.review.service.impl;

import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.INSERT_VO;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.REVIEW_RANK_HISTORY;
import static com.sinosafe.xszc.sqlmapper.MapperNameSpace.UPDATE_PK_VO;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.hf.framework.dao.CommonDao;
import com.sinosafe.xszc.review.service.ReviewRankHistoryService;
import com.sinosafe.xszc.review.vo.ReviewRankHistory;

public class ReviewRankHistoryServiceImpl implements ReviewRankHistoryService{
	
	private static final Log log = LogFactory.getLog(ReviewRankHistoryServiceImpl.class);

	@Autowired
	@Qualifier(value = "baseDao")
	private CommonDao dao;

	/**
	 * 说明:保存或修改记录数据<br><pre>
	 * 编写者:卢水发
	 * 创建时间:2015年7月27日 下午2:32:17 </pre>
	 * @see com.sinosafe.xszc.review.service.ReviewRankHistoryService#saveOrUpdate(com.sinosafe.xszc.review.vo.ReviewRankHistory)
	 */
	@Override
	public boolean saveOrUpdate(ReviewRankHistory rrh) {
		Map<String,Object> whereMap = new HashMap<String, Object>();
		whereMap.put("pkid", rrh.getPkid());
		whereMap.put("validInd", "1");
		boolean flag = false;
		// 判断数据库是否存在，存在作修改,不存在作添加
		if (this.isExistByWhere(whereMap)){
			dao.update(REVIEW_RANK_HISTORY+ UPDATE_PK_VO, rrh);
			flag = true;
		} else {
			dao.insert(REVIEW_RANK_HISTORY+ INSERT_VO, rrh);
			flag = true;
		}
		return flag;
	}

	/**
	 * 说明:查看某条记录是否存在<br><pre>
	 * 编写者:卢水发
	 * 创建时间:2015年7月27日 下午2:32:17 </pre>
	 * @see com.sinosafe.xszc.review.service.ReviewRankHistoryService#saveOrUpdate(com.sinosafe.xszc.review.vo.ReviewRankHistory)
	 */
	private boolean isExistByWhere(Map<String, Object> whereMap) {
		long count = (Long) dao.selectOne(REVIEW_RANK_HISTORY+ ".queryCount", whereMap);
		return count > 0;
	}

}
