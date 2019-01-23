create or replace package SALESUPPORT_IMPORT_HX is

  -- Author  : EX_ZHOUMINGSHENG
  -- Created : 2014-9-29 17:23:51
  -- Purpose : 销售支持系统数据导入核心系统

  procedure P_SALESUPPORT_IMPORT(sRest out varchar2, sMessage out varchar2);

  procedure P_SINGLE_IMPORT(sChaCde in varchar2, sRest out varchar2, sMessage out varchar2);

  --销售支持系统点击保存审核时同步外部销售人员的数据到核心系统
  procedure p_single_salesman(i_pk_id       in varchar2, -- 
                              o_result_code out varchar2, --
                              o_result_msg  out varchar2 --
                              );

  procedure P_WRITE_ERRORLOG(sError IN varchar2);

end SALESUPPORT_IMPORT_HX;
/
create or replace package body SALESUPPORT_IMPORT_HX is

  procedure P_SALESUPPORT_IMPORT(sRest out varchar2, sMessage out varchar2) is
  
  begin
    sRest    := '1';
    sMessage := '成功';
  
    begin
      delete from t_agent a
       where a.c_cha_cde in (select b.channel_code
                               from channel_main b, t_sales_import_dpt c
                              where b.APPROVE_FLAG = '1'
                                   --and b.dept_code like decode(c.c_dpt_cde,'00','',c.c_dpt_cde) || '%'
                                and b.dept_code like c.c_dpt_cde || '%'
                                and c.c_improt_flg = '1');
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          sRest    := '-1';
          sMessage := '导入前删除代理人信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          P_WRITE_ERRORLOG(sMessage);
          COMMIT;
          RETURN;
        END;
    END;
    dbms_output.put_line('导入前删除代理人信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    begin
      delete from t_confer a
       where (a.c_agt_agr_no, a.n_sub_co_no) in (select b.confer_id, b.extend_confer_code
                                                   from CHANNEL_CONFER b, t_sales_import_dpt c
                                                  where b.APPROVE_FLAG = '1'
                                                       --and b.dept_code like decode(c.c_dpt_cde,'00','',c.c_dpt_cde) || '%'
                                                    and b.dept_code like c.c_dpt_cde || '%'
                                                    and c.c_improt_flg = '1');
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          sRest    := '-1';
          sMessage := '导入前删除代理协议信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          P_WRITE_ERRORLOG(sMessage);
          COMMIT;
          RETURN;
        END;
    end;
    dbms_output.put_line('导入前删除代理协议信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    begin
      delete from T_SUBCNF a
       where (a.c_agt_agr_no, a.n_sub_co_no) in (select b.confer_id, b.extend_confer_code
                                                   from CHANNEL_CONFER_PRODUCT b, CHANNEL_CONFER c, t_sales_import_dpt d
                                                  where b.confer_id = c.confer_id
                                                    and b.extend_confer_code = c.extend_confer_code
                                                    and c.approve_flag = '1'
                                                       --and c.dept_code like decode(d.c_dpt_cde,'00','',d.c_dpt_cde) || '%'
                                                    and c.dept_code like d.c_dpt_cde || '%'
                                                    and d.c_improt_flg = '1');
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          sRest    := '-1';
          sMessage := '导入前删除代理子协议信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          P_WRITE_ERRORLOG(sMessage);
          COMMIT;
          RETURN;
        END;
    end;
    dbms_output.put_line('导入前删除代理子协议信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    --个人代理
    begin
      insert into t_agent
        (C_CHA_CDE,
         C_CHA_NME,
         C_CHA_CLS,
         C_CHA_TYPE,
         C_DPT_CDE,
         C_CHA_MRK,
         C_QLFT_NO,
         C_BSNS_NO,
         T_BIRTHDAY,
         C_SEX,
         --1
         C_EDU_CDE,
         C_MAJOR_CDE,
         C_TITLE_CDE,
         C_DUTY,
         C_CERTF_CLS,
         C_CERTF_NO,
         C_MOBILE,
         C_TEL,
         C_FAX,
         C_MAIL,
         --2
         C_ADDR,
         C_ZIP_CDE,
         C_BAD_RCRD,
         C_FRONT_BACK_MRK,
         C_AUTH_MRK,
         C_BANK_ACCOUNT,
         C_REMARK,
         C_SAVINS_FLAG,
         N_AGT_PROP,
         C_CHA_CHARACTER,
         --3
         C_ACCT_NO, --银行账号名称
         T_QLFT_BGN,
         T_QLFT_END,
         T_BSNS_BGN,
         T_BSNS_END,
         C_WORK_CERTIF,
         C_AGENT_BARGAIN_NO,
         C_BANK_PRV,
         C_BANK_CITY,
         C_BANK_MAIN, --收款方银行
         --4
         C_BANK_CODE,
         C_BAD_RCRD_FLAG,
         C_AUD_CDE,
         C_AUD_EMP,
         C_BUIS_TYPE,
         T_ADB_TM, --过期日期
         T_CRT_TM,
         T_UPD_TM,
         C_IMAGE_BATCH_NO,
         -- add new 20160401
         C_CNT_PRSN_CDE, --联系人
         --5
         C_IS_SENDMSGVHL, --是否短信通知车行
         C_COMPANY_PHONE, --我司联系人手机
         C_IS_SEND_TRUEAGT, --短信通知协作人
         C_IS_SEND_CMPNYCONTACT, --短信通知我司联系人
         C_AGTINFO_SOURCE --短信渠道信息来源：0代理人提取/1入协作人提取
         )
        select NVL(a.channel_code, CHR(0)),
               NVL(b.channel_name, CHR(0)),
               NVL(a.category, CHR(0)),
               NVL(a.property, CHR(0)),
               NVL(a.dept_code, CHR(0)),
               '1', --0-机构，1-个人
               NVL(b.license_no, CHR(0)),
               NVL(b.business_no, CHR(0)),
               b.birthday,
               NVL(b.sex, CHR(0)),
               --1
               NVL(b.educatioin, CHR(0)),
               NVL(b.educatioin, CHR(0)),
               NVL(b.title, CHR(0)),
               NVL(b.duty, CHR(0)),
               NVL(b.certify_type, CHR(0)),
               NVL(b.certify_no, CHR(0)),
               NVL(b.mobile, CHR(0)),
               NVL(b.tel, CHR(0)),
               NVL(b.fax, CHR(0)),
               NVL(b.email, CHR(0)),
               --2
               NVL(b.adderss, CHR(0)),
               NVL(b.post_code, CHR(0)),
               NVL(a.mistake_content, CHR(0)),
               '150001',
               decode(NVL(b.CHILD_DEPT_LOOK, CHR(0)), '1', 'Y', 'N'),
               NVL(a.bank_account, CHR(0)),
               NVL(a.remark, CHR(0)),
               NVL(a.finance_flag, '0'),
               a.channel_rate,
               NVL(a.CHANNEL_FEATURE, CHR(0)),
               --3
               NVL(a.BANK_NAME, CHR(0)), --银行账号名称
               NVL(b.license_valid_date, ''),
               NVL(b.license_expire_date, ''),
               NVL(b.business_valid_date, ''),
               NVL(b.business_expire_date, ''),
               NVL(b.qualification_no, CHR(0)),
               NVL(b.contract_no, CHR(0)),
               NVL(a.bank_province, CHR(0)),
               NVL(a.bank_city, CHR(0)),
               NVL(a.bank_receive, CHR(0)), --收款方银行
               --4
               NVL(a.bank_node, CHR(0)),
               NVL(a.mistake_flag, '0'),
               NVL(a.approve_flag, CHR(0)),
               NVL(substr(a.APPROVE_CODE, 1, 10), CHR(0)),
               NVL(a.BUSINESS_LINE, CHR(0)),
               a.T_ADB_TM, --过期日期
               a.created_date,
               a.updated_date,
               d.UPLOAD_ID,
               --add new 20160401
               NVL(f.contact, CHR(0)), --联系人
               --5
               decode(NVL(f.MSG_CAR, CHR(0)), '1', upper('Y'), upper('N')),
               f.COMPANY_PHONE,
               f.IS_SEND_TRUEAGT,
               f.IS_SEND_CMPNYCONTACT,
               f.AGTINFO_SOURCE
          from channel_main           a, --
               CHANNEL_AGENT_DETAIL   b, --
               CHANNEL_UPLOAD         d, --
               t_sales_import_dpt     e, --
               CHANNEL_MEDIUM_CONTACT f --
         where a.channel_code = b.channel_code
           and a.channel_code = d.main_id(+)
           and d.valid_ind(+) = '1'
           and a.APPROVE_FLAG = '1'
              --and a.dept_code like decode(e.c_dpt_cde,'00','',e.c_dpt_cde) || '%'
           and a.dept_code like e.c_dpt_cde || '%'
           and e.c_improt_flg = '1'
           and a.channel_code = f.channel_code(+)
           and f.get_flag(+) = '1';
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          sRest    := '-1';
          sMessage := '导入个人代理信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          P_WRITE_ERRORLOG(sMessage);
          COMMIT;
          RETURN;
        END;
    end;
    dbms_output.put_line('导入个人代理信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    --机构渠道
    begin
      insert into t_agent
        (C_CHA_CDE,
         C_CHA_NME,
         C_CHA_ABBR,
         C_ENG_NME,
         C_CHA_CLS,
         C_CHA_LVL,
         C_CHA_TYPE,
         C_DPT_CDE,
         C_CHA_MRK,
         C_WORK_ADDR,
         --1
         C_WEB_ADDR,
         C_BAD_RCRD,
         C_LICENSE,
         C_CHIEF,
         C_FRONT_BACK_MRK,
         C_AUTH_MRK,
         C_BANK_ACCOUNT,
         C_REMARK,
         C_UPT_DPT_CDE,
         C_SLS_CDE,
         --2
         N_CHA_LVL,
         C_PAR_CDE,
         C_SAVINS_FLAG,
         C_PLY_SIGN,
         C_OUTER_CDE,
         N_AGT_PROP,
         C_CHA_CHARACTER,
         C_ACCT_NO,
         T_QLFT_STRT_TM,
         T_QLFT_END_TM,
         --3
         T_SIGN_TM,
         C_CDD_NME,
         C_CDD_ADDR,
         C_BANK_PRV,
         C_BANK_CITY,
         C_BANK_MAIN,
         C_BANK_CODE,
         C_BAD_RCRD_FLAG,
         C_AUD_CDE,
         C_AUD_EMP,
         --4
         C_BUIS_TYPE,
         T_ADB_TM, --过期日期
         C_COOPERATE_LVL,
         C_TRA_CDE,
         C_ARA_CDE,
         C_CNT_PRSN_CDE, --联系人
         C_DUTY,
         C_MOBILE,
         C_TEL,
         C_FAX,
         --5
         C_MAIL,
         C_ADDR,
         C_ZIP_CDE,
         C_IS_SENDMSGVHL,
         C_IS_SENDMSGCLNT,
         T_CRT_TM,
         T_UPD_TM,
         C_CITY_CDE,
         C_AREA_CDE,
         C_CHANNEL_CDE,
         --6
         C_INNER_CDE,
         C_UKEY_CDE,
         C_AGENTORG_CDE,
         C_IMAGE_BATCH_NO,
         C_COMPANY_PHONE,
         C_IS_SEND_TRUEAGT,
         C_IS_SEND_CMPNYCONTACT,
         C_AGTINFO_SOURCE)
        select NVL(a.channel_code, CHR(0)),
               NVL(b.medium_cname, CHR(0)),
               NVL(b.simple_name, CHR(0)),
               NVL(b.medium_ename, CHR(0)),
               NVL(a.category, CHR(0)),
               NVL(b.channel_level, CHR(0)),
               NVL(a.property, CHR(0)),
               NVL(a.dept_code, CHR(0)),
               '0', --0-机构，1-个人
               NVL(a.office_address, CHR(0)),
               --1
               NVL(b.website, CHR(0)),
               NVL(a.mistake_content, CHR(0)),
               NVL(b.licence, CHR(0)),
               NVL(b.legal, CHR(0)),
               '150001',
               decode(NVL(b.CHILD_DEPT_LOOK, CHR(0)), '1', 'Y', 'N'),
               NVL(a.bank_account, CHR(0)),
               NVL(a.remark, CHR(0)),
               NVL(b.parent_medium_code, CHR(0)),
               NVL(b.PROCESS_USER_CODE, CHR(0)),
               --2
               NVL(b.cha_level, 0),
               NVL(b.parent_channel_code, CHR(0)),
               NVL(a.finance_flag, '0'),
               NVL(b.finance_policy_flag, CHR(0)),
               NVL(b.channel_outer_code, NULL),
               NVL(a.channel_rate, 0),
               NVL(a.CHANNEL_FEATURE, CHR(0)),
               NVL(a.BANK_NAME, CHR(0)),
               NVL(b.valid_date, ''),
               NVL(b.expire_date, ''),
               --3
               NVL(b.sign_date, ''),
               NVL(i.NODE_NAME, NULL),
               NVL(i.ADDRESS, NULL),
               NVL(a.bank_province, CHR(0)),
               NVL(a.bank_city, CHR(0)),
               NVL(a.bank_receive, CHR(0)),
               NVL(a.bank_node, CHR(0)),
               NVL(a.mistake_flag, '0'),
               NVL(a.approve_flag, CHR(0)),
               NVL(substr(a.APPROVE_CODE, 1, 10), CHR(0)),
               --4
               NVL(a.BUSINESS_LINE, CHR(0)),
               a.T_ADB_TM, --过期日期
               NVL(b.PARTER_LEVEL, CHR(0)),
               NVL(b.profession, CHR(0)),
               NVL(b.COUNTRY, CHR(0)),
               NVL(f.contact, CHR(0)), --联系人
               NVL(f.TITLE, CHR(0)),
               NVL(f.MOBILE, CHR(0)),
               NVL(f.tel, CHR(0)),
               NVL(f.fax, CHR(0)),
               --5
               NVL(f.email, CHR(0)),
               NVL(f.ADDRESSS, CHR(0)),
               NVL(f.post, CHR(0)),
               decode(NVL(f.MSG_CAR, CHR(0)), '1', 'Y', 'N'),
               decode(NVL(MSG_CUSTOMER, CHR(0)), '1', 'Y', 'N'),
               a.created_date,
               a.updated_date,
               NVL(b.CITY_CODE, CHR(0)),
               NVL(b.AREA_CODE, CHR(0)),
               NVL(b.CHANNEL_EXTEND_CODE, CHR(0)),
               --6
               b.inner_code,
               b.C_UKEY_CDE,
               b.C_AGENTORG_CDE,
               h.UPLOAD_ID,
               f.COMPANY_PHONE,
               f.IS_SEND_TRUEAGT,
               f.IS_SEND_CMPNYCONTACT,
               f.AGTINFO_SOURCE
          from channel_main           a,
               CHANNEL_MEDIUM_DETAIL  b,
               CHANNEL_MEDIUM_CONTACT f,
               CHANNEL_UPLOAD         h,
               CHANNEL_MEDIUM_NODE    i,
               t_sales_import_dpt     j
         where a.channel_code = b.channel_code
           and a.channel_code = h.main_id(+)
           and h.valid_ind(+) = '1'
           and a.channel_code = i.channel_code(+)
           and i.GET_FLAG(+) = '1'
           and a.channel_code = f.channel_code(+)
           and f.GET_FLAG(+) = '1'
           and a.APPROVE_FLAG = '1'
              --and a.dept_code like decode(j.c_dpt_cde,'00','',j.c_dpt_cde) || '%'
           and a.dept_code like j.c_dpt_cde || '%'
           and j.c_improt_flg = '1';
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          sRest    := '-1';
          sMessage := '导入机构渠道信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          P_WRITE_ERRORLOG(sMessage);
          COMMIT;
          RETURN;
        END;
    end;
    dbms_output.put_line('导入机构渠道信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    --更新开户行网点
    begin
      update t_agent b
         set b.C_BANK_NME =
             (select NVL(c.C_NODE_CNM, CHR(0))
                from T_FIN_BANK_NODE c
               where c.C_REGION_CDE = b.C_BANK_PRV
                 and c.C_COUNTRY_CDE in (select C_COUNTRY_CDE from T_FIN_REGION where C_CITY_CDE = b.C_BANK_CITY)
                 and c.C_BANK_CDE = b.C_BANK_MAIN
                 and c.C_NODE_CDE = b.C_BANK_CODE
                 and (c.t_adb_tm is null or c.t_adb_tm > sysdate));
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          sRest    := '-1';
          sMessage := '更新开户行网点名称失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          P_WRITE_ERRORLOG(sMessage);
          COMMIT;
          RETURN;
        END;
    end;
    dbms_output.put_line('更新开户行网点名称完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    --代理协议
    begin
      insert into t_confer
        (C_AGT_AGR_NO,
         N_SUB_CO_NO,
         C_AUTH_MRK,
         C_CO_MRK,
         C_UDR_MRK,
         C_CLNT_CDE,
         C_CLNT_NME,
         C_DPT_CDE,
         T_EFFC_TM,
         T_CO_STRT_TM,
         T_CO_END_TM,
         C_CO_CNT,
         C_UNDR_PRSN,
         C_UDR_END_MRK,
         N_BAL_CYC,
         C_SLS_CDE,
         T_CRT_TM,
         T_UPD_TM)
        select NVL(a.confer_id, CHR(0)),
               NVL(a.extend_confer_code, 0),
               decode(NVL(a.GRANT_DEPT, CHR(0)), '1', 'Y', 'N'),
               NVL(a.confer_type, CHR(0)),
               NVL(a.APPROVE_FLAG, CHR(0)),
               NVL(a.channel_code, CHR(0)),
               NVL(b.C_CHA_NME, CHR(0)),
               NVL(a.dept_code, CHR(0)),
               a.valid_date,
               a.sign_date,
               a.expire_date,
               NVL(a.remark, CHR(0)),
               NVL(substr(a.APPROVE_CODE, 1, 10), CHR(0)),
               '1',
               NVL(a.calclate_period, 0),
               NVL(b.c_sls_cde, CHR(0)),
               a.created_date,
               a.updated_date
          from CHANNEL_CONFER a, t_agent b, t_sales_import_dpt c
         where a.channel_code = b.C_CHA_CDE
           and a.APPROVE_FLAG = '1'
           and a.VALID_IND = '1'
              --and a.dept_code like decode(c.c_dpt_cde,'00','',c.c_dpt_cde) || '%'
           and a.dept_code like c.c_dpt_cde || '%'
           and c.c_improt_flg = '1';
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          sRest    := '-1';
          sMessage := '导入代理协议信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          P_WRITE_ERRORLOG(sMessage);
          COMMIT;
          RETURN;
        END;
    end;
    dbms_output.put_line('导入代理协议信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    --代理子协议
    begin
      insert into T_SUBCNF
        (C_AGT_AGR_NO, N_SUB_CO_NO, C_PROD_NO, N_NCLM_PROP, N_CMM_PROP, T_CRT_TM, T_UPD_TM)
        select NVL(a.confer_id, CHR(0)),
               NVL(a.EXTEND_CONFER_CODE, 0),
               NVL(a.product_code, CHR(0)),
               NVL(a.ENDORSE_RATE, 0),
               NVL(a.commission_rate, 0),
               NVL(a.created_date, ''),
               NVL(a.updated_date, '')
          from CHANNEL_CONFER_PRODUCT a, CHANNEL_CONFER b, t_sales_import_dpt c
         where a.confer_id = b.confer_id
           and a.extend_confer_code = b.extend_confer_code
           and b.APPROVE_FLAG = '1'
           and b.valid_ind = '1'
           and a.VALID_IND = '1'
              --and b.dept_code like decode(c.c_dpt_cde,'00','',c.c_dpt_cde) || '%'
           and b.dept_code like c.c_dpt_cde || '%'
           and c.c_improt_flg = '1';
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          ROLLBACK;
          sRest    := '-1';
          sMessage := '导入代理子协议信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          P_WRITE_ERRORLOG(sMessage);
          COMMIT;
          RETURN;
        END;
    end;
    dbms_output.put_line('导入代理子协议信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    commit;
    dbms_output.put_line('提交完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
  end P_SALESUPPORT_IMPORT;

  procedure P_SINGLE_IMPORT(sChaCde in varchar2, sRest out varchar2, sMessage out varchar2) is
    nCount number;
  begin
    dbms_output.put_line('导入开始:代码:' || sChaCde || '时间' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
    sRest    := '1';
    sMessage := '成功';
  
    begin
      /* modify by zhoums on 20150416 for REQ-270:销售费用系统与核心数据同步问题 */
      delete from T_SUBCNF a
       where (a.c_agt_agr_no, a.n_sub_co_no) in (select b.confer_id, b.extend_confer_code
                                                   from CHANNEL_CONFER_PRODUCT b, CHANNEL_CONFER c
                                                  where b.confer_id = c.confer_id
                                                    and b.extend_confer_code = c.extend_confer_code
                                                    and c.approve_flag = '1'
                                                    and c.channel_code = sChaCde);
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          sRest    := '-1';
          sMessage := '导入前删除代理子协议信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          RETURN;
        END;
    end;
    dbms_output.put_line('导入前删除代理子协议信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    begin
      delete from t_confer a
       where (a.c_agt_agr_no, a.n_sub_co_no) in (select b.confer_id, b.extend_confer_code
                                                   from CHANNEL_CONFER b
                                                  where b.APPROVE_FLAG = '1'
                                                    and b.channel_code = sChaCde)
         and a.c_clnt_cde = sChaCde;
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          sRest    := '-1';
          sMessage := '导入前删除代理协议信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          RETURN;
        END;
    end;
    dbms_output.put_line('导入前删除代理协议信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    begin
      delete from t_agent a
       where a.c_cha_cde in (select b.channel_code
                               from channel_main b
                              where b.APPROVE_FLAG = '1'
                                and b.channel_code = sChaCde)
         and a.c_cha_cde = sChaCde;
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          sRest    := '-1';
          sMessage := '导入前删除代理人信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          RETURN;
        END;
    END;
    dbms_output.put_line('导入前删除代理人信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    select count(1) into nCount from CHANNEL_AGENT_DETAIL where channel_code = sChaCde;
    if nCount > 0 then
      --个人代理
      begin
        insert into t_agent
          (C_CHA_CDE,
           C_CHA_NME,
           C_CHA_CLS,
           C_CHA_TYPE,
           C_DPT_CDE,
           C_CHA_MRK,
           C_QLFT_NO,
           C_BSNS_NO,
           T_BIRTHDAY,
           C_SEX,
           --1
           C_EDU_CDE,
           C_MAJOR_CDE,
           C_TITLE_CDE,
           C_DUTY,
           C_CERTF_CLS,
           C_CERTF_NO,
           C_MOBILE,
           C_TEL,
           C_FAX,
           C_MAIL,
           --2
           C_ADDR,
           C_ZIP_CDE,
           C_BAD_RCRD,
           C_FRONT_BACK_MRK,
           C_AUTH_MRK,
           C_BANK_ACCOUNT,
           C_REMARK,
           C_SAVINS_FLAG,
           N_AGT_PROP,
           C_CHA_CHARACTER,
           --3
           C_ACCT_NO, --银行账号名称
           T_QLFT_BGN,
           T_QLFT_END,
           T_BSNS_BGN,
           T_BSNS_END,
           C_WORK_CERTIF,
           C_AGENT_BARGAIN_NO,
           C_BANK_PRV,
           C_BANK_CITY,
           C_BANK_MAIN,
           --4
           C_BANK_CODE,
           C_BAD_RCRD_FLAG,
           C_AUD_CDE,
           C_AUD_EMP,
           C_BUIS_TYPE,
           T_ADB_TM, --过期日期
           T_CRT_TM,
           T_UPD_TM,
           C_IMAGE_BATCH_NO,
           -- add new 20160401
           C_CNT_PRSN_CDE, --联系人
           --5
           C_IS_SENDMSGVHL, --是否短信通知车行
           C_COMPANY_PHONE, --我司联系人手机
           C_IS_SEND_TRUEAGT, --短信通知协作
           C_IS_SEND_CMPNYCONTACT, --短信通知我司联系人
           C_AGTINFO_SOURCE --短信渠道信息来源：0代理人提取/1入协作人提取
           )
          select NVL(a.channel_code, CHR(0)),
                 NVL(b.channel_name, CHR(0)),
                 NVL(a.category, CHR(0)),
                 NVL(a.property, CHR(0)),
                 NVL(a.dept_code, CHR(0)),
                 '1', --0-机构，1-个人
                 NVL(b.license_no, CHR(0)),
                 NVL(b.business_no, CHR(0)),
                 b.birthday,
                 NVL(b.sex, CHR(0)),
                 --1
                 NVL(b.educatioin, CHR(0)),
                 NVL(b.educatioin, CHR(0)),
                 NVL(b.title, CHR(0)),
                 NVL(b.duty, CHR(0)),
                 NVL(b.certify_type, CHR(0)),
                 NVL(b.certify_no, CHR(0)),
                 NVL(b.mobile, CHR(0)),
                 NVL(b.tel, CHR(0)),
                 NVL(b.fax, CHR(0)),
                 NVL(b.email, CHR(0)),
                 --2
                 NVL(b.adderss, CHR(0)),
                 NVL(b.post_code, CHR(0)),
                 NVL(a.mistake_content, CHR(0)),
                 '150001',
                 decode(NVL(b.CHILD_DEPT_LOOK, CHR(0)), '1', 'Y', 'N'),
                 NVL(a.bank_account, CHR(0)),
                 NVL(a.remark, CHR(0)),
                 NVL(a.finance_flag, '0'),
                 a.channel_rate,
                 NVL(a.CHANNEL_FEATURE, CHR(0)),
                 --3
                 NVL(a.BANK_NAME, CHR(0)),
                 NVL(b.license_valid_date, ''),
                 NVL(b.license_expire_date, ''),
                 NVL(b.business_valid_date, ''),
                 NVL(b.business_expire_date, ''),
                 NVL(b.qualification_no, CHR(0)),
                 NVL(b.contract_no, CHR(0)),
                 NVL(a.bank_province, CHR(0)),
                 NVL(a.bank_city, CHR(0)),
                 NVL(a.bank_receive, CHR(0)),
                 --4
                 NVL(a.bank_node, CHR(0)),
                 NVL(a.mistake_flag, '0'),
                 NVL(a.approve_flag, CHR(0)),
                 NVL(substr(a.APPROVE_CODE, 1, 10), CHR(0)),
                 NVL(a.BUSINESS_LINE, CHR(0)),
                 a.T_ADB_TM, --过期日期
                 a.created_date,
                 a.updated_date,
                 d.UPLOAD_ID,
                 --add new 20160401
                 NVL(f.contact, CHR(0)), --联系人
                 --5
                 decode(NVL(f.MSG_CAR, CHR(0)), '1', upper('Y'), upper('N')),
                 f.company_phone,
                 f.is_send_trueagt,
                 f.IS_SEND_CMPNYCONTACT,
                 f.AGTINFO_SOURCE
            from channel_main           a, --
                 CHANNEL_AGENT_DETAIL   b, --
                 CHANNEL_UPLOAD         d, --
                 CHANNEL_MEDIUM_CONTACT f --
           where a.channel_code = b.channel_code
             and a.channel_code = d.main_id(+)
             and d.valid_ind(+) = '1'
             and a.APPROVE_FLAG = '1'
             and a.channel_code = sChaCde;
      
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            sRest    := '-1';
            sMessage := '导入个人代理信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
            RETURN;
          END;
      end;
      dbms_output.put_line('导入个人代理信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
    end if;
  
    select count(1) into nCount from CHANNEL_MEDIUM_DETAIL where channel_code = sChaCde;
    if nCount > 0 then
      --机构渠道
      begin
        insert into t_agent
          (C_CHA_CDE,
           C_CHA_NME,
           C_CHA_ABBR,
           C_ENG_NME,
           C_CHA_CLS,
           C_CHA_LVL,
           C_CHA_TYPE,
           C_DPT_CDE,
           C_CHA_MRK,
           C_WORK_ADDR,
           --1
           C_WEB_ADDR,
           C_BAD_RCRD,
           C_LICENSE,
           C_CHIEF,
           C_FRONT_BACK_MRK,
           C_AUTH_MRK,
           C_BANK_ACCOUNT,
           C_REMARK,
           C_UPT_DPT_CDE,
           C_SLS_CDE,
           --2
           N_CHA_LVL,
           C_PAR_CDE,
           C_SAVINS_FLAG,
           C_PLY_SIGN,
           C_OUTER_CDE,
           N_AGT_PROP,
           C_CHA_CHARACTER,
           C_ACCT_NO,
           T_QLFT_STRT_TM,
           T_QLFT_END_TM,
           --3
           T_SIGN_TM,
           C_CDD_NME,
           C_CDD_ADDR,
           C_BANK_PRV,
           C_BANK_CITY,
           C_BANK_MAIN,
           C_BANK_CODE,
           C_BAD_RCRD_FLAG,
           C_AUD_CDE,
           C_AUD_EMP,
           --4
           C_BUIS_TYPE,
           T_ADB_TM, --过期日期
           C_COOPERATE_LVL,
           C_TRA_CDE,
           C_ARA_CDE,
           C_CNT_PRSN_CDE, --联系人
           C_DUTY,
           C_MOBILE,
           C_TEL,
           C_FAX,
           --5
           C_MAIL,
           C_ADDR,
           C_ZIP_CDE,
           C_IS_SENDMSGVHL,
           C_IS_SENDMSGCLNT,
           T_CRT_TM,
           T_UPD_TM,
           C_CITY_CDE,
           C_AREA_CDE,
           C_CHANNEL_CDE,
           --6
           C_INNER_CDE,
           C_UKEY_CDE,
           C_AGENTORG_CDE,
           C_IMAGE_BATCH_NO,
           C_COMPANY_PHONE,
           C_IS_SEND_TRUEAGT,
           C_IS_SEND_CMPNYCONTACT,
           C_AGTINFO_SOURCE)
          select NVL(a.channel_code, CHR(0)),
                 NVL(b.medium_cname, CHR(0)),
                 NVL(b.simple_name, CHR(0)),
                 NVL(b.medium_ename, CHR(0)),
                 NVL(a.category, CHR(0)),
                 NVL(b.channel_level, CHR(0)),
                 NVL(a.property, CHR(0)),
                 NVL(a.dept_code, CHR(0)),
                 '0', --0-机构，1-个人
                 NVL(a.office_address, CHR(0)),
                 --1
                 NVL(b.website, CHR(0)),
                 NVL(a.mistake_content, CHR(0)),
                 NVL(b.licence, CHR(0)),
                 NVL(b.legal, CHR(0)),
                 '150001',
                 decode(NVL(b.CHILD_DEPT_LOOK, CHR(0)), '1', 'Y', 'N'),
                 NVL(a.bank_account, CHR(0)),
                 NVL(a.remark, CHR(0)),
                 NVL(b.parent_medium_code, CHR(0)),
                 NVL(b.PROCESS_USER_CODE, CHR(0)),
                 --2
                 NVL(b.cha_level, 0),
                 NVL(b.parent_channel_code, CHR(0)),
                 NVL(a.finance_flag, '0'),
                 NVL(b.finance_policy_flag, CHR(0)),
                 NVL(b.channel_outer_code, NULL),
                 NVL(a.channel_rate, 0),
                 NVL(a.CHANNEL_FEATURE, CHR(0)),
                 NVL(a.BANK_NAME, CHR(0)),
                 NVL(b.valid_date, ''),
                 NVL(b.expire_date, ''),
                 --3
                 NVL(b.sign_date, ''),
                 NVL(i.NODE_NAME, NULL),
                 NVL(i.ADDRESS, NULL),
                 NVL(a.bank_province, CHR(0)),
                 NVL(a.bank_city, CHR(0)),
                 NVL(a.bank_receive, CHR(0)),
                 NVL(a.bank_node, CHR(0)),
                 NVL(a.mistake_flag, '0'),
                 NVL(a.approve_flag, CHR(0)),
                 NVL(substr(a.APPROVE_CODE, 1, 10), CHR(0)),
                 --4
                 NVL(a.BUSINESS_LINE, CHR(0)),
                 a.T_ADB_TM, --过期日期
                 NVL(b.PARTER_LEVEL, CHR(0)),
                 NVL(b.profession, CHR(0)),
                 NVL(b.COUNTRY, CHR(0)),
                 NVL(f.contact, CHR(0)), --联系人
                 NVL(f.TITLE, CHR(0)),
                 NVL(f.MOBILE, CHR(0)),
                 NVL(f.tel, CHR(0)),
                 NVL(f.fax, CHR(0)),
                 --5
                 NVL(f.email, CHR(0)),
                 NVL(f.ADDRESSS, CHR(0)),
                 NVL(f.post, CHR(0)),
                 decode(NVL(f.MSG_CAR, CHR(0)), '1', 'Y', 'N'),
                 decode(NVL(MSG_CUSTOMER, CHR(0)), '1', 'Y', 'N'),
                 a.created_date,
                 a.updated_date,
                 NVL(b.CITY_CODE, CHR(0)),
                 NVL(b.AREA_CODE, CHR(0)),
                 NVL(b.CHANNEL_EXTEND_CODE, CHR(0)),
                 --6
                 b.inner_code,
                 b.C_UKEY_CDE,
                 b.C_AGENTORG_CDE,
                 h.UPLOAD_ID,
                 f.COMPANY_PHONE,
                 f.IS_SEND_TRUEAGT,
                 f.IS_SEND_CMPNYCONTACT,
                 f.AGTINFO_SOURCE
            from channel_main           a,
                 CHANNEL_MEDIUM_DETAIL  b,
                 CHANNEL_MEDIUM_CONTACT f,
                 CHANNEL_UPLOAD         h,
                 CHANNEL_MEDIUM_NODE    i
           where a.channel_code = b.channel_code
             and a.channel_code = h.main_id(+)
             and h.valid_ind(+) = '1'
             and a.channel_code = i.channel_code(+)
             and i.GET_FLAG(+) = '1'
             and a.channel_code = f.channel_code(+)
             and f.GET_FLAG(+) = '1'
             and a.APPROVE_FLAG = '1'
             and a.channel_code = sChaCde;
      
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            sRest    := '-1';
            sMessage := '导入机构渠道信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
            RETURN;
          END;
      end;
      dbms_output.put_line('导入机构渠道信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
    end if;
  
    --更新开户行网点
    begin
      update t_agent b
         set b.C_BANK_NME =
             (select NVL(c.C_NODE_CNM, CHR(0))
                from T_FIN_BANK_NODE c
               where c.C_REGION_CDE = b.C_BANK_PRV
                 and c.C_COUNTRY_CDE in (select C_COUNTRY_CDE from T_FIN_REGION where C_CITY_CDE = b.C_BANK_CITY)
                 and c.C_BANK_CDE = b.C_BANK_MAIN
                 and c.C_NODE_CDE = b.C_BANK_CODE
                 and (c.t_adb_tm is null or c.t_adb_tm > sysdate))
       where b.c_cha_cde = sChaCde;
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          sRest    := '-1';
          sMessage := '更新开户行网点名称失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          RETURN;
        END;
    end;
    dbms_output.put_line('更新开户行网点名称完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    --代理协议
    begin
      /* modify by zhoums on 20150416 for REQ-270:销售费用系统与核心数据同步问题 */
      insert into t_confer
        (C_AGT_AGR_NO,
         N_SUB_CO_NO,
         C_AUTH_MRK,
         C_CO_MRK,
         C_UDR_MRK,
         C_CLNT_CDE,
         C_CLNT_NME,
         C_DPT_CDE,
         T_EFFC_TM,
         T_CO_STRT_TM,
         T_CO_END_TM,
         C_CO_CNT,
         C_UNDR_PRSN,
         C_UDR_END_MRK,
         N_BAL_CYC,
         C_SLS_CDE,
         T_CRT_TM,
         T_UPD_TM)
        select NVL(a.confer_id, CHR(0)),
               NVL(a.extend_confer_code, 0),
               decode(NVL(a.GRANT_DEPT, CHR(0)), '1', 'Y', 'N'),
               NVL(a.confer_type, CHR(0)),
               NVL(a.APPROVE_FLAG, CHR(0)),
               NVL(a.channel_code, CHR(0)),
               NVL(b.C_CHA_NME, CHR(0)),
               NVL(a.dept_code, CHR(0)),
               a.valid_date,
               a.sign_date,
               a.expire_date,
               NVL(a.remark, CHR(0)),
               NVL(substr(a.APPROVE_CODE, 1, 10), CHR(0)),
               '1',
               NVL(a.calclate_period, 0),
               NVL(b.c_sls_cde, CHR(0)),
               a.created_date,
               a.updated_date
          from CHANNEL_CONFER a, t_agent b, channel_main c
         where a.channel_code = b.C_CHA_CDE
           and a.channel_code = c.channel_code
           and a.APPROVE_FLAG = '1'
           and a.VALID_IND = '1'
           and c.APPROVE_FLAG = '1'
           and a.channel_code = sChaCde;
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          sRest    := '-1';
          sMessage := '导入代理协议信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          RETURN;
        END;
    end;
    dbms_output.put_line('导入代理协议信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
    --代理子协议
    begin
      /* modify by zhoums on 20150416 for REQ-270:销售费用系统与核心数据同步问题 */
      insert into T_SUBCNF
        (C_AGT_AGR_NO, N_SUB_CO_NO, C_PROD_NO, N_NCLM_PROP, N_CMM_PROP, T_CRT_TM, T_UPD_TM)
        select NVL(a.confer_id, CHR(0)),
               NVL(a.EXTEND_CONFER_CODE, 0),
               NVL(a.product_code, CHR(0)),
               NVL(a.ENDORSE_RATE, 0),
               NVL(a.commission_rate, 0),
               NVL(a.created_date, ''),
               NVL(a.updated_date, '')
          from CHANNEL_CONFER_PRODUCT a, CHANNEL_CONFER b, channel_main c
         where a.confer_id = b.confer_id
           and a.extend_confer_code = b.extend_confer_code
           and b.channel_code = c.channel_code
           and b.APPROVE_FLAG = '1'
           and a.VALID_IND = '1'
           and c.APPROVE_FLAG = '1'
           and b.channel_code = sChaCde;
    
    EXCEPTION
      WHEN OTHERS THEN
        BEGIN
          sRest    := '-1';
          sMessage := '导入代理子协议信息失败，错误代码:' || SUBSTR(SQLERRM, 1, 500);
          RETURN;
        END;
    end;
    dbms_output.put_line('导入代理子协议信息完成:' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
  
  end P_SINGLE_IMPORT;

  --销售支持保存审核外部销售人员时，同步数据到核心
  procedure p_single_salesman(i_pk_id       in varchar2, -- 
                              o_result_code out varchar2, --
                              o_result_msg  out varchar2 --
                              ) is
  begin
    dbms_output.put_line('开始同步外部渠道的销售人员:' || i_pk_id);
    begin
      merge into channel_salesman t1
      using channel_salesman_orig t2
      on (t1.pk_id = t2.pk_id and t1.pk_id = i_pk_id)
      when matched then
        update set t1.status = t2.status, t1.telephone = t2.telephone, t1.valid_ind = t2.valid_ind
      when not matched then
        insert
          (pk_id,
           channel_code,
           name,
           sex,
           id_number,
           birthday,
           mobile,
           telephone,
           education,
           email,
           fax,
           address,
           valid_ind,
           created_user,
           created_date,
           updated_user,
           updated_date,
           status,
           approve)
        values
          (t2.pk_id,
           t2.channel_code,
           t2.name,
           t2.sex,
           t2.id_number,
           t2.birthday,
           t2.mobile,
           t2.telephone,
           t2.education,
           t2.email,
           t2.fax,
           t2.address,
           t2.valid_ind,
           'admin',
           sysdate,
           'admin',
           sysdate,
           t2.status,
           '1') where t2.pk_id = i_pk_id;
      --更新记录数字
      o_result_msg := '同步外部销售人员到核心时成功，提交记录数:' || to_char(sql%rowcount);
    exception
      when others then
        begin
          o_result_code := '-1';
          o_result_msg  := '同步外部销售人员到核心时出错:' || i_pk_id || ',' || substr(sqlerrm, 1, 500);
          rollback;
          return;
        end;
    end;
    o_result_code := '1';
    --
    commit;
  
  end p_single_salesman;

  procedure P_WRITE_ERRORLOG(sError IN varchar2) is
  begin
  
    insert into t_sales_import_error (c_error) values (sError);
  
  end P_WRITE_ERRORLOG;

end SALESUPPORT_IMPORT_HX;
/
