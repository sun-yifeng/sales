说明：此目录pro用来管理存过包 20160312

--20160312 增加业务来源系数
-- Add/modify columns 
alter table T_LAW_MIS_GOT_PRM add n_rate_orig NUMBER(10,5);
-- Add comments to the columns 
comment on column T_LAW_MIS_GOT_PRM.n_rate_orig
  is '业务来源系数';
  
-- 系数类型
comment on column T_LAW_RATE.rate_type
  is ' 系数类型：1-险种系数，2-业务线系数，3-车型系数， 4-渠道系数， 5-业务来源系数';
  
-- Drop columns 
alter table T_LAW_MIS_GOT_PRM drop column v_clac_flag;
alter table T_LAW_MIS_GOT_PRM rename column v_employ_code to EMPLOY_CODE;
alter table T_LAW_MIS_GOT_PRM rename column v_dx_flag to TEL_FLAG;
alter table T_LAW_MIS_GOT_PRM rename column c_edr_no to ENDORSE_NO;
-- Add comments to the columns 
comment on column T_LAW_MIS_GOT_PRM.tel_flag
  is '是否电销导入单标记';  
-- Add comments to the columns 
comment on column T_LAW_MIS_GOT_PRM.calc_flag
  is '标准保费状态标示,0-未算过标准保费,1-已经算过标准保费';  