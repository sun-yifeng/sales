create or replace package pkg_law_mis is

  -- Author  : sunyf
  -- Created : 2015/9/11 14:52:19
  -- Purpose : MISϵͳͬ������

  -- ��MISȡ���ݵ�������ֻȡ��������+ȥ�����һ�����ȵ�����
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
  --˵����
  --1��ÿ���³�3�����ϳ�ȡMIS���ݣ�ÿ�γ�ȡ����ʱ��ֻ��ȡ���ڵ�����
  --2��ȡ�����嵥����ʱ��ȡ���е����ʱ�䣬ȡ�������һ������(92��)����ǰʱ�������

  /*procedure main(i_calc_month in varchar2) is
  begin
    --ͬ������
    --p_got_prm(i_calc_month);
    --p_ply_vhl();
    --p_pro_fee(i_calc_month);
    --p_clm_fee(i_calc_month);
    dbms_output.put_line('do nothing');
  end main;*/

  --������ݣ�ע�⣺��������²���Ҫ�������
  function f_cls_data(i_calc_month in varchar2) return varchar2 is
    v_func_name varchar(30) := 'pkg_law_mis.f_cls_data';
  begin
    dbms_output.put_line('do nothing');
    --�������
    --execute immediate 'alter session enable parallel dml';
    --execute immediate 'truncate table t_law_mis_got_prm';
    --execute immediate 'truncate table t_law_mis_vhl';
    --execute immediate 'truncate table t_law_mis_profit';
    --execute immediate 'truncate table t_law_mis_claim';
    --execute immediate 'alter session disable parallel dml';
  exception
    when others then
      --��־��Ϣ
      pkg_law_log.log_error(v_func_name,
                            sys_guid(),
                            'admin',
                            'ͬ��MIS���ݳ���', --
                            sqlerrm);
    
  end f_cls_data;

  --ȡʵ�ձ����嵥���� 59227170
  --��mv_tranfer.mv_fin_got_prm_list��ֹ20160422��59227170������6130362
  --��ֹ20160422���ֻȡ����Ҫ�����ݣ�����6130362����¼
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
         c.c_inter_cde, --��������
         c.c_ply_no, --������
         c.c_bsns_typ, --ҵ����Դ
         c.c_buis_type, --ҵ����
         c.c_prod_no, --��Ʒ����
         c.t_pay_tm, --�շ�����
         c.t_insrnc_bgn_tm, --��������
         c.t_insrnc_end_tm, --��������
         c.c_cmpny_agt_cde, --��������
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

  --ȡʵ�ձ����嵥���� 59227170
  --��mv_tranfer.mv_fin_got_prm_list��ֹ20160422��59227170������6130362
  --��ֹ20160422���ֻȡ����Ҫ�����ݣ�����6130362����¼
  procedure p_got_prm1 is
  begin
    --��1��:������ݣ�
    execute immediate 'truncate table t_law_mis_got_prm';
    --��2������ȡ���ݣ�
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
             t.c_inter_cde, --��������
             t.c_ply_no, --������
             t.c_bsns_typ, --ҵ����Դ
             t.c_buis_type, --ҵ����
             t.c_prod_no, --��Ʒ����
             t.t_pay_tm, --�շ�����
             t.t_insrnc_bgn_tm, --��������
             t.t_insrnc_end_tm, --��������
             t.c_cmpny_agt_cde, --��������
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
    --��3�������µ�����
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

  --����ʹ������(����)��Ŀǰ��18758820
  --��mv_tranfer.mv_ply_base_vhl��ֹ20160422��18758820������
  --��ֹ20160422���ֻȡ����Ҫ�����ݣ�����3392558����¼
  procedure p_ply_vhl is
    --ֻȡ���������������,ֻȡ�������һ������(92��)����ǰʱ�������
    cursor c_vhl is
      select t.c_inter_cde, t.c_ply_no, t.typ3
        from mv_tranfer.mv_ply_base_vhl@misquery t
       where t.t_crt_tm >= c_end_date;
  
    r_vhl   c_vhl%rowtype;
    v_count number := 0;
  
  begin
  
    for r_vhl in c_vhl loop
      --��������
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

  --����ʹ������(����)
  procedure p_ply_vhl1 is
  begin
    --�������
    execute immediate 'truncate table t_law_mis_vhl';
    --��������
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
    --�ύ���� 
    commit;
  end p_ply_vhl1;

  -- ȡMISϵͳ������
  -- 1���������ھ�������
  -- 2�������Ѿ�δ�����
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
    v_date_range date := add_months(trunc(i_calc_month, 'mm'), -12); --ȡ����������ǰ����12����
  begin
    dbms_output.put_line(to_char(v_date_range, 'yyyy-mm-dd'));
    -- ȫ����ȡmis���ݣ������t_law_mis_profit����
    execute immediate 'truncate table t_law_mis_pro_clm';
    -- ȡ��MIS����
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
    --���µ�����ҵ�����                
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
         and (t.c_sls_per not like '%DX%' or t.c_sls_per not like '%����%');
      --
      commit;   
    end loop;
  end p_pro_clm;

