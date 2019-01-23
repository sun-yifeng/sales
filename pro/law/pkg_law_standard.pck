create or replace package pkg_law_standard /*Testpackage*/
 as
  -- purpose : 计算标保

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
    v_bgn_date date := to_date(i_calc_month || '01', 'yyyymmdd'); --取月份第一天
  begin
  
    -- 险种系数
    p_pro_rate(i_dept_code, i_version_id, i_user_name, i_task_id, v_bgn_date);
    -- 业务线系数TODO 只有信保才用此系数
    --p_line_rate(i_dept_code, i_version_id,i_user_name,i_task_id,v_bgn_date);
    -- 车型系数
    p_vhl_rate(i_dept_code, i_version_id, i_user_name, i_task_id, v_bgn_date);
    -- 渠道系数
    p_cha_rate(i_dept_code, i_version_id, i_user_name, i_task_id, v_bgn_date);
    -- 业务来源系数
    p_orig_rate(i_dept_code, i_version_id, i_user_name, i_task_id, v_bgn_date);
    --计算标保
    p_calc_all(i_dept_code, i_version_id, i_user_name, i_task_id, v_bgn_date);
  
    return 1;
    --异常处理
  exception
    when others then
      rollback;
      pkg_law_log.log_error('pkg_law_standard.run', i_task_id, i_user_name, '计算标准保费时出错', sqlerrm);
      return - 1;
  end run;

  -- 1、险种系数
  procedure p_pro_rate(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date) is
    v_begin_time date := sysdate; --计算开始时间（用于记录执行所耗时间）
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
            --and t2.rate != 1 --modify by linzhonghui 不能加此条件，否则当系数由其他改为1后，重新计算，系数不会改变
         and t2.version_id = i_version_id;
    --
    commit;
    --记录耗时
    pkg_law_log.log_info('pkg_law_standard.p_pro_rate',
                         i_task_id,
                         i_user_name,
                         '险种系数耗时' || pkg_law_func.get_spend_time(v_begin_time) || '秒',
                         '');
  end p_pro_rate;
  
  --2、业务线系数
  procedure p_line_rate(i_dept_code  in char,
                        i_version_id in char,
                        i_user_name  in char,
                        i_task_id    in char,
                        i_bgn_date   in date) is
    v_begin_time date := sysdate; --计算开始时间（用于记录执行所耗时间）
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
    --记录耗时
    pkg_law_log.log_info('pkg_law_standard.p_line_rate',
                         i_task_id,
                         i_user_name,
                         '业务线系数耗时' || pkg_law_func.get_spend_time(v_begin_time) || '秒',
                         '');
  end p_line_rate;

  --3、车型系数
  procedure p_vhl_rate(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date) is
    v_begin_time date := sysdate; --计算开始时间（用于记录执行所耗时间）
  begin
    -- 更新车型名称
    merge into t_law_mis_got_prm t1
    using (select distinct t.c_ply_no, t.typ3
             from t_law_mis_vhl t
            where t.c_dpt_cde = i_dept_code) t2
    on (t1.c_dept_cde = i_dept_code and t1.c_ply_no = t2.c_ply_no)
    when matched then
      update set t1.c_vhl_name = t2.typ3;
    --
    commit;
    -- 更新车型系数
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
    --记录耗时
    pkg_law_log.log_info('pkg_law_standard.p_vhl_rate',
                         i_task_id,
                         i_user_name,
                         '车型系数耗时' || pkg_law_func.get_spend_time(v_begin_time) || '秒',
                         '');
  end p_vhl_rate;

  --4、渠道系数,每个渠道一个系数值
  procedure p_cha_rate(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date) is
    v_begin_time date := sysdate; --计算开始时间（用于记录执行所耗时间）
  begin
    --
    merge into t_law_mis_got_prm t1
    using t_law_rate t2
    on (t1.c_dept_cde = i_dept_code and t1.c_cmpny_agt_cde = t2.rate_code) --
    when matched then
      update
         set t1.n_rate_chan = t2.rate,t1.c_cha_nme = t2.rate_name --渠道系数 和 渠道名称
       where t2.valid_ind = '1'
         and t2.rate_type = '4' --渠道系数类型
            --and t2.rate != 1 --modify by linzhonghui 不能加此条件，否则当系数由其他改为1后，重新计算，系数不会改变
         and t2.version_id = i_version_id;
    --
    commit;
    --记录耗时
    pkg_law_log.log_info('pkg_law_standard.p_cha_rate',
                         i_task_id,
                         i_user_name,
                         '渠道系数耗时' || pkg_law_func.get_spend_time(v_begin_time) || '秒',
                         '');
  end p_cha_rate;

  --5、业务来源系数（业务来源系统）
  procedure p_orig_rate(i_dept_code  in char,
                        i_version_id in char,
                        i_user_name  in char,
                        i_task_id    in char,
                        i_bgn_date   in date) is
    v_begin_time date := sysdate; --计算开始时间（用于记录执行所耗时间）
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
         set t1.n_rate_orig = t2.rate --业务来源系数
      ;
    commit;
    --记录耗时
    pkg_law_log.log_info('pkg_law_standard.p_orig_rate',
                         i_task_id,
                         i_user_name,
                         '业务来源系数耗时' || pkg_law_func.get_spend_time(v_begin_time) || '秒',
                         '');
  end p_orig_rate;

  -- 计算标保
  procedure p_calc_all(i_dept_code  in char,
                       i_version_id in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_bgn_date   in date) is
    v_begin_time date := sysdate; --计算开始时间（用于记录执行所耗时间）
  begin
    update t_law_mis_got_prm t1
       set t1.n_prem_stan = 
           ((t1.n_prem_got + nvl(t1.n_tax,0)) * nvl(t1.n_rate_vehl, 1) --乘以车型调整系数
           * nvl(t1.n_rate_prod, 1) --乘以险种调整系数
           * nvl(t1.n_rate_chan, 1) -- 乘以渠道调整系数
           --* nvl(t1.n_rate_chan,1) -- 乘以业务线调整系数 TODO
           * nvl(t1.n_rate_orig, 1) -- 乘以业务来源调整系数
           --* nvl(t1.n_rate_area, 1) -- 乘以区域调整系数(标准保费不需要)
           ),
           t1.calc_flag   = '1'
     where t1.c_dept_cde = i_dept_code;
    commit;
    --记录耗时
    pkg_law_log.log_info('pkg_law_standard.p_calc_all',
                         i_task_id,
                         i_user_name,
                         '计算标保耗时' || pkg_law_func.get_spend_time(v_begin_time) || '秒',
                         '');
  end p_calc_all;

  --计算标准保费之前先检查是否配置系数
  function f_check_rate(i_version_id in char) return integer is
    v_count number := 0;
  begin
    --todo sth...
    --dbms_output.put_line('TODO...');
  
    --验证所有类型系数是否已导入：1-险种系数，2-业务线系数，3-车型系数， 4-渠道系数, 5-业务来源系数
    for n in 1 .. 5 loop
      select count(1)
        into v_count
        from t_law_rate r
       where r.valid_ind = '1'
         and r.rate_type = '' || n
         and r.version_id = i_version_id;
    
      --缺少某个系数，直接跳过标保计算
      if v_count = 0 then
        --记录日志
        --pkg_law_log.log_error('pkg_law_standard.f_check_rate', i_task_id, i_user_name, '调整系数', sqlerrm);
        return - 1;
      end if;
    end loop;
  
    return 1;
  end;
end pkg_law_standard;
/
