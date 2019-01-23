create or replace package pkg_law_rank is

  -- author  : sunyf
  -- created : 2014/10/22 08:23:02
  -- purpose : 职级考核计算

  -- 考核频度（一年的季度数）
  cons_freq constant number := 4;

  -- 空职级代码
  cons_null constant varchar2(20) := '100000000000000'; --000000000000000

  function f_oper_1(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) return varchar2;

  -- 考核操作2维持
  function f_oper_2(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) return varchar2;

  function f_oper_3(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) return varchar2;

  function f_oper_4(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) return varchar2;

  function f_oper_5(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) return varchar2;

  function f_oper_6(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) return varchar2;

  function f_oper_7(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) return varchar2;

  function f_oper_8(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) return varchar2;

  function f_oper_9(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) return varchar2;

  function f_oper_10(i_version_id in varchar2, --基本法版本号
                     i_dept_code  in varchar2, --机构代码
                     i_line_code  in varchar2, --业务线代码
                     i_calc_month in varchar2, --计算月份
                     i_sale_code  in varchar2, --销售人员
                     i_rank_code  in varchar2, --当前职级
                     i_user_name  in varchar2, --操作用户
                     i_task_id    in varchar2) return varchar2;

  function f_init_rank(i_dept_code  in varchar2, --机构代码
                       i_line_code  in varchar2, --业务线
                       i_version_id in varchar2, --基本法号
                       i_calc_month in varchar2, --计算年月
                       i_user_name  in varchar2, --操作用户
                       i_task_id    in varchar2) return boolean;

  function f_calc_reco(i_dept_code  in varchar2, --机构代码
                       i_line_code  in varchar2, --业务线代码
                       i_version_id in varchar2, --基本法版本号
                       i_calc_month in varchar2, --计算月份
                       i_user_name  in varchar2, --操作人
                       i_task_id    in varchar2) return boolean;

  function f_tran_rank(i_dept_code  in varchar2, --机构代码
                       i_line_code  in varchar2, --业务线代码
                       i_version_id in varchar2, --基本法版本号
                       i_calc_month in varchar2, --计算月份
                       i_user_name  in varchar2, --操作人
                       i_task_id    in varchar2) return boolean;

  function f_tran_code(i_dept_code  in varchar2, --机构代码
                       i_line_code  in varchar2, --业务线代码
                       i_version_id in varchar2, --基本法版本号
                       i_calc_month in varchar2, --计算月份
                       i_user_name  in varchar2, --操作人
                       i_task_id    in varchar2) return boolean;

  -- 计算职级
  function run(i_dept_code  in varchar2,
               i_line_code  in varchar2,
               i_version_id in varchar2,
               i_calc_month in varchar2,
               i_user_name  in varchar2, --
               i_task_id    in varchar2) return varchar2;
