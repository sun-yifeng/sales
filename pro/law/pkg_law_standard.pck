create or replace package pkg_law_standard /*Testpackage*/
 as
  -- purpose : ����걣

  function run(i_version_id in char,
               i_dept_code  in char,
               i_line_code  in char,
               i_calc_month in char,
               i_calc_all   in char,
               i_user_name  in char,
               i_task_id    in char) return number;

  --procedure update_dx_employ(t_dept_code in char, t_line_code in char, t_calc_month in char);

  --procedure p_calc_flag(t_dept_code in char, t_line_code in char, t_calc_month in char, i_calc_all in char);

  procedure p_pro_rate(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date);

  procedure p_line_rate(i_dept_code  in char,
                        i_version_id in char,
                        i_user_name  in char,
                        i_task_id    in char,
                        i_bgn_date   in date);

  procedure p_vhl_rate(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date);

  procedure p_cha_rate(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date);

  procedure p_orig_rate(i_dept_code  in char,
                        i_version_id in char,
                        i_user_name  in char,
                        i_task_id    in char,
                        i_bgn_date   in date);

  procedure p_calc_all(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date);
end pkg_law_standard;
/
create or replace package body pkg_law_standard as

  function run(i_version_id in char,
               i_dept_code  in char,
               i_line_code  in char,
               i_calc_month in char,
               i_calc_all   in char,
               i_user_name  in char,
               i_task_id    in char) return number is
    v_bgn_date date := to_date(i_calc_month || '01', 'yyyymmdd'); --ȡ�·ݵ�һ��
  begin
  
    -- ����ϵ��
    p_pro_rate(i_dept_code, i_version_id, i_user_name, i_task_id, v_bgn_date);
    -- ҵ����ϵ��TODO ֻ���ű����ô�ϵ��
    --p_line_rate(i_dept_code, i_version_id,i_user_name,i_task_id,v_bgn_date);
    -- ����ϵ��
    p_vhl_rate(i_dept_code, i_version_id, i_user_name, i_task_id, v_bgn_date);
    -- ����ϵ��
    p_cha_rate(i_dept_code, i_version_id, i_user_name, i_task_id, v_bgn_date);
    -- ҵ����Դϵ��
    p_orig_rate(i_dept_code, i_version_id, i_user_name, i_task_id, v_bgn_date);
    --����걣
    p_calc_all(i_dept_code, i_version_id, i_user_name, i_task_id, v_bgn_date);
  
    return 1;
    --�쳣����
  exception
    when others then
      rollback;
      pkg_law_log.log_error('pkg_law_standard.run', i_task_id, i_user_name, '�����׼����ʱ����', sqlerrm);
      return - 1;
  end run;

  -- 1������ϵ��
  procedure p_pro_rate(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date) is
    v_begin_time date := sysdate; --���㿪ʼʱ�䣨���ڼ�¼ִ������ʱ�䣩
  begin
    --
    merge into t_law_mis_got_prm t1
    using t_law_rate t2
    on (t1.c_dept_cde = i_dept_code and t1.c_prod_no = t2.rate_code) --
    when matched then
      update
         set t1.n_rate_prod = t2.rate --
       where t2.valid_ind = '1'
         and t2.rate_type = '1' --
            --and t2.rate != 1 --modify by linzhonghui ���ܼӴ�����������ϵ����������Ϊ1�����¼��㣬ϵ������ı�
         and t2.version_id = i_version_id;
    --
    commit;
    --��¼��ʱ
    pkg_law_log.log_info('pkg_law_standard.p_pro_rate',
                         i_task_id,
                         i_user_name,
                         '����ϵ����ʱ' || pkg_law_func.get_spend_time(v_begin_time) || '��',
                         '');
  end p_pro_rate;
  
  --2��ҵ����ϵ��
  procedure p_line_rate(i_dept_code  in char,
                        i_version_id in char,
                        i_user_name  in char,
                        i_task_id    in char,
                        i_bgn_date   in date) is
    v_begin_time date := sysdate; --���㿪ʼʱ�䣨���ڼ�¼ִ������ʱ�䣩
  begin
    --
    merge into t_law_mis_got_prm t1
    using t_law_rate t2
    on (t1.c_dept_cde = i_dept_code and t1.c_busi_line = t2.rate_code) --
    when matched then
      update
         set t1.n_rate_line = t2.rate --
       where t2.valid_ind = '1'
         and t2.rate_type = '2' --
         and t2.version_id = i_version_id;
    --
    commit;
    --��¼��ʱ
    pkg_law_log.log_info('pkg_law_standard.p_line_rate',
                         i_task_id,
                         i_user_name,
                         'ҵ����ϵ����ʱ' || pkg_law_func.get_spend_time(v_begin_time) || '��',
                         '');
  end p_line_rate;

  --3������ϵ��
  procedure p_vhl_rate(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date) is
    v_begin_time date := sysdate; --���㿪ʼʱ�䣨���ڼ�¼ִ������ʱ�䣩
  begin
    -- ���³�������
    merge into t_law_mis_got_prm t1
    using (select distinct t.c_ply_no, t.typ3
             from t_law_mis_vhl t
            where t.c_dpt_cde = i_dept_code) t2
    on (t1.c_dept_cde = i_dept_code and t1.c_ply_no = t2.c_ply_no)
    when matched then
      update set t1.c_vhl_name = t2.typ3;
    --
    commit;
    -- ���³���ϵ��
    merge into t_law_mis_got_prm t1
    using (select t.rate_name, t.rate
             from t_law_rate t
            where t.rate_type = '3'
              and t.valid_ind = '1'
              and t.version_id = i_version_id) t2
    on (t1.c_dept_cde = i_dept_code and t1.c_vhl_name = t2.rate_name)
    when matched then
      update set t1.n_rate_vehl = t2.rate;
    --
    commit;
    --��¼��ʱ
    pkg_law_log.log_info('pkg_law_standard.p_vhl_rate',
                         i_task_id,
                         i_user_name,
                         '����ϵ����ʱ' || pkg_law_func.get_spend_time(v_begin_time) || '��',
                         '');
  end p_vhl_rate;

  --4������ϵ��,ÿ������һ��ϵ��ֵ
  procedure p_cha_rate(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date) is
    v_begin_time date := sysdate; --���㿪ʼʱ�䣨���ڼ�¼ִ������ʱ�䣩
  begin
    --
    merge into t_law_mis_got_prm t1
    using t_law_rate t2
    on (t1.c_dept_cde = i_dept_code and t1.c_cmpny_agt_cde = t2.rate_code) --
    when matched then
      update
         set t1.n_rate_chan = t2.rate,t1.c_cha_nme = t2.rate_name --����ϵ�� �� ��������
       where t2.valid_ind = '1'
         and t2.rate_type = '4' --����ϵ������
            --and t2.rate != 1 --modify by linzhonghui ���ܼӴ�����������ϵ����������Ϊ1�����¼��㣬ϵ������ı�
         and t2.version_id = i_version_id;
    --
    commit;
    --��¼��ʱ
    pkg_law_log.log_info('pkg_law_standard.p_cha_rate',
                         i_task_id,
                         i_user_name,
                         '����ϵ����ʱ' || pkg_law_func.get_spend_time(v_begin_time) || '��',
                         '');
  end p_cha_rate;

  --5��ҵ����Դϵ����ҵ����Դϵͳ��
  procedure p_orig_rate(i_dept_code  in char,
                        i_version_id in char,
                        i_user_name  in char,
                        i_task_id    in char,
                        i_bgn_date   in date) is
    v_begin_time date := sysdate; --���㿪ʼʱ�䣨���ڼ�¼ִ������ʱ�䣩
  begin
    merge into t_law_mis_got_prm t1
    using (select r.rate, c.channel_code
             from channel_main c, t_law_rate r
            where r.rate_code = decode(c.channel_property,
                                       null,
                                       decode(c.channel_type, null, c.category, c.channel_type),
                                       c.channel_property)
              and c.valid_ind = '1'
              and c.status = '1'
              and r.rate_type = '5'
              and r.valid_ind = '1'--
              and r.version_id = i_version_id) t2
    on (t1.c_dept_cde = i_dept_code and t1.c_cmpny_agt_cde = t2.channel_code)
    when matched then
      update
         set t1.n_rate_orig = t2.rate --ҵ����Դϵ��
      ;
    commit;
    --��¼��ʱ
    pkg_law_log.log_info('pkg_law_standard.p_orig_rate',
                         i_task_id,
                         i_user_name,
                         'ҵ����Դϵ����ʱ' || pkg_law_func.get_spend_time(v_begin_time) || '��',
                         '');
  end p_orig_rate;

  -- ����걣
  procedure p_calc_all(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date) is
    v_begin_time date := sysdate; --���㿪ʼʱ�䣨���ڼ�¼ִ������ʱ�䣩
  begin
    update t_law_mis_got_prm t1
       set t1.n_prem_stan = 
           ((t1.n_prem_got + nvl(t1.n_tax,0)) * nvl(t1.n_rate_vehl, 1) --���Գ��͵���ϵ��
           * nvl(t1.n_rate_prod, 1) --�������ֵ���ϵ��
           * nvl(t1.n_rate_chan, 1) -- ������������ϵ��
           --* nvl(t1.n_rate_chan,1) -- ����ҵ���ߵ���ϵ�� TODO
           * nvl(t1.n_rate_orig, 1) -- ����ҵ����Դ����ϵ��
           --* nvl(t1.n_rate_area, 1) -- �����������ϵ��(��׼���Ѳ���Ҫ)
           ),
           t1.calc_flag   = '1'
     where t1.c_dept_cde = i_dept_code;
    commit;
    --��¼��ʱ
    pkg_law_log.log_info('pkg_law_standard.p_calc_all',
                         i_task_id,
                         i_user_name,
                         '����걣��ʱ' || pkg_law_func.get_spend_time(v_begin_time) || '��',
                         '');
  end p_calc_all;

  --�����׼����֮ǰ�ȼ���Ƿ�����ϵ��
  function f_check_rate(i_version_id in char) return integer is
    v_count number := 0;
  begin
    --todo sth...
    --dbms_output.put_line('TODO...');
  
    --��֤��������ϵ���Ƿ��ѵ��룺1-����ϵ����2-ҵ����ϵ����3-����ϵ���� 4-����ϵ��, 5-ҵ����Դϵ��
    for n in 1 .. 5 loop
      select count(1)
        into v_count
        from t_law_rate r
       where r.valid_ind = '1'
         and r.rate_type = '' || n
         and r.version_id = i_version_id;
    
      --ȱ��ĳ��ϵ����ֱ�������걣����
      if v_count = 0 then
        --��¼��־
        --pkg_law_log.log_error('pkg_law_standard.f_check_rate', i_task_id, i_user_name, '����ϵ��', sqlerrm);
        return - 1;
      end if;
    end loop;
  
    return 1;
  end;
end pkg_law_standard;
/
