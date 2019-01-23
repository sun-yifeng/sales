create or replace package pkg_law_check is

  function f_exist_func(p_func_name in char,
                        p_user_name in char, --
                        p_ms_id     in integer) return integer;
  /*
  function f_exist_factor(i_factor_code in char,
                          i_dept_code   in char,
                          i_line_code   in char,
                          i_user_name   in char,
                          i_task_id     in integer) return integer;
  
  function f_exist_index(i_index_code in char,
                         i_dept_code  in char,
                         i_line_code  in char,
                         i_user_name  in char,
                         i_task_id    in integer) return integer;
  
  function f_check_index(i_index_formula in char,
                         i_dept_code     in char,
                         i_line_code     in char,
                         i_user_name     in char,
                         i_task_id       in integer) return integer;
  
  function f_check_cond(p_index_code in char,
                        p_index_cond in char,
                        p_version_id in char,
                        i_user_name  in char,
                        i_task_id    in integer) return integer;
  
  function f_check_rank(i_rank_code  in char, --职级代码
                        i_rank_cond  in char, --计算条件，[80,90)|[6000000,+∞)
                        i_version_id in char,
                        i_task_name  in char,
                        i_task_id    in integer) return integer;
  */

  --根据职级代码判断是否为团队经理,0-客户经理，1-团队经理，2-其他
  function f_check_leader(i_rank_code in char) return char;

  --基本法是否配置团队经理按客户经理考核
  function f_mgr_cfg(i_version_id varchar2,
                     i_user_name  in varchar2,
                     i_task_id    in varchar2 --
                     ) return char;

  --判断是否团队经理按客户经理考核。返回：0-否；1-是
  function f_check_mgr_cal_by_cus(i_is_client_manager_check varchar2, --团队经理是否需要按客户经理考核
                                  i_manager_flag            varchar2, --职级类型
                                  i_rank_code               varchar2, --职级
                                  i_sale_rank_two           varchar2 --允许团队长按客户经理考核的职级
                                  ) return varchar2;

  --判断是否团队经理按客户经理考核。返回：0-否；1-是
  function f_mgr_cus(i_manager_flag in varchar2,
                     i_sales_code   in varchar2,
                     i_rank_code    in varchar2,
                     i_rank_two     in varchar2,
                     i_user_name    in varchar2,
                     i_task_id      in varchar2 --
                     ) return char;

  --检查基本法必填的配置项是否已配置。-1：未配置；1：已配置
  function f_check_law_define_cfg(i_version_id varchar2 --版本代码
                                  ) return varchar2;