/*
  -- �˷�������
  --�������ھ����� =��ͳ��ʱ��-�������ڣ�/ֹ��-����
  --��mv_plyno_sum_all��ֹ20160422��25062452�����ݣ����ֻȡ��Ҫ������4884946������
  --��r_ply_rat��e��ֹ20160422��16030609�����ݣ���ȡ���ݵ�ʱ���ֶ�
  procedure p_pro_fee(i_calc_month in date) is
    v_last       date := trunc(sysdate, 'yyyy') - 92;
    v_calc_month date := add_months(i_calc_month, 1); --ȡ�����·ݵ���һ����

    cursor datas is
      select substr(t.c_inter_cde, 2, 2) c_dept_cde,
             t.c_inter_cde,
             t.c_ply_no,
             t.c_sls_cde, --�ͻ�����
             t.t_insrnc_bgn_tm,
             t.t_insrnc_end_tm,
             t.t_udr_date,
             ((case
               when trunc(decode(t.t_insrnc_end_tm,
                                 null,
                                 (t.t_insrnc_bgn_tm + 30),
                                 t.t_insrnc_end_tm) - t.t_insrnc_bgn_tm) = 0 then
                1 --1.�����������Ϊ�գ���Ĭ�ϱ�������=��������+30�죬
               else
                ((case
                --�������ѵ��ڣ�����ֹ��С�ڵ�ǰ�·ݵ�һ�죩����ȡ�����ı���ֹ��
                  when trunc(v_calc_month, 'mm') >=
                       decode(t.t_insrnc_end_tm,
                              null,
                              (t.t_insrnc_bgn_tm + 30),
                              t.t_insrnc_end_tm) then
                   decode(t.t_insrnc_end_tm,
                          null,
                          (t.t_insrnc_bgn_tm + 30),
                          t.t_insrnc_end_tm)
                --������δ���ڣ�����ֹ�ڴ��ڵ�ǰ�·ݵ�һ�죩����ȡ��ǰ�·ݵ�һ��
                  else
                   trunc(v_calc_month, 'mm')
                end) - t.t_insrnc_bgn_tm) --���ӣ�����������������
                / (decode(t.t_insrnc_end_tm,
                          null,
                          (t.t_insrnc_bgn_tm + 30),
                          t.t_insrnc_end_tm) - t.t_insrnc_bgn_tm) --��ĸ��������������
             end) * t.rp_prm_total_all * nvl(d.rate, 1)) n_fee
        from mv_tranfer.mv_plyno_sum_all@misquery t, r_ply_rate@misquery d
       where 1 = 1
         and t.c_ply_no = d.c_ply_no(+)
         and t.t_insrnc_bgn_tm >= v_last;
    datas_row datas%rowtype;
    n         number := 0;
  begin

    --ȫ����ȡmis���ݣ������t_law_mis_profit����
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
               datas_row.c_sls_cde, --�ͻ�����
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

  -- �˷�������
  --�����ٱ������
  --��mv_tranfer.mv_clm_base_info_online��ֹ20160422��4261722�����ݣ����ֻȡ��Ҫ������4884946������
  --��mv_tranfer.mv_clm_base_info_online��ֹ20160422��8167806�����ݣ����ֻȡ��Ҫ������4884946������
  procedure p_clm_fee(i_calc_month in date) is
    v_calc_month date := add_months(i_calc_month, 1); --ȡ�����·ݵ���һ����
    cursor datas is
      select substr(a.c_inter_cde, 2, 2) c_dept_cde,
             a.c_inter_cde,
             a.policy_no,
             a.c_sls_cde, --������Ա
             a.t_insrnc_bgn_tm,
             a.t_insrnc_end_tm,
             a.revokecase_time,--����ʱ��
             a.report_time,--����ʱ��
             a.t_udr_date,
             ((case
               --�Ѿ����
                 when a.endcase_time < trunc(v_calc_month, 'mm') then
                  a.total_payment_amt_rmb
               --δ����������ʱ�䣬ȡ�������
                 when (a.endcase_time >= trunc(v_calc_month, 'mm') or
                      a.endcase_time is null) and
                      a.register_time < trunc(v_calc_month, 'mm') then
                  a.register_amt_rmb
                 else
               --δ����������ʱ�䣬ȡ�������
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
    --ȫ����ȡmis���ݣ�t_law_mis_claims����
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
         revokecase_time,--����ʱ��
         report_time,--����ʱ��
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
               datas_row.c_sls_cde, --������Ա
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
