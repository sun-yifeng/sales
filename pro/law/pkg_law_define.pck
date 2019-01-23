create or replace package pkg_law_define is

  -- Author  : ADMINISTRATOR
  -- Created : 2014-10-8 19:39:28
  -- Purpose : 日志输出功能

  procedure insert_sys_log(i_func_name in char,
                           i_task_id   in char,
                           i_user_name in char,
                           i_log_level in char,
                           i_log_msg   in char);

  procedure insert_law_log(i_func_name in char,
                           i_task_id   in char,
                           i_user_name in char,
                           i_log_level in char,
                           i_log_sub   in char,
                           i_log_msg   in char);

  function f_area_flag(i_verson_id  varchar2, --基本法号
                       i_sales_code varchar2) return varchar2;

  --获取基本法配置中“团队经理是否需要按客户经理考核”的标志。返回：0-否；1-是
  function f_get_mgr_cal_by_cus_cfg(i_version_id varchar2 --版本代码
                                    ) return varchar2;

  --检查人员考核是否开启地域标识（0:否；1:是）
  function f_get_is_area_cfg(i_version_id varchar2 --版本代码
                             ) return varchar2;

  --检查是否配置司龄工资（0:否；1:是）
  function f_get_is_working_age_cfg(i_version_id varchar2 --版本代码
                                    ) return varchar2;

  --获取司龄工资计算起期
  function f_get_working_age_begin_cfg(i_version_id varchar2 --版本代码
                                       ) return date;

  --获取试用期员工固定工资系数
  function f_get_temp_emp_salary_rate_cfg(i_version_id varchar2 --版本代码
                                          ) return number;

  --根据销售员编号、部门编号、计算月份，获取基本法版本号
  function f_get_version_id(i_salesman_code varchar2, --销售员编号
                            i_dept_code     varchar2, --部门标号（2位）
                            i_cal_month     varchar --计算月份（yyyymm）
                            ) return varchar2;
  --获取销售总监补贴金额
  function f_get_subsidy_sum_cfg(i_version_id varchar2 --版本代码
                                 ) return number;

