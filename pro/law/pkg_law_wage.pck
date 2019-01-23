create or replace package pkg_law_wage is

  -- author  : sunyf
  -- created : 2014-9-01 16:01:04
  -- purpose : 计算基本法的指标

  function f_clean_data(i_calc_month in char,
                        i_dept_code  in char,
                        i_line_code  in char,
                        i_user_name  in char,
                        i_task_id    in char,
                        i_version_id in char) return char;

  function f_move_data(i_calc_month in char,
                       i_dept_code  in char,
                       i_line_code  in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_version_id in char) return char;

  function f_calc_wage(i_calc_month in char,
                       i_dept_code  in char,
                       i_line_code  in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_version_id in char) return char;

  --计算指标
  function run(i_dept_code  in varchar2,
               i_line_code  in varchar2,
               i_version_id in varchar2,
               i_calc_month in varchar2,
               i_user_name  in varchar2, --
               i_task_id    in varchar2) return char;

end pkg_law_wage;
/
create or replace package body pkg_law_wage is

  -- author  : sunyf
  -- created : 2014-9-01 16:01:04
  -- purpose : 计算基本法的指标（包括计算薪酬）

  --清除结果集和中间表
  function f_clean_data(i_calc_month in char,
                        i_dept_code  in char,
                        i_line_code  in char,
                        i_user_name  in char,
                        i_task_id    in char,
                        i_version_id in char) return char is
    pragma autonomous_transaction;
  begin
    --清除结果集
    delete from t_law_calc_value t
     where t.calc_month = i_calc_month
       and t.version_id = i_version_id
       and t.item_type = '2';
    --清除跟踪表
    delete from t_law_calc_proce t
     where t.version_id = i_version_id
       and t.calc_month = i_calc_month
       and t.calc_type = '2';
    --清除结果集
    delete from t_law_calc_extra t
     where t.calc_month = i_calc_month
       and t.version_id = i_version_id;
    commit;
    return '1';
  end f_clean_data;

  -- 将因素结果搬到扩展表
  function f_move_data(i_calc_month in char,
                       i_dept_code  in char,
                       i_line_code  in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_version_id in char) return char is
  
    v_sql_str1  varchar2(30000);
    v_sql_str2  varchar2(30000);
    v_sql_str3  varchar2(30000);
    v_func_name varchar2(100) := 'pkg_law_wage.f_move_calc';
    pragma autonomous_transaction;
  begin
    v_sql_str1 := 'insert into t_law_calc_extra(dept_code,line_code,version_id,calc_month,sales_code,group_code';
    v_sql_str2 := ')(select dept_code,line_code,version_id,calc_month,sales_code,group_code ';
    --1.循环因素
    for rec in (select distinct t.item_code
                  from t_law_factor_sys t
                 where t.valid_ind = '1'
                   and t.item_status = '1'
                   and t.version_id = i_version_id
                union
                select distinct t.item_code
                  from t_law_factor_imp t
                 where t.valid_ind = '1'
                   and t.item_status = '1'
                   and t.version_id = i_version_id
                union
                select distinct t.item_code
                  from t_law_factor_exa t
                 where t.valid_ind = '1'
                   and t.item_status = '1'
                   and t.version_id = i_version_id) loop
      v_sql_str1 := v_sql_str1 || ',' || rec.item_code; --因素代码
      v_sql_str2 := v_sql_str2 || ',' || 'round(max(case when object_code = ''' || rec.item_code ||
                    ''' then object_value else 0 end),4) as ' || rec.item_code;
    end loop;
  
    --计算公式
    v_sql_str3 := v_sql_str1 || v_sql_str2 || ' from t_law_calc_value where calc_month = ''' || i_calc_month ||
                  ''' and sales_code in (select salesman_code from t_law_salesman t where t.dept_code = ''' ||
                  i_dept_code || ''' and t.calc_month = ''' || i_calc_month || ''' and t.line_code = ''' || i_line_code ||
                  ''' ) group by calc_month, line_code, version_id, sales_code, group_code, dept_code)';
  
    --写入日志
    pkg_law_log.log_info(v_func_name, i_task_id, i_user_name, '因素结果搬到扩展表', v_sql_str3);
    execute immediate v_sql_str3;
    commit;
    return '1';
  exception
    when others then
      pkg_law_log.log_error(v_func_name, i_task_id, i_user_name, '因素搬到扩展表时出错' || sqlerrm, v_sql_str3);
      rollback;
      return '-1';
  end f_move_data;

  --计算指标，先算客户经理的指标，因为团队经理会用到客户经理指标
  function f_calc_wage(i_calc_month in char,
                       i_dept_code  in char,
                       i_line_code  in char,
                       i_user_name  in char,
                       i_task_id    in char,
                       i_version_id in char) return char is
  
    v_sql_1   varchar2(2048); --批量计算语句
    v_sql_2   varchar2(1024); --记录过程语句
    v_law_cfg char(1) := '1'; --基本法配置项
    v_toggle  boolean := false; --逻辑切换控制
    pragma autonomous_transaction;
    v_func_name  varchar2(100) := 'pkg_law_wage.f_index_calc';
    v_val_result varchar2(1000);
    v_decimal_digit number;
  begin
    --取基本法配置所有的因素，计算指标，对计算公式和计算条件进行验证
    v_val_result := pkg_law_validate.f_main(i_version_id);
    if (v_val_result is not null) then
      pkg_law_log.log_error(v_func_name,
                            i_task_id,
                            i_user_name,
                            '基本法没有配置下面的因素或者指标：' || v_val_result,
                            v_val_result);
    end if;
    --取基本法配置
    select nvl(t.is_client_manager_check, '0')
      into v_law_cfg
      from t_law_define_config t
     where t.version_id = i_version_id;
    --取计算的公式
    for c_rule in (select t.index_code, t.index_name, t.ret, t.index_cond, t.item_type, t.order_no
                     from t_law_calc t --指标公式
                    where 1 = 1
                      and t.valid_ind = '1'
                      and t.item_status = '1'
                      and t.version_id = i_version_id
                    order by t.item_type, t.order_no, t.index_code) loop
      --遍历所有的销售人员
      for c_sale in (select t.salesman_code, t.manager_flag, t.sale_rank_two
                       from t_law_salesman t
                      where 1 = 1
                        and t.dept_code = i_dept_code
                        and t.line_code = i_line_code
                        and t.version_id = i_version_id
                        and t.calc_month = i_calc_month
                      order by t.manager_flag) loop
        --是否需要执行公式      
        if ((c_sale.manager_flag = c_rule.item_type) or (v_law_cfg = '1' and c_rule.item_type = '0' and
           c_sale.manager_flag = '1' and c_sale.sale_rank_two is not null)) then
          v_toggle := true;
        else
          v_toggle := false;
        end if;
        --不符计算条件时跳过
        if (v_toggle) then
          --批量计算拼装语句片段
          select t.decimal_digit into v_decimal_digit from t_law_rule t where t.item_code = c_rule.index_code and t.valid_ind = '1';
          v_sql_1 := 'update t_law_calc_extra set ' || c_rule.index_code || '= round(' || nvl(c_rule.ret, 0) || ','|| v_decimal_digit ||')' ||
                     ' where calc_month = ''' || i_calc_month || ''' and version_id = ''' || i_version_id || ''' and (' ||
                     nvl(trim(replace(replace(c_rule.index_cond, '---', ''), '--', '')), '1=1') ||
                     ') and sales_code = ''' || c_sale.salesman_code || '''';
          --插入计算过程的语句，需要添加排序字段，需要用括号把计算条件包住，因为计算条件中包含有or的。
          v_sql_2 := 'insert into t_law_calc_proce select sys_guid(),''' || i_version_id || ''',''' || i_calc_month ||
                     ''',''' || i_dept_code || ''',''' || i_line_code || ''',''' || c_rule.index_code || ''',''' ||
                     c_rule.ret || ''',''' || nvl(trim(c_rule.index_cond), '---') || ''',round(' || c_rule.index_code ||
                     ','|| v_decimal_digit ||'),1,''' || i_user_name || ''',sysdate,''' || i_user_name || ''',sysdate,sales_code,' ||
                     '''2'',''' || c_rule.index_name || ''',''' || c_rule.order_no ||
                     ''',null from t_law_calc_extra where ' || c_rule.index_code || ' is not null and calc_month = ''' ||
                     i_calc_month || ''' and version_id = ''' || i_version_id || ''' and (' ||
                     nvl(trim(replace(replace(c_rule.index_cond, '---', ''), '--', '')), '1=1') ||
                     ') and sales_code = ''' || c_sale.salesman_code || '''';
          --插入日志信息
          pkg_law_log.log_info(v_func_name,
                               i_task_id,
                               i_user_name,
                               '执行计算公式',
                               '销售人员:' || c_sale.salesman_code || ',计算月份:' || i_calc_month || ',计算公式:' ||
                               c_rule.index_code || ',计算条件:' || c_rule.index_cond || '执行语句:' || v_sql_1 || ',插入计算过程:' ||
                               v_sql_2);
        
          --执行计算公式
          begin
            execute immediate v_sql_1;
            commit;
          exception
            when others then
              pkg_law_log.log_error(v_func_name,
                                    i_task_id,
                                    i_user_name,
                                    '执行公式出错,销售人员:' || c_sale.salesman_code || ',计算月份:' || i_calc_month || ',计算公式:' ||
                                    c_rule.index_code || ',计算条件:' || c_rule.index_cond || sqlerrm,
                                    v_sql_1);
          end;
          --插入计算过程
          begin
            execute immediate v_sql_2;
            commit;
          exception
            when others then
              pkg_law_log.log_error(v_func_name,
                                    i_task_id,
                                    i_user_name,
                                    '记录过程出错,销售人员:' || c_sale.salesman_code || ',计算月份:' || i_calc_month || ',计算公式:' ||
                                    c_rule.index_code || ',计算条件:' || c_rule.index_cond || sqlerrm,
                                    v_sql_2);
          end;
        end if;
      end loop;
    end loop;
    return '1';
  end f_calc_wage;

  --程序入口
  function run(i_dept_code  in varchar2,
               i_line_code  in varchar2,
               i_version_id in varchar2,
               i_calc_month in varchar2,
               i_user_name  in varchar2, --
               i_task_id    in varchar2) return char is
    v_return    char;
    v_func_name varchar2(128) := 'pkg_law_wage.run';
  begin
    --清除数据
    v_return := f_clean_data(i_calc_month,
                             i_dept_code,
                             i_line_code,
                             i_user_name,
                             i_task_id, --
                             i_version_id);
    --写中间表
    if v_return = '1' then
      v_return := f_move_data(i_calc_month,
                              i_dept_code,
                              i_line_code,
                              i_user_name,
                              i_task_id, --
                              i_version_id);
    end if;
    --计算指标
    if v_return = '1' then
      v_return := f_calc_wage(i_calc_month,
                              i_dept_code,
                              i_line_code,
                              i_user_name,
                              i_task_id, --
                              i_version_id);
    end if;
    return v_return;
  exception
    when others then
      v_return := pkg_law_func.unlock_person(i_calc_month,
                                             i_dept_code,
                                             i_line_code,
                                             i_user_name,
                                             i_task_id,
                                             i_version_id);
      pkg_law_log.log_info(v_func_name, i_task_id, i_user_name, '计算公式出错', sqlerrm);
      --raise_application_error(-20001, sqlerrm);
      return '-1';
  end run;

end pkg_law_wage;
/
