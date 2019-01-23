package com.sinosafe.xszc.channel.service;

import com.sinosafe.xszc.util.PageDto;

public interface MediumHistoryService {

	public PageDto findMediumByWhere(PageDto pageDto);

	public PageDto findMediumsByWhere(PageDto pageDto);
}