end pkg_law_define;
/
create or replace package body pkg_law_define is

  function long_2_varchar(l_high_value in long) return varchar2 as
  begin
    return substr(l_high_value, 1, 4000);
  end;

  --其他功能日志
  procedure insert_sys_log(i_func_name in char,
                           i_task_id   in char,
                           i_user_name in char,
                           i_log_level in char,
                           i_log_msg   in char) is
    v_mod     integer; --取余数
    v_count_1 integer; --分段数
    v_count_2 integer; --计数器
    v_length  integer; --每次截取长度
    v_pos_bng integer; --开始截取位置
    v_pos_eng integer; --结束截取位置
    pragma autonomous_transaction;
  begin
  
    /*
    dbms_output.put_line(i_function_name || ',' || i_task_id || ',' ||
                         i_log_level || ',length:' || length(i_log_msg) || ',' ||
                         i_log_msg || ',' || i_user_name);
    */
  
    v_length  := 2000;
    v_count_1 := trunc(length(i_log_msg) / v_length); --只取整数
    v_count_2 := 0;
    v_mod     := length(i_log_msg) mod v_length;
  
    --如果有余数，则多截取一次
    if (v_mod > 0) then
      v_count_1 := v_count_1 + 1;
    end if;
  
    while v_count_2 < v_count_1 loop
      begin
      
        v_pos_bng := 1 + v_count_2 * v_length;
        v_pos_eng := (v_count_2 + 1) * v_length;
      
        /*
        dbms_output.put_line('v_count1:' || to_char(v_count1) ||
                             ',v_count2:' || to_char(v_count2) || ',开始位置:' ||
                             to_char(v_pos_bng) || ',结束位置:' ||
                             to_char(v_pos_eng));
        
        dbms_output.put_line('日志内容:' ||
                             substr(i_log,
                                    1 + v_count2 * v_length,
                                    (v_count2 + 1) * v_length));
        */
      
        insert into t_sys_log
          (pk_id, func_name, task_id, log_level, log_msg, created_user, created_date)
        values
          (seq_sys_log.nextval,
           upper(substr(i_func_name, 1, 128)),
           substr(i_task_id, 1, 128),
           i_log_level,
           substr(i_log_msg, v_pos_bng, v_pos_eng),
           substr(i_user_name, 1, 128),
           sysdate);
        --
        v_count_2 := v_count_2 + 1;
      exception
        when others then
        
          --dbms_output.put_line('写日志时出错,' || sqlcode || ',' || sqlerrm );
          /*不要删除*/
          begin
            raise_application_error(-20999,
                                    '[' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') || ']' || '(' || sqlcode || ':' ||
                                    sqlerrm || ')');
          end;
        
      end;
    end loop;
    commit;
  end insert_sys_log;

  --根据销售人员代码判断同城异地（0:否；1:是）
  function f_area_flag(i_verson_id  varchar2, --基本法号
                       i_sales_code varchar2) return varchar2 is
    v_area_flag   char(1) := '0';
    v_area_flag_1 char(1) := '0';
    v_area_flag_2 char(1) := '0';
  begin
    --先判断基本法有无配置同城异地
    begin
      select t.is_area into v_area_flag_1 from t_law_define_config t where t.version_id = i_verson_id;
    exception
      when no_data_found then
        return '0';
    end;
    --再判断业务员有无配置同城异地
    begin
      select t.area into v_area_flag_2 from salesman t where t.salesman_code = i_sales_code;
    exception
      when no_data_found then
        return '0';
    end;
    if (v_area_flag_1 = '1' and v_area_flag_2 = '1') then
      v_area_flag := '1';
    end if;
    return v_area_flag;
  end f_area_flag;

  --基本法日志表
  procedure insert_law_log(i_func_name in char,
                           i_task_id   in char,
                           i_user_name in char,
                           i_log_level in char,
                           i_log_sub   in char,
                           i_log_msg   in char) is
    v_count_1 integer; --分段数
    v_count_2 integer; --计数器
    v_count_3 integer; --取余数
    v_length  integer; --每次截取长度
    v_pos_bng integer; --开始截取位置
    v_pos_end integer; --结束截取位置
    pragma autonomous_transaction;
    p_log_msg varchar(4000);
  begin
  
    /*调试用，勿删除
    dbms_output.put_line(i_func_name || ',' || i_log_sub || ',length:' || length(i_log_msg) || ',' || i_log_msg);
    */
    v_length  := 4000;
    v_count_1 := trunc(length(nvl(i_log_msg, 0)) / v_length); --只取整数
    v_count_2 := 0;
    v_count_3 := length(nvl(i_log_msg, 1)) mod v_length;
  
    --如果有余数，则多截取一次
    if (v_count_3 > 0) then
      v_count_1 := v_count_1 + 1;
    end if;
  
    --
    while v_count_2 < v_count_1 loop
      begin
      
        v_pos_bng := 1 + v_count_2 * v_length;
        v_pos_end := (v_count_2 + 1) * v_length;
      
        p_log_msg := substr(i_log_msg, v_pos_bng, v_pos_end);
      
        insert into t_law_log
          (pk_id, func_name, task_id, log_level, log_sub, log_msg, created_user, created_date)
        values
          (sys_guid(),
           upper(substr(i_func_name, 1, 128)),
           substr(i_task_id, 1, 128),
           i_log_level,
           i_log_sub,
           p_log_msg,
           i_user_name,
           systimestamp);
        --
        v_count_2 := v_count_2 + 1;
        commit;
      exception
        when others then
          --dbms_output.put_line('写日志时出错,' || sqlcode || ',' || sqlerrm );
          begin
            rollback;
            raise_application_error(-20999,
                                    '[' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') || ']' || '(' || sqlcode || ':' ||
                                    sqlerrm || ')');
          end;
      end;
    end loop;
    commit;
  end insert_law_log;

  --获取基本法配置中“团队经理是否需要按客户经理考核”的标志。返回：0-否；1-是
  function f_get_mgr_cal_by_cus_cfg(i_version_id varchar2 --版本代码
                                    ) return varchar2 is
    v_is_client_manager_check varchar2(1);
  begin
    select nvl(max(t.is_client_manager_check), 0)
      into v_is_client_manager_check
      from t_law_define_config t
     where t.valid_ind = '1' --有效
       and t.version_id = i_version_id;
  
    return v_is_client_manager_check;
  end f_get_mgr_cal_by_cus_cfg;

  --是否开启地域标识（0:否；1:是）
  function f_get_is_area_cfg(i_version_id varchar2 --版本代码
                             ) return varchar2 is
    v_is_area varchar2(1);
  begin
    select nvl(max(t.is_area), 0)
      into v_is_area
      from t_law_define_config t
     where t.valid_ind = '1' --有效
       and t.version_id = i_version_id;
  
    return v_is_area;
  end f_get_is_area_cfg;

  --是否配置司龄工资（0:否；1:是）
  function f_get_is_working_age_cfg(i_version_id varchar2 --版本代码
                                    ) return varchar2 is
    v_is_working_age varchar2(1);
  begin
    select nvl(max(t.is_working_age), 0)
      into v_is_working_age
      from t_law_define_config t
     where t.valid_ind = '1' --有效
       and t.version_id = i_version_id;
  
    return v_is_working_age;
  end f_get_is_working_age_cfg;

  --获取司龄工资计算起期
  function f_get_working_age_begin_cfg(i_version_id varchar2 --版本代码
                                       ) return date is
    v_working_age_begin date;
  begin
    select max(t.working_age_begin)
      into v_working_age_begin
      from t_law_define_config t
     where t.valid_ind = '1' --有效
       and t.version_id = i_version_id;
  
    return v_working_age_begin;
  end f_get_working_age_begin_cfg;

  --获取试用期员工固定工资系数
  function f_get_temp_emp_salary_rate_cfg(i_version_id varchar2 --版本代码
                                          ) return number is
    v_temp_emp_salary_rate number;
  begin
    select nvl(max(t.temp_emp_salary_rate), 0)
      into v_temp_emp_salary_rate
      from t_law_define_config t
     where t.valid_ind = '1' --有效
       and t.version_id = i_version_id;
  
    return v_temp_emp_salary_rate;
  end f_get_temp_emp_salary_rate_cfg;

  --根据销售员编号、部门编号、计算月份，获取基本法版本号
  function f_get_version_id(i_salesman_code varchar2, --销售员编号
                            i_dept_code     varchar2, --部门标号（2位）
                            i_cal_month     varchar --计算月份（yyyymm）
                            ) return varchar2 is
    v_version_id varchar(50);
  begin
    select max(s.version_id)
      into v_version_id
      from t_law_salesman s
     where s.salesman_code = i_salesman_code
       and s.dept_code = i_dept_code
       and s.calc_month = i_cal_month;
  
    return v_version_id;
  end f_get_version_id;

  --获取销售总监补贴金额
  function f_get_subsidy_sum_cfg(i_version_id varchar2 --版本代码
                                 ) return number is
    v_subsidy_sum number;
  begin
    select nvl(max(t.subsidy_sum), 0)
      into v_subsidy_sum
      from t_law_define_config t
     where t.valid_ind = '1' --有效
       and t.version_id = i_version_id;
  
    return v_subsidy_sum;
  end f_get_subsidy_sum_cfg;

end pkg_law_define;
/
