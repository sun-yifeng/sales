create or replace package pkg_law_sum is

  -- author  : sunyf
  -- created : 2014-9-9 17:28:36
  -- purpose : 计算因素

  function f_clear_data(i_calc_month in char,
                        i_dept_code  in char,
                        i_line_code  in char,
                        i_version_id in char,
                        i_user_name  in char,
                        i_task_id    in char) return integer;

  function f_calc_factor(i_calc_month in char,
                         i_dept_code  in char,
                         i_line_code  in char,
                         i_version_id in char,
                         i_user_name  in char,
                         i_task_id    in char) return integer;

  function run(i_dept_code  in char,
               i_line_code  in char,
               i_version_id in char,
               i_calc_month in char,
               i_user_name  in char, --
               i_task_id    in char) return char;

end pkg_law_sum;
/
create or replace package body pkg_law_sum is

  -- author  : sunyf
  -- created : 2014-9-9 17:28:36
  -- purpose : 计算因素

  --清除因素数据
  function f_clear_data(i_calc_month in char,
                        i_dept_code  in char,
                        i_line_code  in char,
                        i_version_id in char,
                        i_user_name  in char,
                        i_task_id    in char) return integer is
    pragma autonomous_transaction;
    v_func_name varchar2(30) := 'pkg_law_sum.f_clear_data';
  begin
    --清除结果表
    delete from t_law_calc_value t
     where 1 = 1
       and t.dept_code = i_dept_code
       and t.line_code = i_line_code
       and t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.item_type = '1';
    --清除跟踪表
    delete from t_law_calc_proce t
     where t.version_id = i_version_id
       and t.line_code = i_line_code
       and t.calc_month = i_calc_month
       and t.calc_type = '1';
    commit;
    return 1;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '清除因素数据失败', --
                            sqlerrm);
      return - 1;
  end f_clear_data;

  --因素计算
  function f_calc_factor(i_calc_month in char,
                         i_dept_code  in char,
                         i_line_code  in char,
                         i_version_id in char,
                         i_user_name  in char,
                         i_task_id    in char) return integer is
    pragma autonomous_transaction;
    v_rank_code varchar2(50);
    v_func_sql  varchar2(1024);
    v_para_sql  varchar2(1024);
    v_para_set  boolean := false; --控制导入因素的参数
    v_func_name varchar2(30) := 'pkg_law_sum.f_calc_factor';
    v_law_cfg   char(1) := '1'; --基本法配置项
    v_toggle    boolean := false; --逻辑切换控制
    v_end_date  date := add_months(to_date(i_calc_month, 'yyyymm'), 1) - 1 / (24 * 60 * 60); --该月份最后一秒
    v_result    number(16, 4);
  begin
    --基本法配置
    select nvl(t.is_client_manager_check, '0')
      into v_law_cfg
      from t_law_define_config t
     where t.version_id = i_version_id;
    --取所有因素
    for c_factor in (select t.item_code, t.item_name, t.item_type
                       from t_law_factor_sys t
                      where t.valid_ind = '1'
                        and t.item_status = '1'
                        and t.version_id = i_version_id
                     union
                     select t.item_code, t.item_name, t.item_type
                       from t_law_factor_imp t
                      where t.valid_ind = '1'
                        and t.item_status = '1'
                        and t.version_id = i_version_id
                     union
                     select t.item_code, t.item_name, t.item_type
                       from t_law_factor_exa t
                      where t.valid_ind = '1'
                        and t.item_status = '1'
                        and t.version_id = i_version_id
                      order by item_code) loop
      --确定函数名
      if ((upper(substr(c_factor.item_code, 1, 1)) = upper('a'))) then
        v_func_sql := 'begin :v1 := pkg_law_factor.' || c_factor.item_code ||
                      '(:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10); end;';
        v_para_set := false;
      elsif (upper(substr(c_factor.item_code, 1, 1)) = upper('b')) then
        v_func_sql := 'begin :v1 := pkg_law_factor.bxxx(:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10); end;';
        v_para_set := true;
      elsif ((upper(substr(c_factor.item_code, 1, 1)) = upper('c'))) then
        v_func_sql := 'begin :v1 := pkg_law_factor.cx' || substr(c_factor.item_code, 3) ||
                      '(:v2,:v3,:v4,:v5,:v6,:v7,:v8,:v9,:v10); end;';
        v_para_set := false;
      else
        continue;
      end if;
    
      --取所有人员
      for c_sales in (select t.salesman_code, t.manager_flag, t.rank_code, t.sale_rank_two, t.group_code, t.bng_date
                        from t_law_salesman t
                       where 1 = 1
                         and t.dept_code = i_dept_code
                         and t.line_code = i_line_code
                         and t.version_id = i_version_id
                         and t.calc_month = i_calc_month
                       order by t.manager_flag, t.salesman_code) loop
        begin
          savepoint sp;
          --是否需要执行公式       
          if ((c_factor.item_type = c_sales.manager_flag) or
             (v_law_cfg = '1' and c_factor.item_type = '0' and c_sales.manager_flag = '1' and
             c_sales.sale_rank_two is not null)) then
            v_toggle := true;
          else
            v_toggle := false;
          end if;
          --是否用第二职级考核
          if (c_factor.item_type = c_sales.manager_flag) then
            v_rank_code := c_sales.rank_code;
          elsif (v_law_cfg = '1' and c_factor.item_type = '0' and c_sales.manager_flag = '1' and
                c_sales.sale_rank_two is not null) then
            v_rank_code := c_sales.sale_rank_two;
          end if;
          --不符计算条件时跳过
          if (v_toggle) then
            --日志参数
            v_para_sql := '函数:' || v_func_sql || ',共9个参数:' || i_version_id || ',' || i_user_name || ',' || i_task_id || ',' ||
                          c_sales.bng_date || ',' || v_end_date || ',' || c_sales.salesman_code || ',' || i_dept_code || ',' ||
                          v_rank_code || ',' || c_sales.group_code;
            --执行函数
            execute immediate v_func_sql
              using out v_result, i_version_id, i_user_name, i_task_id, trunc(c_sales.bng_date), v_end_date, --
            c_sales.salesman_code, i_dept_code, v_rank_code, --
            case when v_para_set then c_factor.item_code else c_sales.group_code end;
            --写入结果
            insert into t_law_calc_value
              (pk_id,
               dept_code,
               line_code,
               version_id,
               calc_month,
               bng_date,
               end_date,
               sales_code,
               rank_code,
               group_code,
               object_code,
               object_value,
               created_user,
               created_date,
               updated_user,
               updated_date,
               item_type)
            values
              (sys_guid(),
               i_dept_code,
               i_line_code,
               i_version_id,
               i_calc_month,
               trunc(c_sales.bng_date),
               v_end_date,
               c_sales.salesman_code,
               v_rank_code,
               c_sales.group_code,
               c_factor.item_code,
               round(v_result, 4), -- 因素结果
               'admin',
               sysdate,
               'admin',
               sysdate,
               '1');
            --计算过程
            insert into t_law_calc_proce
              (pk_id,
               version_id,
               calc_month,
               dept_code,
               line_code,
               calc_code,
               calc_note,
               calc_cond,
               calc_result,
               valid_ind,
               created_user,
               created_date,
               updated_user,
               updated_date,
               sales_code,
               calc_type,
               calc_desc)
            values
              (sys_guid(),
               i_version_id,
               i_calc_month,
               i_dept_code,
               i_line_code,
               c_factor.item_code, --因素代码
               '---', --计算公式
               '---', --计算条件
               round(v_result, 4), -- 计结果
               '1',
               i_user_name,
               sysdate,
               i_user_name,
               sysdate,
               c_sales.salesman_code,
               '1', -- 因素
               c_factor.item_name);
          end if;
        exception
          when others then
            pkg_law_log.log_error(v_func_name,
                                  i_task_id,
                                  i_user_name,
                                  '计算因素失败', --
                                  sqlerrm || ',' || v_para_sql);
            rollback to sp;
        end;
      end loop;
    end loop;
    commit;
    return 1;
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '计算因素失败', --
                            sqlerrm || ',' || v_para_sql);
      return - 1;
  end f_calc_factor;

  function run(i_dept_code  in char,
               i_line_code  in char,
               i_version_id in char,
               i_calc_month in char,
               i_user_name  in char, --
               i_task_id    in char) return char is
    v_return    integer := 1;
    v_func_name varchar2(128) := 'pkg_law_sum.run';
  begin
    --清除数据
    if v_return = 1 then
      v_return := f_clear_data(i_dept_code,
                               i_line_code,
                               i_version_id,
                               i_calc_month,
                               i_user_name, -- 
                               i_task_id);
    end if;
    --计算因素
    if v_return = 1 then
      v_return := f_calc_factor(i_dept_code,
                                i_line_code,
                                i_version_id,
                                i_calc_month,
                                i_user_name, -- 
                                i_task_id);
    end if;
    return to_char(v_return);
  exception
    when others then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name, --
                            '计算因素出错',
                            sqlerrm);
      return '-1';
  end run;

end pkg_law_sum;
/