end pkg_law_rank;
/
create or replace package body pkg_law_rank is

  -- author  : sunyf
  -- created : 2014/10/22 08:23:02
  -- purpose : 职级考核计算
  -- 获取当前职级类型的最低职级(判断是淘汰用),要注意：
  --1、基本法配置项，有地域区分，则需要考虑"初级客户经理F","初级团队经理E"；如果不区分地域，则不考虑"初级客户经理F","初级团队经理E"；
  --2、人员处理页面，是选择同城，则需要考虑"初级客户经理F","初级团队经理E"；如果不选择同城，则不考虑"初级客户经理F","初级团队经理E"；
  -- 总结："初级客户经理F","初级团队经理E"，只适应用异地基本法的异地人员。

  /* 考核操作（选择项）：
  1  调整至年化标准保费对应的职级
  2  维持现有的销售职级
  3  向上升一级
  4  向下降一级
  5  降低到分公司最低职级
  6  降两级
  7  降三级
  8  TODO:未使用
  9  不合格(撤并)
  10 调整至(年化保费/95%)对应的职级
  */

  -- 考核操作1调整到标保对应职级
  function f_oper_1(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) --任务id
   return varchar2 is
    v_rank_code  varchar2(30);
    v_pram_str1  varchar2(500);
    v_stan_prem  number(20, 4); --标准保费
    v_work_time  number(20, 4); --在岗时间
    v_year_stan  number(20, 4); --年化标保
    v_curr_level number; --当前职级
    i_lead_flag  char(1); --经理类型
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_1';
  begin
    --取推荐职级
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --当前职级数
    select t.levle_no, t.manager_flag
      into v_curr_level, i_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --dbms_output.put_line('v_curr_level:' || v_curr_level || ',i_lead_flag:' || i_lead_flag);
    --取当年累计标准保费
    if(i_dept_code = '10')then
    	select case
             when i_lead_flag = '0' then
              t.a005 - t.a034
             when i_lead_flag = '1' then
              t.a105 - t.a149
             else
              -1
           end
      into v_stan_prem
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    else
      select case
             when i_lead_flag = '0' then
              t.a005
             when i_lead_flag = '1' then
              t.a105
             else
              -1
           end
      into v_stan_prem
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    end if;
    --dbms_output.put_line('v_stan_prem:' || v_stan_prem);
    --取在岗时间
    select case
             when i_lead_flag = '0' then
              t.a001
             when i_lead_flag = '1' then
              t.a101
             else
              -1
           end
      into v_work_time
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    --不能被0除
    if (v_work_time = 0) then
      v_work_time := -1;
    end if;
    --dbms_output.put_line('v_work_time:' || v_work_time);
    --调整的对应职级
    begin
      select t.rank_code
        into v_rank_code
        from t_law_rank_def t
       where 1 = 1
         and t.valid_ind = '1'
         and t.item_status = '1'
         and t.dept_code = i_dept_code
         and t.line_code = i_line_code
         and t.version_id = i_version_id
         and t.manager_flag = i_lead_flag
         and t.levle_no = (select max(t1.levle_no)
                             from t_law_rank_def t1
                            where 1 = 1
                              and t1.valid_ind = '1'
                              and t1.item_status = '1'
                              and t1.levle_no is not null
                              and t1.dept_code = i_dept_code
                              and t1.line_code = i_line_code
                              and t1.version_id = i_version_id
                              and t1.manager_flag = i_lead_flag
                              and t1.norm_premium <= (v_stan_prem * 12) / (10000 * v_work_time) --
                           );
    exception
      when no_data_found then
        pkg_law_log.log_warning(v_func_name,
                                i_task_id,
                                i_user_name,
                                '考核操作1调整到标保对应职级',
                                sqlerrm || ',标准保费太低,找不到对应级别,系统将不调整级别,请检查考核计算条件。标保保费:' || v_stan_prem || ',销售人员:' ||
                                i_sale_code);
        return v_rank_code;
    end;
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '考核操作1调整到标保对应职级',
                            sqlerrm || ',销售人员:' || i_sale_code || '计算月份:' || i_calc_month || ',标准保费:' || v_stan_prem ||
                            ',在岗时间:' || v_work_time || ',年化标保:' || to_char((v_stan_prem * 12) / (10000 * v_work_time)) ||
                            ',推荐职级:' || v_rank_code);
  end f_oper_1;

  -- 考核操作2维持
  function f_oper_2(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) --任务id
   return varchar2 is
    v_func_name varchar2(30) := 'pkg_law_rank.f_oper_2';
  begin
    return i_rank_code;
  end f_oper_2;

  -- 考核操作3升一级
  function f_oper_3(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) --任务id
   return varchar2 is
    v_curr_level number;
    v_top1_level number;
    v_rank_code  varchar2(30);
    v_lead_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_3';
  begin
    --取推荐职级
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --当前职级数
    select t.levle_no, t.manager_flag
      into v_curr_level, v_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --取最高级别
    select max(t.levle_no)
      into v_top1_level
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.levle_no is not null
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = v_lead_flag;
    --如果当前级别为最高级别，则返回原职级
    if (v_curr_level = v_top1_level) then
      return i_rank_code;
    end if;
    --如果当前级别非最高级别，则升一个职级
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = v_lead_flag
       and t.levle_no = v_curr_level + 1;
    --return
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '考核操作3升一级' || i_sale_code, sqlerrm);
  end f_oper_3;

  -- 考核操作4降一级
  function f_oper_4(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) --任务id
   return varchar2 is
    v_curr_level number;
    v_low1_level number;
    v_rank_code  varchar2(30);
    v_lead_flag  char(1);
    v_area_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_4';
  begin
    --取推荐职级
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --当前职级数
    select t.levle_no, t.manager_flag
      into v_curr_level, v_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --取最低职级
    select min(t.levle_no)
      into v_low1_level
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.levle_no is not null
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = v_lead_flag;
    --如果当前职级为最低，则返回原职级
    if (v_curr_level = v_low1_level) then
      return i_rank_code;
    end if;
    --如果当前职级非最低，则降一个职级
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = v_lead_flag
       and t.levle_no = v_curr_level - 1;
    --return
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '考核操作4降一级' || i_sale_code, sqlerrm);
  end f_oper_4;

  -- 考核操作5降低到最低职级
  function f_oper_5(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) --任务id
   return varchar2 is
    v_curr_level number;
    v_low1_level number;
    v_rank_code  varchar2(30);
    i_lead_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_5';
  begin
    --取推荐职级
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --当前职级数
    select t.levle_no, t.manager_flag
      into v_curr_level, i_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --取最低职级
    select min(t.levle_no)
      into v_low1_level
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.levle_no is not null
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = i_lead_flag;
    --如果当前职级最低，则返回原职级
    if (v_curr_level = v_low1_level) then
      return i_rank_code;
    end if;
    --取最低职级
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = i_lead_flag
       and t.levle_no = 1;
    --
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '考核操作5降低到最低职级' || i_sale_code, sqlerrm);
  end f_oper_5;

  -- 考核操作6连续降两级
  function f_oper_6(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) --任务id
   return varchar2 is
    v_curr_level number;
    v_rank_code  varchar2(30);
    i_lead_flag  char(1);
    v_area_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_6';
  begin
    --取推荐职级
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --当前职级数
    select t.levle_no, t.manager_flag
      into v_curr_level, i_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --如果当前级别小于等于3
    if (v_curr_level <= 3) then
      select t.rank_code
        into v_rank_code
        from t_law_rank_def t
       where t.version_id = i_version_id
         and t.dept_code = i_dept_code
         and t.line_code = i_line_code
         and t.manager_flag = i_lead_flag
         and t.levle_no = 1;
      return v_rank_code;
    end if;
    --其他情况，则降两级
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = i_lead_flag
       and t.levle_no = v_curr_level - 2;
    --
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '考核操作6连续降两级' || i_sale_code, sqlerrm);
  end f_oper_6;

  -- 考核操作7连续降三级
  function f_oper_7(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) --任务id
   return varchar2 is
    v_curr_level number;
    v_rank_code  varchar2(30);
    i_lead_flag  char(1);
    v_area_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_7';
  begin
    --取推荐职级
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --当前职级数
    select t.levle_no, t.manager_flag
      into v_curr_level, i_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --如果当前级别小于4
    if (v_curr_level <= 4) then
      select t.rank_code
        into v_rank_code
        from t_law_rank_def t
       where 1 = 1
         and t.valid_ind = '1'
         and t.item_status = '1'
         and t.version_id = i_version_id
         and t.dept_code = i_dept_code
         and t.line_code = i_line_code
         and t.manager_flag = i_lead_flag
         and t.levle_no = 1;
      return v_rank_code;
    end if;
    --其他情况，则降三级
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.version_id = i_version_id
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.manager_flag = i_lead_flag
       and t.levle_no = v_curr_level - 3;
    --
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '考核操作7连续降三级' || i_sale_code, sqlerrm);
  end f_oper_7;

  -- 考核操作8TODO：未使用这个代码
  function f_oper_8(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) --任务id
   return varchar2 is
    v_curr_level number;
    v_rank_code  varchar2(30);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_8';
  begin
    return 'TODO:';
  end f_oper_8;

  -- 考核操作9：淘汰（不合格）
  function f_oper_9(i_version_id in varchar2, --基本法版本号
                    i_dept_code  in varchar2, --机构代码
                    i_line_code  in varchar2, --业务线代码
                    i_calc_month in varchar2, --计算月份
                    i_sale_code  in varchar2, --销售人员
                    i_rank_code  in varchar2, --当前职级
                    i_user_name  in varchar2, --操作用户
                    i_task_id    in varchar2) --任务id
   return varchar2 is
    v_curr_level number;
    v_rank_code  varchar2(30);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_9';
  begin
    return upper('t');
  end f_oper_9;

  -- 考核操作10调整至(年化保费/95%)对应的职级
  function f_oper_10(i_version_id in varchar2, --基本法版本号
                     i_dept_code  in varchar2, --机构代码
                     i_line_code  in varchar2, --业务线代码
                     i_calc_month in varchar2, --计算月份
                     i_sale_code  in varchar2, --销售人员
                     i_rank_code  in varchar2, --当前职级
                     i_user_name  in varchar2, --操作用户
                     i_task_id    in varchar2) --任务id
   return varchar2 is
    v_rank_code  varchar2(30);
    v_work_time  number(20, 4); --在岗时间
    v_year_stan  number(20, 4); --年化标保
    v_stan_prem  number(16, 4); --标准保费
    v_curr_level number;
    i_lead_flag  char(1);
    v_func_name  varchar2(30) := 'pkg_law_rank.f_oper_10';
  begin
    --取推荐职级
    /*select t.recommend_rank
     into v_rank_code
     from review_rank t
    where t.valid_ind = '1'
      and t.dept_code_two = i_dept_code
      and t.line_code = i_line_code
      and t.calc_month = i_calc_month
      and t.salesman_code = i_sale_code;*/
    --当前职级数
    select t.levle_no, t.manager_flag
      into v_curr_level, i_lead_flag
      from t_law_rank_def t
     where t.rank_code = i_rank_code;
    --取当年累计标准保费
    if(i_dept_code = '10')then
    	select case
             when i_lead_flag = '0' then
              t.a005 - t.a034
             when i_lead_flag = '1' then
              t.a105 - t.a149
             else
              -1
           end
      into v_stan_prem
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    else
      select case
             when i_lead_flag = '0' then
              t.a005
             when i_lead_flag = '1' then
              t.a105
             else
              -1
           end
      into v_stan_prem
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    end if;
    --取在岗时间
    select case
             when i_lead_flag = '0' then
              t.a001
             when i_lead_flag = '1' then
              t.a101
             else
              -1
           end
      into v_work_time
      from t_law_calc_extra t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.sales_code = i_sale_code;
    -- 调整的对应职级
    select t.rank_code
      into v_rank_code
      from t_law_rank_def t
     where 1 = 1
       and t.valid_ind = '1'
       and t.item_status = '1'
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.version_id = i_version_id
       and t.manager_flag = i_lead_flag
       and t.levle_no = (select max(t1.levle_no)
                           from t_law_rank_def t1
                          where 1 = 1
                            and t.valid_ind = '1'
                            and t1.item_status = '1'
                            and t1.levle_no is not null
                            and t1.dept_code = i_dept_code
                            and t1.line_code = i_line_code
                            and t1.version_id = i_version_id
                            and t1.manager_flag = i_lead_flag
                            and t1.norm_premium <= (v_stan_prem * 12) / (10000 * v_work_time * 0.95) --
                         );
    --日志
    pkg_law_log.log_debug(v_func_name,
                          i_task_id,
                          i_user_name,
                          '考核操作1调整到标保对应职级', --
                          '销售人员:' || i_sale_code || '计算月份:' || i_calc_month || ',标准保费:' || v_stan_prem || ',在岗时间:' ||
                          v_work_time || ',年化标保:' || (v_stan_prem * 12) / (10000 * v_work_time * 0.95) || ',推荐职级:' ||
                          v_rank_code);
  
    --
    return v_rank_code;
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '考核操作1调整到标保对应职级' || i_sale_code, sqlerrm);
  end f_oper_10;

  --每次计算职级时都需要调整级别，因为分公司使用哪些职级是不确定的
  function f_adjust_level(i_dept_code  in varchar2, --机构代码
                          i_line_code  in varchar2, --业务线
                          i_version_id in varchar2, --基本法号
                          i_calc_month in varchar2, --计算年月
                          i_user_name  in varchar2, --操作用户
                          i_task_id    in varchar2) return boolean is
    v_levle_1   integer := 1;
    v_levle_2   integer := 1;
    v_func_name varchar2(30) := 'pkg_law_rank.f_adjust_level';
  begin
    --清空级别
    update t_law_rank_def t
       set t.levle_no = ''
     where 1 = 1
          --and t.valid_ind = '1'
          --and t.item_status = '1'
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.version_id = i_version_id;
  
    --客户经理0
    for c in (select t.pk_id
                from t_law_rank_def t
               where t.valid_ind = '1'
                 and t.item_status = '1'
                 and t.manager_flag = '0'
                 and t.dept_code = i_dept_code
                 and t.line_code = i_line_code
                 and t.version_id = i_version_id
                 and t.norm_premium is not null
               order by t.norm_premium) loop
      --更新级别
      update t_law_rank_def t set t.levle_no = v_levle_1 where t.pk_id = c.pk_id;
      --级别自增
      v_levle_1 := v_levle_1 + 1;
    end loop;
  
    --团队经理1
    for c in (select t.pk_id
                from t_law_rank_def t
               where t.valid_ind = '1'
                 and t.item_status = '1'
                 and t.manager_flag = '1'
                 and t.dept_code = i_dept_code
                 and t.line_code = i_line_code
                 and t.version_id = i_version_id
                 and t.norm_premium is not null
               order by t.norm_premium) loop
      --更新级别
      update t_law_rank_def t set t.levle_no = v_levle_2 where t.pk_id = c.pk_id;
      --级别自增
      v_levle_2 := v_levle_2 + 1;
    end loop;
    --
    commit;
    return true;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '调整级别时出错i_dept_code:' || i_dept_code || ',i_line_code:' || i_line_code || ',i_calc_month:' ||
                            i_calc_month,
                            sqlerrm);
      rollback;
      return false;
  end f_adjust_level;

  --清空数据
  function f_clean_data(i_dept_code  in varchar2, --机构代码
                        i_line_code  in varchar2, --业务线
                        i_version_id in varchar2, --基本法号
                        i_calc_month in varchar2, --计算年月
                        i_user_name  in varchar2, --操作用户
                        i_task_id    in varchar2) return boolean is
    v_func_name varchar2(30) := 'pkg_law_rank.f_clean_data';
  begin
    --
    delete from review_rank t
     where 1 = 1
       and t.line_code = i_line_code
       and t.dept_code_two = i_dept_code
       and t.calc_month = i_calc_month;
    --清空过程记录
    delete from t_law_calc_proce t
     where t.dept_code = i_dept_code
       and t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.line_code = i_line_code
       and t.calc_type = '3';
    --
    commit;
    return true;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '清除数据时出错i_dept_code:' || i_dept_code || ',i_line_code:' || i_line_code || ',i_calc_month:' ||
                            i_calc_month,
                            sqlerrm);
      rollback;
      return false;
  end f_clean_data;

  --初始化职级数据(先插入原职级作为推荐职级)
  function f_init_rank(i_dept_code  in varchar2, --机构代码
                       i_line_code  in varchar2, --业务线
                       i_version_id in varchar2, --基本法号
                       i_calc_month in varchar2, --计算年月
                       i_user_name  in varchar2, --操作用户
                       i_task_id    in varchar2) return boolean is
    v_func_name varchar2(30) := 'pkg_law_rank.f_rank_rank';
  begin
    --职级考核表数据
    insert into review_rank
      (rank_id,
       calc_month,
       dept_code_two,
       dept_name_two,
       dept_code_three,
       dept_name_three,
       dept_code_four,
       dept_name_four,
       group_code,
       group_name,
       salesman_code,
       salesman_name,
       rank_code,
       rank_name,
       recommend_rank,
       rank_score,
       prem_rate,
       confirm_status,
       line_code,
       valid_ind,
       created_user,
       created_date,
       updated_user,
       updated_date,
       cus_recommend_rank)
      select sys_guid(),
             i_calc_month,
             t2.dept_code dept_code_two,
             t2.dept_simple_name dept_name_two,
             t3.dept_code dept_code_three,
             t3.dept_simple_name dept_name_three,
             t4.dept_code dept_code_four,
             t4.dept_simple_name dept_name_four,
             t1.group_code,
             t5.group_name,
             t1.salesman_code,
             t1.salesman_cname,
             t1.sale_rank,
             t6.rank_name,
             t1.sale_rank,
             t7.score,
             t7.tatol_prem_rate,
             '0',
             t1.business_line,
             '1',
             'admin',
             sysdate,
             'admin',
             to_char(sysdate, 'yyyy-mm-dd hh:mm:ss'),
             t.sale_rank_two
        from t_law_salesman t
        left join salesman t1
          on t.salesman_code = t1.salesman_code
        left join department t2
          on substr(t1.dept_code, 1, 2) = t2.dept_code
        left join department t3
          on substr(t1.dept_code, 1, 4) = t3.dept_code
        left join department t4
          on substr(t1.dept_code, 1, 8) = t4.dept_code
        left join group_main t5
          on t1.group_code = t5.group_code
        left join t_law_rank_def t6
          on t1.sale_rank = t6.rank_code
        left join review_score t7
          on t1.salesman_code = t7.salesman_code
         and t7.calc_month = i_calc_month
         and t7.line_code = i_line_code
         and t7.rank_code = t1.sale_rank --团队经理按客户经理考核review_score表会出现两条记录，所以须加此条件关联
       where 1 = 1
         and t.version_id = i_version_id
         and t.dept_code = i_dept_code
         and t.line_code = i_line_code
         and t.calc_month = i_calc_month;
    return true;
    commit;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '初始职级数据时出错i_dept_code:' || i_dept_code || ',i_line_code:' || i_line_code ||
                            ',i_calc_month:' || i_calc_month,
                            sqlerrm);
      rollback;
      return false;
  end f_init_rank;

  --计算推荐职级（循环每个具体的人）
  function f_calc_reco(i_dept_code  in varchar2, --机构代码
                       i_line_code  in varchar2, --业务线代码
                       i_version_id in varchar2, --基本法版本号
                       i_calc_month in varchar2, --计算月份
                       i_user_name  in varchar2, --操作人
                       i_task_id    in varchar2) return boolean is
    v_sql_count  varchar2(1000) := ''; --统计脚本
    v_sql_result integer := 0; --统计结果
    v_sql_func   varchar2(200) := ''; --函数脚本
    v_sql_para   varchar2(200) := ''; --函数参数
    v_sql_proc   varchar2(1000) := ''; --计算过程
    v_reco_rank  varchar2(30) := ''; --推荐职级
    v_calc_flag  char(1) := '1'; --团队长按客户经理考核
    v_tmp_rank   varchar2(200) := ''; --临时职级
    v_func_name  varchar2(30) := 'pkg_law_rank.f_calc_rank';
  begin
    --按客户经理算
    select t.is_client_manager_check into v_calc_flag from t_law_define_config t where t.version_id = i_version_id;
    --取考核的人员
    for c_sales in (select t.salesman_code, t.manager_flag, t.rank_code, t.sale_rank_two
                      from t_law_salesman t
                     where 1 = 1
                       and t.version_id = i_version_id
                       and t.dept_code = i_dept_code
                       and t.line_code = i_line_code
                       and t.calc_month = i_calc_month) loop
      begin
        savepoint sp;
        --取所有的规则
        for c_rules in (select t.calc_code, t.calc_note, t.calc_cond, t.item_type, t.calc_desc
                          from t_law_calc_review t
                         where 1 = 1
                           and t.valid_ind = '1'
                           and t.item_status = '1'
                           and t.version_id = i_version_id
                         order by t.calc_code) loop
          --是否符合条件
          v_sql_count := 'select count(1) from t_law_calc_extra t where t.dept_code =''' || i_dept_code ||
                         ''' and t.calc_month = ''' || i_calc_month || ''' and t.sales_code = ''' ||
                         c_sales.salesman_code || ''' and (' || c_rules.calc_cond || ')';
          execute immediate v_sql_count
            into v_sql_result;
          --如果符合计算条件
          if (v_sql_result > 0) then
            --如果职级类型匹配（客户经理的规则对客户经理，团队经理的规则对团队经理）
            if (c_rules.item_type = c_sales.manager_flag) then
              --查询推荐职级              
              select t.recommend_rank
                into v_tmp_rank
                from review_rank t
               where t.calc_month = i_calc_month
                 and t.dept_code_two = i_dept_code
                 and t.salesman_code = c_sales.salesman_code;
              --计算操作参数
              v_sql_para := i_version_id || ',' || i_dept_code || ',' || i_line_code || ',' || i_calc_month || ',' ||
                            c_sales.salesman_code || ',' || v_tmp_rank || ',' || i_user_name || ',' || i_task_id;
              --计算推荐职级
              v_sql_func := 'begin :v0 := pkg_law_rank.f_oper_' || c_rules.calc_note ||
                            '(:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8); end;';
              execute immediate v_sql_func
                using out v_reco_rank, i_version_id, i_dept_code, i_line_code, i_calc_month, c_sales.salesman_code, v_tmp_rank, i_user_name, i_task_id;
              --记录计算过程（过程类型为3）
              v_sql_proc := 'insert into t_law_calc_proce select sys_guid(),''' || i_version_id || ''',''' ||
                            i_calc_month || ''',''' || i_dept_code || ''',''' || i_line_code || ''',''' ||
                            c_rules.calc_code || ''',''---'',''' || nvl(trim(c_rules.calc_cond), '---') || ''',''' ||
                            c_rules.calc_note || ''', 1, ''' || i_user_name || ''', sysdate, ''' || i_user_name ||
                            ''', sysdate, ''' || c_sales.salesman_code || ''',''3'',''' || c_rules.calc_note ||
                            ''', null,''' || v_reco_rank || ''' from dual';
              execute immediate v_sql_proc;
              --更新考核操作和推荐职级（第一职级）
              if (c_rules.calc_note is not null and v_reco_rank is not null) then
                update review_rank t
                   set t.recommend_rank = v_reco_rank
                 where t.valid_ind = '1'
                   and t.dept_code_two = i_dept_code
                   and t.line_code = i_line_code
                   and t.calc_month = i_calc_month
                   and t.salesman_code = c_sales.salesman_code;
              end if;
              --如果职级类型不配(并且满足团队经理按客户经理考核，即规则为客户经理...)
            elsif (c_rules.item_type = '0' and c_sales.manager_flag = '1' and v_calc_flag = '1' and
                  c_sales.sale_rank_two is not null) then
              --查询推荐职级              
              select t.cus_recommend_rank
                into v_tmp_rank
                from review_rank t
               where t.calc_month = i_calc_month
                 and t.dept_code_two = i_dept_code
                 and t.salesman_code = c_sales.salesman_code;
              --计算操作参数（过程类型为3）
              v_sql_para := i_version_id || ',' || i_dept_code || ',' || i_line_code || ',' || i_calc_month || ',' ||
                            c_sales.salesman_code || ',' || v_tmp_rank || ',' || i_user_name || ',' || i_task_id;
              --计算推荐职级
              v_sql_func := 'begin :v0 := pkg_law_rank.f_oper_' || c_rules.calc_note ||
                            '(:v1,:v2,:v3,:v4,:v5,:v6,:v7,:v8); end;';
              execute immediate v_sql_func
                using out v_reco_rank, i_version_id, i_dept_code, i_line_code, i_calc_month, c_sales.salesman_code, v_tmp_rank, i_user_name, i_task_id;
              --记录计算过程(过程类型为3）
              v_sql_proc := 'insert into t_law_calc_proce select sys_guid(),''' || i_version_id || ''',''' ||
                            i_calc_month || ''',''' || i_dept_code || ''',''' || i_line_code || ''',''' ||
                            c_rules.calc_code || ''',''---'',''' || nvl(trim(c_rules.calc_cond), '---') || ''',''' ||
                            c_rules.calc_note || ''', 1, ''' || i_user_name || ''', sysdate, ''' || i_user_name ||
                            ''', sysdate, ''' || c_sales.salesman_code || ''',''3'',''' || c_rules.calc_note ||
                            ''', null,''' || v_reco_rank || ''' from dual';
              execute immediate v_sql_proc;
              --更新考核操作和推荐职级（第二职级）
              if (c_rules.calc_note is not null and v_reco_rank is not null) then
                update review_rank t
                   set t.cus_recommend_rank = v_reco_rank
                 where t.valid_ind = '1'
                   and t.dept_code_two = i_dept_code
                   and t.line_code = i_line_code
                   and t.calc_month = i_calc_month
                   and t.salesman_code = c_sales.salesman_code;
              end if;
            end if;
          end if;
        end loop;
      exception
        when others then
          pkg_law_log.log_error(v_func_name,
                                i_task_id,
                                i_user_name,
                                '计算考核职级时失败',
                                sqlerrm || ',函数:' || v_sql_func || '参数:' || v_sql_para || ',规则数目:' || v_sql_count ||
                                ',记录过程:' || v_sql_proc);
          rollback to sp;
      end;
      commit;
    end loop;
    commit;
    return true;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '计算考核职级时失败',
                            sqlerrm || ',函数:' || v_sql_func || '参数:' || v_sql_para || ',规则数目:' || v_sql_count ||
                            ',记录过程:' || v_sql_proc);
      return true;
      rollback;
  end f_calc_reco;

  --转换评定结果“S升级”“J降级”“T淘汰”“W维持”
  function f_tran_rank(i_dept_code  in varchar2, --机构代码
                       i_line_code  in varchar2, --业务线代码
                       i_version_id in varchar2, --基本法版本号
                       i_calc_month in varchar2, --计算月份
                       i_user_name  in varchar2, --操作人
                       i_task_id    in varchar2) return boolean is
    v_leve_no_1 integer;
    v_leve_no_2 integer;
    v_tran_ret1 char(1);
    v_tran_ret2 char(1);
    v_func_name varchar2(30) := 'pkg_law_rank.f_tran_rank';
  begin
    for c_rank in (select t.rank_id, t.salesman_code, t.rank_code, t.recommend_rank,t.cus_recommend_rank,t1.sale_rank_two
                     from review_rank t left join t_law_salesman t1 
                     on t1.salesman_code = t.salesman_code
                    where 1 = 1
                      and t.valid_ind = '1'
                      and t.dept_code_two = i_dept_code
                      and t.calc_month = i_calc_month
                      and t.line_code = i_line_code) loop
      begin
        savepoint sp;
        if (c_rank.recommend_rank = upper('t')) then
          --淘汰不需要转换
          v_tran_ret1 := c_rank.recommend_rank;
        else
          --取原来职的级数
          select t1.levle_no
            into v_leve_no_1
            from t_law_rank_def t1
           where 1 = 1
             and t1.valid_ind = '1'
             and t1.item_status = '1'
             and t1.rank_code = c_rank.rank_code;
          --取推荐职的级数
          select t1.levle_no
            into v_leve_no_2
            from t_law_rank_def t1
           where 1 = 1
             and t1.valid_ind = '1'
             and t1.item_status = '1'
             and t1.rank_code = c_rank.recommend_rank;
          --转换评定结果
          if (v_leve_no_1 = v_leve_no_2) then
            v_tran_ret1 := upper('w');
          elsif (v_leve_no_1 < v_leve_no_2) then
            v_tran_ret1 := upper('s');
          elsif (v_leve_no_1 > v_leve_no_2) then
            v_tran_ret1 := upper('j');
          else
            v_tran_ret1 := upper('t');
          end if;
        end if;
        
        --如果第二职级推荐职级为“淘汰”
        if(c_rank.sale_rank_two is not null and c_rank.cus_recommend_rank is not null)then
          if(c_rank.cus_recommend_rank = upper('t')) then
             v_tran_ret2 := c_rank.cus_recommend_rank;
           else
         
           --取原来职的级数
          select t1.levle_no
            into v_leve_no_1
            from t_law_rank_def t1
           where 1 = 1
             and t1.valid_ind = '1'
             and t1.item_status = '1'
             and t1.rank_code = c_rank.sale_rank_two;
          --取推荐职的级数
          select t1.levle_no
            into v_leve_no_2
            from t_law_rank_def t1
           where 1 = 1
             and t1.valid_ind = '1'
             and t1.item_status = '1'
             and t1.rank_code = c_rank.cus_recommend_rank;
          --转换评定结果
          if (v_leve_no_1 = v_leve_no_2) then
            v_tran_ret2 := upper('w');
          elsif (v_leve_no_1 < v_leve_no_2) then
            v_tran_ret2 := upper('s');
          elsif (v_leve_no_1 > v_leve_no_2) then
            v_tran_ret2 := upper('j');
          else
            v_tran_ret2 := upper('t');
          end if;                       
         end if; 
         update review_rank t set t.cus_review_result = v_tran_ret2 where t.rank_id = c_rank.rank_id;                       
        end if;
                 
        --更新评定结果  
        update review_rank t set t.review_result = v_tran_ret1 where t.rank_id = c_rank.rank_id;
      exception
        when others then
          pkg_law_log.log_error(v_func_name,
                                i_task_id,
                                i_user_name,
                                '转换评定结果时出错,calc_month:' || i_calc_month || ',sale_code:' || c_rank.salesman_code,
                                sqlerrm);
          rollback to sp;
      end;
    end loop;
    commit;
    return true;
  end f_tran_rank;

  --转换推荐职级考核操作
  function f_tran_code(i_dept_code  in varchar2, --机构代码
                       i_line_code  in varchar2, --业务线代码
                       i_version_id in varchar2, --基本法版本号
                       i_calc_month in varchar2, --计算月份
                       i_user_name  in varchar2, --操作人
                       i_task_id    in varchar2) return boolean is
    v_tran_ret1 char(100);
    v_tran_ret2 char(100);
    v_func_name varchar2(30) := 'pkg_law_rank.f_tran_code';
  begin
    for c_reco in (select t.pk_id, t.sales_code, t.reco_rank, t.calc_desc
                     from t_law_calc_proce t
                    where 1 = 1
                      and t.dept_code = i_dept_code
                      and t.line_code = i_line_code
                      and t.version_id = i_version_id
                      and t.calc_month = i_calc_month
                      and t.calc_type = '3'
                      and t.reco_rank is not null) loop
      begin
        savepoint sp;
        if (c_reco.reco_rank = upper('t')) then
          v_tran_ret1 := '淘汰(不合格)';
        else
          select t.rank_name
            into v_tran_ret1
            from t_law_rank_def t
           where 1 = 1
             and t.rank_code = c_reco.reco_rank;
        end if;
        select t.item_name
          into v_tran_ret2
          from t_law_rule t
         where t.valid_ind = '1'
           and t.item_type = upper('A')
           and t.item_code = c_reco.calc_desc;
        --更新评定结果
        update t_law_calc_proce t
           set t.reco_rank = v_tran_ret1, t.calc_desc = v_tran_ret2
         where t.pk_id = c_reco.pk_id;
      exception
        when others then
          pkg_law_log.log_error(v_func_name,
                                i_task_id,
                                i_user_name,
                                '转换职级代码时出错,销售人员:' || c_reco.sales_code || ',职级代码:' || c_reco.reco_rank,
                                sqlerrm);
          rollback to sp;
      end;
    end loop;
    commit;
    return true;
  end f_tran_code;

  --计算职级的入口
  function run(i_dept_code  in varchar2,
               i_line_code  in varchar2,
               i_version_id in varchar2,
               i_calc_month in varchar2,
               i_user_name  in varchar2,
               i_task_id    in varchar2) return varchar2 is
    v_result boolean := true;
  begin
    --调整级别数字
    if (v_result) then
      v_result := f_adjust_level(i_dept_code, --机构代码
                                 i_line_code, --业务线
                                 i_version_id, --基本法号
                                 i_calc_month, --计算年月
                                 i_user_name, --操作用户
                                 i_task_id); --任务ID
    end if;
    --清除相关数据
    if (v_result) then
      v_result := f_clean_data(i_dept_code, --机构代码
                               i_line_code, --业务线
                               i_version_id, --基本法号
                               i_calc_month, --计算年月
                               i_user_name, --操作用户
                               i_task_id); --任务ID
    end if;
    --插入职级数据
    if (v_result) then
      v_result := f_init_rank(i_dept_code, --机构代码
                              i_line_code, --业务线
                              i_version_id, --基本法号
                              i_calc_month, --计算年月
                              i_user_name, --操作用户
                              i_task_id); --任务ID
    end if;
    --计算推荐职级
    if (v_result) then
      v_result := f_calc_reco(i_dept_code, --机构代码
                              i_line_code, --业务线代码
                              i_version_id, --基本法版本号
                              i_calc_month, --计算月份
                              i_user_name, --操作用户
                              i_task_id); --任务ID
    end if;
    --转换评定结果
    if (v_result) then
      v_result := f_tran_rank(i_dept_code, --机构代码
                              i_line_code, --业务线代码
                              i_version_id, --基本法版本号
                              i_calc_month, --计算月份
                              i_user_name, --操作人
                              i_task_id); --任务ID
    end if;
    --转换职级代码
    if (v_result) then
      v_result := f_tran_code(i_dept_code, --机构代码
                              i_line_code, --业务线代码
                              i_version_id, --基本法版本号
                              i_calc_month, --计算月份
                              i_user_name, --操作人
                              i_task_id); --任务ID
    end if;
    --
    return '1';
  exception
    when others then
      pkg_law_log.log_error('pkg_law_rank.run',
                            i_task_id,
                            i_user_name,
                            '分公司' || i_dept_code || '计算职级错误',
                            sqlerrm);
      return '-1';
  end run;

end pkg_law_rank;
/