end pkg_law_check;
/
create or replace package body pkg_law_check is

  -- 函数是否创建is_func_exist
  function f_exist_func(p_func_name in char, p_user_name in char, p_ms_id in integer) return integer is
    sp_methodname varchar2(100);
    sp_status     varchar2(16);
  begin
    sp_methodname := 'pkg_law_check.f_exist_func';
    begin
      select status
        into sp_status
        from user_objects -- user_objects
       where object_type = upper('FUNCTION')
         and object_name = upper(p_func_name);
    exception
      when no_data_found then
        return 0;
      when others then
        pkg_law_log.log_error(sp_methodname, p_ms_id, p_user_name, '检查因素失败，校验计算函数失败', '');
    end;
    --
    if sp_status = upper('INVALID') then
      pkg_law_log.log_error(sp_methodname,
                            p_ms_id,
                            p_user_name,
                            '检查因素失败，函数' || upper(p_func_name) || '失效',
                            '');
    end if;
    return 1;
  end f_exist_func;

  -- 因子是否存在
  function f_exist_factor(i_factor_code in char,
                          i_dept_code   in char,
                          i_line_code   in char,
                          i_user_name   in char,
                          i_task_id     in integer,
                          i_version_id  in char) return integer is
    sp_methodname varchar2(100);
    sp_cnt        integer;
  begin
    sp_methodname := 'pkg_law_check.f_exist_factor';
    select count(0)
      into sp_cnt
      from t_law_factor_sys
     where 1 = 1
       and item_code = i_factor_code
       and version_id = i_version_id;
    --
    if sp_cnt > 1 then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            upper('表t_factor_def有重复因素:') || i_factor_code || ',dept_code:' || i_dept_code ||
                            ',line_code:' || i_line_code,
                            '');
    elsif sp_cnt < 1 then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            upper('表t_factor_def未配置因素:') || i_factor_code || ',dept_code:' || i_dept_code ||
                            ',line_code:' || i_line_code,
                            '');
    end if;
    return(case when sp_cnt <> 1 then 0 else 1 end);
  end f_exist_factor;

  -- 检查指标
  /*
  function f_exist_index(i_index_code in char,
                         i_dept_code  in char,
                         i_line_code  in char,
                         i_user_name  in char,
                         i_task_id    in integer) return integer is
    sp_methodname varchar2(100);
    sp_cnt        integer;
  begin
    sp_methodname := 'pkg_law_check.f_exist_index';
  
    --指标跟版本无关
    select count(0)
      into sp_cnt
      from t_index_def
     where 1 = 1
       and index_code = i_index_code
       and dept_code = i_dept_code --
       and line_code = i_line_code --
    ;
    --
    if sp_cnt > 1 then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            upper('表t_index_def有重复公式:') || i_index_code || ',dept_code:' || i_dept_code ||
                            ',line_code:' || i_line_code,
                            '');
    elsif sp_cnt < 1 then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            upper('表t_index_def未配置公式:') || i_index_code || ',dept_code:' || i_dept_code ||
                            ',line_code:' || i_line_code,
                            '');
    end if;
    return(case when sp_cnt <> 1 then 0 else 1 end);
  end f_exist_index;
  
  --检查指标的公式
  function f_check_index(i_index_formula in char,
                         i_dept_code     in char,
                         i_line_code     in char,
                         i_user_name     in char,
                         i_task_id       in integer) return integer is
    sp_methodname   varchar2(100);
    sp_index_result varchar2(256);
    sp_arr          pkg_law_func.ty_array;
    v_arr_index     integer;
    v_arr_value     varchar2(100);
  begin
    sp_methodname := 'pkg_law_check.f_check_index';
    pkg_law_log.log_debug(sp_methodname,
                          i_task_id,
                          i_user_name,
                          '检查计算公式' || i_index_formula || ',部门代码' || i_dept_code || ',业务线' || i_line_code,
                          '');
  
    --去掉加减乘除
    sp_index_result := replace(i_index_formula, '+', '|');
    sp_index_result := replace(sp_index_result, '-', '|');
    sp_index_result := replace(sp_index_result, '*', '|');
    sp_index_result := replace(sp_index_result, '/', '|');
    --去掉左右括号
    sp_index_result := replace(sp_index_result, '(', '|');
    sp_index_result := replace(sp_index_result, ')', '|');
    --转换成为数组
    sp_arr      := pkg_law_func.split(sp_index_result, '|');
    v_arr_index := 1;
    v_arr_value := '';
    --检查数组元素
    while v_arr_index <= sp_arr.count loop
      v_arr_value := sp_arr(v_arr_index);
      if v_arr_value is not null and upper(v_arr_value) <> lower(v_arr_value) then
        if (upper(substr(v_arr_value, 1, 2)) = pkg_law_cons.c_prefix_f) then
          return f_exist_factor(v_arr_value, i_dept_code, i_line_code, i_user_name, i_task_id);
        elsif (upper(substr(v_arr_value, 1, 2)) = pkg_law_cons.c_prefix_w) or
              (upper(substr(v_arr_value, 1, 2)) = pkg_law_cons.c_prefix_r) then
          return f_exist_index(v_arr_value, i_dept_code, i_line_code, i_user_name, i_task_id);
        end if;
      end if;
      v_arr_index := v_arr_index + 1;
    end loop;
    return 1;
  end f_check_index;
  
  --检查指标的公式条件是否正确
  function f_check_cond(p_index_code in char,
                        p_index_cond in char,
                        p_version_id in char,
                        i_user_name  in char,
                        i_task_id    in integer) return integer is
    sp_methodname varchar2(100);
    v_arr         pkg_law_func.ty_array;
    v_cnt         integer;
    v_len         integer;
  begin
    sp_methodname := 'pkg_law_check.f_check_cond';
  
    --1.是否有中文
    if instr('，', p_index_cond) > 0 or instr('（', p_index_cond) > 0 or instr('）', p_index_cond) > 0 then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            '公式' || p_index_code || '的条件' || p_index_cond || '有中文逗号或括号',
                            '');
      return - 1;
    end if;
  
    --公式计算条件（数组）
    v_arr := pkg_law_func.split(p_index_cond, '|');
  
    --指标对应的因素个数
    select count(0)
      into v_cnt
      from t_index_factor t
     where t.version_id = p_version_id
       and t.index_code = p_index_code;
  
    --2.因素关系与条件个数是否相等
    if v_cnt <> v_arr.count then
      pkg_law_log.log_error(sp_methodname,
                            i_task_id,
                            i_user_name,
                            '公式' || p_index_code || '在表t_index_factor的配置数' || to_char(v_cnt) || '与条件' || p_index_cond || '个数' ||
                            to_char(v_arr.count) || '不等',
                            '');
      return - 2;
    end if;
  
    v_len := 0;
    --3.检查计算条件
    for rec in (select t.*
                  from t_index_factor t
                 where t.version_id = p_version_id
                   and t.index_code = p_index_code
                 order by t.order_no) loop
      v_len := v_len + 1;
      -- 计算条件是否错误
      if pkg_law_func.f_calc_cond('field_test', v_arr(v_len), rec.exhibit_type) is null then
        pkg_law_log.log_error(sp_methodname,
                              i_task_id,
                              i_user_name,
                              '公式' || p_index_code || '的计算条件' || p_index_cond || '配置错误:' || v_arr(v_len),
                              '');
        return - 3;
      end if;
    end loop;
    return 1;
  end f_check_cond;
  
  --功能：检查职级的计算公式
  --参数：i_rank_code 职级代码
  --      i_rank_cond 职级计算条件，如[80,90)|[6000000,+∞)
  function f_check_rank(i_rank_code  in char, --职级代码
                        i_rank_cond  in char, --计算条件，[80,90)|[6000000,+∞)
                        i_version_id in char,
                        i_task_name  in char,
                        i_task_id    in integer) return integer is
    v_methodname varchar2(128);
    v_arr        pkg_law_func.ty_array;
    sp_cnt       integer;
    sp_index     integer;
  begin
    v_methodname := 'pkg_law_check.f_check_rank';
  
    --1.检查公式配置中是否有中文的逗号、左右括号
    if instr('，', i_rank_cond) > 0 or instr('（', i_rank_cond) > 0 or instr('）', i_rank_cond) > 0 then
      return - 1;
    end if;
    --职级计算公式（数组）
    v_arr := pkg_law_func.split(i_rank_cond, '|');
    select count(0)
      into sp_cnt
      from t_rank_factor t --职级考核评分指标表
     where 1 = 1
       and t.version_id = '1'
          --and t.version_id = p_version_id
       and t.rank_code = i_rank_code;
    --2.检查职级计算公式中的参数和职级因素关系表中的参数是否相等
    if sp_cnt <> v_arr.count then
      return - 2;
    end if;
  
    sp_index := 0;
    --3.检查职级计算公式
    for rec in (select t.*
                  from t_rank_factor t
                 where 1 = 1
                   and t.version_id = '1'
                      --and t.version_id = p_version_id
                   and t.rank_code = i_rank_code
                 order by t.order_no) loop
      sp_index := sp_index + 1;
      -- 检查职级计算条件是否错误
      if pkg_law_func.f_calc_cond('field_test', v_arr(sp_index), rec.exhibit_type) is null then
        pkg_law_log.log_error(v_methodname,
                              i_task_id,
                              i_task_name,
                              '基本法' || i_version_id || '职级' || i_rank_code || '的计算条件' || i_rank_cond || '配置错误:' ||
                              v_arr(sp_index),
                              '');
        return - 3;
      end if;
    end loop;
    return 1;
  end f_check_rank;
  */

  --根据职级代码判断是否为团队经理,0-客户经理，1-团队经理，2-其他
  function f_check_leader(i_rank_code in char) return char is
    v_manager_flag varchar2(50) := '-1';
  begin
    select max(t.manager_flag)
      into v_manager_flag
      from t_law_rank_def t
     where t.valid_ind = '1'
       and t.rank_code = i_rank_code;
    --
    return v_manager_flag;
  end f_check_leader;

  --基本法是否配置团队经理按客户经理考核
  function f_mgr_cfg(i_version_id varchar2,
                     i_user_name  in varchar2,
                     i_task_id    in varchar2 --
                     ) return char is
    v_return_flag char(1);
    v_func_name   varchar(30) := 'pkg_law_check.f_mgr_cfg';
  begin
    --取基本法里面的团队经理按客户经理考核开关
    select t.is_client_manager_check
      into v_return_flag
      from t_law_define_config t
     where t.valid_ind = '1'
       and t.version_id = i_version_id;
    --返回boolean结果
    return '1';
  exception
    when no_data_found then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '基本法配置项团队经理是否按客户经理考核出错,基本法ID:' || i_version_id,
                            sqlerrm);
      return '-1';
  end f_mgr_cfg;

  --判断是否团队经理按客户经理考核。返回：0-否；1-是
  function f_mgr_cus(i_manager_flag in varchar2,
                     i_sales_code   in varchar2,
                     i_rank_code    in varchar2,
                     i_rank_two     in varchar2,
                     i_user_name    in varchar2,
                     i_task_id      in varchar2 --
                     ) return char is
    v_return char(2) := '-1';
  begin
    --非团队经理并且无两个职级的
    if (i_manager_flag <> '1' or i_rank_two is null or i_sales_code = i_rank_two) then
      v_return := 1;
    end if;
    return v_return;
  end f_mgr_cus;

  --判断是否团队经理按客户经理考核。返回：0-否；1-是
  function f_check_mgr_cal_by_cus(i_is_client_manager_check varchar2, --团队经理是否需要按客户经理考核
                                  i_manager_flag            varchar2, --职级类型
                                  i_rank_code               varchar2, --职级
                                  i_sale_rank_two           varchar2 --允许团队长按客户经理考核的职级
                                  ) return varchar2 is
    v_return_flag varchar2(1) := '0';
  begin
    --如果是客户经理因素，且允许团队经理按客户经理考核，且人员是团队经理，且SALE_RANK_TWO不为空
    if (i_is_client_manager_check = '1' and i_manager_flag = '1' and i_sale_rank_two is not null and
       i_sale_rank_two <> i_rank_code) then
      v_return_flag := '1';
    end if;
    return v_return_flag;
  end f_check_mgr_cal_by_cus;

  --检查基本法必填的配置项是否已配置。-1：未配置；1：已配置
  function f_check_law_define_cfg(i_version_id varchar2 --版本代码
                                  ) return varchar2 is
    v_count number := 0;
  begin
    select count(1)
      into v_count
      from t_law_define_config t
     where t.valid_ind = '1' --有效
       and t.version_id = i_version_id;
    if v_count = 0 then
      return '-1';
    else
      return '1';
    end if;
  end f_check_law_define_cfg;

end pkg_law_check;
/
