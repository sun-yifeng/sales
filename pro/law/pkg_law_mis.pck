create or replace package pkg_law_mis is

  -- Author  : sunyf
  -- Created : 2015/9/11 14:52:19
  -- Purpose : MIS系统同步程序

  -- 从MIS取数据的条件，只取当年数据+去年最后一个季度的数据
  c_end_date constant date := trunc(sysdate, 'yyyy') - 92;

  --procedure main(i_calc_month in varchar2);

  procedure p_got_prm(i_calc_month in varchar2);

  procedure p_got_prm1;

  procedure p_ply_vhl;

  procedure p_ply_vhl1;

  procedure p_pro_clm(i_calc_month in date);

--procedure p_pro_fee(i_calc_month in date);

--procedure p_clm_fee(i_calc_month in date);

end pkg_law_mis;
/
create or replace package body pkg_law_mis is
  --说明：
  --1、每个月初3号晚上抽取MIS数据，每次抽取数据时，只抽取当期的数据
  --2、取保单清单数据时，取现有的最大时间，取上年最后一个季度(92天)到当前时间的数据

  /*procedure main(i_calc_month in varchar2) is
  begin
    --同步数据
    --p_got_prm(i_calc_month);
    --p_ply_vhl();
    --p_pro_fee(i_calc_month);
    --p_clm_fee(i_calc_month);
    dbms_output.put_line('do nothing');
  end main;*/

  --清除数据，注意：特殊情况下才需要清除数据
  function f_cls_data(i_calc_month in varchar2) return varchar2 is
    v_func_name varchar(30) := 'pkg_law_mis.f_cls_data';
  begin
    dbms_output.put_line('do nothing');
    --清除数据
    --execute immediate 'alter session enable parallel dml';
    --execute immediate 'truncate table t_law_mis_got_prm';
    --execute immediate 'truncate table t_law_mis_vhl';
    --execute immediate 'truncate table t_law_mis_profit';
    --execute immediate 'truncate table t_law_mis_claim';
    --execute immediate 'alter session disable parallel dml';
  exception
    when others then
      --日志信息
      pkg_law_log.log_error(v_func_name,
                            sys_guid(),
                            'admin',
                            '同步MIS数据出错', --
                            sqlerrm);
    
  end f_cls_data;

  --取实收保费清单数据 59227170
  --表mv_tranfer.mv_fin_got_prm_list截止20160422有59227170条数据6130362
  --截止20160422如果只取有需要的数据，则有6130362条记录
  procedure p_got_prm(i_calc_month in varchar2) is
    v_pay_tm date;
    v_count  number := 0;
    --
    --v_pay_tm_1 date := to_date('2015-01-01','yyyy-mm-dd');
    --v_pay_tm_2 date := to_date('2016-01-01','yyyy-mm-dd');
  begin
    --
    select max(t.t_pay_tm) into v_pay_tm from t_law_mis_got_prm t;
    --exception
    --when no_data_found then
    --v_last := c_end_date;
    --
    for c in (select t.c_inter_cde,
                     t.c_ply_no,
                     t.c_bsns_typ,
                     t.c_buis_type,
                     t.c_prod_no,
                     t.t_pay_tm,
                     t.t_insrnc_bgn_tm,
                     t.t_insrnc_end_tm,
                     t.c_cmpny_agt_cde,
                     t.n_got_prm,
                     t.c_edr_no,
                     t.c_sls_per,
                     t.c_sls_cde,
                     t.n_tax
                from mv_tranfer.mv_fin_got_prm_list@misquery t
               where 1 = 1
                    --and t.t_pay_tm > v_pay_tm --
                 and (t.t_pay_tm >= to_date('2016-01-01', 'yyyy-mm-dd') or
                     t.t_pay_tm < to_date('2016-01-01', 'yyyy-mm-dd')) --
              
              ) loop
      --
      insert into t_law_mis_got_prm
        (pk_id,
         c_dept_cde,
         c_inter_cde,
         c_ply_no,
         c_busi_oria,
         c_busi_line,
         c_prod_no,
         t_pay_tm,
         t_insrnc_bgn_tm,
         t_insrnc_end_tm,
         c_cmpny_agt_cde,
         n_prem_got,
         endorse_no,
         created_date,
         n_tax,
         c_sls_cde,
         c_sls_per,
         c_sls_cde1)
      values
        (sys_guid(),
         substr(c.c_inter_cde, 2, 2),
         c.c_inter_cde, --机构内码
         c.c_ply_no, --保单号
         c.c_bsns_typ, --业务来源
         c.c_buis_type, --业务线
         c.c_prod_no, --产品代码
         c.t_pay_tm, --收费日期
         c.t_insrnc_bgn_tm, --保险起期
         c.t_insrnc_end_tm, --保险至期
         c.c_cmpny_agt_cde, --渠道编码
         c.n_got_prm,
         c.c_edr_no,
         sysdate,
         c.n_tax,
         c.c_sls_cde,
         c.c_sls_per,
         c.c_sls_cde);
    
      --
      v_count := v_count + 1;
      if mod(v_count, 50000) = 0 then
        commit;
      end if;
      --
    end loop;
  
    commit;
  
  end p_got_prm;

  --取实收保费清单数据 59227170
  --表mv_tranfer.mv_fin_got_prm_list截止20160422有59227170条数据6130362
  --截止20160422如果只取有需要的数据，则有6130362条记录
  procedure p_got_prm1 is
  begin
    --第1步:清除数据；
    execute immediate 'truncate table t_law_mis_got_prm';
    --第2步：抽取数据；
    insert into t_law_mis_got_prm
      (pk_id,
       c_dept_cde,
       c_inter_cde,
       c_ply_no,
       c_busi_oria,
       c_busi_line,
       c_prod_no,
       t_pay_tm,
       t_insrnc_bgn_tm,
       t_insrnc_end_tm,
       c_cmpny_agt_cde,
       n_prem_got,
       endorse_no,
       created_date,
       n_tax,
       c_sls_cde,
       c_sls_per,
       c_sls_cde1,
       sign_date,
       t_udr_date)
      select sys_guid(),
             substr(t.c_inter_cde, 2, 2),
             t.c_inter_cde, --机构内码
             t.c_ply_no, --保单号
             t.c_bsns_typ, --业务来源
             t.c_buis_type, --业务线
             t.c_prod_no, --产品代码
             t.t_pay_tm, --收费日期
             t.t_insrnc_bgn_tm, --保险起期
             t.t_insrnc_end_tm, --保险至期
             t.c_cmpny_agt_cde, --渠道编码
             nvl(t.rp_got_prm_rmb,0),  --RMB
             t.c_edr_no,
             sysdate,
             t.n_tax,
             t.c_sls_cde,
             t.c_sls_per,
             t.c_sls_cde,
             t.t_sign_tm,
             t.t_udr_date
        from mv_tranfer.mv_fin_got_prm_list@misquery t
       where ( --
              (t.t_pay_tm >= to_date('2016-01-01', 'yyyy-mm-dd')) 
            or --
              (t.t_pay_tm < to_date('2016-01-01', 'yyyy-mm-dd') and t.t_insrnc_bgn_tm >= to_date('2016-01-01', 'yyyy-mm-dd'))--
             );
    --
    commit;
    --第3步：更新电网销
    --update t_law_mis_got_prm t
    --   set t.c_sls_cde1 = t.c_sls_per
    -- where 1=1
    --   --and t.c_dept_cde in ('20', '09', '17')
    --   and t.c_sls_per is not null
    --   and (t.c_ply_no like upper('dx%') or t.c_ply_no like upper('wx%'));
    --
    update T_LAW_MIS_GOT_PRM t
      set t.c_sls_cde1 = t.c_sls_per
    where 1=1
      --and t.c_dept_cde in('09','17','20')
      and t.c_busi_line in ('925004', '925005')
      and t.c_sls_per is not null
      and t.c_sls_cde1 <> t.c_sls_per;  
    --   
    commit;
  
  end p_got_prm1;

  --导入使用性质(车型)，目前有18758820
  --表mv_tranfer.mv_ply_base_vhl截止20160422有18758820条数据
  --截止20160422如果只取有需要的数据，则有3392558条记录
  procedure p_ply_vhl is
    --只取三列数据提高性能,只取上年最后一个季度(92天)到当前时间的数据
    cursor c_vhl is
      select t.c_inter_cde, t.c_ply_no, t.typ3
        from mv_tranfer.mv_ply_base_vhl@misquery t
       where t.t_crt_tm >= c_end_date;
  
    r_vhl   c_vhl%rowtype;
    v_count number := 0;
  
  begin
  
    for r_vhl in c_vhl loop
      --导入数据
      insert into t_law_mis_vhl
        (pk_id, c_dpt_cde, c_inter_cde, c_ply_no, typ3, created_date)
        select sys_guid(),
               substr(r_vhl.c_inter_cde, 2, 2),
               r_vhl.c_inter_cde,
               r_vhl.c_ply_no,
               r_vhl.typ3,
               sysdate
          from dual;
    
      --
      v_count := v_count + 1;
      if mod(v_count, 20000) = 0 then
        commit;
      end if;
    end loop;
  
    commit;
  end p_ply_vhl;

  --导入使用性质(车型)
  procedure p_ply_vhl1 is
  begin
    --清除数据
    execute immediate 'truncate table t_law_mis_vhl';
    --插入数据
    insert into t_law_mis_vhl
      (pk_id, c_dpt_cde, c_inter_cde, c_ply_no, typ3, created_date)
      select sys_guid(),
             substr(t1.c_inter_cde, 2, 2),
             t1.c_inter_cde,
             t1.c_ply_no,
             t1.typ3,
             sysdate
        from mv_tranfer.mv_ply_base_vhl@misquery t1
       where t1.c_ply_no in (select t2.c_ply_no from t_law_mis_got_prm t2);
    --提交数据 
    commit;
  end p_ply_vhl1;

  -- 取MIS系统的数据
  -- 1、导入满期净保数据
  -- 2、导入已决未决金额
  procedure p_pro_clm(i_calc_month in date) is
    type type_varray is varray(32) of varchar2(3);
    v_arr        type_varray := type_varray('901',
                                            '902',
                                            '903',
                                            '904',
                                            '905',
                                            '906',
                                            '907',
                                            '908',
                                            '909',
                                            '910',
                                            '911',
                                            '912',
                                            '913',
                                            '914',
                                            '915',
                                            '916',
                                            '917',
                                            '918',
                                            '919',
                                            '920',
                                            '921',
                                            '922',
                                            '923',
                                            '924',
                                            '925',
                                            '926',
                                            '927',
                                            '928',
                                            '929',
                                            '930',
                                            '931');
    v_dept1      varchar(30) := '';
    v_dept2      varchar(30) := '';
    v_data_sql1  varchar(32767) := '';
    v_data_sql2  varchar(32767) := '';
    v_date_range date := add_months(trunc(i_calc_month, 'mm'), -12); --取数条件：向前滚动12个月
  begin
    dbms_output.put_line(to_char(v_date_range, 'yyyy-mm-dd'));
    -- 全量抽取mis数据，先清除t_law_mis_profit数据
    execute immediate 'truncate table t_law_mis_pro_clm';
    -- 取出MIS数据
    v_data_sql1 := 'insert into t_law_mis_pro_clm
                  (pk_id,
                   c_dept_cde,
                   c_inter_cde,
                   c_ply_no,
                   c_prod_no,
                   t_insrnc_bgn_tm,
                   t_insrnc_end_tm,
                   created_date,
                   yj_ri,
                   wj_ri,
                   manqi,
                   c_sls_cde,
                   c_sls_per,
                   c_sls_cde1,
                   rate,
                   t_udr_date)
                  select sys_guid(),
                         substr(t.c_inter_cde, 2, 2),
                         t.c_inter_cde,
                         t.c_ply_no,
                         t.c_prod_no,
                         t.t_insrnc_bgn_tm,
                         t.t_insrnc_end_tm,
                         sysdate,
                         t.clm_rate,
                         t.wj_ri,
                         t.manqi,
                         t.c_sls_cde,
                         t.c_sls_per,
                         t.c_sls_cde,
                         t.rate,
                         t.t_udr_date
                     from mis_report.p_duty_25@misquery t
                   where 1 = 1
                     and t.c_inter_cde like :v1 and t.t_insrnc_bgn_tm >= :v2';
    --更新电网销业务归属                
    v_data_sql2 := 'update t_law_mis_pro_clm t
                       set t.c_sls_cde1 = t.c_sls_per
                     where 1 = 1
                       and t.c_dept_cde = :v1
                       and (t.c_ply_no like upper(''dx%'') or t.c_ply_no like upper(''wx%''))
                       and t.c_sls_per is not null';
    --dbms_output.put_line(v_data_sql);
    for i in 1 .. v_arr.count loop
      v_dept1 := v_arr(i) || '%';
      v_dept2 := substr(v_arr(i), 2, 2);
      execute immediate v_data_sql1
        using v_dept1, v_date_range;
      dbms_output.put_line(v_dept1 || ',' ||
                           to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
      --
      execute immediate v_data_sql2
        using v_dept2;
      dbms_output.put_line(v_dept2 || ',' ||
                           to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
      commit;
      --
      update t_law_mis_pro_clm t
         set t.c_sls_cde1 = t.c_sls_per
       where 1 = 1
         --and t.c_dept_cde in('09', '17','20')
         and (t.c_ply_no like upper('dx%') or t.c_ply_no like upper('wx%'))
         and t.c_sls_per is not null
         and length(t.c_sls_per) > 10
         and (t.c_sls_per not like '%DX%' or t.c_sls_per not like '%电销%');
      --
      commit;   
    end loop;
  end p_pro_clm;

/*
  -- 此方法作废
  --导入满期净保费 =（统计时间-保险起期）/止期-起期
  --表mv_plyno_sum_all截止20160422有25062452条数据，如果只取需要的则有4884946条数据
  --表r_ply_rat！e截止20160422有16030609条数据，无取数据的时间字段
  procedure p_pro_fee(i_calc_month in date) is
    v_last       date := trunc(sysdate, 'yyyy') - 92;
    v_calc_month date := add_months(i_calc_month, 1); --取计算月份的上一个月

    cursor datas is
      select substr(t.c_inter_cde, 2, 2) c_dept_cde,
             t.c_inter_cde,
             t.c_ply_no,
             t.c_sls_cde, --客户经理
             t.t_insrnc_bgn_tm,
             t.t_insrnc_end_tm,
             t.t_udr_date,
             ((case
               when trunc(decode(t.t_insrnc_end_tm,
                                 null,
                                 (t.t_insrnc_bgn_tm + 30),
                                 t.t_insrnc_end_tm) - t.t_insrnc_bgn_tm) = 0 then
                1 --1.如果保险至期为空，则默认保险至期=保险起期+30天，
               else
                ((case
                --当保单已到期（保险止期小于当前月份第一天），则取保单的保险止期
                  when trunc(v_calc_month, 'mm') >=
                       decode(t.t_insrnc_end_tm,
                              null,
                              (t.t_insrnc_bgn_tm + 30),
                              t.t_insrnc_end_tm) then
                   decode(t.t_insrnc_end_tm,
                          null,
                          (t.t_insrnc_bgn_tm + 30),
                          t.t_insrnc_end_tm)
                --当保单未到期（保险止期大于当前月份第一天），则取当前月份第一天
                  else
                   trunc(v_calc_month, 'mm')
                end) - t.t_insrnc_bgn_tm) --分子（保单经过的天数）
                / (decode(t.t_insrnc_end_tm,
                          null,
                          (t.t_insrnc_bgn_tm + 30),
                          t.t_insrnc_end_tm) - t.t_insrnc_bgn_tm) --分母（保险总天数）
             end) * t.rp_prm_total_all * nvl(d.rate, 1)) n_fee
        from mv_tranfer.mv_plyno_sum_all@misquery t, r_ply_rate@misquery d
       where 1 = 1
         and t.c_ply_no = d.c_ply_no(+)
         and t.t_insrnc_bgn_tm >= v_last;
    datas_row datas%rowtype;
    n         number := 0;
  begin

    --全量抽取mis数据，先清除t_law_mis_profit数据
    execute immediate 'truncate table t_law_mis_profit';

    for datas_row in datas loop

      insert into t_law_mis_profit
        (pk_id,
         c_dept_cde,
         c_inter_cde,
         c_ply_no,
         c_sls_cde,
         t_insrnc_bgn_tm,
         t_insrnc_end_tm,
         t_udr_date,
         n_fee,
         created_date)
        select sys_guid(),
               datas_row.c_dept_cde,
               datas_row.c_inter_cde,
               datas_row.c_ply_no,
               datas_row.c_sls_cde, --客户经理
               datas_row.t_insrnc_bgn_tm,
               datas_row.t_insrnc_end_tm,
               datas_row.t_udr_date,
               datas_row.n_fee,
               sysdate
          from dual;

      n := n + 1;
      if mod(n, 20000) = 0 then
        commit;
      end if;

    end loop;
    commit;

  end p_pro_fee;

  -- 此方法作废
  --导入再保后赔款
  --表mv_tranfer.mv_clm_base_info_online截止20160422有4261722条数据，如果只取需要的则有4884946条数据
  --表mv_tranfer.mv_clm_base_info_online截止20160422有8167806条数据，如果只取需要的则有4884946条数据
  procedure p_clm_fee(i_calc_month in date) is
    v_calc_month date := add_months(i_calc_month, 1); --取计算月份的上一个月
    cursor datas is
      select substr(a.c_inter_cde, 2, 2) c_dept_cde,
             a.c_inter_cde,
             a.policy_no,
             a.c_sls_cde, --销售人员
             a.t_insrnc_bgn_tm,
             a.t_insrnc_end_tm,
             a.revokecase_time,--撤单时间
             a.report_time,--报案时间
             a.t_udr_date,
             ((case
               --已决金额
                 when a.endcase_time < trunc(v_calc_month, 'mm') then
                  a.total_payment_amt_rmb
               --未决，有立案时间，取立案金额
                 when (a.endcase_time >= trunc(v_calc_month, 'mm') or
                      a.endcase_time is null) and
                      a.register_time < trunc(v_calc_month, 'mm') then
                  a.register_amt_rmb
                 else
               --未决，无立案时间，取报案金额
                  a.report_amt_rmb
       end) * nvl(d.rate, 1)) n_fee
        from mv_tranfer.mv_clm_base_info_online@misquery a,
             r_clm_rate@misquery                         d
       where 1 = 1
         and a.revokecase_ind = upper('z')
         and a.claim_no = d.claim_no(+)
         and a.t_insrnc_bgn_tm >= c_end_date;
    n         number := 0;
    datas_row datas%rowtype;
  begin
    --全量抽取mis数据，t_law_mis_claims数据
    execute immediate 'truncate table t_law_mis_claim';
    for datas_row in datas loop

      insert into t_law_mis_claim
        (pk_id,
         c_dept_cde,
         c_inter_cde,
         c_ply_no,
         c_sls_cde,
         t_insrnc_bgn_tm,
         t_insrnc_end_tm,
         revokecase_time,--撤单时间
         report_time,--报案时间
         t_udr_date,
         n_fee,
         created_user,
         created_date,
         updated_user,
         updated_date)
        select sys_guid(),
               datas_row.c_dept_cde,
               datas_row.c_inter_cde,
               datas_row.policy_no,
               datas_row.c_sls_cde, --销售人员
               datas_row.t_insrnc_bgn_tm,
               datas_row.t_insrnc_end_tm,
               datas_row.revokecase_time,
               datas_row.report_time,
               datas_row.t_udr_date,
               datas_row.n_fee,
               'system',
               sysdate,
               'system',
               sysdate
          from dual;

      n := n + 1;
      if mod(n, 20000) = 0 then
        commit;
      end if;

    end loop;
    commit;
  end p_clm_fee;
  */

end pkg_law_mis;
/
